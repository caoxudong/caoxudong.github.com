---
title:      java线程重复执行start方法的问题
category:   blog
layout:     post
tags:       [java]
---

java线程重复执行start方法的问题
=================


先看代码

    package test.java.lang.thread;
    
    public class TestThread {
    
        public static void main(String[] args) throws InterruptedException {
            Thread t = new Thread();
            t.start();
            t.start();
        }
    
    }
    

上面的代码在运行时，会抛出以下异常，

    Exception in thread "main" java.lang.IllegalThreadStateException
    at java.lang.Thread.start(Thread.java:682)
    at test.java.lang.thread.TestThread.main(TestThread.java:8)
    

原因在于，在start方法中，会对线程是否重复启动做检查：

    if (threadStatus != 0)
            throw new IllegalThreadStateException();
    

其中，属性`threadStatus`的定义如下：

    private volatile int threadStatus = 0;
    

该属性由在线程启动后，由本地方法修改：线程在执行start方法时，会调用本地方法start0来完成线程的创建。start0方法的[具体实现][1]是：

    JVM_ENTRY(void, JVM_StartThread(JNIEnv* env, jobject jthread))
        JVMWrapper("JVM_StartThread");
        JavaThread *native_thread = NULL;
    
        // We cannot hold the Threads_lock when we throw an exception,
        // due to rank ordering issues. Example:  we might need to grab the
        // Heap_lock while we construct the exception.
        bool throw_illegal_thread_state = false;
    
        // We must release the Threads_lock before we can post a jvmti event
        // in Thread::start.
        {
            // Ensure that the C++ Thread and OSThread structures aren't freed before
            // we operate.
            MutexLocker mu(Threads_lock);
    
            // Since JDK 5 the java.lang.Thread threadStatus is used to prevent
            // re-starting an already started thread, so we should usually find
            // that the JavaThread is null. However for a JNI attached thread
            // there is a small window between the Thread object being created
            // (with its JavaThread set) and the update to its threadStatus, so we
            // have to check for this
            if (java_lang_Thread::thread(JNIHandles::resolve_non_null(jthread)) != NULL) {
                throw_illegal_thread_state = true;
            } else {
                // We could also check the stillborn flag to see if this thread was already stopped, but
                // for historical reasons we let the thread detect that itself when it starts running
    
                jlong size = java_lang_Thread::stackSize(JNIHandles::resolve_non_null(jthread));
                // Allocate the C++ Thread structure and create the native thread.  The
                // stack size retrieved from java is signed, but the constructor takes
                // size_t (an unsigned type), so avoid passing negative values which would
                // result in really large stacks.
                size_t sz = size > 0 ? (size_t) size : 0;
                native_thread = new JavaThread(&thread_entry, sz);
    
                // At this point it may be possible that no osthread was created for the
                // JavaThread due to lack of memory. Check for this situation and throw
                // an exception if necessary. Eventually we may want to change this so
                // that we only grab the lock if the thread was created successfully -
                // then we can also do this check and throw the exception in the
                // JavaThread constructor.
                if (native_thread->osthread() != NULL) {
                    // Note: the current thread is not being used within "prepare".
                    native_thread->prepare(jthread);
                }
            }
        }
    
        if (throw_illegal_thread_state) {
            THROW(vmSymbols::java_lang_IllegalThreadStateException());
        }
    
        assert(native_thread != NULL, "Starting null thread?");
    
        if (native_thread->osthread() == NULL) {
            // No one should hold a reference to the 'native_thread'.
            delete native_thread;
            if (JvmtiExport::should_post_resource_exhausted()) {
                JvmtiExport::post_resource_exhausted(
                    JVMTI_RESOURCE_EXHAUSTED_OOM_ERROR | JVMTI_RESOURCE_EXHAUSTED_THREADS,
                    "unable to create new native thread");
            }
            THROW_MSG(vmSymbols::java_lang_OutOfMemoryError(),
                "unable to create new native thread");
        }
    
        Thread::start(native_thread);
    
    JVM_END
    

其中的注释说道，自jdk5之后，在Thread类中增加了一个`threadStatus`属性，以此来防止线程被重复启动。

其中`Thread::start(Thread* thread)`方法的[实现][2]如下，

    void Thread::start(Thread* thread) {
        trace("start", thread);
        // Start is different from resume in that its safety is guaranteed by context or
        // being called from a Java method synchronized on the Thread object.
        if (!DisableStartThread) {
            if (thread->is_Java_thread()) {
                // Initialize the thread state to RUNNABLE before starting this thread.
                // Can not set it after the thread started because we do not know the
                // exact thread state at that time. It could be in MONITOR_WAIT or
                // in SLEEPING or some other state.
                java_lang_Thread::set_thread_status(((JavaThread*)thread)->threadObj(),
                                          java_lang_Thread::RUNNABLE);
            }
            os::start_thread(thread);
        }
    }
    

这里对threadStatus属性做了修改，保证线程不会被重复启动。

[1]:    http://hg.openjdk.java.net/jdk7u/jdk7u/hotspot/file/ae4adc1492d1/src/share/vm/prims/jvm.cpp
[2]:    http://hg.openjdk.java.net/jdk7u/jdk7u/hotspot/file/ae4adc1492d1/src/share/vm/runtime/thread.cpp

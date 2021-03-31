---
title:      jvm中对线程栈最小值的限制
layout:     post
category:   blog
tags:       [java]
---

今天在重启线上服务的时候，将线程栈从256KB减小为128KB，jvm启动失败，错误信息为

>The stack size specified is too small, Specify at least 228k

这个错误是jvm本身报的，它对线程栈的大小做了最小值的限制。报错位置如下

[os_linux.cpp][1]

    ```c++
    // Check minimum allowable stack size for thread creation and to initialize
    // the java system classes, including StackOverflowError - depends on page
    // size.  Add a page for compiler2 recursion in main thread.
    // Add in 2*BytesPerWord times page size to account for VM stack during
    // class initialization depending on 32 or 64 bit VM.
    os::Linux::min_stack_allowed = MAX2(os::Linux::min_stack_allowed,
                (size_t)(StackYellowPages+StackRedPages+StackShadowPages) * Linux::page_size() +
                        (2*BytesPerWord COMPILER2_PRESENT(+1)) * Linux::vm_default_page_size());

    size_t threadStackSizeInBytes = ThreadStackSize * K;
    if (threadStackSizeInBytes != 0 &&
        threadStackSizeInBytes < os::Linux::min_stack_allowed) {
            tty->print_cr("\nThe stack size specified is too small, "
                        "Specify at least %dk",
                        os::Linux::min_stack_allowed/ K);
            return JNI_ERR;
    }
    ```

这里首先计算了变量`threadStackSizeInBytes`的值，然后与`os::Linux::min_stack_allowed`的值进行比较，若小于`os::Linux::min_stack_allowed`的值，则会在标准错误中打印错误信息"The stack size specified is too small, Specify at least XXk"，并返回错误，标识启动失败。

计算方法为:

    os::Linux::min_stack_allowed = max(
        os::Linux::min_stack_allowed, 
        (2 + 1 + 20) * 4K + (2 * 8 + 1) * 8K
    ) = 228K

其中，`StackYellowPages` `StackRegPages` `StackSahdowPages`3个值是虚拟机参数，定义如下

[globals.hpp][7]

    ```c++
    /* stack parameters */                                                    \
    product_pd(intx, StackYellowPages,                                        \
            "Number of yellow zone (recoverable overflows) pages")            \
                                                                              \
    product_pd(intx, StackRedPages,                                           \
            "Number of red zone (unrecoverable overflows) pages")             \
                                                                              \
    product_pd(intx, StackShadowPages,                                        \
            "Number of shadow zone (for overflow checking) pages "            \
            "this should exceed the depth of the VM and native call stack") 
    ```

[globals_x86.hpp][8]

    ```c++
    define_pd_global(intx, StackYellowPages, NOT_WINDOWS(2) WINDOWS_ONLY(3));
    define_pd_global(intx, StackRedPages, 1);
    #ifdef AMD64
    // Very large C++ stack frames using solaris-amd64 optimized builds
    // due to lack of optimization caused by C++ compiler bugs
    define_pd_global(intx, StackShadowPages, NOT_WIN64(20) WIN64_ONLY(6) DEBUG_ONLY(+2));
    #else
    define_pd_global(intx, StackShadowPages, 4 DEBUG_ONLY(+5));
    #endif // AMD64
    ```

HotSpot启动的时候，若发现当前系统使用了大内存页，则会调整`StackYellowPages` `StackRedPages`和`StackShadowPages`的大小，如下所示：

[os_linux.cpp][9]

    ```c++
    // If the pagesize of the VM is greater than 8K determine the appropriate
    // number of initial guard pages.  The user can change this with the
    // command line arguments, if needed.
    if (vm_page_size() > (int)Linux::vm_default_page_size()) {
        StackYellowPages = 1;
        StackRedPages = 1;
        StackShadowPages = round_to((StackShadowPages*Linux::vm_default_page_size()), vm_page_size()) / vm_page_size();
    }
    ```
`Linux::page_size()`: 通过`sysconf(_SC_PAGESIZE)`获取到系统当前页面大小，查询操作系统实际数值后，该值为4K

[Linux::page_size()][10]

    ```
    Linux::set_page_size(sysconf(_SC_PAGESIZE));
    ```

`Linux::vm_default_page_size()`的默认值为8K

[Linux::vm_default_page_size()][11]

    ```c++
    const int os::Linux::_vm_default_page_size = (8 * K);
    ```

`BytesPerWord`在64位系统上为8，32位系统上为4

[BytesPerWord][12]

    ```c++
    #ifdef _LP64
    const int LogBytesPerWord    = 3;
    #else
    const int LogBytesPerWord    = 2;
    #endif
    const int LogBytesPerLong    = 3;

    const int BytesPerShort      = 1 << LogBytesPerShort;
    const int BytesPerInt        = 1 << LogBytesPerInt;
    const int BytesPerWord       = 1 << LogBytesPerWord;
    const int BytesPerLong       = 1 << LogBytesPerLong;
    ```

下面说说关于hotspot中的线程栈。

在HotSpot中创建线程会可以分为6种类型，各自有不同的栈大小，

* Java线程: java_thread
* 编译器线程: compiler_thread
* 虚拟机自身线程: vm_thread
* cms gc线程: cgc_thread
* PS gc线程: pgc_thread
* 观察者线程: watcher_thread

如下所示，[os::create_thread][5]

    ```c++
    if (os::Linux::supports_variable_stack_size()) {
        // calculate stack size if it's not specified by caller
        if (stack_size == 0) {
        stack_size = os::Linux::default_stack_size(thr_type);

        switch (thr_type) {
        case os::java_thread:
            // Java threads use ThreadStackSize which default value can be
            // changed with the flag -Xss
            assert (JavaThread::stack_size_at_create() > 0, "this should be set");
            stack_size = JavaThread::stack_size_at_create();
            break;
        case os::compiler_thread:
            if (CompilerThreadStackSize > 0) {
            stack_size = (size_t)(CompilerThreadStackSize * K);
            break;
            } // else fall through:
            // use VMThreadStackSize if CompilerThreadStackSize is not defined
        case os::vm_thread:
        case os::pgc_thread:
        case os::cgc_thread:
        case os::watcher_thread:
            if (VMThreadStackSize > 0) stack_size = (size_t)(VMThreadStackSize * K);
            break;
        }
    }

    // glibc guard page
    pthread_attr_setguardsize(&attr, os::Linux::default_guard_size(thr_type));
    ```

其中，`os::Linux::default_guard_size`方法的实现如下，[os::Linux::default_guard_size][6]

    ```c++
    size_t os::Linux::default_guard_size(os::ThreadType thr_type) {
        // Creating guard page is very expensive. Java thread has HotSpot
        // guard page, only enable glibc guard page for non-Java threads.
        return (thr_type == java_thread ? 0 : page_size());
    }
    ```

linux x86平台下，线程栈底部内存页的排布如下所示：[os_linux_x86][4]

    ```c++
    // Java thread:
    //
    //   Low memory addresses
    //    +------------------------+
    //    |                        |\  JavaThread created by VM does not have glibc
    //    |    glibc guard page    | - guard, attached Java thread usually has
    //    |                        |/  1 page glibc guard.
    // P1 +------------------------+ Thread::stack_base() - Thread::stack_size()
    //    |                        |\
    //    |  HotSpot Guard Pages   | - red and yellow pages
    //    |                        |/
    //    +------------------------+ JavaThread::stack_yellow_zone_base()
    //    |                        |\
    //    |      Normal Stack      | -
    //    |                        |/
    // P2 +------------------------+ Thread::stack_base()
    //
    // Non-Java thread:
    //
    //   Low memory addresses
    //    +------------------------+
    //    |                        |\
    //    |  glibc guard page      | - usually 1 page
    //    |                        |/
    // P1 +------------------------+ Thread::stack_base() - Thread::stack_size()
    //    |                        |\
    //    |      Normal Stack      | -
    //    |                        |/
    // P2 +------------------------+ Thread::stack_base()
    //
    // ** P1 (aka bottom) and size ( P2 = P1 - size) are the address and stack size returned from
    //    pthread_attr_getstack()
    ```

即

* java线程没有`glibc guard page`，但有`StackYellowPages`和`StackRedPages`
* 非java线程有`glibc guard page`，但没有`StackYellowPages`和`StackRedPages`
* 线程栈的大小 = P1 - size
    * 对于java线程，这个size包含了`StackYellowPages`和`StackRedPages`，这部分空间，代码不可用
    * 对于非java线程，这个size代码全部可用

当发生`StackOverflowError`时，可以根据程序运行到`StackYellowPages`或是`StackRedPages`来采取不同的处理方式

* 若待访问的地址已经处理`StackYellowPages`中，可恢复的故障
    * 若是在运行java代码，则抛出`StackOverflowError`，程序继续运行
    * 若是在运行native代码，则返回并终止程序运行
* 若待访问的地址已经处理`StackRedPages`中，无法恢复的故障，打印相关错误信息

如下所示，[JVM_handle_linux_signal][13]

    ```c++
    // Handle ALL stack overflow variations here
    if (sig == SIGSEGV) {
        address addr = (address) info->si_addr;

        // check if fault address is within thread stack
        if (addr < thread->stack_base() &&
            addr >= thread->stack_base() - thread->stack_size()) {
            // stack overflow
            if (thread->in_stack_yellow_zone(addr)) {
                thread->disable_stack_yellow_zone();
                if (thread->thread_state() == _thread_in_Java) {
                    // Throw a stack overflow exception.  Guard pages will be reenabled
                    // while unwinding the stack.
                    stub = SharedRuntime::continuation_for_implicit_exception(thread, pc, SharedRuntime::STACK_OVERFLOW);
                } else {
                    // Thread was in the vm or native code.  Return and try to finish.
                    return 1;
                }
            } else if (thread->in_stack_red_zone(addr)) {
                // Fatal red zone violation.  Disable the guard pages and fall through
                // to handle_unexpected_exception way down below.
                thread->disable_stack_red_zone();
                tty->print_raw_cr("An irrecoverable stack overflow has occurred.");

                // This is a likely cause, but hard to verify. Let's just print
                // it as a hint.
                tty->print_raw_cr("Please check if any of your loaded .so files has "
                                    "enabled executable stack (see man page execstack(8))");
            } else {
                // Accessing stack address below sp may cause SEGV if current
                // thread has MAP_GROWSDOWN stack. This should only happen when
                // current thread was created by user code with MAP_GROWSDOWN flag
                // and then attached to VM. See notes in os_linux.cpp.
                if (thread->osthread()->expanding_stack() == 0) {
                    thread->osthread()->set_expanding_stack();
                    if (os::Linux::manually_expand_stack(thread, addr)) {
                        thread->osthread()->clear_expanding_stack();
                        return 1;
                    }
                    thread->osthread()->clear_expanding_stack();
                } else {
                    fatal("recursive segv. expanding stack.");
                }
            }
        }
    }
    ```

关于`StackShadowPages`，Oracle的文档[<Troubleshooting Guide for Java SE 6 with HotSpot VM>][2]有如下说明

>In the HotSpot implementation, Java methods share stack frames with C/C++ native code, namely user native code and the virtual machine itself. Java methods generate code that checks that stack space is available a fixed distance towards the end of the stack so that the native code can be called without exceeding the stack space. This distance towards the end of the stack is called “Shadow Pages.” The size of the shadow pages is between 3 and 20 pages, depending on the platform. This distance is tunable, so that applications with native code needing more than the default distance can increase the shadow page size. The option to increase shadow pages is `-XX:StackShadowPages= n`, where n is greater than the default stack shadow pages for the platform.
>
>If your application gets a segmentation fault without a core file or fatal error log file (see   Appendix C, Fatal Error Log) or a `STACK_OVERFLOW_ERROR` on Windows or the message "An irrecoverable stack overflow has occurred," this indicates that the value of StackShadowPages was exceeded and more space is needed.
>
>If you increase the value of `StackShadowPages`, you might also need to increase the default thread stack size using the `-Xss` parameter. Increasing the default thread stack size might decrease the number of threads that can be created, so be careful in choosing a value for the thread stack size. The thread stack size varies by platform from 256k to 1024k.

在java线程中，java代码和本地代码公用一个线程栈，java代码所需要的空间可以由javac计算出来，而调用本地代码所需的空间无法再编译期获知，因此使用了`StackShadowPages`来提前预留出一部分栈空间，防止运行本地代码时爆栈。



[1]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os/linux/vm/os_linux.cpp#l4990
[2]:    https://www.oracle.com/technetwork/java/javase/crashes-137240.html
[3]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os/linux/vm/os_linux.cpp#l141
[4]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os_cpu/linux_x86/vm/os_linux_x86.cpp#l681
[5]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os/linux/vm/os_linux.cpp#l795
[6]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os_cpu/linux_x86/vm/os_linux_x86.cpp#l675
[7]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/share/vm/runtime/globals.hpp#l3313
[8]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/cpu/x86/vm/globals_x86.hpp#l59
[9]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os/linux/vm/os_linux.cpp#l4937
[10]:   https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os/linux/vm/os_linux.cpp#l4901
[11]:   https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os/linux/vm/os_linux.cpp#l141
[12]:   https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/share/vm/utilities/globalDefinitions.hpp#l81
[13]:   https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os_cpu/linux_x86/vm/os_linux_x86.cpp#l214
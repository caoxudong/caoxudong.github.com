---
title:      hotspot源代码学习，杂项，part1，常用的宏
category:   blog
layout:     post
tags:       [jvm, openjdk, hotspot, marco]
---


>jdk版本是openjdk-7u6-fcs-src-b24-28_aug_2012

# JVM方法常用的宏

[interfaceSupport.hpp][1]

    ```c++
    // Debug class instantiated in JRT_ENTRY and ITR_ENTRY macro.
    // Can be used to verify properties on enter/exit of the VM.

    #ifdef ASSERT
    class VMEntryWrapper {
    public:
    VMEntryWrapper() {
        if (VerifyLastFrame) {
        InterfaceSupport::verify_last_frame();
        }
    }

    ~VMEntryWrapper() {
        InterfaceSupport::check_gc_alot();
        if (WalkStackALot) {
        InterfaceSupport::walk_stack();
        }
    #ifdef ENABLE_ZAP_DEAD_LOCALS
        if (ZapDeadLocalsOld) {
        InterfaceSupport::zap_dead_locals_old();
        }
    #endif
    #ifdef COMPILER2
        // This option is not used by Compiler 1
        if (StressDerivedPointers) {
        InterfaceSupport::stress_derived_pointers();
        }
    #endif
        if (DeoptimizeALot || DeoptimizeRandom) {
        InterfaceSupport::deoptimizeAll();
        }
        if (ZombieALot) {
        InterfaceSupport::zombieAll();
        }
        if (UnlinkSymbolsALot) {
        InterfaceSupport::unlinkSymbols();
        }
        // do verification AFTER potential deoptimization
        if (VerifyStack) {
        InterfaceSupport::verify_stack();
        }

    }
    };


    class VMNativeEntryWrapper {
    public:
    VMNativeEntryWrapper() {
        if (GCALotAtAllSafepoints) InterfaceSupport::check_gc_alot();
    }

    ~VMNativeEntryWrapper() {
        if (GCALotAtAllSafepoints) InterfaceSupport::check_gc_alot();
    }
    };

    #endif


    // VM-internal runtime interface support

    #ifdef ASSERT

    class RuntimeHistogramElement : public HistogramElement {
    public:
    RuntimeHistogramElement(const char* name);
    };

    #define TRACE_CALL(result_type, header)                            \
    InterfaceSupport::_number_of_calls++;                            \
    if (TraceRuntimeCalls)                                           \
        InterfaceSupport::trace(#result_type, #header);                \
    if (CountRuntimeCalls) {                                         \
        static RuntimeHistogramElement* e = new RuntimeHistogramElement(#header); \
        if (e != NULL) e->increment_count();                           \
    }
    #else
    #define TRACE_CALL(result_type, header)                            \
    /* do nothing */
    #endif


    // LEAF routines do not lock, GC or throw exceptions

    #define VM_LEAF_BASE(result_type, header)                            \
    TRACE_CALL(result_type, header)                                    \
    debug_only(NoHandleMark __hm;)                                     \
    os::verify_stack_alignment();                                      \
    /* begin of body */


    // ENTRY routines may lock, GC and throw exceptions

    #define VM_ENTRY_BASE(result_type, header, thread)                   \
    TRACE_CALL(result_type, header)                                    \
    HandleMarkCleaner __hm(thread);                                    \
    Thread* THREAD = thread;                                           \
    os::verify_stack_alignment();                                      \
    /* begin of body */


    // QUICK_ENTRY routines behave like ENTRY but without a handle mark

    #define VM_QUICK_ENTRY_BASE(result_type, header, thread)             \
    TRACE_CALL(result_type, header)                                    \
    debug_only(NoHandleMark __hm;)                                     \
    Thread* THREAD = thread;                                           \
    os::verify_stack_alignment();                                      \
    /* begin of body */


    // Definitions for IRT (Interpreter Runtime)
    // (thread is an argument passed in to all these routines)

    #define IRT_ENTRY(result_type, header)                               \
    result_type header {                                               \
        ThreadInVMfromJava __tiv(thread);                                \
        VM_ENTRY_BASE(result_type, header, thread)                       \
        debug_only(VMEntryWrapper __vew;)


    #define IRT_LEAF(result_type, header)                                \
    result_type header {                                               \
        VM_LEAF_BASE(result_type, header)                                \
        debug_only(No_Safepoint_Verifier __nspv(true);)


    #define IRT_ENTRY_NO_ASYNC(result_type, header)                      \
    result_type header {                                               \
        ThreadInVMfromJavaNoAsyncException __tiv(thread);                \
        VM_ENTRY_BASE(result_type, header, thread)                       \
        debug_only(VMEntryWrapper __vew;)

    #define IRT_END }


    // Definitions for JRT (Java (Compiler/Shared) Runtime)

    #define JRT_ENTRY(result_type, header)                               \
    result_type header {                                               \
        ThreadInVMfromJava __tiv(thread);                                \
        VM_ENTRY_BASE(result_type, header, thread)                       \
        debug_only(VMEntryWrapper __vew;)


    #define JRT_LEAF(result_type, header)                                \
    result_type header {                                               \
    VM_LEAF_BASE(result_type, header)                                  \
    debug_only(JRT_Leaf_Verifier __jlv;)


    #define JRT_ENTRY_NO_ASYNC(result_type, header)                      \
    result_type header {                                               \
        ThreadInVMfromJavaNoAsyncException __tiv(thread);                \
        VM_ENTRY_BASE(result_type, header, thread)                       \
        debug_only(VMEntryWrapper __vew;)

    // Same as JRT Entry but allows for return value after the safepoint
    // to get back into Java from the VM
    #define JRT_BLOCK_ENTRY(result_type, header)                         \
    result_type header {                                               \
        TRACE_CALL(result_type, header)                                  \
        HandleMarkCleaner __hm(thread);

    #define JRT_BLOCK                                                    \
        {                                                                \
        ThreadInVMfromJava __tiv(thread);                                \
        Thread* THREAD = thread;                                         \
        debug_only(VMEntryWrapper __vew;)

    #define JRT_BLOCK_END }

    #define JRT_END }

    // Definitions for JNI

    #define JNI_ENTRY(result_type, header)                               \
        JNI_ENTRY_NO_PRESERVE(result_type, header)                       \
        WeakPreserveExceptionMark __wem(thread);

    #define JNI_ENTRY_NO_PRESERVE(result_type, header)             \
    extern "C" {                                                         \
    result_type JNICALL header {                                \
        JavaThread* thread=JavaThread::thread_from_jni_environment(env); \
        assert( !VerifyJNIEnvThread || (thread == Thread::current()), "JNIEnv is only valid in same thread"); \
        ThreadInVMfromNative __tiv(thread);                              \
        debug_only(VMNativeEntryWrapper __vew;)                          \
        VM_ENTRY_BASE(result_type, header, thread)


    // Ensure that the VMNativeEntryWrapper constructor, which can cause
    // a GC, is called outside the NoHandleMark (set via VM_QUICK_ENTRY_BASE).
    #define JNI_QUICK_ENTRY(result_type, header)                         \
    extern "C" {                                                         \
    result_type JNICALL header {                                \
        JavaThread* thread=JavaThread::thread_from_jni_environment(env); \
        assert( !VerifyJNIEnvThread || (thread == Thread::current()), "JNIEnv is only valid in same thread"); \
        ThreadInVMfromNative __tiv(thread);                              \
        debug_only(VMNativeEntryWrapper __vew;)                          \
        VM_QUICK_ENTRY_BASE(result_type, header, thread)


    #define JNI_LEAF(result_type, header)                                \
    extern "C" {                                                         \
    result_type JNICALL header {                                \
        JavaThread* thread=JavaThread::thread_from_jni_environment(env); \
        assert( !VerifyJNIEnvThread || (thread == Thread::current()), "JNIEnv is only valid in same thread"); \
        VM_LEAF_BASE(result_type, header)


    // Close the routine and the extern "C"
    #define JNI_END } }



    // Definitions for JVM

    #define JVM_ENTRY(result_type, header)                               \
    extern "C" {                                                         \
    result_type JNICALL header {                                       \
        JavaThread* thread=JavaThread::thread_from_jni_environment(env); \
        ThreadInVMfromNative __tiv(thread);                              \
        debug_only(VMNativeEntryWrapper __vew;)                          \
        VM_ENTRY_BASE(result_type, header, thread)


    #define JVM_ENTRY_NO_ENV(result_type, header)                        \
    extern "C" {                                                         \
    result_type JNICALL header {                                       \
        JavaThread* thread = (JavaThread*)ThreadLocalStorage::thread();  \
        ThreadInVMfromNative __tiv(thread);                              \
        debug_only(VMNativeEntryWrapper __vew;)                          \
        VM_ENTRY_BASE(result_type, header, thread)


    #define JVM_QUICK_ENTRY(result_type, header)                         \
    extern "C" {                                                         \
    result_type JNICALL header {                                       \
        JavaThread* thread=JavaThread::thread_from_jni_environment(env); \
        ThreadInVMfromNative __tiv(thread);                              \
        debug_only(VMNativeEntryWrapper __vew;)                          \
        VM_QUICK_ENTRY_BASE(result_type, header, thread)


    #define JVM_LEAF(result_type, header)                                \
    extern "C" {                                                         \
    result_type JNICALL header {                                       \
        VM_Exit::block_if_vm_exited();                                   \
        VM_LEAF_BASE(result_type, header)


    #define JVM_END } }

    #endif // SHARE_VM_RUNTIME_INTERFACESUPPORT_HPP
    ```





[1]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/share/vm/runtime/interfaceSupport.hpp
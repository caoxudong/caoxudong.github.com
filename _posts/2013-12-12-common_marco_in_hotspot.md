---
title:      hotspot源代码学习，杂项，part1，常用的宏
category:   blog
layout:     post
tags:       [jvm, openjdk, hotspot, marco]
---


>jdk版本是openjdk-7u6-fcs-src-b24-28_aug_2012

# JVM方法常用的宏

    // Definitions for JVM
    
    #define JVM_ENTRY(result_type, header)                                   \
    extern "C" {                                                             \
        result_type JNICALL header {                                         \
            JavaThread* thread=JavaThread::thread_from_jni_environment(env); \
            ThreadInVMfromNative __tiv(thread);                              \
            debug_only(VMNativeEntryWrapper __vew;)                          \
            VM_ENTRY_BASE(result_type, header, thread)
    
    
    #define JVM_ENTRY_NO_ENV(result_type, header)                                \
        extern "C" {                                                             \
            result_type JNICALL header {                                         \
                JavaThread* thread = (JavaThread*)ThreadLocalStorage::thread();  \
                ThreadInVMfromNative __tiv(thread);                              \
                debug_only(VMNativeEntryWrapper __vew;)                          \
                VM_ENTRY_BASE(result_type, header, thread)
    
    
    #define JVM_QUICK_ENTRY(result_type, header)                                 \
        extern "C" {                                                             \
            result_type JNICALL header {                                         \
                JavaThread* thread=JavaThread::thread_from_jni_environment(env); \
                ThreadInVMfromNative __tiv(thread);                              \
                debug_only(VMNativeEntryWrapper __vew;)                          \
                VM_QUICK_ENTRY_BASE(result_type, header, thread)
    
    
    #define JVM_LEAF(result_type, header)                                        \
        extern "C" {                                                             \
            result_type JNICALL header {                                         \
                VM_Exit::block_if_vm_exited();                                   \
                VM_LEAF_BASE(result_type, header)
    
    
    #define JVM_END } }

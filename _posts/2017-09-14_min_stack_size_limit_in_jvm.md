---
title:      jvm中对线程栈最小值的限制
layout:     post
category:   blog
tags:       [java]
---

今天在重启线上服务的时候，将线程栈从256KB减小为128KB，jvm启动失败，错误信息为

>The stack size specified is too small, Specify at least 228k

这个错误是jvm本身报的，它对线程栈的大小做了最小值的限制。报错位置在[os_linux.cpp][1]

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


变量`os::Linux::min_stack_allowed`的值由以下几个值决定

* `StackYellowPages`
* `StackRedPages`
* `StackShadowPages`
* 操作系统中页面的值
    * `Linux::page_size()`
    * `Linux::vm_default_page_size()`
* `BytesPerWord`

关于`StackShadowPages`，Oracle的文档[<Troubleshooting Guide for Java SE 6 with HotSpot VM>][2]有如下说明

>In the HotSpot implementation, Java methods share stack frames with C/C++ native code, namely user native code and the virtual machine itself. Java methods generate code that checks that stack space is available a fixed distance towards the end of the stack so that the native code can be called without exceeding the stack space. This distance towards the end of the stack is called “Shadow Pages.” The size of the shadow pages is between 3 and 20 pages, depending on the platform. This distance is tunable, so that applications with native code needing more than the default distance can increase the shadow page size. The option to increase shadow pages is `-XX:StackShadowPages= n`, where n is greater than the default stack shadow pages for the platform.
>
>If your application gets a segmentation fault without a core file or fatal error log file (see   Appendix C, Fatal Error Log) or a `STACK_OVERFLOW_ERROR` on Windows or the message "An irrecoverable stack overflow has occurred," this indicates that the value of StackShadowPages was exceeded and more space is needed.
>
>If you increase the value of `StackShadowPages`, you might also need to increase the default thread stack size using the `-Xss` parameter. Increasing the default thread stack size might decrease the number of threads that can be created, so be careful in choosing a value for the thread stack size. The thread stack size varies by platform from 256k to 1024k.

[1]:    http://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os/linux/vm/os_linux.cpp#l4990
[2]:    http://www.oracle.com/technetwork/java/javase/crashes-137240.html
---
title:      进程退出的相关函数，part1，声明
category:   blog
layout:     post
tags:       [c. glibc]
---


进程退出的相关函数，part1，声明
================


> 下面讨论都假设当前使用x86平台

# 函数声明

stdlib.h中对有exit相关函数的声明：

进程退出状态：

    /* We define these the same for all machines.
       Changes from this to the outside world should be done in `_exit'.  */
    #define EXIT_FAILURE    1   /* Failing exit status.  */
    #define EXIT_SUCCESS    0   /* Successful exit status.  */
    

exit函数的声明：

    /* Call all functions registered with `atexit' and `on_exit',
       in the reverse of the order in which they were registered,
       perform stdio cleanup, and terminate program execution with STATUS.  */
    extern void exit (int __status) __THROW __attribute__ ((__noreturn__));
    

quick_exit函数的声明：

    /* Call all functions registered with `at_quick_exit' in the reverse
       of the order in which they were registered and terminate program
       execution with STATUS.  */
    extern void quick_exit (int __status) __THROW __attribute__ ((__noreturn__));
    

_Exit函数的声明：

    /* Terminate the program with STATUS without calling any of the
       functions registered with `atexit' or `on_exit'.  */
    extern void _Exit (int __status) __THROW __attribute__ ((__noreturn__));
    

on_exit函数的声明：

    /* Register a function to be called with the status
       given to `exit' and the given argument.  */
    extern int on_exit (void (*__func) (int __status, void *__arg), void *__arg) __THROW __nonnull ((1));
    

atexit函数的声明：

    /* Register a function to be called when `exit' is called.  */
    extern int atexit (void (*__func) (void)) __THROW __nonnull ((1));
    

at_quick_exit函数的声明：

    /* Register a function to be called when `quick_exit' is called.  */
    # ifdef __cplusplus
        extern "C++" int at_quick_exit (void (*__func) (void)) __THROW __asm ("at_quick_exit") __nonnull ((1));
    # else
        extern int at_quick_exit (void (*__func) (void)) __THROW __nonnull ((1));
    # endif
    

abort函数的声明：

    /* Abort execution and generate a core-dump.  */
    extern void abort (void) __THROW __attribute__ ((__noreturn__));
    

从上面的函数声明中可以看到，

1.  exit和_Exit函数的区别主要在于进程退出之前是否调用预先注册的清理函数（exit会调用atexit和on_exit），清理函数的调用顺序与注册顺序相反； 
2.  quick_exit也会调用清理函数（at_quick_exit），清理函数的调用顺序与注册顺序相反；
3.  atexit和on_exit和区别主要在于，清理函数是否有参数； 
4.  abort会立即终止进程，生成core-dump，不执行清理工作。

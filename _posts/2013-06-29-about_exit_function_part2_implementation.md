---
category:   pages
layout:     post
tags:       [c. glibc]
---


进程退出的相关函数，part2，实现
=====================


> [进程退出的相关函数，part1，声明][1]

# _exit函数

## posix实现

该实现在$glibc_src_home/posix/_exit.c中

    /* The function `_exit' should take a status argument and simply
       terminate program execution, using the low-order 8 bits of the
       given integer as status.  */
    void
    _exit (status)
        int status;
    {
        status &= 0xff;
        abort ();
    }
    

> 上面的函数定义中，所使用的K&R风格的定义方式，与ANSI C略有不同。

下面是函数abort的声明($glibc_src_home/stdlib/stdlib.h)和定义($glibc_src_home/sysdeps/mach/hurd/dl-sysdep.c)为：

    /* Abort execution and generate a core-dump.  */
    extern void abort (void) __THROW __attribute__ ((__noreturn__));
    
    /* Try to get a machine dependent instruction which will make the
       program crash.  This is used in case everything else fails.  */
    #include <abort-instr.h>
    #ifndef ABORT_INSTRUCTION
        /* No such instruction is available.  */
        # define ABORT_INSTRUCTION
    #endif
    
    void weak_function
    abort (void)
    {
        /* Try to abort using the system specific command.  */
        ABORT_INSTRUCTION;
    
        /* If the abort instruction failed, exit.  */
        _exit (127);
    
        /* If even this fails, make sure we never return.  */
        while (1)
            /* Try for ever and ever.  */
            ABORT_INSTRUCTION;
    }
    

在这里，weak_function是一个宏，用于设置当前函数为弱符号（weak symbol），以便用户代码覆盖，参见[gcc手册][2]

    # define weak_function __attribute__ ((weak))
    

另外，在abort函数中调用的_exit函数，并非本文最开始所说的_exit函数，而是与abort函数定义在同一个文件($glibc_src_home/sysdeps/mach/hurd/dl-sysdep.c)中的。

    void weak_function attribute_hidden
    _exit (int status)
    {
        __proc_mark_exit (_dl_hurd_data->portarray[INIT_PORT_PROC], W_EXITCODE (status, 0), 0);
        while (__task_terminate (__mach_task_self ()))
            __mach_task_self_ = (__mach_task_self) ();
    }
    

## linux实现

_exit函数的实现在$glibc_src_home/sysdeps/unix/sysv/linux/_exit.c中

    void
    _exit (status)
        int status;
    {
        while (1)
        {
            #ifdef __NR_exit_group
                INLINE_SYSCALL (exit_group, 1, status);
            #endif
                INLINE_SYSCALL (exit, 1, status);
    
            #ifdef ABORT_INSTRUCTION
                ABORT_INSTRUCTION;
            #endif
        }
    }

[1]:    /post/about_exit_function_part1_declaration
[2]:    http://gcc.gnu.org/onlinedocs/gcc-3.2/gcc/Function-Attributes.html

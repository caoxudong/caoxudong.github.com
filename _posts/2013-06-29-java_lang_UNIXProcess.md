---
title:      java.lang.UNIXProcess类
category:   blog
layout:     post
tags:       [java, openjdk]
---


> 今天的定时任务抛了个异常，在调用栈中发现有个名为UNIXProcess的类，这里记录一下。

UNIXProcess类是*nix系统在java程序中的体现，程序员可以使用该类创建新进程，实现与"fork"类似的功能（对于Windows系统，使用的是java.lang.ProcessImpl类）。相关用法参见[Runtime.exec方法][1]。下面继续说说UNIXProcess本身。

java.lang.UNIXProcess这个类只存在于*nix系的操作系统中，并且分为linux、bsd、solaris个版本（mac os使用的是solaris版本的），它们都位于[$openjdk_src_home/jdk/src/solaris/classes/java/lang][2]目录下。

在编译的时候，会根据当前操作系统的不同，会编译指定的UNIXProcess.java文件，并将其拷贝到rt.jar中，，参见[makefile][3]

    # UNIXProcess.java is different for solaris and linux. We need to copy
    # the correct UNIXProcess.java over to $(GENSRCDIR)/java/lang/.
    
    ifeq ($(PLATFORM), macosx)
    PLATFORM_UNIX_PROCESS = \
        $(PLATFORM_SRC)/classes/java/lang/UNIXProcess.java.bsd
    else
    PLATFORM_UNIX_PROCESS = \
        $(PLATFORM_SRC)/classes/java/lang/UNIXProcess.java.$(PLATFORM)
    endif
    
    $(GENSRCDIR)/java/lang/UNIXProcess.java: $(PLATFORM_UNIX_PROCESS)
        $(install-file)
    

其中，`install-file`的定义在[Defs.gmk][4]中：

    # Simple install of $< file to $@
    define install-file
        $(prep-target)
        $(CP) $< $@
    endef
    

就其区别来说，bsd和linux两个版本的代码实际上完全相同，而与solaris版本区别较大，具体表现在以下几个方面。

## "fork"的使用策略

在文件[UNIXProcess_md.c][5]的注释中，说明了对"fork"的使用，以及最终在linux上使用vfork，Unix系统使用fork的决定(clone方法的相关代码仍然保留)。

    fork(2)
    可移植性较好，但会由于overcommit发生错误。
    
    vfork()    
    有重大问题（参见man手册），但好在glibc已将该函数记录在案，并且XPG4已将其标准化。另一个好处是，vfork实际上是一个独立的系统调用，这说明linux会一直支持下去。
    
    clone()   
    调用该函数时使用`CLONE_VM`选项，而非`CLONE_THREAD`选项，由于glibc中包含了对`CLONE_VM`和`CLONE_THREAD`相关组合的处理，所以在其他系统上也应该可以工作，但实际上并不是这样。
    

代码中相关宏的设置：

    #define START_CHILD_USE_CLONE 0  /* clone() currently disabled; see above. */
    
    #ifndef START_CHILD_USE_CLONE
        #ifdef __linux__
            #define START_CHILD_USE_CLONE 1
        #else
            #define START_CHILD_USE_CLONE 0
        #endif
    #endif
    
    /* By default, use vfork() on Linux. */
    #ifndef START_CHILD_USE_VFORK
        #ifdef __linux__
            #define START_CHILD_USE_VFORK 1
        #else
            #define START_CHILD_USE_VFORK 0
        #endif
    #endif
    
具体使用实在startChild方法中，根据宏的设置，调用`vfork`,`fork`或者`clone`函数。

## 默认"PATH"的设置

代码说明一切

    /**
     * If PATH is not defined, the OS provides some default value.
     * Unfortunately, there's no portable way to get this value.
     * Fortunately, it's only needed if the child has PATH while we do not.
     */
    static const char*
    defaultPath(void)
    {
    #ifdef __solaris__
        /* These really are the Solaris defaults! */
        return (geteuid() == 0 || getuid() == 0) ?
            "/usr/xpg4/bin:/usr/ccs/bin:/usr/bin:/opt/SUNWspro/bin:/usr/sbin" :
            "/usr/xpg4/bin:/usr/ccs/bin:/usr/bin:/opt/SUNWspro/bin:";
    #else
        return ":/bin:/usr/bin";    /* glibc */
    #endif
    }
    

这是急眼了么？

    /* These really are the Solaris defaults! */
    

## waitForProcessExit方法对子进程返回值的处理

    /* The child exited because of a signal.
         * The best value to return is 0x80 + signal number,
         * because that is what all Unix shells do, and because
         * it allows callers to distinguish between process exit and
         * process death by signal.
         * Unfortunately, the historical behavior on Solaris is to return
         * the signal number, and we preserve this for compatibility. */
    #ifdef __solaris__
        return WTERMSIG(status);
    #else
        return 0x80 + WTERMSIG(status);
    #endif

[1]:    http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/java/lang/Runtime.java#613
[2]:    http://hg.openjdk.java.net/jdk7u/jdk7u/jdk/file/87c6c2882d3f/src/solaris/classes/java/lang/
[3]:    http://hg.openjdk.java.net/jdk7u/jdk7u/jdk/file/87c6c2882d3f/make/java/java/Makefile
[4]:    http://hg.openjdk.java.net/jdk7u/jdk7u/jdk/file/87c6c2882d3f/make/common/Defs.gmk
[5]:    http://hg.openjdk.java.net/jdk7u/jdk7u/jdk/file/87c6c2882d3f/src/solaris/native/java/lang/UNIXProcess_md.c

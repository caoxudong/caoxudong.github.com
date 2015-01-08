---
title:      hotspot源代码学习，flags，part2，一些有用的命令行参数
category:   blog
layout:     post
tags:       [hotspot, jvm, openjdk]
---


hotspot源代码学习，flags，part2，一些有用的命令行参数
===================



>hotpost的参数一般都定义在globals.hpp相关文件中，包括运行时、编译器、gc等模块都有自己的globals.hpp文件，这些文件中定义的参数都是以`-XX`开头的参数。还有一些是以`-`和`-X`开头的参数，这些参数的解析是在launcher模块中完成的。

>源代码版本： `openjdk-7u6-fcs-src-b24-28_aug_2012`

# -XshowSettings

该参数用于显示当前程序中的基本配置，如下所示：

    $ java -XshowSettings
    VM settings:
        Stack Size: 320.00K
        Max. Heap Size (Estimated): 878.25M
        Ergonomics Machine Class: server
        Using VM: Java HotSpot(TM) Server VM
    
    Property settings:
        awt.toolkit = sun.awt.X11.XToolkit
        file.encoding = ANSI_X3.4-1968
        /*此处省略很多行*/
        user.name = root
        user.timezone = 
    
    Locale settings:
        default locale = English
        default display locale = English (United States)
        default format locale = English (United States)
        available locales = ar, ar_AE, ar_BH, ar_DZ, ar_EG, ar_IQ, ar_JO, ar_KW, 
            ar_LB, ar_LY, ar_MA, ar_OM, ar_QA, ar_SA, ar_SD, ar_SY, 
            /*此处省略很多行*/         
            zh_CN, zh_HK, zh_SG, zh_TW
    (省略java命令的帮助信息)

# -XX:+ShowMessageBoxOnError

该参数可以让Java进程在退出前先暂停，然后手动从外部执行需要的命令，并且会提示额外信息：

    ------------------------------------------------------------------------------
    Internal Error at allocation.inline.hpp:58, pid=26378, tid=1325251472
    Error: char in /HUDSON/workspace/jdk7u3-2-build-linux-i586-product/jdk7u3/hotspot/src/share/vm/utilities/stack.inline.hpp
    
    Do you want to debug the problem?
    
    To debug, run 'gdb /proc/26378/exe 26378'; then switch to thread 1325251472 (0x4efdbb90)
    Enter 'yes' to launch gdb automatically (PATH must include gdb)
    Otherwise, press RETURN to abort...
    ==============================================================================

上面是在linux上打印的额外信息，可以在其中直接启用gdb进行调试。

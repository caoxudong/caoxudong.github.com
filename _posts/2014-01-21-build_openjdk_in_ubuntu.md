---
title:      ubuntu编译jdk
category:   blog
layout:     post
tags:       [java, jvm, openjdk, ubuntu]
---



>本机环境如下：

    [henry@henry-ubuntu:~/program/java/oracle_jdk/jdk1.7.0_51]$ java -version
    java version "1.7.0_51"
    Java(TM) SE Runtime Environment (build 1.7.0_51-b13)
    Java HotSpot(TM) Client VM (build 24.51-b03, mixed mode)
    
    [henry@henry-ubuntu:~/workspace/openjdk/openjdk-7u40-fcs-src-b43-26_aug_2013/openjdk]$ uname -a
    Linux henry-ubuntu 3.2.0-29-generic-pae #46-Ubuntu SMP Fri Jul 27 17:25:43 UTC 2012 i686 i686 i386 GNU/Linux


# 默认全部编译 

主要参考文档：README-builds.html，在源代码目录就有。

过程：

1.  安装mercurial 

2.  下载某个repository（repository与project的区别，参见<http://openjdk.java.net/guide/repositories.html>）

3.  执行脚本get_source.sh以获取源代码。 

4.  设置基本环境变量。
    
        export LANG=C 
        export ALT_BOOTDIR=$JAVA_HOME 
        export JAVA_HOME= 
        export CLASSPATH=

5.  相关依赖库 

    5.1 安装CUPs，如果安装的时候制定了自定义目录，则还需要配置环境变量`ALT_CUPS_HEADERS_PATH`

        sudo apt-get install cups-common
        sudo apt-get install libcups2-dev

    5.2 安装FreeType，需要2.3以上的版本。如果安装的时候制定了自定义目录，则还需要配置环境变量`ALT_FREETYPE_LIB_PATH`和`ALT_FREETYPE_HEADERS_PATH`

        sudo apt-get install libfreetype6
        sudo apt-get install libfreetype6-dev

    5.3 安装ALSA，这个就不要自定义安装了

        sudo apt-get alsa-base
        sudo apt-get alsa-utils
        sudo apt-get install libclalsadrv2
        sudo apt-get install libclalsadrv-dev

6.  至此make sanity应该可以通过了，然后make。 

7.  make时的错误

    * 找不到gawk

            sudo apt-get install gawk

    * 找不到X11库，执行

            sudo apt-get install libx11-dev 
    
    * fatal error: X11/extensions/shape.h: No such file or directory，执行

            sudo apt-get install libxext-dev
    
    * fatal error: X11/extensions/Xrender.h: No such file or directory，执行

            sudo apt-get install libxrender-dev
    
    * fatal error: X11/extensions/XTest.h: No such file or directory，执行

            sudo apt-get install libxtst-dev

    * fatal error: X11/Intrinsic.h: No such file or directory，执行

            sudo apt-get install libxt-dev
    
    如果还有缺少库的情况，可以到这里<http://packages.ubuntu.com/>搜索。

8. 继续make时的错误

    * 权限错误

            /home/henry/program/java/oracle_jdk/jdk1.7.0_51/bin/javac -g -encoding ascii -source 6 -target 6 -classpath /home/henry/program/java/oracle_jdk/jdk1.7.0_51/lib/tools.jar -sourcepath /media/sf_win7_e_drive/workspace/openjdk/openjdk-7u6-fcs-src-b24-28_aug_2012/openjdk/hotspot/agent/src/share/classes -d /media/sf_win7_e_drive/workspace/openjdk/openjdk-7u6-fcs-src-b24-28_aug_2012/openjdk/build/linux-i586/hotspot/outputdir/linux_i486_compiler2/product/../generated/saclasses @/media/sf_win7_e_drive/workspace/openjdk/openjdk-7u6-fcs-src-b24-28_aug_2012/openjdk/build/linux-i586/hotspot/outputdir/linux_i486_compiler2/product/../generated/agent.classes.list
            
            warning: [options] bootstrap class path not set in conjunction with -source 1.6
            /media/sf_win7_e_drive/workspace/openjdk/openjdk-7u6-fcs-src-b24-28_aug_2012/openjdk/hotspot/agent/src/share/classes/sun/jvm/hotspot/debugger/win32/coff/COFFFileParser.java:333: error: error while writing COFFFileParser.COFFFileImpl.COFFHeaderImpl.OptionalHeaderWindowsSpecificFieldsImpl: /media/sf_win7_e_drive/workspace/openjdk/openjdk-7u6-fcs-src-b24-28_aug_2012/openjdk/build/linux-i586/hotspot/outputdir/linux_i486_compiler2/product/../generated/saclasses/sun/jvm/hotspot/debugger/win32/coff/COFFFileParser$COFFFileImpl$COFFHeaderImpl$OptionalHeaderWindowsSpecificFieldsImpl.class (Operation not permitted)
            
            class OptionalHeaderWindowsSpecificFieldsImpl implements OptionalHeaderWindowsSpecificFields {
            ^
            
            Note: Some input files use unchecked or unsafe operations.
            Note: Recompile with -Xlint:unchecked for details.


        没找到具体原因，猜测是与使用了virtualbox，并将编译编译结果输出到windows的共享目录相关。

        变通方法，设置`ALT_OUTPUTDIR`变量，将编译结果输出到virtualbox的虚拟硬盘中，重新make。

    * 找不到类

            cd linux_i486_compiler2/product && ./test_gamma
            Using java runtime at: /home/henry/program/java/oracle_jdk/jdk1.7.0_51/jre
            Error occurred during initialization of VM
            java/lang/NoClassDefFoundError: java/lang/invoke/AdapterMethodHandle

        在classpath中确实没找到AdapterMethodHandle这个类，从下面两个邮件列表中的问题看，应该是新旧两个虚拟机不兼容，所以重新下载源码([openjdk-7u40-fcs-src-b43-26_aug_2013][3])再编译

        * [http://mail.openjdk.java.net/pipermail/mlvm-dev/2012-July/004821.html][1]
        * [http://mail.openjdk.java.net/pipermail/build-dev/2013-May/008877.html][2]

9.  make成功

    32bit    

        #-- Build times ----------
        Target all_product_build
        Start 2014-01-21 19:50:53
        End   2014-01-21 20:31:48
        00:00:20 corba
        00:01:26 hotspot
        00:01:08 jaxp
        00:01:48 jaxws
        00:35:25 jdk
        00:00:48 langtools
        00:40:55 TOTAL

    64bit

        #-- Build times ----------
        Target all_product_build
        Start 2014-01-26 14:36:02
        End   2014-01-26 16:31:03
        00:07:00 corba
        00:37:02 hotspot
        00:02:48 jaxp
        00:04:15 jaxws
        01:01:14 jdk
        00:02:41 langtools
        01:55:01 TOTAL

    电脑矬真是苦逼，时间长的令人发指。


10.  运行一下
    
    32bit
    
        [henry@henry-ubuntu:~/program/java/openjdk/openjdk-7u40-fcs-src-b43-26_aug_2013/bin]$ ./java -version
        openjdk version "1.7.0-internal"
        OpenJDK Runtime Environment (build 1.7.0-internal-henry_2014_01_21_09_17-b00)
        OpenJDK Client VM (build 24.0-b56, mixed mode)

    64bit

        [henry@ubuntu:~/program/java/open_jdk/jdk7u40]$ bin/java -version
        openjdk version "1.7.0-internal"
        OpenJDK Runtime Environment (build 1.7.0-internal-henry_2014_01_26_14_35-b00)
        OpenJDK 64-Bit Server VM (build 24.0-b56, mixed mode)



# 定制化编译

>[openjdk的编译参数][4]

    //TODO: 定制化编译openjdk的某个部分




[1]:    http://mail.openjdk.java.net/pipermail/mlvm-dev/2012-July/004821.html
[2]:    http://mail.openjdk.java.net/pipermail/build-dev/2013-May/008877.html
[3]:    http://www.java.net/download/openjdk/jdk7u40/promoted/b43/openjdk-7u40-fcs-src-b43-26_aug_2013.zip
[4]:    /blog/2013/09/26/build_openjdk
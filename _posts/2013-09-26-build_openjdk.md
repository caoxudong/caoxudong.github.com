---
title:      编译OpenJDK
category:   blog
layout:     post
tag:        [openjdk, java, jvm, hotspot]
---


编译OpenJDK
=================




>[在ubuntu上编译openjdk][1]
>
>[在mac osx上编译openjdk][3]

>下面的说明以在mac osx上编译jdk8为基础

# 依赖项

* freetype2: 需要2.3及之后的，用于编译jconsole等GUI工具
* ant: 用于编译java组件
* CUPS:  Common UNIX Printing System，打印驱动
* jdk: 编译jdk需要用到以前版本的jdk（不知道第一个版本的jdk是怎么编译出来的）
* gcc: 相关版本信息参见README-builds.html文件的说明
* CA: CA的内容参见[wiki][2]说明，这里基本不需要设置
* zip/unzip: 编译过程中会用到
* XRender: 编译GUI工具会用到
* ALSA: （only linux，0.9.1 or newer）编译时需要alsa和alsa-devel两个包


<a name="compilation_options" />
# 编译选项

## 环境变量

* **PATH**: 没啥说的，都懂
* **BUILD_NUMBER**: 指定构建的build号，例如"b27"

## ALT_*类选项

>ALT_*选项用于覆盖默认编译选项，主要用于自定义配置，无视windows

* **ALT_SLASH_JAVA**: 大部分 **ALT**选项的默认根路径，在solaris和linux上，默认值是`/java`，在windows上是`J:`
* **ALT_DROPS_DIR**: 该目录用于存储在编译过程中下载的各类依赖，例如jaxws和jaxp等，下载过一次后，以后再编译时就不会再下载了，默认值是`$(ALT_JDK_DEVTOOLS_PATH)/share/jdk7-drops`
* **ALT_BOOTDIR**: 编译openjdk需要用到jdk6，称之为`bootstrap jdk`,该选项就是设置该JDK的目录，`bootstrap jdk`中应该包含`bin` `lib` `include`目录
* **ALT_JDK_IMPORT_PATH**: 如果你不需要编译整个JDK，或者之前已经完整编译过JDK，现在只想编译hospot，不需要重复编译其他的组件，就可以设置该选项，指向之前已经安装的JDK目录
* **ALT_BUILD_JDK_IMPORT_PATH**: 该选项主要用于编译其他平台。如果没有设置`ALT_JDK_IMPORT_PATH`的话，就会使用该选项中的工具来编译。该选项指定的目录中应该包含以下子目录：solaris-sparc, solaris-i586, solaris-sparcv9, solaris-amd64, linux-i586, linux-amd64, windows-i586, windows-amd64
* **ANT_HOME**: 一些java组件是用ant编译的
* **ALT_FREETYPE_LIB_PATH**： FreeType2的库路径
* **ALT_FREETYPE_INCLUDE_PATH**: FreeType2头文件的路径
* **ALT_CACERTS_FILE**: 该选项用于覆盖默认的[CA][2]设置
* **ALT_COMPILER_PATH**：该选项用于指定编译器，并将该选项指定的目录放入到`PATH`变量中
* **ALT_CUPS_HEADERS_PATH**: CPUS是电源管理软件，使用该选项覆盖默认的CUPS头文件路径
* **ALT_OUTPUTDIR**: 编译后的输出目录
* **ALT_COMPILER_PATH**: 指定c/c++编译器的路径，一般与 **CROSS_COMPILE_ARCH**选项配合使用
* **ALT_DEVTOOLS_PATH**: 包含了像zip/unzip这类工具的路径，大杂烩，啥都有。Linux - `$(ALT_JDK_DEVTOOLS_PATH)/linux/bin`, Solaris - `$(ALT_JDK_DEVTOOLS_PATH)/{sparc,i386}/bin`, Windows(with CYGWIN)  - `/usr/bin`
* **ALT_JDK_DEVTOOLS_PATH**: devtools的root路径，默认值是` $(ALT_SLASH_JAVA)/devtools`
* **ALT_UNIXCCS_PATH**: solaris only，指定Unix CCS命令的路径，默认值是`/usr/ccs/bin`
* **ALT_OPENWIN_HOME**: 编译GUI工具时用到，指定图形库的路径，其值依赖于具体的os

## build选项

* **ARCH_DATA_MODEL**: 32或64，solaris上可以选择编译哪个版本，windown或linux不能选，依赖于os而定
* **CROSS_COMPILE_ARCH**: 用于指定本次要进行交叉编译。设置该选项后，还需要需要设置 **ALT_COMPILER_PATH**（指定编译器路径），**EXTRA_CFLAGS**（指定传给编译器的参数）和 **ALT_OPENWIN_HOME**（目标平台的图形库）
* **EXTRA_CFLAGS**: 用于指定在交叉编译时传给编译器的参数，这些参数会被附加到 **CFLAGS**和 **CXXFLAGS**值的后面
* **USE_ONLY_BOOTDIR_TOOLS**: 该选项主要用于交叉编译，指定在交叉编译时使用的jdk
* **HOST_CC**: 指定用于生产目标程序的C编译器，在linux上，默认值是`/usr/bin/gcc`，在其他系统上需要显示指定
* **CC_VER**: 用于指定编译器版本（mac osx）
* **BUILD_HEADLESS_ONLY**: 当编译环境中压根没有图形界面时，使用此选项。该选项会排除对所有图形相关工具和库的编译。
* **JAVASE_EMBEDDED**: 指定生成 **Oracle Java SE Embedded product**，指定该选项会将SE-Embended相关编译文件包含进来
* **LIBZIP_CAN_USE_MMAP**: 如果设置为false，则在使用zip工具时禁用mmap，否则启用mmap
* **COMPRESS_JARS**: 如果设置为true，会将某些jar进行压缩

## hotspot选项
* **BUILD_CLIENT_ONLY**: 只编译client模式的hotspot





[1]:    /post/build_openjdk_in_ubuntu
[2]:    http://en.wikipedia.org/wiki/Certificate_Authority
[3]:    /post/build_openjdk8_in_macosx_10.8.4

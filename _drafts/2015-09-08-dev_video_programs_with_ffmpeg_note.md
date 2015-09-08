---
title:      开发笔记，使用FFpmeg截取视频中的图片
layout:     post
category:   blog
tags:       [video, ffmpeg]
---

# FFmpeg

[FFmpeg][1]是一款跨平台的视频、音频处理工具。在ubuntu上，可以通过PPA来安装，参见[https://launchpad.net/~mc3man/+archive/ubuntu/trusty-media][2]

# 安装依赖库

先设置PPA:

    sudo add-apt-repository ppa:mc3man/trusty-media
    sudo apt-get update
    sudo apt-get dist-upgrade

安装ffmpeg

    sudo apt-get install ffmpeg

安装libva
    
    sudo apt-get install libva-dev

安装vorbis

    sudo apt-get install libvorbis-dev

刷新动态库

    sudo ldconfig

# 系统环境

    $ gcc -v
    Using built-in specs.
    COLLECT_GCC=gcc
    COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/4.8/lto-wrapper
    Target: x86_64-linux-gnu
    Configured with: ../src/configure -v --with-pkgversion='Ubuntu 4.8.4-2ubuntu1~14.04' --with-bugurl=file:///usr/share/doc/gcc-4.8/README.Bugs --enable-languages=c,c++,java,go,d,fortran,objc,obj-c++ --prefix=/usr --program-suffix=-4.8 --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.8 --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --enable-gnu-unique-object --disable-libmudflap --enable-plugin --with-system-zlib --disable-browser-plugin --enable-java-awt=gtk --enable-gtk-cairo --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-4.8-amd64/jre --enable-java-home --with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-4.8-amd64 --with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-4.8-amd64 --with-arch-directory=amd64 --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --enable-objc-gc --enable-multiarch --disable-werror --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32,m64,mx32 --with-tune=generic --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
    Thread model: posix
    gcc version 4.8.4 (Ubuntu 4.8.4-2ubuntu1~14.04) 

    $ uname -a
    Linux henry-ubuntu 3.13.0-63-generic #103-Ubuntu SMP Fri Aug 14 21:42:59 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux






[1]:    https://www.ffmpeg.org/
[2]:    https://launchpad.net/~mc3man/+archive/ubuntu/trusty-media
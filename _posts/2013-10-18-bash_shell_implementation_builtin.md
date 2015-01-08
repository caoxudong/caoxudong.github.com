---
category:   pages
layout:     post
tags:       [shell, bash]
---


bash中alias的实现
===================

>这里的源代码是基于glibc-2.18.90的

alias这个命令很常用，其实现也很简单。

    #!/bin/sh
    # $FreeBSD: src/usr.bin/alias/generic.sh,v 1.2 2005/10/24 22:32:19 cperciva Exp $
    # This file is in the public domain.
    builtin `echo ${0##*/} | tr \[:upper:] \[:lower:]` ${1+"$@"}

就这么一点，下面把这个命令分开细说。

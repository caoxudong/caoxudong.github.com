---
title:      hotspot源代码学习，对象，part3, 标记字
category:   pages
layout:     post
tags:       [hotspot, java, jvm, vm]
---

hotspot源代码学习，对象，part3, 标记字
================


>源代码版本openjdk-7u40-fcs-src-b43-26_aug_2013

标记字（mark word）的定义在[markOop.hpp][1]中，内容如下所示

    // Bit-format of an object header (most significant first, big endian layout below):
    //
    //  32 bits:
    //  --------
    //             hash:25 ------------>| age:4    biased_lock:1 lock:2 (normal object)
    //             JavaThread*:23 epoch:2 age:4    biased_lock:1 lock:2 (biased object)
    //             size:32 ------------------------------------------>| (CMS free block)
    //             PromotedObject*:29 ---------->| promo_bits:3 ----->| (CMS promoted object)
    //
    //  64 bits:
    //  --------
    //  unused:25 hash:31 -->| unused:1   age:4    biased_lock:1 lock:2 (normal object)
    //  JavaThread*:54 epoch:2 unused:1   age:4    biased_lock:1 lock:2 (biased object)
    //  PromotedObject*:61 --------------------->| promo_bits:3 ----->| (CMS promoted object)
    //  size:64 ----------------------------------------------------->| (CMS free block)
    //
    //  unused:25 hash:31 -->| cms_free:1 age:4    biased_lock:1 lock:2 (COOPs && normal object)
    //  JavaThread*:54 epoch:2 cms_free:1 age:4    biased_lock:1 lock:2 (COOPs && biased object)
    //  narrowOop:32 unused:24 cms_free:1 unused:4 promo_bits:3 ----->| (COOPs && CMS promoted object)
    //  unused:21 size:35 -->| cms_free:1 unused:7 ------------------>| (COOPs && CMS free block)

32位平台上，标记字中字段的长度、偏移如下所示([gist][3])，注意是按照大端序存储：

                    offset    length    description
    lock            0         2         
    biased_lock     2         1
    age             3         4
    cms             7         0
    hash            7         25
    epoch           7         2    

其中，lock字段共两位，其含义如下所示：

    00    当前对象已被加轻量级锁，markOop指针指向线程栈中的对实际象头
    01    当前对象未被加锁，当前markOop指向不同的对象头
    10    当前对象已被加重量级锁，对象头已被换出
    11    垃圾回收标记，用于标记当前对象已经无用






[1]:    http://hg.openjdk.java.net/jdk7u/jdk7u/hotspot/file/05fe7a87d149/src/share/vm/oops/markOop.hpp
[2]:    http://hg.openjdk.java.net/jdk7u/jdk7u/hotspot/file/05fe7a87d149/src/share/vm/utilities/globalDefinitions.hpp
[3]:    https://gist.github.com/caoxudong/8567764
---
category:   pages
layout:     post
tags:       [java, jvm, gc, c4]
---

《C4: The Continuously Concurrent Compacting Collector》笔记
=========================



> [《C4: The Continuously Concurrent Compacting Collector》][1]是Azul System公司发表一篇论文，对C4垃圾回收器做了介绍。这里对其中的一些内容做简单记录。另外，Eva Anderssion也写过一篇文中对C4进行介绍（参见[译文][2]）。

# 摘要

# 简介

> *   C4 is a Generational, Continuously Concurrent Compacting Collector algorithm.
> *   C4 differentiates itself from other generational garbage collectors by supporting simultaneous-generational concurrency: the different generations are collected using concurrent (non stop-the-world) mechanisms that can be simultaneously and independently active.
> *   All generations in C4 use concurrent compacting collectors and avoid the use of global stop-the-world operations, maintaining concurrent mutator operation throughout all phases of each generation. 

大部分的垃圾回收算法是stop-the-world式的（cms和g1的部分操作是stop-the-world式的），而随着jvm内存的增大，应用程序的暂停时间也会相应的增长（g1的一个主要特性是可以预估暂停时间）。因此，jvm内存的大小一般不会太大，因此“小内存，多实例”的部署模型被广为接受，但该模型增加维护成本，也浪费了一些系统资源。

先前，Azul System公司借助于定制的处理器和操作系统内核实现了“无暂停的垃圾回收（Pauseless GC）”，2010年，又发布了世界首款、基于x86平台的、纯软件实现的C4算法的商业实现。

目前来看，cms和g1都是“标记-清理”实现，而c4包含了“压缩”过程，可以有效的降低碎片带来的影响。

# c4算法

## lvb(load value barrier)

lvb是Pauseless GC算法中读屏障的具体实现。lvb要求每个对象引用在被载入到内存，并对修改线程（mutator）可见之前，都必须要遵守2项原则，即：

1.  所有未被标记的、可见的、已载入的引用，都要被垃圾回收器“安全的”标记；
2.  所有可见的、已载入的引用，都需要指向引用对象的正确位置。

如果lvb发现某个引用违反了上述规则，那就通知垃圾回收器对此进行修正，防止错误的引用被其他程序看到。

## 自愈（self healing）

由于lvb是在载入引用时发生作用，所以它不仅可以访问需要校验引用，还可以访问存储引用的内存地址。当lvb修正引用指向的时，会拷贝一份正确的地址到源地址中（就是原先存储引用的位置），这样，mutator就可以访问到正确的对象，而无需重复修复工作。

修复工作是在载入引用后立即执行的，然后，该引用才可以被其他线程、mutator访问。

## 引用元数据与NMT状态（Reference metadata and the NMT state）

NMT： Not Marked Through

c4会遍历堆中所有带有NMT状态的对象，如果与期望的状态不匹配，则触发lvb修正对象引用。

与通常意义上的pauseless垃圾回收算法不同，c4为堆上的每一代都维护了一个NMT的期望值。此外，在metadata中还包含了该引用所处的代信息（即该引用所指向的对象所处的代），这样lvb就可以更有效率对NMT状态进行校验。

如果在标记阶段，lvb发现某个带有NMT状态的、已载入的对象引用与其目标代（target generation）的当前期望状态（current expected state）不匹配，则lvb会将NMT状态修改为期望值，并记录下这个引用，以保证垃圾回收器可以正确的遍历这个引用。通过自愈机制，所指向的地址也得以修复。

## 页保护与并发重定位（Page protection and concurrent relocation）

正在进行压缩的页会被保护起来，当某个对象引用指向一个被保护中的页时会触发lvb，此时，lvb会接收引用所指向的对象的新位置，修正引用值，修复原先存储该引用的内存地址（即载入该引用的内存地址）的内容。如果触发了lvb的对象引用还没有完成重定位的话，则lvb会先协助完成对象重定位的操作，然后修正引用值，指向新的位置。

## Quick Release

Quich Release方法在Pauseless中被引入，后来Compressor做了些许修改。Quick Release方法使得JVM可以在GC循环完成之前就回收一部分内存。



[1]:    http://www.azulsystems.com/products/zing/c4-java-garbage-collector-wp
[2]:    /post/jvm_performance_optimization_4_c4_gc

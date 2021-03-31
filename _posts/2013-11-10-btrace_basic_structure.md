---
title:      Btrace基本流程图 
category:   blog
layout:     post
tags:       [btrace, java]
---

原文地址： <https://caoxudong818.iteye.com/blog/1388886>

BTrace是一个很好的监控工具，可以在不停机的情况下对正在运行中的系统进行监控，功能强大，对目标系统的影响较小。这里并不准备介绍BTrace的使用方法，重在通过源代码说明BTrace的工作原理，因此还没用过BTrace的童鞋请问谷老师。

下面的图BTrace的一些执行过程：

Client模式的基本执行过程：

![Figure 1 "Client Mode"][1]

编译BTrace脚本的基本过程：

![Figure 2 "Compile Script"][2]




[1]:    /image/btrace_process_fig1.png
[2]:    /image/btrace_process_fig2.png

---
title:      accuracy/precision/resolution/sensitivity的区别
layout:     post
category:   blog
tags:       [performance]
---

做性能测试时，一些测量工具所提供的相关指标会涉及到与精度、准度相关的描述，这里记录一下

# 概念表述

* accuracy

    准度，测量值与真实值之间的差值所达到的量级，例如秒，毫秒，表示了误差的大小。

* precision

    精度，多次测量后，各个测量值与平均值的差所达到的量级，例如秒，毫秒，表示测量值方差的大小

* resolution

    分辨率，表示理论上能测量到的数值变化的最小程度。

* sensitivity

    灵敏度，是个绝对值，表示能检测到的数值变化的最小值。反映了输入偏差和输出偏差的比值，即若较小的输入偏差会引发较大的输出偏差，则说明灵敏度较高

# 示例

`System.currentTimeMillis`方法，这个方式返回的时间单位是毫秒，但按照API文档的说法，其颗粒度取决于底层操作系统，实际情况可能会更大，例如有些操作系统衡量时间的单位是数十毫秒。

这里面，

* 准度，是指该方法能测量到毫秒级别的时间
* 精度，取决于底层操作系统，可能是几毫秒或数十毫秒
* 分辨率，指该方法能否测量到的最小时间单位是毫秒
* 敏感度，取决于底层操作系统，可能是几毫秒或数十毫秒

`System.nanoTime`方法，该方法返回那秒级别的时间，文档写到，该方法提供纳秒级别的准度，但未必能提供纳秒级别的分辨率，即两次测量的差值，未必能精度到几毫秒级别。

# Resources

[https://kb.mccdaq.com/KnowledgebaseArticle50043.aspx][1]
[https://zhuanlan.zhihu.com/p/47861140][2]




[1]:    https://kb.mccdaq.com/KnowledgebaseArticle50043.aspx
[2]:    https://zhuanlan.zhihu.com/p/47861140
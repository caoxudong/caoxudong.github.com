---
title:      Java中的currentTimeMillis和nanoTime
layout:     post
category:   blog
tags:       [java]
---

java中获取时间常用两种方法`System.currentTimeMillis`和`System.nanoTime`。文档中，对这两个方法的使用场景做了明确指定。

* `System.currentTimeMilllis`: 可以作为墙上时间使用，精度取决于底层操作系统，可能会达到数十毫秒。
* `System.nanoTime`: 不可用做墙上时间，只能用来测量时间流逝。提供了纳秒的准度，精度则未必。

从描述上看，做性能测试的话，还是用`System.nanoTime`方法更好些。

从实现上看，linux为例，`System.currentTimeMilllis`的值直接取自于函数`gettimeofday`的值。虽然`gettimeofday`可以得到微秒的准度，但经过换算后，只能达到毫秒的准度了，符合`System.currentTimeMilllis`方法文档的描述。此外，若是手动修改的系统时间，则函数`gettimeofday`会返回过去的值，连带`System.currentTimeMilllis`方法也会如此。

另一方面，`System.nanoTime`的利用高精度计时器来计算(`-lrt`，`librt.so.1`)时间流逝，准度可达纳秒，基于 **monotonic clock**的特性，即便手动修改时间，函数也不会返回过去的值，同时这个特性注定了，该函数只能用来测量时间流逝，不能用来表示墙上时间。当然，如果系统不支持 **monotonic clock**，还是会通过`gettimeofday`返回数值，此时准度退化为毫秒。
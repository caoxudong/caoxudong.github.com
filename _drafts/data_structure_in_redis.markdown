---
title:      redis中的数据结构
layout:     post
category:   blog
tags:       [algorithm, redis, cache]
---

>以下内容以redis 3.2.11为例，https://github.com/antirez/redis/tree/3.2.11

# 链表

## adlilst

https://github.com/antirez/redis/blob/3.2.11/src/adlist.h

双向链表。

用处: 

* 连接到redis的客户端列表
* 将要关闭的redis的客户端列表
* slave节点列表
* monitor列表
* 要执行写入操作的客户端列表
* 未被阻塞祝的客户端列表
* 准备好的key的列表
* 等待确认(ACK)的客户端列表

## quicklist，快速链表

https://github.com/antirez/redis/blob/3.2.11/src/quicklist.h

双向链表
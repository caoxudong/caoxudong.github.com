---
title:      一分钟小提示：uniq需要sort
layout:     post
category:   blog
tags:       [linux, shell, uniq, sort, one-minute-tips]
---

执行`uniq`命令前，需要先用`sort`命令做排序，否则很有可能`uniq`会失效，因为`uniq`只会对相邻的内容做合并。

>Linux manual
>
>Note:  'uniq' does not detect repeated lines unless they are adjacent.  You may want to sort the input first, or use 'sort -u' without 'uniq'.  Also, comparisons honor the rules specified by 'LC_COLLATE'.
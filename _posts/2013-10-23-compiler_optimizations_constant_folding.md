---
title:      编译器优化，part 1，常量折叠
category:   blog
layout:     post
tags:       [compiler, optimization]
---


wiki地址： [http://en.wikipedia.org/wiki/Constant_folding][1]

# 常量折叠

**constant folding，常量折叠**，编译器优化技术之一，通过对编译时常量或常量表达式进行计算来简化代码。以下面的代码为例：

    i = 320 * 200 * 32;

上面的代码中，编译器通常会在代码的[中间表示（Intemediate Representation）][2]（关于中间表示，《JRockit权威指南》中有示例对[代码生成过程][3]进行说明）中对该常量表达式进行计算，直接计算出`320 * 200 * 32`的值，而不会在此生成2个乘法指令。


# 常量传播

**constant propagation，常量传播**，编译器优化技术之一，可以在一段代码中，将表达式中的常量替换为相关表达式或字面量，再使用常量折叠技术来简化代码。示例代码如下：

    int x = 14;
    int y = 7 - x / 2;
    return y * (28 / x + 2);
    
    //常量传播
    
    int x = 14;
    int y = 7 - 14 / 2;
    return y * (28 / 14 + 2);
    
    //常量折叠
    
    int x = 14;
    int y = 0;
    return 0;

[1]:    http://en.wikipedia.org/wiki/Constant_folding
[2]:    http://en.wikipedia.org/wiki/Intermediate_representation#Intermediate_representation
[3]:    https://github.com/caoxudong/oracle_jrockit_the_definitive_guide/blob/master/chap2/2.6.md

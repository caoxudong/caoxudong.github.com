---
title:      编译器优化技术列表 
layout:     post
category:   blog
tags:       [compiler, optimization]
---

# common subexpression elimination

[wiki, https://en.wikipedia.org/wiki/Common_subexpression_elimination][1].

对代码中的重复表达式进行合并，以前少运算量。例如

    a = b * c + g;
    d = b * c * e;

可以被转换为

    tmp = b * c;
    a = tmp + g;
    d = tmp * e;

# copy propagation

[wiki, https://en.wikipedia.org/wiki/Copy_propagation][2]

将代码中的变量赋值替换到表达式中。例如

    y = x
    z = 3 + y

可以被转换为

    z = 3 + x

# Resources

* [wiki, common subexpression elimination][1]
* [wiki, copy propagation][2]



[1]:    https://en.wikipedia.org/wiki/Common_subexpression_elimination
[2]:    https://en.wikipedia.org/wiki/Copy_propagation
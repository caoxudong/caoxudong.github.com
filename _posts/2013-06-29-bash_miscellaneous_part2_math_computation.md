---
title:      bash 拾零， part 2 - 数学运算
category:   blog
layout:     post
tags:       [bash, shell]
---



# 基本计算方法

## 使用`$(())`

在shell中可以使用`$(())`进行数学运算。例如：

    #!/bin/bash
    
    a=1
    b=2
    
    echo $(($a % $b))
    

输出为：

    1
    

## NOTE

### 进制

bash中的数学计算是有进制的，默认为10进制。

*   变量数字若是以0开头，则表示为8进制
*   变量数字若是以0x开头，则表示为16进制

在计算时可以指定所使用的进制：

    #!/bin/bash
    
    a=23
    b=3
    
    echo $(($a/$b))
    echo $((8#$a/$b))
    

输出结果为：

    7
    6

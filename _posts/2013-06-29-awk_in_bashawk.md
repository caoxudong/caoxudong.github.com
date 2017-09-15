---
title:      在awk程序中使用单引号
category:   blog
layout:     post
tags:       [awk, bash, shell]
---



# 在awk程序中使用单引号

示例代码如下：

    uname -a | awk -F ' ' -v single_quote="'" '
        BEGIN {str=""} 
        {
            for (i=1; i<NF; i++) { 
                str = str single_quote $i single_quote;
            }
        } 
        END {print str}
    '
    

输出如下：

    'Linux'
    'a01.flash.test.qingdao.yoqoo'
    '2.6.18-308.el5'
    '#1'
    'SMP'
    'Tue'
    'Feb'
    '21'
    '20:06:06'
    'EST'
    '2012'
    'x86_64'
    'x86_64'
    'x86_64'

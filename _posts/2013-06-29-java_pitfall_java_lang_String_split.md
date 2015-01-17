---
title:      java.lang.String#split
category:   blog
layout:     post
tags:       [java]
---


# split函数

split函数一种重载方式的定义如下：

    public String[] split(String regex, int limit)
    

其中，limit表示模式会匹配几次，并影响最后得到的数组元素的个数。

     * <p> The <tt>limit</tt> parameter controls the number of times the
     * pattern is applied and therefore affects the length of the resulting
     * array.  If the limit <i>n</i> is greater than zero then the pattern
     * will be applied at most <i>n</i>&nbsp;-&nbsp;1 times, the array's
     * length will be no greater than <i>n</i>, and the array's last entry
     * will contain all input beyond the last matched delimiter.  If <i>n</i>
     * is non-positive then the pattern will be applied as many times as
     * possible and the array can have any length.  If <i>n</i> is zero then
     * the pattern will be applied as many times as possible, the array can
     * have any length, and trailing empty strings will be discarded.
    

注释中说道：

*   如果n大于0，则模式最多会匹配n-1次，则结果中元素的个数不会大于n，最后一个元素会包含分隔符之后所有的内容
*   如果n是非正数，则模式会尽可能多的匹配
*   如果n=0，则模式会尽可能多的匹配，<font color="red">但如果原字符串以分隔符结束，则会将本应分离出的、最后一个的空字符串会被抛弃掉</font>

注意红字部分，参见下面的示例：

    String a = "2#3#4#";
    System.out.println(a.split("#").length);
    输出为3
    
    String a = "2#3#4#";
    System.out.println(a.split("#", -1).length);
    输出为4
    

另外需要注意的split函数的另一个重载函数

    public String[] split(String regex) {
        return split(regex, 0);
    }
    

这个0的设置，太不和谐。

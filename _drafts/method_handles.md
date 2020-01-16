---
title:      Java中的MethodHandle
layout:     post
category:   blog
tags:       [java, jvm]
---

>以下内容基于JDK8

# what

>A method handle is a typed, directly executable reference to an underlying method, constructor, field, or similar low-level operation, with optional transformations of arguments or return values. These transformations are quite general, and include such patterns as conversion, insertion, deletion, and substitution.
>
>Method handles are dynamically and strongly typed according to their parameter and return types. They are not distinguished by the name or the defining class of their underlying methods. A method handle must be invoked using a symbolic type descriptor which matches the method handle's own type descriptor.

[API文档][1]对`MethodHandle`的定义是，一个 **动态的**，**强类型的**，**可直接执行的**，**对底层方法实现**的 **引用**。`MethodHandle`之间不以方法的名字或声明方法的类来区别，而是以方法的`MethodType`（包括参数类型和返回值类型）来区别。

其中：

* **动态的**: 类型检查发生在首次调用时
* **强类型的**: 不支持自动类型转换
* **可直接执行的**: 通过`MethodHandle#invoke`方法族来调用底层方法
* **对底层方法实现**: `MethodHandle`本身并不包含具体的方法实现
* **引用**: 顾名思义，是个引用。

# why





# Resources

* [API Reference][1]
* [JSR 292 Cookbook][2]





[1]:    https://docs.oracle.com/javase/8/docs/api/java/lang/invoke/MethodHandle.html
[2]:    http://cr.openjdk.java.net/~jrose/pres/200906-Cookbook.htm



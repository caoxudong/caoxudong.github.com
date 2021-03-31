---
title:      AVM2 Overview学习笔记1 -- AVM2基本结构
category:   blog
layout:     post
tags:       [note, flash, avm]
---


>组里的同事都是用flash的，所以哥也得学学flash才能有共同语言。本来就对虚拟机比较感兴趣，所以呢，哥准备学学avm2，努努力，争取做个自己的avm出来，哪怕矬一点也好。当然，这个东西只能作为业余爱好或是玩具，不应该占据太多的时间和精力。在网上搜了搜，adobe放出来的资料还真是少，官网上有两篇，"[AVM2 Overview][1]"和"[SWF File Format Specification][2]"。先从AVM2 Overview开始看吧，了解一下AVM2的基本概念。

# 基本概念

*   Virtual Machine: 以ABC文件为输入,执行其中所描述的计算过程.ABC文件中是编译后的代码,其中包含了常量数据AVM2的指令集和各类元数据.(A virtual machine is a mechanism that takes as its input the description of a computation and that performs that computation. For the AVM2, the input is in the form of an ABC file, which contains compiled programs; these comprise constant data , instructions from the AVM2 instruction set, and various kinds of metadata. )
*   Script: 初始化方法和指令集合,记录原始代码.(A script set of traits and an initializer method; a script populates a top-level environment with definitions and data.)
*   Bytecode, code: 运行在AVM2上的字节码.(Bytecode or code is a specification of computation in the form of a sequence of simple actions on the virtual machine state. )
*   Scope: 貌似是一种映射,类似于map,可以嵌套使用,现在还不知道是啥,后续再说.(scope是 Scope is a mapping from names to locations, where no two names are the same. Scopes can nest, and nested scopes can contain bindings (associations between names and locations) that shadow the bindings of the nesting scope. )
*   Object: AS3中对象是属性的无序集合,类似于map。 (An object is an unordered collection of named properties, which are containers that hold values. A value in ActionScript 3.0 is either an Object reference or one of the special values null or undefined. )
*   Namespace: 命名空间,AS3中类是有包名的,不知道为啥还需要命名空间.(Namespaces are used to control the visibility of a set of properties independent of the major structure of the program. )
*   Class:类.( A class is a named description of a group of objects. Objects are created from classes by instantiation . )
*   Inheritance: 实例.(New classes can be derived from older classes by the mechanism known as inheritance or subclassing . The new class is called the derived class or subclass of the old class, and the old class is called the base class or superclass . )
*   Trait: 特征(姑且这么叫),是所有对象都共有的属性,类似于Java中Object对象中的方法和属性.(A trait is a fixed-name property shared by all objects that are instances of the same class; a set of traits expresses the type of an object. )
*   Method: 方法，这里有两层意思，一是指方法体本身，作为一个对象包含了代码和数据，二是方法闭包（“闭包”这个词真是纠结），包含了方法体和创建方法体所在的执行上下文。（The word method is used with two separate meanings. One meaning is a method body, which is an object that contains code as well as data that belong to that code or that describe the code. The other meaning is a method closure, which is a method body together with a reference to the environment in which the closure was created. In this document, functions, constructors, ActionScript 3.0 class methods, and other objects that can be invoked are collectively referred to as method closures. ）
*   Verification: 在将ABC文件载入到AVM2中之前，要先对文件进行校验，如果不符合规范的话，会拒绝载入。（The contents of an ABC file undergo verification when the file is loaded into the AVM2. The ABC file is rejected by the verifier if it does not conform to the AVM2 Overview. Verification is described in Chapter 3. ）
*   Just-in-Time (JIT) Compiler: 即时编译，可选，将AVM2指令转换为本地代码。（AVM2 implementations may contain an optional run-time compiler for transforming AVM2 instructions into processor-specific instructions. Although not an implementation requirement, employing a JIT compiler provides a performance benefit for many applications.）

# AVM基本结构

## 常量数值

*   int, 32位有符号整型数，-2,147,483,648 to 2,147,483,647 (-2^31 ~ 2^31-1)
*   uint, 32位无符号整型数，0 to 4,294,967,296 (2^32)
*   double, 64位双精度浮点数，以IEEE Standard for Binary Floating-Point Arithmetic为标准
*   string, UTF-8编码的字符序列，最长长度为2^30-1
*   namespace，将URI（内部表示为string）绑定到某个trait上，这种绑定是单向的，即namespace只能有一个URI。这里对namespace还不太了解。（Namespaces tie a URI (represented internally by a string) to a trait. The relationship is unidirectional, meaning the namespace data type only contains a URI. Each namespace is also of a particular kind, and there are restrictions regarding the relationships between the trait and kind. These rules are defined later in this chapter. ）
*   null， 一个*单例值*，表示“没有对象”
*   undefined， 一个*单例*值，表示“没有意义的值”，该值只能在特定的上下文中使用。

## 概述

AVM2中的计算是基于方法信息（method information）、局部数据区、常量池和堆上下文中的方法体代码进行的。

*   方法体中的代码由AVM2指令集构成
*   方法信息决定了方法的使用方式
*   方法的局部数据区包含操作数栈、作用域栈（scope stack）和局部寄存器（local register） 
    *   作用域栈是运行时上下文的一部分，其中保存了当AVM2执行*name lookup*指令时需要搜索的对象。当执行异常处理、闭包创建和AS3中的with语句时会向作用域栈中推入元素
    *   局部寄存器保存了参数值、局部变量
*   常量池中保存了指令流中引用到的常量数值：数字、字符串和各种名字
*   程序运行期间创建的对象分配与堆上，这些对象最终由AVM2回收
*   运行时上下文中包含了一个对象链，当在运行时查找命名属性时，会沿着该对象链从最近处（最新push到对象链中的对象）到最远处（全局对象）逐个查找对象中是否有命名属性 
    *   （这不是基于原型的继承么？）

## 名字

名字在AVM中的表示是一个非限定名（*an unqualified name*）与一个或多个命名空间(*namespaces*)的组合，它们统称为*multinames*。multinames中通常包含一个命名索引和一个或多命名空间索引。某些multinames会在运行时对名字和命名空间进行解析。对象中属性的命名是简单的QName(Qulified name)。RTQName、RTQNameL和MultinameL统称为运行时multinames。

### QName(Qualified Name)

multiname的最简单形式，由一个名字索引，后跟一个命名空间索引构成。其中名字索引指向字符串常量池中的位置，命名空间索引指向命名空间常量池中的位置。QName常用于表示变量和类型注解：

    public var s : String; 
    

上面的代码包含两个QName，分别是变量s(namespace: public, name: s)和类型String(namespace: public, name: String)

### RTQName (Runtime Qualified Name)

RTQName是运行时QName，命名空间直到运行时才会解析。RTQName只有一个名字索引，指向字符串常量池中的位置。当RTQName是字节码的操作数时，那么在操作数栈上应该会有一个命名空间供RTQName使用。

RTQName常用于那些在编译时无法确定命名空间的限定名：

    var ns = getANamespace(); 
    x = ns::r;
    

上面的代码会产生一个RTQName，`ns::r`，这里名字是`r`，并将命名空间`ns`推入到栈中。

### RTQNameL (Runtime Qualified Name Late)

命名空间和名字都是在运行时才确定的QName。

当以RTQNameL作为字节码的操作数时，需要将名字和命名空间都推入操作数栈，其中名字的类型必须是String，命名空间的类型必须是Namespace。

    var x = getAName(); 
    var ns = getANamespace(); 
    w = ns::[x]; 
    

上面的代码生成了一个RTQNameL，`ns::[x]`。

### Multiname (Multiple Namespace Name)

由一个名字和一个命名空间集合组成。Multiname常用于非限定名。

    use namespace t; 
    trace(f);  
    

上面的代码产生了一个Multiname，`f`，其名字是`f`，其命名空间集合包含了所有开放命名空间（public，t，以及当前运行上下文中的所有private和internal命名空间）。在运行时，命名空间集合中的任何一个都可以解析`f`。

### MultinameL (Multiple Namespace Name Late)

编译时名字未知的Multiname。

    use namespace t; 
    trace(o[x]); 
    

### 解析multiname

一般情况下，解析multiname时的搜索顺序如下：

1.  对象中生命的特征；
2.  对象的动态属性；
3.  原型链。

不过，只有当nultiname中包含public命名空间时，才会对动态属性和原型链进行搜索。

## 方法调用

> When invoking a method in the AVM2, the first argument is always the “this” value to be used in the method. All methods take at least 1 argument (the “this” value), followed by any declared arguments.

（难道AS3中静态方法也是这样的么？）

> When invoking the [[Call]] property, the behavior is different for different types of closures. A closure is an object that contains a reference to a method, and the [[Call]] property acts differently depending on whether it is a function, method, or class closure. A function closure is one that is of a global method that isn't associated with any instance of a class. A method closure contains an instance method of a class, and will always remember its original “this” value.

这里说道，当调用`[[Call]]`属性时，所产生的行为会因为行为主体的不同而有所区别。代码示例：

    function f(){} 
    var a = f;  // a is a function closure 
    
    class C{ 
        function m(){} 
    } 
    var q = new C(); 
    var a = q.m;  // a is a method closure
    

总结来说：

1.  如果调用的闭包是一个函数闭包（function closure），则传递给`[[Call]]`的第一个参数与传给该函数的第一个参数相同，均为`this`；如果第一个参数的值为`null`或`undefined``，则使用全局对象作为`this`的指向。
2.  如果调用的闭包是一个方法闭包，那么传给`[[Call]]`的第一个参数会被忽略，而`this`值会被传给方法作为第一个参数。
3.  如果调用的闭包是一个类闭包，并且对`[[Call]]`的调用存在一个参数，则本次调用被认为是类型转换，而参数会被强制转换为闭包所表示的类。

## 字节码指令小结

一些指令前缀：

    _b(Boolean), _a(any), _i (int), _d(double), _s(string), _u(unsigned), _o(object)

操作局部变量区的指令：

    getlocal, getlocal0, getlocal1, getlocal2, getlocal3, setlocal , setlocal0, setlocal1, setlocal2, setlocal3

数学运算指令：

    increment, increment_i, inclocal, inclocal_i, add, add_i, decrement, decrement_i, declocal, declocal_i, subtract, subtract_i, multiply , multiply_i, divide, modulo, negate, negate_i, equals, strictequals, lessthan, lessequals, greaterthan, greaterequals, istype, istypelate, in

位运算指令：

    bitnot, bitand, bitor, bitxor, lshift, rshift, urshift

类型转换指令：

    coerce, convert_b, coerce_a, convert_i, convert_d, coerce_s, convert_s, convert_u, convert_o

对象操作指令：

    newclass, newobject, newarray, newactivation， construct, constructsuper, constructprop， dxns， dxnslate

栈操作指令：

    pushnull, pushundefined, pushtrue, pushfalse, pushnan, pushbyte, pushshort, pushstring, pushint, pushdouble, pushscope, pushnamespace， pop, dup, swap

流转控制指令：

    iflt, ifle, ifnlt, ifnle, ifgt, ifge, ifngt, ifnge, ifeq, ifne, ifstricteq, ifstrictne, iftrue, iffalse, label, lookupswitch

方法调用指令：

    call, callmethod, callstatic, callproperty, callproplex, callpropvoid, callsupervoid, callsuper

异常处理指令:

    throw

调试指令：

    debugfile, debugline, debug

to be continued...

[1]:    https://www.adobe.com/content/dam/Adobe/en/devnet/actionscript/articles/avm2overview.pdf
[2]:    https://wwwimages.adobe.com/www.adobe.com/content/dam/Adobe/en/devnet/swf/pdf/swf_file_format_spec_v10.pdf

---
title:      Java中的Lambda表达式的实现
layout:     post
category:   blog
tags:       [lambda, java, jvm]
---

# 1 什么是lambda表达式

wiki, [匿名函数][14]

## 1.1 目标类型

相同的lambda表达式可以有不同的目标类型，例如

* Callable<String> c = () -> "done";
* PrivilegedAction<String> a = () -> "done";

## 1.2 函数式接口

* 接口中除default方法外，只有一个抽象方法的接口，即为函数式接口
* FunctionalInterface只是个可选标记，帮助编译器发现问题
* 保证了向下兼容，以往代码中定义的接口，都可以成为函数式接口

## 1.3 捕获(capturing)/非捕获(non-capturing)

* 捕获: lambda表达式中访问外部变量
* 非捕获: lambda表达式中无需访问外部变量，可以优化为静态方法调用

jdk7引用外部变量时，必须是final的，jdk8时，只要实际上是final的就行，即即使没在变量上添加final声明，也不会引发编译错误.

## 1.4 方法引用

* 使用"::"操作符获取方法引用
* 静态方法
* 特殊对象的成员方法: 捕获对象的实例变量
* 特殊类型的任意对象的成员方法
* 方法的类型参数可以通过类型推导得出，或者放在"::"之后来指定
    * Function<Integer[], Integer[]> toArray = integers::<Integer>toArray;

方法引用与反射的区别

* 方法引用减少了权限检查
* 方法引用不能突破访问权限控制

# 2 实现lambda的几种方法

* 内部类
* 转化当前类的方法（实例方法/静态方法，取决于是否捕获了当前实例的成员）
* 引入新的结构化函数类型，例如"根据string和object计算出int"的类型`(string, object) -> int`

## 2.1 使用内部类

使用内部类一样可以实现lambda，编译器针对函数式接口，生成一个内部实现类，再将lambda的内容拷贝到内部实现类的方法中即可。

那么jdk为什么没有这样实现？

缺点

* 需要加载内部类，造成启动变慢，影响性能： （解压jar，读取类文件，解析字节码等）
* 增加内存消耗： code cache, metaspace, heap, stack
* 发展受限：使用内部类会lambda被绑定到使用字节码生成内部类这种机制上，限制了lambda在将来的进化，进而限制了jvm的进化

内部类会持有外部类的引用，以便访问外部类的数据，容易造成内存泄漏，而非捕获的lambda则不会持有外部类的引用

## 2.2 转化为当前类的方法



## 2.3 引入新的结构化函数类型

* 增加了类型系统的复杂度，将来还需要处理函数类型和普通类型混合的问题
* 这会导致库函数风格分离：老代码使用回调接口，新代码使用结构化函数类型
* 结构化函数类型的语法会很笨重，尤其是要处理检查异常（checked exception）的时候
* 运行时，很难针对不同的结构化函数类型，给出不同的运行时表示，即难以重载带有结构化函数类型的方法，例如m(T->U)和m(X->Y)



# translation

## lambda -> static method

    class A {
        public void foo() {
            List<String> list = ...
            list.forEach( s -> { System.out.println(s); } );
        }
    }

    class A {
        public void foo() {
            List<String> list = ...
            list.forEach( [lambda for lambda$1 as Block] );
        }

        static void lambda$1(String s) {
            System.out.println(s);
        }
    }

## lambda -> static method, with capturing effectively final field

    class B {
        public void foo() {
            List<Person> list = ...
            final int bottom = ..., top = ...;
            list.removeIf( p -> (p.size >= bottom && p.size <= top) );
        }
    }

    class B {
        public void foo() {
            List<Person> list = ...
            final int bottom = ..., top = ...;
            list.removeIf( [ lambda for lambda$1 as Predicate capturing (bottom, top) ]);
        }

        static boolean lambda$1(int bottom, int top, Person p) {
            return (p.size >= bottom && p.size <= top;
        }
    }

## 可变参数

需要进行桥接，有编译器创建桥接方法

方法引用所指向的方法带有可变参数，而要转换成的函数式接口是固定参数，则需要编译器生成一个桥接方法，完成转换。

    interface IIS {
        void foo(Integer a1, Integer a2, String a3);
    }

    class Foo {
        static void m(Number a1, Object... rest) { ... }
    }

    class Bar {
        void bar() {
            SIS x = Foo::m;
        }
    }

    class Bar {
        void bar() {
            SIS x = indy((MH(metafactory), MH(invokeVirtual IIS.foo),
                        MH(invokeStatic m$bridge))( ))
        }

        static private void m$bridge(Integer a1, Integer a2, String a3) {
            Foo.m(a1, a2, a3);
        }
    }

# adaptation

* 去掉语法糖之后的lambda方法，(A1..An) -> Ra，这里的lambda方法是一个捕获成员变量的方法，第一个参数是接收者
* 函数式接口的类型： (F1..Fm) -> Rf，这里没有接收者参数
* factory site的动态参数列表： (D1..Dk)

则，必然存在`k+m == n`

将lambda方法的参数(A1..An)划分为(D1..Dk H1..Hm)，其中(D1..Dk)为动态参数，(H1..Hm)是函数式接口的参数.

设i=1..n，Hi对于Fi是可适配的，Ra对于Rf是可是配的，则当满足下面的条件之一时，类型T对于类型U是可是配的：

* T == U
* T是原生类型，U是引用类型，T可经过装箱转换为U
* T是引用类型，U是原生类型，T可经过拆箱转换为U
* T和U是原生类型，T可经过类型提升转换为U
* T和U是引用类型，T可经过类型扩展转换为U

适配由metafactory在链接时校验，在运行时执行。

# Metafactory variants

* 简单版：支持非序列化lambda，非序列化的静态的或非绑定的成员方法引用
* 复杂版：支持序列化lambda，和各种类型的方法引用
* 究极版：支持任意类型的lambda

可序列化的lambda对象需要提供额外的参数给metafactory，才能完成重建静态/动态的参数列表，会带来性能损耗：
* 实现类中添加额外的域
* 额外的构造方法和初始化
* lambda表达式转换策略的限制：例如不能使用方法句柄代理，因为结果对象并不会实现writeReplace方法

为了避免将性能损耗带给所有的lambda，因此针对不同情况，使用了不同的lambda metafactory.

# Glossary

* natural signature: 编译器根据lambda表达式推断出的函数签名，包括参数类型、返回值类型和异常声明
* lambda descriptor: 对lambda函数做类型擦除之后的描述形式
* lambda object: lambda factory返回的，实现了函数式接口，并且捕获了lambda行为的对象

# Resource

* [Lambda Expressions][1]
* [Java SE 8: Lambda Quick Start][2]
* [Java 8 Lambdas - A Peek Under the Hood][3]
* [Translation of Lambda Expressions][4]
* [JDK8: Lambda Performance Study][5]
* [JVMLS 2013: Lambda Performance][6]
* [Implementing lambda expressions in Java][7]
* [OpenJDK Lambda Project][8]
* [State of the Lambda][9]
* [State of the Lambda: Libraries Edition][10]
* [State of the Lambda - final][11]
* [State of the Lambda: Libraries Edition - final][12]
* [Lambda FAQ][13]
* [Anonymous function][14]





[1]:    https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html
[2]:    http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/Lambda-QuickStart/index.html
[3]:    https://www.infoq.com/articles/Java-8-Lambdas-A-Peek-Under-the-Hood
[4]:    http://cr.openjdk.java.net/~briangoetz/lambda/lambda-translation.html
[5]:    http://www.oracle.com/technetwork/java/jvmls2013kuksen-2014088.pdf
[6]:    http://video.oracle.com/detail/videos/featured-videos/video/2623576348001
[7]:    http://wiki.jvmlangsummit.com/images/7/7b/Goetz-jvmls-lambda.pdf
[8]:    http://openjdk.java.net/projects/lambda/
[9]:    http://cr.openjdk.java.net/~briangoetz/lambda/lambda-state-4.html
[10]:   http://cr.openjdk.java.net/~briangoetz/lambda/sotc3.html
[11]:   http://cr.openjdk.java.net/~briangoetz/lambda/lambda-state-final.html
[12]:   http://cr.openjdk.java.net/~briangoetz/lambda/lambda-libraries-final.html
[13]:   http://www.lambdafaq.org/
[14]:   https://en.wikipedia.org/wiki/Anonymous_function
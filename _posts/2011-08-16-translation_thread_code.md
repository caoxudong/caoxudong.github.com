---
category:   pages
tags:       [interpreter, translation]
layout:     post
---



转载：翻译《Threaded Code》
=========================



[原文地址][2]

[原英文地址][1]

找到一篇关于threaded code的文章，很遗憾，没太看懂，仍没有弄明白什么是threaded code。 请看懂的朋友指点。 翻译如下，文章后面引用部分没有翻译。

# **1 为什么要用Threaded Code？**

Threaded Code是实现虚拟机解释器的一种技术。解释器的实现方法有很多种，较为流行的有以下几种：

*   直接解释字符串；
*   编译为树状结构（典型的，如语法树），并解释这棵树；
*   编译到虚拟机中，并解释虚拟机代码。 如果你对运行性能比较关注，那么执行虚拟机编码的方法是比较好的（因为获取并解码比较简单，因此执行起来也比较快）。如果你对运行的性能并不是那么关注，那么你也不妨关注下使用虚拟机的实现方法，因为相比于其他方法并没有复杂多少。 Threaded Code，就其本意来说，只是一种实现虚拟机解释器的技术。至少，在Forth社区中，几乎所有用来实现Forth虚拟机的技术都会被冠以“threading”的标签。 

# **2 什么是Threaded Code？**

下面来看一下包含了虚拟机指令A、B、C的代码片段。我们可以编写出机器级子程序Ar、Br、Cr来执行虚拟机指令的动作。然后，就可以编写出下面的机器码来执行虚拟机指令：

    call Ar
    call Br
    call Cr
    

这就是“subroutine-threaded code”，尽管在原始意义上，它并不是“threaded code”。事实上，subroutine threading并不是一种解释性技术。 现在，咱们去掉call指令:

    Ar
    Br
    Cr
    

这样就成了表示虚拟机指令的代码地址的序列。 这样，我们无法通过掉转到其开始处来执行这段代码。我们还需要跟踪指向某个寄存器中的当前指令的指针（并不是使用处理器的程序计数器寄存器，而是返回地址栈/寄存器）。 那我们如何执行下一条指令呢？让我们假设指令指针寄存器指令指针寄存器（ip）总是指向跟在当前代码指令字后面的代码序列的字上。然后，我们只需要载入这个字，跳转到它所指的位置，并将指令指针寄存器加1。例如，在MIPS汇编语言中，有如下代码：

    lw   $2,0($4) #get next instruction, $4=inst.ptr.
    addu $4,$4,4  #advance instruction pointer
    j    $2       #execute next instruction
    #nop          #branch delay slot
    

这段例程是一个解释器的相关代码（Forth社区的aka内部解释器），也就是NEXT例程。在每个虚拟机指令例程的末尾都会有一段这样的代码的拷贝，或者是各个虚拟机指令例程共享同一个NEXT例程的拷贝，然后跳转到这个地方。在现代的处理器中，共享NEXT例程不仅会浪费一次跳转，还可能会大幅增加分支预测错误率。因此，并不推荐这样做。 上面描述的方法称为“direct threaded code”。 注意，相比于一些流行的言论，“subroutine threading”通常会比“direct threaded code”慢一些。但是这正是本地代码生成的起始点。

# 3 Threading技术

## 3.1 Indirect Threaded Code 让我们考虑下常量。他们可以使用虚拟机指令lit来表示，后跟常量的具体值。如果常量的使用很频繁，则使用虚拟机指令具有较好的空间效率。但是，常量的使用较少，那么虚拟机指令的代码就比较相似。所以，我们希望可以共享同一段代码，指向不同的数据。 为了达到这个目标，我们可以在NEXT例程中添加一个间接层级，即“Indirect Threaded Code”。每个字（虚拟机指令的一般化）都有一个代码字段和一个参数字段。例如，下面的常量：

    code-field:      
    docon #code address of shared CONstant code
    parameter-field:  
    value #value of constant
    

现在，虚拟机代码由一个代码字段的地址的序列组成，而不再是代码地址了。简单虚拟机指令就会使如下的形式：

    code-field2:       parameter-field2
    parameter-field2:  code #machine code of the primitive
    

在这段MIPS汇编语言中，“Indirect Threaded Code”的NEXT例程如下所示：

    lw   $2,0($4) #get the code-field address of the next word, $4=inst.ptr.
    #nop          #load delay slot
    lw   $3,0($2) #get the code address of the word
    addu $4,$4,4  #advance instruction pointer
    j    $3       #execute code for the word
    #nop          #branch delay slot</pre>   next指令的代码会从$2的代码字段中计算出参数字段。 
    

## 3.2 Forth and Direct Threading

传统上讲，Forth是使用“indirect threaded”实现的，但是，与“direct threaded”的Forth实现由很多相通之处，如非原语指令会有一个代码字段，但它包含的是一个跳转而不是一个地址。在大多数处理器中，这种跳转会比传统的“indirect threaded”实现消耗更多的时间。因此，“direct threaded”只用在运行原语指令的情况下。在486上，会有2%~8%的速度提升。 注意，在奔腾、K5和K6处理器上，混合代码和数据是非常耗时的操作，因此，在这种处理器上，“direct threaded”会运行得更慢。

## 3.3 Token Threaded Code Direct threaded code

无法简单的在不同的机器中间传输，因为它包含了代码地址，而不同机器上的代码地址并不相同。而Token threaded code则使用了修正过的虚拟机指令编码，达到了代码的可移植性，唯一的代价是在每个NEXT例程中需要查询一次映射表，该映射表会将指令符号和代码地址相关联。“indirect threading”和“token threading”是一种正交的关系，所以它们可以整合为“indirect token threading”（会有一个更慢的NEXT例程）。

## 3.4 其他一些名词

*   Switch Threading:  一种在编程语言（如C语言）中实现虚拟机解释器的方法。
*   Call Threading:  在C语言中使用的另一种方法。
*   Segment Threading: </span>8086体系结构中使用的一种技术。这里的代码中包含的是段的序列，而不是代码地址的序列。这样就可以使用8086的整个地址空间，即16位指针的全部范围，但是，要求每个字都要以16字节对齐。
*   Native Code: 这并不是一项线程技术。该名词在Forth社区或其他一些地方用来说明这样一种实现，即生成机器码来替代解释器代码。简单的本地代码系统会以“subroutine-threaded code”开始，然后会对代码进行内联及优化操作。与“true compiler”“just-in-time compiler”等名词相关。
*   Byte Code: 每个虚拟机指令都使用一个字节表示，这可以认为是“token threading”的变化体。

# 4 如何实现可移植的Threaded Code？

许多编程语言并没有提供实现间接跳转的方法，所以他们无法实现直接或间接的Threaded Code。本节中会展示一些可用的选项。更多详细内容参见。 下面要展示的是与direct threading相关的变种。在NEXT例程中添加一个间接操作来实现indirect threading版本。

## 4.1 GNU　C的标签

这是GNU C对标准C的一个扩展，也是当前threaded code实现方法中可以执行最好的。FORTRAN语言中一个与之相似的特性是可计算goto。在GNU C中，direct threaded NEXT与下面的代码类似：

    typedef  void *Inst;
    Inst *ip;    /* you should use a local variable for this */
    #define NEXT  goto  **ip++
    

## 4.2 后继式传递（Continuation-passing style，CPS）

在CPS中，所有的调用都是尾调用，可以执行尾调用优化，转化为跳转操作。因此我们可以在语言编译器或解释器的实现中将threaded code的间接跳转实现为间接尾调用。在C语言中，direct threading可以以下面的方式实现：

    typedef void (* Inst)();
    void inst1(Inst *ip, /* other regs */)
    {
        ...
        (*ip)(ip+1, /* other registers */);
    }
    

## 4.3 Switch Threading Switch Threading

使用了C语言的switch语句，与token threaded code具有相同的优点，而缺点则是更慢的执行速度，因为大部分C语言编译器都会为switch语句执行范围检查。在当前CPU中，造成switch threading性能缺陷的主要原因是它使用了一个共享的间接分支，这会导致现代CPU上的间接分支预测中使用的BTB（branch target buffer）上产生100%的分支预测失败。而在分离的NEXT例程中的threaded code仅有50%的预测失败的几率。C语言中switch threading代码与下面类似：

    typedef enum {
        add /* ... */
    } Inst;
    
    void engine()
    {
        static Inst program[] = { inst1 /* ... */ };
    
        Inst *ip;
    
        for (;;)
            switch (*ip++) {
            case inst1:
            ...
            break;
            ...
        }
    }
    

分离的NEXT例程、BTB中预测失败和增强性能这些目标可以通过重复switch语句来实现，如下所示：

    typedef enum {
        add /* ... */
    } Inst;
    
    void engine()
    {
        static Inst program[] = { inst1 /* ... */ };
    
        Inst *ip;
    
        switch (*ip++) {
        case inst1: goto label1;
            ...
        }
    
        label1:
        ...
        switch (*ip++) {
        case inst1: goto label1;
            ...
        }
        ...
    }
    

## 4.4 Call Threading Call Threading

使用了间接调用来替代间接跳转。对每个调用来说，都必须有一个返回，这样调用方法的耗费就是使用返回值序列的耗费，而不是跳转序列的耗费。 此外，每个虚拟机指令都是一个函数。这看起来优雅，且允许各自编程，但是这也意味着全局变量将由虚拟机寄存器使用，大部分编译器都会在内存中进行分配。相比之下，对于switch threading，你会使用局部变量，可以在寄存器中分配。 Call threading代码如下所示：

    typedef void (* Inst)();
    
    Inst *ip;
    
    void inst1()
    {
        ...
    }
    
    void engine()
    {
        for (;;)
        (*ip++)();
    }

[1]:    http://www.complang.tuwien.ac.at/forth/threaded-code.html
[2]:    http://caoxudong818.iteye.com/blog/1150046

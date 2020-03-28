---
title:      Java检查子类型关系的实现
layout:     post
category:   blog
tags:       [java, hotspot]
---

Java代码中经常涉及到的是检查两个类之间的继承关系，因此其实现方式将会对程序的整体性能代码较大影响。

以`A instanceof B`来说，最简单的实现方式是将父类、父接口放在一维数组中，再遍历一遍。这种方式实现简单，但是性能不咋地。

在hotspot中的实现方式是将父类和父接口区分开，较深的继承关系和较浅的继承关系区分开，针对"较浅的父类继承"做优化，其余情况（接口继承和较深的父类继承）则通过线性扫描处理:

1. 保存有限深度的继承树，继承关系的深度从0开始计算，`Object`类的继承深度为0，其余各类按继承层级做加1处理。由于java是单根继承，因此若是两个类具有继承关系，且继承关系较浅，则父类会存在于子类的继承树里
2. 对于其他情况，最终需要通过扫描子类的完整继承树。
    
在扫描子类的完整继承树之前，可以做一些优化判断，剔除明显不需要扫描继承树的情况

1. `B`本身的继承深度浅，且`A`没有继承`B`
2. `A` == `B`

除却以上情况，再进行完整继承树的扫描。这种处理方式，能够较好的应对绝大部分应用场景。第2种情况好说，下面专门说说第1种情况。

从具体实现上看，hotspot定义了两种类型：

* **restricted primary class**
    * 若`T`表示 **类** **原生类型数组** 或 **原生类型包装类数组** 数组时，并且`T`的继承树深度小于 **指定阈值**时，则称`T`为 **restricted primary class**
* **restricted secondary type**: 
    * 除了 **restricted primary class**之外的，都是 **restricted secondary type**

定义类的数据结构如下(这里去掉了与本主题无关的字段):

    jint _primary_super_limit = 8

    class Klass {
        juint           _super_check_offset;        
        Klass*          _secondary_super_cache;
        Array<Klass*>*  _secondary_supers;
        Klass*          _primary_supers[_primary_super_limit];
        Klass*          _super;
    }

其中变量`_primary_super_limit`表示有限继承树的深度。变量`_super_check_offset`在两种类型下表示不同的含义。

* **restricted primary class**: 表示当前类型在有限继承树中的索引位置，若不在有限继承树中，则置为`_primary_super_limit`。
* **restricted secondary type**: 表示字段`_secondary_super_cache`相对于当前对象的偏移位置。

假设`A`继承`M`，`M`继承`Object`，则`A`的继承树如下：

    Object  -> 0
    M       -> 1
    A       -> 2

此时`_super_check_offset`的值为`2`。

回到前面的问题，若`B`本身的继承深度浅，且`A`没有继承`B`，则可以判断目标类型`_super_check_offset`的值和当前类型的`_secondary_super_cache`偏移是否相同（这个值其实是个编译时常量）。

* 若不同，则说明`_super_check_offset`的值表示`B`在继承树中的索引位置，但由于前面已经判断过`B`不在`A`的有限继承树中，因此说明`A`没有继承自`B`
* 若相同，判断一下`A`和`B`是否相同，若不相同，只能再通过遍历`_secondary_supers`来判断了。

完整的继承关系判断方法实现如下:

    bool is_subtype_of(Klass* k) const {
        juint    off = k->super_check_offset();
        Klass* sup = *(Klass**)( (address)this + off );
        const juint secondary_offset = in_bytes(secondary_super_cache_offset());
        if (sup == k) {
            return true;
        } else if (off != secondary_offset) {
            return false;
        } else {
            return search_secondary_supers(k);
        }
    }

# Resources

* [Fast subtype checking in the HotSpot JVM][1]
* [Klass.hpp#is_subtype_of][2]



[1]:    https://www.researchgate.net/publication/221552851_Fast_subtype_checking_in_the_HotSpot_JVM
[2]:    https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/oops/klass.hpp#l415
---
title:      hotspot源代码学习，对象，part2，默认hashcode的生成
category:   blog
layout:     post
tags:       [jvm, openjdk, hotspot, hashcode]
---


hotspot源代码学习，对象，part2，默认hashcode的生成
==================



>jdk版本是openjdk-7u40-fcs-src-b43-26_aug_2013


java中，计算对象的默认hashcode的方法主要在[synchronizer.cpp文件][1]中。对象的hashcode并不是在创建对象时就计算好的，而是在第一次使用的时候，也就是首次调用`hashCode`方法时进行计算，并存储在对象的标记字中的。

`java.lang.Object#hashCode()`方法是native，会调用`ObjectSynchronizer::FastHashCode`方法获取hashcode，基本流程如下图所示：

!["call hashCode Method"][2]

具体到计算`hashcode`时，会涉及到`get_next_hash`方法（在[synchronizer.cpp][1]，用于计算新的hashcode）和`hash`方法（在[markOop.hpp][3]中，用于获取已有的hashcode）：

其中，`hash`方法的实现是先获取该对象的标记字对象，然后对该标记字对象的的地址做位移和逻辑与操作，以结果作为hashcode（其中，mark_bits方法在[globalDefinitions.hpp][4]），之所以做移位操作操作是因为hashcode在标记字中只占用了部分位（32位机器上是占用25位，64位机器上占用31，标记字的内容参见[这里][5]）。

    
    intptr_t hash() const {
        return mask_bits(value() >> hash_shift, hash_mask);
    }
    
    uintptr_t value() const { 
        return (uintptr_t) this; 
    }
    
    inline intptr_t mask_bits (intptr_t  x, intptr_t m) { 
        return x & m; 
    }

`get_next_hash`方法会根据传给JVM的参数`-XX:hashCode=n`来选择使用哪种方法生成对象的hashcode：

1. hashCode=0，使用系统生成的随机数作为hashcode
2. hashCode=1，对对象地址做移位和逻辑操作，生成hashcode
3. hashCode=2，所有的hashcode都等于1
4. hashCode=3，用一个自增序列给hashcode赋值
5. hashCode=4，以对象地址作为hashcode
6. hashCode=其他，好复杂的位操作

>正常情况下，`markOopDesc::hash_mask`的值应该全是1，此时，如果之前计算出的hashcode为0，则会触发断言错误

    static inline intptr_t get_next_hash(Thread * Self, oop obj) {
        intptr_t value = 0 ;
        if (hashCode == 0) {
            // This form uses an unguarded global Park-Miller RNG,
            // so it's possible for two threads to race and generate the same RNG.
            // On MP system we'll have lots of RW access to a global, so the
            // mechanism induces lots of coherency traffic.
            value = os::random() ;
        } else
        if (hashCode == 1) {
            // This variation has the property of being stable (idempotent)
            // between STW operations.  This can be useful in some of the 1-0
            // synchronization schemes.
            intptr_t addrBits = intptr_t(obj) >> 3 ;
            value = addrBits ^ (addrBits >> 5) ^ GVars.stwRandom ;
        } else
        if (hashCode == 2) {
            value = 1 ;            // for sensitivity testing
        } else
        if (hashCode == 3) {
            value = ++GVars.hcSequence ;
        } else
        if (hashCode == 4) {
            value = intptr_t(obj) ;
        } else {
            // Marsaglia's xor-shift scheme with thread-specific state
            // This is probably the best overall implementation -- we'll
            // likely make this the default in future releases.
            unsigned t = Self->_hashStateX ;
            t ^= (t << 11) ;
            Self->_hashStateX = Self->_hashStateY ;
            Self->_hashStateY = Self->_hashStateZ ;
            Self->_hashStateZ = Self->_hashStateW ;
            unsigned v = Self->_hashStateW ;
            v = (v ^ (v >> 19)) ^ (t ^ (t >> 8)) ;
            Self->_hashStateW = v ;
            value = v ;
        }
    
        value &= markOopDesc::hash_mask;
        if (value == 0) value = 0xBAD ;
        assert (value != markOopDesc::no_hash, "invariant") ;
        TEVENT (hashCode: GENERATE) ;
        return value;
    }

上面是计算出的hashcode值，但并不是直接将该值写入到的标记字中，需要经过处理，如下所示：

    temp = mark->copy_set_hash(hash); // merge the hash code into header
    // use (machine word version) atomic operation to install the hash
    test = (markOop) Atomic::cmpxchg_ptr(temp, obj->mark_addr(), mark);
    if (test == mark) {
      return hash;
    }
    // If atomic operation failed, we must inflate the header
    // into heavy weight monitor. We could add more code here
    // for fast path, but it does not worth the complexity.

其中，[copy_set_hash方法][3]会复制原标记字中其他位的内容，与新hashcode合成新的标记字：

    markOop copy_set_hash(intptr_t hash) const {
        intptr_t tmp = value() & (~hash_mask_in_place);
        tmp |= ((hash & hash_mask) << hash_shift);
        return (markOop)tmp;
    }

此外，如注释所说，如果通过原子操作失败，则需要使用重量级锁来设置hashcode，如下所示：

    // Inflate the monitor to set hash code
    monitor = ObjectSynchronizer::inflate(Self, obj);
    // Load displaced header and check it has hash code
    mark = monitor->header();
    assert (mark->is_neutral(), "invariant") ;
    hash = mark->hash();
    if (hash == 0) {
        hash = get_next_hash(Self, obj);
        temp = mark->copy_set_hash(hash); // merge hash code into header
        assert (temp->is_neutral(), "invariant") ;
        test = (markOop) Atomic::cmpxchg_ptr(temp, monitor, mark);
        if (test != mark) {
            // The only update to the header in the monitor (outside GC)
            // is install the hash code. If someone add new usage of
            // displaced header, please update this code
            hash = test->hash();
            assert (test->is_neutral(), "invariant") ;
            assert (hash != 0, "Trivial unexpected object/monitor header usage.");
        }
    }









[1]:    http://hg.openjdk.java.net/jdk7u/jdk7u/hotspot/file/74d14a44c398/src/share/vm/runtime/synchronizer.cpp
[2]:    /image/call_hashcode_method.jpg
[3]:    http://hg.openjdk.java.net/jdk7u/jdk7u/hotspot/file/74d14a44c398/src/share/vm/oops/markOop.hpp
[4]:    http://hg.openjdk.java.net/jdk7u/jdk7u/hotspot/file/74d14a44c398/src/share/vm/utilities/globalDefinitions.hpp
[5]:    ./hotspot_source_study_object_part3_mard_word
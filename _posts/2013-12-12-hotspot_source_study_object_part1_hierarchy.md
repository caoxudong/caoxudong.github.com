---
title:      hotspot源代码学习，对象，part1，jvm中对象的结构关系
category:   pages
layout:     post
tags:       [jvm, openjdk, hotspot, hashcode]
---


hotspot源代码学习，对象，part1，jvm中对象的结构关系
=======================



>jdk版本是openjdk-7u40-fcs-src-b43-26_aug_2013

    // oopDesc is the top baseclass for objects classes.  The {name}Desc classes describe
    // the format of Java objects so the fields can be accessed from C++.
    // oopDesc is abstract.
    // (see oopHierarchy for complete oop class hierarchy)
    //
    // no virtual functions allowed

    typedef class oopDesc*                      oop;
    typedef class   instanceOopDesc*              instanceOop;
    typedef class   methodOopDesc*                methodOop;
    typedef class   constMethodOopDesc*           constMethodOop;
    typedef class   methodDataOopDesc*            methodDataOop;
    typedef class   arrayOopDesc*                 arrayOop;
    typedef class     objArrayOopDesc*              objArrayOop;
    typedef class     typeArrayOopDesc*             typeArrayOop;
    typedef class   constantPoolOopDesc*          constantPoolOop;
    typedef class   constantPoolCacheOopDesc*     constantPoolCacheOop;
    typedef class   klassOopDesc*                 klassOop;
    typedef class   markOopDesc*                  markOop;
    typedef class   compiledICHolderOopDesc*      compiledICHolderOop;

    class Klass;
    class   instanceKlass;
    class     instanceMirrorKlass;
    class     instanceRefKlass;
    class   methodKlass;
    class   constMethodKlass;
    class   methodDataKlass;
    class   klassKlass;
    class     instanceKlassKlass;
    class     arrayKlassKlass;
    class       objArrayKlassKlass;
    class       typeArrayKlassKlass;
    class   arrayKlass;
    class     objArrayKlass;
    class     typeArrayKlass;
    class   constantPoolKlass;
    class   constantPoolCacheKlass;
    class   compiledICHolderKlass;



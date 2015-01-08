---
title:      hotspot源代码学习，flags，part1，定义
category:   blog
layout:     post
tags:       [hotspot, jvm, openjdk]
---



hotspot源代码学习，flags，part1，定义
=======================


> jvm中hotspot的参数(flag)的定义主要位于[globals.hpp][1]、其他个操作系统相关的globals.hpp（如[globals_linux.hpp][2]）以及其他相关组件（如compiler和gc）的globals.hpp（如[g1_globals.hpp][3], [c1_globals.hpp][4]）。 下面主要以hotspot的主globals.hpp来说明对flags的处理。

>源代码版本： `openjdk-7u6-fcs-src-b24-28_aug_2012`

# flags的种类

hotspot的参数包含几大类，分别是：

*   **develop** 只在开发期间可见可修改，当应用于生产环境时，作为常量使用
*   **product** 总是可见可修改的
*   **nonproduct** 开发期间可见可写，生产环境不可用

flag的类型必须是bool、intx、uintx或ccstr之一，其中，ccstr的意思是"const str"，此外"ccstr"只能用于当前文件，否则预编译在处理宏的时候会出现错误。

## diagnostic flags

虽然在product版本的jvm可以使用diagnostic参数，但是，在生产环境使用这些参数是不明智的。diagnostic参数并非用于对jvm进行调优，也不应该用于生产环境，而是对jvm进行调试时使用的。

添加`-XX:+UnlockDiagnosticVMOptions`选项可以启用diagnostic参数。使用该参数会影响`-Xprintflags`的输出结果。

## experimental flags

这类参数不是官方product版本的一部分，它们没有经过完整或严格的测试，但有助于社区的开发者对hotspot进行开发调试，因此得以保留。

> 无论是experimental flags还是diagnostic flags，都必须小心使用。 为便于开发调试，develop flags的实现也是可写的

## manageable flags

可以用过JMX（com.sun.management.HotSpotDiagnosticMXBean API）进行写操作的flags。它必须符合以下条件：

*   作为外部导出接口，定义于CCC
*   当前的VM实现支持对该参数的动态设置，即vm在运行时必须每次都查询该参数的值，而不能缓存起来重用
*   用户可以在jvm运行时编程查询该参数的值

## product_rw flags

这类参数与manageable flags类似，区别在于它们只能内部使用（internal/private），在将来的版本中可能会被删除。它必须符合以下条件：

*   当前的VM实现支持对该参数的动态设置，即vm在运行时必须每次都查询该参数的值，而不能缓存起来重用

# hotspot如何解析flags

对flags的解析主要由几个宏完成，它们均定义在[globals.hpp][1]中。具体内容如下：

    #define RUNTIME_FLAGS(develop, develop_pd, product, product_pd, diagnostic, \
            experimental, notproduct, manageable, product_rw, lp64_product)     \
                                                                                \
    lp64_product(bool, UseCompressedOops, false,                                \
            "Use 32-bit object references in 64-bit VM. "                       \
            "lp64_product means flag is always constant in 32 bit VM")          \
                                                                                \
    notproduct(bool, CheckCompressedOops, true,                                 \
            "generate checks in encoding/decoding code in debug VM")            \
    ......
    #define RUNTIME_OS_FLAGS(develop, develop_pd, product, product_pd,          \
            diagnostic, notproduct)                                             \
    product(bool, UseOprofile, false,                                           \
            "enable support for Oprofile profiler")                             \
                                                                                \
    product(bool, UseLinuxPosixThreadCPUClocks, true,                           \
            "enable fast Linux Posix clocks where available")                   \
    /*  NB: The default value of UseLinuxPosixThreadCPUClocks may be            \
        overridden in Arguments::parse_each_vm_init_arg.  */                    \
                                                                                \
    product(bool, UseHugeTLBFS, false,                                          \
            "Use MAP_HUGETLB for large pages")                                  \
                                                                                \
    product(bool, UseSHM, false,                                                \
            "Use SYSV shared memory for large pages")
    ......
    #define DECLARE_PRODUCT_FLAG(type, name, value, doc)    extern "C" type name;
    ......
    #define MATERIALIZE_PRODUCT_FLAG(type, name, value, doc)   type name = value;
    

在该文件的结尾处有对这两个宏的具体调用：

    RUNTIME_FLAGS(DECLARE_DEVELOPER_FLAG, DECLARE_PD_DEVELOPER_FLAG,            \
            DECLARE_PRODUCT_FLAG, DECLARE_PD_PRODUCT_FLAG,                      \
            DECLARE_DIAGNOSTIC_FLAG, DECLARE_EXPERIMENTAL_FLAG,                 \
            DECLARE_NOTPRODUCT_FLAG, DECLARE_MANAGEABLE_FLAG,                   \
            DECLARE_PRODUCT_RW_FLAG, DECLARE_LP64_PRODUCT_FLAG)
    
    RUNTIME_OS_FLAGS(DECLARE_DEVELOPER_FLAG, DECLARE_PD_DEVELOPER_FLAG,         \
            DECLARE_PRODUCT_FLAG, DECLARE_PD_PRODUCT_FLAG,                      \
            DECLARE_DIAGNOSTIC_FLAG, DECLARE_NOTPRODUCT_FLAG)
    

该文件在经过预处理后，上面的代码会被整理成如下结果：

    extern "C" bool UseCompressedOops;
    extern "C" bool CheckCompressedOops;
    

然后，在globals.cpp中，有对这些flag进行复制的代码，也是通过宏实现：

    RUNTIME_FLAGS(MATERIALIZE_DEVELOPER_FLAG, MATERIALIZE_PD_DEVELOPER_FLAG,    \
              MATERIALIZE_PRODUCT_FLAG, MATERIALIZE_PD_PRODUCT_FLAG,            \
              MATERIALIZE_DIAGNOSTIC_FLAG, MATERIALIZE_EXPERIMENTAL_FLAG,       \
              MATERIALIZE_NOTPRODUCT_FLAG,                                      \
              MATERIALIZE_MANAGEABLE_FLAG, MATERIALIZE_PRODUCT_RW_FLAG,         \
              MATERIALIZE_LP64_PRODUCT_FLAG)
    
    RUNTIME_OS_FLAGS(MATERIALIZE_DEVELOPER_FLAG, MATERIALIZE_PD_DEVELOPER_FLAG, \
                 MATERIALIZE_PRODUCT_FLAG, MATERIALIZE_PD_PRODUCT_FLAG,         \
                 MATERIALIZE_DIAGNOSTIC_FLAG, MATERIALIZE_NOTPRODUCT_FLAG)
    

上面的宏，经过预处理后的结果是：

    bool UseCompressedOops = false;
    bool CheckCompressedOops = true;
    ......
    

这样，就得到了这些flags的默认值。接下来，在globals.cpp中还会将这些值存入到一个全局变量`flags`中。代码如下：

    #define RUNTIME_PRODUCT_FLAG_STRUCT(type, name, value, doc) {               \
            #type, XSTR(name), &name, NOT_PRODUCT_ARG(doc) "{product}", DEFAULT \
    },
    #define RUNTIME_DIAGNOSTIC_FLAG_STRUCT(type, name, value, doc) { #type,     \
            XSTR(name), &name, NOT_PRODUCT_ARG(doc) "{diagnostic}", DEFAULT     \
    },
    ......
    
    static Flag flagTable[] = {
        RUNTIME_FLAGS(RUNTIME_DEVELOP_FLAG_STRUCT,                              \
            RUNTIME_PD_DEVELOP_FLAG_STRUCT, RUNTIME_PRODUCT_FLAG_STRUCT,        \
            RUNTIME_PD_PRODUCT_FLAG_STRUCT, RUNTIME_DIAGNOSTIC_FLAG_STRUCT,     \
            RUNTIME_EXPERIMENTAL_FLAG_STRUCT, RUNTIME_NOTPRODUCT_FLAG_STRUCT,   \
            RUNTIME_MANAGEABLE_FLAG_STRUCT, RUNTIME_PRODUCT_RW_FLAG_STRUCT,     \
            RUNTIME_LP64_PRODUCT_FLAG_STRUCT) 
    
        RUNTIME_OS_FLAGS(RUNTIME_DEVELOP_FLAG_STRUCT,                           \
            RUNTIME_PD_DEVELOP_FLAG_STRUCT, RUNTIME_PRODUCT_FLAG_STRUCT,        \
            RUNTIME_PD_PRODUCT_FLAG_STRUCT, RUNTIME_DIAGNOSTIC_FLAG_STRUCT,     \
            RUNTIME_NOTPRODUCT_FLAG_STRUCT)
        ......
        FLAGTABLE_EXT
        {0, NULL, NULL}
    };
    Flag* Flag::flags = flagTable;
    size_t Flag::numFlags = (sizeof(flagTable) / sizeof(Flag));
    

经过处理之后的代码（非product版本，product版本中没有那段注释内容）：

    static Flag flagTable[] = {
        {"bool", "CheckCompressedOops", &CheckCompressedOops,                   \
            "generate checks in encoding/decoding code in debug VM"             \
            "{notproduct}", DEFAULT},
        ......
    }
    Flag* Flag::flags = flagTable;
    size_t Flag::numFlags = (sizeof(flagTable) / sizeof(Flag));
    

这里，DEFAULT是一个枚举元素，表明flag的默认值。

    enum FlagValueOrigin {
        DEFAULT          = 0,
        COMMAND_LINE     = 1,
        ENVIRON_VAR      = 2,
        CONFIG_FILE      = 3,
        MANAGEMENT       = 4,
        ERGONOMIC        = 5,
        ATTACH_ON_DEMAND = 6,
        INTERNAL         = 99
    };
    

此外，Flag也定义在[globals.hpp][1]中，如下所示。

    struct Flag {
        const char *type;
        const char *name;
        void*       addr;
    
        NOT_PRODUCT(const char *doc;)
    
        const char *kind;
        FlagValueOrigin origin;
    
        // points to all Flags static array
        static Flag *flags;
    
        // number of flags
        static size_t numFlags;
    
        //方法声明略
    };
    

这样，这些flags就作为全局变量供hotspot使用。




[1]:    http://hg.openjdk.java.net/jdk7/hotspot/hotspot/file/9b0ca45cd756/src/share/vm/runtime/globals.hpp
[2]:    http://hg.openjdk.java.net/jdk7/hotspot/hotspot/file/9b0ca45cd756/src/os/linux/vm/globals_linux.hpp
[3]:    http://hg.openjdk.java.net/jdk7/hotspot/hotspot/file/9b0ca45cd756/src/share/vm/gc_implementation/g1/g1_globals.hpp
[4]:    http://hg.openjdk.java.net/jdk7/hotspot/hotspot/file/9b0ca45cd756/src/share/vm/c1/c1_globals.hpp

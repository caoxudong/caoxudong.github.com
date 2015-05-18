---
title:      AVM2 Overview学习笔记3 -- ABC
category:   blog
layout:     post
tags:       [note, avm, flash]
---

>[AVM2 Overview学习笔记1 -- AVM2基本结构][4]
>[AVM2 Overview学习笔记2 -- 运行][5]


ABC文件是AVM2加载执行程序的最小单位，但实际上，AVM2并非一定要从文件系统中加载ABC文件。

> Despite the name, the contents of an abcFile does not need to be read from a file in the file system; it can be generated dynamically by a run-time compiler or other tools. The use of the word “file” is historical.

下面对ABC做简单介绍。

# 原生类型

值得注意的是，多字节类型是以小端序（little-endian order）存储的，负整数使用补码存储。

*   u8，8位无符号整数；
*   u16，16位无符号整数；
*   s24，24位有符号整数；
*   u30，30位无符号整数，使用变长结构（variable-length）存储；
*   u32，32位无符号整数，使用变长结构（variable-length）存储；
*   s32，32位有符号整数，使用变长结构（variable-length）存储；
*   d64，64位浮点数，使用[IEEE-754][1]中规定的结构。

变长结构说明： * 变长编码的u30，u32和s32使用1到4个字节，具体长度依赖于该数值大小; * 每个字节的低7位用于保存数值，如果最高位被置位，则表示下一个字节也是该数值的一部分; * 对于s32来说，是使用符号扩展表示的

# ABC文件结构

    abcFile  
    { 
        u16 minor_version 
        u16 major_version 
        cpool_info constant_pool 
        u30 method_count 
        method_info method[method_count] 
        u30 metadata_count 
        metadata_info metadata[metadata_count] 
        u30 class_count 
        instance_info instance[class_count] 
        class_info class[class_count] 
        u30 script_count 
        script_info script[script_count] 
        u30 method_body_count 
        method_body_info method_body[method_body_count] 
    }
    

基本上与class文件结构相似。

# 常量池

    cpool_info 
    { 
        u30 int_count 
        s32 integer[int_count] 
        u30 uint_count 
        u32 uinteger[uint_count] 
        u30 double_count 
        d64 double[double_count] 
        u30 string_count 
        string_info string[string_count] 
        u30 namespace_count 
        namespace_info namespace[namespace_count] 
        u30 ns_set_count 
        ns_set_info ns_set[ns_set_count] 
        u30 multiname_count 
        multiname_info multiname[multiname_count]  
    } 
    

这里可以看到，常量池中是按照不同数据类型分别存储的。

# 字符串

在AVM2中，字符串是UTF-8编码的[Unicode][2]字符。字符串的基本结构如下：

    string_info 
    { 
        u30 size 
        u8  utf8[size] 
    }
    

## 命名空间

命名空间的基本结构如下：

    namespace_info 
    { 
        u8  kind 
        u30 name 
    }
    

用户自定义命名空间的类型是`CONSTANT_Namespace`或`CONSTANT_ExplicitNamespace`，并有一个非空的名字，而系统命名空间的名字是空的，类型也不同。命名空间的类型如下：

    Namespace Kind              Value 
    CONSTANT_Namespace          0x08 
    CONSTANT_PackageNamespace   0x16 
    CONSTANT_PackageInternalNs  0x17 
    CONSTANT_ProtectedNamespace 0x18 
    CONSTANT_ExplicitNamespace  0x19 
    CONSTANT_StaticProtectedNs  0x1A 
    CONSTANT_PrivateNs          0x05
    

## 命名空间集合

    ns_set_info 
    { 
        u30 count 
        u30 ns[count] 
    } 
    

ns\_set\_info中存储的命名空间的集合，其数组ns中的元素是常量池中命名空间类型常量的索引。

## Multiname

基本结构如下：

    multiname_info 
    { 
        u8   kind 
        u8   data[] 
    }
    

其中，kind表明了当前Multiname的类型，data中保存了相关multiname的具体内容。multiname的类型如下：

    Multiname Kind       Value 
    CONSTANT_QName       0x07 
    CONSTANT_QNameA      0x0D 
    CONSTANT_RTQName     0x0F 
    CONSTANT_RTQNameA    0x10 
    CONSTANT_RTQNameL    0x11 
    CONSTANT_RTQNameLA   0x12 
    CONSTANT_Multiname   0x09 
    CONSTANT_MultinameA  0x0E 
    CONSTANT_MultinameL  0x1B 
    CONSTANT_MultinameLA 0x1C 
    

其中后缀'A'（例如`CONSTANT_QNameA`）表示属性名。

不同Multiname类型的基本结构：

    multiname_kind_QName 
    { 
        u30 ns 
        u30 name 
    }
    

其中`ns`和`name`的值分别是常量池中命名空间和字符串类型常量数值的索引值。如果`ns`为0表示任意命名空间，如果`name`为0表示任意名字。

    multiname_kind_RTQName 
    { 
        u30 name 
    }
    

其中`name`的含义与`multiname_kind_QName`中相同。

    multiname_kind_RTQNameL 
    { 
    }
    

没有与该类型对应的数据。

    multiname_kind_Multiname 
    { 
        u30 name 
        u30 ns_set 
    } 
    

其中`name`是常量池中字符串常量数组的索引，`ns_set`是常量池中`ns_set`数组的索引。`name`的值为0表示是任意名字，而`ns_set`的值不能为0。

    multiname_kind_MultinameL 
    { 
        u30 ns_set 
    }
    

其中`ns_set`的含义与`multiname_kind_Multiname`中相同。

# 方法签名

方法的基本结构如下：

    method_info 
    { 
        u30 param_count 
        u30 return_type 
        u30 param_type[param_count] 
        u30 name 
        u8  flags 
        option_info options 
        param_info param_names 
    }
    

其中`param_count`是该方法的参数个数，同时也是数组`param_type`的长度，数组`param_type`中的元素是指向常量池中`multiname`数组元素的索引。如果数组`param_type`的元素为0，表示可以是任意类型。`return_type`也是指向常量池中`multiname`数组元素的索引，表示返回类型，为0则表示任意类型。值得注意的是，`flags`是一个位向量，用于记载该方法的附加信息。相关位所表示的信息如下（未提及的位都必须为0）：


| Name            | Value | Meaning |
| --------------- | ----- | ------- |
| NEED_ARGUMENTS  |  0x01 | Suggests to the run-time that an “arguments” object (as specified by the ActionScript 3.0 Language Reference) be created. Must not be used together with NEED_REST. See Chapter 3. |
| NEED_ACTIVATION |  0x02 | Must be set if this method uses the newactivation opcode.| 
| NEED_REST       |  0x04 | This flag creates an ActionScript 3.0 rest arguments array. Must not be used with NEED_ARGUMENTS. See Chapter 3. |
| HAS_OPTIONAL    |  0x08 | Must be set if this method has optional parameters and the options field is present in this method_info structure.|
| SET_DXNS        |  0x40 | Must be set if this method uses the dxns or dxnslate opcodes.|
| HAS_PARAM_NAMES |  0x80 | Must be set when the param_names field is present in this method_info structure.|

  
  
## 可选参数

    option_info  
    { 
        u30 option_count 
        option_detail option[option_count] 
    } 
    
    option_detail 
    { 
        u30 val 
        u8  kind 
    }
    

结构`option_info`用于定义方法的可选参数的默认值，`option_count`表示可选参数的个数，该值不可以为0，也不可以比`method_info`结构中`parameter_count`的值大。`option_detail`结构的`kind`表示该参数的类型，`val`是指向常量池中对应类型数组元素的索引。参数类型定义如下：

| Constant Kind               | Value | Entry     |
| --------------------------- | ----- | --------- |
| CONSTANT_Int                |  0x03 | integer   |
| CONSTANT_Uint               |  0x04 | uinteger  | 
| CONSTANT_Double             |  0x06 | double    |
| CONSTANT_Utf8               |  0x01 | string    |
| CONSTANT_True               |  0x0B | -         |
| CONSTANT_False              |  0x0A | -         |
| CONSTANT_Null               |  0x0C | -         |
| CONSTANT_Undefined          |  0x00 | -         |
| CONSTANT_Namespace          |  0x08 | namespace |
| CONSTANT_PackageNamespace   |  0x16 | namespace |
| CONSTANT_PackageInternalNs  |  0x17 | Namespace |
| CONSTANT_ProtectedNamespace |  0x18 | Namespace |
| CONSTANT_ExplicitNamespace  |  0x19 | Namespace |
| CONSTANT_StaticProtectedNs  |  0x1A | Namespace |
| CONSTANT_PrivateNs          |  0x05 | namespace |
  
 
## 参数名

    param_info  
    { 
        u30 param_name[param_count] 
    }
    

当`method_info`中的`flag`属性中设置了`HAS_PARAM_NAMES`标志后，会有`param_info`结构。`param_info`数组中的每个元素都是指向常量池中`string`类型数组元素的索引。这个数据结构的存在是为外部工具准备的，AVM2并不使用。（有意思）

# metadata_info

    metadata_info  
    { 
        u30 name 
        u30 item_count 
        item_info items[item_count] 
    } 
    
    item_info  
    { 
        u30 key 
        u30 value 
    }
    

`metadata_info`结构中保存了嵌入到ABC文件中的属性信息，AVM2并不使用这些信息。

# instance

    instance_info  
    { 
        u30 name 
        u30 super_name 
        u8  flags 
        u30 protectedNs  
        u30 intrf_count 
        u30 interface[intrf_count] 
        u30 iinit 
        u30 trait_count 
        traits_info trait[trait_count] 
    } 
    

`instance_info`用于定义AVM2运行时对象（类的实例）的一些特征。其中`name`和`super_name`都是指向常量池中`multiname`数组中元素的索引。`flags`是位向量，记录了在解释`instance_info`时的选项，如下所示（未列出的位必须为0）：

| Name                      | Value | Meaning |
| ------------------------- | ----- | ------- |
| CONSTANT_ClassSealed      |  0x01 | The class is sealed: properties can not be dynamically added to instances of the class. |
| CONSTANT_ClassFinal       |  0x02 | The class is final: it cannot be a base class for any other class. | 
| CONSTANT_ClassInterface   |  0x04 | The class is an interface.|
| CONSTANT_ClassProtectedNs |  0x08 | The class uses its protected namespace and the protectedNs field is present in the interface_info structure.|

当`flags`中设置了`CONSTANT_ProtectedNs`标志后，才会有`protectedNs`属性，它是指向常量池中命名空间数组中元素的索引，表示该类中`protected namespace`的值。

`intrf_count`和`interface`分别表示所实现的接口的数量和名字，其中`interface`数组中的元素是指向常量池中`multiname`数组中元素的索引。`iinit`是指向ABC文件中`method`数组中元素的索引，实际上就是当前类的构造函数。 （难道AS3中每个类只能有一个构造函数？不过，考虑到AS3中函数式可以有默认参数的，所以这样有可能，后续需要确认一下。）

`trait_count`和`trait`参见下一节中的内容。

# Trait

    traits_info  
    { 
        u30 name 
        u8  kind 
        u8  data[] 
        u30 metadata_count 
        u30 metadata[metadata_count] 
    }
    

其中，`name`是指向常量池中`multiname`数组中元素的索引，是该特征的名字，该值不可以为0。`kind`包含两个4位的域，其中低4为决定了当前Trait的类型，高4位是一个位向量，包含了当前Trait的属性(具体内容参见下面的表格)。对于属性域`data`的解释需要参考当前Trait的不同类型。如果属性域`kind`高4位中设置了`ATTR_Metadata`标志，则会有属性域`metadata_count`和`metadata`，其中数组`metadata`中的元素是指向ABC文件中`metadata`数组中元素的索引。

属性域`kind`中低4位所表示的类型如下所示：

| Type            | Value |
| --------------- | ----- |
| Trait_Slot      |       |
| Trait_Method    |     1 |
| Trait_Getter    |     2 | 
| Trait_Setter    |     3 | 
| Trait_Class     |     4 |
| Trait_Function  |     5 |
| Trait_Const     |     6 |

当`kind`中低4位的值是`Trait_Slot(0)`或`Trait_Const(6)`时，属性域`data`的中是一个`trait_slot`结构：

    trait_slot 
    { 
        u30 slot_id 
        u30 type_name 
        u30 vindex 
        u8  vkind  
    } 
    

其中，`slot_id`是一个整数，介于0和N之间，指明了当前Trait的位置，如果为0，则需要有AVM2指定一个位置。`type_name`是指向常量池中`multiname`数组中元素的索引。`vindex`和`vkind`合起来定义一个值。如果`vindex`为0，则`vkind`为空；否则的话，`vindex`的值是指向常量池中不同类型数组元素的索引，具体指向哪个数组由`vkind`决定。`vkind`的类型参见上文中*可选参数*一节中的描述。

当`kind`中的低4位的值是`Trait_Class(0x04)`时，`data`中是一个`trait_class`结构：

    trait_class 
    { 
        u30 slot_id 
        u30 classi 
    }
    

其中，`classi`是指向ABC文件中`class`数组中元素的索引。

当`kind`中的低4位的值是`Trait_Function(0x05)`时，`data`中是一个`trait_function`结构：

    trait_function 
    { 
        u30 slot_id 
        u30 function 
    }
    

其中，`function`是指向ABC文件中`function`数组中元素的索引。

当`kind`中的低4位的值是`Trait_Method(0x01)` `Trait_Getter(0x02)`或`Trait_Setter(0x03)`时，`data`中是一个`trait_method`结构：

    trait_method 
    { 
        u30 disp_id 
        u30 method 
    }
    

其中，`disp_id`是一个编译器设置的值，用于运行性能的优化。重载方法具有相同的`disp_id`，如果此值为0，则禁用此优化。`method`是指向ABC文件中`method`数组中元素的索引。

前文提到，属性域`kind`的高4位用于确定属性，下面的表格对其作了说明，未在表中列出的会被忽略。

| Attributes    | Value | Description |
| ------------- | ----- | ----------- |
| ATTR_Final    |  0x01 | Is used with Trait_Method, Trait_Getter and Trait_Setter. It marks a method that cannot be overridden by a sub-class | 
| ATTR_Override |  0x02 | Is used with Trait_Method, Trait_Getter and Trait_Setter. It marks a method that has been overridden in this class |
| ATTR_Metadata |  0x04 | Is used to signal that the fields metadata_count and metadata follow the data field in the traits_info entry |
  
# class

    class_info  
    { 
        u30 cinit 
        u30 trait_count 
        traits_info traits[trait_count] 
    }
    

其中，`cinit`是指向ABC文件中`method`数组中元素的索引，实际上是类的初始化函数。`trait_count`和`trait`是该类的特征，其结构参见前一节的说明。

# Script

    script_info  
    { 
        u30 init 
        u30 trait_count 
        traits_info trait[trait_count] 
    }
    

该结构用于定义AS3中的特征。其中，`init`是指向ACB文件中`method`数组中元素的索引，其指向的方法会在调用任何其他方法之前调用，可以认为是方法的初始化方法。`trait_count`和`trait`的含义参见上一节说明。

# method

    method_body_info 
    { 
        u30 method 
        u30 max_stack 
        u30 local_count 
        u30 init_scope_depth  
        u30 max_scope_depth 
        u30 code_length 
        u8  code[code_length] 
        u30 exception_count 
        exception_info exception[exception_count] 
        u30 trait_count 
        traits_info trait[trait_count] 
    }
    

该结构用于保存某个方法或函数的AVM2指令，其中的属性域指明了在执行对应的方法时所需要消耗的资源，同时也是对所消耗资源的的限制。

# Exception

    exception_info  
    { 
        u30 from 
        u30 to  
        u30 target 
        u30 exc_type 
        u30 var_name 
    }
    

该结构指明了异常块的范围，所要处理的异常类型，当发生指定异常时调转到哪里执行（注意，目标位置需在[from,to]范围之内），以及异常发生时接收到的异常对象的变量名（该值是指向常量池中`string`数组中元素的索引）。

to be continued...

# 相关资源

*   [IEEE-754][1]
*   [IEEE Floating Point][2]
*   [Unicode][3]

[1]:    http://grouper.ieee.org/groups/754/
[2]:    http://unicode.org
[3]:    http://en.wikipedia.org/wiki/IEEE_floating_point
[4]:    /blog/2013/11/10/avm2_overview_note_1_basic_structure
[5]:    /blog/2013/11/10/avm2_overview_note_2_run

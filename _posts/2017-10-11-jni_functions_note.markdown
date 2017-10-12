---
title:      JNI开发
layout:     post
category:   blog
tags:       [java, jni, jvm]
---

# 目录

* [1 简介][2]
* [2 设计概览][3]
    * [2.1 JNI函数和指针][4]
    * [2.2 编译、载入、链接本地方法][5]
        * [2.2.1 解析本地方法名][6]
        * [2.2.2 本地方法参数][7]
    * [2.3 引用Java对象][8]
        * [2.3.1 全局引用和局部引用][9]
        * [2.3.2 实现局部引用][10]
    * [2.4 访问Java对象][11]
        * [2.4.1 访问原生类型的数组][12]
        * [2.4.2 访问属性和方法][13]
        * [2.4.3 报告程序错误][14]
    * [2.5 Java异常][15]
        * [2.5.1 异常和错误码][16]
        * [2.5.2 异步异常][17]
        * [2.5.3 异常处理][18]
* [3 JNI的类型和数据结构][19]
    * [3.1 原生类型][20]
    * [3.2 引用类型][21]
    * [3.3 属性和方法ID][22]
    * [3.4 值类型][23]
    * [3.5 类型签名][24]
    * [3.6 自定义UTF-8编码][25]
* [4 JNI函数][26]
    * [4.1 接口函数表][27]
    * [4.2 版本信息][28]
        * [4.2.1 GetVersion][29]
        * [4.2.2 Constant][30]
    * [4.3 类操作][31]
        * [4.3.1 DefineClass][32]
        * [4.3.2 FindClass][33]
        * [4.3.3 GetSuperclass][34]
        * [4.3.4 IsAssignableFrom][35]
    * [4.4 异常][36]
        * [4.4.1 Throw][37]
        * [4.4.2 ThrowNew][38]
        * [4.4.3 ExceptionOccurred][39]
        * [4.4.4 ExceptionDescribe][40]
        * [4.4.5 ExceptionClear][41]
        * [4.4.6 FatalError][42]
        * [4.4.7 ExceptionCheck][43]
    * [4.5 全局引用和局部引用][44]
        * [4.5.1 全局引用][45]
            * [4.5.1.1 NewGlobalRef][46]
            * [4.5.1.2 DeleteGlobalRef][47]
        * [4.5.2 局部引用][48]
            * [4.5.2.1 DeleteLocalRef][49]
            * [4.5.2.2 EnsureLocalCapacity][50]
            * [4.5.2.3 PushLocalFrame][51]
            * [4.5.2.4 PopLocalFrame][52]
            * [4.5.2.5 NewLocalRef][53]
        * [4.5.3 弱全局引用][54]
            * [4.5.3.1 NewWeakGlobalRef][55]
            * [4.5.3.2 DeleteWeakGlobalRef][56]
        * [4.5.4 对象操作][57]
            * [4.5.4.1 AllocObject][58]
            * [4.5.4.2 NewObject, NewObjectA, NewObjectV][59]
            * [4.5.4.3 GetObjectClass][60]
            * [4.5.4.4 GetObjectRefType][61]
            * [4.5.4.5 IsInstanceOf][62]
            * [4.5.4.6 IsSameObject][63]
        * [4.5.5 访问对象的属性][64]
            * [4.5.5.1 GetFieldID][65]
            * [4.5.5.2 `Get<type>Field`系列函数][66]
            * [4.5.5.3 `Set<type>Field`系列函数][67]
        * [4.5.6 调用实例方法][68]
            * [4.5.6.1 GetMethodID][69]
            * [4.5.6.2 `Call<type>Method` `Call<type>MethodA`和`Call<type>MethodV`系列函数][70]
            * [4.5.6.3 `CallNonvirtual<type>Method` `CallNonvirtual<type>MethodA` `CallNonvirtual<type>MethodV`系列函数][71]
        * [4.5.7 访问静态属性][72]
            * [4.5.7.1 GetStaticFieldID][73]
            * [4.5.7.2 `GetStatic<type>Field`系列函数][74]
            * [4.5.7.3 `SetStatic<type>Field`系列函数][75]
        * [4.5.8 调用静态方法][76]
            * [4.5.8.1 GetStaticMethodID][77]
            * [4.5.8.2 `CallStatic<type>Method` `CallStatic<type>MethodA` `CallStatic<type>MethodV`系列函数][78]
        * [4.5.9 字符串操作][79]
            * [4.5.9.1 NewString][80]
            * [4.5.9.2 GetStringChars][81]
            * [4.5.9.3 ReleaseStringChars][82]
            * [4.5.9.4 NewStringUTF][83]
            * [4.5.9.5 GetStringUTFLength][84]
            * [4.5.9.6 GetStringUTFChars][85]
            * [4.5.9.7 ReleaseStringUTFChars][86]
            * [4.5.9.8 GetStringRegion][87]
            * [4.5.9.9 GetStringUTFRegion][88]
            * [4.5.9.10 GetStringCritical, ReleaseStringCritical][89]
        * [4.5.10 数组操作][90]
            * [4.5.10.1 GetArrayLength][91]
            * [4.5.10.2 NewObjectArray][92]
            * [4.5.10.3 GetObjectArrayElement][93]
            * [4.5.10.4 SetObjectArrayElement][94]
            * [4.5.10.5 `New<PrimitiveType>Array`系列函数][95]
            * [4.5.10.6 `Get<PrimitiveType>ArrayElements`系列函数][96]
            * [4.5.10.7 `Release<PrimitiveType>ArrayElements`系列函数][97]
            * [4.5.10.8 `Get<PrimitiveType>ArrayRegion`系列函数][98]
            * [4.5.10.9 `Set<PrimitiveType>ArrayRegion`系列函数][99]
            * [4.5.10.10 GetPrimitiveArrayCritical, ReleasePrimitiveArrayCritical][100]
        * [4.5.11 注册本地方法][101]
            * [4.5.11.1 RegisterNatives][102]
            * [4.5.11.2 UnregisterNatives][103]
        * [4.5.12 监视器操作][104]
            * [4.5.12.1 MonitorEnter][105]
            * [4.5.12.2 MonitorExit][106]
        * [4.5.13 NIO支持][107]
            * [4.5.13.1 NewDirectByteBuffer][110]
            * [4.5.13.2 GetDirectBufferAddress][111]
            * [4.5.13.3 GetDirectBufferCapacity][112]
        * [4.5.14 反射支持][113]
            * [4.5.14.1 FromReflectedMethod][114]
            * [4.5.14.2 FromReflectedField][115]
            * [4.5.14.3 ToReflectedMethod][116]
            * [4.5.14.4 ToReflectedField][117]
        * [4.5.15 JVM接口][118]
            * [4.5.15.1 GetJavaVM][119]
* [5 Invocation API][120]
    * [5.1 Overview][121]
        * [5.1.1 创建JVM][122]
        * [5.1.2 连接到JVM][123]
        * [5.1.3 断开与JVM的连接][124]
        * [5.1.4 卸载JVM][125]
    * [5.2 库与版本管理][126]
        * [5.2.1 JNI_OnLoad][127]
        * [5.2.2 JNI_UnOnLoad][128]
    * [5.3 Invocation API][129]
        * [5.3.1 JNI_GetDefaultJavaVMInitArgs][130]
        * [5.3.2 JNI_GetCreatedJavaVMs][131]
        * [5.3.3 JNI_CreateJavaVM][132]
        * [5.3.4 DestroyJavaVM][133]
        * [5.3.5 AttachCurrentThread][134]
        * [5.3.6 AttachCurrentThreadAsDaemon][135]
        * [5.3.7 DetachCurrentThread][136]
        * [5.3.8 GetEnv][137]
            
            


<a name="1"></a>
# 1 简介

没啥可说的

<a name="2"></a>
# 2 设计概览

<a name="2.1"></a>
## 2.1 JNI函数和指针

本地代码通过可以通过一系列JNI函数来访问JVM的内部数据，而想要访问这一系列JNI函数，又需要通过一个JNI接口指针(JNI Interface Pointer)才行，如下图所示

                                                Array of pointers       +---------------------+
                                                to JNI functions    +-> |an interface function|
    +-------------+     +---------------+      +-----------------+  |   +---------------------+
    |JNI interface+---> |Pointer        +--+-> |Pointer          +--+
    |pointer      |     +---------------+  |   +-----------------+      +---------------------+
    |             |     |per-thread JNI |  +-> |Pointer          +----> |an interface function|
    +-------------+     |data structure |  |   +-----------------+      +---------------------+
                        +---------------+  +-> |Pointer          +--+
                                               +-----------------+  |   +---------------------+
                                               |...              |  +-> |an interface function|
                                               +-----------------+      +---------------------+

JNI接口指针的设计有些类似于C++的虚函数表，这样做的好处是，可以通过JNI命名空间来隔离本地代码，JVM可以借此提供多个版本的JNI函数表，例如一个版本用来做调试，效率不高，但会做更多的参数检查，另一个版本用于做正式使用，参数检查较少，但效率更高。

JNI函数接口只能在当前线程使用，**禁止**将接口指针传给其他线程，当在同一个线程中多次调用本地方法时，JVM保证传递的是相同的接口指针。由于本地方法可能被不同的Java线程调用，因此可能传入不同的接口指针。

<a name="2.2"></a>
## 2.2 编译、载入、链接本地方法

JVM本身是支持多线程的，因此在编译、链接本地代码库的时候，也要添加多线程的支持。例如，在使用Sun Studio编译器编译代码时，应该添加`-mt`标记，使用GCC编译代码时，应该使用`-D_REENTRANT`或`-D_POSIX_C_SOURCE`标记。编译本地代码库之后，可以通过`System.loadLibrary`方法来载入本地库，如下所示：

    ```java
    package pkg; 

    class Cls {
        native double f(int i, String s);
        static {
            System.loadLibrary("pkg_Cls");
        }
    }
    ```

编译后的本地代码库要符合目标操作系统的命名约定，例如在Solaris系统上，`pkg_Cls`代码库的名字应该是`libpkg_Cls.so`，在Windows系统上，`pkg_Cls`代码库的名字应该是`pkg_Cls.dll`。

上面说的动态库，JVM也可以使用静态库，但这需要与JVM的实现绑定在一起，`System.loadLibrary`或其他等价的方法在加载静态库的时候，必须成功。

当且仅当静态库对外导出了名为`JNI_OnLoad_L`的函数时，并且与JVM绑定在一起时，才是真正的静态链接。如果静态库中既包含函数`JNI_OnLoad_L`，又包含函数`JNI_OnLoad`，则函数`JNI_OnLoad`会被忽略。如果某个代码库`L`是静态链接的，则当首次调用`System.loadLibrary`或其他等价方法时，会执行`JNI_OnLoad_L`方法，其参数和返回值与`JNI_OnLoad`方法相同。

若某个静态库的名字是`L`，则无法在加载具有相同名字的动态库。

当包含了某个静态库的类加载器被GC掉，并且该静态库中导出了名为`JNI_OnUnload_L`函数时，会调用`JNI_OnUnload_L`完成清理工作。类似的，若静态库中同时导出了名为`JNI_OnUnLoad_L`和`JNI_OnUnLoad`的函数，则函数`JNI_OnUnLoad`会被忽略掉。

开发者可以调用JNI函数`RegisterNatives`来注册某个类的本地方法，这对静态链接的函数非常有用。

<a name="2.2.1"></a>
### 2.2.1 解析本地方法名

动态链接器会根据本地方法的方法名来解析函数入口，方法名遵循如下规则：

* 函数名带有`Java_`前缀
* 后跟以下划线完整类名，类的包名分隔符`.`以`_`来代替
* 后跟函数名
* 对于重载的本地方法，会使用双下划线(`__`)来分隔参数签名

JVM根据本地方法名查找方法的规则如下：

* 先查找不带参数签名的方法
* 再查找带参数签名的方法

这里值得注意的是，如果本地方法和非本地方法同名，其实并不需要使用带参数签名的方法名，因为非本地方法不会存在于本地代码库中。

由于Java代码中支持Unicode字符，因此为了与C语言兼容，需要对本地方法中的非ASCII字符进行转义，规则如下：

* 使用`_0XXXX`表示非ASCII的Unicode字符，注意这里使用的小写字符，例如`_0abcd`
* 使用`_1`表示下划线`_`
* 使用`_2`表示分号`;`
* 使用`_3`表示中括号`[`

代码示例：

    ```java
    public class Hello {
        private native int sum(int a, int b);
        private native String concat(String a, String b);
        private native String 试试(String a, String b);

        public static void main(String[] args) {
            System.out.println(new Hello().sum(1,2));
            System.out.println(new Hello().concat("caoxudong is ", "testging"));
        }

        static {
            System.loadLibrary("Hello");
        }

    }
    ```

使用`javah`编译后的头文件

    ```c
    /* DO NOT EDIT THIS FILE - it is machine generated */
    #include <jni.h>
    /* Header for class Hello */

    #ifndef _Included_Hello
    #define _Included_Hello
    #ifdef __cplusplus
    extern "C" {
    #endif
    /*
    * Class:     Hello
    * Method:    sum
    * Signature: (II)I
    */
    JNIEXPORT jint JNICALL Java_Hello_sum
    (JNIEnv *, jobject, jint, jint);

    /*
    * Class:     Hello
    * Method:    concat
    * Signature: (Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    */
    JNIEXPORT jstring JNICALL Java_Hello_concat
    (JNIEnv *, jobject, jstring, jstring);

    /*
    * Class:     Hello
    * Method:    _08bd5_08bd5
    * Signature: (Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    */
    JNIEXPORT jstring JNICALL Java_Hello__08bd5_08bd5
    (JNIEnv *, jobject, jstring, jstring);

    #ifdef __cplusplus
    }
    #endif
    #endif
    ```

<a name="2.2.2"></a>
### 2.2.2 本地方法参数

* 第一个参数是JNI接口指针，`JNIEnv *`
* 第二个参数是Java对象，具体值取决于当前方法是静态方法还是实例方法，若是静态方法，则表示类对象，若是实例方法，则表示实例对象
* 其余参数与定义本地方法时的参数一一对应

**需要注意的是，一定要使用JNI接口指针来操作Java对象，不要耍小聪明绕过JNI接口指针。**

<a name="2.3"></a>
## 2.3 引用Java对象

像整型(`int`)和字符(`char`)原生类型的数据会在Java代码和本地代码之间互相拷贝数据，而其他引用类型的对象则可以在Java代码和本地代码之间传递引用。JVM需要跟踪所有传递给本地代码的对象，防止其被垃圾回收；另一方面，本地代码需要有一种途径来告知JVM哪些对象可以被回收掉；此外，垃圾回收器需要能够移动本地代码所引用的对象。

<a name="2.3.1"></a>
### 2.3.1 全局引用和局部引用

JNI将本地代码所使用的对象分为全局引用(`global reference`)和本地引用(`local reference`)。本地引用只在本地方法调用中有效，当本地方法退出时，会自动释放掉；而全局引用在显式调用释放方法前，会一直有效。

一些操作原则：

* 对象是作为局部引用传递给本地方法的
* JNI函数返回的Java对象也都是局部引用的
* 开发者可以使用局部引用来创建全局引用
* 意图接收Java对象的JNI函数，即可以接收局部引用，也可以接收全局引用
* 本地方法返回给JVM的结果，即可以是局部引用，也可以是全局引用

大部分情况下，开发者可以不必关心局部引用的释放，JVM会做好这件事；在某些特殊场景下，才需要有开发者显式释放掉局部引用，例如：

* 本地方法访问了一个很大的Java对象，因此创建了一个指向该对象的局部引用，在返回到调用函数之前，该本地方法需要执行很多额外的工作，由于有局部引用指向该Java对象，即便该Java对象已经不再使用，它也不会被垃圾回收器回收掉
* JVM需要一块额外的内存空间来跟踪本地方法创建的局部引用，因此若本地方法创建了大量局部引用，则可能导致内存不足而引发错误，例如本地方法遍历某个很大的数据，访问其中的Java对象，每次迭代都会创建局部引用，而这个新创建的局部引用在本地迭代之后就不再使用，造成大量内存浪费

JNI允许开发者在本地方法中手动删除局部引用，而且除了将局部引用作为结果返回之外，JNI函数不可以创建额外的局部引用。

局部引用不是线程安全的，只可用在当前线程中。

<a name="2.3.2"></a>
### 2.3.2 实现局部引用

当从Java代码转换到本地代码时，JVM会创建注册表来记录不可移动的局部引用到Java对象的映射，同时避免该Java对象被垃圾回收器回收掉。调用本地方法时，传入传出的Java对象都会被添加到这个注册表中，当从本地方法返回时，该注册表会被删除，注册表中引用的对象也得以被垃圾回收器回收掉。

实现注册表有多种方法，例如哈希表、链表等。尽管使用引用计数可以避免在注册表中创建重复内容，但就JNI的具体实现来说，这并不是必要的。

需要注意的是，不能通过保守的遍历本地调用栈来实现局部引用，因为本地方法可能会将局部引用存储在全局或堆中的某个数据结构中。

<a name="2.4"></a>
## 2.4 访问Java对象

JNI通过局部引用和全局引用提供了一整套访问函数，使开发者可以不比关心JVM内部的具体实现，提升了JNI的适用性。

当然，通过访问函数来访问数据的开销肯定会比直接访问实际数据结构的开销大，但在大部分场景下，能逼得Java开发者通过本地方法来实现的功能，其执行开销本身就比调用访问函数的开销大得多，所以说，不必太过在意。

<a name="2.4.1"></a>
### 2.4.1 访问原生类型的数组

当然，在访问包含了大量原生数据类型数组时，若每次迭代都要调用JNI访问函数来访问数组元素，就太没有效率了。

一种解决方案是引入**pinning**机制，JVM锁定原始数组，并提供类似于游标的直接指针，以便本地代码可以访问数组元素，但这种方案有两个前提条件：

* 垃圾回收器能够支持**pinning**
* JVM必须将原生类型的数组放置在一个连续的内存空间上，大部分情况下也确实是这么实现的，不过在实现布尔类型的数组时可以将数组元素压缩存储，因此使用这种方式的代码不具备可移植性

这里，可以采用一种折衷的方法：

* 通过一系列函数来实现原生类型的数组在本地代码和Java代码之间的拷贝，当本地代码只需要访问数组中的少量数据时，使用这些拷贝函数即可；
* 若开发者确实需要访问大量的数组元素，还是通过另一系列类似直接指针的函数来访问数组元素，这时请一定牢记，这些函数可能需要JVM做一些内存分配或和数据拷贝的工作，实际执行时是否需要分配内存和拷贝数据取决于JVM的具体实现，例如：
    * 如果垃圾回收器支持**pinning**，而且数组对象的内存布局与本地代码的期望形式相同，则无需内存拷贝
    * 否则需要将数组拷贝到一块不可移动的内存区域(例如在C堆中分配内存)，执行一些必要的格式转换，再返回指向该内存块的指针
* 最后通过接口函数通知JVM，"本地代码无需再访问数组元素"，然后系统会释放对原始数组的锁定，接触原始数组和拷贝数组的关联关系，释放拷贝数组

这个方案有一些灵活性，垃圾回收器可以区别对待拷贝数组和原始数组，例如只拷贝小对象，而大对象则使用**pinning**机制来访问。

JNI的实现者必须保证，在多线程场景下运行的本地方法可以同时访问相同的数组对象，例如，JNI可能会使用引用技术来记录每个通过**pinning**机制来访问的数组对象，以便当所有访问该数组的线程退出本地方法时，可以退出**pinning**操作，但是JNI不能通过加锁来限制其他线程同时对数组进行访问。当然，同时访问数组元素，且没有进行同步控制时，访问结果是不确定的。

<a name="2.4.2"></a>
### 2.4.2 访问属性和方法

开发者可以通过JNI来访问Java对象的属性和方法。JNI可以通过属性和方法的符号名(symbolic names)和类型签名(type signatures)来定位具体的属性和方法。例如，要访问类`cls`中的方法`f`，可以使用如下方法：

    ```c++
    methodID mid = env->GetMethodID(cls, "f", "(ILjava/lang/String;)D");
    ```

在获取到方法之后，就可以重复使用了，无需每次都重新获取：

    ```c++
    jdouble result = env->CallDoubleMethod(obj, mid, 10, str);
    ```

这里需要注意的是，即便是获取到了方法或属性的ID，JVM也可能会卸载目标类，而卸载了目标类之后，ID也就无效了，因此，如果本地方法需要在一段时间内持续持有属性或方法ID，需要做一些额外的工作才能确保执行正确：

* 持有一个对目标类的引用
* 重新计算属性或方法的ID

JNI并不强制要求属性或方法ID该如如何实现。

<a name="2.4.3"></a>
### 2.4.3 报告程序错误

JNI并不检查像空指针或错误参数类型这样的程序错误，原因如下：

* 会降低本地方法的性能
* 很多时候，运行时类型信息不足，无法检查

大多数C语言程序库并不对程序错误加以预防，例如像`printf`这样的函数在遇到无效地址时，并不会报告错误代码，而是会引发一个运行时错误。因此，强制C语言程序库对所有可能错误进行检查没什么意义，用户代码本身就需要做检查，C语言运行库就无需再做一遍了。

开发者禁止将错误指针或参数传递给本地方法，否则可能会引发无法预知的结果，包括异常的系统状态或JVM崩溃。

<a name="2.5"></a>
## 2.5 Java异常

JNI允许本地代码抛出任何类型的异常，也可以处理被抛出的Java异常，若不处理，则会被返还给JVM继续处理。

<a name="2.5.1"></a>
### 2.5.1 异常和错误码

特定的JNI函数会使用Java的异常机制来报告异常，大部分情况下，JNI会通过返回错误码并抛出Java异常来报告错误。错误码通常是特定的返回值，例如`NULL`，因此开发者可以：

* 检查最后一次调用JNI函数的返回值来判断是否有错误发生
* 调用函数`ExceptionOccurred()`，获取包含了详细错误信息的异常对象

有两种情况，开发者需要检查异常对象，而不必检查JNI函数的返回值：

* JNI函数的返回值是通过调用Java方法而得到的。开发者必须调用`ExceptionOccurred()`方法来检查是否在Java方法中跑出了异常
* 某些JNI的数组访问函数没有返回值，但可能会抛出`ArrayIndexOutOfBoundsException`异常或`ArrayStoreException`异常

其他场景下，非错误的返回值保证了没有异常被抛出。

<a name="2.5.2"></a>
### 2.5.2 异步异常

在多线程场景下，非当前线程可能会抛出异步异常(asynchronous exception)，异步异常并不会立刻影响当前线程中本地代码的执行，直到满足以下条件之一：

* 本地代码调用了可能会抛出同步异常的JNI函数
* 本地代码调用`ExceptionOccurred()`方法来显式的检查是否有异常(同步或异步的)被抛出

注意，只有那些可能会抛出同步异常的JNI函数需要检查异步异常。

本地方法应该在适当的时机调用`ExceptionOccurred()`方法来确保当前线程可以在可控的时间范围内对异步异常进行相应。

<a name="2.5.3"></a>
### 2.5.3 异常处理

在本地代码中，有两种处理异常的方法：

* 本地代码可以立即返回，由本地方法的调用者来处理异常
* 本地方法可以调用`ExceptionClear()`方法清除异常信息，自己来处理异常

当有异常被抛出后，本地方法在调用其他JNI函数前，**必须**先清除异常信息。当有异常未被处理时，可以安全调用的JNI方法有：

* `ExceptionOccurred()`
* `ExceptionDescribe()`
* `ExceptionClear()`
* `ExceptionCheck()`
* `ReleaseStringChars()`
* `ReleaseStringUTFChars()`
* `ReleaseStringCritical()`
* `Release<Type>ArrayElements()`
* `ReleasePrimitiveArrayCritical()`
* `DeleteLocalRef()`
* `DeleteGlobalRef()`
* `DeleteWeakGlobalRef()`
* `MonitorExit()`
* `PushLocalFrame()`
* `PopLocalFrame()`

<a name="3"></a>
# 3 JNI的类型和数据结构

<a name="3.1"></a>
## 3.1 原生类型

原生类型和Java对象类型的对应关系如下：

    Java类型             原生类型             描述
    boolean             jboolean            unsigned 8 bits
    byte                jbyte               signed 8 bits
    char                jchar               unsigned 16 bits
    short               jshort              signed 16 bits
    int                 jint                signed 32 bits
    long                jlong               signed 64 bits
    float               jfloat              32 bits
    double              jdouble             64 bits
    void                void                not applicable

为了使用方便，在JNI中做了如下定义：

    ```c++
    #define JNI_FALSE  0
    #define JNI_TRUE   1
    ```

定义类型`jsize`来表示基本索引和大小：

    ```c++
    typedef jint jsize;
    ```

<a name="3.2"></a>
## 3.2 引用类型

JNI引入了一系列引用类型来对应Java中不同种类的对象，JNI中的引用类型有如下继承关系：

* `jobject`
    * `jclass`(`java.lang.Class`对象)
    * `jstring`(`java.lang.String`对象)
    * `jarray`(数组对象)
        * `jobjectArray`(对象数组)
        * `jbooleanArray`(布尔数组)
        * `jbyteArray`(字节数组)
        * `jcharArray`(字符数组)
        * `jshortArray`(短整型数组)
        * `jintArray`(整型数组)
        * `jlongArray`(长整型数组)
        * `jfloatArray`(浮点数数组)
        * `jdoubleArray`(双精度浮点数数组)
    * `jthrowable`(`java.lang.Throwable`对象)

在C语言中，所有其他的JNI引用类型都被定义为`jobject`，例如：

    ```c
    typedef jobject jclass;
    ```

而在C++语言中，JNI引入了一系列冗余类来维持继承体系，例如：

    ```c++
    class _jobject {};
    class _jclass : public _jobject {};
    // ...
    typedef _jobject *jobject;
    typedef _jclass *jclass;
    ```

<a name="3.3"></a>
## 3.3 属性和方法ID

在JNI中，属性和方法的ID被定义普通的指针：

    ```c
    struct _jfieldID;              /* opaque structure */
    typedef struct _jfieldID *jfieldID;   /* field IDs */

    struct _jmethodID;              /* opaque structure */
    typedef struct _jmethodID *jmethodID; /* method IDs */
    ```

<a name="3.4"></a>
## 3.4 值类型

值类型`jvalue`是一个联合体(`union type`)，用于表示参数数组，其定义如下：

    ```c
    typedef union jvalue {
        jboolean z;
        jbyte    b;
        jchar    c;
        jshort   s;
        jint     i;
        jlong    j;
        jfloat   f;
        jdouble  d;
        jobject  l;
    } jvalue;
    ```

<a name="3.5"></a>
## 3.5 类型签名

JNI沿用了JVM内部类型签名表示方法，如下所示：

    类型签名                         Java类型
    Z                               boolean
    B                               byte
    C                               char
    S                               short
    I                               int
    J                               long
    F                               float
    D                               double
    L full class name               full class name
    [ type                          type[]
    (arg-types)ret-type	            method type

例如，有如下Java方法：

    ```java
    long f (int n, String s, int[] arr);
    ```

其类型签名为：

    (ILjava/lang/String;[I)J

<a name="3.6"></a>
## 3.6 自定义UTF-8编码

JNI使用自定义UTF-8编码来表示各种字符串类型，这与JVM所使用的编码相同。使用自定义UTF-8编码，确保只包含非空的ASCII字符的字符串可以只用一个字节来存储一个字符，而且所有的Unicode字符都可以正确表示。

在` \u0001`到`\u007F`范围内的字符，可以只用一个字节表示，其中的低7位用来表示字符的编码值，例如：

* 0xxxxxxx

空白符和`\u0080`到`\u07FF`范围内的字符使用两个字节(x和y)来表示，字符的编码值使用公式`((x & 0x1f) << 6) + (y & 0x3f)`来计算，例如：

* x: 110xxxxx
* y: 10yyyyyy

范围在`'\u0800`到`\uFFFF'`的字符使用3个字节(x、y和z)来表示，字符的编码值使用公式`((x & 0xf) << 12) + ((y & 0x3f) << 6) + (z & 0x3f)`来计算，例如：

* x: 1110xxxx
* y: 10yyyyyy
* z: 10zzzzzz

范围在`U+FFFF`之上的字符(称之为**补充字符**)使用6个字节(u、v、w、x、y和z)来表示，字符的编码值使用公式` 0x10000+((v&0x0f)<<16)+((w&0x3f)<<10)+(y&0x0f)<<6)+(z&0x3f)`来计算。

对于那些需要使用多个字节来存储的字符来说，他们在class文件中是以大端序(big-endian)来存储的。

这种表示方式与标准UTF-8格式有些区别：

* 空白符`0`使用两个字节来存储，因此JNI中的自定义UTF-8编码永远不会内嵌空白符
* JNI只使用了标准UTF-8格式中的1字节、2字节和3字节这3种格式，JVM无法识别4字节格式的标准UTF-8编码，而是使用2倍的3字节编码格式( two-times-three-byte format)

<a name="4"></a>
# 4 JNI函数

<a name="4.1"></a>
## 4.1 接口函数表

开发者可以通过本地方法的参数`JNIEnv`来访问JNI函数，参数`JNIEnv`是一个指针，其指向的数据结构包含了所有的JNI函数，参数的定义如下：

    ```c++
    typedef const struct JNINativeInterface *JNIEnv;
    ```

JVM会以下面的代码初始化接口函数表，其中需要注意的是，前几个为`NULL`的参数值是为了能够与**COM**兼容所预留的，之所以将这些参数值放在初始化列表的最前面，这样以后再添加与类操作相关的JNI函数时，可以放到`FindClass`后面，而不必放到函数表的末尾。

    ```c++
    const struct JNINativeInterface ... = {

        NULL,
        NULL,
        NULL,
        NULL,
        GetVersion,

        DefineClass,
        FindClass,

        FromReflectedMethod,
        FromReflectedField,
        ToReflectedMethod,

        GetSuperclass,
        IsAssignableFrom,

        ToReflectedField,

        Throw,
        ThrowNew,
        ExceptionOccurred,
        ExceptionDescribe,
        ExceptionClear,
        FatalError,

        PushLocalFrame,
        PopLocalFrame,

        NewGlobalRef,
        DeleteGlobalRef,
        DeleteLocalRef,
        IsSameObject,
        NewLocalRef,
        EnsureLocalCapacity,

        AllocObject,
        NewObject,
        NewObjectV,
        NewObjectA,

        GetObjectClass,
        IsInstanceOf,

        GetMethodID,

        CallObjectMethod,
        CallObjectMethodV,
        CallObjectMethodA,
        CallBooleanMethod,
        CallBooleanMethodV,
        CallBooleanMethodA,
        CallByteMethod,
        CallByteMethodV,
        CallByteMethodA,
        CallCharMethod,
        CallCharMethodV,
        CallCharMethodA,
        CallShortMethod,
        CallShortMethodV,
        CallShortMethodA,
        CallIntMethod,
        CallIntMethodV,
        CallIntMethodA,
        CallLongMethod,
        CallLongMethodV,
        CallLongMethodA,
        CallFloatMethod,
        CallFloatMethodV,
        CallFloatMethodA,
        CallDoubleMethod,
        CallDoubleMethodV,
        CallDoubleMethodA,
        CallVoidMethod,
        CallVoidMethodV,
        CallVoidMethodA,

        CallNonvirtualObjectMethod,
        CallNonvirtualObjectMethodV,
        CallNonvirtualObjectMethodA,
        CallNonvirtualBooleanMethod,
        CallNonvirtualBooleanMethodV,
        CallNonvirtualBooleanMethodA,
        CallNonvirtualByteMethod,
        CallNonvirtualByteMethodV,
        CallNonvirtualByteMethodA,
        CallNonvirtualCharMethod,
        CallNonvirtualCharMethodV,
        CallNonvirtualCharMethodA,
        CallNonvirtualShortMethod,
        CallNonvirtualShortMethodV,
        CallNonvirtualShortMethodA,
        CallNonvirtualIntMethod,
        CallNonvirtualIntMethodV,
        CallNonvirtualIntMethodA,
        CallNonvirtualLongMethod,
        CallNonvirtualLongMethodV,
        CallNonvirtualLongMethodA,
        CallNonvirtualFloatMethod,
        CallNonvirtualFloatMethodV,
        CallNonvirtualFloatMethodA,
        CallNonvirtualDoubleMethod,
        CallNonvirtualDoubleMethodV,
        CallNonvirtualDoubleMethodA,
        CallNonvirtualVoidMethod,
        CallNonvirtualVoidMethodV,
        CallNonvirtualVoidMethodA,

        GetFieldID,

        GetObjectField,
        GetBooleanField,
        GetByteField,
        GetCharField,
        GetShortField,
        GetIntField,
        GetLongField,
        GetFloatField,
        GetDoubleField,
        SetObjectField,
        SetBooleanField,
        SetByteField,
        SetCharField,
        SetShortField,
        SetIntField,
        SetLongField,
        SetFloatField,
        SetDoubleField,

        GetStaticMethodID,

        CallStaticObjectMethod,
        CallStaticObjectMethodV,
        CallStaticObjectMethodA,
        CallStaticBooleanMethod,
        CallStaticBooleanMethodV,
        CallStaticBooleanMethodA,
        CallStaticByteMethod,
        CallStaticByteMethodV,
        CallStaticByteMethodA,
        CallStaticCharMethod,
        CallStaticCharMethodV,
        CallStaticCharMethodA,
        CallStaticShortMethod,
        CallStaticShortMethodV,
        CallStaticShortMethodA,
        CallStaticIntMethod,
        CallStaticIntMethodV,
        CallStaticIntMethodA,
        CallStaticLongMethod,
        CallStaticLongMethodV,
        CallStaticLongMethodA,
        CallStaticFloatMethod,
        CallStaticFloatMethodV,
        CallStaticFloatMethodA,
        CallStaticDoubleMethod,
        CallStaticDoubleMethodV,
        CallStaticDoubleMethodA,
        CallStaticVoidMethod,
        CallStaticVoidMethodV,
        CallStaticVoidMethodA,

        GetStaticFieldID,

        GetStaticObjectField,
        GetStaticBooleanField,
        GetStaticByteField,
        GetStaticCharField,
        GetStaticShortField,
        GetStaticIntField,
        GetStaticLongField,
        GetStaticFloatField,
        GetStaticDoubleField,

        SetStaticObjectField,
        SetStaticBooleanField,
        SetStaticByteField,
        SetStaticCharField,
        SetStaticShortField,
        SetStaticIntField,
        SetStaticLongField,
        SetStaticFloatField,
        SetStaticDoubleField,

        NewString,

        GetStringLength,
        GetStringChars,
        ReleaseStringChars,

        NewStringUTF,
        GetStringUTFLength,
        GetStringUTFChars,
        ReleaseStringUTFChars,

        GetArrayLength,

        NewObjectArray,
        GetObjectArrayElement,
        SetObjectArrayElement,

        NewBooleanArray,
        NewByteArray,
        NewCharArray,
        NewShortArray,
        NewIntArray,
        NewLongArray,
        NewFloatArray,
        NewDoubleArray,

        GetBooleanArrayElements,
        GetByteArrayElements,
        GetCharArrayElements,
        GetShortArrayElements,
        GetIntArrayElements,
        GetLongArrayElements,
        GetFloatArrayElements,
        GetDoubleArrayElements,

        ReleaseBooleanArrayElements,
        ReleaseByteArrayElements,
        ReleaseCharArrayElements,
        ReleaseShortArrayElements,
        ReleaseIntArrayElements,
        ReleaseLongArrayElements,
        ReleaseFloatArrayElements,
        ReleaseDoubleArrayElements,

        GetBooleanArrayRegion,
        GetByteArrayRegion,
        GetCharArrayRegion,
        GetShortArrayRegion,
        GetIntArrayRegion,
        GetLongArrayRegion,
        GetFloatArrayRegion,
        GetDoubleArrayRegion,
        SetBooleanArrayRegion,
        SetByteArrayRegion,
        SetCharArrayRegion,
        SetShortArrayRegion,
        SetIntArrayRegion,
        SetLongArrayRegion,
        SetFloatArrayRegion,
        SetDoubleArrayRegion,

        RegisterNatives,
        UnregisterNatives,

        MonitorEnter,
        MonitorExit,

        GetJavaVM,

        GetStringRegion,
        GetStringUTFRegion,

        GetPrimitiveArrayCritical,
        ReleasePrimitiveArrayCritical,

        GetStringCritical,
        ReleaseStringCritical,

        NewWeakGlobalRef,
        DeleteWeakGlobalRef,

        ExceptionCheck,

        NewDirectByteBuffer,
        GetDirectBufferAddress,
        GetDirectBufferCapacity,

        GetObjectRefType
    };
    ```

<a name="4.2"></a>
## 4.2 版本信息

<a name="4.2.1"></a>
### 4.2.1 GetVersion

    ```c++
    jint GetVersion(JNIEnv *env);
    ```

函数返回当前本地方法接口的版本号。

该函数在`JNIEnv`接口函数表的索引位置为`4`。

参数：

    env         JNI接口指针

返回值：

    函数返回值的高16位是主版本号，低16位是次版本号
    In JDK/JRE 1.1, GetVersion() returns 0x00010001
    In JDK/JRE 1.2, GetVersion() returns 0x00010002
    In JDK/JRE 1.4, GetVersion() returns 0x00010004
    In JDK/JRE 1.6, GetVersion() returns 0x00010006

<a name="4.2.2"></a>
## 4.2.2 Constants

自JDK/JRE 1.2其，版本信息定义如下

    ```c++
    #define JNI_VERSION_1_1 0x00010001
    #define JNI_VERSION_1_2 0x00010002

    #define JNI_EDETACHED    (-2)              /* thread detached from the VM */
    #define JNI_EVERSION     (-3)              /* JNI version error 
    ```

自JDK/JRE 1.4之后，增加版本信息如下：

    ```c++
    #define JNI_VERSION_1_4 0x00010004
    ```

自JDK/JRE 1.4之后，增加版本信息如下：

    ```c++
    #define JNI_VERSION_1_6 0x00010006
    ```

<a name="4.3"></a>
## 4.3 类操作

<a name="4.3.1"></a>
### 4.3.1 DefineClass

    ```c++
    jclass DefineClass(JNIEnv *env, const char *name, jobject loader, const jbyte *buf, jsize bufLen);
    ```

从字节数组中载入一个类。在调用函数`DefineClass`之后，参数`buf`所指向的字节数组可能会释放掉。

该函数在`JNIEnv`接口函数表的索引位置为`5`。

参数：

    env         JNI接口指针
    name        待载入的类或接口的名字，字符串使用自定义UTF-8编码存储
    loader      指定用来载入类的加载器对象
    buf         包含了待载入的类信息的字节数组
    bufLen      包含了待载入的类信息的字节数组的长度

返回值：

    返回载入的Java类对象；如果发生错误，则返回NULL

异常：

    ClassFormatError        参数buf中存储的不是有效的类数据，抛出此异常
    ClassCircularityError   若类或接口被定义为自己的父类或父接口时，抛出此异常
    OutOfMemoryError        内存不足时，抛出此异常
    SecurityException       若待载入的异常位于"java"包下时，抛出此异常

<a name="4.3.2"></a>
### 4.3.2 FindClass

    ```c++
    jclass FindClass(JNIEnv *env, const char *name);
    ```

在JDK 1.1中，该方法用于载入一个局部定义的类(locally-defined class)，它会在环境变量`CLASSPATH`所指定的目录和压缩包中搜索待载入的类。

从JDK 1.2起，Java的安全模型运行非系统类(non-system classes)载入和调用本地方法。`FindClass`方法会使用声明了当前本地方法的类的类加载器来加载目标类。如果当前的本地方法属于一个系统类，则无需使用用户自定义的类加载器；否则会调用对应的类加载来加载目标类。

从JDK 1.2起，当通过调用接口(Invocation Interface)来调用`FindClass`时，是没有当前本地方法及其关联的类加载器的。这种情况下，会调用`ClassLoader.getSystemClassLoader`方法获取类加载器，可以加载`java.class.path`属性中指定的类。

参数`name`指定了待加载类的完整名字，或是数组的类型签名。

若需要载入`java.lang.String`类，则参数`name`的值为：

    java/lang/String

若需要载入`java.lang.Object[]`类，则参数`name`的值为

    [Ljava/lang/Object;

该函数在`JNIEnv`接口函数表的索引位置为`6`。

参数：

    env         JNI接口指针
    name        指定了待加载类的完整名字，或是数组的类型签名。包名的分隔符使用"/"表示，若name以"["开头，则表示要载入的是一个数组类型。name的值使用自定义UTF-8编码。

返回值：

    返回载入了的Java类对象；若发生错误，则返回NULL

异常：

    ClassFormatError        类数据格式错误，抛出此异常
    ClassCircularityError   若类或接口被定义为自己的父类或父接口时，抛出此异常
    OutOfMemoryError        内存不足时，抛出此异常
    NoClassDefFoundError    找不到指定的类型数据时，抛出此异常

<a name="4.3.3"></a>
### 4.3.3 GetSuperclass

    ```c++
    jclass GetSuperclass(JNIEnv *env, jclass clazz);
    ```

若参数`clazz`表示的是非`Object`的其他类对象，则该函数返回目标类的父类。

若参数`clazz`表示的`Object`类或是接口类，则该函数返回`NULL`。

该函数在`JNIEnv`接口函数表的索引位置为`10`。

参数：

    env         JNI接口指针
    clazz       Java类对象

返回值：

    返回目标类的父类或"NULL"

<a name="4.3.4"></a>
### 4.3.4 IsAssignableFrom

    ```c++
    jboolean IsAssignableFrom(JNIEnv *env, jclass clazz1, jclass clazz2);
    ```

判断参数`clazz1`所指定的类型是否可以安全的扩展为`clazz2`参数所指定的类型。

该函数在`JNIEnv`接口函数表的索引位置为`11`。

参数：

    env         JNI接口指针
    clazz1      源Java类型对象
    clazz2      目标Java类型对象

返回值：

    当满足以下任意条件时，返回"JNI_TRUE"，否则返回"JNI_FALSE"

    * clazz1和clazz2指向相同的Java类
    * clazz1是clazz2的父类
    * clazz1是clazz2的接口之一

<a name="4.4"></a>
### 4.4 异常

<a name="4.4.1"></a>
### 4.4.1 Throw

    ```c++
    jint Throw(JNIEnv *env, jthrowable obj);
    ```

抛出一个`java.lang.Throwable`类型的异常对象。

该函数在`JNIEnv`接口函数表的索引位置为`13`。

参数：

    env         JNI接口指针
    obj         类型为"java.lang.Throwable"的对象

返回值：

    函数调用成功返回0，否则返回负数。

异常：

    抛出一个`java.lang.Throwable`类型的异常对象。

<a name="4.4.2"></a>
### 4.4.2 ThrowNew

    ```c++
    jint ThrowNew(JNIEnv *env, jclass clazz, const char *message);
    ```

从已有的信息中构造一个新的异常对象并抛出，异常对象的类型由参数`clazz`指定，异常的错误信息由参数`message`指定。

该函数在`JNIEnv`接口函数表的索引位置为`14`。

参数：

    env         JNI接口指针
    clazz       待创建异常对象的类型，必须为"java.lang.Throwable"的自雷
    message     异常信息，使用自定义UTF-8进行编码

返回值：

    函数调用成功返回0，否则返回负数。

异常：

    抛出新创建的异常对象

<a name="4.4.3"></a>
### 4.4.3 ExceptionOccurred

    ```c++
    jthrowable ExceptionOccurred(JNIEnv *env);
    ```

该函数用于判断当前是否有被抛出的异常。除非是通过本地方法调用`ExceptionClear()`函数，或是在Java代码中捕获了异常对象，否则异常对象会一直处于被抛出的状态。

该函数在`JNIEnv`接口函数表的索引位置为`15`。

参数：

    env         JNI接口指针

返回值：

    返回当前正处于被抛出状态的异常；果没有异常被抛出，返回"NULL"

<a name="4.4.4"></a>
### 4.4.4 ExceptionDescribe

    ```c++
    void ExceptionDescribe(JNIEnv *env);
    ```

在系统错误报告通道(system error-reporting channel，例如标准错误`stderr`)打印异常和调用栈信息。该方法可用于调试目标代码。

该函数在`JNIEnv`接口函数表的索引位置为`16`。

参数：

    env         JNI接口指针

<a name="4.4.5"></a>
### 4.4.5 ExceptionClear

    ```c++
    void ExceptionClear(JNIEnv *env);
    ```

清除当前正处于被抛出状态的异常。若当前没有异常被抛出，则啥也不做。

该函数在`JNIEnv`接口函数表的索引位置为`17`。

参数：

    env         JNI接口指针

<a name="4.4.6"></a>
### 4.4.6 FatalError

    ```c++
    void FatalError(JNIEnv *env, const char *msg);
    ```

抛出一个致命错误(fatal error)，且并不期望JVM能够同错误中恢复。该函数不会返回。

该函数在`JNIEnv`接口函数表的索引位置为`18`。

参数：

    env         JNI接口指针
    msg         错误信息，使用自定义UTF-8编码

<a name="4.4.7"></a>
### 4.4.7 ExceptionCheck

该函数用于检查是否有被抛出的异常，且无需为异常对象创建新的局部引用。

若当前有被抛出的异常，函数返回`JNI_TRUE`，否则返回`JNI_FALSE`。

该函数在`JNIEnv`接口函数表的索引位置为`228`。

参数：

    env         JNI接口指针

返回值：

    若当前有被抛出的异常，函数返回`JNI_TRUE`，否则返回`JNI_FALSE`。

该方法自JDK/JRE 1.2之后引入。

<a name="4.5"></a>
## 4.5 全局引用和局部引用

<a name="4.5.1"></a>
### 4.5.1 全局引用

<a name="4.5.1.1"></a>
#### 4.5.1.1 NewGlobalRef

    ```c++
    jobject NewGlobalRef(JNIEnv *env, jobject obj);
    ```
创建一个新的全局引用来指向参数`obj`所指定的对象。参数`obj`可能是全局引用或局部引用。全局引用必须显式调用`DeleteGlobalRef()`来释放内存。

该函数在`JNIEnv`接口函数表的索引位置为`21`。

参数：

    env         JNI接口指针
    obj         全局引用或局部引用

返回值：

    返回新创建的全局引用；若系统内存不足，则返回"NULL"

<a name="4.5.1.2"></a>
#### 4.5.1.2 DeleteGlobalRef

    ```c++
    void DeleteGlobalRef(JNIEnv *env, jobject globalRef);
    ```

删除全局引用。

该函数在`JNIEnv`接口函数表的索引位置为`22`。

参数：
    env         JNI接口指针
    globalRef   待删除的全局引用

<a name="4.5.2"></a>
### 4.5.2 局部引用

局部引用只在本地方法的作用域内有效，在退出本地方法后，会自动释放掉局部引用。每个局部引用都会消耗一定量的JVM资源，因此开发者不能创建太多的局部引用，否则可能会导致系统内存不足。

<a name="4.5.2.1"></a>
#### 4.5.2.1 DeleteLocalRef

    ```c++
    void DeleteLocalRef(JNIEnv *env, jobject localRef);
    ```

删除局部引用。

该函数在`JNIEnv`接口函数表的索引位置为`23`。

参数：
    env         JNI接口指针
    localRef    待删除的局部引用

注意： 自JDK/JRE 1.1起，就提供了函数`DeleteLocalRef`供开发者手动删除局部引用。如果本地代码需要遍历很大的数组，那么及时删除无用的本地引用是非常必要的，否则可能会造成系统内存不足。

从JDK/JRE 1.2起，JNI提供另外4个函数来管理局部引用的生命周期。

<a name="4.5.2.2"></a>
#### 4.5.2.2 EnsureLocalCapacity

    ```c++
    jint EnsureLocalCapacity(JNIEnv *env, jint capacity);
    ```

该函数用于确认在当前线程中是否还能创建足够数量的本地引用。若可以，则函数返回0，否则返回负数，并抛出异常。

在进入本地方法前，JVM默认会确保本地方法可以创建16个局部引用。

为了支持向后兼容，JVM会额外多创建一些局部引用，超过参数`capacity`所指定的范围。(为了支持调试，JVM可能提示开发者，创建了过多的局部引用。在JDK中，开发者可以添加参数`-verbose:jni`来打开这种信息提示)。如果JVM无法创建由参数`capacity`所指定的那么多的局部引用，则JVM会调用`FatalError`函数强制退出。

该函数在`JNIEnv`接口函数表的索引位置为`26`。

参数：
    env         JNI接口指针
    capacity    局部引用的个数

该函数自JDK/JRE 1.2起可以使用。

<a name="4.5.2.3"></a>
#### 4.5.2.3  PushLocalFrame

    ```c++
    jint PushLocalFrame(JNIEnv *env, jint capacity);
    ```

创建一个局部引用帧，在其中可以创建指定数量的局部引用，具体数量由参数`capacity`指定。若函数调用成功，则返回0；否则返回负数，并抛出`OutOfMemoryError`异常。

注意，已经在前一个局部引用帧中创建的局部引用在当前栈帧中仍然有效。

该函数在`JNIEnv`接口函数表的索引位置为`19`。

参数：
    env         JNI接口指针
    capacity    局部引用的个数

该函数自JDK/JRE 1.2起可以使用。

<a name="4.5.2.4"></a>
#### 4.5.2.4 PopLocalFrame

    ```c++
    jobject PopLocalFrame(JNIEnv *env, jobject result);
    ```

弹出当前的局部引用帧，释放所有局部引用，返回在前一个局部引用帧需要使用的目标对象的局部引用。

若不希望给前一个局部引用帧返回引用，则参数`result`传入`NULL`即可。

该函数在`JNIEnv`接口函数表的索引位置为`20`。

参数：
    env         JNI接口指针
    result      需要返回给上层局部引用帧的局部引用

该函数自JDK/JRE 1.2起可以使用。

<a name="4.5.2.5"></a>
#### 4.5.2.5 NewLocalRef

    ```c++
    jobject NewLocalRef(JNIEnv *env, jobject ref);
    ```

为参数`ref`所指向的对象引用创建一个新的局部引用，目标对象引用可能是局部引用或全局引用。如果参数`ref`的值为`NULL`，则函数返回`NULL`。

该函数在`JNIEnv`接口函数表的索引位置为`25`。

参数：
    env         JNI接口指针
    ref         指向目标对象的引用

该函数自JDK/JRE 1.2起可以使用。

<a name="4.5.3"></a>
### 4.5.3 弱全局引用

弱全局引用是一种特殊的全局引用，区别在于被弱全局引用所指向的对象是可以被垃圾回收器回收掉的。当实际对象被回收掉时，弱全局引用实际上就指向了`NULL`。开发者需要调用`IsSameObject`函数来比较弱全局引用和`NULL`，以此判断弱全局引用所指向的对象是否已经被回收掉了。弱全局引用与Java中的弱引用作用相似。

2001.06新增声明

由于垃圾回收可能会在运行本地方法的时候发生，因此弱全局引用所指向的对象可能会在任意时刻被回收掉，开发者在使用的时候，需要注意此点。

尽管函数`IsSameObject`可用来判断弱全局引用是否指向了一个被回收掉的对象，但不能防止该对象在调用`IsSameObject`之后被释放掉。因此，函数`IsSameObject`的检查结果并不能确保以后再调用其他JNI函数的时候，目标对象没有被回收掉。

为了克服这个缺陷，推荐通过函数`NewLocalRef`或`NewGlobalRef`来访问目标对象，防止该对象被回收掉。在调用这些函数时，若目标对象已经被回收掉，则函数返回`NULL`，否则会返回一个强引用。在完成对目标对象的访问后，应立即显式删除新创建的引用对象。

弱全局引用比其他类型的弱引用(Java中的软引用或弱引用)更"弱"。若弱全局引用和软引用(或弱引用)指向了同一个对象，则在软引用(或引用)清除对目标对象的引用之前，弱全局引用都不会等同于`NULL`。

弱全局引用比Java内部需要执行`finalize`方法的对象的引用更"弱"。在目标对象执行完`finalize`方法之前，弱全局引用都不会等同于`NULL`。

交叉使用弱全局引用和虚引用(`PhantomReferences`)的结果是未定义的。就JVM的实现来说，既可以在处理虚引用之后再处理弱全局引用，也可以在处理虚引用之前先处理弱全局引用；弱全局引用和虚引用有可能会指向同一个对象，也可能不会。因此，不要交叉使用弱全局引用和虚引用。

<a name="4.5.3.1"></a>
#### 4.5.3.1 NewWeakGlobalRef

    ```c++
    jweak NewWeakGlobalRef(JNIEnv *env, jobject obj);
    ```

该函数用于创建一个弱全局引用。若参数`obj`指向的对象为`NULL`，则该函数返回`NULL`；若系统内存不足，该函数返回`NULL`，并抛出`OutOfMemoryError`错误。

该函数在`JNIEnv`接口函数表的索引位置为`226`。

参数：
    env         JNI接口指针
    obj         目标对象

该函数自JDK/JRE 1.2起可以使用。

<a name="4.5.3.2"></a>
#### 4.5.3.2 DeleteWeakGlobalRef

    ```c++
    void DeleteWeakGlobalRef(JNIEnv *env, jweak obj);
    ```

该函数删除一个弱全局引用。

该函数在`JNIEnv`接口函数表的索引位置为`227`。

参数：
    env         JNI接口指针
    obj         待删除的弱全局引用

该函数自JDK/JRE 1.2起可以使用。

<a name="4.5.4"></a>
### 4.5.4 对象操作

<a name="4.5.4.1"></a>
#### 4.5.4.1 AllocObject

    ```c++
    jobject AllocObject(JNIEnv *env, jclass clazz);
    ```

为新创建的Java对象分配内存，但不会调用构造函数。返回对该对象的引用。

参数`clazz`不可以指向数组类型。

该函数在`JNIEnv`接口函数表的索引位置为`27`。

参数：
    env         JNI接口指针
    clazz       Java的类型对象

返回：

    返回指向Java对象的引用；若如法构造该对象，则返回"NULL"

异常：

    InstantiationException    若clazz指向接口或其他抽象类型，则抛出该异常
    OutOfMemoryError          若系统内存不足，则抛出该异常

<a name="4.5.4.2"></a>
#### 4.5.4.2 NewObject, NewObjectA, NewObjectV

    ```c++
    jobject NewObject(JNIEnv *env, jclass clazz, jmethodID methodID, ...);

    jobject NewObjectA(JNIEnv *env, jclass clazz, jmethodID methodID, const jvalue *args);

    jobject NewObjectV(JNIEnv *env, jclass clazz, jmethodID methodID, va_list args);
    ```

这三个函数均可用来构造新的Java对象。其中，参数`methodID`用于指定调用哪个构造函数来初始化对象，其参数值必须是以`<init>`为方法名，以`void(V)`作为返回值调用函数`GetMethodID`所得。

参数`clazz`不可以是数组类型。

* `NewObject`： 使用函数`NewObject`时，开发者将传递给构造函数的参数直接放到参数`methodID`后面即可，`NewObject`函数会将这些参数传递给目标类型的构造函数。该函数在`JNIEnv`接口函数表的索引位置为`28`。
* `NewObjectA`： 使用函数`NewObjectA`时，开发者需要将传递给构造函数的参数包装为一个`jvalues`类型的数组，放置在参数`methodID`后面，`NewObjectA`从数组中获取参数，再传给目标类型的构造函数。该函数在`JNIEnv`接口函数表的索引位置为`30`。
* `NewObjectV`： 使用函数`NewObjectV`时，开发者需要将传递给构造函数的参数包装为类型为`va_list`的参数，放置在参数`methodID`后面，`NewObjectV`从数组中获取参数，再传给目标类型的构造函数。该函数在`JNIEnv`接口函数表的索引位置为`29`。

参数：
    env         JNI接口指针
    clazz       Java的类型对象
    methodID    目标构造函数的ID值
    args        要传递给构造函数的参数

返回：

    返回指向Java对象的引用；若无法构造该对象，返回NULL

异常：

    InstantiationException      若clazz指向接口或其他抽象类型，则抛出该异常
    OutOfMemoryError            若系统内存不足，则抛出该异常
    构造函数本身可能抛出的异常。

<a name="4.5.4.3"></a>
#### 4.5.4.3 GetObjectClass

    ```c++
    jclass GetObjectClass(JNIEnv *env, jobject obj);
    ```

返回某个对象的类型对象。

该函数在`JNIEnv`接口函数表的索引位置为`31`。

参数：
    env         JNI接口指针
    obj         目标对象，不可以为"NULL"

返回：

    返回某个对象的类型对象。

异常：

    InstantiationException      若clazz指向接口或其他抽象类型，则抛出该异常
    OutOfMemoryError            若系统内存不足，则抛出该异常

<a name="4.5.4.4"></a>
#### 4.5.4.4 GetObjectRefType

    ```c++
    jobjectRefType GetObjectRefType(JNIEnv* env, jobject obj);
    ```

返回目标对象的引用类型，其结果可能是局部引用、全局引用或弱全局引用。

该函数在`JNIEnv`接口函数表的索引位置为`232`。

参数：
    env         JNI接口指针
    obj         目标对象

返回：

    返回某个对象的类型对象。
    JNIInvalidRefType       = 0,
    JNILocalRefType         = 1,
    JNIGlobalRefType        = 2,
    JNIWeakGlobalRefType    = 3

其中，无效的引用类型是指，参数`obj`所指向的地址并不是由创建引用类型的函数或JNI函数所分配。例如`NULL`并不是有效的引用，因此`GetObjectRefType(env,NULL)`会返回`JNIInvalidRefType`。

另一方面，对于空引用，函数会返回创建该空引用时所用的引用类型。

函数`GetObjectRefType`不能用于已经被删除的引用。引用通常实现为指向内存中数据结构的指针，而目标数据结构可能会被JVM中其他引用分配服务所复用，因此一旦删除某个引用所指向的数据结构后，函数`GetObjectRefType`就无法指定返回值了。

该函数自JDK/JRE 1.6起可以使用。

<a name="4.5.4.5"></a>
#### 4.5.4.5 IsInstanceOf

    ```c++
    jboolean IsInstanceOf(JNIEnv *env, jobject obj, jclass clazz);
    ```

该函数用于判断目标对象是否是某个类型的实例。

该函数在`JNIEnv`接口函数表的索引位置为`32`。

参数：
    env         JNI接口指针
    obj         目标对象
    clazz       目标类型

返回：

    如果目标对象可以被扩展类目标类型，则返回"JNI_TRUE"；否则返回"JNI_FALSE"。

<a name="4.5.4.5"></a>
#### 4.5.4.5 IsSameObject

    ```c++
    jboolean IsSameObject(JNIEnv *env, jobject ref1, jobject ref2);
    ```

判断参数中两个引用是否指向同一个Java对象。

该函数在`JNIEnv`接口函数表的索引位置为`24`。

参数：
    env         JNI接口指针
    ref1        对象引用1
    ref2        对象引用2

返回：

    若是，则返回"JNI_TRUE"；否则返回"JNI_FALSE"。

<a name="4.5.5"></a>
### 4.5.5 访问对象的属性

<a name="4.5.5.1"></a>
#### 4.5.5.1 GetFieldID

    ```c++
    jfieldID GetFieldID(JNIEnv *env, jclass clazz, const char *name, const char *sig);
    ```

该函数返回某个类型的实例属性的ID，目标属性由属性名和签名来指定。`Get<type>Field`和`Set<type>Field`系列函数使用该ID值来获取属性的值。

对未初始化的类调用该函数时，会先初始化目标类。

该函数无法获取数组的长度；应该使用`GetArrayLength()`。

该函数在`JNIEnv`接口函数表的索引位置为`94`。

参数：
    env         JNI接口指针
    clazz       目标类型
    name        属性名，以自定义UTF-8编码，以0结尾
    sig         签名，以自定义UTF-8编码，以0结尾

返回：

    返回属性ID；若操作失败，返回"NULL"

异常：

    NoSuchFieldError                若没有目标属性，则抛出该错误
    ExceptionInInitializerError     若类初始化事变，则抛出该错误
    OutOfMemoryError                若内存不足，则抛出该错误

<a name="4.5.5.2"></a>
#### 4.5.5.2 `Get<type>Field`系列函数

    ```c++
    NativeType Get<type>Field(JNIEnv *env, jobject obj, jfieldID fieldID);
    ```

该系列函数用于获取目标实例的目标属性的值，其中目标属性`fieldID`是通过`GetFieldID()`函数所得。

下面的内容描述了不同类型的函数和返回类型的对应关系。

    function            native type
    GetObjectField()	jobject
    GetBooleanField()	jboolean
    GetByteField()	    jbyte
    GetCharField()	    jchar
    GetShortField()	    jshort
    GetIntField()	    jint
    GetLongField()	    jlong
    GetFloatField()	    jfloat
    GetDoubleField()	jdouble

该系列函数在`JNIEnv`接口函数表的索引位置如下所示：

    function            index
    GetObjectField()	95
    GetBooleanField()	96
    GetByteField()	    97
    GetCharField()	    98
    GetShortField()	    99
    GetIntField()	    100
    GetLongField()	    101
    GetFloatField()	    102
    GetDoubleField()	103

参数：

    env         JNI接口指针
    obj         指向Java对象的引用，不可以为"NULL"
    fieldID     有效的属性ID

返回：

    返回目标属性的值。

<a name="4.5.5.3"></a>
#### 4.5.5.3 `Set<type>Field`系列函数

    ```c++
    void Set<type>Field(JNIEnv *env, jobject obj, jfieldID fieldID, NativeType value);
    ```

该系列函数用于对目标对象的目标属性进行赋值，其中目标属性`fieldID`是通过`GetFieldID()`函数所得。

下面的内容描述了不同类型的函数和属性类型的对应关系。

    function            type
    SetObjectField()	jobject
    SetBooleanField()	jboolean
    SetByteField()	    jbyte
    SetCharField()	    jchar
    SetShortField()	    jshort
    SetIntField()	    jint
    SetLongField()	    jlong
    SetFloatField()	    jfloat
    SetDoubleField()	jdouble

该系列函数在`JNIEnv`接口函数表的索引位置如下所示：

    function            index
    SetObjectField()	104
    SetBooleanField()	105
    SetByteField()	    106
    SetCharField()	    107
    SetShortField()	    108
    SetIntField()	    109
    SetLongField()	    110
    SetFloatField()	    111
    SetDoubleField()	112

参数：

    env         JNI接口指针
    obj         指向Java对象的引用，不可以为"NULL"
    fieldID     有效的属性ID
    value       待赋值的内容

<a name="4.5.6"></a>
### 4.5.6 调用实例方法

<a name="4.5.6.1"></a>
#### 4.5.6.1 GetMethodID

    ```c++
    jmethodID GetMethodID(JNIEnv *env, jclass clazz, const char *name, const char *sig);
    ```

返回某个类或接口的实例方法ID。目标方法可能被定义于类的某个父类，并通过名字和参数来唯一定位。

对未初始化的类调用该函数时，会先初始化目标类。

若要获取构造函数的方法ID，需要以`<init>`作为方法名，以`void(V)`作为返回类型。

该函数在`JNIEnv`接口函数表的索引位置是`33`。

参数：

    env         JNI接口指针
    clazz       目标类型
    name        目标方法的名字，以自定义UTF-8编码，以0结尾
    sig         目标方法签名，以自定义UTF-8编码，以0结尾

返回：

    返回目标方法的ID；若找不到目标方法，返回"NULL"。

异常：

    NoSuchMethodError               若找不到目标方法，抛出该错误
    ExceptionInInitializerError     若类初始化错误，抛出该错误
    OutOfMemoryError                若系统内存不足，抛出该错误

<a name="4.5.6.2"></a>
#### 4.5.6.2 `Call<type>Method` `Call<type>MethodA`和`Call<type>MethodV`系列函数

    ```c++
    NativeType Call<type>Method(JNIEnv *env, jobject obj, jmethodID methodID, ...);

    NativeType Call<type>MethodA(JNIEnv *env, jobject obj, jmethodID methodID, const jvalue *args);

    NativeType Call<type>MethodV(JNIEnv *env, jobject obj,  jmethodID methodID, va_list args);
    ```

这3个系列的函数用于在本地方法中调用Java对象的实例方法，其区别在于如何处理被调用函数的参数。

调用目标对象的实例方法时，方法的ID值必须通过调用函数`GetMethodID()`来获取。

需要注意的是，如果被调用的函数是私有方法或构造函数，则必须通过其本身的类来获取方法ID，而不能通过其父类获取。

* `Call<type>Method`： 使用函数`Call<type>MethodwObject`时，开发者将传递给目标函数的参数直接放到参数`methodID`后面即可，函数`Call<type>Method`会将这些参数传递给目标函数。
* `Call<type>MethodA`： 使用函数`Call<type>MethodA`时，开发者需要将传递给目标函数的参数包装为一个`jvalues`类型的数组，放置在参数`methodID`后面，`Call<type>MethodA`从数组中获取参数，再传给目标函数。
* `Call<type>MethodV`： 使用函数`Call<type>MethodV`时，开发者需要将传递给目标函数的参数包装为类型为`va_list`的参数，放置在参数`methodID`后面，`Call<type>MethodV`从数组中获取参数，再传给目标函数。

下表描述不同类型所对应的具体函数：

    function                    native type
    CallVoidMethod()            void
    CallVoidMethodA()           void
    CallVoidMethodV()	        void
    CallObjectMethod()          jobject
    CallObjectMethodA()         jobject
    CallObjectMethodV()	        jobject
    CallBooleanMethod()         jboolena
    CallBooleanMethodA()        jboolean
    CallBooleanMethodV()        jboolean
    CallByteMethod()            jbyte
    CallByteMethodA()           jbyte
    CallByteMethodV()	        jbyte
    CallCharMethod()            jchar
    CallCharMethodA()           jchar
    CallCharMethodV()	        jchar
    CallShortMethod()           jshort
    CallShortMethodA()          jshort
    CallShortMethodV()	        jshort
    CallIntMethod()             jint
    CallIntMethodA()            jint
    CallIntMethodV()	        jint
    CallLongMethod()            jlong
    CallLongMethodA()           jlong
    CallLongMethodV()	        jlong
    CallFloatMethod()           jfloat
    CallFloatMethodA()          jfloat
    CallFloatMethodV()	        jfloat
    CallDoubleMethod()          jdouble
    CallDoubleMethodA()         jdouble
    CallDoubleMethodV()	        jdouble

下表展示了各个函数在`JNIEnv`接口函数表的索引：

    function                index
    CallVoidMethod()        61
    CallVoidMethodA()       63
    CallVoidMethodV()	    62
    CallObjectMethod()      34
    CallObjectMethodA()     36
    CallObjectMethodV()	    35
    CallBooleanMethod()     37
    CallBooleanMethodA()    39
    CallBooleanMethodV()	38
    CallByteMethod()        40
    CallByteMethodA()       42
    CallByteMethodV()	    41
    CallCharMethod()        43
    CallCharMethodA()       45
    CallCharMethodV()	    44
    CallShortMethod()       46
    CallShortMethodA()      48
    CallShortMethodV()	    47
    CallIntMethod()         49
    CallIntMethodA()        51
    CallIntMethodV()	    50
    CallLongMethod()        52
    CallLongMethodA()       54
    CallLongMethodV()	    53
    CallFloatMethod()       55
    CallFloatMethodA()      57
    CallFloatMethodV()	    56
    CallDoubleMethod()      58
    CallDoubleMethodA()     60
    CallDoubleMethodV()	    59

参数：

    env         JNI接口指针
    obj         指向Java对象的引用
    methodID    目标方法的ID值

返回：

    返回调用目标方法的返回值

异常：

    抛出在执行目标方法时抛出的异常

<a name="4.5.6.3"></a>
#### 4.5.6.3 `CallNonvirtual<type>Method` `CallNonvirtual<type>MethodA` `CallNonvirtual<type>MethodV`系列函数

    ```c++
    NativeType CallNonvirtual<type>Method(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, ...);

    NativeType CallNonvirtual<type>MethodA(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, const jvalue *args);

    NativeType CallNonvirtual<type>MethodV(JNIEnv *env, jobject obj, jclass clazz, jmethodID methodID, va_list args);
    ```

这3个系列的函数用于调用某个Java对象的实例方法，方法的ID值通过调用`GetMethodID()`方法获得。

`CallNonvirtual<type>Method`系列函数和`Call<type>Method`系列函数的区别在于，`Call<type>Method`系列函数是基于实例的类来调用目标方法的，`CallNonvirtual<type>Method`系列函数是基于参数`clazz`指定的类来调用目标方法的，而且参数`methodID`也应该是在该类上获得的。获取参数`methodID`是，必须是从对象的真实类型或其父类中获得的。

* `CallNonvirtual<type>Method`： 使用函数`CallNonvirtual<type>Method`时，开发者将传递给目标函数的参数直接放到参数`methodID`后面即可，函数`CallNonvirtual<type>Method`会将这些参数传递给目标函数。
* `CallNonvirtual<type>MethodA`： 使用函数`CallNonvirtual<type>MethodA`时，开发者需要将传递给目标函数的参数包装为一个`jvalues`类型的数组，放置在参数`methodID`后面，`CallNonvirtual<type>MethodA`从数组中获取参数，再传给目标函数。
* `CallNonvirtual<type>MethodV`： 使用函数`CallNonvirtual<type>MethodV`时，开发者需要将传递给目标函数的参数包装为类型为`va_list`的参数，放置在参数`methodID`后面，`CallNonvirtual<type>MethodV`从数组中获取参数，再传给目标函数。

下表描述不同类型所对应的具体函数：

    function                        native type
    CallNonvirtualVoidMethod()      void
    CallNonvirtualVoidMethodA()     void
    CallNonvirtualVoidMethodV()	    void
    CallNonvirtualObjectMethod()    jobject
    CallNonvirtualObjectMethodA()   jobject
    CallNonvirtualObjectMethodV()   jobject
    CallNonvirtualBooleanMethod()   jboolean
    CallNonvirtualBooleanMethodA()  jboolean
    CallNonvirtualBooleanMethodV()  jboolean
    CallNonvirtualByteMethod()      jbyte
    CallNonvirtualByteMethodA()     jbyte
    CallNonvirtualByteMethodV()	    jbyte
    CallNonvirtualCharMethod()      jchar
    CallNonvirtualCharMethodA()     jchar
    CallNonvirtualCharMethodV()	    jchar
    CallNonvirtualShortMethod()     jshort
    CallNonvirtualShortMethodA()    jshort
    CallNonvirtualShortMethodV()	jshort
    CallNonvirtualIntMethod()       jint
    CallNonvirtualIntMethodA()      jint
    CallNonvirtualIntMethodV()	    jint
    CallNonvirtualLongMethod()      jlong
    CallNonvirtualLongMethodA()     jlong
    CallNonvirtualLongMethodV()	    jlong
    CallNonvirtualFloatMethod()     jfloat
    CallNonvirtualFloatMethodA()    jfloat
    CallNonvirtualFloatMethodV()	jfloat
    CallNonvirtualDoubleMethod()    jdouble
    CallNonvirtualDoubleMethodA()   jdouble
    CallNonvirtualDoubleMethodV()	jdouble

下表展示了各个函数在`JNIEnv`接口函数表的索引：

    function                        index
    CallNonvirtualVoidMethod()      91
    CallNonvirtualVoidMethodA()     93
    CallNonvirtualVoidMethodV()	    92
    CallNonvirtualObjectMethod()    64
    CallNonvirtualObjectMethodA()   66
    CallNonvirtualObjectMethodV()	65
    CallNonvirtualBooleanMethod()   67
    CallNonvirtualBooleanMethodA()  69
    CallNonvirtualBooleanMethodV()	68
    CallNonvirtualByteMethod()      70
    CallNonvirtualByteMethodA()     72
    CallNonvirtualByteMethodV()	    71
    CallNonvirtualCharMethod()      73
    CallNonvirtualCharMethodA()     75
    CallNonvirtualCharMethodV()	    74
    CallNonvirtualShortMethod()     76
    CallNonvirtualShortMethodA()    78
    CallNonvirtualShortMethodV()	77
    CallNonvirtualIntMethod()       79
    CallNonvirtualIntMethodA()      81
    CallNonvirtualIntMethodV()	    80
    CallNonvirtualLongMethod()      82
    CallNonvirtualLongMethodA()     84
    CallNonvirtualLongMethodV()	    83
    CallNonvirtualFloatMethod()     85
    CallNonvirtualFloatMethodA()    87
    CallNonvirtualFloatMethodV()	86
    CallNonvirtualDoubleMethod()    88
    CallNonvirtualDoubleMethodA()   90
    CallNonvirtualDoubleMethodV()	89

参数：

    env         JNI接口指针
    clazz       目标类对象
    obj         指向Java对象的引用
    methodID    目标方法的ID值

返回：

    返回调用目标方法的返回值

异常：

    抛出调用目标方法时抛出的异常

<a name="4.5.7"></a>
### 4.5.7 访问静态属性

<a name="4.5.7.1"></a>
#### 4.5.7.1 GetStaticFieldID

    ```c++
    jfieldID GetStaticFieldID(JNIEnv *env, jclass clazz, const char *name, const char *sig);
    ```

返回某个类的静态属性的ID值，目标属性通过名字和签名来定位。`GetStatic<type>Field`和`SetStatic<type>Field`系列函数会通过该ID值来访问静态属性的值。

对于未初始化的类，调用该函数时，会先完成类的初始化。

该函数在`JNIEnv`接口函数表的索引位置是`144`。

参数：

    env         JNI接口指针
    clazz       目标类对象
    name        目标方法的名字，以自定义UTF-8编码，以0结尾
    sig         目标方法签名，以自定义UTF-8编码，以0结尾

返回：

    返回目标属性的ID值；若目标属性不存在，返回"NULL"

异常：

    NoSuchFieldError                若目标属性不存在，抛出该错误
    ExceptionInInitializerError     若初始化类时发生错误，抛出该错误
    OutOfMemoryError                若系统内存不足，抛出该错误

<a name="4.5.7.2"></a>
#### 4.5.7.2 `GetStatic<type>Field`系列函数

    ```c++
    NativeType GetStatic<type>Field(JNIEnv *env, jclass clazz, jfieldID fieldID);
    ```

该系列函数用于访问目标对象的静态属性值，属性ID必须通过调用函数`GetStaticFieldID()`来获取。

下表描述不同类型所对应的具体函数：

    function                    native type
    GetStaticObjectField()	    jobject
    GetStaticBooleanField()	    jboolean
    GetStaticByteField()	    jbyte
    GetStaticCharField()	    jchar
    GetStaticShortField()	    jshort
    GetStaticIntField()	        jint
    GetStaticLongField()	    jlong
    GetStaticFloatField()	    jfloat
    GetStaticDoubleField()	    jdouble

下表描述了不同函数在`JNIEnv`中的索引位置：

    function                    index
    GetStaticObjectField()	    145
    GetStaticBooleanField()	    146
    GetStaticByteField()	    147
    GetStaticCharField()	    148
    GetStaticShortField()	    149
    GetStaticIntField()	        150
    GetStaticLongField()	    151
    GetStaticFloatField()	    152
    GetStaticDoubleField()	    153

参数：

    env         JNI接口指针
    clazz       目标类对象
    fieldID     静态属性域的ID值

返回：

    返回静态属性的值

<a name="4.5.7.3"></a>
#### 4.5.7.3 `SetStatic<type>Field`系列函数

    ```c++
    void SetStatic<type>Field(JNIEnv *env, jclass clazz, jfieldID fieldID, NativeType value);
    ```

该函数用于设置某个对象的目标属性值。目标属性的ID值需要通过调用函数`GetStaticFieldID()`来获取。

下表描述不同类型所对应的具体函数：

    function                    native type
    SetStaticObjectField()	    jobject
    SetStaticBooleanField()	    jboolean
    SetStaticByteField()	    jbyte
    SetStaticCharField()	    jchar
    SetStaticShortField()	    jshort
    SetStaticIntField()	        jint
    SetStaticLongField()	    jlong
    SetStaticFloatField()	    jfloat
    SetStaticDoubleField()	    jdouble

下表描述了不同函数在`JNIEnv`中的索引位置：

    function                    index
    SetStaticObjectField()	    154
    SetStaticBooleanField()	    155
    SetStaticByteField()	    156
    SetStaticCharField()	    157
    SetStaticShortField()	    158
    SetStaticIntField()	        159
    SetStaticLongField()	    160
    SetStaticFloatField()	    161
    SetStaticDoubleField()	    162

参数：

    env         JNI接口指针
    clazz       目标类对象
    fieldID     目标属性域的ID
    value       待设置的属性值。

<a name="4.5.8"></a>
### 4.5.8 调用静态方法

<a name="4.5.8.1"></a>
#### 4.5.8.1 GetStaticMethodID

    ```c++
    jmethodID GetStaticMethodID(JNIEnv *env, jclass clazz, const char *name, const char *sig);
    ```

返回某个静态方法的ID值，目标方法由方法名和签名来定位。

对于未初始化的类，调用该方法时，会先进行类的初始化。

该函数在`JNIEnv`接口函数表的索引位置是`113`。

参数：

    env         JNI接口指针
    clazz       目标类对象
    name        目标方法的名字，以自定义UTF-8编码，以0结尾
    sig         目标方法签名，以自定义UTF-8编码，以0结尾

返回：

    返回目标方法的ID值；若操作失败，返回"NULL"

异常：

    NoSuchMethodError               若目标方法不存在，抛出该错误
    ExceptionInInitializerError     若初始化类时发生错误，抛出该错误
    OutOfMemoryError                若系统内存不足，抛出该错误

<a name="4.5.8.2"></a>
#### 4.5.8.2 `CallStatic<type>Method` `CallStatic<type>MethodA` `CallStatic<type>MethodV`系列函数

    ```c++
    NativeType CallStatic<type>Method(JNIEnv *env, jclass clazz, jmethodID methodID, ...);

    NativeType CallStatic<type>MethodA(JNIEnv *env, jclass clazz, jmethodID methodID, jvalue *args);

    NativeType CallStatic<type>MethodV(JNIEnv *env, jclass clazz, jmethodID methodID, va_list args);
    ```

这3个系列函数用于调用由参数`methodID`指定的静态方法。

* `CallStatic<type>Method`： 开发者将传递给目标函数的参数直接放到参数`methodID`后面即可，函数`CallStatic<type>Method`会将这些参数传递给目标函数。
* `CallStatic<type>MethodA`： 开发者需要将传递给目标函数的参数包装为一个`jvalues`类型的数组，放置在参数`methodID`后面，`CallStatic<type>MethodA`从数组中获取参数，再传给目标函数。
* `CallStatic<type>MethodV`： 开发者需要将传递给目标函数的参数包装为类型为`va_list`的参数，放置在参数`methodID`后面，`CallStatic<type>MethodV`从数组中获取参数，再传给目标函数。

下表描述不同类型所对应的具体函数：

    function                    native type
    CallStaticVoidMethod()      void
    CallStaticVoidMethodA()     void
    CallStaticVoidMethodV()	    void
    CallStaticObjectMethod()    jobject
    CallStaticObjectMethodA()   jobejct
    CallStaticObjectMethodV()	jobject
    CallStaticBooleanMethod()   jboolean
    CallStaticBooleanMethodA()  jboolean
    CallStaticBooleanMethodV()	jboolean
    CallStaticByteMethod()      jbyte
    CallStaticByteMethodA()     jbyte
    CallStaticByteMethodV()	    jbyte
    CallStaticCharMethod()      jchar
    CallStaticCharMethodA()     jchar
    CallStaticCharMethodV()	    jchar
    CallStaticShortMethod()     jshort
    CallStaticShortMethodA()    jshort
    CallStaticShortMethodV()	jshort
    CallStaticIntMethod()       jint
    CallStaticIntMethodA()      jint
    CallStaticIntMethodV()	    jint
    CallStaticLongMethod()      jlong
    CallStaticLongMethodA()     jlong
    CallStaticLongMethodV()	    jlong
    CallStaticFloatMethod()     jfloat
    CallStaticFloatMethodA()    jfloat
    CallStaticFloatMethodV()	jfloat
    CallStaticDoubleMethod()    jdouble
    CallStaticDoubleMethodA()   jdouble
    CallStaticDoubleMethodV()	jdouble

下表描述了不同函数在`JNIEnv`中的索引位置：

    function                    index
    CallStaticVoidMethod()      141
    CallStaticVoidMethodA()     143
    CallStaticVoidMethodV()	    142
    CallStaticObjectMethod()    114
    CallStaticObjectMethodA()   116
    CallStaticObjectMethodV()	115
    CallStaticBooleanMethod()   117
    CallStaticBooleanMethodA()  119
    CallStaticBooleanMethodV()	118
    CallStaticByteMethod()      120
    CallStaticByteMethodA()     122
    CallStaticByteMethodV()	    121
    CallStaticCharMethod()      123
    CallStaticCharMethodA()     125
    CallStaticCharMethodV()	    124
    CallStaticShortMethod()     126
    CallStaticShortMethodA()    128
    CallStaticShortMethodV()	127
    CallStaticIntMethod()       129
    CallStaticIntMethodA()      131
    CallStaticIntMethodV()	    130
    CallStaticLongMethod()      132
    CallStaticLongMethodA()     134
    CallStaticLongMethodV()	    133
    CallStaticFloatMethod()     135
    CallStaticFloatMethodA()    137
    CallStaticFloatMethodV()	136
    CallStaticDoubleMethod()    138
    CallStaticDoubleMethodA()   140
    CallStaticDoubleMethodV()	139

参数：

    env         JNI接口指针
    clazz       目标类对象
    methodID    目标方法的ID值

返回：

    返回调用目标方法的返回值

异常：

    抛出调用目标方法时抛出的异常

<a name="4.5.9"></a>
### 4.5.9 字符串操作

<a name="4.5.9.1"></a>
#### 4.5.9.1 NewString

    ```c++
    jstring NewString(JNIEnv *env, const jchar *unicodeChars, jsize len);
    ```

该用法用于以根据Unicode字符数组创建新的`java.lang.String`对象。

该函数在`JNIEnv`接口函数表的索引位置是`163`。

参数：

    env             JNI接口指针
    unicodeChars    指向Unicode字符串的指针
    len             Unicode字符串的长度

返回：

    返回新创建的"java.lang.Object"对象；如果无法创建新对象，则返回"NULL"

异常：

    OutOfMemoryError    若系统内存不足，则抛出该错误

<a name="4.5.9.2"></a>
#### 4.5.9.2 GetStringLength

    ```c++
    jsize GetStringLength(JNIEnv *env, jstring string);
    ```

返回Java字符串的长度，即Unicode字符的个数。

该函数在`JNIEnv`接口函数表的索引位置是`164`。

参数：

    env             JNI接口指针
    string          Java的字符串对象

返回：

    返回字符串的长度

<a name="4.5.9.3"></a>
#### 4.5.9.3 GetStringChars

    ```c++
    const jchar * GetStringChars(JNIEnv *env, jstring string, jboolean *isCopy);
    ```

返回指向字符串对象中Unicode字符数组的指针。在调用函数`ReleaseStringChars()`之后，该指针的值变为无效。

调用该函数时，若参数`isCopy`不为`NULL`，则：

* 若执行了拷贝，则`isCopy`被设置为`JNI_TRUE`
* 若未执行拷贝，则`isCopy`被设置为`JNI_FALSE`

该函数在`JNIEnv`接口函数表的索引位置是`165`。

参数：

    env             JNI接口指针
    string          Java的字符串对象
    isCopy          指向布尔值的指针

返回：

    返回指向Unicode字符串的指针；如果操作失败，返回"NULL"

<a name="4.5.9.3"></a>
#### 4.5.9.3 ReleaseStringChars

    ```c++
    void ReleaseStringChars(JNIEnv *env, jstring string, const jchar *chars);
    ```

该函数用于通知JVM"本地代码不会再访问某个字符串的字符数组了"，参数`chars`的值是通过调用函数`GetStringChars()`所得。

该函数在`JNIEnv`接口函数表的索引位置是`166`。

参数：

    env             JNI接口指针
    string          Java的字符串对象
    chars           指向Unicode字符串的指针

<a name="4.5.9.4"></a>
#### 4.5.9.4 NewStringUTF

    ```c++
    jstring NewStringUTF(JNIEnv *env, const char *bytes);
    ```

该函数用于构造一个`java.lang.String`对象，字符串的内容由参数`bytes`指定，以自定义UTF-8编码。

该函数在`JNIEnv`接口函数表的索引位置是`167`。

参数：

    env             JNI接口指针
    bytes           指向以自定义UTF-8编码的字符串内容

返回：

    返回一个字符串对象；若无法创建，则返回"NULL"

异常：

    OutOfMemoryError    若系统内存不足，则抛出此错误

<a name="4.5.9.5"></a>
#### 4.5.9.5 GetStringUTFLength

    ```c++
    jsize GetStringUTFLength(JNIEnv *env, jstring string);
    ```

返回以自定义UTF-8编码的字符串所使用字节的个数。

该函数在`JNIEnv`接口函数表的索引位置是`168`。

参数：

    env             JNI接口指针
    string          字符串对象

返回：

    返回字符串所使用的字节的个数。

<a name="4.5.9.6"></a>
#### 4.5.9.6 GetStringUTFChars

    ```c++
    const char * GetStringUTFChars(JNIEnv *env, jstring string, jboolean *isCopy);
    ```

返回指向以自定义UTF-8编码的字符串的字节数组的指针，当调用函数`ReleaseStringUTFChars()`后，该指针的值变为无效。

调用该函数时，若参数`isCopy`不为`NULL`，则：

* 若执行了拷贝，则`isCopy`被设置为`JNI_TRUE`
* 若未执行拷贝，则`isCopy`被设置为`JNI_FALSE`

该函数在`JNIEnv`接口函数表的索引位置是`169`。

参数：

    env             JNI接口指针
    string          字符串对象
    isCopy          指向布尔值的指针

返回：

    返回指向以自定义UTF-8编码的字符串的字节数组的指针；若操作失败，则返回"NULL"

<a name="4.5.9.7"></a>
#### 4.5.9.7 ReleaseStringUTFChars

    ```c++
    void ReleaseStringUTFChars(JNIEnv *env, jstring string, const char *utf);
    ```

该函数用于通知JVM，"本地代码不会再访问参数utf指向的数组"，参数`utf`的值由函数`GetStringUTFChars()`所得。

该函数在`JNIEnv`接口函数表的索引位置是`170`。

参数：

    env             JNI接口指针
    string          字符串对象
    utf             指向字符串内容的指针

注意：在JDK/JRE 1.1中，开发者可以得到原生类型的数组；到了JDK/JRE 1.2时，添加了一系列函数，以便在本地代码中可以获取以UTF-8或自定义UTF-8编码的字符。参见下面的函数介绍。

<a name="4.5.9.8"></a>
#### 4.5.9.8 GetStringRegion

    ```c++
    void GetStringRegion(JNIEnv *env, jstring str, jsize start, jsize len, jchar *buf);
    ```

该函数用于拷贝指定长度的Unicode字符到指定的字符数组中。

若索引超过限制，则抛出`StringIndexOutOfBoundsException`异常。

该函数在`JNIEnv`接口函数表的索引位置是`220`。

该函数自JDK/JRE 1.2之后可用。

<a name="4.5.9.9"></a>
#### 4.5.9.9 GetStringUTFRegion

    ```c++
    void GetStringUTFRegion(JNIEnv *env, jstring str, jsize start, jsize len, char *buf);
    ```

从目标字符串中，拷贝指定数量的Unicode字符，转换为自定义UTF-8编码，再放置到指定的数组中。

若索引超过限制，则抛出`StringIndexOutOfBoundsException`异常。

该函数在`JNIEnv`接口函数表的索引位置是`221`。

该函数自JDK/JRE 1.2之后可用。

<a name="4.5.9.10"></a>
#### 4.5.9.10 GetStringCritical, ReleaseStringCritical

    ```c++
    const jchar * GetStringCritical(JNIEnv *env, jstring string, jboolean *isCopy);

    void ReleaseStringCritical(JNIEnv *env, jstring string, const jchar *carray);
    ```

这两个函数的语义与前面提到的函数`GetStringChars`和`ReleaseStringChars`类似。在获取字符数组时，JVM会尽量返回指向字符串元素的指针；否则，会拷贝一份数组内容并返回。`Get/ReleaseStringCritical`函数和`Get/ReleaseStringChars`函数的关键区别在于如何调用他们：如果代码段中调用了`GetStringCritical`函数，则在调用`ReleaseStringChars`之前，本地代码**禁止**再调用其他JNI函数，否则会阻塞当前线程的运行。

函数`GetPrimitiveArrayCritical`和`ReleasePrimitiveArrayCritical`的调用方式于此类似。

函数在`JNIEnv`接口函数表的索引位置如下所示：

    GetStringCritical       224
    ReleaseStingCritical    225

该函数自JDK/JRE 1.2之后可用。

<a name="4.5.10"></a>
### 4.5.10 数组操作

<a name="4.5.10.1"></a>
#### 4.5.10.1 GetArrayLength

    ```c++
    jsize GetArrayLength(JNIEnv *env, jarray array);
    ```

返回数组的长度。

函数在`JNIEnv`接口函数表的索引位置为`171`。

参数：

    env             JNI接口指针
    array           数组对象

返回：

    返回数组的长度

<a name="4.5.10.2"></a>
#### 4.5.10.2 NewObjectArray

    ```c++
    jobjectArray NewObjectArray(JNIEnv *env, jsize length, jclass elementClass, jobject initialElement);
    ```

构造一个指定类型的数组对象，并以指定值来初始化数组内容。

函数在`JNIEnv`接口函数表的索引位置为`172`。

参数：

    env             JNI接口指针
    length          数组长度
    elementClass    数组类型
    initialElement  数组内容的初始值

返回：

    返回数组对象；若无法创建数组对象，返回"NULL"

异常：

    OutOfMemoryError    系统内存不足时，抛出该错误

<a name="4.5.10.3"></a>
#### 4.5.10.3 GetObjectArrayElement

    ```c++
    jobject GetObjectArrayElement(JNIEnv *env, jobjectArray array, jsize index);
    ```

返回`Object`类型数组中的某个元素。

函数在`JNIEnv`接口函数表的索引位置为`173`。

参数：

    env             JNI接口指针
    array           目标数组
    index           目标索引位置

返回：

    返回目标索引位置的元素

异常：

    ArrayIndexOutOfBoundsException      若指定的索引并不在目标数组的有效范围内，抛出该异常

<a name="4.5.10.4"></a>
#### 4.5.10.4 SetObjectArrayElement

    ```c++
    void SetObjectArrayElement(JNIEnv *env, jobjectArray array, jsize index, jobject value);
    ```

对目标数组的指定索引位置赋值。

函数在`JNIEnv`接口函数表的索引位置为`173`。

参数：

    env             JNI接口指针
    array           目标数组
    index           目标索引位置
    value           待设置的值

异常：

    ArrayIndexOutOfBoundsException      若指定的索引并不在目标数组的有效范围内，抛出该异常
    ArrayStoreException                 若待设置的值不是数组类型的子类，则抛出该异常

<a name="4.5.10.5"></a>
#### 4.5.10.5 `New<PrimitiveType>Array`系列函数

    ```c++
    ArrayType New<PrimitiveType>Array(JNIEnv *env, jsize length);
    ```

该系列函数用于创建原生类型的数组对象。

下表描述了原生类型与具体函数的对应关系

    function            array type
    NewBooleanArray()	jbooleanArray
    NewByteArray()	    jbyteArray
    NewCharArray()	    jcharArray
    NewShortArray()	    jshortArray
    NewIntArray()	    jintArray
    NewLongArray()	    jlongArray
    NewFloatArray()	    jfloatArray
    NewDoubleArray()	jdoubleArray

下表描述了具体函数在`JNIEnv`接口函数中的索引位置

    function            index
    NewBooleanArray()	175
    NewByteArray()	    176
    NewCharArray()	    177
    NewShortArray()	    178
    NewIntArray()	    179
    NewLongArray()	    180
    NewFloatArray()	    181
    NewDoubleArray()	182

参数：

    env             JNI接口指针
    length          数组的长度

返回：

    返回新创建的对象；若无法创建，则返回"NULL"

<a name="4.5.10.6"></a>
#### 4.5.10.6 `Get<PrimitiveType>ArrayElements`系列函数

    ```c++
    NativeType *Get<PrimitiveType>ArrayElements(JNIEnv *env, ArrayType array, jboolean *isCopy);
    ```

该系列函数用于获取数组内容，返回指向内容的指针，当调用函数`Release<PrimitiveType>ArrayElements()`后，该指针的值变为无效。由于该函数返回的值可能是原始数组内容的拷贝，因此修改其数组元素时并不能反映到原始数组中。这时需要调用函数`Release<PrimitiveType>ArrayElements()`函数，使修改生效。

调用该函数时，若参数`isCopy`不为`NULL`，则：

* 若执行了拷贝，则`isCopy`被设置为`JNI_TRUE`
* 若未执行拷贝，则`isCopy`被设置为`JNI_FALSE`

无论布尔值在JVM中是如何表示的，函数`GetBooleanArrayElements()`都会返回`jboolean`类型的指针，其中每个字节表示一个数组元素。其他类型的数组在内存中都是连续存放的。

下表描述了原生类型和具体函数的对应关系：

    function                    array type      native type      
    GetBooleanArrayElements()	jbooleanArray	jboolean
    GetByteArrayElements()	    jbyteArray	    jbyte
    GetCharArrayElements()	    jcharArray	    jchar
    GetShortArrayElements()	    jshortArray	    jshort
    GetIntArrayElements()	    jintArray	    jint
    GetLongArrayElements()	    jlongArray	    jlong
    GetFloatArrayElements()	    jfloatArray	    jfloat
    GetDoubleArrayElements()	jdoubleArray	jdouble

下表描述了函数在`JNIEnv`接口函数中的索引位置：

    function                    index
    GetBooleanArrayElements()	183
    GetByteArrayElements()	    184
    GetCharArrayElements()	    185
    GetShortArrayElements()	    186
    GetIntArrayElements()	    187
    GetLongArrayElements()	    188
    GetFloatArrayElements()	    189
    GetDoubleArrayElements()	190

参数：

    env             JNI接口指针
    array           数组的长度
    isCopy          指向布尔值的指针

返回：

    返回指向数组元素的指针；若操作失败，则返回"NULL"

<a name="4.5.10.7"></a>
#### 4.5.10.7 `Release<PrimitiveType>ArrayElements`系列函数

    ```c++
    void Release<PrimitiveType>ArrayElements(JNIEnv *env, ArrayType array, NativeType *elems, jint mode);
    ```

该系列函数用于通知JVM，"本地代码不会再访问数组元素了"。参数`elems`是指向数组元素的指针，通过调用函数`Get<PrimitiveType>ArrayElements()`获得。如果必要的话，该函数会将所有对数组元素的更新拷贝回原始数组。

参数`mode`指定应该如何释放数组缓冲。如果参数`elems`所指向的内容并非是原始数组的拷贝，则参数`mode`不起作用；否则按照如下参数值来执行：

    mode	        actions
    0	            将数组内容拷贝回原始数组，并释放参数elems指向的缓冲区
    JNI_COMMIT	    将数组内容拷贝回原始数组，但不释放参数elems指向的缓冲区
    JNI_ABORT	    释放参数elems指向的缓冲区，但不会将数组内容拷贝回原始数组

大部分情况下，开发者都会将参数`mode`设置为0，以便同步数组内容到原始数组。其他参数值给了开发者更灵活的操作，使用时请小心。

下表描述了原生类型和具体函数的对应关系：

    function                        array type      native type
    ReleaseBooleanArrayElements()	jbooleanArray	jboolean
    ReleaseByteArrayElements()	    jbyteArray	    jbyte
    ReleaseCharArrayElements()	    jcharArray	    jchar
    ReleaseShortArrayElements()	    jshortArray	    jshort
    ReleaseIntArrayElements()	    jintArray	    jint
    ReleaseLongArrayElements()	    jlongArray	    jlong
    ReleaseFloatArrayElements()	    jfloatArray	    jfloat
    ReleaseDoubleArrayElements()	jdoubleArray	jdouble

下表描述了函数在`JNIEnv`接口函数中的索引位置：

    function                        index
    ReleaseBooleanArrayElements()	191
    ReleaseByteArrayElements()	    192
    ReleaseCharArrayElements()	    193
    ReleaseShortArrayElements()	    194
    ReleaseIntArrayElements()	    195
    ReleaseLongArrayElements()	    196
    ReleaseFloatArrayElements()	    197
    ReleaseDoubleArrayElements()	198

参数：

    env             JNI接口指针
    array           数组对象
    elems           指向数组元素数组的指针
    mode            释放方式

<a name="4.5.10.8"></a>
#### 4.5.10.8 `Get<PrimitiveType>ArrayRegion`系列函数

    ```c++
    void Get<PrimitiveType>ArrayRegion(JNIEnv *env, ArrayType array, jsize start, jsize len, NativeType *buf);
    ```

该系列函数用于将数组中某个范围的元素拷贝到指定的缓冲区中。

下表描述了原生类型和具体函数的对应关系：

    function                    array type      native type
    GetBooleanArrayRegion()	    jbooleanArray	jboolean
    GetByteArrayRegion()	    jbyteArray	    jbyte
    GetCharArrayRegion()	    jcharArray	    jchar
    GetShortArrayRegion()	    jshortArray	    jhort
    GetIntArrayRegion()	        jintArray	    jint
    GetLongArrayRegion()	    jlongArray	    jlong
    GetFloatArrayRegion()	    jfloatArray	    jloat
    GetDoubleArrayRegion()	    jdoubleArray	jdouble

下表描述了函数在`JNIEnv`接口函数中的索引位置：

    function                    index
    GetBooleanArrayRegion()	    199
    GetByteArrayRegion()	    200
    GetCharArrayRegion()	    201
    GetShortArrayRegion()	    202
    GetIntArrayRegion()	        203
    GetLongArrayRegion()	    204
    GetFloatArrayRegion()	    205
    GetDoubleArrayRegion()	    206

参数：

    env             JNI接口指针
    array           数组对象
    start           起始位置
    len             拷贝的长度
    buf             指定的缓冲区

异常：

    ArrayIndexOutOfBoundsException      若指定的索引不在指定数组的有效范围内，抛出该异常

<a name="4.5.10.9"></a>
#### 4.5.10.9 `Set<PrimitiveType>ArrayRegion`系列函数

    ```c++
    void Set<PrimitiveType>ArrayRegion(JNIEnv *env, ArrayType array, jsize start, jsize len, const NativeType *buf);
    ```

该系列函数用于将指定缓冲区中的内容拷贝到数组的指定的范围内。

下表描述了原生类型和具体函数的对应关系：

    function                    array type      native type
    SetBooleanArrayRegion()	    jbooleanArray	jboolean
    SetByteArrayRegion()	    jbyteArray	    jbyte
    SetCharArrayRegion()	    jcharArray	    jchar
    SetShortArrayRegion()	    jshortArray	    jshort
    SetIntArrayRegion()	        jintArray	    jint
    SetLongArrayRegion()	    jlongArray	    jlong
    SetFloatArrayRegion()	    jfloatArray	    jfloat
    SetDoubleArrayRegion()	    jdoubleArray	jdouble

下表描述了函数在`JNIEnv`接口函数中的索引位置：

    function                    index
    SetBooleanArrayRegion()	    207
    SetByteArrayRegion()	    208
    SetCharArrayRegion()	    209
    SetShortArrayRegion()	    210
    SetIntArrayRegion()	        211
    SetLongArrayRegion()	    212
    SetFloatArrayRegion()	    213
    SetDoubleArrayRegion()	    214

参数：

    env             JNI接口指针
    array           数组对象
    start           起始位置
    len             拷贝的长度
    buf             指定的缓冲区

异常：

    ArrayIndexOutOfBoundsException      若指定的索引不在指定数组的有效范围内，抛出该异常

>注意，在JDK/JRE 1.1中，开发者可以通过函数`Get/Release<primitivetype>ArrayElements`来获取指向原生数组元素的指针。若JVM支持**pinning**机制，则该函数会返回指向原始数据的指针；否则会返回指向拷贝数据的指针。
>
>在JDK/JRE 1.3中，引入了新的函数，即便JVM不支持**pinning**机制，也可以返回原始数据的指针。

<a name="4.5.10.10"></a>
#### 4.5.10.10 GetPrimitiveArrayCritical, ReleasePrimitiveArrayCritical

    ```c++
    void * GetPrimitiveArrayCritical(JNIEnv *env, jarray array, jboolean *isCopy);

    void ReleasePrimitiveArrayCritical(JNIEnv *env, jarray array, void *carray, jint mode);
    ```

这两个函数的语义与前面提到的函数`Get/Release<primitivetype>ArrayElements`类似。JVM会尽量返回指向原始数组的指针；实在不行的话，会返回拷贝数组的指针。他们关键区别在于调用方式。

在调用函数`GetPrimitiveArrayCritical`之后，本地代码应该尽快调用函数`ReleasePrimitiveArrayCritical`。正如函数名所表达的，这两个函数中间的代码，是"**关键代码**"。在关键代码中，本地代码**禁止**再调用其他JNI函数或系统调用，否则可能会造成当前线程阻塞。

因为存在这种限制条件，即便JVM不支持**pinning**机制，本地代码调用该函数时很有可能会得到指向原始数组的指针。例如，当通过该函数获取到指向原始数组的指针时，JVM可能会临时禁用垃圾回收器。

多次调用`Get/Release<primitivetype>ArrayElements`时，可以嵌套进行，例如：

    ```c++
    jint len = (*env)->GetArrayLength(env, arr1);
    jbyte *a1 = (*env)->GetPrimitiveArrayCritical(env, arr1, 0);
    jbyte *a2 = (*env)->GetPrimitiveArrayCritical(env, arr2, 0);
    /* We need to check in case the VM tried to make a copy. */
    if (a1 == NULL || a2 == NULL) {
        ... /* out of memory exception thrown */
    }
    memcpy(a1, a2, len);
    (*env)->ReleasePrimitiveArrayCritical(env, arr2, a2, 0);
    (*env)->ReleasePrimitiveArrayCritical(env, arr1, a1, 0);
    ```

注意，如果JVM的内部实现将数组表示为其他格式的话，函数`GetPrimitiveArrayCritical`可能会返回一个数组的拷贝。因此，开发者需要检查函数的返回值是否为`NULL`，此时表示系统内存不足。

下表描述了函数在`JNIEnv`接口函数中的索引位置：

    GetPrimitiveArrayCritical       222
    ReleasePrimitiveArrayCritical   223

该函数自JDK/JRE 1.2之后可用。

<a name="4.5.11"></a>
### 4.5.11 注册本地方法

<a name="4.5.11.1"></a>
#### 4.5.11.1 RegisterNatives

    ```c++
    jint RegisterNatives(JNIEnv *env, jclass clazz, const JNINativeMethod *methods, jint nMethods);
    ```

该函数用于为指定类型注册本地方法。类型由参数`clazz`指定。参数`methods`指定了要注册的本地方法的数组，每个元素都包含有名字、签名和函数指针，其中名字和签名都是以自定义UTF-8编码的。参数`nMethods`指定了要注册的本地方法的个数。数据结构`JNINativeMethod`的定义如下：

    ```c++
    typedef struct {

        char *name;

        char *signature;

        void *fnPtr;

    } JNINativeMethod;
    ```

函数指针必须具有如下类型的签名：

    ```c++
    ReturnType (*fnPtr)(JNIEnv *env, jobject objectOrClass, ...);
    ```

函数在`JNIEnv`接口函数中的索引位置为`215`。

参数：

    env             JNI接口指针
    clazz           Java的类型对象
    methods         待注册的本地方法数组
    nMethods        待注册的本地方法数量

返回：

    若成功，返回"0"；否则返回负数

异常：

    NoSuchMethodError       若在类中找不到指定的方法，或指定方法不是本地方法，则抛出该错误

<a name="4.5.11.2"></a>
#### 4.5.11.2 UnregisterNatives

    ```c++
    jint UnregisterNatives(JNIEnv *env, jclass clazz);
    ```

取消注册某个类中所有的本地方法。取消注册后，目标类会回到链接、注册本地方法之前的状态。

一般情况下，这个方法不应该使用。它只是提供了一种重新载入和链接本地库的特殊方式。

函数在`JNIEnv`接口函数中的索引位置为`216`。

参数：

    env             JNI接口指针
    clazz           目标类型对象

返回：

    若成功，返回"0"；否则返回负数

<a name="4.5.12"></a>
### 4.5.12 监视器操作

<a name="4.5.12.1"></a>
#### 4.5.12.1 MonitorEnter

    ```c++
    jint MonitorEnter(JNIEnv *env, jobject obj);
    ```

该函数用于进入目标对象所持有的监视器。

参数`obj`的值**禁止**为`NULL`。

每个Java对象都有一个监视器与之相关联。若当前线程已经持有了目标对象的监视器，则调用该方法时会增加监视器中计数器的值，这个值表示当前线程进入监视器的次数；若目标对象的监视器还没有被任何线程持有，则将当前线程设置为监视器的持有者，并将计数器设置为1；若目标对象的监视器已经被其他线程持有，则当前线程会等待，知道监视器被释放，然后尝试重新进入监视器。

通过函数`MonitorEnter`进入的监视器，不能通过JVM指令`monitorexit`或退出`synchronized`方法来释放。函数`MonitorEnter`和`monitorenter`指令可能竞争同一个对象的监视器。

为了避免死锁，通过函数`MonitorEnter`进入的监视器，必须通过函数`MonitorExit`来释放，除非调用函数`DetachCurrentThread`来隐式的释放监视器。

函数在`JNIEnv`接口函数中的索引位置为`217`。

参数：

    env             JNI接口指针
    obj             目标对象

返回：

    若成功，返回"0"；否则返回负数

<a name="4.5.12.2"></a>
#### 4.5.12.2 MonitorExit

    ```c++
    jint MonitorExit(JNIEnv *env, jobject obj);
    ```

在调用该函数时，当前线程必须持有目标对象的监视器。成功调用该函数后，会将监视器中的计数器的值减1。若计数器的值变为0，则当前线程释放目标监视器。

**禁止**本地方法调用该函数来释放通过`synchronized`方法或`monitorenter`指令进入的监视器。

函数在`JNIEnv`接口函数中的索引位置为`218`。

参数：

    env             JNI接口指针
    obj             目标对象

返回：

    若成功，返回"0"；否则返回负数

异常：

    IllegalMonitorStateException    若当前线程没持有目标监视器时，抛出该异常。

<a name="4.5.13"></a>
### 4.5.13 NIO支持

NIO相关的函数使本地代码可以访问`java.nio`的直接缓冲。直接缓冲的内容可能会驻留在本地内存中，而非放到可执行垃圾回收的堆中。有关直接缓冲相关的信息，参见[New I/O][108]和[java.nio.ByteBuffer][109]的说明。

在JDK/JRE 1.4中，JNI引入了3个新的函数，可以创建、校验和操作直接缓冲。

* [NewDirectByteBuffer][110]
* [GetDirectBufferAddress][111]
* [GetDirectBufferCapacity][112]

所有的JVM实现都必须支持这些函数，但并不要求支持通过JNI访问直接缓冲。如果JVM不支持通过JNI访问直接缓冲，则函数`NewDirectByteBuffer`和`GetDirectBufferAddress`只能返回`NULL`，而函数`GetDirectBufferCapacity`只能返回`-1`。如果JVM支持通过JNI访问直接缓冲，则必须返回正确的值。

<a name="4.5.13.1"></a>
#### 4.5.13.1 NewDirectByteBuffer

    ```c++
    jobject NewDirectByteBuffer(JNIEnv* env, void* address, jlong capacity);
    ```

创建`java.nio.ByteBuffer`对象，并为其分配一块指定起始位置和长度的内存。

调用该函数的本地代码，必须确保缓冲区指向了一块有效的内存区域，至少是可读的，某些场景下，还需要是可写的。在Java代码中访问无效内存区域的话，可能会返回任意值，可能会无效，或是抛出未指定的异常。

函数在`JNIEnv`接口函数中的索引位置为`229`。

参数：

    env             JNI接口指针
    address         内存区域的开始位置，不可为NULL
    capacity        要开辟的内存区域的大小，单位是字节

返回：

    返回一个指向新创建的"java.nio.ByteBuffer"的局部引用。如果函数调用发生异常，或是JVM不支持通过JNI访问直接缓冲，返回NULL

异常：

    OutOfMemoryError    若分配ByteBuffer对象失败，抛出该错误

该函数自JDK/JRE 1.4之后可用。

<a name="4.5.13.2"></a>
#### 4.5.13.2 GetDirectBufferAddress

    ```c++
    void* GetDirectBufferAddress(JNIEnv* env, jobject buf);
    ```

返回`java.nio.Buffer`对象所引用的内存区域的起始位置。

该函数使本地代码与Java代码可以访问同一块直接缓冲。

函数在`JNIEnv`接口函数中的索引位置为`230`。

参数：

    env             JNI接口指针
    buf             "java.nio.Buffer"对象的引用，不可以为NULL

返回：

    返回直接缓冲的起始位置。

    以下情况返回"NULL"：
    * 内存区域未定义
    * 参数"buf"不是"java.nio.Buffer"对象
    * JVM不支持通过JNI访问直接缓冲

该函数自JDK/JRE 1.4之后可用。

<a name="4.5.13.3"></a>
#### 4.5.13.3 GetDirectBufferCapacity

GetDirectBufferCapacity

    ```c++
    jlong GetDirectBufferCapacity(JNIEnv* env, jobject buf);
    ```

返回直接缓冲的大小，
Fetches and returns the capacity of the memory region referenced by the given direct java.nio.Buffer. The capacity is the number of elements that the memory region contains.

函数在`JNIEnv`接口函数中的索引位置为`231`。

参数：

    env             JNI接口指针
    buf             "java.nio.Buffer"对象的引用，不可以为NULL

返回：

    返回直接缓冲去的大小。

    以下情况返回"NULL"：
    * 参数"buf"所指向的不是"java.nio.Buffer"对象
    * JVM不支持通过JNI访问直接缓冲
    * 参数"buf"所指向的未对齐的视图缓冲，而且处理器架构不支持访问未对齐的内存区域

该函数自JDK/JRE 1.4之后可用。

<a name="4.5.14"></a>
### 4.5.14 反射支持

开发者可以通过JNI函数来访问Java的方法和属性。Java的反射API使开发者可以在运行时获取Java类的内部信息。JNI提供了一系列转换方法使开发者可以方便的将JNI中的方法/属性ID值转换为反射调用所需的方法和属性对象。

<a name="4.5.14.1"></a>
#### 4.5.14.1 FromReflectedMethod

    ```c++
    jmethodID FromReflectedMethod(JNIEnv *env, jobject method);
    ```

将`java.lang.reflect.Method`对象或`java.lang.reflect.Constructor`转换为JNI的方法ID。

函数在`JNIEnv`接口函数中的索引位置为`7`。

该函数自JDK/JRE 1.2之后可用。

<a name="4.5.14.2"></a>
#### 4.5.14.2 FromReflectedField

    ```c++
    jfieldID FromReflectedField(JNIEnv *env, jobject field);
    ```

将`java.lang.reflect.Field`对象转换为JNI的属性ID。

函数在`JNIEnv`接口函数中的索引位置为`8`。

该函数自JDK/JRE 1.2之后可用。

<a name="4.5.14.3"></a>
#### 4.5.14.3 ToReflectedMethod

    ```c++
    jobject ToReflectedMethod(JNIEnv *env, jclass cls, jmethodID methodID, jboolean isStatic);
    ```

将方法ID转换为`java.lang.reflect.Method`或`java.lang.reflect.Constructor`对象。参数`isStatic`用于表示目标方法是否是静态方法。

如果方法执行失败，返回`0`，并抛出`OutOfMemoryError`错误。

函数在`JNIEnv`接口函数中的索引位置为`9`。

该函数自JDK/JRE 1.2之后可用。

<a name="4.5.14.4"></a>
#### 4.5.14.4 ToReflectedField

    ```c++
    jobject ToReflectedField(JNIEnv *env, jclass cls, jfieldID fieldID, jboolean isStatic);
    ```

将属性ID转换为`java.lang.reflect.Field`对象，参数`isStatic`用于表示目标属性是否是静态属性。

如果方法执行失败，返回`0`，并抛出`OutOfMemoryError`错误。

函数在`JNIEnv`接口函数中的索引位置为`12`。

该函数自JDK/JRE 1.2之后可用。

<a name="4.5.15"></a>
### 4.5.15 JVM接口

<a name="4.5.15.1"></a>
#### 4.5.15.1 GetJavaVM

    ```c++
    jint GetJavaVM(JNIEnv *env, JavaVM **vm);
    ```

返回与当前线程关联的JVM接口。执行结果存放于参数`vm`中。

函数在`JNIEnv`接口函数中的索引位置为`219`。

参数：

    env             JNI接口指针
    vm              用于返回结果的指针

返回：

    若执行成功，返回"0"，否则返回负数。

<a name="5"></a>
# 5 Invocation API

Invocation API使软件供应商可以将Java嵌入到任意本地应用中。供应商在发布包含Java的应用程序时，可以不必包含JVM的源代码。

<a name="5.1"></a>
## 5.1 Overview

下面的代码展示了如何在Invocation API中调用函数。在这个示例中，C++代码创建了一个JVM，并调用了名为`Main.test`的静态方法。为便于理解，这里省略了错误检查。

    ```c++
    #include <jni.h>       /* where everything is defined */
    ...
    JavaVM *jvm;       /* denotes a Java VM */
    JNIEnv *env;       /* pointer to native method interface */
    JavaVMInitArgs vm_args; /* JDK/JRE 6 VM initialization arguments */
    JavaVMOption* options = new JavaVMOption[1];
    options[0].optionString = "-Djava.class.path=/usr/lib/java";
    vm_args.version = JNI_VERSION_1_6;
    vm_args.nOptions = 1;
    vm_args.options = options;
    vm_args.ignoreUnrecognized = false;
    /* load and initialize a Java VM, return a JNI interface
        * pointer in env */
    JNI_CreateJavaVM(&jvm, (void**)&env, &vm_args);
    delete options;
    /* invoke the Main.test method using the JNI */
    jclass cls = env->FindClass("Main");
    jmethodID mid = env->GetStaticMethodID(cls, "test", "(I)V");
    env->CallStaticVoidMethod(cls, mid, 100);
    /* We are done. */
    jvm->DestroyJavaVM();
    ```

This example uses three functions in the API. The Invocation API allows a native application to use the JNI interface pointer to access VM features. The design is similar to Netscape’s JRI Embedding Interface.

在这个示例中，使用了3个函数。Invocation API允许本地应用程序通过JNI接口指针访问JVM的特性。


<a name="5.1.1"></a>
### 5.1.1 创建JVM

函数`JNI_CreateJavaVM()`可以载入并初始化一个JVM，然后返回JNI接口指针，调用了该函数的线程可被认为是主线程。

<a name="5.1.2"></a>
### 5.1.2 连接到JVM

JNI接口指针(即`JNIEnv`)仅在当前线程内有效。其他的线程若需要访问JVM实例，**必须**先调用函数`AttachCurrentThread`将自己连接到JVM，以便能获取到JNI接口指针。连接到JVM后，本地线程就可以像运行在本地方法中的Java线程一样正常工作了。在调用函数`DetachCurrentThread()`后，本地线程会断开与JVM的连接。

连接到JVM的线程应该具有足够大的栈空间来完成预定的任务。每个线程栈的大小取决于不同操作系统的设置。例如，对于`pthread`来说，线程栈的大小可以在创建线程时通过参数`pthread_attr_t`传入。

<a name="5.1.3"></a>
### 5.1.3 断开与JVM的连接

本地线程在退出之前，必须调用函数`DetachCurrentThread()`来断开与JVM的连接。需要注意的是，如果有Java方法在调用栈的话，线程无法断开与JVM的连接。

<a name="5.1.4"></a>
### 5.1.4 卸载JVM

函数`JNI_DestroyJavaVM()`可用于卸载一个JVM实例。

调用该函数后，JVM会等到除当前线程外所有非守护的用户线程都退出时才会真正退出。用户线程包括Java线程和连接到JVM的本地线程。之所以有这种限制，是因为Java线程和连接到JVM的本地线程可能会持有系统资源，例如锁、窗口等，JVM无法自动释放这些资源。若当前线程成为最后一个非守护的用户线程时，释放系统资源的工作则可以由开发者自行控制。

<a name="5.2"></a>
## 5.2 库与版本管理

本地库在加载之后，对所有的类加载器都是可见的。不同类加载器中的不同类可能会连接到同一个本地线程。这会导致两个问题：

* 本地库被类加载器loader1中的类Class1载入后，可能会被错误的连接到类加载器loader2中的类Class1
* 本地线程可能会混淆不同类加载器中的类，这会打破类加载器所构建的命名空间，导致类型安全问题

每个类加载器管理自己的本地库集合，同一个JNI本地库不能被多个类加载器载入，否则会抛出`UnsatisfiedLinkError`错误。例如，当某个本地库被不同类加载器载入时，`System.loadLibrary`方法会抛出`UnsatisfiedLinkError`错误。这么做有以下优点：

* 基于类加载器的命名空间隔离机制得以保留。本地库不会混淆不同类加载器中的类。
* 本地库可以在对应的类加载器被垃圾回收器回收时卸载掉。

为了更好的进行版本控制和资源管理，JNI库可以导出函数`JNI_OnLoad`和`JNI_OnUnload`来处理。

<a name="5.2.1"></a>
### 5.2.1 JNI_OnLoad

    ```c++
    jint JNI_OnLoad(JavaVM *vm, void *reserved);
    ```

在载入本地库时(例如调用函数`System.loadLibrary`)，JVM会调用函数`JNI_OnLoad`。函数`JNI_OnLoad`必须返回本地库所所需的JNI版本号。

为了能够使用新增的JNI函数，本地库需要导出函数`JNI_OnLoad`，且该函数必须返回`JNI_VERSION_1_2`。如果本地库没有导出函数`JNI_OnLoad`，则JVM会假设本地库仅仅需要版本号为`JNI_VERSION_1_1`的支持。如果JVM无法识别函数`JNI_OnLoad`返回值，则JVM会卸载掉该本地库，就像没再载入过一样。

    ```c++
    JNI_Onload_L(JavaVM *vm, void *reserved);
    ```

如果库`L`是静态链接的，则在调用函数`System.loadLibrary("L")`或其他等效API时，JVM会调用函数`JNI_OnLoad_L`，参数和返回值与调用函数`JNI_OnLoad`相同。函数`JNI_OnLoad_L`必须返回本地库所需要的JNI版本号，必须大于等于`JNI_VERSION_1_8`。如果JVM无法识别函数`JNI_OnLoad`返回值，则JVM会卸载掉该本地库，就像没再载入过一样。

<a name="5.2.2"></a>
### 5.2.2 JNI_OnUnload

    ```c++
    void JNI_OnUnload(JavaVM *vm, void *reserved);
    ```

当载入过本地库的类加载器被回收掉时，会JVM会调用本地库的函数`JNI_OnUnload`来执行清理工作。由于该函数的执行上下文无法预知，因此开发者在该函数中应尽可能保守的使用JVM服务。

注意，函数`JNI_OnLoad`和`JNI_OnUnload`是可选的，并非是JVM导出的。

    ```c++
    JNI_OnUnload_L(JavaVM *vm, void *reserved);
    ```

若库是静态链接的，则载入了该库的类加载器被回收掉时，JVM会调用函数`JNI_OnUnload_L`来执行清理函数。由于该函数的执行上下文无法预知，因此开发者在该函数中应尽可能保守的使用JVM服务。

注意：载入本地库是一个整体过程，使本地库和个函数入口得以在JVM中完成注册；而通过操作系统级别的调用来载入本地库(例如`dlopen`)并不能完成目标。从类加载器中调用本地函数，会将本地库载入到内存中，返回指向本地库的句柄，以便后续搜索本地库的入口点。在返回句柄并注册本地库后，Java的本地类加载器完成整个载入过程。

<a name="5.3"></a>
## 5.3 Invocation API

`JavaVM`是指向Invocation API函数表的指针，下面的代码展示了该函数表的定义：

    ```c++
    typedef const struct JNIInvokeInterface *JavaVM;

    const struct JNIInvokeInterface ... = {
        NULL,
        NULL,
        NULL,

        DestroyJavaVM,
        AttachCurrentThread,
        DetachCurrentThread,

        GetEnv,

        AttachCurrentThreadAsDaemon
    };
    ```

注意，`JNI_GetDefaultJavaVMInitArgs()` `JNI_GetCreatedJavaVMs()`和`JNI_CreateJavaVM()`这三个函数并不是`JavaVM`函数表的一部分，调用着三个函数时，并不需要有`JavaVM`数据结构。

<a name="5.3.1"></a>
### 5.3.1 JNI_GetDefaultJavaVMInitArgs

    ```c++
    jint JNI_GetDefaultJavaVMInitArgs(void *vm_args);
    ```

返回JVM的默认参数配置。在调用该函数前，本地代码必须先设置属性`vm_args->version`为本地代码期望JVM能支持的JNI版本号。调用该函数后，属性`vm_args->version`会被设置为当前JVM所能支持的实际JNI版本号。

参数：

    vm_args     指向数据结构"JavaVMInitArgs"的指针，函数返回后，会在其中填入默认参数

返回：

    如果当前JVM能支持期望的JNI版本号，则返回"JNI_OK"；否则返回相应的错误码，值为负数。

<a name="5.3.2"></a>
### 5.3.2 JNI_GetCreatedJavaVMs

    ```c++
    jint JNI_GetCreatedJavaVMs(JavaVM **vmBuf, jsize bufLen, jsize *nVMs);
    ```

返回所有已创建的JVM实例。指向JVM实例的指针会被放入到参数`vmBuf`中，并按照JVM实例的创建顺序排放，返回的JVM实例的个数由参数`bufLen`指定，所有已创建的JVM实例的个数由参数`nVMs`返回。

需要注意的是，不支持在单一线程中创建多个JVM实例。

参数：

    vmBuf       存放JVM实例的数组指针
    bufLen      要返回的JVM实例的个数
    nVMs        所有已创建的JVM实例的个数

返回：

    若函数调用成功，返回"JNI_OK"；否则返回相应的错误码，值为负数。

<a name="5.3.3"></a>
### 5.3.3 JNI_CreateJavaVM

    ```c++
    jint JNI_CreateJavaVM(JavaVM **p_vm, void **p_env, void *vm_args);
    ```

载入并初始化一个JVM实例，当前线程变为主线程，并为当前线程设置JNI接口函数参数。

不支持在单一线程中创建多个JVM实例。

传给函数`JNI_CreateJavaVM`的第二个参数永远都是指向`JNIEnv*`的指针，而第三个参数是指向数据结构`JavaVMInitArgs`的指针，其中`options`属性指明启动JVM的选项。

    ```c++
    typedef struct JavaVMInitArgs {
        jint version;

        jint nOptions;
        JavaVMOption *options;
        jboolean ignoreUnrecognized;
    } JavaVMInitArgs;
    ```

其中`JavaVMOption`的定义如下：

    ```c++
    typedef struct JavaVMOption {
        char *optionString;  /* the option as a string in the default platform encoding */
        void *extraInfo;
    } JavaVMOption;
    ```

数组的大小由参数`nOptions`指定。若参数`ignoreUnrecognized`设置为`JNI_TRUE`，则函数`JNI_CreateJavaVM`会忽略所有以`-X`或`_`开头的、无法识别的JVM选项；若参数`ignoreUnrecognized`设置为`JNI_FALSE`，则遇到无法识别的JVM选项时，函数`JNI_CreateJavaVM`会返回`JNI_ERR`。所有的JVM实现都必须能识别以下标准参数：

    options                         desc
    -D<name>=<value>	            定义系统属性
    -verbose[:class|gc|jni]	        设置详细输出。可以以英文逗号分隔多个选项，例如"-verbose:gc,class"。
    vfprintf	                    此时，属性"extraInfo"是指向vfprintf钩子的指针
    exit	                        此时，属性"extraInfo"是指向退出钩子的指针
    abort	                        此时，属性"extraInfo"是指向终止钩子的指针

此外，每个JVM实现都可以支持自己特有的非标准选项。非标准选项必须以`-X`或`_`开头，例如JDK/JRE支持`-Xms`和`-Xmx`来指定堆的初始大小和最大值。以`-X`开头的选项可以被`java`命令工具所使用。

下面的代码展示了如何创建一个JVM：

    ```c++
    JavaVMInitArgs vm_args;
    JavaVMOption options[4];

    options[0].optionString = "-Djava.compiler=NONE";           /* disable JIT */
    options[1].optionString = "-Djava.class.path=c:\myclasses"; /* user classes */
    options[2].optionString = "-Djava.library.path=c:\mylibs";  /* set native library path */
    options[3].optionString = "-verbose:jni";                   /* print JNI-related messages */

    vm_args.version = JNI_VERSION_1_2;
    vm_args.options = options;
    vm_args.nOptions = 4;
    vm_args.ignoreUnrecognized = TRUE;

    /* Note that in the JDK/JRE, there is no longer any need to call
    * JNI_GetDefaultJavaVMInitArgs.
    */
    res = JNI_CreateJavaVM(&vm, (void **)&env, &vm_args);
    if (res < 0) ...
    ```

参数：

    p_vm        指向返回JVM数据结构的指针，新创建的JVM会放到这里
    p_env       指向主线程所使用的JNI接口指针的指针
    vm_args     JVM的初始化参数

返回：

    若函数调用成功，返回"JNI_OK"；否则返回相应的错误码，值为负数。

<a name="5.3.4"></a>
### 5.3.4 DestroyJavaVM 

    ```c++
    jint DestroyJavaVM(JavaVM *vm);
    ```

销毁JVM实例，释放其持有的资源。

任何线程都可以调用该方法。如果当前线程是连接到JVM的线程，则JVM会等到除当前线程外所有非守护的用户线程退出后，才会真正退出。如果当前线程不是连接到JVM的线程，则JVM会连接到当前线程，并等到除当前线程外所有非守护的用户线程退出后，才会真正退出。

该函数在JVM接口函数表中的索引位置为`3`。

参数：

    vm          待销毁的JVM实例

返回：

    若函数调用成功，返回"JNI_OK"；否则返回相应的错误码，值为负数。

销毁中的JVM不可再使用，结果未定义。

<a name="5.3.5"></a>
### 5.3.5 AttachCurrentThread

    ```c++
    jint AttachCurrentThread(JavaVM *vm, void **p_env, void *thr_args);
    ```

将当前线程连接到JVM，在参数`p_env`中返回JNI接口指针。

已经连接到JVM的线程重复调用该方法时，是空操作。

本地线程不能同时连接到两个不同的JVM实例。

当本地线程连接到JVM后，其上下文类载入去被设置为启动类载入器(bootstrap loader)。

该函数在JVM接口函数表中的索引位置为`4`。

参数：

    vm          待连接的JVM实例
    p_env       操作成功后，JNI接口指针通过该参数返回
    thr_args    可以为NULL；或是指向数据结构"JavaVMAttachArgs"的指针，用来指定额外信息on:

第二个参数永远是指向`JNIEnv`的指针。

第三个参数是保留参数，可以设置为`NULL`；也可以设置为以下数据结构的指针，以此来传递额外信息：

    ```c++
    typedef struct JavaVMAttachArgs {
        jint version;
        char *name;    /* the name of the thread as a modified UTF-8 string, or NULL */
        jobject group; /* global ref of a ThreadGroup object, or NULL */
    } JavaVMAttachArgs
    ```

返回：

    若函数调用成功，返回"JNI_OK"；否则返回相应的错误码，值为负数。

<a name="5.3.6"></a>
### 5.3.6 AttachCurrentThreadAsDaemon

    ```c++
    jint AttachCurrentThreadAsDaemon(JavaVM* vm, void** penv, void* args);
    ```

该方法的语义与函数`AttachCurrentThread`类似，但新创建的`java.lang.Thread`实例会被设置为守护线程。

如果当前线程已经通过函数`AttachCurrentThread`或`AttachCurrentThreadAsDaemon`连接到JVM，则调用当前方法只会将参数`penv`设置为当前线程的`JNIEnv*`的值，不会变更当前线程的守护线程状态。

该函数在JVM接口函数表中的索引位置为`7`。

参数：

    vm          待连接的JVM实例
    penv        操作成功后，JNI接口指针通过该参数返回
    args        指向数据结构"JavaVMAttachArgs"的指针

返回：

    若函数调用成功，返回"JNI_OK"；否则返回相应的错误码，值为负数。

异常：

    无

<a name="5.3.7"></a>
### 5.3.7 DetachCurrentThread

    ```c++
    jint DetachCurrentThread(JavaVM *vm);
    ```

断开当前线程与目标JVM的连接，同时释放当前线程所持有的监视器，所有等待该监视器的线程都会收到通知。

可以在主线程调用该函数。

该函数在JVM接口函数表中的索引位置为`7`。

参数：

    vm          待断开的JVM实例

返回：

    若函数调用成功，返回"JNI_OK"；否则返回相应的错误码，值为负数。

<a name="5.3.8"></a>
### 5.3.8 GetEnv

    ```c++
    jint GetEnv(JavaVM *vm, void **env, jint version);
    ```

该函数在JVM接口函数表中的索引位置为`6`。

参数：

    vm          目标JVM实例
    env         做返回结果使用
    version     期望支持的JNI版本号

返回：

    * 如果当前线程尚未连接到JVM，则参数"*env"被置为"NULL"，函数返回"JNI_EDETACHED"
    * 如果当前JVM不支持期望的JNI版本号，则参数"*env"被置为"NULL"，函数返回"JNI_EVERSION"
    * 其他情况下，参数"*env"指向JNI接口指针，函数返回"JNI_OK"






# Resources

* [Java Native Interface Specification Contents][1]



[1]:     http://docs.oracle.com/javase/8/docs/technotes/guides/jni/spec/jniTOC.html
[2]:     #1
[3]:     #2
[4]:     #2.1
[5]:     #2.2
[6]:     #2.2.1
[7]:     #2.2.2
[8]:     #2.3
[9]:     #2.3.1
[10]:    #2.3.2
[11]:    #2.4
[12]:    #2.4.1
[13]:    #2.4.2
[14]:    #2.4.3
[15]:    #2.5
[16]:    #2.5.1
[17]:    #2.5.2
[18]:    #2.5.3
[19]:    #3
[20]:    #3.1
[21]:    #3.2
[22]:    #3.3
[23]:    #3.4
[24]:    #3.5
[25]:    #3.6
[26]:    #4
[27]:    #4.1
[28]:    #4.2
[29]:    #4.2.1
[30]:    #4.2.2
[31]:    #4.3
[32]:    #4.3.1
[33]:    #4.3.2
[34]:    #4.3.3
[35]:    #4.3.4
[36]:    #4.4
[37]:    #4.4.1
[38]:    #4.4.2
[39]:    #4.4.3
[40]:    #4.4.4
[41]:    #4.4.5
[42]:    #4.4.6
[43]:    #4.4.7
[44]:    #4.5
[45]:    #4.5.1
[46]:    #4.5.1.1
[47]:    #4.5.1.2
[48]:    #4.5.2
[49]:    #4.5.2.1
[50]:    #4.5.2.2
[51]:    #4.5.2.3
[52]:    #4.5.2.4
[53]:    #4.5.2.5
[54]:    #4.5.3
[55]:    #4.5.3.1
[56]:    #4.5.3.2
[57]:    #4.5.4
[58]:    #4.5.4.1
[59]:    #4.5.4.2
[60]:    #4.5.4.3
[61]:    #4.5.4.4
[62]:    #4.5.4.5
[63]:    #4.5.4.6
[64]:    #4.5.5
[65]:    #4.5.5.1
[66]:    #4.5.5.2
[67]:    #4.5.5.3
[68]:    #4.5.6
[69]:    #4.5.6.1
[70]:    #4.5.6.2
[71]:    #4.5.6.3
[72]:    #4.5.7
[73]:    #4.5.7.1
[74]:    #4.5.7.2
[75]:    #4.5.7.3
[76]:    #4.5.8
[77]:    #4.5.8.1
[78]:    #4.5.8.2
[79]:    #4.5.9
[80]:    #4.5.9.1
[81]:    #4.5.9.2
[82]:    #4.5.9.3
[83]:    #4.5.9.4
[84]:    #4.5.9.5
[85]:    #4.5.9.6
[86]:    #4.5.9.7
[87]:    #4.5.9.8
[88]:    #4.5.9.9
[89]:    #4.5.9.10
[90]:    #4.5.10
[91]:    #4.5.10.1
[92]:    #4.5.10.2
[93]:    #4.5.10.3
[94]:    #4.5.10.4
[95]:    #4.5.10.5
[96]:    #4.5.10.6
[97]:    #4.5.10.7
[98]:    #4.5.10.8
[99]:    #4.5.10.9
[100]:   #4.5.10.10
[101]:   #4.5.11
[102]:   #4.5.11.1
[103]:   #4.5.11.2
[104]:   #4.5.12
[105]:   #4.5.12.1
[106]:   #4.5.12.2
[107]:   #4.5.13
[108]:   http://docs.oracle.com/javase/8/docs/technotes/guides/io/index.html
[109]:   http://docs.oracle.com/javase/8/docs/api/java/nio/ByteBuffer.html
[110]:   #4.5.13.1
[111]:   #4.5.13.2
[112]:   #4.5.13.3
[113]:   #4.5.14
[114]:   #4.5.14.1
[115]:   #4.5.14.2
[116]:   #4.5.14.3
[117]:   #4.5.14.4
[118]:   #4.5.15
[119]:   #4.5.15.1
[120]:   #5
[121]:   #5.1
[122]:   #5.1.1
[123]:   #5.1.2
[124]:   #5.1.3
[125]:   #5.1.4
[126]:   #5.2
[127]:   #5.2.1
[128]:   #5.2.2
[129]:   #5.3
[130]:   #5.3.1
[131]:   #5.3.2
[132]:   #5.3.3
[133]:   #5.3.4
[134]:   #5.3.5
[135]:   #5.3.6
[136]:   #5.3.7
[137]:   #5.3.8
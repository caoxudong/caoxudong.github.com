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
            * [4.5.5.2 "Get<type>Field"系列函数][65]
            * [4.5.5.3 "Set<type>Field"系列函数][66]
        * [4.5.6 调用实例方法][67]
            * [4.5.6.1 GetMethodID][68]
            


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

* NewObject

使用函数`NewObject`时，开发者将传递给构造函数的参数直接放到参数`methodID`后面即可，`NewObject`函数会将这些参数传递给目标类型的构造函数。

该函数在`JNIEnv`接口函数表的索引位置为`28`。

* NewObjectA

使用函数`NewObjectA`时，开发者需要将传递给构造函数的参数包装为一个`jvalues`类型的数组，放置在参数`methodID`后面，`newObjectA`从数组中获取参数，再传给目标类型的构造函数。

该函数在`JNIEnv`接口函数表的索引位置为`30`。

* NewObjectV

使用函数`NewObjectV`时，开发者需要将传递给构造函数的参数包装台类型为`va_list`的参数，放置在参数`methodID`后面，`newObjectV`从数组中获取参数，再传给目标类型的构造函数。

该函数在`JNIEnv`接口函数表的索引位置为`29`。

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
#### 4.5.5.2 "Get<type>Field"系列函数

    ```c++
    NativeType Get<type>Field(JNIEnv *env, jobject obj, jfieldID fieldID);
    ```

该系列函数用于获取目标实例的目标属性的值，其中目标属性`fieldID`是通过`GetFieldID()`函数所得。

下面的内容描述了不同类型的函数和返回类型的对应关系。

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
#### 4.5.5.3 "Set<type>Field"系列函数

    ```c++
    void Set<type>Field(JNIEnv *env, jobject obj, jfieldID fieldID, NativeType value);
    ```

该系列函数用于对目标对象的目标属性进行赋值，其中目标属性`fieldID`是通过`GetFieldID()`函数所得。

下面的内容描述了不同类型的函数和属性类型的对应关系。

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

该系列函数在`JNIEnv`接口函数表的索引位置是`33`。

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









# Resources

* [Java Native Interface Specification Contents][1]



[1]:    http://docs.oracle.com/javase/8/docs/technotes/guides/jni/spec/jniTOC.html
[2]:    #1
[3]:    #2
[4]:    #2.1
[5]:    #2.2
[6]:    #2.2.1
[7]:    #2.2.2
[8]:    #2.3
[9]:    #2.3.1
[10]:   #2.3.2
[11]:   #2.4
[12]:   #2.4.1
[13]:   #2.4.2
[14]:   #2.4.3
[15]:   #2.5
[16]:   #2.5.1
[17]:   #2.5.2
[18]:   #2.5.3
[19]:   #3
[20]:   #3.1
[21]:   #3.2
[22]:   #3.3
[23]:   #3.4
[24]:   #3.5
[25]:   #3.6
[26]:   #4
[27]:   #4.1
[28]:   #4.2
[29]:   #4.2.1
[30]:   #4.2.2
[31]:   #4.3
[32]:   #4.3.1
[33]:   #4.3.2
[34]:   #4.3.3
[35]:   #4.3.4
[36]:   #4.4
[37]:   #4.4.1
[38]:   #4.4.2
[39]:   #4.4.3
[40]:   #4.4.4
[41]:   #4.4.5
[42]:   #4.4.6
[43]:   #4.4.7
[44]:   #4.5
[45]:   #4.5.1
[46]:   #4.5.1.1
[47]:   #4.5.1.2
[48]:   #4.5.2
[49]:   #4.5.2.1
[50]:   #4.5.2.2
[51]:   #4.5.2.3
[52]:   #4.5.2.4
[53]:   #4.5.2.5
[54]:   #4.5.3
[55]:   #4.5.3.1
[56]:   #4.5.3.2
[57]:   #4.5.4
[58]:   #4.5.4.1
[59]:   #4.5.4.2
[60]:   #4.5.4.3
[61]:   #4.5.4.4
[62]:   #4.5.4.5
[63]:   #4.5.4.6
[64]:   #4.5.5
[65]:   #4.5.5.1
[66]:   #4.5.5.2
[67]:   #4.5.5.3
[68]:   #4.5.6
[69]:   #4.5.6.1
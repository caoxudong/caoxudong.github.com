---
title:      JVMTI
layout:     post
category:   blog
tags:       [java, jvm, jvmti]
---

# 目录

* [1 introduction][1]
    * [1.1 啥是JVMTI][2]
    * [1.2 架构][3]
    * [1.3 开发JVMTI代理][5]
    * [1.4 部署JVMTI代理][6]
    * [1.5 静态链接的JVMTI代理][7]
    * [1.6 JVMTI代理的命令行选项][8]
    * [1.7 启动JVMTI代理][12]
    * [1.8 启动JVMTI代理(OnLoad阶段)][13]
    * [1.9 启动JVMTI代理(Live阶段)][10]
    * [1.10 关闭JVMTI代理][14]
    * [1.11 JAVA_TOOL_OPTIONS][15]
    * [1.12 执行环境][16]
    * [1.13 字节码增强][17]
    * [1.14 自定义UTF-8编码][18]
    * [1.15 上下文][19]
* [Resource][100]

<a name="1"></a>
# 1 introduction

<a name="1.1"></a>
## 1.1 啥是JVMTI

JVMTI是用来开发和监控JVM所使用的程序接口，可以探查JVM内部状态，并控制JVM应用程序的执行。可实现的功能包括但不限于：调试、监控、线程分析、覆盖率分析工具等。

需要注意的是，并非所有的JVM实现都支持JVMTI。

JVMTI是双通道接口(two-way interface)。JVMTI的客户端，或称为代理(agent)，可以监听感兴趣的事件。JVMTI提供了很多函数，以便来查询或控制应用程序。

JVMTI代理与目标JVM运行在同一个进程中，通过JVMTI进行通信，最大化控制能力，最小化通信成本。典型场景下，JVMTI代理会被实现的非常紧凑，其他的进程会与JVMTI代理进行通信，进而实现控制JVM应用程序的目标。

<a name="1.2"></a>
## 1.2 架构

在开发JVM应用程序工具的时候，可以直接通过JVMTI实现，也可以通过其他高级接口间接实现。**Java Platform Debugger Architecture**包含了JVMTI和其他高级的、进程外的调试器接口，很多时候，使用高级接口比JVMTI更合适。有关**Java Platform Debugger Architecture**的详细内容，参见[这里][4]。

<a name="1.3"></a>
## 1.3 开发JVMTI代理

开发JVMTI代理时，可以使用任何支持C语言调用约定和C/C++定义的本地语言。

使用JVMTI时所涉及到的函数、事件、数据类型和常量都定义在文件`jvmti.h`中。开发的时候加上下面的语句即可

    ```c
    #include <jvmti.h>
    ```

<a name="1.4"></a>
## 1.4 部署JVMTI代理

JVMTI代理的部署方式依具体的操作系统而定，典型场景下是将之编译为动态链接库。以Windows平台为例，JVMTI代理会被编译为一个`.dll`文件；在Solaris平台上，则将之编译为一个`.so`文件。

在JVM启动的时候通过命令行选项来指定JVMTI代理的名字，以此启动JVMTI代理。在某些JVM实现中，支持在[**live**][]阶段[启动JVMTI代理][10]。具体情况具体分析。

<a name="1.5"></a>
## 1.5 静态链接的JVMTI代理

>从JVMTI 1.2.3版本起可用。

JVMTI代理可以与JVM以静态链接的方式相关联。代理库与JVM的关联方式取决于JVM的具体实现。当且仅当代理库`L`导出了名为`Agent_OnLoad_L`的函数时，代理库`L`才能与JVM做静态链接。

如果代理库同时导出名为`Agent_OnLoad_L`和`Agent_OnLoad`的函数，则函数`Agent_OnLoad`会被忽略掉。若代理库`L`是静态链接的，则函数`Agent_OnLoad_L`会被调用，其传入的参数和期望的返回值与函数`Agent_OnLoad`相同。若代理库`L`被静态链接，则禁止再动态链接同名的动态库。

若静态链接库`L`导出了名为`Agent_OnUnLoad_L`的函数，则其调用时机与调用函数`Agent_OnUnLoad`相同。静态链接库不能被卸载，调用函数`Agent_OnUnLoad_L`来执行代理关闭任务。若静态库同时导出名为`Agent_OnUnLoad_L`和`Agent_OnUnLoad`的函数，则函数`Agent_OnUnLoad`会被忽略掉

对于代理`L`，函数`Agent_OnAttach_L`和`Agent_OnAttach`具有相同的参数和返回值。若代理`L`同时导出了函数`Agent_OnAttach_L`和`Agent_OnAttach`，则函数`Agent_OnAttach`会被忽略。

<a name="1.6"></a>
## 1.6 JVMTI代理的命令行选项

下文所述的"命令行选项"是指通过[Invocation API][11]调用`JVM_CreateJavaVM`函数时，在参数`JavaVMInitArgs`中传入的选项。

下面的两个命令行选项可用于在JVM启动时加载运行JVMTI代理。

    ```
    -agentlib:<agent-lib-name>=<options>
    ```

紧跟着`-agentlib`的是要加载的JVMTI代理的文件名，其搜索方式取决于当前的系统平台。典型场景下，`<agent-lib-name>`会被扩展为一个具体的文件名。`<options>`的内容会在启动代理的时候被传入。例如，如果命令行选项是`-agentlib:foo=opt1,opt2`，则在Windows平台上，会在环境变量`PATH`指定的路径中查找名为`foo.dll`的动态库；在Solaris平台上，会在环境变量`LD_LIBRARY_PATH`指定的路径中查找名为`libfoo.so`的动态库。如果代理时静态链接到可执行文件中的，则并不会执行载入操作。

    ```
    -agentpath:<path-to-agent>=<options>
    ```

紧跟着`-agentpath:`的是要加载的JVMTI代理的路径，无需添加库的名字。`<options>`的内容会在启动代理的时候被传入。例如，若命令行选项是`-agentpath:c:\myLibs\foo.dll=opt1,opt2`，则JVM会尝试载入动态库`c:\myLibs\foo.dll`。如果代理时静态链接到可执行文件中的，则并不会执行载入操作。

对于动态链接的代理，会在启动的时候，调用函数`Agent_OnLoad`。对于静态链接的代理，会在启动的时候，调用函数`Agent_OnLoad_<agent-lib-name>`，其中`<agent-lib-name>`是代理的文件名，以`-agentpath:c:\myLibs\foo.dll=opt1,opt2`为例，系统会查找名为`Agent_OnLoad_foo`的函数。

JVM在会载入的JVMTI代理搜索JNI本地方法的实现来完成预定功能，例如字节码增强。

JVM在搜索目标方法时，会先搜索其他库，最后才搜索JVMTI代理库，若是JVMTI代理库希望能覆盖或拦截非代理库方法的本地实现，可以通过`NativeMethodBind`事件来实现。

这类切换功能只能做到这里，并不能修改JVM或JVMTI的状态。不能通过命令行选项来启用JVMTI或JVMTI的某些方面，只能变成实现JVMTI的功能。

<a name="1.7"></a>
## 1.7 启动JVMTI代理

JVM会调用启动函数来启动JVMTI代理。如果在`OnLoad`阶段启动，则会调用静态库的`Agent_OnLoad`或`Agent_OnLoad_L`函数。如果是在`live`阶段，则会调用静态库的`Agent_OnAttach`或`Agent_OnAttach_L`函数。每个JVMTI代理的启动函数，只会调用一次。

<a name="1.8"></a>
## 1.8 启动JVMTI代理(OnLoad阶段)

若JVMTI代理时在`OnLoad`阶段启动的，则其代理库必须导出具有如下原型的启动函数：

    ```c++
    JNIEXPORT jint JNICALL Agent_OnLoad(JavaVM *vm, char *options, void *reserved)
    ```

对于静态链接的代理，则需要具有如下原型的启动函数：

    ```c++
    JNIEXPORT jint JNICALL Agent_OnLoad_L(JavaVM *vm, char *options, void *reserved)
    ```

JVM会调用这个函数来启动JVMTI代理，调用时机会发生在JVM的初始化阶段，而且特别早：

* 系统属性可能还没有设置好
* JVM的完整功能仍旧可用(JVM的完整功能可能只有这个时候才是完整可用的)
* 还没有执行任何字节码
* 还没有载入任何类
* 还没有创建任何对象

JVM在调用函数`Agent_OnLoad`或`Agent_OnLoad_<agent-lib-name>`时，会将`<options>`作为第二个参数传入，例如，`opt1,opt2`会被传入到函数`Agent_OnLoad`的`*options`参数中。参数`options`是使用[自定义UTF-8编码][20]的。若命令行选项中没有指定`=<options>`部分，则参数`options`是一个长度为0的空字符串。参数`options`的作用域只在函数`Agent_OnLoad`或`Agent_OnLoad_<agent-lib-name>`内，若要超出这个范围，则需要开发者自行拷贝相关内容。`OnLoad`阶段是指调用函数`Agent_OnLoad`过程。由于在`OnLoad`阶段内，JVM还没有完成初始化，因此在函数`Agent_OnLoad`中可执行的操作是有限的。JVMTI代理可以安全的处理命令行选项并通过函数`SetEventCallbacks`设置事件回调。一旦接收到JVM初始化完成的事件(即触发了`VMInit`回调)，则JVMTI代理可以完成其初始化。

基本原理：之所以要在JVM初始化完成之前启动JVMTI代理，是因为JVMTI代理在初始化过程中会设置期望的功能，而很多功能必须在JVM初始化之前进行设置。相比较来说，在JVMDI中，命令行选项`-Xdebug`提供了对功能的粗粒度控制，JVMPI通过各种黑科技提供了一个标识"JVMPI on"的开发，而并没有哪个命令行选项能够在平衡性能损耗和功能选择的前提下，提供更好细粒度控制。提前JVMTI代理的初始化，也便于控制其执行环境，可以修改文件系统和系统属性来支持其所需的功能。

函数`Agent_OnLoad`和`Agent_OnLoad_<agent-lib-name>`的返回值用来指示相应的错误，非0值表示发生了错误，会终止JVM的运行。

<a name="1.9"></a>
## 1.9 启动JVMTI代理(Live阶段)

对于某些JVM实现来说，允许JVMTI在**live**阶段启动，具体机制取决于JVM的具体实现。例如，可能会涉及到某个系统平台的专属特性或某个专属的API，以此连接到正在运行的目标JVM，要求其启动目标JVMTI代理。

若某个JVMTI代理需要在**live**阶段启动，则需要导出具有如下原型的函数：

    ```c++
    JNIEXPORT jint JNICALL Agent_OnAttach(JavaVM* vm, char *options, void *reserved)
    ```

若是静态链接的，则需要导出具有如下原型的函数：

    ```c++
    JNIEXPORT jint JNICALL Agent_OnAttach_L(JavaVM* vm, char *options, void *reserved)
    ```

JVM在启动JVMTI代理时，会在连接到JVM的线程中调用该函数。参数`vm`当前JVM实例，参数`options`是提供给JVMTI代理的命令行选项，使用自定义UTF-8编码，若没有提供命令行选项，则传入一个长度为0的空字符串。参数`options`的作用域只在函数`Agent_OnAttach`或`Agent_OnAttach_L`内，若要超出这个范围，则需要开发者自行拷贝相关内容。

注意，在**live**阶段，某些功能是不可用的。

函数`Agent_OnAttach`或`Agent_OnAttach_<agent-lib-name>`会初始化JVMTI代理，发生错误时，会返回非0值。发生错误时，并不会终止JVM的运行。发生错误时，JVM会忽略相关错误，或者执行某些特殊操作，这取决于JVM的具体实现，例如可能会打印错误信息到标准错误，或者将之记录到系统日志中。

<a name="1.10"></a>
## 1.10 关闭JVMTI代理

JVMTI代理可以导出具有如下原型的关闭函数：


    ```c++
    JNIEXPORT void JNICALL Agent_OnUnload(JavaVM *vm)
    ```

若是静态链接，则导出如下函数：

    ```c++
    JNIEXPORT void JNICALL Agent_OnUnload_L(JavaVM *vm)
    ```

当JVMTI代理被卸载的时候，JVM会调用该函数。若某些平台的特殊机制触发了卸载机制，或由于JVM终止(无论是正常结束还是异常结束，包括启动失败)而导致JVMTI代理(事实上)将被卸载，则JVMTI代理会被卸载掉(除非JVMTI代理是静态链接的)，并调用该函数。当然，非受控关闭是特殊情况。需要注意的是，该函数和JVM死亡事件的区别：发送JVM死亡事件时，JVM肯定已经完成初始化了，存在有效的JVMTI执行环境，并且可以接收`VMDeath`事件；而这些对于函数`Agent_OnUnload`和`Agent_OnUnload_<agent-lib-name>`都不是必要的，而且，该函数在其他一些场景下也会被调用。系统会先发送`VMDeath`事件，然后再调用该函数。该函数可用于执行一些清理工作。

<a name="1.11"></a>
## 1.11 JAVA_TOOL_OPTIONS

由于命令行并不总是能被访问或修改，因此JVM系统提供了变量`JAVA_TOOL_OPTIONS`，方面为JVMTI代理传输参数。

某些支持环境变量或其他命名字符串的平台，可能会支持变量`JAVA_TOOL_OPTIONS`，变量的内容可以包含空白符，包括空格，制表符，回车，换行，水平制表符和换页符，但必须是被引用起来才行，多个空白符会被认为是一个。引用方法如下：

* 所有的字符都一对被单引号引用起来，这时变量的内容本身不能包含单引号，此时双引号无特殊意义
* 所有的字符都一对被双引号引用起来，这时变量的内容本身不能包含双引号，此时单引号无特殊意义
* 被引用的内容可以位于变量内容的任意部分
* 被引用时，空白符无特殊意义，不再表示边界含义
* 引用边界符(单引号或双引号)不是变量内容

Invocation API的函数`JNI_CreateJavaVM`会将变量内容添加到参数`JavaVMInitArgs`前面。当前平台处于安全考虑，可能会禁用这个特性，例如在Unix系统上，当实际用户ID或组ID与真实ID不同时，JVM的参考实现可能会禁用这个特性。该特性本意是用来支持工具的初始化，尤其是本地代理或Java代理的初始化。其他的工具可能也会使用到这个特性，因此变量不应该被覆盖掉，相反，应该通过命令行选项来将内容附加给变量。注意，变量是在Invocation API创建JVM时处理的，此时不会处理命令行选项。

<a name="1.12"></a>
## 1.11 执行环境

JVMTI规范支持同时处理多个JVMTI代理。每个代理，尤其专属的JVMTI执行环境，即他们之间的状态不会互相影响。JVMTI执行环境的状态包括：

* 事件回调
* 已启用的事件集合
* 功能
* 内存分配/释放的钩子

尽管JVMTI之间的状态是分离的，但他们探查和修改的JVM状态是共享的，同时执行JVMTI代理的本地执行环境也是共享的。因此，某个JVMTI的误操作可能会导致其他JVMTI操作失败，而JVMTI的实现并不能防止这种负面影响的发生，如何从技术上尽可能减小这种事情的发生已经超出了本文的讨论范畴，此处不再赘述。

调用JVMTI相关函数创建代理时，将JVMTI的版本作为作为参数传入，系统会创建一个JVMTI执行环境。更多有关创建和使用JVMTI执行环境的详细内容参见JVMTI函数。典型场景下，JVMTI执行环境是在函数`Agent_OnLoad`中调用函数`GetEnv`所得。

<a name="1.13"></a>
## 1.12 字节码增强

这个接口并不包含对性能分析的支持，例如在一些例子中，会包含对象分配事件、方法进入和退出事件。相反，该接口提供了对字节码增强的支持，即修改JVM字节码指令的能力。典型场景下，这种修改会在方法中增加一些事件，例如在方法的开始处，添加对函数`MyProfiler.methodEntered()`的调用。由于这些修改只是增加一些功能，因此并不会修改应用程序的状态和行为。新加入的代码是标准字节码，JVM可以全速运行，还可以对新加入的代码做运行时优化。如果新增加的代码并不涉及到切换字节码执行，则无需执行成本较高的状态转换，从而达到很高的性能。此外，该方法还提供了完整的代理控制，使字节码增强可以被限制到只对特殊的目标代码进行操作，例如用户代码的末尾。字节码增强可以运行完整的Java代码或调用本地代理，也可以只是做事件计数器。

可以通过以下3中方式添加字节码增强：

* 静态增强： 在JVM载入class文件之前，先行完成字节码增强，例如创建一个专属目录，将增强过的class文件都放到这个目录下。这个方法太傻，而且代理通常也无法知道在要载入的原始文件是哪个。
* 载入时增强：当JVM载入某个class文件时，class文件的原始字节码会被发给JVMTI代理，完成增强工作。在载入class文件时，会触发事件`ClassFileLoadHook`，这个机制保证了一定的效率，而且确保了只会增强一次。
* 动态增强： 已经被载入的class文件(可能已经运行了)也是可以被修改的。当系统调用函数`RetransformClasses`时，会触发事件`ClassFileLoadHook`，从而进行动态增强。类可能会被修改多次，也可以返回其原始状态，在这个过程总，可以执行动态增强。

类修改功能是得字节码增强(事件`ClassFileLoadHook`和函数`RetransformClasses`)和热替换(函数`RedefineClasses`)得以实现。

对依赖关系的处理需要特别注意，尤其是在增强核心类的时候。例如，想要获取对象分配的事件通知，可以对类`Object`的构造函数进行增强。假设构造函数原本是个空函数，则可以将之修改为：

    ```java
    public Object() {
        MyProfiler.allocationTracker(this);
    }
    ```

单数，如果是通过事件`ClassFileLoadHook`来执行修改，则可能会影响到JVM的正常执行：

1. 第一个创建的对象会调用构造函数，进而载入类`MyProfiler`
1. 由于类`MyProfiler`还没有载入，因此会分配内存
1. 造成无限循环，爆栈

修改方案是延迟对追踪方法的调用，例如，添加属性`trackAllocations`，然后在`VMInit`事件处理中将这个值赋值为`true`：

    ```java
    static boolean trackAllocations = false;

    public Object() {
        if (trackAllocations) {
            MyProfiler.allocationTracker(this);
        }
    }
    ```

函数`SetNativeMethodPrefix`使本地方法可以被包装方法增强。    

<a name="1.14"></a>
## 1.13 自定义UTF-8编码

JVMTI使用自定义UTF-8编码，与JNI相同。自定义UTF-8编码与标准UTF-8编码的区别在于如何展示补充字符和空字符(null character)。具体内容参见[JNI规范中对自定义UTF-8编码的说明][20]。

<a name="1.15"></a>
## 1.14 上下文

本文介绍了访问JVM中应用程序状态的接口，除非特别说明，相关技术名词是与Java平台而非本地平台相关的，例如：

* 线程： 指Java编程语言中的线程
* 栈帧： JVM中的栈帧
* 类： Java编程语言中的类
* 堆： JVM中的堆
* 监视器： Java编程语言中的对象监视器

Sun，Sun Microsystems，Sun的logo，Java，JVM已经有Oracle及其子公司在美国和其他工作注册商标。


<a name="resources"></a>
# Resources

* [JVM Tool Interface][100]






[1]:      #1
[2]:      #1.1
[3]:      #1.2
[4]:      http://docs.oracle.com/javase/7/docs/technotes/guides/jpda/architecture.html
[5]:      #1.3
[6]:      #1.4
[7]:      #1.5
[8]:      #1.6
[10]:     #1.9
[11]:     http://blog.caoxudong.info/blog/2017/10/11/jni_functions_note#5.3.3
[12]:     #1.7
[13]:     #1.8
[14]:     #1.10
[15]:     #1.11
[16]:     #1.12
[17]:     #1.13
[18]:     #1.14
[19]:     #1.15
[20]:     http://blog.caoxudong.info/blog/2017/10/11/jni_functions_note#3.6

[100]:    https://docs.oracle.com/javase/8/docs/platform/jvmti/jvmti.html

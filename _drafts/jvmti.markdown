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
* [2 函数][21]
    * [2.1 访问函数][22]
    * [2.2 函数返回值][23]
    * [2.3 管理JNI对象引用][24]
    * [2.4 预先获取状态][25]
    * [2.5 异常与函数][26]
    * [2.6 函数表][27]
        * [2.6.1 内存管理][28]
            * [2.6.1.1 Allocate][66]
            * [2.6.1.2 Deallocate][67]
        * [2.6.2 线程][29]
            * [2.6.2.1 GetThreadState][68]
            * [2.6.2.2 GetCurrentThread][69]
            * [2.6.2.3 GetAllThreads][70]
            * [2.6.2.4 SuspendThread][71]
            * [2.6.2.5 SuspendThreadList][72]
            * [2.6.2.6 ResumeThread][73]
            * [2.6.2.7 ResumeThreadList][74]
            * [2.6.2.8 StopThread][75]
            * [2.6.2.9 InterruptThread][76]
            * [2.6.2.10 GetThreadInfo][77]
            * [2.6.2.11 GetOwnedMonitorInfo][78]
            * [2.6.2.12 GetOwnedMonitorStackDepthInfo][79]
            * [2.6.2.13 GetCurrentContendedMonitor][80]
            * [2.6.2.14 RunAgentThread][81]
            * [2.6.2.15 SetThreadLocalStorage][82]
            * [2.6.2.16 GetThreadLocalStorage][83]
        * [2.6.3 线程组][30]
            * [2.6.3.1 GetTopThreadGroups][84]
            * [2.6.3.2 GetThreadGroupInfo][85]
            * [2.6.3.3 GetThreadGroupChildren][86]
        * [2.6.4 栈帧][31]
            * [2.6.4.1 GetStackTrace][87]
            * [2.6.4.2 GetAllStackTraces][88]
            * [2.6.4.3 GetThreadListStackTraces][89]
            * [2.6.4.4 GetFrameCount][90]
            * [2.6.4.5 PopFrame][91]
            * [2.6.4.6 GetFrameLocation][92]
            * [2.6.4.7 NotifyFramePop][93]
        * [2.6.5 强制提前返回][32]
            * [2.6.5.1 ForceEarlyReturnObject][94]
            * [2.6.5.2 ForceEarlyReturnInt][95]
            * [2.6.5.3 ForceEarlyReturnLong][96]
            * [2.6.5.4 ForceEarlyReturnFloat][97]
            * [2.6.5.5 ForceEarlyReturnDouble][98]
            * [2.6.5.6 ForceEarlyReturnVoid][99]
        * [2.6.6 堆][33]
            * [2.6.6.1 FollowReferences][103]
            * [2.6.6.2 IterateThroughHeap][104]
            * [2.6.6.3 GetTag][105]
            * [2.6.6.4 SetTag][106]
            * [2.6.6.5 GetObjectsWithTags][107]
            * [2.6.6.6 ForceGarbageCollection][108]
        * [2.6.7 堆1.0][34]
        * [2.6.8 局部变量][35]
        * [2.6.9 断点][36]
        * [2.6.10 探查属性值][37]
        * [2.6.11 类][38]
        * [2.6.12 对象][39]
        * [2.6.13 属性][40]
        * [2.6.14 方法][41]
        * [2.6.15 原始监视器][42]
        * [2.6.16 JNI方法拦截][43]
        * [2.6.17 事件管理][44]
        * [2.6.18 扩展机制][45]
        * [2.6.19 功能][46]
        * [2.6.20 计时器][47]
        * [2.6.21 搜索类加载器][48]
        * [2.6.22 系统属性][49]
        * [2.6.23 通用][50]
    * [2.7 错误码][51]
* [3 事件][52]
    * [3.1 事件索引][53]
* [4 数据类型][54]
    * [4.1 JVMTI中所使用的JNI数据类型][55]
    * [4.2 JVMTI中的基本类型][56]
    * [4.3 数据结构类型定义][57]
    * [4.4 函数类型定义][58]
    * [4.5 枚举定义][59]
    * [4.6 函数表][60]
* [5 常量索引][61]
* [6 变更历史][62]
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

<a name="2"></a>
# 2 函数

<a name="2.1"></a>
## 2.1 访问函数

本地代码可以通过JVMTI提供的特性来访问JVMTI函数，[与JNI类似][63]，可以通过一个接口指针来访问JVMTI的函数。JVMTI的接口指针称为`环境指针(environment pointer)`。

环境指针是指向执行环境的指针，其类型为`jvmtiEnv*`。执行环境包含了与当前JVMTI连接相关的额信息，其第一个值是指向函数表的指针，函数表是一个包含了JVMTI函数指针的数组，每个函数指针在函数表中按预定义的索引值排列。

若使用C语言开发，则使用双向链表访问JVMTI函数，环境指针作为调用JVMTI函数的第一个参数传入，例如：

    ```c
    jvmtiEnv *jvmti;
    ...
    jvmtiError err = (*jvmti)->GetLoadedClasses(jvmti, &class_count, &classes);
    ```
    
若使用C++开发，则只需要访问`jvmtiEnv`的成员函数即可，例如：

    ```c++
    jvmtiEnv *jvmti;
    ...
    jvmtiError err = jvmti->GetLoadedClasses(&class_count, &classes);
    ```
    
除非特别说明，本文中的示例均使用C语言开发。

可以通过函数`GetEnv`获取JVMTI执行环境：

    ```c
    jvmtiEnv *jvmti;
    ...
    (*jvm)->GetEnv(jvm, &jvmti, JVMTI_VERSION_1_0);
    ```

每次调用函数`GetEnv`都会创建一个新的JVMTI连接，即新的JVMTI执行环境。函数`GetEnv`的第三个参数，必须是有效的JVMTI版本。函数的返回值是JVMTI的执行环境，它的版本可能与参数传入的版本不同，但肯定是兼容目标版本的。若当前JVM中没有与兼容的版本，或当前系统之不支持JVMTI，则函数`GetEnv`返回`JNI_EVERSION`。在特定的上下文中，可能会添加其他的接口来创建JVMTI执行环境。创建的JVMTI环境，可以通过函数`DisposeEnvironment`来释放，这点与JNI不同，JNITI的执行环境可以动态创建，并且跨线程使用。

<a name="2.2"></a>
## 2.2 函数返回值

JVMTI函数总是会返回结构体`jvmtiError`，其中会包含相应的错误码。某些函数可能会通过调用函数提供的出参返回一些额外的信息。在某些场景下，JVMTI函数会分配内存，需要调用者显式释放，在这些JVMTI的函数说明中会加以强调。返回值为空列表，空数组，空序列等时，会返回`NULL`。

若执行JVMTI函数发生了错误，即返回了非`JVMTI_ERROR_NONE`的值，则参数指针所指向的内存值是未定义的，不会分配内存，也不会创建全局引用。如果是由于无效入参引起的错误，则不会执行任何操作。

<a name="2.3"></a>
## 2.3 管理JNI对象引用

JVMTI通过JNI引用(`jobject`和`jclass`)及其衍生类(`jthread`和`jthreadGroup`)来定位对象。传给JVMTI函数的引用，可以使全局引用或局部引用，但必须是强引用。所有JVMTI函数返回的都是局部引用，这些局部引用是在调用JVMTI函数过程中创建的。作为一种资源，局部引用必须被正确管理，参见[JNI文档][64]。当线程从本地代码返回后，所有的局部引用都会被释放。注意，某些线程，包括JVMTI代理线程，永远不会从本地代码中返回。JVM的实现机制保证了，线程可以创建16个局部引用，而且无需显式管理他们的生命周期。对于某些线程来说，在从本地代码返回前，需要执行有限数量的JVMTI函数调用，例如处理指定事件的线程，可能无需显式管理局部引用；但对于需要长时间运行的线程来说，必须通过JNI函数来显式管理局部引用的生命周期，例如调用JNI函数`PushLocalFrame`和`PopLocalFrame`。为了在从本地代码返回后，还能保留某些局部引用，则需要将它们转换为全局引用。需要注意的是，这些规则不适用于`jmethodID`和`jfieldID`，因为他们不是`jobject`对象。

<a name="2.4"></a>
## 2.4 预先获取状态

除非JVMTI函数特别说明"JVMTI代理必须将线程或JVM置为特殊状态，例如挂起"，否则JVMTI实现在执行函数调用的时候，会负责将JVM状态置为安全、一致的状态。

<a name="2.5"></a>
## 2.5 异常与函数

JVMTI函数永远不会抛出异常，通过返回值表示执行状态。在调用JVMTI函数时，已存在的异常会被保留。参见[JNI中对异常的处理][65]。

<a name="2.6"></a>
## 2.6 函数表

<a name="2.6.1"></a>
### 2.6.1 内存管理

内存管理的函数包括：

* [2.6.1.1 Allocate][66]
* [2.6.1.2 Deallocate][67]

这两个函数JVMTI代理可以通过JVMTI分配/释放内存，需要注意的是，JVMTI的管理机制与其他内存管理库的机制不兼容。

<a name="2.6.1.1"></a>
#### 2.6.1.1 Allocate

    ```c
    jvmtiError Allocate(jvmtiEnv* env, jlong size, unsigned char** mem_ptr)
    ```

函数`Allocate`通过JVMTI的内存分配器分配一块内存区域，通过该函数分配的内存，需要通过函数`Deallocate`释放掉。

* 调用阶段： 可能在任何阶段调用
* 回调点： 该函数可能会在堆处理函数的回调函数中被调用，或者在事件`GarbageCollectionStart` `GarbageCollectionFinish`和`ObjectFree`的事件处理函数中被调用
* 索引位置： 46
* Since： 1.0
* 功能： 必要
* 参数：
    * size: 类型为`jlong`，表示要分配的字节数，使用类型`jlong`是为了与JVMDI相兼容
    * mem_ptr: 
        * 类型为`unsigned char**`，出参。若参数`size`为0，则`mem_ptr`的值为`NULL`
        * 调用者传入指向`unsigned char*`的指针，若分配成功，则会将新分配的地址放到该指针指向的位置
        * 新分配的内存区域，需要通过函数`Deallocate`释放掉
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_OUT_OF_MEMORY`: 内存不足
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`size`小于0
    * `JVMTI_ERROR_NULL_POINTER	`: 参数`mem_ptr`为`NULL`

<a name="2.6.1.2"></a>
#### 2.6.1.2 Deallocate

    ```c
    jvmtiError Deallocate(jvmtiEnv* env, unsigned char* mem)
    ```

该函数通过`JVMTI`的内存分配器释放由参数`mem`指向的内存区域，特别的，应该专用于由JVMTI函数分配的内存区域。分配的内存都应该被释放掉，避免内存泄漏。

* 调用阶段： 可能在任何阶段调用
* 回调安全： 该函数可能会在堆处理函数的回调函数中被调用，或者在事件`GarbageCollectionStart` `GarbageCollectionFinish`和`ObjectFree`的事件处理函数中被调用
* 索引位置： 47
* Since： 1.0
* 功能： 必选
* 参数：
    * mem_ptr: 
        * 类型为`unsigned char**`，指向待释放的内存区域。
        * 调用者传入类型为`unsigned char`的数组，数组元素会被忽略
        * 如果参数值为`NULL`，则啥也不做
* 返回：
    * 通用错误码 

<a name="2.6.2"></a>
### 2.6.2 线程

线程相关的函数包括：

* [2.6.2.1 GetThreadState][68]
* [2.6.2.2 GetCurrentThread][69]
* [2.6.2.3 GetAllThreads][70]
* [2.6.2.4 SuspendThread][71]
* [2.6.2.5 SuspendThreadList][72]
* [2.6.2.6 ResumeThread][73]
* [2.6.2.7 ResumeThreadList][74]
* [2.6.2.8 StopThread][75]
* [2.6.2.9 InterruptThread][76]
* [2.6.2.10 GetThreadInfo][77]
* [2.6.2.11 GetOwnedMonitorInfo][78]
* [2.6.2.12 GetOwnedMonitorStackDepthInfo][79]
* [2.6.2.13 GetCurrentContendedMonitor][80]
* [2.6.2.14 RunAgentThread][81]
* [2.6.2.15 SetThreadLocalStorage][82]
* [2.6.2.16 GetThreadLocalStorage][83]

<a name="2.6.2.1"></a>
#### 2.6.2.1 GetThreadState

    ```c
    jvmtiError GetThreadState(jvmtiEnv* env, jthread thread, jint* thread_state_ptr)
    ```

该函数用于获取当前线程状态。线程状态值的说明参见[2.6.2节][29]的说明。

JVMTI线程状态如下：

    线程状态常量                                      常量值       描述
    JVMTI_THREAD_STATE_ALIVE	                    0x0001	    线程存活着。0表示线程是新创建(还未启动)或已结束的。
    JVMTI_THREAD_STATE_TERMINATED	                0x0002	    线程已经结束执行
    JVMTI_THREAD_STATE_RUNNABLE	                    0x0004	    线程运行中
    JVMTI_THREAD_STATE_BLOCKED_ON_MONITOR_ENTER	    0x0400	    线程正等待进入同步块，或者在调用函数"Object.wait()"后，等待重新进入同步块
    JVMTI_THREAD_STATE_WAITING	                    0x0080	    线程正在等待
    JVMTI_THREAD_STATE_WAITING_INDEFINITELY	        0x0010	    线程正在等待，且没有超时，例如调用了函数"Object.wait()"
    JVMTI_THREAD_STATE_WAITING_WITH_TIMEOUT	        0x0020	    线程正在等待，且设置了超时，例如调用了函数"Object.wait(long)"
    JVMTI_THREAD_STATE_IN_OBJECT_WAIT	            0x0100	    线程正在等待获取对象监视器，例如调用了函数"Object.wait"
    JVMTI_THREAD_STATE_PARKED	                    0x0200	    线程已经被暂停，例如调用了函数"LockSupport.park"，"LockSupport.parkUtil"和"LockSupport.parkNanos"
    JVMTI_THREAD_STATE_SUSPENDED	                0x100000	线程被挂起，例如调用了函数"java.lang.Thread.suspend()"，或者JVMTI函数"SuspendThread"。若该状态位被设置，则状态值的其他位表示了线程在被挂起前的状态。
    JVMTI_THREAD_STATE_INTERRUPTED	                0x200000    线程已经被中断Thread has been interrupted.
    JVMTI_THREAD_STATE_IN_NATIVE	                0x400000	线程正在执行本地代码。需要注意的，JVM在执行JIT编译后的Java代码或JVM本身的代码时，并不会设置该标志位。JNI和JVMTI可能会作为JVM本身代码实现。
    JVMTI_THREAD_STATE_VENDOR_1	                    0x10000000	由JVM厂商定义。
    JVMTI_THREAD_STATE_VENDOR_2	                    0x20000000	由JVM厂商定义。
    JVMTI_THREAD_STATE_VENDOR_3	                    0x40000000	由JVM厂商定义。

JVMTI线程状态与Java线程状态的对应关系：

    常量                                         值                                                  描述
    	                                        JVMTI_THREAD_STATE_TERMINATED | 
                                                JVMTI_THREAD_STATE_ALIVE | 
                                                JVMTI_THREAD_STATE_RUNNABLE | 
    JVMTI_JAVA_LANG_THREAD_STATE_MASK           JVMTI_THREAD_STATE_BLOCKED_ON_MONITOR_ENTER |       Mask the state with this before comparison
                                                JVMTI_THREAD_STATE_WAITING | 
                                                JVMTI_THREAD_STATE_WAITING_INDEFINITELY | 
                                                JVMTI_THREAD_STATE_WAITING_WITH_TIMEOUT	

    JVMTI_JAVA_LANG_THREAD_STATE_NEW	        0	                                                java.lang.Thread.State.NEW

    JVMTI_JAVA_LANG_THREAD_STATE_TERMINATED	    JVMTI_THREAD_STATE_TERMINATED	                    java.lang.Thread.State.TERMINATED

    JVMTI_JAVA_LANG_THREAD_STATE_RUNNABLE	    JVMTI_THREAD_STATE_ALIVE |                          java.lang.Thread.State.RUNNABLE
                                                JVMTI_THREAD_STATE_RUNNABLE	

    JVMTI_JAVA_LANG_THREAD_STATE_BLOCKED	    JVMTI_THREAD_STATE_ALIVE | 
                                                JVMTI_THREAD_STATE_BLOCKED_ON_MONITOR_ENTER	        java.lang.Thread.State.BLOCKED

                                        	    JVMTI_THREAD_STATE_ALIVE | 
    JVMTI_JAVA_LANG_THREAD_STATE_WAITING        JVMTI_THREAD_STATE_WAITING |                        java.lang.Thread.State.WAITING
                                                JVMTI_THREAD_STATE_WAITING_INDEFINITELY	

                                            	JVMTI_THREAD_STATE_ALIVE | 
    JVMTI_JAVA_LANG_THREAD_STATE_TIMED_WAITING  JVMTI_THREAD_STATE_WAITING |                        java.lang.Thread.State.TIMED_WAITING
                                                JVMTI_THREAD_STATE_WAITING_WITH_TIMEOUT	

线程状态的设计考虑了将来对规范的扩展，因此不应该将状态值作为标量使用。大多数的查询，都应该测试状态值的某个标志位是否被设置。本文中没有定义的标志位是为将来预留的。遵守规范的JVM实现必须将预留的标志位设置为`0`。JVMTI代理应该忽略这些预留的标志位，不能假设他们肯定就是`0`。

示例：

* 阻塞在`synchromized`语句的线程的状态为：

        JVMTI_THREAD_STATE_ALIVE + JVMTI_THREAD_STATE_BLOCKED_ON_MONITOR_ENTER

* 还未启动的线程的状态为：

        0

* 调用了函数`object.wait(3000)`的线程状态为：

        JVMTI_THREAD_STATE_ALIVE + JVMTI_THREAD_STATE_WAITING + JVMTI_THREAD_STATE_WAITING_WITH_TIMEOUT + JVMTI_THREAD_STATE_MONITOR_WAITING

* 运行过程中被挂起的线程状态为：

        JVMTI_THREAD_STATE_ALIVE + JVMTI_THREAD_STATE_RUNNABLE + JVMTI_THREAD_STATE_SUSPENDED

大多数场景下，程序应该针对指定的标志位进行测试。例如：

* 线程是否正在休眠：

        ```c
        jint state;
        jvmtiError err;

        err = (*jvmti)->GetThreadState(jvmti, thread, &state);
        if (err == JVMTI_ERROR_NONE) {
        if (state & JVMTI_THREAD_STATE_SLEEPING) {  ...
        ```

* 线程是否正在等待(`Object.wait`，暂停或休眠)：

        ```c
        if (state & JVMTI_THREAD_STATE_WAITING) {  ...
        ```

* 线程是否还未启动：

        ```c
        if ((state & (JVMTI_THREAD_STATE_ALIVE | JVMTI_THREAD_STATE_TERMINATED)) == 0)  {  ...
        ```

* 判断线程是调用了`object.wait()`还是`object.wait(long)`:

        ```c
        if (state & JVMTI_THREAD_STATE_IN_OBJECT_WAIT)  {  
            if (state & JVMTI_THREAD_STATE_WAITING_WITH_TIMEOUT)  {
                printf("in Object.wait(long timeout)\n");
            } else {
                printf("in Object.wait()\n");
            }
        }
        ```

函数`java.lang.Thread.getState()`返回的线程状态`java.lang.Thread.State`是函数`GetThreadState`返回值的子集。通过掩码做位运算，可以获取到对应的`java.lang.Thread.State`。下面的代码展示了如何根据函数`GetThreadState`的返回值获取对应的`java.lang.Thread.State`：

    ```c
    err = (*jvmti)->GetThreadState(jvmti, thread, &state);
    abortOnError(err);
        switch (state & JVMTI_JAVA_LANG_THREAD_STATE_MASK) {
        case JVMTI_JAVA_LANG_THREAD_STATE_NEW:
            return "NEW";
        case JVMTI_JAVA_LANG_THREAD_STATE_TERMINATED:
            return "TERMINATED";
        case JVMTI_JAVA_LANG_THREAD_STATE_RUNNABLE:
            return "RUNNABLE";
        case JVMTI_JAVA_LANG_THREAD_STATE_BLOCKED:
            return "BLOCKED";
        case JVMTI_JAVA_LANG_THREAD_STATE_WAITING:
            return "WAITING";
        case JVMTI_JAVA_LANG_THREAD_STATE_TIMED_WAITING:
            return "TIMED_WAITING";
        }
    ```

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 17
* Since： 1.0
* 功能： 必选
* 参数：
    * `thread`: 类型为`jthread`，待处理的线程对象，若为`NULL`，则表示要处理当前线程
    * `thread_state_ptr`: 
        * 类型为`jint*`，出参
        * 调用者传入指向`jint`的指针，函数返回时，会将线程状态的值放到该指针指向的内存
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_THREAD`： 参数`thread`指向的并不是线程对象
    * `JVMTI_ERROR_NULL_POINTER`： 参数`thread_state_ptr`为`NULL`

<a name="2.6.2.2"></a>
#### 2.6.2.2 GetCurrentThread

    ```c
    jvmtiError GetCurrentThread(jvmtiEnv* env, jthread* thread_ptr)
    ```

该函数用于获取当前线程对象，这里获取的在Java代码中调用该函数时所在的线程。

注意，大部分接收线程对象作为参数JVMTI函数，在接收到`NULL`时，都会以当前线程作为目标。

* 调用阶段： 只可能在`start`或`live`阶段调用
* 回调安全： 无
* 索引位置： 18
* Since： 1.1
* 功能： 必选
* 参数：
    * `thread_ptr`: 
        * 类型为`jthread*`，出参，用于获取线程对象。
        * 调用者传入指向`jthread`的指针，函数返回的时候，会填入获取到的线程对象。
        * 获取到的线程对象是一个JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NULL_POINTER`: 参数`thread_ptr`为`NULL`

<a name="2.6.2.3"></a>
#### 2.6.2.3 GetAllThreads

    ```c
    jvmtiError GetAllThreads(jvmtiEnv* env, jint* threads_count_ptr, jthread** threads_ptr)
    ```

该函数用于获取所有存活的线程，注意，这里所说的是Java的线程，即所有连接到JVM的线程。若函数`java.lang.Thread.isAlive()`返回`true`，表示该线程是存活的，即线程已经启动了，但还没有死。线程的全部范围由JVMTIz还行环境的上下文决定，典型情况下，就是所连接到JVM的线程。注意，这其中是包含JVMTI代理线程的。有参见`RunAgentThread`的说明。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 4
* Since： 1.0
* 功能： 必选
* 参数：
    * `threads_count_ptr`: 
        * 类型为`jint*`，出参
        * 调用者传入指向`jint`指针，函数返回的时候，会填入获取到的线程的个数
    * `threads_ptr`: 
        * 类型为`jthread**`，出参，表示获取到的线程数组。
        * 调用者传入指向`jthread*`指针，函数返回的时候，会创建一个长度为`threads_count_ptr`的数组，将来需要调用函数`Deallocate`加以释放。
        * 获取到的线程对象是JNI局部引用，必须加以管理
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NULL_POINTER`: 参数`threads_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`threads_ptr`为`NULL`

<a name="2.6.2.4"></a>
#### 2.6.2.4 SuspendThread

    ```c
    jvmtiError SuspendThread(jvmtiEnv* env, jthread thread)
    ```

暂定目标线程。如果指定了目标线程，则会阻塞当前函数，直到其他线程对目标线程调用了函数`ResumeThread`。如果要暂停的是当前线程，则该函数啥也不干，返回错误

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 5
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_suspend`: 是否能暂停/恢复线程
* 参数：
    * `thread`: 类型为`jthread`，要暂停的目标线程，若为`NULL`，则表示当前线程
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_suspend`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_THREAD_SUSPENDED`: 线程已经被暂停
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是一个线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 线程不是存活状态，可能还未启动或已经死亡

<a name="2.6.2.5"></a>
#### 2.6.2.5 SuspendThreadList

    ```c
    jvmtiError SuspendThreadList(jvmtiEnv* env, jint request_count, const jthread* request_list, jvmtiError* results)
    ```

该函数用于暂停指定的线程集合，暂停之后，可以通过函数`ResumeThreadList`或`ResumeThread`恢复运行。如果调用线程也在指定的线程集合中，则该函数不会返回，直到其他线程恢复调用线程的运行。若在暂停线程时遇到错误，会在出参中放置错误信息，而不是函数返回值，此时已经被暂停的线程不会改变状态。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 92
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_suspend`: 是否能暂停/恢复线程
* 参数：
    * `request_count`: 类型为`jint`，要暂停的线程的数目
    * `request_list`: 
        * 类型为`const jthread*`，待暂停的线程的数组
        * 调用者传入一个数组，数组元素的类型为`jthread`，数组元素的个数为`request_count`
    * `results`: 
        * 类型为`jvmtiError*`，出参
        * 调用者要传入一个长度为`request_count`的数组，函数返回时，会放入暂停线程时的错误码，若线程被正确暂停，则放入`JVMTI_ERROR_NONE`，其他错误信息参见[函数`SuspendThread`的说明][71]
        * 调用者传入的数组必须能够存放足够数量的`jvmtiError`对象。函数返回时，会忽略传入时的值，并设置操作结果
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_suspend`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`request_count`小于0
    * `JVMTI_ERROR_NULL_POINTER`: 参数`request_list`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`results`为`NULL`

<a name="2.6.2.6"></a>
#### 2.6.2.6 ResumeThread

    ```c
    jvmtiError ResumeThread(jvmtiEnv* env, jthread thread)
    ```

恢复已暂停线程的运行。通过JVMTI的暂停函数(`SuspendThread`)或`java.lang.Thread.suspend()`暂停的线程可以被恢复运行，对其他的线程无效。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 6
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_suspend`: 是否能暂停/恢复线程
* 参数：
    * `thread`: 类型为`jthread`，要恢复运行的线程
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_suspend`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_THREAD_NOT_SUSPENDED`: 目标线程没有被暂停
    * `JVMTI_ERROR_INVALID_TYPESTATE`: 线程状态已经被改变，状态不一致
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 目标线程不是存活状态，即未启动或已死亡

<a name="2.6.2.7"></a>
#### 2.6.2.7 ResumeThreadList

    ```c
    jvmtiError ResumeThreadList(jvmtiEnv* env, jint request_count, const jthread* request_list, jvmtiError* results)
    ```

恢复目标数组中的线程。通过JVMTI的暂停函数(`SuspendThread`)或`java.lang.Thread.suspend()`暂停的线程可以被恢复运行，对其他的线程无效。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 93
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_suspend`: 是否能暂停/恢复线程
* 参数：
    * `request_count`: 类型为`jint`，要恢复的线程的数量
    * `request_list`: 
        * 类型为`const jthread*`，要恢复的线程数组
        * 调用者需要传入一个`jthread`类型的数组，数组长度为`request_count`
    * `results`: 
        * 类型为`jvmtiError*`，出参
        * 调用者传入一个`jvmtiError`类型的数组，长度为`request_count`，函数返回时，会填入恢复线程运行的操作结果。若操作成功，填入`JVMTI_ERROR_NONE`，否则填入具体的错误码，参见函数[`ResumeThread`][73]。
        * 调用者传入的数组必须能够存放足够数量的`jvmtiError`对象。函数返回时，会忽略传入时的值，并设置操作结果
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_suspend`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`request_count`小于0
    * `JVMTI_ERROR_NULL_POINTER	`: 参数`request_list`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER	`: 参数`results`为`NULL`

<a name="2.6.2.8"></a>
#### 2.6.2.8 StopThread

    ```c
    jvmtiError StopThread(jvmtiEnv* env, jthread thread, jobject exception)
    ```

该函数用于给目标线程发送异步异常，类似于调用方法`java.lang.Thread.stop`。正常情况下，该函数用于以`ThreadDeath`异常杀死目标线程。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 93
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_signal_thread`: 是否能中断/终止线程
* 参数：
    * `thread`: 类型为`jthread`，要终止的线程
    * `exception`: 类型为`jobejct`，异步异常对象
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_signal_thread`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE	`: 目标线程不是存活状态，即未启动或已死亡
    * `JVMTI_ERROR_INVALID_OBJECT`: 参数`exception`不是对象

<a name="2.6.2.9"></a>
#### 2.6.2.9 InterruptThread

    ```c
    jvmtiError InterruptThread(jvmtiEnv* env, jthread thread)
    ```

该函数用于中断目标线程，类似于`java.lang.Thread.interrupt`。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 8
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_signal_thread`: 是否能中断/终止线程
* 参数：
    * `thread`: 类型为`jthread`，要中断的线程
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_signal_thread`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE	`: 目标线程不是存活状态，即未启动或已死亡

<a name="2.6.2.10"></a>
#### 2.6.2.10 GetThreadInfo

    ```c
    jvmtiError GetThreadInfo(jvmtiEnv* env, jthread thread, jvmtiThreadInfo* info_ptr)
    ```

其中，结构体`jvmtiThreadInfo`定义如下：

    ```c
    struct jvmtiThreadInfo {
        char* name;
        jint priority;
        jboolean is_daemon;
        jthreadGroup thread_group;
        jobject context_class_loader;
    };
    ```

字段含义如下：

* `name`: 以自定义UTF-8编码的线程名
* `priority`: 线程优先级，常量值参见`jvmtiThreadPriority`
* `is_daemon`: 目标线程是否是守护线程
* `thread_group`: 目标线程所属的线程组，如果线程已死，该属性值为`NULL`
* `context_class_loader`: 与目标线程相关联的上下文类载入器

该函数用于获取目标线程的相关信息。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 9
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则表示当前线程
    * `info_ptr`: 
        * 类型为`jvmtiThreadInfo*`，
        * 出参，函数返回时，会填入线程信息。
        * JDK1.1的实现中无法识别字段`context_class_loader`，因此其值为`NULL`。
        * 调用者需要传入指向结构体`jvmtiThreadInfo`的指针，函数返回的时候，会向其中赋值。
            * 字段`name`是一个数组，需要调用`Deallocate`来释放
            * 字段`thread_group`是一个局部引用，必须管理起来
            * 字段`context_class_loader`是一个局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_signal_thread`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_NULL_POINTER	`: 参数`info_str`为`NULL`

<a name="2.6.2.11"></a>
#### 2.6.2.11 GetOwnedMonitorInfo

    ```c
    jvmtiError GetOwnedMonitorInfo(jvmtiEnv* env, jthread thread, jint* owned_monitor_count_ptr, jobject** owned_monitors_ptr)
    ```

该函数用于获取目标线程所持有的监视器信息。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 10
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_get_owned_monitor_info`: 是否能获取监视器的属主信息
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则表示当前线程
    * `owned_monitor_count_ptr`: 
        * 类型为`jint*`，出参，函数返回时，会填入监视器的数量
    * `owned_monitors_ptr`:
        * 类型为`jobejct**`，出参，函数返回时，会填入监视器对象
        * 调用者传入指向`jobject*`的指针，函数返回时，会创建长度为`*owned_monitor_count_ptr`的数组对象，后续需要调用函数`Deallocate`函数来释放
        * 数组中的对象是局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_get_owned_monitor_info`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE	`: 参数`thread`不是存活线程，可能未启动或已死亡
    * `JVMTI_ERROR_NULL_POINTER`: 参数`owned_monitor_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`owned_monitors_ptr`为`NULL`

<a name="2.6.2.12"></a>
#### 2.6.2.12 GetOwnedMonitorStackDepthInfo

    ```c
    jvmtiError GetOwnedMonitorStackDepthInfo(jvmtiEnv* env, jthread thread, jint* monitor_info_count_ptr, jvmtiMonitorStackDepthInfo** monitor_info_ptr
    ```

其中，结构体`jvmtiMonitorStackDepthInfo`的定义如下：

    ```c
    typedef struct {
        jobject monitor;
        jint stack_depth;
    } jvmtiMonitorStackDepthInfo;
    ```

其中字段含义如下：

* `monitor`: 监视器对象
* `stack_depth`: 获取到监视器时栈帧的深度。若是当前函数，则深度为0。若JVM无法判断栈帧的深度，则置为-1，例如，通过JNI函数`MonitorEnter`获取到监视器。

该函数用于获取目标线程所持有的监视器信息，以及是在哪个栈帧获取的监视器。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 153
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_get_owned_monitor_stack_depth_info`: 是否能获取到监视器和栈帧深度信息
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则表示当前线程
    * `monitor_info_count_ptr`: 
        * 类型为`jint*`，出参，函数返回时，会填入监视器的数量
    * `monitor_info_ptr`:
        * 类型为`jvmtiMonitorStackDepthInfo **`，出参，函数返回时，会填入监视器对象和栈帧的深度
        * 调用者传入指向`jvmtiMonitorStackDepthInfo*`的指针，函数返回时，会创建长度为`*monitor_info_count_ptr`的数组对象，后续需要调用函数`Deallocate`函数来释放
        * 数组中的对象是局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_get_owned_monitor_info`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE	`: 参数`thread`不是存活线程，可能未启动或已死亡
    * `JVMTI_ERROR_NULL_POINTER`: 参数`monitor_info_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`monitor_info_ptr`为`NULL`

<a name="2.6.2.13"></a>
#### 2.6.2.13 GetCurrentContendedMonitor

    ```c
    jvmtiError GetCurrentContendedMonitor(jvmtiEnv* env, jthread thread, jobject* monitor_ptr)
    ```

获取目标进程正在通过`java.lang.Obejct.wait`方法竞争的对象监视器。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 11
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_get_current_contended_monitor`: 是否能获取到监视器和栈帧深度信息
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则表示当前线程
    * `monitor_ptr`: 
        * 类型为`jobject*`，出参，函数返回时，会填入监视器获取到的监视器对象，若没有，则置为`NULL`
        * 调用者传入指向`jobject`对象的指针，函数返回的是一个JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_get_owned_monitor_info`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE	`: 参数`thread`不是存活线程，可能未启动或已死亡
    * `JVMTI_ERROR_NULL_POINTER`: 参数`monitor_ptr`为`NULL`

<a name="2.6.2.14"></a>
#### 2.6.2.14 RunAgentThread

    ```c
    typedef void (JNICALL *jvmtiStartFunction)(jvmtiEnv* jvmti_env, JNIEnv* jni_env, void* arg);
    ```

该指针为JVMTI提供的回调机制，当使用函数`RunAgentThread`启动一个代理线程时，会调用该指针指向的函数。

    ```c
    jvmtiError RunAgentThread(jvmtiEnv* env, jthread thread, jvmtiStartFunction proc, const void* arg, jint priority)
    ```

函数`RunAgentThread`用于以指定的本地函数，启动JVMTI代理线程。参数`arg`是会作为目标函数的参数传入，新创建的JVMTI代理线程可以用来处理与其他线程的交互，或者处理指定的事件，使用这种方式创建线程，无需载入`java.lang.Thread`的子类或是其他实现了接口`java.lang.Runnable`的类。新创建的JVMTI代理线程可以一直在本地代码中运行，但是该线程需要关联一个新创建的`java.lang.Thread`实例，这个实例可以用JNI函数来创建。

线程优先级常量`jvmtiThreadPriority`：

    常量                             值      描述
    JVMTI_THREAD_MIN_PRIORITY	    1	    Minimum possible thread priority
    JVMTI_THREAD_NORM_PRIORITY	    5	    Normal thread priority
    JVMTI_THREAD_MAX_PRIORITY	    10	    Maximum possible thread priority

新创建的线程会作为守护线程启动，如果启用了事件`ThreadStart`的话，会发送事件`ThreadStart`。

由于线程已经启动了，因此在该函数返回时，线程处于存活状态，除非线程在启动后立刻就死了。

该线程的线程组会被忽略，该线程不会被添加到线程组，而且在通过Java或JVMTI级别的接口查询线程组时，是查不到该线程的。

在Java编程语言中是看不到这个线程的，但可以在JVMTI中看到，例如可以通过函数`GetAllThreads`或`GetAllStackTraces`。

在执行函数`proc`过程中，新创建的线程会被连接到JVM，参见[JNI的相关文档][101]。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 12
* Since： 1.1
* 功能： 
    * 必选
* 参数：
    * `thread`: 类型为`jthread`，要运行的线程对象
    * `proc`: 类型为`jvmtiStartFunction`，线程的启动函数
    * `arg`: 
        * 类型为`const void *`，传给线程启动函数的参数
        * 调用者传入y一个指针，若为`NULL`，则会将`NULL`传给启动函数
    * `priority`: 类型为`jint`，线程优先级，函数`java.lang.Thread.setPriority`能接受的优先级和常量`jvmtiThreadPriority`的值都可以在这里设置
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_PRIORITY`: 线程优先级的值小于`JVMTI_THREAD_MIN_PRIORITY`或大于`JVMTI_THREAD_MAX_PRIORITY`
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_NULL_POINTER`: 参数`proc`为`NULL`

<a name="2.6.2.15"></a>
#### 2.6.2.15 SetThreadLocalStorage

    ```c
    jvmtiError SetThreadLocalStorage(jvmtiEnv* env, jthread thread, const void* data)
    ```

JVM中内部保存了执行环境和所属线程关联关系，并用一个指针指向它，指针的值就是线程局部存储(thread-local storage)。在调用该函数之前，指针的值为`NULL`，存储数据时，会分配相应的内存。存入的数据，可以通过函数`GetThreadLocalStorage`来获取。

* 调用阶段： 只可能在`start`或`live`阶段调用
* 回调安全： 无
* 索引位置： 103
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `data`: 类型为`const void *`，要存储的数据。调用者传入一个指针，若为`NULL`，则存入`NULL`
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE	`: 参数`thread`不是存活线程，可能未启动或已死亡

<a name="2.6.2.16"></a>
#### 2.6.2.16 GetThreadLocalStorage

    ```c
    jvmtiError GetThreadLocalStorage(jvmtiEnv* env, jthread thread, void** data_ptr)
    ```

该函数用于获取使用函数`SetThreadLocalStorage`存入的数据。

* 调用阶段： 只可能在`start`或`live`阶段调用
* 回调安全： 无
* 索引位置： 102
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `data_ptr`: 类型为`void**`，出参，要获取的数据。若没有通过函数`SetThreadLocalStorage`设置值，则返回`NULL`
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE	`: 参数`thread`不是存活线程，可能未启动或已死亡
    * `JVMTI_ERROR_NULL_POINTER`: 参数`data_ptr`为`NULL`

<a name="2.6.3"></a>
### 2.6.3 线程组

线程组相关函数包括：

* [2.6.3.1 GetTopThreadGroups][84]
* [2.6.3.2 GetThreadGroupInfo][85]
* [2.6.3.3 GetThreadGroupChildren][86]

<a name="2.6.3.1"></a>
#### 2.6.3.1 GetTopThreadGroups

    ```c
    jvmtiError GetTopThreadGroups(jvmtiEnv* env, jint* group_count_ptr, jthreadGroup** groups_ptr)
    ```

该函数用于获取JVM的顶层线程组。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 13
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `group_count_ptr`: 
        * 类型为`jint*`，出参，返回顶层线程组的数量
        * 调用者传入一个指向`jint`的指针
    * `groups_ptr`: 
        * 类型为`jthreadGroup**`，出参，返回顶层线程组的数组
        * 调用者传入指向`jthreadGroup*`的指针，函数返回时，会创建长度为`*group_count_ptr`的数组，后续需要通过函数`Deallocate`来释放
        * 数组中是JNI局部引用，需要管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NULL_POINTER`: 参数`group_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`groups_ptr`为`NULL`

<a name="2.6.3.2"></a>
#### 2.6.3.2 GetThreadGroupInfo

    ```c
    jvmtiError GetThreadGroupInfo(jvmtiEnv* env, jthreadGroup group, jvmtiThreadGroupInfo* info_ptr)
    ```

该函数用于获取线程组相关的信息。

其中，结构体`jvmtiThreadGroupInfo`的定义如下：

    ```c
    typedef struct {
        jthreadGroup parent;
        char* name;
        jint max_priority;
        jboolean is_daemon;
    } jvmtiThreadGroupInfo;
    ```

属性含义如下：

    field           type            desc
    parent	        jthreadGroup	父线程组
    name	        char*	        以自定义UTF-8编码的线程组的名字
    max_priority	jint	        该线程组的最大优先级
    is_daemon	    jboolean	    该线程组是否是守护线程组

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 14
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `group`: 类型为`jthreadGroup`，目标线程组
    * `info_ptr`: 
        * 类型为`jvmtiThreadGroupInfo*`，出参，保存了线程组的相关信息
        * 调用者传入指向`jvmtiThreadGroupInfo`的指针
        * 属性`jvmtiThreadGroupInfo.parent`是一个JNI局部引用，必须管理起来
        * 属性`jvmtiThreadGroupInfo.name`是一个新分配的数组，使用函数`Deallocate`来释放
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_THREAD_GROUP`: 参数`group`为不是一个线程组对象
    * `JVMTI_ERROR_NULL_POINTER`: 参数`info_ptr`为`NULL`

<a name="2.6.3.3"></a>
#### 2.6.3.3 GetThreadGroupChildren

    ```c
    jvmtiError GetThreadGroupChildren(jvmtiEnv* env, jthreadGroup group, jint* thread_count_ptr, jthread** threads_ptr, jint* group_count_ptr, jthreadGroup** groups_ptr)
    ```

该函数用于获取目标线程组中所有的存活线程和子线程组。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 15
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `group`: 类型为`jthreadGroup`，目标线程组
    * `thread_count_ptr`: 
        * 类型为`jint*`，出参，标明目标线程组中存活的线程数量
        * 调用者传入指向`jint`的指针，在函数返回的时候，设置为存活的线程数量
    * `threads_ptr`:
        * 类型为`jthread**`，出参，返回目标线程组中的存活线程
        * 调用者传入指向`jthread*`的指针，函数会创建长度为`*thread_count_ptr`的数组，并将数组的地址赋值到`threads_ptr`，后续需要调用函数`Deallocate`来释放内存
        * 数组中是JNI局部引用，必须管理起来
    * `group_count_ptr`: 
        * 类型为`jint*`，出参，标明存活的子线程组的数量
        * 调用者传入指向`jint`的指针，在函数返回的时候，设置为存活的子线程组的数量
    * `groups_ptr`:
        * 类型为`jthreadGroup**`，出参，返回目标线程组存活的子线程组
        * 调用者传入指向`jthreadGroup*`的指针，函数会创建长度为`*group_count_ptr`的数组，并将数组的地址赋值到`groups_ptr`，后续需要调用函数`Deallocate`来释放内存
        * 数组中是JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_THREAD_GROUP`: 参数`group`为不是一个线程组对象
    * `JVMTI_ERROR_NULL_POINTER`: 参数`thread_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`threads_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`group_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`groups_ptr`为`NULL`

<a name="2.6.4"></a>
### 2.6.4 栈帧

栈帧相关函数包括：

* [2.6.4.1 GetStackTrace][87]
* [2.6.4.2 GetAllStackTraces][88]
* [2.6.4.3 GetThreadListStackTraces][89]
* [2.6.4.4 GetFrameCount][90]
* [2.6.4.5 PopFrame][91]
* [2.6.4.6 GetFrameLocation][92]
* [2.6.4.7 NotifyFramePop][93]

这些函数可用于获取目标线程的栈信息，栈帧由深度值来引用，深度值为0表示为当前帧。

对栈帧的描述参见[JVM规范2.6节][102]。栈帧与方法调用相关(包括本地方法)，但与平台和JVM的内部实现无关。

JVMTI实现可能会通过方法调用来载入线程，而这些函数所获取到的栈帧可能会被包含在栈中，即栈帧的深度可能会比方法`main()`和`run()`大。但这种机制，必须在该JVMTI实现所有的JVMTI功能中保持一致。

栈帧数据结构的定义如下：

    ```c
    typedef struct {
        jmethodID method;
        jlocation location;
    } jvmtiFrameInfo;
    ```

其属性域含义如下：

* `method`: 标明执行该栈帧的方法
* `location`: 当前正在执行的执行的索引位置，若当前为本地方法，则该值为`-1`

栈数据结构的定义如下：

    ```c
    typedef struct {
        jthread thread;
        jint state;
        jvmtiFrameInfo* frame_buffer;
        jint frame_count;
    } jvmtiStackInfo;
    ```

其属性域含义如下：

* `thread`: 出参，表示目标线程
* `state`: 出现，线程状态，参见
* `frame_buffer`: 出参，JVMTI代理创建数组，相应的函数会填入栈帧信息
* `frame_count`: 出参，相应函数会填入栈帧的数量，值为`min(max_frame_count, stackDepth)`

<a name="2.6.4.1"></a>
#### 2.6.4.1 GetStackTrace

    ```c
    jvmtiError GetStackTrace(jvmtiEnv* env, jthread thread, jint start_depth, jint max_frame_count, jvmtiFrameInfo* frame_buffer, jint* count_ptr)
    ```

该函数用于获取目标线程的栈信息。若参数`max_frame_count`的值小于栈的深度，则只返回顶部数量为`max_frame_count`的栈帧，否则返回全部栈帧。参数`frame_buffer`保存了获取的栈帧信息，最近调用的函数放在数组的开始位置。

下面的例子展示了如何获取栈顶的5个栈帧：

    ```c
    jvmtiFrameInfo frames[5];
    jint count;
    jvmtiError err;

    err = (*jvmti)->GetStackTrace(jvmti, aThread, 0, 5, frames, &count);
    if (err == JVMTI_ERROR_NONE && count >= 1) {
        char *methodName;
        err = (*jvmti)->GetMethodName(jvmti, frames[0].method, 
                            &methodName, NULL, NULL);
        if (err == JVMTI_ERROR_NONE) {
            printf("Executing method: %s", methodName);
        }
    }
    ```

调用该函数时，无需挂起目标线程。

函数`GetLineNumberTable`可用于将指令的索引位置映射为源代码的行号。这个操作可以延迟执行。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 104
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `thread`: 类型为`jthread`，目标线程组，若为`NULL`，则表示当前线程
    * `start_depth`: 
        * 类型为`jint`，表示从指定的深度开始获取栈帧信息
        * 若值为非负数，则从当前帧开始计算深度。例如，若值为`0`，则从当前帧开始；若为`1`，则从当前帧的调用者开始；若为`2`，则从当前帧的调用者的调用者开始，以此类推
        * 若为负数，则从第一个函数调用开始计算，第一个栈帧的深度为`stackDepth + start_depth`，其中`stackDepth`为整个栈的深度。例如，若值为`-1`，则只会获取最后一个栈帧；若值为`-2`，则从最后一个栈帧的被调用函数开始。
    * `max_frame_count`: 类型为`jint`，表示要获取的栈帧数量的最大值
    * `frame_buffer`:
        * 类型为`jvmtiFrameInfo *`，出参，调用者创建一块内存区域，用于存储获取的栈帧信息
        * 调用者创建一个足够大的数组，可以放下数量为`max_frame_count`的`jvmtiFrameInfo`。数组原本的内容会被忽略，在函数返回的时候，会设置出参`count_ptr`的值
    * `count_ptr`:
        * 类型为`jint*`，出参，标明获取到的栈帧的数量
        * 若参数`start_depth`为非负数，则该值为`min(max_frame_count, stackDepth - start_depth)`
        * 若参数`start_depth`为负数，则该值为`min(max_frame_count, -start_depth)`
        * 调用者传入一个指向`jint`的指针，函数返回时会设置该值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`start_depth`为正数，且大于`stackDepth`；或者参数`start_depth`小于0，且小于`-stackDepth`
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是一个线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 参数`thread`不是存活线程，可能未启动或已死亡
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`max_frame_count`小于0
    * `JVMTI_ERROR_NULL_POINTER`: 参数`frame_buffer`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`count_ptr`为`NULL`

<a name="2.6.4.2"></a>
#### 2.6.4.2 GetAllStackTraces

    ```c
    jvmtiError GetAllStackTraces(jvmtiEnv* env, jint max_frame_count, jvmtiStackInfo** stack_info_ptr, jint* thread_count_ptr)
    ```

该函数用于获取所有存活线程的栈信息(包括JVMTI代理线程)。若参数`max_frame_count`小于栈的深度，则只返回栈顶部的、数量为`max_frame_count`的栈帧信息；否则返回整个栈信息。参数`frame_buffer`保存了获取的栈帧信息，最近调用的函数放在数组的开始位置。

函数会同时收集所有存活线程的栈信息，即在收集信息时，线程状态和栈的信息不会发生变化。线程会被挂起。

示例如下：

    ```c
    jvmtiStackInfo *stack_info;
    jint thread_count;
    int ti;
    jvmtiError err;

    err = (*jvmti)->GetAllStackTraces(jvmti, MAX_FRAMES, &stack_info, &thread_count); 
    if (err != JVMTI_ERROR_NONE) {
        ...   
    }
    for (ti = 0; ti < thread_count; ++ti) {
        jvmtiStackInfo *infop = &stack_info[ti];
        jthread thread = infop->thread;
        jint state = infop->state;
        jvmtiFrameInfo *frames = infop->frame_buffer;
        int fi;

        myThreadAndStatePrinter(thread, state);
        for (fi = 0; fi < infop->frame_count; fi++) {
            myFramePrinter(frames[fi].method, frames[fi].location);
        }
    }
    /* this one Deallocate call frees all data allocated by GetAllStackTraces */
    err = (*jvmti)->Deallocate(jvmti, stack_info); 
    ```

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 100
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `max_frame_count`: 类型为`jint`，表示要获取的栈帧数量的最大值
    * `stack_info_ptr`:
        * 类型为`jvmtiStackInfo **`，出参，函数返回时会填入线程的栈信息，数组元素的个数由参数`thread_count_ptr`指定
        * 调用者创建一个足够大的数组，可以放下数量为`max_frame_count`的`jvmtiFrameInfo`。数组原本的内容会被忽略，在函数返回的时候，会设置出参`count_ptr`的值
        * 需要注意的是，函数在分配内存时，包含了`jvmtiFrameInfo`数组的部分，这部分区域的地址放在属性域`jvmtiStackInfo.frame_buffer`中，不能分别释放内存
        * 调用者传入指向`jvmtiStackInfo*`的指针，函数返回时，`jvmtiStackInfo*`会指向一个新分配的数组，后续需要使用函数`Deallocate`释放该数组。数组中的元素时JNI局部引用，必须管理起来
    * `thread_count_ptr`:
        * 类型为`jint*`，出参，标明线程的数量
        * 调用者传入一个指向`jint`的指针，函数返回时会设置该值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`max_frame_count`小于0
    * `JVMTI_ERROR_NULL_POINTER`: 参数`stack_info_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`thread_count_ptr`为`NULL`

<a name="2.6.4.3"></a>
#### 2.6.4.3 GetThreadListStackTraces

    ```c
    jvmtiError GetThreadListStackTraces(jvmtiEnv* env, jint thread_count, const jthread* thread_list, jint max_frame_count, jvmtiStackInfo** stack_info_ptr)
    ```

该函数用于获取指定线程的栈信息。若参数`max_frame_count`小于栈的深度，则只返回线程栈顶部的`max_frame_count`个栈帧；否则，会返回整个栈。参数`stack_info_ptr`保存了获取的栈帧信息，最近调用的函数放在数组的开始位置。

函数会同时收集目标线程的栈信息，即在收集信息时，线程状态和栈的信息不会发生变化。线程会被挂起。

若目标线程还没有启动或已经死亡，则会返回长度为0的栈帧，属性域`jvmtiStackInfo.frame_count`的值为`0`。开发者可以通过属性域`jvmtiStackInfo.state`来检查线程状态。

函数调用示例参见函数[`GetAllStackTraces`][88]的说明。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 101
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `thread_count`: 类型为`jint`，表示目标线程的数量
    * `thread_list`: 
        * 类型为`const jthread*`，表示目标线程数组
        * 调用者需要传入长度为`thread_count`的数组
    * `max_frame_count`: 类型为`jint`，表示要获取的调用栈的数量
    * `stack_info_ptr`:
        * 类型为`jvmtiStackInfo **`，出参，函数返回时会填入线程的栈信息，数组元素的个数由参数`thread_count_ptr`指定
        * 调用者创建一个足够大的数组，可以放下数量为`max_frame_count`的`jvmtiFrameInfo`。数组原本的内容会被忽略，在函数返回的时候，会设置出参`count_ptr`的值
        * 需要注意的是，函数在分配内存时，包含了`jvmtiFrameInfo`数组的部分，这部分区域的地址放在属性域`jvmtiStackInfo.frame_buffer`中，不能分别释放内存
        * 调用者传入指向`jvmtiStackInfo*`的指针，函数返回时，`jvmtiStackInfo*`会指向一个新分配的数组，后续需要使用函数`Deallocate`释放该数组。数组中的元素时JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread_list`中的某个元素不是线程对象
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`thread_count`小于0
    * `JVMTI_ERROR_NULL_POINTER`: 参数`thread_list`为`NULL`
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`max_frame_count`小于0
    * `JVMTI_ERROR_NULL_POINTER`: 参数`stack_info_ptr`为`NULL`

<a name="2.6.4.4"></a>
#### 2.6.4.4 GetFrameCount

    ```c
    jvmtiError GetFrameCount(jvmtiEnv* env, jthread thread, jint* count_ptr)
    ```

该函数用于获取目标线程调用栈中当前的栈帧数量。

注意，线程中栈帧的数量随时都在变动。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 16
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则表示当前线程
    * `count_ptr`: 类型为`jint*`，出参，函数返回时，会设置栈帧的数量。
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 线程不是存活状态，可能还未启动或已经死亡
    * `JVMTI_ERROR_NULL_POINTER`: 参数`count_ptr`为`NULL`

<a name="2.6.4.5"></a>
#### 2.6.4.5 PopFrame

    ```c
    jvmtiError PopFrame(jvmtiEnv* env, jthread thread)
    ```

该函数用于弹出线程栈帧。弹出顶层栈帧后，会将程序回到前一个栈帧。当线程恢复运行后，线程的执行状态会被置为调用当前方法之前的状态。执行过程如下所示：

* 当前栈帧会被弹出抛弃，前一个栈帧成为顶部栈帧
* 恢复操作数栈，若不是以`invokestatic`指令调用的当前栈帧，则`objectref`也会添加到栈
* 恢复JVM的指令寄存器，将之置为调用当前栈帧的调用指令

需要注意的是，弹出栈帧后，在被调函数中被修改的内容还会保持已经被修改的值；当继续执行的时候，会调用指令序列的第一个指令。

在调用函数`PopFrame`和恢复线程的过程中，线程栈的状态是未定义的。若要弹出多个栈帧，必须按下面3个步骤重复执行：

* 以事件触发的方式暂停挂起线程（例如，步进、断点等）
* 调用函数`PopFrame`
* 恢复线程运行

在弹出栈帧后，调用被调函数而获取的锁(例如被调函数是`synchronized`)和在被调函数因进入同步块而获取到的锁，都会被释放掉。注意，这种自动释放锁的机制，并不适用与本地代码获取的锁或`java.util.concurrent.locks`中的锁。

执行该函数后，`finally`代码块不会执行。

对全局状态的修改不会恢复。

目标线程会被挂起，也就是说，目标线程不能是当前线程。

被调方法和调用方法必须是Java方法。

执行该函数不会触发JVMTI事件。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 80
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_pop_frame`: 是否能弹出栈帧
* 参数：
    * `thread`: 类型为`jthread`，目标线程
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_pop_frame`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 调用方法或被调方法是本地方法，导致无法弹出栈帧
    * `JVMTI_ERROR_THREAD_NOT_SUSPENDED`: 目标线程无法挂起
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 调用栈中栈帧数量少于2个
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 线程不是存活状态，可能还未启动或已经死亡

<a name="2.6.4.6"></a>
#### 2.6.4.6 GetFrameLocation

    ```c
    jvmtiError GetFrameLocation(jvmtiEnv* env, jthread thread, jint depth, jmethodID* method_ptr, jlocation* location_ptr)
    ```

对于Java代码的调用栈帧，返回当前指令的位置。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 80
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_pop_frame`: 是否能获取监视器的属主信息
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `depth`: 类型为`jint`，目标栈帧的深度
    * `method_ptr`: 
        * 类型为`jmethodID*`，出参，指向当前指令位置的方法
        * 调用者传入指向`jmethodID`的指针，函数返回的时候，会设置该值
    * `location_ptr`: 
        * 类型为`jlocation*`，出参，指向当前执行指令的索引位置。若当前方法为本地方法，则置为`-1`
        * 调用者传入指向`jlocation`的指针，函数返回的时候，会设置该值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 线程不是存活状态，可能还未启动或已经死亡
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 参数`depth`所指定的位置没有栈帧
    * `JVMTI_ERROR_NULL_POINTER`: 参数`method_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`location_ptr`为`NULL`

<a name="2.6.4.7"></a>
#### 2.6.4.7 NotifyFramePop

    ```c
    jvmtiError NotifyFramePop(jvmtiEnv* env, jthread thread, jint depth)
    ```

在将指定栈帧从调用栈中弹出后，会产生一个`FramePop`事件。有关事件`FramePop`的详细内容，参见这里。只有非Java方法能接收栈帧弹出事件的通知。

目标线程必须是当前线程，或者是被挂起的。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 80
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_generate_frame_pop_events`: 是否能发送/接收`FramePop`事件
* 参数：
    * `thread`: 类型为`jthread`，弹出栈帧的线程，若为`NULL`，则为当前线程
    * `depth`: 类型为`jint`，被弹出栈帧的深度
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_generate_frame_pop_events`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 调用方法或被调方法是本地方法，导致无法弹出栈帧
    * `JVMTI_ERROR_THREAD_NOT_SUSPENDED`: 目标线程不是挂起状态，也不是当前线程
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 线程不是存活状态，可能还未启动或已经死亡
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 参数`depth`所指定的位置没有栈帧

<a name="2.6.5"></a>
### 2.6.5 强制提前返回

强制提前返回相关的函数包括：

* [2.6.5.1 ForceEarlyReturnObject][94]
* [2.6.5.2 ForceEarlyReturnInt][95]
* [2.6.5.3 ForceEarlyReturnLong][96]
* [2.6.5.4 ForceEarlyReturnFloat][97]
* [2.6.5.5 ForceEarlyReturnDouble][98]
* [2.6.5.6 ForceEarlyReturnVoid][99]

这一系列函数使JVMTI代理可以强制在方法执行的任意位置提前退出。被提前返回的方法称为被调用方法。对于目标线程来说，调用该函数的方法即为被调用方法。

调用该方法时，目标线程必须是挂起状态，或者是当前线程。强制返回的时机发生在Java代码恢复运行时。在调用该系列函数之后，线程恢复执行之前，调用栈的状态是未定义的。

执行该系列函数时，被调用方法不会再继续执行指令。特别的，`finally`代码块也不会执行。这可能会导致应用程序的不一致状态，需要特别注意。

在调用该系列函数后，调用被调函数时获取的锁(`synchronized`代码块)会被释放掉。注意，对于本地代码中的锁和`java.util.concurrent.locks`中的锁，并不会被释放掉。

在调用该系列函数后，会按正常的函数返回顺序，产生相应的事件，例如`MethodExit`。

被调函数必须是非Java代码。调用该系列函数时，若线程只有一个栈帧，则线程恢复运行时会退出。

<a name="2.6.5.1"></a>
#### 2.6.5.1 ForceEarlyReturnObject

    ```c
    jvmtiError ForceEarlyReturnObject(jvmtiEnv* env, jthread thread, jobject value)
    ```

该函数用于从目标线程的当前方法中强制提前返回，当前方法的返回值是`Object`或其子类。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 88
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_force_early_return`: 是否能从方法强制提前返回
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `value`: 类型为`jobject`，从被调用方法的栈帧中返回的值，可以为`NULL`
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_force_early_return`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 调用方法或被调方法是本地方法，或者JVM的实现无法提供此功能
    * `JVMTI_ERROR_TYPE_MISMATCH`: 被调用函数的返回值的类型不是`Object`或`Object`的子类
    * `JVMTI_ERROR_TYPE_MISMATCH`: 参数`value`的实际类型与被调函数返回值的类型bu兼容
    * `JVMTI_ERROR_THREAD_NOT_SUSPENDED`: 目标线程不是挂起状态，也不是当前线程
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 目标线程中已经没有栈帧了
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 线程不是存活状态，可能还未启动或已经死亡
    * `JVMTI_ERROR_INVALID_OBJECT`: 参数`value`不是一个对象

<a name="2.6.5.2"></a>
#### 2.6.5.2 ForceEarlyReturnInt

    ```c
    jvmtiError ForceEarlyReturnInt(jvmtiEnv* env, jthread thread, jint value)
    ```

该函数用于从目标线程的当前方法中强制提前返回，当前方法的返回值是`int` `short` `char`或`boolean`。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 82
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_force_early_return`: 是否能从方法强制提前返回
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `value`: 类型为`jint`，从被调用方法的栈帧中返回的值，可以为`NULL`
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_force_early_return`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 调用方法或被调方法是本地方法，或者JVM的实现无法提供此功能
    * `JVMTI_ERROR_TYPE_MISMATCH`: 被调用函数的返回值的类型不是`int` `short` `char`或`boolean`
    * `JVMTI_ERROR_THREAD_NOT_SUSPENDED`: 目标线程不是挂起状态，也不是当前线程
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 目标线程中已经没有栈帧了
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 线程不是存活状态，可能还未启动或已经死亡

<a name="2.6.5.3"></a>
#### 2.6.5.3 ForceEarlyReturnLong

    ```c
    jvmtiError ForceEarlyReturnLong(jvmtiEnv* env, jthread thread, jlong value)
    ```
该函数用于从目标线程的当前方法中强制提前返回，当前方法的返回值是`long`

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 83
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_force_early_return`: 是否能从方法强制提前返回
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `value`: 类型为`jlong`，从被调用方法的栈帧中返回的值，可以为`NULL`
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_force_early_return`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 调用方法或被调方法是本地方法，或者JVM的实现无法提供此功能
    * `JVMTI_ERROR_TYPE_MISMATCH`: 被调用函数的返回值的类型不是`long`
    * `JVMTI_ERROR_THREAD_NOT_SUSPENDED`: 目标线程不是挂起状态，也不是当前线程
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 目标线程中已经没有栈帧了
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 线程不是存活状态，可能还未启动或已经死亡

<a name="2.6.5.4"></a>
#### 2.6.5.4 ForceEarlyReturnFloat

    ```c
    jvmtiError ForceEarlyReturnFloat(jvmtiEnv* env, jthread thread, jfloat value)
    ```

该函数用于从目标线程的当前方法中强制提前返回，当前方法的返回值是`float`

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 84
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_force_early_return`: 是否能从方法强制提前返回
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `value`: 类型为`jfloat`，从被调用方法的栈帧中返回的值，可以为`NULL`
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_force_early_return`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 调用方法或被调方法是本地方法，或者JVM的实现无法提供此功能
    * `JVMTI_ERROR_TYPE_MISMATCH`: 被调用函数的返回值的类型不是`float`
    * `JVMTI_ERROR_THREAD_NOT_SUSPENDED`: 目标线程不是挂起状态，也不是当前线程
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 目标线程中已经没有栈帧了
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 线程不是存活状态，可能还未启动或已经死亡

<a name="2.6.5.5"></a>
#### 2.6.5.5 ForceEarlyReturnDouble

    ```c
    jvmtiError ForceEarlyReturnDouble(jvmtiEnv* env, jthread thread, jdouble value)
    ```

该函数用于从目标线程的当前方法中强制提前返回，当前方法的返回值是`double`

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 85
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_force_early_return`: 是否能从方法强制提前返回
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `value`: 类型为`jdouble`，从被调用方法的栈帧中返回的值，可以为`NULL`
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_force_early_return`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 调用方法或被调方法是本地方法，或者JVM的实现无法提供此功能
    * `JVMTI_ERROR_TYPE_MISMATCH`: 被调用函数的返回值的类型不是`double`
    * `JVMTI_ERROR_THREAD_NOT_SUSPENDED`: 目标线程不是挂起状态，也不是当前线程
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 目标线程中已经没有栈帧了
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 线程不是存活状态，可能还未启动或已经死亡


<a name="2.6.5.6"></a>
#### 2.6.5.6 ForceEarlyReturnVoid

    ```c
    jvmtiError ForceEarlyReturnVoid(jvmtiEnv* env, jthread thread)
    ```

该函数用于从目标线程的当前方法中强制提前返回，当前方法的不能有返回值。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 86
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_force_early_return`: 是否能从方法强制提前返回
* 参数：
    * `thread`: 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_force_early_return`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 调用方法或被调方法是本地方法，或者JVM的实现无法提供此功能
    * `JVMTI_ERROR_TYPE_MISMATCH`: 被调用函数的有返回值
    * `JVMTI_ERROR_THREAD_NOT_SUSPENDED`: 目标线程不是挂起状态，也不是当前线程
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 目标线程中已经没有栈帧了
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 线程不是存活状态，可能还未启动或已经死亡

<a name="2.6.6"></a>
### 2.6.6 堆

堆处理相关的函数包括：

* [2.6.6.1 FollowReferences][103]
* [2.6.6.2 IterateThroughHeap][104]
* [2.6.6.3 GetTag][105]
* [2.6.6.4 SetTag][106]
* [2.6.6.5 GetObjectsWithTags][107]
* [2.6.6.6 ForceGarbageCollection][108]

堆处理相关的函数类型包括：

* [jvmtiHeapIterationCallback]
* [jvmtiHeapReferenceCallback]
* [jvmtiPrimitiveFieldCallback]
* [jvmtiArrayPrimitiveValueCallback]
* [jvmtiStringPrimitiveValueCallback]
* [jvmtiReservedCallback]

堆的类型包括：

* [jvmtiHeapReferenceKind] - Heap Reference Enumeration
* [jvmtiPrimitiveType] - Primitive Type Enumeration
* [jvmtiHeapReferenceInfoField] - Reference information structure for Field references
* [jvmtiHeapReferenceInfoArray] - Reference information structure for Array references
* [jvmtiHeapReferenceInfoConstantPool] - Reference information structure for Constant Pool references
* [jvmtiHeapReferenceInfoStackLocal] - Reference information structure for Local Variable references
* [jvmtiHeapReferenceInfoJniLocal] - Reference information structure for JNI local references
* [jvmtiHeapReferenceInfoReserved] - Reference information structure for Other references
* [jvmtiHeapReferenceInfo] - Reference information structure
* [jvmtiHeapCallbacks] - Heap callback function structure

相关常量包括：

* [Heap Filter Flags]
* [Heap Visit Control Flags]

这一系列函数用于分析堆，查看堆中对象，以及给对象打标签。

对象标签是与堆中对象相关联的值，在JVMTI代理中可以通过函数`SetTag`或回调函数`jvmtiHeapIterationCallback`来设置。

对象标签是与执行环境相关联的，因此，在一个执行环境设置的标签，在其他执行环境中是不可见的。

标签的值是`jlong`类型的，可用于标记一个对象或存储一个指向更复杂信息的指针。在没有被打标签的对象中，标签的值为`0`，因此将该值设置为`0`，即可将对象的标签解除。

JVMTI代理可以使用堆相关的函数来遍历堆，按照对象引用递归的访问所有对象，获取相关信息。

使用回调函数时，需要遵守以下规则： 

* **回调函数中禁止使用JNI函数**
* **除非特别说明，回调函数中禁止使用JVMTI函数**，例如原始监视器、内存管理和线程局部存储函数

某些JVM实现，可能会使用内部线程来调用回调函数，也可能会使用调用迭代函数的线程来调用回调函数。堆的回调时单线程运行的，一次只会调用一个回调函数。

可以使用过滤标记(**Heap Filter Flags**)来控制过滤条件：

    Constant	                        Value	Description
    JVMTI_HEAP_FILTER_TAGGED	        0x4	    过滤掉已加标签的对象
    JVMTI_HEAP_FILTER_UNTAGGED	        0x8	    过滤掉未加标签的对象
    JVMTI_HEAP_FILTER_CLASS_TAGGED	    0x10	过滤掉已加标签的类
    JVMTI_HEAP_FILTER_CLASS_UNTAGGED	0x20	过滤掉未加标签的类


堆回调函数返回的访问控制标记(**Heap Visit Control Flags**)可用于退出当前迭代。对于回调函数`jvmtiHeapReferenceCallback`来说，可用于减小遍历对象引用工作量。
The Heap Visit Control Flags are returned by the heap callbacks and can be used to abort the iteration. For the Heap Reference Callback, it can also be used to prune the graph of traversed references (JVMTI_VISIT_OBJECTS is not set).

    Constant	            Value	Description
    JVMTI_VISIT_OBJECTS	    0x100	若程序正在访问对象，且If we are visiting an object and if this callback was initiated by FollowReferences, traverse the references of this object. Otherwise ignored.
    JVMTI_VISIT_ABORT	    0x8000	Abort the iteration. Ignore all other bits.



<a name="2.6.6.1"></a>
#### 2.6.6.1 FollowReferences



<a name="2.6.7"></a>
### 2.6.7 堆1.0

<a name="2.6.8"></a>
### 2.6.8 局部变量

<a name="2.6.9"></a>
### 2.6.9 断点

<a name="2.6.10"></a>
### 2.6.10 探查属性值

<a name="2.6.11"></a>
### 2.6.11 类

<a name="2.6.12"></a>
### 2.6.12 对象

<a name="2.6.13"></a>
### 2.6.13 属性

<a name="2.6.14"></a>
### 2.6.14 方法

<a name="2.6.15"></a>
### 2.6.15 原始监视器

<a name="2.6.16"></a>
### 2.6.16 JNI方法拦截

<a name="2.6.17"></a>
### 2.6.17 事件管理

<a name="2.6.18"></a>
### 2.6.18 扩展机制

<a name="2.6.19"></a>
### 2.6.19 功能

<a name="2.6.20"></a>
### 2.6.20 计时器

<a name="2.6.21"></a>
### 2.6.21 搜索类加载器

<a name="2.6.22"></a>
### 2.6.22 系统属性

<a name="2.6.23"></a>
### 2.6.23 通用

<a name="2.7"></a>
## 2.7 错误码

<a name="3"></a>
# 3 事件

<a name="3.1"></a>
## 3.1 事件索引

<a name="4"></a>
# 4 数据类型

<a name="4.1"></a>
##  4.1 JVMTI中所使用的JNI数据类型

<a name="4.2"></a>
## 4.2 JVMTI中的基本类型

<a name="4.3"></a>
## 4.3 数据结构类型定义

<a name="4.4"></a>
## 4.4 函数类型定义

<a name="4.5"></a>
## 4.5 枚举定义

<a name="4.6"></a>
## 4.6 函数表

<a name="5"></a>
# 5 常量索引

<a name="6"></a>
# 6 变更历史

















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
[21]:     #2
[22]:     #2.1
[23]:     #2.2
[24]:     #2.3
[25]:     #2.4
[26]:     #2.5
[27]:     #2.6
[28]:     #2.6.1
[29]:     #2.6.2
[30]:     #2.6.3
[31]:     #2.6.4
[32]:     #2.6.5
[33]:     #2.6.6
[34]:     #2.6.7
[35]:     #2.6.8
[36]:     #2.6.9
[37]:     #2.6.10
[38]:     #2.6.11
[39]:     #2.6.12
[40]:     #2.6.13
[41]:     #2.6.14
[42]:     #2.6.15
[43]:     #2.6.16
[44]:     #2.6.17
[45]:     #2.6.18
[46]:     #2.6.19
[47]:     #2.6.20
[48]:     #2.6.21
[49]:     #2.6.22
[50]:     #2.6.23
[51]:     #2.7
[52]:     #3
[53]:     #3.1
[54]:     #4
[55]:     #4.1
[56]:     #4.2
[57]:     #4.3
[58]:     #4.4
[59]:     #4.5
[60]:     #4.6
[61]:     #5
[62]:     #6
[63]:     http://blog.caoxudong.info/blog/2017/10/11/jni_functions_note#2
[64]:     http://blog.caoxudong.info/blog/2017/10/11/jni_functions_note#4.5.2
[65]:     http://blog.caoxudong.info/blog/2017/10/11/jni_functions_note#2.5.3
[66]:     #2.6.1.1
[67]:     #2.6.1.2
[68]:     #2.6.2.1
[69]:     #2.6.2.2
[70]:     #2.6.2.3
[71]:     #2.6.2.4
[72]:     #2.6.2.5
[73]:     #2.6.2.6
[74]:     #2.6.2.7
[75]:     #2.6.2.8
[76]:     #2.6.2.9
[77]:     #2.6.2.10
[78]:     #2.6.2.11
[79]:     #2.6.2.12
[80]:     #2.6.2.13
[81]:     #2.6.2.14
[82]:     #2.6.2.15
[83]:     #2.6.2.16
[84]:     #2.6.3.1
[85]:     #2.6.3.2
[86]:     #2.6.3.3
[87]:     #2.6.4.1
[88]:     #2.6.4.2
[89]:     #2.6.4.3
[90]:     #2.6.4.4
[91]:     #2.6.4.5
[92]:     #2.6.4.6
[93]:     #2.6.4.7
[94]:     #2.6.5.1
[95]:     #2.6.5.2
[96]:     #2.6.5.3
[97]:     #2.6.5.4
[98]:     #2.6.5.5
[99]:     #2.6.5.6
[100]:    https://docs.oracle.com/javase/8/docs/platform/jvmti/jvmti.html
[101]:    http://blog.caoxudong.info/blog/2017/10/11/jni_functions_note#5.1.2
[102]:    https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-2.html#jvms-2.6
[103]:    #2.6.6.1
[104]:    #2.6.6.2
[105]:    #2.6.6.3
[106]:    #2.6.6.4
[107]:    #2.6.6.5
[108]:    #2.6.6.6



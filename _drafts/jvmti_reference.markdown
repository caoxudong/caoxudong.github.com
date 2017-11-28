---
title:      JVMTI 参考
layout:     post
category:   blog
tags:       [java, jvm, jvmti]
---

>原文地址，https://docs.oracle.com/javase/8/docs/platform/jvmti/jvmti.html

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
            * [2.6.6.1 jvmtiHeapIterationCallback][109]
            * [2.6.6.2 jvmtiHeapReferenceCallback][110]
            * [2.6.6.3 jvmtiPrimitiveFieldCallback][111]
            * [2.6.6.4 jvmtiArrayPrimitiveValueCallback][112]
            * [2.6.6.5 jvmtiStringPrimitiveValueCallback][113]
            * [2.6.6.6 jvmtiReservedCallback][114]
            * [2.6.6.7 FollowReferences][103]
            * [2.6.6.8 IterateThroughHeap][104]
            * [2.6.6.9 GetTag][105]
            * [2.6.6.10 SetTag][106]
            * [2.6.6.11 GetObjectsWithTags][107]
            * [2.6.6.12 ForceGarbageCollection][108]
        * [2.6.7 堆1.0][34]
            * [2.6.7.1 jvmtiHeapObjectCallback][115]
            * [2.6.7.2 jvmtiHeapRootCallback][116]
            * [2.6.7.3 jvmtiStackReferenceCallback][117]
            * [2.6.7.4 jvmtiObjectReferenceCallback][118]
            * [2.6.7.5 IterateOverObjectsReachableFromObject][119]
            * [2.6.7.6 IterateOverReachableObjects][120]
            * [2.6.7.7 IterateOverHeap][121]
            * [2.6.7.8 IterateOverInstancesOfClass][122]
        * [2.6.8 局部变量][35]
            * [2.6.8.1 GetLocalObject][123]
            * [2.6.8.2 GetLocalInstance][124]
            * [2.6.8.3 GetLocalInt][125]
            * [2.6.8.4 GetLocalLong][126]
            * [2.6.8.5 GetLocalFloat][127]
            * [2.6.8.6 GetLocalDouble][128]
            * [2.6.8.7 SetLocalObject][129]
            * [2.6.8.8 SetLocalInt][130]
            * [2.6.8.9 SetLocalLong][131]
            * [2.6.8.10 SetLocalFloat][132]
            * [2.6.8.11 SetLocalDouble][133]
        * [2.6.9 断点][36]
            * [2.6.9.1 SetBreakpoint][134]
            * [2.6.9.2 ClearBreakpoint][135]
        * [2.6.10 监察属性值][37]
            * [2.6.10.1 SetFieldAccessWatch][136]
            * [2.6.10.2 ClearFieldAccessWatch][137]
            * [2.6.10.3 SetFieldModificationWatch][138]
            * [2.6.10.4 ClearFieldModificationWatch][139]
        * [2.6.11 类][38]
            * [2.6.11.1 GetLoadedClasses][140]
            * [2.6.11.2 GetClassLoaderClasses][142]
            * [2.6.11.3 GetClassSignature][143]
            * [2.6.11.4 GetClassStatus][144]
            * [2.6.11.5 GetSourceFileName][145]
            * [2.6.11.6 GetClassModifiers][146]
            * [2.6.11.7 GetClassMethods][148]
            * [2.6.11.8 GetClassFields][149]
            * [2.6.11.9 GetImplementedInterfaces][150]
            * [2.6.11.10 GetClassVersionNumbers][151]
            * [2.6.11.11 GetConstantPool][152]
            * [2.6.11.12 IsInterface][153]
            * [2.6.11.13 IsArrayClass][154]
            * [2.6.11.14 IsModifiableClass][155]
            * [2.6.11.15 GetClassLoader][156]
            * [2.6.11.16 GetSourceDebugExtension][157]
            * [2.6.11.17 RetransformClasses][158]
            * [2.6.11.18 RedefineClasses][159]
        * [2.6.12 对象][39]
            * [2.6.12.1 GetObjectSize][160]
            * [2.6.12.2 GetObjectHashCode][161]
            * [2.6.12.3 GetObjectMonitorUsage][162]
        * [2.6.13 属性][40]
            * [2.6.13.1 GetFieldName][164]
            * [2.6.13.2 GetFieldDeclaringClass][165]
            * [2.6.13.3 GetFieldModifiers][166]
            * [2.6.13.4 IsFieldSynthetic][167]
        * [2.6.14 方法][41]
            * [2.6.14.1 GetMethodName][168]
            * [2.6.14.2 GetMethodDeclaringClass][169]
            * [2.6.14.3 GetMethodModifiers][170]
            * [2.6.14.4 GetMaxLocals][171]
            * [2.6.14.5 GetArgumentsSize][172]
            * [2.6.14.6 GetLineNumberTable][173]
            * [2.6.14.7 GetMethodLocation][174]
            * [2.6.14.8 GetLocalVariableTable][175]
            * [2.6.14.9 GetBytecodes][176]
            * [2.6.14.10 IsMethodNative][177]
            * [2.6.14.11 IsMethodSynthetic][178]
            * [2.6.14.12 IsMethodObsolete][179]
            * [2.6.14.13 SetNativeMethodPrefix][180]
            * [2.6.14.14 SetNativeMethodPrefixes][181]
        * [2.6.15 原始监视器][42]
            * [2.6.15.1 CreateRawMonitor][182]
            * [2.6.15.2 DestroyRawMonitor][183]
            * [2.6.15.3 RawMonitorEnter][184]
            * [2.6.15.4 RawMonitorExit][185]
            * [2.6.15.5 RawMonitorWait][186]
            * [2.6.15.6 RawMonitorNotify][187]
            * [2.6.15.7 RawMonitorNotifyAll][188]
        * [2.6.16 JNI方法拦截][43]
            * [2.6.16.1 SetJNIFunctionTable][189]
            * [2.6.16.2 GetJNIFunctionTable][190]
        * [2.6.17 事件管理][44]
            * [2.6.17.1 SetEventCallbacks][191]
            * [2.6.17.2 SetEventNotificationMode][192]
            * [2.6.17.3 GenerateEvents][193]
        * [2.6.18 扩展机制][45]
            * [2.6.18.1 jvmtiExtensionFunction][194]
            * [2.6.18.2 jvmtiExtensionEvent][195]
            * [2.6.18.3 GetExtensionFunctions][196]
            * [2.6.18.4 GetExtensionEvents][197]
            * [2.6.18.5 SetExtensionEventCallback][198]
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

* [2.6.6.7 FollowReferences][103]
* [2.6.6.8 IterateThroughHeap][104]
* [2.6.6.9 GetTag][105]
* [2.6.6.10 SetTag][106]
* [2.6.6.11 GetObjectsWithTags][107]
* [2.6.6.12 ForceGarbageCollection][108]

堆处理相关的函数类型包括：

* [2.6.6.1 jvmtiHeapIterationCallback]
* [2.6.6.2 jvmtiHeapReferenceCallback]
* [2.6.6.3 jvmtiPrimitiveFieldCallback]
* [2.6.6.4 jvmtiArrayPrimitiveValueCallback]
* [2.6.6.5 jvmtiStringPrimitiveValueCallback]
* [2.6.6.6 jvmtiReservedCallback]

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

                    Heap Filter Flags
    Constant	                        Value	Description
    JVMTI_HEAP_FILTER_TAGGED	        0x4	    过滤掉已加标签的对象
    JVMTI_HEAP_FILTER_UNTAGGED	        0x8	    过滤掉未加标签的对象
    JVMTI_HEAP_FILTER_CLASS_TAGGED	    0x10	过滤掉已加标签的类
    JVMTI_HEAP_FILTER_CLASS_UNTAGGED	0x20	过滤掉未加标签的类


堆回调函数返回的访问控制标记(**Heap Visit Control Flags**)可用于退出当前迭代。对于回调函数`jvmtiHeapReferenceCallback`来说，可用于减小遍历对象引用工作量。

                Heap Visit Control Flags
    Constant	            Value	Description
    JVMTI_VISIT_OBJECTS	    0x100	若程序正在访问对象，且该回调时由函数"FollowReferences"发起的，则遍历该对象的引用；否则，忽略。
    JVMTI_VISIT_ABORT	    0x8000	中断当前迭代。使用该选项会忽略掉其他的标志位。

堆引用枚举(**Heap Reference Enumeration**)由堆引用回调(**Heap Reference Callback**)和原生属性回调(**Primitive Field Callback**)提供，用于描述引用的具体类型，如下所示：

            Heap Reference Enumeration (jvmtiHeapReferenceKind)
    Constant	                            Value	Description
    JVMTI_HEAP_REFERENCE_CLASS	            1	    从对象实例指向其类对象的引用
    JVMTI_HEAP_REFERENCE_FIELD	            2	    从对象实例指向其成员变量的引用
    JVMTI_HEAP_REFERENCE_ARRAY_ELEMENT	    3	    从数组对象实例指向其某个数组元素的引用
    JVMTI_HEAP_REFERENCE_CLASS_LOADER	    4	    从类对象实例指向其类加载器的引用
    JVMTI_HEAP_REFERENCE_SIGNERS	        5	    从类对象实例指向其签字信息数组的引用
    JVMTI_HEAP_REFERENCE_PROTECTION_DOMAIN	6	    从类对象实例指向其保护域(protection domain)的引用
    JVMTI_HEAP_REFERENCE_INTERFACE	        7	    从类对象实例指向其实现的某个接口的引用。注意，接口被定义为常量池中的某个引用，所以被引用的接口可能会被报告为是"JVMTI_HEAP_REFERENCE_CONSTANT_POOL"类型的引用
    JVMTI_HEAP_REFERENCE_STATIC_FIELD	    8	    从类对象实例指向其某个静态变量的值的引用
    JVMTI_HEAP_REFERENCE_CONSTANT_POOL	    9	    从类对象实例指向常量池中某个已解析的条目的引用
    JVMTI_HEAP_REFERENCE_SUPERCLASS	        10	    从类对象实例指向其父类的引用。如果父类是"java.lang.Object"，则触发回调。注意，已载入的类是通过常量池的引用来定义父类的，因此被引用的父类可能会被报告为是"JVMTI_HEAP_REFERENCE_CONSTANT_POOL"类型的引用
    JVMTI_HEAP_REFERENCE_JNI_GLOBAL	        21	    堆的根集合引用，JNI全局引用
    JVMTI_HEAP_REFERENCE_SYSTEM_CLASS	    22	    堆的根集合引用，系统类
    JVMTI_HEAP_REFERENCE_MONITOR	        23	    堆的根集合引用，监视器
    JVMTI_HEAP_REFERENCE_STACK_LOCAL	    24	    堆的根集合引用，栈上的局部变量
    JVMTI_HEAP_REFERENCE_JNI_LOCAL	        25	    堆的根集合引用，JNI局部引用
    JVMTI_HEAP_REFERENCE_THREAD	            26	    堆的根集合引用，线程
    JVMTI_HEAP_REFERENCE_OTHER	            27	    堆的根集合引用，其他类型的堆根引用

原生类型使用单字符的类型描述符时，对应关系如下所示：

            Primitive Type Enumeration (jvmtiPrimitiveType)
    Constant	                    Value	Description
    JVMTI_PRIMITIVE_TYPE_BOOLEAN	90	    'Z' - Java programming language boolean - JNI jboolean
    JVMTI_PRIMITIVE_TYPE_BYTE	    66	    'B' - Java programming language byte    - JNI jbyte
    JVMTI_PRIMITIVE_TYPE_CHAR	    67	    'C' - Java programming language char    - JNI jchar
    JVMTI_PRIMITIVE_TYPE_SHORT	    83	    'S' - Java programming language short   - JNI jshort
    JVMTI_PRIMITIVE_TYPE_INT	    73	    'I' - Java programming language int     - JNI jint
    JVMTI_PRIMITIVE_TYPE_LONG	    74	    'J' - Java programming language long    - JNI jlong
    JVMTI_PRIMITIVE_TYPE_FLOAT	    70	    'F' - Java programming language float   - JNI jfloat
    JVMTI_PRIMITIVE_TYPE_DOUBLE	    68	    'D' - Java programming language double  - JNI jdouble

对于`JVMTI_HEAP_REFERENCE_FIELD`和`JVMTI_HEAP_REFERENCE_STATIC_FIELD`类型的引用，有如下结构：

    ```c
    typedef struct {
        jint index;
    } jvmtiHeapReferenceInfoField;
    ```

对于`JVMTI_HEAP_REFERENCE_FIELD`类型的引用来说，引用对象不是类或接口，此时`index`的值是目标属性在引用对象中的索引位置。

对于`JVMTI_HEAP_REFERENCE_STATIC_FIELD`类型的引用来说，引用对象是类(下文中，称该类为`C`)或接口(下文中，称该类为`I`)，此时`index`的值是目标属性在类或接口中的索引位置。

如果引用对象不是接口，则属性索引值由以下规则决定：

1. 列出`C`及其父类的所有属性
1. 按顺序排序所有属性，顺序由函数`GetClassFields`指定
1. 给属性按顺序赋值，值分别为`n` `n+1`...，其中`n`为`C`的所有接口中的属性的个数

如果引用对象是接口，则属性索引值由以下规则决定：

1. 列出`I`直接声明的所有属性
1. 按顺序排序所有属性，顺序由函数`GetClassFields`指定
1. 给属性按顺序赋值，值分别为`n` `n+1`...，其中`n`为`I`的所有父接口中的属性的个数

通过上述两种规则，就可以将所有种类的属性都包含进来了(static, public, private, 等等)。

示例：

    ```java
    interface I0 {
        int p = 0;
    }

    interface I1 extends I0 {
        int x = 1;
    }

    interface I2 extends I0 {
        int y = 2;
    }

    class C1 implements I1 {
        public static int a = 3;
        private int b = 4;
    }

    class C2 extends C1 implements I2 {
        static int q = 5;
        final int r = 6;
    }
    ```

假设在`C1`上调用函数`GetClassFields`，返回`C1`的属性顺序为`a,b`，在`C2`上调用函数`GetClassFields`，返回`C1`的属性顺序为`q,q`。

类`C1`实例中属性的索引值为：

    field   index   desc
    a	    2	    C1实现的接口中包含了两个属性，I0中的p和I1中的x，因此n=2
    b	    3	    从n=2开始，顺次排序，因此为3

类`C1`具有相同的属性索引值。

类`C2`实例中属性的索引值为：

    field   index   desc
    a	    3	    C2实现的接口中包含了两个属性，I0中的p、I1中的x和I2中的y，因此n=3，注意，I0中的p只会计算一次
    b	    4	    从n=3开始，顺次排序，因此为4
    q	    5	    从n=3开始，顺次排序，因此为5
    r	    6	    从n=3开始，顺次排序，因此为6

类`C2`具有相同的属性索引值。注意，属性的索引值取决于从哪个对象来观察他，例如，上面示例中的属性`a`。此外，并非所有的属性索引值都能在回调中得到，但所有的属性索引值都是为了展示使用的。

接口`I1`的属性索引为：

    field   index   desc
    x	    1	    I1的父接口中属性的个数为1，即I0中的p

对于`JVMTI_HEAP_REFERENCE_ARRAY_ELEMENT`类型的引用，有如下结构：

    ```c
    typedef struct {
        jint index;
    } jvmtiHeapReferenceInfoArray;
    ```

其中，`index`的值为目标元素在数组中的索引位置。

对于`JVMTI_HEAP_REFERENCE_CONSTANT_POOL`类型的引用，有如下结构：

    ```c
    typedef struct {
        jint index;
    } jvmtiHeapReferenceInfoConstantPool;
    ```

其中，`index`的值为目标在类的常量池中的索引位置。

对于`JVMTI_HEAP_REFERENCE_STACK_LOCAL`类型的引用，有如下结构：

    ```c
    typedef struct {
        jlong thread_tag;
        jlong thread_id;
        jint depth;
        jmethodID method;
        jlocation location;
        jint slot;
    } jvmtiHeapReferenceInfoStackLocal;
    ```

属性说明如下：

    jvmtiHeapReferenceInfoStackLocal - Reference information structure for Local Variable references
    Field	        Type	    Description
    thread_tag	    jlong	    与目标栈关联的线程的标签，若没有标签，则为0
    thread_id	    jlong	    与目标栈关联的线程的唯一ID
    depth	        jint	    目标栈的栈帧深度
    method	        jmethodID	当前栈帧所执行的方法的ID
    location	    jlocation	当前栈帧的执行位置
    slot	        jint	    局部变量的槽的数量

对于`JVMTI_HEAP_REFERENCE_JNI_LOCAL`类型的引用，有如下结构：

    ```c
    typedef struct {
        jlong thread_tag;
        jlong thread_id;
        jint depth;
        jmethodID method;
    } jvmtiHeapReferenceInfoJniLocal;
    ```

属性说明如下：

    jvmtiHeapReferenceInfoJniLocal - Reference information structure for JNI local references
    Field	    Type	    Description
    thread_tag	jlong	    与目标栈关联的线程的标签，若没有标签，则为0
    thread_id	jlong	    与目标栈关联的线程的唯一ID
    depth	    jint	    目标栈的栈帧深度
    method	    jmethodID	当前栈帧所执行的方法的ID

对于`JVMTI_HEAP_REFERENCE_OTHER`类型的引用，有如下结构：

    ```c
    typedef struct {
        jlong reserved1;
        jlong reserved2;
        jlong reserved3;
        jlong reserved4;
        jlong reserved5;
        jlong reserved6;
        jlong reserved7;
        jlong reserved8;
    } jvmtiHeapReferenceInfoReserved;
    ```

属性说明如下：

    jvmtiHeapReferenceInfoReserved - Reference information structure for Other references
    Field	    Type	Description
    reserved1	jlong	reserved for future use.
    reserved2	jlong	reserved for future use.
    reserved3	jlong	reserved for future use.
    reserved4	jlong	reserved for future use.
    reserved5	jlong	reserved for future use.
    reserved6	jlong	reserved for future use.
    reserved7	jlong	reserved for future use.
    reserved8	jlong	reserved for future use.

引用信息的数据结构是一个联合体，包含了各种类型的引用，如下所示：

    ```c
    typedef union {
        jvmtiHeapReferenceInfoField field;
        jvmtiHeapReferenceInfoArray array;
        jvmtiHeapReferenceInfoConstantPool constant_pool;
        jvmtiHeapReferenceInfoStackLocal stack_local;
        jvmtiHeapReferenceInfoJniLocal jni_local;
        jvmtiHeapReferenceInfoReserved other;
    } jvmtiHeapReferenceInfo;
    ```

属性说明如下：

    jvmtiHeapReferenceInfo - Reference information structure
    Field	        Type	                            Description
    field	        jvmtiHeapReferenceInfoField	        引用类型是JVMTI_HEAP_REFERENCE_FIELD和JVMTI_HEAP_REFERENCE_STATIC_FIELD
    array	        jvmtiHeapReferenceInfoArray	        引用类型是JVMTI_HEAP_REFERENCE_ARRAY_ELEMENT
    constant_pool	jvmtiHeapReferenceInfoConstantPool	引用类型是JVMTI_HEAP_REFERENCE_CONSTANT_POOL
    stack_local	    jvmtiHeapReferenceInfoStackLocal	引用类型是JVMTI_HEAP_REFERENCE_STACK_LOCAL
    jni_local	    jvmtiHeapReferenceInfoJniLocal	    引用类型是JVMTI_HEAP_REFERENCE_JNI_LOCAL
    other	        jvmtiHeapReferenceInfoReserved	    引用类型是为将来预留的

堆回调函数结构体，如下所示：

    ```c
    typedef struct {
        jvmtiHeapIterationCallback heap_iteration_callback;
        jvmtiHeapReferenceCallback heap_reference_callback;
        jvmtiPrimitiveFieldCallback primitive_field_callback;
        jvmtiArrayPrimitiveValueCallback array_primitive_value_callback;
        jvmtiStringPrimitiveValueCallback string_primitive_value_callback;
        jvmtiReservedCallback reserved5;
        jvmtiReservedCallback reserved6;
        jvmtiReservedCallback reserved7;
        jvmtiReservedCallback reserved8;
        jvmtiReservedCallback reserved9;
        jvmtiReservedCallback reserved10;
        jvmtiReservedCallback reserved11;
        jvmtiReservedCallback reserved12;
        jvmtiReservedCallback reserved13;
        jvmtiReservedCallback reserved14;
        jvmtiReservedCallback reserved15;
    } jvmtiHeapCallbacks;
    ```

具体说明如下：

            jvmtiHeapCallbacks - Heap callback function structure
    Field	                            Type	                            Description
    heap_iteration_callback	            jvmtiHeapIterationCallback	        该回调函数用于获取堆中对象的描述信息，由函数IterateThroughHeap使用，但会被函数FollowReferences忽略
    heap_reference_callback	            jvmtiHeapReferenceCallback	        该回调函数用于获取堆中对象的描述信息，由函数FollowReferences使用，但会被函数IterateThroughHeap忽略
    primitive_field_callback	        jvmtiPrimitiveFieldCallback	        该回调函数用于获取原生类型属性的描述信息
    array_primitive_value_callback	    jvmtiArrayPrimitiveValueCallback	该回调函数用于获取原生类型数组的描述信息
    string_primitive_value_callback	    jvmtiStringPrimitiveValueCallback	该回调函数用于获取字符串数据的描述信息
    reserved5	                        jvmtiReservedCallback	            为将来预留
    reserved6	                        jvmtiReservedCallback	            为将来预留
    reserved7	                        jvmtiReservedCallback	            为将来预留
    reserved8	                        jvmtiReservedCallback	            为将来预留
    reserved9	                        jvmtiReservedCallback	            为将来预留
    reserved10	                        jvmtiReservedCallback	            为将来预留
    reserved11	                        jvmtiReservedCallback	            为将来预留
    reserved12	                        jvmtiReservedCallback	            为将来预留
    reserved13	                        jvmtiReservedCallback	            为将来预留
    reserved14	                        jvmtiReservedCallback	            为将来预留
    reserved15	                        jvmtiReservedCallback	            为将来预留

注意，堆转储功能会对每个对象使用回调函数。尽管使用缓冲的方式进行处理看起来吞吐量更高一些，但实际测试的结果并不是这样，可能是由于内存引用的局部性或数组访问的开销而导致的。

<a name="2.6.6.1"></a>
#### 2.6.6.1 jvmtiHeapIterationCallback

    ```c
    typedef jint (JNICALL *jvmtiHeapIterationCallback)(jlong class_tag, jlong size, jlong* tag_ptr, jint length, void* user_data);
    ```

为JVMTI代理提供的回调函数，用于获取堆中对象的描述信息，但并不是传入对象。

该回调函数应该返回一个包含了访问控制标记(visit control flags)的位向量，这个值将决定了整个迭代过程是否中止，`JVMTI_VISIT_OBJECTS`标记会被忽略。

参见堆回调函数限制。

参数信息如下：

    Name	        Type	Description
    class_tag	    jlong	对象的类的标签，若没有标签，则为0。若对象是一个运行时类，则该参数的值与`java.lang.Class`的标签相同，若没有标签，则为0
    size	        jlong	对象大小，单位是字节。参见函数GetObjectSize
    tag_ptr	        jlong*	对象标签的值的指针，若没有标签，则为0。JVMTI可以对该指针指向的内容赋值，从而完成对对象标签的赋值
    length	        jint	若当前对象是数组，则该值为数组的长度；否则为-1
    user_data	    void*	传入到迭代函数中的、用户提供的数据

<a name="2.6.6.2"></a>
#### 2.6.6.2 jvmtiHeapReferenceCallback

    ```c
    typedef jint (JNICALL *jvmtiHeapReferenceCallback)(jvmtiHeapReferenceKind reference_kind, const jvmtiHeapReferenceInfo* reference_info, jlong class_tag, jlong referrer_class_tag, jlong size, jlong* tag_ptr, jlong* referrer_tag_ptr, jint length, void* user_data);
    ```

为JVMTI代理提供的回调函数，用于获取引用的描述信息，引用关系是从一个对象或JVM指向另一个对象，或者是堆的跟指向某个对象。

该回调函数应该返回一个包含了访问控制标记(visit control flags)的位向量，这个值将决定了被引用的对象是否要被访问，或者整个迭代是否要中止。

参见堆回调函数限制。

参数信息如下：

    Name	            Type	                            Description
    reference_kind	    jvmtiHeapReferenceKind	            引用类型
    reference_info      const jvmtiHeapReferenceInfo *      引用详细信息。当参数reference_kind的值为JVMTI_HEAP_REFERENCE_FIELD, JVMTI_HEAP_REFERENCE_STATIC_FIELD, JVMTI_HEAP_REFERENCE_ARRAY_ELEMENT, JVMTI_HEAP_REFERENCE_CONSTANT_POOL, JVMTI_HEAP_REFERENCE_STACK_LOCAL, 或JVMTI_HEAP_REFERENCE_JNI_LOCAL时，会设置该值；否则为NULL
    class_tag	        jlong	                            被引用对象的类的标签，若没有标签，则为0。若被引用对象是一个运行时类，则该参数的值与`java.lang.Class`的标签相同，若没有标签，则为0
    referrer_class_tag  jlong                               引用对象的类的标签，若没有标签，则为0。若引用对象是一个运行时类，则该参数的值与`java.lang.Class`的标签相同，若没有标签，则为0
    size                jlong                               被引用对象的大小，单位为字节，参见函数GetObjectSize
    tag_ptr             jlong*                              指向被引用对象标签值的指针。JVMTI代理可以对该指针指向的值进行赋值，从而完成对对象标签的赋值
    referrer_tag_ptr    jlong*                              指向引用对象标签值的指针。JVMTI代理可以对该指针指向的值进行赋值，从而完成对对象标签的赋值
    length              jint                                若当前对象是数组，则该值为数组的长度；否则为-1
    user_data	        void*	                            传入到迭代函数中的、用户提供的数据

<a name="2.6.6.3"></a>
#### 2.6.6.3 jvmtiPrimitiveFieldCallback

    ```c
    typedef jint (JNICALL *jvmtiPrimitiveFieldCallback)(jvmtiHeapReferenceKind kind, const jvmtiHeapReferenceInfo* info, jlong object_class_tag, jlong* object_tag_ptr, jvalue value, jvmtiPrimitiveType value_type, void* user_data);
    ```

为JVMTI代理提供的回调函数，用于获取对象的原生类型属性的描述信息。若当前对象是类对象，则该回调函数得到的是静态属性，否则为实例属性。

该回调函数应该返回一个包含了访问控制标记(visit control flags)的位向量，这个值将决定了整个迭代是否要中止，`JVMTI_VISIT_OBJECTS`标记会被忽略。

参见堆回调函数限制。

参数信息如下：

    Name	            Type	                            Description
    kind	            jvmtiHeapReferenceKind	            属性类型，静态属性或实例属性，即JVMTI_HEAP_REFERENCE_FIELD或JVMTI_HEAP_REFERENCE_STATIC_FIELD.
    info	            const jvmtiHeapReferenceInfo *	    目标属性信息
    object_class_tag	jlong	                            目标对象的类的标签，若没有标签，则为0。若被引用对象是一个运行时类，则该参数的值与`java.lang.Class`的标签相同，若没有标签，则为0
    object_tag_ptr	    jlong*	                            指向对象标签值的指针，若没有标签，则为0。JVMTI代理可以对该指针指向的值进行赋值，从而完成对对象标签的赋值
    value	            jvalue	                            目标属性的值
    value_type	        jvmtiPrimitiveType	                目标属性的类型
    user_data	        void*	                            传入到迭代函数中的、用户提供的数据

<a name="2.6.6.4"></a>
#### 2.6.6.4 jvmtiArrayPrimitiveValueCallback

    ```c
    typedef jint (JNICALL *jvmtiArrayPrimitiveValueCallback)(jlong class_tag, jlong size, jlong* tag_ptr, jint element_count, jvmtiPrimitiveType element_type, const void* elements, void* user_data);
    ```

为JVMTI代理提供的回调函数，用于获取原生类型数组中某个元素的描述信息。

该回调函数应该返回一个包含了访问控制标记(visit control flags)的位向量，这个值将决定了整个迭代是否要中止，`JVMTI_VISIT_OBJECTS`标记会被忽略。

参见堆回调函数限制。

参数信息如下：

    Name	        Type	                Description
    class_tag	    jlong	                目标对象的类的标签，若没有标签，则为0。
    size	        jlong	                数组对象的大小，单位为字节，参见函数GetObjectSize
    tag_ptr	        jlong*	                指向数组对象的标签值的指针，若没有标签，则为0。JVMTI代理可以对该指针指向的值进行赋值，从而完成对对象标签的赋值
    element_count	jint	                数组的长度
    element_type	jvmtiPrimitiveType	    数组元素的类型
    elements	    const void*	            数组中的元素
    user_data	    void*	                传入到迭代函数中的、用户提供的数据

<a name="2.6.6.5"></a>
#### 2.6.6.5 jvmtiStringPrimitiveValueCallback

    ```c
    typedef jint (JNICALL *jvmtiStringPrimitiveValueCallback)(jlong class_tag, jlong size, jlong* tag_ptr, const jchar* value, jint value_length, void* user_data);
    ```

为JVMTI代理提供的回调函数，用于获取字符串数据(`java.lang.String`)的描述信息。

该回调函数应该返回一个包含了访问控制标记(visit control flags)的位向量，这个值将决定了整个迭代是否要中止，`JVMTI_VISIT_OBJECTS`标记会被忽略。

参见堆回调函数限制。

参数信息如下：

    Name	        Type	        Description
    class_tag	    jlong	        目标对象的类的标签，若没有标签，则为0。
    size	        jlong	        字符串对象的大小，单位为字节，参见函数GetObjectSize
    tag_ptr	        jlong*	        指向数组对象的标签值的指针，若没有标签，则为0。JVMTI代理可以对该指针指向的值进行赋值，从而完成对对象标签的赋值
    value	        const jchar*	字符串的内容，使用Unicode编码
    value_length	jint	        字符串的长度，该值等于字符串中16位Unicode字符的数量
    user_data	    void*	        传入到迭代函数中的、用户提供的数据

<a name="2.6.6.6"></a>
#### 2.6.6.6 jvmtiReservedCallback

    ```c
    typedef jint (JNICALL *jvmtiReservedCallback)();
    ```

为将来预留。

<a name="2.6.6.7"></a>
#### 2.6.6.7 FollowReferences

    ```c
    jvmtiError FollowReferences(jvmtiEnv* env, jint heap_filter, jclass klass, jobject initial_object, const jvmtiHeapCallbacks* callbacks, const void* user_data)
    ```

该函数用于遍历堆中的对象，包括从指定对象或从堆的根集合(未指定参数`initial_object`时)中可访问的全部对象。堆的根集合包括系统类、JNI全局引用、线程栈中的引用和其他可用作垃圾回收根集合的对象。

假设`A`和`B`表示对象，当访问`A`指向`B`的引用时，或访问从堆的根集合指向`B`的引用时，或以`B`作为初始对象时，则称为`B`"被访问到"。对于从`A`指向`B`的引用，如果没有访问到`A`时，则也不会遍历`A`到`B`的引用。报告引用的顺序与遍历的顺序相同，报告的形式是调用回调函数`jvmtiHeapReferenceCallback`。在`A`到`B`的引用中，`A`被称为引用者，`B`被称为被引用者。每个引用者发出的引用只会触发一次回调，即使存在循环引用或多个指向引用者的路径，也只会回调一次。引用者和被引用者之间存在多条引用时，每条引用都会报告，报告时，回调函数`jvmtiHeapReferenceCallback`的参数`reference_kind`和`reference_info`的数值可能不尽相同。

该函数报告的对象引用时从Java语言的角度来看的，而非JVM的角度。当下面的这些引用非空时，会进行报告：

* 实例对象会报告其指向每个非原生类型属性的引用，包括继承得来的属性
* 实例对象会报告其指向类对象的引用
* 类对象会报告其指向父类和直接实现/继承的接口的引用
* 类对象会报告其指向类载入器，保护域(protection domain)，签字信息和常量池中已解析的常量项的引用
* 类对象会报告其指向每个直接声明的非原生类型的静态属性的引用
* 数组会报告其指向数组类型和每个数组元素的引用
* 原生类型数组会报告其指向数组类型的引用

该函数还可用于检查原生类型的值。原生类型数组或字符串会在访问对象后加以报告，报告的形式是调用回调函数`jvmtiArrayPrimitiveValueCallback`或`jvmtiStringPrimitiveValueCallback`。原生类型的属性，则会在访问对象后，通过回调函数`jvmtiPrimitiveFieldCallback`来报告。

JVMTI代理是否提供回调函数的实现，只决定了回调函数是否被调用，并不会影响对象遍历，及相应回调函数的调用。但是，`jvmtiHeapReferenceCallback`返回的访问控制标记却会决定当前对象引用的对象是否要被访问。堆过滤器标记(heap filter flags)和参数`klass`不会控制哪个对象要被访问，但会控制哪个对象和原生数据会以回调函数的形式来报告。例如，如果只设置了回调函数`array_primitive_value_callback`，并且参数`klass`设置为字节数组类型，则只会报告字节数组。总结如下：

	                                                                        Controls objects visited	    Controls objects reported	            Controls primitives reported
    the Heap Visit Control Flags returned by jvmtiHeapReferenceCallback     Yes	                            Yes, since visits are controlled	    Yes, since visits are controlled
    array_primitive_value_callback	                                        No	                            Yes	                                    No
    heap filter                                                             No	                            Yes	                                    Yes
    klass	                                                                No	                            Yes	                                    Yes

在执行该函数的过程中，堆的状态不会更改：不会新分配对象，不会执行垃圾回收，对象的状态也不会发生改变。其结果是，正在执行Java代码的线程，试图恢复Java代码运行的线程，和试图恢复执行JNI函数的线程，都会暂停。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 115
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_tag_objects`: 能够获取/设置对象标签
* 参数：
    * `heap_filter`: 
        * 类型为`jint`，表示堆过滤器标记位向量，用于限制针对哪些对象会调用回调函数
        * 该参数对对象和原生类型的回调函数都生效
    * `klass`: 
        * 类型为`jclass`
        * 回调函数只会报告由该参数指定的类型的实例。该类型的子类型的实例对象不会被报告。如果`klass`是一个接口，则不会报告任何对象
        * 该参数对对象和原生类型的回调函数都生效
        * 若参数值为`NULL`，则回调函数不会受限于某个具体类型
    * `initial_object`:
        * 类型为`jobject`，表示从指定的对象开始遍历堆中的对象
        * 若为`NULL`，则从堆的根集合开始遍历
    * `callbacks`:
        * 类型为`const jvmtiHeapCallbacks *`，表示目标回调函数，JVMTI代理需要提供一个回调函数的指针
    * `user_data`:
        * 类型为`const void *`，用户提供的、回传给回调函数的数据
        * JVMTI代理提供一个指向数据内容的指针，若为`NULL`，则会将`NULL`传给回调函数
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_tag_objects`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`不是有效的类对象
    * `JVMTI_ERROR_INVALID_OBJECT`: 参数`initial_object`不是有效的对象
    * `JVMTI_ERROR_NULL_POINTER`: 参数`callbacks`为`NULL`

<a name="2.6.6.8"></a>
#### 2.6.6.8 IterateThroughHeap

    ```c
    jvmtiError IterateThroughHeap(jvmtiEnv* env, jint heap_filter, jclass klass, const jvmtiHeapCallbacks* callbacks, const void* user_data)
    ```

初始化迭代，遍历堆中所有对象，包括可达对象和不可达对象。遍历对象时，是无序的。

遍历堆中对象时，会以回调函数`jvmtiHeapIterationCallback`的形式来报告。对象前的引用信息不会报告。如果只想遍历可达对象，或者需要获取对象引用信息，则需要使用函数`FollowReferences`。

该函数还可用于检查原生类型的值。原生类型数组或字符串会在访问对象后加以报告，报告的形式是调用回调函数`jvmtiArrayPrimitiveValueCallback`或`jvmtiStringPrimitiveValueCallback`。原生类型的属性，则会在访问对象后，通过回调函数`jvmtiPrimitiveFieldCallback`来报告。

使用该函数后，堆中所有的对象都会被访问到，除非是在回调函数中返回的访问控制标记指明了要终止迭代。无论JVMTI代理是否提供了回调函数的实现，只会决定该回调函数是否会被调用，而不会影响遍历哪些对象和这些对象的回调函数的调用。堆过滤器标记和`klass`参数并不会控制哪些对象会被遍历，他们只会控制哪些对象和原生类型数据是否会触发回调函数。例如，如果JVMTI代理提供了回调函数`array_primitive_value_callback`的实现，并且参数`klass`设置为字节数组类型，则只会报告字节数组。总结如下：

                                                                            Controls objects visited	            Controls objects reported	            Controls primitives reported
    the Heap Visit Control Flags returned by jvmtiHeapIterationCallback	    No(unless they abort the iteration)	    No(unless they abort the iteration)	    No(unless they abort the iteration)
    array_primitive_value_callback in callbacks set	                        No	                                    Yes	                                    No
    heap_filter	                                                            No	                                    Yes	                                    Yes
    klass	                                                                No	                                    Yes	                                    Yes

在执行该函数的过程中，堆的状态不会更改：不会新分配对象，不会执行垃圾回收，对象的状态也不会发生改变。其结果是，正在执行Java代码的线程，试图恢复Java代码运行的线程，和试图恢复执行JNI函数的线程，都会暂停。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 116
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_tag_objects`: 能够获取/设置对象标签
* 参数：
    * `heap_filter`: 
        * 类型为`jint`，表示堆过滤器标记位向量，用于限制针对哪些对象会调用回调函数
        * 该参数对对象和原生类型的回调函数都生效
    * `klass`: 
        * 类型为`jclass`
        * 回调函数只会报告由该参数指定的类型的实例。该类型的子类型的实例对象不会被报告。如果`klass`是一个接口，则不会报告任何对象
        * 该参数对对象和原生类型的回调函数都生效
        * 若参数值为`NULL`，则回调函数不会受限于某个具体类型
    * `callbacks`:
        * 类型为`const jvmtiHeapCallbacks *`，表示目标回调函数，JVMTI代理需要提供一个回调函数的指针
    * `user_data`:
        * 类型为`const void *`，用户提供的、回传给回调函数的数据
        * JVMTI代理提供一个指向数据内容的指针，若为`NULL`，则会将`NULL`传给回调函数
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_tag_objects`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`不是有效的类对象
    * `JVMTI_ERROR_NULL_POINTER`: 参数`callbacks`为`NULL`

<a name="2.6.6.9"></a>
#### 2.6.6.9 GetTag

    ```c
    jvmtiError GetTag(jvmtiEnv* env, jobject object, jlong* tag_ptr)
    ```

该函数用于获取目标对象的标签。标签的值是一个长整型，一般用于存储一个唯一的ID值或是指向对象信息的指针。设置标签值可以通过方法`SetTag`完成。若对象没有标签，则标签值为0。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 106
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_tag_objects`: 能够获取/设置对象标签
* 参数：
    * `object`: 
        * 类型为`jobject`，目标对象
    * `tag_ptr`: 
        * 类型为`jlong*`，出参，指向标签的值
        * JVMTI代理提供一个指向`jlong`的指针，函数返回时，会设置该指针指向的值。
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_tag_objects`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_OBJECT`: 参数`object`不是有效的对象
    * `JVMTI_ERROR_NULL_POINTER`: 参数`tag_ptr`为`NULL`

<a name="2.6.6.10"></a>
#### 2.6.6.10 SetTag

    ```c
    jvmtiError SetTag(jvmtiEnv* env, jobject object, jlong tag)
    ```

该函数用于设置对象的标签。标签值是一个长整数，一般用于存储一个唯一的ID值或是指向对象信息的指针。获取标签值可以通过方法`GetTag`完成。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 107
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_tag_objects`: 能够获取/设置对象标签
* 参数：
    * `object`: 
        * 类型为`jobject`，目标对象
    * `tag`: 
        * 类型为`jlong`，要设置的标签值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_tag_objects`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_OBJECT`: 参数`object`不是有效的对象

<a name="2.6.6.11"></a>
#### 2.6.6.11 GetObjectsWithTags

    ```c
    jvmtiError GetObjectsWithTags(jvmtiEnv* env, jint tag_count, const jlong* tags, jint* count_ptr, jobject** object_result_ptr, jlong** tag_result_ptr)
    ```

该函数用于返回堆中带有指定标签的对象。返回的内容中，对象和标签的位置在出参数组中是一一对应的。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 114
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_tag_objects`: 能够获取/设置对象标签
* 参数：
    * `tag_count`: 
        * 类型为`jint`，要扫描的标签的数量
    * `tags`: 
        * 类型为`const jlong *`，要扫描的标签的值，此时，标签值不能为0
        * JVMTI代理需要提供一个长度为`tag_count`的`jlong`数组
    * `count_ptr`:
        * 类型为`jint *`，出参，返回扫描出的符合结果对象的数量
        * JVMTI代理需要提供一个指向`jint`的指针，函数返回时，会设置该值
    * `object_result_ptr`:
        * 类型为`jobject **`，出参，返回扫描出的符合结果对象
        * JVMTI代理需要提供一个指向`jobject*`的指针，函数返回时，会创建一个长度为`*count_ptr`的数组，并在数组中填充对象指针。新创建的数组需要使用函数`Deallocate`来释放。若`object_result_ptr`为`NULL`，则不会返回该信息。数组返回的对象是JNI局部引用，必须管理起来。
    * `tag_result_ptr`:
        * 类型为`jlong **`，出参，返回`object_result_ptr`中的每个对象的标签值，索引位置一一对应
        * JVMTI代理需要提供一个指向`jlong*`的指针，函数返回时，会创建一个长度为`*count_ptr`的数组。新创建的数组需要使用函数`Deallocate`来释放。若`tag_result_ptr`为`NULL`，则不会返回该信息。数组返回的对象是JNI局部引用，必须管理起来。
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_tag_objects`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_OBJECT`: 参数`object`不是有效的对象
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`tags`中包含0
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`tag_count`小于0
    * `JVMTI_ERROR_NULL_POINTER`: 参数`tags`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`countr_ptr`为`NULL`

<a name="2.6.6.12"></a>
#### 2.6.6.12 ForceGarbageCollection

    ```c
    jvmtiError ForceGarbageCollection(jvmtiEnv* env)
    ```

该函数用于强制执行垃圾回收。垃圾回收会尽可能完整。需要注意的是，该函数并不会触发**finalizer**运行。在垃圾回收结束前，该函数都不会返回。

垃圾回收会尽可能完整，但并不能保证所有的`ObjectEvent`事件都会在该函数返回时发出。特别的，某个对象可能正在等待执行**finalization**，因而无法被回收掉。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 108
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * 无
* 返回：
    * 无

<a name="2.6.7"></a>
### 2.6.7 堆1.0

堆1.0的相关函数包括：

* [2.6.7.5 IterateOverObjectsReachableFromObject][119]
* [2.6.7.6 IterateOverReachableObjects][120]
* [2.6.7.7 IterateOverHeap][121]
* [2.6.7.8 IterateOverInstancesOfClass][122]

堆1.0的回调函数包括：

* [2.6.7.1 jvmtiHeapObjectCallback][115]
* [2.6.7.2 jvmtiHeapRootCallback][116]
* [2.6.7.3 jvmtiStackReferenceCallback][117]
* [2.6.7.4 jvmtiObjectReferenceCallback][118]

堆1.0的类型包括：

* [jvmtiHeapObjectFilter - Heap Object Filter Enumeration][]
* [jvmtiHeapRootKind - Heap Root Kind Enumeration][]
* [jvmtiObjectReferenceKind - Object Reference Enumeration][]
* [jvmtiIterationControl - Iteration Control Enumeration][115]

这些函数和数据类型是在JVMTI 1.0版本中引入的，现在已经被功能更强，更灵活的版本取代：

* 允许访问原生数据，包括字符串、数组和原生类型的属性
* 运行设置引用对象的标签值，增强了构建引用图的效率
* 提供了更强的过滤能力
* 扩展性更好，更能适应将来新版本JVMTI的功能

请尽量使用当前版本的[堆函数][33]。

            Heap Object Filter Enumeration (jvmtiHeapObjectFilter)
    Constant	                Value	Description
    JVMTI_HEAP_OBJECT_TAGGED	1	    只处理被标记的对象
    JVMTI_HEAP_OBJECT_UNTAGGED	2	    只处理未被标记的对象
    JVMTI_HEAP_OBJECT_EITHER	3	    标记和未被标记的对象都要处理


            Heap Root Kind Enumeration (jvmtiHeapRootKind)
    Constant	                    Value	Description
    JVMTI_HEAP_ROOT_JNI_GLOBAL	    1	    JNI全局引用
    JVMTI_HEAP_ROOT_SYSTEM_CLASS	2	    系统类
    JVMTI_HEAP_ROOT_MONITOR	        3	    监视器
    JVMTI_HEAP_ROOT_STACK_LOCAL	    4	    栈局部(stack local)
    JVMTI_HEAP_ROOT_JNI_LOCAL	    5	    JNI局部引用
    JVMTI_HEAP_ROOT_THREAD	        6	    线程
    JVMTI_HEAP_ROOT_OTHER	        7	    其他


            Object Reference Enumeration (jvmtiObjectReferenceKind)
    Constant	                        Value	Description
    JVMTI_REFERENCE_CLASS               1       从对象到其类对象的引用
    JVMTI_REFERENCE_FIELD               2       从对象到其成员变量值的引用。此时，回调函数jvmtiObjectReferenceCallback的参数referrer_index，表示成员变量的索引位置。这个索引位置是基于目标对象所有属性顺次排序的，包括在类中直接声明的静态变量、成员变量，以及从父类、父接口中继承来的静态变量和实例变量，private和public的都有。因此，计算索引位置的值时，会在父类、父接口的属性的索引值的基础上，再加上当前类中目标属性的声明顺序而得。索引位置从0开始。
    JVMTI_REFERENCE_ARRAY_ELEMENT       3       从数组对象指向其元素的引用。回调函数jvmtiObjectReferenceCallback的参数referrer_index，表示该元素的索引位置。
    JVMTI_REFERENCE_CLASS_LOADER        4       从类指向其类加载器的引用
    JVMTI_REFERENCE_SIGNERS             5       从类指向其签字信息数组的引用
    JVMTI_REFERENCE_PROTECTION_DOMAIN   6       从类指向其保护域的引用
    JVMTI_REFERENCE_INTERFACE           7       从类指向其某个接口的引用
    JVMTI_REFERENCE_STATIC_FIELD        8       从类指向其静态变量值的引用。此时，回调函数jvmtiObjectReferenceCallback的参数referrer_index，表示静态变量的索引位置。这个索引位置是基于目标对象所有属性顺次排序的，包括在类中直接声明的静态变量、成员变量，以及从父类、父接口中继承来的静态变量和实例变量，private和public的都有。因此，计算索引位置的值时，会在父类、父接口的属性的索引值的基础上，再加上当前类中目标属性的声明顺序而得。索引位置从0开始。注意，这个定义不同于JVMTI 1.0规范中的定义。
    JVMTI_REFERENCE_CONSTANT_POOL       9       从类对象实例指向常量池中某个已解析的条目的引用


            Iteration Control Enumeration (jvmtiIterationControl)
    Constant	                Value	Description
    JVMTI_ITERATION_CONTINUE	1	    继续迭代，若当前是一个引用迭代，则沿着引用指向的对象继续进行
    JVMTI_ITERATION_IGNORE	    2	    继续迭代，若当前是一个引用迭代，则忽略引用指向的对象
    JVMTI_ITERATION_ABORT	    0	    终止迭代

<a name="2.6.7.1"></a>
#### 2.6.7.1 jvmtiHeapObjectCallback

    ```c
    typedef jvmtiIterationControl (JNICALL *jvmtiHeapObjectCallback)(jlong class_tag, jlong size, jlong* tag_ptr, void* user_data);
    ```

该回调函数用于获取堆中对象的描述信息。

若要继续迭代，则应该返回`JVMTI_ITERATION_CONTINUE`，若要终止迭代，则返回`JVMTI_ITERATION_ABORT`。

参见堆回调函数限制。

                    Parameters
    Name	        Type	    Description
    class_tag	    jlong	    当前对象的类的标签，若没有标签，则为0。若当前对象是一个运行时类，则该值与java.lang.Class类的标签值相同，若没有标签，则为0。
    size	        jlong	    对象的大小，单位为字节，参见GetObjectSize.
    tag_ptr	        jlong*	    对象标签的值，若没有标签，则为0。通过该参数，可以设置对象标签的值。
    user_data	    void*	    用户提供的、会在迭代中传入的数据

<a name="2.6.7.2"></a>
#### 2.6.7.2 jvmtiHeapRootCallback

    ```c
    typedef jvmtiIterationControl (JNICALL *jvmtiHeapRootCallback)(jvmtiHeapRootKind root_kind, jlong class_tag, jlong size, jlong* tag_ptr, void* user_data);
    ```

该回调函数用于获取堆中根集合对象的描述信息。

若要继续迭代，则应该返回`JVMTI_ITERATION_CONTINUE`；若要继续迭代，但忽略引用所指向的对象，则应该返回`JVMTI_ITERATION_IGNORE`；若要终止迭代，则返回`JVMTI_ITERATION_ABORT`。

参见堆回调函数限制。

                    Parameters
    Name	        Type	                Description
    root_kind	    jvmtiHeapRootKind	    堆根集合的类型
    class_tag	    jlong	                当前对象的类的标签，若没有标签，则为0。若当前对象是一个运行时类，则该值与java.lang.Class类的标签值相同，若没有标签，则为0。
    size	        jlong	                对象的大小，单位为字节，参见GetObjectSize.
    tag_ptr	        jlong*	                对象标签的值，若没有标签，则为0。通过该参数，可以设置对象标签的值。
    user_data	    void*	                用户提供的、会在迭代中传入的数据

<a name="2.6.7.3"></a>
#### 2.6.7.3 jvmtiStackReferenceCallback

    ```c
    typedef jvmtiIterationControl (JNICALL *jvmtiStackReferenceCallback)(jvmtiHeapRootKind root_kind, jlong class_tag, jlong size, jlong* tag_ptr, jlong thread_tag, jint depth, jmethodID method, jint slot, void* user_data);
    ```

该回调函数用于获取栈中根集合对象的描述信息。

若要继续迭代，则应该返回`JVMTI_ITERATION_CONTINUE`；若要继续迭代，但忽略引用所指向的对象，则应该返回`JVMTI_ITERATION_IGNORE`；若要终止迭代，则返回`JVMTI_ITERATION_ABORT`。

参见堆回调函数限制。

                    Parameters
    Name	        Type	                Description
    root_kind	    jvmtiHeapRootKind	    堆根集合的类型
    class_tag	    jlong	                当前对象的类的标签，若没有标签，则为0。若当前对象是一个运行时类，则该值与java.lang.Class类的标签值相同，若没有标签，则为0。
    size	        jlong	                对象的大小，单位为字节，参见GetObjectSize
    tag_ptr	        jlong*	                对象标签的值，若没有标签，则为0。通过该参数，可以设置对象标签的值。
    thread_tag      jlong                   当前栈的线程的标签，若没有标签，则为0
    depth           jint                    栈帧的深度
    method          jmethodID               当前栈帧正在执行的方法的ID
    slot            jint                    当前栈帧的局部变量的槽的数量
    user_data	    void*	                用户提供的、会在迭代中传入的数据

<a name="2.6.7.4"></a>
#### 2.6.7.4 jvmtiObjectReferenceCallback

    ```c
    typedef jvmtiIterationControl (JNICALL *jvmtiObjectReferenceCallback)(jvmtiObjectReferenceKind reference_kind, jlong class_tag, jlong size, jlong* tag_ptr, jlong referrer_tag, jint referrer_index, void* user_data);
    ```

该回调函数用于获取堆中对象间引用的描述信息。

若要继续迭代，则应该返回`JVMTI_ITERATION_CONTINUE`；若要继续迭代，但忽略引用所指向的对象，则应该返回`JVMTI_ITERATION_IGNORE`；若要终止迭代，则返回`JVMTI_ITERATION_ABORT`。

参见堆回调函数限制。

                        Parameters
    Name	            Type	                    Description
    reference_kind	    jvmtiObjectReferenceKind	引用类型
    class_tag	        jlong	                    当前对象的类的标签，若没有标签，则为0。若当前对象是一个运行时类，则该值与java.lang.Class类的标签值相同，若没有标签，则为0。
    size	            jlong	                    对象的大小，单位为字节，参见GetObjectSize
    tag_ptr	            jlong*	                    对象标签的值，若没有标签，则为0。通过该参数，可以设置对象标签的值。
    referrer_tag        jlong                       引用对象的标签，若没有标签，则为0
    referrer_index      jint                        引用的索引值。
    user_data	        void*	                    用户提供的、会在迭代中传入的数据

<a name="2.6.7.5"></a>
#### 2.6.7.5 IterateOverObjectsReachableFromObject

    ```c
    jvmtiError IterateOverObjectsReachableFromObject(jvmtiEnv* env, jobject object, jvmtiObjectReferenceCallback object_reference_callback, const void* user_data)
    ```

该函数可用于遍历从指定对象开始的、所有的直接或间接可达对象。例如，对象`A`包含指向对象`B`的引用，遍历的时候会调用指定的回调函数，而且只会调用一次，即便包含循环引用或多条指向对象`A`的引用路径，对于`A`到`B`的引用，也只会触发一次回调函数。`A`到`B`的引用可能会有多种形式，此时参数`jvmtiObjectReferenceCallback.reference_kind`和`jvmtiObjectReferenceCallback.referrer_index`会不尽相同。对被引用对象的回调总是会在对引用对象的回调之后。

有关对象引用的内容，参见函数[`FollowReferences`][103]。

在执行该函数的过程中，堆的状态不会更改：不会新分配对象，不会执行垃圾回收，对象的状态也不会发生改变。其结果是，正在执行Java代码的线程，试图恢复Java代码运行的线程，和试图恢复执行JNI函数的线程，都会暂停。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 109
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_tag_objects`: 能够获取/设置对象标签
* 参数：
    * `object`: 
        * 类型为`jobject`，目标对象
    * `object_reference_callback`:
        * 类型为`jvmtiObjectReferenceCallback`， 回调函数
    * `user_data`:
        * 类型为`const void *`，迭代过程中要传递的用户数据
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_tag_objects`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_OBJECT`: 参数`object`不是有效的对象
    * `JVMTI_ERROR_NULL_POINTER`: 参数`object_reference_callback`为`NULL`

<a name="2.6.7.6"></a>
#### 2.6.7.6 IterateOverReachableObjects

    ```c
    jvmtiError IterateOverReachableObjects(jvmtiEnv* env, jvmtiHeapRootCallback heap_root_callback, jvmtiStackReferenceCallback stack_ref_callback, jvmtiObjectReferenceCallback object_ref_callback, const void* user_data)
    ```

该函数用于遍历所有从根集合开始可到的对象。根集合包含系统类、JNI全局引用、线程栈和其他作为垃圾回收根起点的对象。

对于每个根对象，都会触发回调函数`heap_root_callback`或`stack_ref_callback`。某个对象可能会因为各种原因而成为根对象，并调用对应的回调函数。

对于每个对象引用，回调函数`object_ref_callback`都会被调用，并且只会被调用一次，几遍存在循环引用或多种引用路径，也是如此。在引用对象和被引用对象之间，可能存在多种引用关系，可以通过`jvmtiObjectReferenceCallback.reference_kind`或`jvmtiObjectReferenceCallback.referrer_index`的值来判断。回调函数的触发，只会发生在其引用对象的回调函数触发之后。

更多有关对象引用的内容，参见函数`FollowReferences`。

在报告对象引用之前，根已经报告给分析器了。换句话说，回调函数`object_ref_callback`会在所有的根对象的回调函数完成之后才触发。如果回调函数`object_ref_callback`为`NULL`，则在将根对象报告分析器后，该函数返回。

在执行该函数的过程中，堆的状态不会更改：不会新分配对象，不会执行垃圾回收，对象的状态也不会发生改变。其结果是，正在执行Java代码的线程，试图恢复Java代码运行的线程，和试图恢复执行JNI函数的线程，都会暂停。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 110
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_tag_objects`: 能够获取/设置对象标签
* 参数：
    * `heap_root_callback`: 
        * 类型为`jvmtiHeapRootCallback`
        * 该回调函数用于报告所有指定类型的根对象，类型包括，`JVMTI_HEAP_ROOT_JNI_GLOBAL` `JVMTI_HEAP_ROOT_SYSTEM_CLASS` `JVMTI_HEAP_ROOT_MONITOR` `JVMTI_HEAP_ROOT_THREAD` `JVMTI_HEAP_ROOT_OTHER`
        * 若为`NULL`，则不会报告根对象
    * `stack_ref_callback`:
        * 类型为`jvmtiStackReferenceCallback`
        * 该回调函数用于报告所有指定类型的根对象，类型包括，`JVMTI_HEAP_ROOT_STACK_LOCAL` `JVMTI_HEAP_ROOT_JNI_LOCAL`
        * 若为`NULL`，则不会报告栈引用
    * `object_ref_callback`:
        * 类型为`jvmtiObjectReferenceCallback`
        * 该函数用于报告每个对象间引用
        * 若为`NULL`，则不会报告来自根对象的引用
    * `user_data`:
        * 类型为`const void *`，迭代过程中要传递的用户数据
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_tag_objects`，需要调用`AddCapabilities`

<a name="2.6.7.7"></a>
#### 2.6.7.7 IterateOverHeap

    ```c
    jvmtiError IterateOverHeap(jvmtiEnv* env, jvmtiHeapObjectFilter object_filter, jvmtiHeapObjectCallback heap_object_callback, const void* user_data)
    ```

该函数用于遍历堆中所有对象，包括可达和不可达的。

参数`object_filter`用于指定需要对哪些对象执行回调函数，若该参数的值为`JVMTI_HEAP_OBJECT_TAGGED`，则只会针对有标签的对象执行回调函数；若该参数的值为`JVMTI_HEAP_OBJECT_UNTAGGED`，则只会针对没有标签的对象执行回调函数；若该参数的值为`JVMTI_HEAP_OBJECT_EITHER`，则会对所有对象执行回调函数.

在执行该函数的过程中，堆的状态不会更改：不会新分配对象，不会执行垃圾回收，对象的状态也不会发生改变。其结果是，正在执行Java代码的线程，试图恢复Java代码运行的线程，和试图恢复执行JNI函数的线程，都会暂停。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 111
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_tag_objects`: 能够获取/设置对象标签
* 参数：
    * `object_filter`: 
        * 类型为`jvmtiHeapObjectFilter`，指定需要对哪些对象执行回调函数
    * `heap_object_callback`:
        * 类型为`jvmtiHeapObjectCallback`，指定对于符合规则(`jvmtiHeapObjectFilter`)的对象要执行的回调函数
    * `user_data`:
        * 类型为`const void *`，迭代过程中要传递的用户数据
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_tag_objects`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`object_filter`不是`jvmtiHeapObjectFilter`类型
    * `JVMTI_ERROR_NULL_POINTER`: 参数`heap_object_callback `为`NULL`

<a name="2.6.7.8"></a>
#### 2.6.7.8 IterateOverInstancesOfClass

    ```c
    jvmtiError IterateOverInstancesOfClass(jvmtiEnv* env, jclass klass, jvmtiHeapObjectFilter object_filter, jvmtiHeapObjectCallback heap_object_callback, const void* user_data)
    ```

该函数用于遍历堆中所有指定类的实例对象，包括直接继承和间接继承的，包括可达和不可达的。

参数`object_filter`指定了哪些对象会调用回调函数，若该参数的值为`JVMTI_HEAP_OBJECT_TAGGED`，则只会针对有标签的对象执行回调函数；若该参数的值为`JVMTI_HEAP_OBJECT_UNTAGGED`，则只会针对没有标签的对象执行回调函数；若该参数的值为`JVMTI_HEAP_OBJECT_EITHER`，则会对所有对象执行回调函数.

在执行该函数的过程中，堆的状态不会更改：不会新分配对象，不会执行垃圾回收，对象的状态也不会发生改变。其结果是，正在执行Java代码的线程，试图恢复Java代码运行的线程，和试图恢复执行JNI函数的线程，都会暂停。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 112
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_tag_objects`: 能够获取/设置对象标签
* 参数：
    * `klass`: 
        * 类型为`jclass`，指定目标类型
    * `object_filter`:
        * 类型为`jvmtiHeapObjectFilter`，指定针对哪些对象触发回调函数
    * `heap_object_callback`:
        * 类型为`jvmtiHeapObjectCallback`，指定符合要求的对象要调用的回调函数
    * `user_data`:
        * 类型为`const void *`，迭代过程中要传递的用户数据
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_tag_objects`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`不是类对象
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`object_filter`不是`jvmtiHeapObjectFilter`类型
    * `JVMTI_ERROR_NULL_POINTER`: 参数`heap_object_callback `为`NULL`

<a name="2.6.8"></a>
### 2.6.8 局部变量

局部变量的相关函数包括：

* [2.6.8.1 GetLocalObject][123]
* [2.6.8.2 GetLocalInstance][124]
* [2.6.8.3 GetLocalInt][125]
* [2.6.8.4 GetLocalLong][126]
* [2.6.8.6 GetLocalDouble][127]
* [2.6.8.6 GetLocalDouble][128]
* [2.6.8.7 SetLocalObject][129]
* [2.6.8.8 SetLocalInt][130]
* [2.6.8.9 SetLocalLong][131]
* [2.6.8.10 SetLocalFloat][132]
* [2.6.8.11 SetLocalDouble][133]

这些函数用于获取/设置局部变量的值。局部变量是通过栈帧的深度和变量的槽值来定位的。通过函数`GetLocalVariableTable`可以获取变量操作。

<a name="2.6.8.1"></a>
#### 2.6.8.1 GetLocalObject

    ```c
    jvmtiError GetLocalObject(jvmtiEnv* env, jthread thread, jint depth, jint slot, jobject* value_ptr)
    ```

该函数用于获取`Object`类型或其子类型的局部变量。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 21
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_access_local_variables`: 能否获取/设置局部变量
* 参数：
    * `thread`: 
        * 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `depth`:
        * 类型为`jint`，包含了局部变量的栈帧的深度
    * `slot`:
        * 类型为`jint`，指定局部变量的槽值
    * `value_ptr`:
        * 类型为`jobject*`，出参，用于返回局部变量的值
        * 返回的值是一个JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_access_local_variables`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_SLOT`: 参数`slot`无效
    * `JVMTI_ERROR_TYPE_MISMATCH`: 变量类型不是`Object`或其子类型
    * `JVMTI_ERROR_OPAQUE_FRAME`: 栈帧不可见
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 目标线程已死或未启动
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 栈的指定的深度中没有栈帧
    * `JVMTI_ERROR_NULL_POINTER`: 参数`value_ptr `为`NULL`

<a name="2.6.8.2"></a>
#### 2.6.8.2 GetLocalInstance

    ```c
    jvmtiError GetLocalInstance(jvmtiEnv* env, jthread thread, jint depth, jobject* value_ptr)
    ```

该函数用于获取非静态栈帧中，局部变量槽值为`0`的变量值，即`this`。对于本地方法栈帧，使用该函数可以获取`this`的值，而函数`GetLocalObject`则会返回`JVMTI_ERROR_OPAQUE_FRAME`。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 155
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_access_local_variables`: 能否获取/设置局部变量
* 参数：
    * `thread`: 
        * 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `depth`:
        * 类型为`jint`，包含了局部变量的栈帧的深度
    * `value_ptr`:
        * 类型为`jobject*`，出参，用于返回局部变量的值
        * 返回的值是一个JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_access_local_variables`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_SLOT`: 参数`slot`指定的不是非静态栈帧
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 目标线程已死或未启动
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 栈的指定的深度中没有栈帧
    * `JVMTI_ERROR_NULL_POINTER`: 参数`value_ptr `为`NULL`

<a name="2.6.8.3"></a>
#### 2.6.8.3 GetLocalInt

    ```c
    jvmtiError GetLocalInt(jvmtiEnv* env, jthread thread, jint depth, jint slot, jint* value_ptr)
    ```

该函数用于获取类型为`int` `short` `char` `byte`或`boolean`的局部变量。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 22
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_access_local_variables`: 能否获取/设置局部变量
* 参数：
    * `thread`: 
        * 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `depth`:
        * 类型为`jint`，包含了局部变量的栈帧的深度
    * `slot`:
        * 类型为`jint`，指定局部变量的槽值
    * `value_ptr`:
        * 类型为`jint*`，出参，用于返回局部变量的值
        * 返回的值是一个JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_access_local_variables`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_SLOT`: 参数`slot`无效
    * `JVMTI_ERROR_TYPE_MISMATCH`: 变量类型不是`int` `short` `char` `byte`或`boolean`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 栈帧不可见
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 目标线程已死或未启动
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 栈的指定的深度中没有栈帧
    * `JVMTI_ERROR_NULL_POINTER`: 参数`value_ptr `为`NULL`

<a name="2.6.8.4"></a>
#### 2.6.8.4 GetLocalLong

    ```c
    jvmtiError GetLocalLong(jvmtiEnv* env, jthread thread, jint depth, jint slot, jlong* value_ptr)
    ```

该函数用于获取类型为`long`的局部变量。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 23
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_access_local_variables`: 能否获取/设置局部变量
* 参数：
    * `thread`: 
        * 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `depth`:
        * 类型为`jint`，包含了局部变量的栈帧的深度
    * `slot`:
        * 类型为`jint`，指定局部变量的槽值
    * `value_ptr`:
        * 类型为`jlong*`，出参，用于返回局部变量的值
        * 返回的值是一个JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_access_local_variables`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_SLOT`: 参数`slot`无效
    * `JVMTI_ERROR_TYPE_MISMATCH`: 变量类型不是`long`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 栈帧不可见
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 目标线程已死或未启动
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 栈的指定的深度中没有栈帧
    * `JVMTI_ERROR_NULL_POINTER`: 参数`value_ptr `为`NULL`

<a name="2.6.8.5"></a>
#### 2.6.8.5 GetLocalFloat

    ```c
    jvmtiError GetLocalFloat(jvmtiEnv* env, jthread thread, jint depth, jint slot, jfloat* value_ptr)
    ```

该函数用于获取类型为`float`的局部变量。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 24
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_access_local_variables`: 能否获取/设置局部变量
* 参数：
    * `thread`: 
        * 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `depth`:
        * 类型为`jint`，包含了局部变量的栈帧的深度
    * `slot`:
        * 类型为`jint`，指定局部变量的槽值
    * `value_ptr`:
        * 类型为`jfloat*`，出参，用于返回局部变量的值
        * 返回的值是一个JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_access_local_variables`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_SLOT`: 参数`slot`无效
    * `JVMTI_ERROR_TYPE_MISMATCH`: 变量类型不是`float`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 栈帧不可见
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 目标线程已死或未启动
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 栈的指定的深度中没有栈帧
    * `JVMTI_ERROR_NULL_POINTER`: 参数`value_ptr `为`NULL`

<a name="2.6.8.6"></a>
#### 2.6.8.6 GetLocalDouble

    ```c
    jvmtiError GetLocalDouble(jvmtiEnv* env, jthread thread, jint depth, jint slot, jdouble* value_ptr)
    ```

该函数用于获取类型为`double`的局部变量。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 25
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_access_local_variables`: 能否获取/设置局部变量
* 参数：
    * `thread`: 
        * 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `depth`:
        * 类型为`jint`，包含了局部变量的栈帧的深度
    * `slot`:
        * 类型为`jint`，指定局部变量的槽值
    * `value_ptr`:
        * 类型为`jdouble*`，出参，用于返回局部变量的值
        * 返回的值是一个JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_access_local_variables`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_SLOT`: 参数`slot`无效
    * `JVMTI_ERROR_TYPE_MISMATCH`: 变量类型不是`double`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 栈帧不可见
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 目标线程已死或未启动
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 栈的指定的深度中没有栈帧
    * `JVMTI_ERROR_NULL_POINTER`: 参数`value_ptr `为`NULL`

<a name="2.6.8.7"></a>
#### 2.6.8.7 SetLocalObject

    ```c
    jvmtiError SetLocalObject(jvmtiEnv* env, jthread thread, jint depth, jint slot, jobject value)
    ```

该函数用于设置类型为`Object`或其子类型的局部变量。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 26
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_access_local_variables`: 能否获取/设置局部变量
* 参数：
    * `thread`: 
        * 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `depth`:
        * 类型为`jint`，包含了局部变量的栈帧的深度
    * `slot`:
        * 类型为`jint`，指定局部变量的槽值
    * `value`:
        * 类型为`jobject`，待设置的局部变量值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_access_local_variables`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_SLOT`: 参数`slot`无效
    * `JVMTI_ERROR_TYPE_MISMATCH`: 变量类型不是`Object`或其子类型
    * `JVMTI_ERROR_TYPE_MISMATCH`: 参数`value`的类型有局部变量的类型不兼容
    * `JVMTI_ERROR_OPAQUE_FRAME`: 栈帧不可见
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 目标线程已死或未启动
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 栈的指定的深度中没有栈帧
    * `JVMTI_ERROR_INVALID_OBJECT`: 参数`value`不是一个对象

<a name="2.6.8.8"></a>
#### 2.6.8.8 SetLocalInt

    ```c
    jvmtiError SetLocalInt(jvmtiEnv* env, jthread thread, jint depth, jint slot, jint value)
    ```

该函数用于设置类型为`int` `short` `char` `byte`或`boolean`的局部变量。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 27
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_access_local_variables`: 能否获取/设置局部变量
* 参数：
    * `thread`: 
        * 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `depth`:
        * 类型为`jint`，包含了局部变量的栈帧的深度
    * `slot`:
        * 类型为`jint`，指定局部变量的槽值
    * `value`:
        * 类型为`jint`，待设置的局部变量值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_access_local_variables`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_SLOT`: 参数`slot`无效
    * `JVMTI_ERROR_TYPE_MISMATCH`: 变量类型不是`int` `short` `char` `byte`或`boolean`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 栈帧不可见
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 目标线程已死或未启动
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 栈的指定的深度中没有栈帧

<a name="2.6.8.9"></a>
#### 2.6.8.9 SetLocalLong

    ```c
    jvmtiError SetLocalLong(jvmtiEnv* env, jthread thread, jint depth, jint slot, jlong value)
    ```

该函数用于设置类型为`long`的局部变量。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 28
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_access_local_variables`: 能否获取/设置局部变量
* 参数：
    * `thread`: 
        * 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `depth`:
        * 类型为`jint`，包含了局部变量的栈帧的深度
    * `slot`:
        * 类型为`jint`，指定局部变量的槽值
    * `value`:
        * 类型为`jlong`，待设置的局部变量值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_access_local_variables`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_SLOT`: 参数`slot`无效
    * `JVMTI_ERROR_TYPE_MISMATCH`: 变量类型不是`long`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 栈帧不可见
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 目标线程已死或未启动
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 栈的指定的深度中没有栈帧

<a name="2.6.8.10"></a>
#### 2.6.8.10 SetLocalFloat

    ```c
    jvmtiError SetLocalFloat(jvmtiEnv* env, jthread thread, jint depth, jint slot, jfloat value)
    ```

该函数用于设置类型为`float`的局部变量。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 29
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_access_local_variables`: 能否获取/设置局部变量
* 参数：
    * `thread`: 
        * 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `depth`:
        * 类型为`jint`，包含了局部变量的栈帧的深度
    * `slot`:
        * 类型为`jint`，指定局部变量的槽值
    * `value`:
        * 类型为`jfloat`，待设置的局部变量值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_access_local_variables`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_SLOT`: 参数`slot`无效
    * `JVMTI_ERROR_TYPE_MISMATCH`: 变量类型不是`float`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 栈帧不可见
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 目标线程已死或未启动
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 栈的指定的深度中没有栈帧

<a name="2.6.8.11"></a>
#### 2.6.8.11 SetLocalDouble

    ```c
    jvmtiError SetLocalDouble(jvmtiEnv* env, jthread thread, jint depth, jint slot, jdouble value)
    ```

该函数用于设置类型为`double`的局部变量。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 30
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_access_local_variables`: 能否获取/设置局部变量
* 参数：
    * `thread`: 
        * 类型为`jthread`，目标线程，若为`NULL`，则为当前线程
    * `depth`:
        * 类型为`jint`，包含了局部变量的栈帧的深度
    * `slot`:
        * 类型为`jint`，指定局部变量的槽值
    * `value`:
        * 类型为`jdouble`，待设置的局部变量值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_access_local_variables`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_SLOT`: 参数`slot`无效
    * `JVMTI_ERROR_TYPE_MISMATCH`: 变量类型不是`double`
    * `JVMTI_ERROR_OPAQUE_FRAME`: 栈帧不可见
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 目标线程已死或未启动
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`depth`小于0
    * `JVMTI_ERROR_NO_MORE_FRAMES`: 栈的指定的深度中没有栈帧

<a name="2.6.9"></a>
### 2.6.9 断点

断点相关的函数包括：

* [2.6.9.1 SetBreakpoint][134]
* [2.6.9.2 ClearBreakpoint][135]

<a name="2.6.9.1"></a>
#### 2.6.9.1 SetBreakpoint

    ```c
    jvmtiError SetBreakpoint(jvmtiEnv* env, jmethodID method, jlocation location)
    ```

该函数用于在指定指令上设置断点，具体的指令由参数`method`和`location`指定。每个指令上只能有一个断点。

当目标指令要被执行时，会生成一个`Breakpoint`事件。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 38
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_generate_breakpoint_events`: 能否获取/设置断点事件
* 参数：
    * `method`: 
        * 类型为`jmethod`，目标方法ID
    * `location`:
        * 类型为`jlocation`，目标方法中目标指令的索引位置
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_generate_breakpoint_events`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_DUPLICATE`: 目标指令上已经有断点了
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID
    * `JVMTI_ERROR_INVALID_LOCATION`: 参数`location`不是有效的索引位置


<a name="2.6.9.2"></a>
#### 2.6.9.2 ClearBreakpoint

    ```c
    jvmtiError ClearBreakpoint(jvmtiEnv* env, jmethodID method, jlocation location)
    ```

该函数用于在指定指令上清除断点，具体的指令由参数`method`和`location`指定。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 39
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_generate_breakpoint_events`: 能否获取/设置断点事件
* 参数：
    * `method`: 
        * 类型为`jmethod`，目标方法ID
    * `location`:
        * 类型为`jlocation`，目标方法中目标指令的索引位置
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_generate_breakpoint_events`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_NOT_FOUND`: 目标指令上没有断点
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID
    * `JVMTI_ERROR_INVALID_LOCATION`: 参数`location`不是有效的索引位置

<a name="2.6.10"></a>
### 2.6.10 监察属性值

检查属性值的函数包括：

* [2.6.10.1 SetFieldAccessWatch][136]
* [2.6.10.2 ClearFieldAccessWatch][137]
* [2.6.10.3 SetFieldModificationWatch][138]
* [2.6.10.4 ClearFieldModificationWatch][139]

<a name="2.6.10.1"></a>
#### 2.6.10.1 SetFieldAccessWatch

    ```c
    jvmtiError SetFieldAccessWatch(jvmtiEnv* env, jclass klass, jfieldID field)
    ```

该函数用于生成一个`FieldAccess`事件，目标属性由参数`klass`和`field`指定。每次访问目标属性时，都会生成一个事件，直到调用函数`ClearFieldAccessWatch`显式撤销。这里说到的**访问监察**是指在Java代码或JNI代码中访问属性，通过其他方法访问属性不算作**访问监察**的范围。JVMTI的使用者需要注意，他们对属性的访问也会触发相应的事件。每个属性只能有一个属性访问监察集合。修改属性的操作并不算作是访问属性，因此需要使用函数`SetFieldModificationWatch`来**访问监察**对属性修改的操作。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 41
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_generate_field_access_events`: 能否对目标属性设置访问监察
* 参数：
    * `klass`: 
        * 类型为`jclass`，目标类型
    * `field`:
        * 类型为`jfieldID`，目标属性的ID值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_generate_field_access_events`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_DUPLICATE`: 目标属性上已经有了访问监察
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`不是类对象，或者指定的类还没有载入
    * `JVMTI_ERROR_INVALID_FIELDID`: 参数`field`不是属性ID

<a name="2.6.10.2"></a>
#### 2.6.10.2 ClearFieldAccessWatch

    ```c
    jvmtiError ClearFieldAccessWatch(jvmtiEnv* env, jclass klass, jfieldID field)
    ```

该函数用于撤销在函数`SetFieldAccessWatch`中对目标属性设置的访问监察。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 42
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_generate_field_access_events`: 能否对目标属性设置访问监察
* 参数：
    * `klass`: 
        * 类型为`jclass`，目标类型
    * `field`:
        * 类型为`jfieldID`，目标属性的ID值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_generate_field_access_events`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_NOT_FOUND`: 目标属性上没有设置访问监察
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`不是类对象，或者指定的类还没有载入
    * `JVMTI_ERROR_INVALID_FIELDID`: 参数`field`不是属性ID

<a name="2.6.10.3"></a>
#### 2.6.10.3 SetFieldModificationWatch

    ```c
    jvmtiError SetFieldModificationWatch(jvmtiEnv* env, jclass klass, jfieldID field)
    ```

该函数用于生成一个`FieldModification`事件，目标属性由参数`klass`和`field`指定。每次修改目标属性时，都会生成一个事件，直到调用函数`ClearFieldModificationWatch`显式撤销。这里说到的**修改监察**是指在Java代码或JNI代码中修改属性会被**监察**到，通过其他方法修改属性不算作**监察**的范围。JVMTI的使用者需要注意，他们对属性的修改也会触发相应的事件。每个属性只能有一个属性修改监察集合。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 43
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_generate_field_modification_events`: 能否对目标属性设置修改监察
* 参数：
    * `klass`: 
        * 类型为`jclass`，目标类型
    * `field`:
        * 类型为`jfieldID`，目标属性的ID值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_generate_field_modification_events`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_DUPLICATE`: 目标属性上已经有了修改监察
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`不是类对象，或者指定的类还没有载入
    * `JVMTI_ERROR_INVALID_FIELDID`: 参数`field`不是属性ID

<a name="2.6.10.4"></a>
#### 2.6.10.4 ClearFieldModificationWatch

    ```c
    jvmtiError ClearFieldModificationWatch(jvmtiEnv* env, jclass klass, jfieldID field)
    ```

该函数用于撤销在函数`SetFieldModificationWatch`中对目标属性设置的修改监察。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 44
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_generate_field_modification_events`: 能否对目标属性设置修改监察
* 参数：
    * `klass`: 
        * 类型为`jclass`，目标类型
    * `field`:
        * 类型为`jfieldID`，目标属性的ID值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_generate_field_modification_events`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_NOT_FOUND`: 目标属性上没有设置修改监察
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`不是类对象，或者指定的类还没有载入
    * `JVMTI_ERROR_INVALID_FIELDID`: 参数`field`不是属性ID

<a name="2.6.11"></a>
### 2.6.11 类

类操作相关的函数包括：

* [2.6.11.1 GetLoadedClasses][140]
* [2.6.11.2 GetClassLoaderClasses][142]
* [2.6.11.3 GetClassSignature][143]
* [2.6.11.4 GetClassStatus][144]
* [2.6.11.5 GetSourceFileName][145]
* [2.6.11.6 GetClassModifiers][146]
* [2.6.11.7 GetClassMethods][148]
* [2.6.11.8 GetClassFields][149]
* [2.6.11.9 GetImplementedInterfaces][150]
* [2.6.11.10 GetClassVersionNumbers][151]
* [2.6.11.11 GetConstantPool][152]
* [2.6.11.12 IsInterface][153]
* [2.6.11.13 IsArrayClass][154]
* [2.6.11.14 IsModifiableClass][155]
* [2.6.11.15 GetClassLoader][156]
* [2.6.11.16 GetSourceDebugExtension][157]
* [2.6.11.17 RetransformClasses][158]
* [2.6.11.18 RedefineClasses][159]

<a name="2.6.11.1"></a>
#### 2.6.11.1 GetLoadedClasses

    ```c
    jvmtiError GetLoadedClasses(jvmtiEnv* env, jint* class_count_ptr, jclass** classes_ptr)
    ```

该函数用于返回JVM中所有已载入的类。已载入类的属性会放在出参`class_count_ptr`中，已载入类的列表会放在出参`classes_ptr`中。

已载入类中包含了原生类型数组的类型，但不会包含原生类型。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 78
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `class_count_ptr`: 
        * 类型为`jint*`，出参，用于返回已载入类的数量
        * JVMTI代理需要提供一个指向`jint`的指针
    * `classes_ptr`:
        * 类型为`jclass**`，出参，用于返回已载入的类
        * JVMTI代理需要提供一个指向`jclass*`的指针，该函数会创建一个长度为`*class_count_ptr`的数组，并赋值给该出参。
        * 新创建的数组需要使用函数`Deallocate`加以释放，`class_ptr`返回的是JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NULL_POINTER`: 参数`class_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`classes_ptr`为`NULL`

<a name="2.6.11.2"></a>
#### 2.6.11.2 GetClassLoaderClasses

    ```c
    jvmtiError GetClassLoaderClasses(jvmtiEnv* env, jobject initiating_loader, jint* class_count_ptr, jclass** classes_ptr)
    ```

该函数用于返回以指定的类载入器为**初始类载入器**的类。JVM中的每个类都是由其类载入器创建的，创建方式可以是直接定义的，也可以是委托给其他类载入器定义的。参见[JVM规范][141]。

对于JDK 1.1来说，它不能区分初始类载入器和定义类载入器，因此该函数会返回JVM中所有已载入的类。要返回的类的数量放在出参`class_count_ptr`中，要返回的类放在出参`classes_ptr`中。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 79
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `initiating_loader`:
        * 类型为`jobejct`，初始类载入器，若为`NULL`，则返回由启动类载入器`bootstrap loader`初始化的类
    * `class_count_ptr`: 
        * 类型为`jint*`，出参，用于返回已载入类的数量
        * JVMTI代理需要提供一个指向`jint`的指针
    * `classes_ptr`:
        * 类型为`jclass**`，出参，用于返回已载入的类
        * JVMTI代理需要提供一个指向`jclass*`的指针，该函数会创建一个长度为`*class_count_ptr`的数组，并赋值给该出参。
        * 新创建的数组需要使用函数`Deallocate`加以释放，`class_ptr`返回的是JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NULL_POINTER`: 参数`class_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`classes_ptr`为`NULL`

<a name="2.6.11.3"></a>
#### 2.6.11.3 GetClassSignature

    ```c
    jvmtiError GetClassSignature(jvmtiEnv* env, jclass klass, char** signature_ptr, char** generic_ptr)
    ```

该函数用于获取目标类的JNI类型签名和类型的泛型信息。例如，对于类型`java.util.List`来说，签名是`Ljava/util/List;`，类型`int[]`的签名是`[I`。`java.lang.Integer.TYPE`是`I`。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 48
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `signature_ptr`: 
        * 类型为`char**`，出参，用于返回类型的签名信息，使用自定义UTF-8编码
        * JVMTI代理需要提供一个指向`char*`的指针，该函数会创建一个数组来存在签名信息，新创建的数组需要使用函数`Deallocate`加以释放
        * 若`signature_ptr`为`NULL`，则不会返回签名信息
    * `generic_ptr`:
        * 类型为`char**`，出参，用于返回泛型信息，使用自定义UTF-8编码
        * JVMTI代理需要提供一个指向`char*`的指针，新创建的数组需要使用函数`Deallocate`加以释放
        * 若类型没有泛型，则不会返回泛型信息，该参数为`NULL`
        * 若`signature_ptr`为`NULL`，则不会返回泛型信息
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象

<a name="2.6.11.4"></a>
#### 2.6.11.4 GetClassStatus

    ```c
    jvmtiError GetClassStatus(jvmtiEnv* env, jclass klass, jint* status_ptr)
    ```

该函数用于获取目标类型的状态，状态标志位中可能会同事存在多个状态值。

类型的状态包括：

            Class Status Flags
    Constant	                        Value	Description
    JVMTI_CLASS_STATUS_VERIFIED	        1	    类型的字节码已经校验
    JVMTI_CLASS_STATUS_PREPARED	        2	    类型的准备已经完成
    JVMTI_CLASS_STATUS_INITIALIZED	    4	    类型的初始化已经完成，静态初始化器已经运行
    JVMTI_CLASS_STATUS_ERROR	        8	    类型初始化失败，类不可用
    JVMTI_CLASS_STATUS_ARRAY	        16	    类型是数组，若设置了该标志位，则其他标志位置0
    JVMTI_CLASS_STATUS_PRIMITIVE	    32	    类型是原生类型，例如java.lang.Integer.TYPE，若设置了该标志位，则其他标志位置0

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 49
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `status_ptr`: 
        * 类型为`jint*`，出参，用于返回类型的状态，可能会同时包含多个标志位
        * JVMTI代理需要提供一个指向`jint*`的指针，函数返回时会设置该值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象
    * `JVMTI_ERROR_NULL_POINTER`: 参数`status_ptr`为`NULL`

<a name="2.6.11.5"></a>
#### 2.6.11.5 GetSourceFileName

    ```c
    jvmtiError GetSourceFileName(jvmtiEnv* env, jclass klass, char** source_name_ptr)
    ```

该函数用于获取指定累的源文件名，注意，只是文件名，不包含路径。

对于原生类型(例如`java.lang.Integer.TYPE`)和数组，该函数返回`JVMTI_ERROR_ABSENT_INFORMATION`。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 50
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_get_source_file_name`: 能否对目标属性设置修改监察
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `source_name_ptr`: 
        * 类型为`char**`，出参，用于源文件名，使用自定义UTF-8编码
        * JVMTI代理需要提供一个指向`char*`的指针，函数会创建一个新的数组并返回，需要调用函数`Deallocate`释放
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_get_source_file_name`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_ABSENT_INFORMATION`: 类信息中不包括源文件名，原生类型(例如`java.lang.Integer.TYPE`)和数组，返回该值
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象或还未载入
    * `JVMTI_ERROR_NULL_POINTER`: 参数`source_name_ptr`为`NULL`

<a name="2.6.11.6"></a>
#### 2.6.11.6 GetClassModifiers

    ```c
    jvmtiError GetClassModifiers(jvmtiEnv* env, jclass klass, jint* modifiers_ptr)
    ```

该函数用于获取指定类型的访问标记，通过出参`modifiers_ptr`返回。访问标记定义在[JVM规范第4章][147]。

若目标类型是对象数组，则其`public` `private`和`protected`标记与其数组元素类型相同。对于原生类型数组，则元素类型由原生类型决定，例如`java.lang.Integer.TYPE`。

若目标类型是原生类型，则其`public`标记永远为`true`，其`private`和`protected`标记永远为`false`。

若目标类型是数组或原生类型，则其`final`标记永远为`true`，其`interface`标记，永远为`false`。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 51
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `modifiers_ptr`: 
        * 类型为`jint*`，出参，用于获取类型的访问标记，JVMTI代理需要提供一个指向`jint`的指针
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象或还未载入
    * `JVMTI_ERROR_NULL_POINTER`: 参数`modifiers_ptr`为`NULL`

<a name="2.6.11.7"></a>
#### 2.6.11.7 GetClassMethods

    ```c
    jvmtiError GetClassMethods(jvmtiEnv* env, jclass klass, jint* method_count_ptr, jmethodID** methods_ptr)
    ```

该函数用于获取指定类型的方法，数量放在`method_count_ptr`，方法ID放在`methods_ptr`。这里面包含了构造函数、静态初始化方法和真实的方法。需要注意的是，这里只包含了目标类型直接声明的方法，不包括继承得来的方法。对于数组和原生类型，例如`java.lang.Integer.TYPE`，该方法返回空列表。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 52
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_maintain_original_method_order`: 是否能获取目标类文件中的方法
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `method_count_ptr`: 
        * 类型为`jint*`，出参，返回方法的个数，JVMTI代理需要提供一个指向`jint`的指针
    * `methods_ptr`:
        * 类型为`jmethodID**`，出参，返回方法ID
        * JVMTI代理需要提供一个指向`jmethodID*`的指针，函数会创建一个长度为`*method_count_ptr`的数组，需要显式调用函数`Deallocate`来释放
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_CLASS_NOT_PREPARED`: 目标类型还未准备好
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象或还未载入
    * `JVMTI_ERROR_NULL_POINTER`: 参数`method_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`methods_ptr`为`NULL`

<a name="2.6.11.8"></a>
#### 2.6.11.8 GetClassFields

    ```c
    jvmtiError GetClassFields(jvmtiEnv* env, jclass klass, jint* field_count_ptr, jfieldID** fields_ptr)
    ```

该函数用于获取指定类型的属性，数量放在`field_count_ptr`，属性ID放在`fields_ptr`。这里只会返回类型直接声明的属性，不包括继承的来属性。返回的属性的顺序与其在类型文件中的出现顺序相同。对于数组和原生类型，例如`java.lang.Integer.TYPE`，该方法返回空列表。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 53
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `field_count_ptr`: 
        * 类型为`jint*`，出参，返回属性的个数，JVMTI代理需要提供一个指向`jint`的指针
    * `fields_ptr`:
        * 类型为`jfieldID**`，出参，返回属性ID
        * JVMTI代理需要提供一个指向`jfieldID*`的指针，函数会创建一个长度为`*field_count_ptr`的数组，需要显式调用函数`Deallocate`来释放
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_CLASS_NOT_PREPARED`: 目标类型还未准备好
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象或还未载入
    * `JVMTI_ERROR_NULL_POINTER`: 参数`field_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`fields_ptr`为`NULL`

<a name="2.6.11.9"></a>
#### 2.6.11.9 GetImplementedInterfaces

    ```c
    jvmtiError GetImplementedInterfaces(jvmtiEnv* env, jclass klass, jint* interface_count_ptr, jclass** interfaces_ptr)
    ```

该方法用于返回目标类的直接父接口。对于普通类，该函数返回在其`implements`语句中声明的接口；对于接口，该函数返回其`extends`语句中声明的接口。对于数组和原生类型，例如`java.lang.Integer.TYPE`，该方法返回空列表。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 54
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `interface_count_ptr`: 
        * 类型为`jint*`，出参，返回接口的个数，JVMTI代理需要提供一个指向`jint`的指针
    * `interfaces_ptr`:
        * 类型为`jclass**`，出参，返回接口类型
        * JVMTI代理需要提供一个指向`jclass*`的指针，函数会创建一个长度为`*interface_count_ptr`的数组，需要显式调用函数`Deallocate`来释放
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_CLASS_NOT_PREPARED`: 目标类型还未准备好
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象或还未载入
    * `JVMTI_ERROR_NULL_POINTER`: 参数`interface_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`interfaces_ptr`为`NULL`

<a name="2.6.11.10"></a>
#### 2.6.11.10 GetClassVersionNumbers

    ```c
    jvmtiError GetClassVersionNumbers(jvmtiEnv* env, jclass klass, jint* minor_version_ptr, jint* major_version_ptr)
    ```

该函数用于获取指定类的主版本号和次版本号，参见[JVM规范第4章][147]。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 145
* Since： 1.1
* 功能： 
    * 必选
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `minor_version_ptr`: 
        * 类型为`jint*`，出参，返回次版本号，JVMTI代理需要提供一个指向`jint`的指针
    * `major_version_ptr`:
        * 类型为`jint*`，出参，返回主版本号，JVMTI代理需要提供一个指向`jint`的指针
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_ABSENT_INFORMATION`: 目标类型是原生类型或数组
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象或还未载入
    * `JVMTI_ERROR_NULL_POINTER`: 参数`minor_version_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`major_version_ptr`为`NULL`

<a name="2.6.11.11"></a>
#### 2.6.11.11 GetConstantPool

    ```c
    jvmtiError GetConstantPool(jvmtiEnv* env, jclass klass, jint* constant_pool_count_ptr, jint* constant_pool_byte_count_ptr, unsigned char** constant_pool_bytes_ptr)
    ```

该函数用于获取目标类型的常量池信息，以原始字节码的形式返回，常量池的内容参见[JVM规范第4章][147]。常量池的格式取决于类文件格式的版本，因此需要检查主版本号和次版本号的兼容性。

该函数返回的常量池的布局和内容可能与类文件中的定义不同。函数`GetConstantPool()`返回的常量池的内容可能会比类文件中定义的多，也有可能会少，且常量池中条目的顺序也与类文件中的定义不尽相同。函数`GetConstantPool()`返回的常量池与函数`GetBytecodes()`的常量池相匹配。即，函数`GetBytecodes`返回的字节码的索引值与函数`GetConstantPool`常量项相对应。注意，由于函数`RetransformClasses`和`RedefineClasses`可以改变常量池，该函数返回的常量池也会相应的变化，因此如果存在有对类的转换或重定义，则函数`GetConstantPool()`和`GetBytecodes()`返回的内容可能无法保持一致。指定字节码中常量项的值与定义的类文件中相匹配，即使索引值不匹配，也没关系。不会被字节码直接或间接使用的常量项(例如,与注解关联的UTF-8zifuch )，不一定会存在于返回的常量池中。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 146
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_get_constant_pool`: 是否能获取目标类的常量池
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `constant_pool_count_ptr`: 
        * 类型为`jint*`，出参，返回值等于常量池中常量项的个数+1，与JVM规范中的定义相同
        * JVMTI代理需要提供一个指向`jint`的指针
    * `constant_pool_byte_count_ptr`:
        * 类型为`jint*`，出参，返回以字节形式表示的常量池的个数
        * JVMTI代理需要提供一个指向`jint`的指针
    * `constant_pool_bytes_ptr`:
        * 类型为`unsigned char**`，出参，返回原始常量池，即在类文件中定义的`constant_pool`内容
        * JVMTI代理需要提供一个指向`unsigned char*`的指针，函数返回时，会创建一个长度为`*constant_pool_byte_count_ptr`的数组，需要调用函数`Deallocate`释放
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_get_constant_pool`，需要调用`AddCapabilities
    * `JVMTI_ERROR_ABSENT_INFORMATION`: 目标类型是原生类型或数组
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象或还未载入
    * `JVMTI_ERROR_NULL_POINTER`: 参数`constant_pool_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`constant_pool_byte_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`constant_pool_bytes_ptr`为`NULL`

<a name="2.6.11.12"></a>
#### 2.6.11.12 IsInterface

    ```c
    jvmtiError IsInterface(jvmtiEnv* env, jclass klass, jboolean* is_interface_ptr)
    ```

该函数用于判断指定的类对象是否是接口。若是，出参`is_interface_ptr`置为`JNI_TRUE`，否则置为`JNI_FALSE`。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 55
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `is_interface_ptr`: 
        * 类型为`jboolean*`，出参，表示目标类型是否是接口
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象或还未载入
    * `JVMTI_ERROR_NULL_POINTER`: 参数`is_interface_ptr`为`NULL`

<a name="2.6.11.13"></a>
#### 2.6.11.13 IsArrayClass

    ```c
    jvmtiError IsArrayClass(jvmtiEnv* env, jclass klass, jboolean* is_array_class_ptr)
    ```

该函数用于判断指定的类对象是否是数组。若是，出参`is_interface_ptr`置为`JNI_TRUE`，否则置为`JNI_FALSE`。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 55
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `is_array_class_ptr`: 
        * 类型为`jboolean*`，出参，表示目标类型是否是数组
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象或还未载入
    * `JVMTI_ERROR_NULL_POINTER`: 参数`is_array_class_ptr`为`NULL`

<a name="2.6.11.14"></a>
#### 2.6.11.14 IsModifiableClass

    ```c
    jvmtiError IsModifiableClass(jvmtiEnv* env, jclass klass, jboolean* is_modifiable_class_ptr)
    ```

该函数用判断目标类是否可修改。若类是可修改的(出参`is_modifiable_class_ptr`被置为`JNI_TRUE`)，则可以通过`RedefineClasses`或`RetransformClasses`对类进行修改。若类不可修改，则无法执行重定义或重转换操作。

原生类型(例如`java.lang.Integer.TYPE`)和数组类型永远不可修改。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 45
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_redefine_any_class`: 是否能获重定义所有类，不包括原生类型和数组类型
        * `can_redefine_classes`: 对于该函数没有作用。但使用`RedefineClasses`重定义类时，必须加上
        * `can_retransform_classes`: 对于该函数没有作用。但使用`RetransformClasses`重转换类时，必须加上
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `is_modifiable_class_ptr`: 
        * 类型为`jboolean*`，出参，表示目标类型是否可修改
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象或还未载入
    * `JVMTI_ERROR_NULL_POINTER`: 参数`is_modifiable_class_ptr`为`NULL`

<a name="2.6.11.15"></a>
#### 2.6.11.15 GetClassLoader

    ```c
    jvmtiError GetClassLoader(jvmtiEnv* env, jclass klass, jobject* classloader_ptr)
    ```

该函数用于获取指定类的类载入器，以出参`classloader_ptr`返回。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 57
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `classloader_ptr`: 
        * 类型为`jobject*`，出参，用于获取类载入器
        * 返回的内容是JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象或还未载入
    * `JVMTI_ERROR_NULL_POINTER`: 参数`classloader_ptr`为`NULL`

<a name="2.6.11.16"></a>
#### 2.6.11.16 GetSourceDebugExtension

    ```c
    jvmtiError GetSourceDebugExtension(jvmtiEnv* env, jclass klass,char** source_debug_extension_ptr)
    ```

该函数用于获取指定类的调试扩展信息，以出参`source_debug_extension_ptr`返回。返回的字符串中包含了在类文件中定义的调试扩展信息。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 90
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_get_source_debug_extension`: 是否能获取调试扩展信息
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类型
    * `source_debug_extension_ptr`: 
        * 类型为`char**`，出参，用于获取调试扩展信息
        * JVMTI代理需要提供一个指向`char*`的指针，函数返回时会创建一个数组，需要调用函数`Deallocate`释放
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_get_source_debug_extension`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_ABSENT_INFORMATION`: 类文件中没有调试扩展信息
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`为不是类对象或还未载入
    * `JVMTI_ERROR_NULL_POINTER`: 参数`source_debug_extension_ptr`为`NULL`

<a name="2.6.11.17"></a>
#### 2.6.11.17 RetransformClasses

    ```c
    jvmtiError RetransformClasses(jvmtiEnv* env, jint class_count, const jclass* classes)
    ```

该函数用于对已载入的类做字节码增强。在某些场景下，用户无法访问类的字节码，但却想要替换掉某些类定义(例如使用"fix-and-continue"调试模式时，会从源代码重新编译)，此时需要使用函数`RedefineClasses`。


当类首次被载入时，或是被重定义时，原始的类文件字节可以通过`ClassFileLoadHook`事件进行转换。该函数会返回转换过程(不论之前是否已经做过转换)。转换过程按以下步骤执行：

* 获取原始类文件字节
* 对于不能执行转换的JVMTI代理来说，在载入和重定义时，会接收到`ClassFileLoadHook`事件，它所返回的字节会作为转换的输出，这相当于没做任何修改就返回了，相当于`ClassFileLoadHook`事件没有发给这类JVMTI代理
* 对于可以执行转换的JVMTI代理来说，会发出`ClassFileLoadHook`事件，允许执行转换
* 转换过的字节作为新的类定义来安装

更多详细内容参见事件`ClassFileLoadHook`。

原始类文件字节会被传入到函数`ClassLoader.defineClass`或`RedefineClasses`(对于`RedefineClasses`来说，会在任何类转换之前)中但是可能不会和他们精准匹配。常量池可能会与函数`GetConstantPool`中的返回不尽相同。在方法字节码中的常量池索引会相关联。某些属性可能不会出现。这里面，常量项的顺序没有意义，也不会特意保留。

类的重转换会触发安装新版本的方法实现。老版本的方法实现会被废弃，在下一次方法调用的时候，会调用新版本的方法。如果方法已经在调用栈中执行，那么该方法会继续执行老版本的方法实现。

该函数不会触发任何初始化，除非是JVM实现有特殊的自定义实现。换句话说，类的重转换不会触发类的初始化，静态变量的值不会变化。

线程不会挂起。

目标类中的断点会被清除。

所有的属性都会更新。

被转换的类的实例不会受影响，实例变量的值不会变化。实例的标签值也不会变化。

在该函数的响应中，只会发送`ClassFileLoadHook`事件，其他的都不会发送。

重转换可能会改变方法的实现，常量池和属性。因此，重转换**禁止**添加、移除、重命名方法或和方法，**禁止**改变方法签名，**禁止**改变方法修饰符，**禁止**改变继承关系。在将来的版本中，可能会解除。如果试图执行不支持的重转换，则会返回相应的错误码。类文件的字节码，在经过`ClassFileLoadHook`事件调用链之前，都不会被校验或安装，因此返回的错误码可以表示转换的结果。如果函数返回了非`JVMTI_ERROR_NONE`的错误码，则被转换的目标类不会安装新的定义。在该函数返回，且错误码为`JVMTI_ERROR_NONE`时，所有被转换的类都会完成新定义的安装。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 152
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_retransform_classes`: 是否能通过函数`RetransformClasses`转换类定义。除了各个JVM实现对该函数的限制之外，该项功能**必须**在`ClassFileLoadHook`首次启用之前设置。
        * `can_retransform_any_class`: 是否能对任意类调用函数`RetransformClasses`(必须先设置功能`can_retransform_classes `)
* 参数：
    * `class_count`:
        * 类型为`jint`，要转换的类的个数
    * `classes`: 
        * 类型为`const jclass**`，要转换的类的数组，数组长度为`class_count`
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_retransform_classes`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_UNMODIFIABLE_CLASS`: 参数`classes`中的某个类无法修改，参见`IsModifiableClass`
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`classes`中的某个类无效
    * `JVMTI_ERROR_UNSUPPORTED_VERSION`: 参数`classes`中的某个类的版本不受当前JVM支持
    * `JVMTI_ERROR_INVALID_CLASS_FORMAT`: 参数`classes`中的某个类的格式错误，JVM返回`ClassFormatError`
    * `JVMTI_ERROR_CIRCULAR_CLASS_DEFINITION`: 转换之后的类定义将导致循环定义，JVM返回`ClassCircularityError`
    * `JVMTI_ERROR_FAILS_VERIFICATION`: 转换之后的类定义校验失败
    * `JVMTI_ERROR_NAMES_DONT_MATCH`: 转换之后的类的名字与转换之前的类的名字不同
    * `JVMTI_ERROR_UNSUPPORTED_REDEFINITION_METHOD_ADDED`: 转换之后的类添加了新的方法
    * `JVMTI_ERROR_UNSUPPORTED_REDEFINITION_SCHEMA_CHANGED`: 转换之后的类改变了属性
    * `JVMTI_ERROR_UNSUPPORTED_REDEFINITION_HIERARCHY_CHANGED`: 转换之后的类改变了继承关系
    * `JVMTI_ERROR_UNSUPPORTED_REDEFINITION_METHOD_DELETED`: 转换之后的类删除了转换之前的类中声明的方法
    * `JVMTI_ERROR_UNSUPPORTED_REDEFINITION_CLASS_MODIFIERS_CHANGED`： 转换之后了类改变了类的修饰符
    * `JVMTI_ERROR_UNSUPPORTED_REDEFINITION_METHOD_MODIFIERS_CHANGED`: 转换之后了类改变了方法的修饰符
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`class_count`小于0
    * `JVMTI_ERROR_NULL_POINTER`:参数`classes`为`NULL`

<a name="2.6.11.18"></a>
#### 2.6.11.18 RedefineClasses

    ```c
    jvmtiError RedefineClasses(jvmtiEnv* env, jint class_count, const jvmtiClassDefinition* class_definitions)
    ```

其中参数`jvmtiClassDefinition`的定义如下：

    ```c
    typedef struct {
        jclass klass;
        jint class_byte_count;
        const unsigned char* class_bytes;
    } jvmtiClassDefinition;
    ```

字段定义如下：

* `klass`:
    * 类型为`jclass`，当前类对象
* `class_byte_count`: 
    * 类型为`jint`，要定义的类的字节的数量
* `class_bytes`:
    * 类型为`const unsigned char*`，要定义的类的字节


该函数用于重新定义那些已经定义的类，具体场景可能是使用"fix-and-continue"调试模式。若要对已经存在的类进行转换，例如字节码增强，则需要使用函数`RetransformClasses`。

重新定义类将会为安装新版本的方法实现，同时将之前的方法实现标记为"废弃的"，在下一次调用该方法时，会调用新版本的方法实现。若目标方法已经创建了调用栈帧，则会继续使用旧版本的方法实现，此时如果想使用新版本的方法实现，可以调用函数`PopFrame`抛出已经栈帧。

该函数不会触发任何初始化，除非是JVM实现有特殊的自定义实现。换句话说，类的重转换不会触发类的初始化，静态变量的值不会变化。

线程不会挂起。

目标类中的断点会被清除。

所有的属性都会更新。

被转换的类的实例不会受影响，实例变量的值不会变化。实例的标签值也不会变化。

JVM在响应该函数时，会发送事件`ClassFileLoadHook`(如果启用了的话)，而非其他事件。

重定义可能会改变方法的实现，常量池和属性。因此，重定义**禁止**添加、移除、重命名方法或和方法，**禁止**改变方法签名，**禁止**改变方法修饰符，**禁止**改变继承关系。在将来的版本中，可能会解除。如果试图执行不支持的重定义，则会返回相应的错误码。类文件的字节码，在经过`ClassFileLoadHook`事件调用链之前，都不会被校验或安装，因此返回的错误码可以表示转换的结果。如果函数返回了非`JVMTI_ERROR_NONE`的错误码，则被转换的目标类不会安装新的定义。在该函数返回，且错误码为`JVMTI_ERROR_NONE`时，所有被转换的类都会完成新定义的安装。

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 87
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_redefine_classes`: 是否能通过函数`RedefineClasses`重定义类
        * `can_redefine_any_class`: 是否能修改任意非原生类型、非数组类型调用函数，参见`IsModifiableClass`
* 参数：
    * `class_count`:
        * 类型为`jint`，要定义的类的个数
    * `class_definitions`: 
        * 类型为`const jvmtiClassDefinition*`，要定义的类的数组，数组长度为`class_count`
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_redefine_classes`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`class_definitions`中某个元素的`class_bytes`字段为`NULL`
    * `JVMTI_ERROR_UNMODIFIABLE_CLASS`: 参数`class_definitions`中的某个类无法修改，参见`IsModifiableClass`
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`class_definitions`中的某个类无效
    * `JVMTI_ERROR_UNSUPPORTED_VERSION`: 参数`class_definitions`中的某个类的版本不受当前JVM支持
    * `JVMTI_ERROR_INVALID_CLASS_FORMAT`: 参数`class_definitions`中的某个类的格式错误，JVM返回`ClassFormatError`
    * `JVMTI_ERROR_CIRCULAR_CLASS_DEFINITION`: 重定义之后的类定义将导致循环定义，JVM返回`ClassCircularityError`
    * `JVMTI_ERROR_FAILS_VERIFICATION`: 重定义之后的类定义校验失败
    * `JVMTI_ERROR_NAMES_DONT_MATCH`: 重定义之后的类的名字与转换之前的类的名字不同
    * `JVMTI_ERROR_UNSUPPORTED_REDEFINITION_METHOD_ADDED`: 重定义之后的类添加了新的方法
    * `JVMTI_ERROR_UNSUPPORTED_REDEFINITION_SCHEMA_CHANGED`: 重定义之后的类改变了属性
    * `JVMTI_ERROR_UNSUPPORTED_REDEFINITION_HIERARCHY_CHANGED`: 重定义之后的类改变了继承关系
    * `JVMTI_ERROR_UNSUPPORTED_REDEFINITION_METHOD_DELETED`: 重定义之后的类删除了转换之前的类中声明的方法
    * `JVMTI_ERROR_UNSUPPORTED_REDEFINITION_CLASS_MODIFIERS_CHANGED`： 重定义之后了类改变了类的修饰符
    * `JVMTI_ERROR_UNSUPPORTED_REDEFINITION_METHOD_MODIFIERS_CHANGED`: 重定义之后了类改变了方法的修饰符
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`class_count`小于0
    * `JVMTI_ERROR_NULL_POINTER`:参数`class_definitions`为`NULL`

<a name="2.6.12"></a>
### 2.6.12 对象

对象相关的函数包括：

* [2.6.12.1 GetObjectSize][160]
* [2.6.12.2 GetObjectHashCode][161]
* [2.6.12.3 GetObjectMonitorUsage][162]

<a name="2.6.12.1"></a>
#### 2.6.12.1 GetObjectSize

    ```c
    jvmtiError GetObjectSize(jvmtiEnv* env, jobject object, jlong* size_ptr)
    ```

该函数用于获取指定对象的大小，以出参`size_ptr`返回。对象的大小与JVM的具体实现相关，是该对象所占用存储空间的近似值，可能会包含某些或所有对象的开销，因此对象大小的比较，只在某个JVM实现内有意义，在不同JVM实现之间没有比较意思。对象的大小，在单次调用期间，也可能会发生变化。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 154
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `object`:
        * 类型为`jobject`，目标对象
    * `size_ptr`: 
        * 类型为`jlong*`，出参，返回目标对象的大小，JVMTI提供一个指向`jlong`的指针
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_OBJECT`: 参数`object`不是对象
    * `JVMTI_ERROR_NULL_POINTER`: 参数`size_ptr`为`NULL`

<a name="2.6.12.2"></a>
#### 2.6.12.2 GetObjectHashCode

    ```c
    jvmtiError GetObjectHashCode(jvmtiEnv* env, jobject object, jint* hash_code_ptr)
    ```

该函数用于获取指定对象的哈希值，以出参`hash_code_ptr`返回。哈希值可用于维护对象引用的哈希表，但是在某些JVM实现中，这可能会导致较大性能损耗，在大多数场景下，使用对象标签值来关联相应的数据是一个更有效率的方法。该函数保证了，对象的哈希值会在对象的整个生命周期内有效。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 58
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `object`:
        * 类型为`jobject`，目标对象
    * `hash_code_ptr`: 
        * 类型为`jint*`，出参，返回目标对象的哈希值，JVMTI提供一个指向`jint`的指针
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_OBJECT`: 参数`object`不是对象
    * `JVMTI_ERROR_NULL_POINTER`: 参数`hash_code_ptr`为`NULL`

<a name="2.6.12.3"></a>
#### 2.6.12.3 GetObjectMonitorUsage

    ```c
    jvmtiError GetObjectMonitorUsage(jvmtiEnv* env, jobject object, jvmtiMonitorUsage* info_ptr)
    ```

该函数用于获取指定对象的监视器。

其中参数`jvmtiMonitorUsage`的定义如下：

    ```c
    typedef struct {
        jthread owner;
        jint entry_count;
        jint waiter_count;
        jthread* waiters;
        jint notify_waiter_count;
        jthread* notify_waiters;
    } jvmtiMonitorUsage;
    ```

字段说明如下：

* `owner`: 类型为`jthread`，表示持有该监视器的线程，若为`NULL`，则表示没有现成持有该监视器
* `entry_count`: 类型为`jint`，表示持有该监视器的线程进入监视器的次数
* `waiter_count`: 类型为`jint`，表示等待该监视器的线程的数量
* `waiters`: 类型为`jthread*`，表示等待该监视器的线程
* `notify_waiter_count`: 类型为`jint`，表示等待该监视器通知的线程的数量
* `notify_waiters`: 类型为`jthread*`，表示等待该监视器通知的线程

调用信息如下：

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 59
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_get_monitor_info`: 是否能获取监视器信息
* 参数：
    * `object`:
        * 类型为`jobject`，目标对象
    * `info_ptr`: 
        * 类型为`jvmtiMonitorUsage*`，出参，返回目标对象的监视器信息
        * JVMTI代理提供一个指向`jvmtiMonitorUsage`的指针
            * `owner`字段返回的是JNI局部引用，需要管理起来
            * `waiters`字段指向一个新分配的数组，需要显式调用函数`Deallocate`释放，并且数组中的元素也是JNI局部引用，需要管理起来
            * `notify_waiters`字段指向一个新分配的数组，需要显式调用函数`Deallocate`释放，并且数组中的元素也是JNI局部引用，需要管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_get_monitor_info`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_OBJECT`: 参数`object`不是对象
    * `JVMTI_ERROR_NULL_POINTER`: 参数`into_ptr`为`NULL`

<a name="2.6.13"></a>
### 2.6.13 属性

属性相关的函数包括：

* [2.6.13.1 GetFieldName][164]
* [2.6.13.2 GetFieldDeclaringClass][165]
* [2.6.13.3 GetFieldModifiers][166]
* [2.6.13.4 IsFieldSynthetic][167]

<a name="2.6.13.1"></a>
#### 2.6.13.1 GetFieldName

    ```c
    jvmtiError GetFieldName(jvmtiEnv* env, jclass klass, jfieldID field, char** name_ptr, char** signature_ptr, char** generic_ptr)
    ```

该函数用于获取指定类和属性的信息，出参`name_ptr`返回属性名，出参`signature_ptr`返回属性签名。

属性签名参见[JNI规范][163]和[JVM规范第4章][147]。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 59
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类
    * `field`:
        * 类型为`jfield`，目标属性
    * `name_ptr`:
        * 类型为`char **`，出参返回属性名，以自定义UTF-8编码
        * JVMTI代理需要传入一个指向`char *`的指针，函数返回时，会创建一个新的数组，需要显式调用`Deallocate`函数释放
        * 若参数`name_ptr`为`NULL`，则不会返回属性名
    * `signature_ptr`
        * 类型为`char **`，出参返回属性签名，以自定义UTF-8编码
        * JVMTI代理需要传入一个指向`char *`的指针，函数返回时，会创建一个新的数组，需要显式调用`Deallocate`函数释放
        * 若参数`signature_ptr`为`NULL`，则不会返回属性签名
    * `generic_ptr`
        * 类型为`char **`，出参返回属性的泛型签名，以自定义UTF-8编码
        * JVMTI代理需要传入一个指向`char *`的指针，函数返回时，会创建一个新的数组，需要显式调用`Deallocate`函数释放
        * 若参数`generic_ptr`为`NULL`，则不会返回属性的泛型签名
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`不是对象或还未载入
    * `JVMTI_ERROR_INVALID_FIELDID`: 参数`field`不是属性ID

<a name="2.6.13.2"></a>
#### 2.6.13.2 GetFieldDeclaringClass

    ```c
    jvmtiError GetFieldDeclaringClass(jvmtiEnv* env, jclass klass, jfieldID field, jclass* declaring_class_ptr)
    ```

该函数用于返回指定类和属性，通过出参`declaring_class_ptr`返回定义了该属性的类。定义类可以是类、父类或接口。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 61
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类
    * `field`:
        * 类型为`jfield`，目标属性
    * `declaring_class_ptr`:
        * 类型为`jclass *`，出参，返回定义该属性的类
        * JVMTI代理需要传入一个指向`jclass`的指针，函数返回一个JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`不是对象或还未载入
    * `JVMTI_ERROR_INVALID_FIELDID`: 参数`field`不是属性ID
    * `JVMTI_ERROR_NULL_POINTER`: 参数`declaring_class_ptr`为`NULL`

<a name="2.6.13.3"></a>
#### 2.6.13.3 GetFieldModifiers

    ```c
    jvmtiError GetFieldModifiers(jvmtiEnv* env, jclass klass, jfieldID field, jint* modifiers_ptr)
    ```

该函数用于获取指定类的指定属性的访问标记，以出参`modifiers_ptr`返回。访问标记参见[JVM规范第4章][147]。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 62
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类
    * `field`:
        * 类型为`jfield`，目标属性
    * `modifiers_ptr`:
        * 类型为`jint *`，出参，返回目标属性的访问标记
        * JVMTI代理需要传入一个指向`jint`的指针
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`不是对象或还未载入
    * `JVMTI_ERROR_INVALID_FIELDID`: 参数`field`不是属性ID
    * `JVMTI_ERROR_NULL_POINTER`: 参数`modifiers_ptr`为`NULL`

<a name="2.6.13.4"></a>
#### 2.6.13.4 IsFieldSynthetic

    ```c
    jvmtiError IsFieldSynthetic(jvmtiEnv* env, jclass klass, jfieldID field, jboolean* is_synthetic_ptr)
    ```

该函数用于获取指定类的指定属性是否合成构造的，以出参`is_synthetic_ptr`返回。合成构造的属性是指由编译器生成的，而非源代码中原本就存在的。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 63
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_get_synthetic_attribute`: 是否能测试某个属性/方法是合成构造的，参建方法`IsFieldSynthetic`和`IsMethodSynthetic`
* 参数：
    * `klass`:
        * 类型为`jclass`，目标类
    * `field`:
        * 类型为`jfield`，目标属性
    * `is_synthetic_ptr`:
        * 类型为`jboolean *`，出参，返回目标属性是否是合成构造的
        * JVMTI代理需要传入一个指向`jboolean`的指针
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_get_synthetic_attribute`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_CLASS`: 参数`klass`不是对象或还未载入
    * `JVMTI_ERROR_INVALID_FIELDID`: 参数`field`不是属性ID
    * `JVMTI_ERROR_NULL_POINTER`: 参数`is_synthetic_ptr`为`NULL`

<a name="2.6.14"></a>
### 2.6.14 方法

方法相关的函数包括：

* [2.6.14.1 GetMethodName][168]
* [2.6.14.2 GetMethodDeclaringClass][169]
* [2.6.14.3 GetMethodModifiers][170]
* [2.6.14.4 GetMaxLocals][171]
* [2.6.14.5 GetArgumentsSize][172]
* [2.6.14.6 GetLineNumberTable][173]
* [2.6.14.7 GetMethodLocation][174]
* [2.6.14.8 GetLocalVariableTable][175]
* [2.6.14.9 GetBytecodes][176]
* [2.6.14.10 IsMethodNative][177]
* [2.6.14.11 IsMethodSynthetic][178]
* [2.6.14.12 IsMethodObsolete][179]
* [2.6.14.13 SetNativeMethodPrefix][180]
* [2.6.14.14 SetNativeMethodPrefixes][181]

这些函数用于提供方法的相关信息，以及设置方法该如何执行。

函数`RetransformClasses`和`RedefineClasses`会安装方法实现的新版本，新版本和老版本如果满足以下全部条件，则认为是等同的：

* 新版本和旧版本的方法的字节码，除了在常量池中的索引值不同之外，其他都相同
* 新版本和旧版本的方法的字节码引用的常量项相同

若新版本和旧版本的方法不同，则认为旧版本的方法被认为是**废弃的**，会被赋值一个新的方法ID，旧的方法ID会指向新版本的方法实现。使用方法`IsMethodObsolete`可以测试方法ID所指向的方法是否已经被废弃。

<a name="2.6.14.1"></a>
#### 2.6.14.1 GetMethodName

    ```c
    jvmtiError GetMethodName(jvmtiEnv* env, jmethodID method, char** name_ptr, char** signature_ptr, char** generic_ptr)
    ```

该函数用于返回目标方法的名字和方法签名。

方法签名的定义参见[JNI规范][163]，在JVM规范中表示为[方法描述符][147]。需要注意的是，这与Java语言规范中定义的方法签名不同。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 64
* Since： 1.0
* 功能： 
    * 自选
* 参数：
    * `method`:
        * 类型为`jmethodID`，目标方法
    * `name_ptr`:
        * 类型为`char**`，出参，返回目标方法的名字，以自定义UTF-8编码
        * JVMTI代理需要提供一个指向`char*`的指针，函数返回时会创建一个数组，需要调用方法`Deallocate`显式释放
        * 若参数`name_ptr`为`NULL`，则不会返回方法名
    * `signature_ptr`:
        * 类型为`char**`，出参，返回目标方法的签名，以自定义UTF-8编码
        * JVMTI代理需要提供一个指向`char*`的指针，函数返回时会创建一个数组，需要调用方法`Deallocate`显式释放
        * 若参数`signature_ptr`为`NULL`，则不会返回方法签名
    * `generic_ptr`:
        * 类型为`char**`，出参，返回目标方法的泛型签名，以自定义UTF-8编码
        * JVMTI代理需要提供一个指向`char*`的指针，函数返回时会创建一个数组，需要调用方法`Deallocate`显式释放
        * 若参数`generic_ptr`为`NULL`，则不会返回方法的泛型签名
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID

<a name="2.6.14.2"></a>
#### 2.6.14.2 GetMethodDeclaringClass

    ```c
    jvmtiError GetMethodDeclaringClass(jvmtiEnv* env, jmethodID method, jclass* declaring_class_ptr)
    ```

该函数用于获取定义了目标方法的类。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 65
* Since： 1.0
* 功能： 
    * 自选
* 参数：
    * `method`:
        * 类型为`jmethodID`，目标方法
    * `declaring_class_ptr`:
        * 类型为`jclass*`，出参，返回定义了目标方法的类
        * JVMTI代理需要提供一个指向`jclass`的指针，函数返回时会设置该值，该值是一个JNI局部引用，必须管理起来
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID
    * `JVMTI_ERROR_NULL_POINTER`: 参数`declaring_class_ptr`为`NULL`

<a name="2.6.14.3"></a>
#### 2.6.14.3 GetMethodModifiers

    ```c
    jvmtiError GetMethodModifiers(jvmtiEnv* env, jmethodID method, jint* modifiers_ptr)
    ```

该函数用于获取定义了目标方法的访问标记，访问标记参见[JVM规范第4章][147]。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 66
* Since： 1.0
* 功能： 
    * 自选
* 参数：
    * `method`:
        * 类型为`jmethodID`，目标方法
    * `modifiers_ptr`:
        * 类型为`jint*`，出参，返回定义了目标方法的类
        * JVMTI代理需要提供一个指向`jint`的指针，函数返回时会设置该值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID
    * `JVMTI_ERROR_NULL_POINTER`: 参数`modifiers_ptr`为`NULL`

<a name="2.6.14.4"></a>
#### 2.6.14.4 GetMaxLocals

    ```c
    jvmtiError GetMaxLocals(jvmtiEnv* env, jmethodID method, jint* max_ptr)
    ```

该函数用于获取定义了目标方法所用到的局部变量槽的数量，局部变量槽包括局部变量和传给目标方法的参数。

参见[JVM规范4.7.3节][147]中对`max_locals`的介绍。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 66
* Since： 1.0
* 功能： 
    * 自选
* 参数：
    * `method`:
        * 类型为`jmethodID`，目标方法
    * `max_ptr`:
        * 类型为`jint*`，出参，返回定义了目标方法所用到的局部变量槽的数量
        * JVMTI代理需要提供一个指向`jint`的指针，函数返回时会设置该值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID
    * `JVMTI_ERROR_NATIVE_METHOD`: 参数`method`是本地方法
    * `JVMTI_ERROR_NULL_POINTER`: 参数`max_ptr`为`NULL`

<a name="2.6.14.5"></a>
#### 2.6.14.5 GetArgumentsSize

    ```c
    jvmtiError GetArgumentsSize(jvmtiEnv* env, jmethodID method, jint* size_ptr)
    ```

该方法用于获取目标方法的参数所占用的局部变量槽的数量，注意，两个字长的参数会占用两个槽。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 69
* Since： 1.0
* 功能： 
    * 自选
* 参数：
    * `method`:
        * 类型为`jmethodID`，目标方法
    * `size_ptr`:
        * 类型为`jint*`，出参，返回定义了目标方法的参数所用到的局部变量槽的数量
        * JVMTI代理需要提供一个指向`jint`的指针，函数返回时会设置该值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID
    * `JVMTI_ERROR_NATIVE_METHOD`: 参数`method`是本地方法
    * `JVMTI_ERROR_NULL_POINTER`: 参数`size_ptr`为`NULL`

<a name="2.6.14.6"></a>
#### 2.6.14.6 GetLineNumberTable

    ```c
    jvmtiError GetLineNumberTable(jvmtiEnv* env, jmethodID method, jint* entry_count_ptr, jvmtiLineNumberEntry** table_ptr)
    ```

其中参数`jvmtiLineNumberEntry`的定义如下：

    ```c
    typedef struct {
        jlocation start_location;
        jint line_number;
    } jvmtiLineNumberEntry;
    ```

字段定义如下：

* `start_location`: 类型为`jlocation`，表示当前源代码行的起始位置
* `line_number`: 类型为`jint`，表示行号

该方法与用于获取目标方法的源代码行号记录表。表的大小通过参数`entry_count_ptr`返回，表本身通过参数`table_ptr`返回。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 70
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_get_line_numbers`: 是否能目标方法的行号记录表
* 参数：
    * `method`: 类型为`jmethod`，目标方法
    * `entry_count_ptr`: 类型为`jint*`，出参，用于返回源代码行号记录中记录项的个数
    * `table_ptr`: 
        * 类型为`jvmtiLineNumberEntry**`，出参，用于返回源代码行号记录表
        * 函数返回时会创建一个长度为`entry_count_ptr`的数组，必须通过函数`Deallocate`释放
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_get_line_numbers`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_ABSENT_INFORMATION`: 类信息不包含行号记录表
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID
    * `JVMTI_ERROR_NATIVE_METHOD`: 参数`method`是本地方法
    * `JVMTI_ERROR_NULL_POINTER`: 参数`entry_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`table_ptr`为`NULL`

<a name="2.6.14.7"></a>
#### 2.6.14.7 GetMethodLocation

    ```c
    jvmtiError GetMethodLocation(jvmtiEnv* env, jmethodID method, jlocation* start_location_ptr, jlocation* end_location_ptr)
    ```

该方法用于获取目标方法的起止地址和结束地址，分别以出参`start_location_ptr`和`end_location_ptr`返回。在传统的字节码索引方式中，`start_location_ptr`指向的值总是0，`end_location_ptr`指向的值总是字节码数量减一。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 71
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `method`: 类型为`jmethod`，目标方法
    * `start_location_ptr`: 
        * 类型为`jlocation*`，出参，用于方法的起始位置
        * 若无法获取方法位置信息，则返回`-1`
        * 若可以获取方法位置信息，且函数`GetJLocationFormat`返回`JVMTI_JLOCATION_JVMBCI`，则该值始终为`0`
    * `end_location_ptr`: 
        * 类型为`jlocation*`，出参，用于方法的结束位置
        * 若无法获取方法位置信息，则返回`-1`
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_ABSENT_INFORMATION`: 类信息不包含方法大小
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID
    * `JVMTI_ERROR_NATIVE_METHOD`: 参数`method`是本地方法
    * `JVMTI_ERROR_NULL_POINTER`: 参数`start_location_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`end_location_ptr`为`NULL`

<a name="2.6.14.8"></a>
#### 2.6.14.8 GetLocalVariableTable

    ```c
    jvmtiError GetLocalVariableTable(jvmtiEnv* env, jmethodID method, jint* entry_count_ptr, jvmtiLocalVariableEntry** table_ptr)
    ```

其中参数`jvmtiLocalVariableEntry`的定义如下：

    ```c
    typedef struct {
        jlocation start_location;
        jint length;
        char* name;
        char* signature;
        char* generic_signature;
        jint slot;
    } jvmtiLocalVariableEntry;
    ```

其中字段含义如下：

* `start_location`: 类型为`jlocation`，表示局部变量在代码的什么位置首次生效，即在什么位置开始必须有值
* `length`: 类型为`jint`，表示该局部变量的有效区域的长度，即局部变量有效区域的结束位置为`start_location + length`
* `name`: 类型为`char*`，表示局部变量的名字，使用自定义UTF-8编码
* `signature`: 类型为`char*`，表示局部变量的类型签名，使用自定义UTF-8编码，签名的格式参见[JVM规范4.3.2节][147]
* `generic_signature`: 类型为`char*`，表示局部变量的泛型类型签名，使用自定义UTF-8编码，若局部变量没有泛型，则该值为`NULL`
* `slot`: 类型为`jint`，表示局部变量的槽

该方法用于获取局部变量信息。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 72
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_access_local_variables`: 是否能获取/设置局部变量
* 参数：
    * `method`: 类型为`jmethodID`，目标方法
    * `entry_count_ptr`: 
        * 类型为`jint*`，出参，表示局部变量表的大小
        * JVMTI代理需要传入指向`jint`的指针，函数返回时会设置该值
    * `table_ptr`:
        * 类型为`jvmtiLocalVariableEntry**`，出参，表示局部变量表的额内容
        * JVMTI需要传入指向`jvmtiLocalVariableEntry*`的指针，函数返回时，会创建一个长度为`*entry_count_ptr`的数组，需要调用函数`Deallocate`显式释放
        * `jvmtiLocalVariableEntry->name`所指的内容也是新创建的数组，需要调用函数`Deallocate`显式释放
        * `jvmtiLocalVariableEntry->signature`所指的内容也是新创建的数组，需要调用函数`Deallocate`显式释放
        * `jvmtiLocalVariableEntry->generic_signature`所指的内容也是新创建的数组，需要调用函数`Deallocate`显式释放
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_access_local_variables`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_ABSENT_INFORMATION`: 类信息中不包含局部变量信息
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID
    * `JVMTI_ERROR_NATIVE_METHOD`: 参数`method`是本地方法
    * `JVMTI_ERROR_NULL_POINTER`: 参数`entry_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`table_ptr`为`NULL`

<a name="2.6.14.9"></a>
#### 2.6.14.9 GetBytecodes

    ```c
    jvmtiError GetBytecodes(jvmtiEnv* env, jmethodID method, jint* bytecode_count_ptr, unsigned char** bytecodes_ptr)
    ```

该函数用于获取目标方法的字节码，字节码的数量以出参`bytecode_count_ptr`返回，字节码的内容以出参`bytecodes_ptr`返回。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 75
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_get_bytecodes`: 是否能获取字节码
* 参数：
    * `method`: 类型为`jmethodID`，目标方法
    * `bytecode_count_ptr`: 
        * 类型为`jint*`，出参，表示字节码数组的长度
        * JVMTI代理需要传入指向`jint`的指针，函数返回时会设置该值
    * `bytecodes_ptr`:
        * 类型为`unsigned char**`，出参，表示字节码内容本身
        * JVMTI需要传入指向`unsigned char*`的指针，函数返回时，会创建一个长度为`*bytecode_count_ptr`的数组，需要调用函数`Deallocate`显式释放
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_get_bytecodes`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID
    * `JVMTI_ERROR_NATIVE_METHOD`: 参数`method`是本地方法
    * `JVMTI_ERROR_NULL_POINTER`: 参数`bytecode_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`bytecodes_ptr`为`NULL`

<a name="2.6.14.10"></a>
#### 2.6.14.10 IsMethodNative

    ```c
    jvmtiError IsMethodNative(jvmtiEnv* env, jmethodID method, jboolean* is_native_ptr)
    ```

该函数用于判断目标方法是否是本地方法。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 76
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `method`: 类型为`jmethodID`，目标方法
    * `is_native_ptr`: 
        * 类型为`jboolean*`，出参，表示目标方法是否是本地方法
        * JVMTI代理需要传入指向`jboolean`的指针，函数返回时会设置该值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID
    * `JVMTI_ERROR_NULL_POINTER`: 参数`is_native_ptr`为`NULL`

<a name="2.6.14.11"></a>
#### 2.6.14.11 IsMethodSynthetic

    ```c
    jvmtiError IsMethodSynthetic(jvmtiEnv* env, jmethodID method, jboolean* is_synthetic_ptr)
    ```

该函数用于判断目标方法是否是合成构造的，以出参`is_synthetic_ptr`返回。合成构造的方法是指由编译器生成的，而非存在于源代码中的。

* 调用阶段： 只可能在`live`或`start`阶段调用
* 回调安全： 无
* 索引位置： 77
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_get_synthetic_attribute`: 是否能测试方法/属性是否是合成构造的，参见函数`IsFieldSynthetic`和`IsMethodSynthetic`
* 参数：
    * `method`: 类型为`jmethodID`，目标方法
    * `is_synthetic_ptr`: 
        * 类型为`jboolean*`，出参，表示目标方法是否是合成构造的
        * JVMTI代理需要传入指向`jint`的指针，函数返回时会设置该值
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`is_synthetic_ptr`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_INVALID_METHODID`: 参数`method`不是方法ID
    * `JVMTI_ERROR_NULL_POINTER`: 参数`is_synthetic_ptr`为`NULL`

<a name="2.6.14.13"></a>
#### 2.6.14.13 SetNativeMethodPrefix

    ```c
    jvmtiError SetNativeMethodPrefix(jvmtiEnv* env, const char* prefix)
    ```

该函数可用于修改解析本地方法的错误处理方式，该函数可以设置方法名的前缀，然后进行重试。当使用事件`ClassFileLoadHook`时，可以对本地方法进行增强。

由于本地方法不能直接被增强(因为本地方法没有字节码)，因此必须将本地方法包装为一个非本地方法来执行增强操作。假设现在有如下本地方法：

    native boolean foo(int x);

，可以将类文件(事件`ClassFileLoadHook`)转换为以下形式：

    ```c
    boolean foo(int x) {
        ... record entry to foo ...
        return wrapped_foo(x);
    }

    native boolean wrapped_foo(int x);
    ```

这样，原先的本地函数`foo`变为了包装函数`foo`，真正的函数以前缀`wrapped_`开头。注意，使用`wrapped_`作为前缀是个糟糕的选择，因为应用程序开发者有可能会定义以`wrapped_`开头的方法，进而造成方法冲突。比较好的命名时类似`$$$MyAgentWrapped$$$_`这样的，虽然可读性不好，但不会有命名冲突。

包装方法可以在调用本地方法前收集相关数据，目前的问题就是，如何将被包装的方法和本地实现链接起来，即方法`wrapped_foo`需要被解析为本地实现`foo`，例如：

    ```c
    Java_somePackage_someClass_foo(JNIEnv* env, jint x)
    ```

该函数可以指定前缀和解析方式。特别的，当标准解析失败时，可以通过添加前缀的方式重试解析。有两种解析方式，通过JNI函数`RegisterNatives`的显式解析和普通的自动解析。

使用函数`RegisterNatives`显式解析时，JVM会尝试如下关联：

    ```c
    method(foo) -> nativeImplementation(foo)
    ```

当这种方式失败时，则添加前缀，进行重试：

    ```c
    method(wrapped_foo) -> nativeImplementation(foo)
    ```

使用自动解析时，JVM会尝试如下关联：

    ```c
    method(wrapped_foo) -> nativeImplementation(wrapped_foo)
    ```

当这种方式失败时，则删除前缀，进行重试：

    ```c
    method(wrapped_foo) -> nativeImplementation(foo)
    ```

注意，由于前缀只在标准解析失败时使用，因此可以有选择的对本地方法进行包装。

每个JVMTI的执行环境都是独立的，可以独立进行字节码转换，因此可以进行多层包装，每个执行环境都有其自己的前缀。由于字节码转换是按顺序执行的，因此如果要应用前缀的话，则需要按相同的顺序应用。转换应用程序的顺序参见事件`ClassFileLoadHook`的描述。如果3个JVMTI执行环境要应用包装，则函数`foo`可能会变成`$env3_$env2_$env1_foo`。但如果说，第2个执行环境没有对函数`foo`进行包装，则函数`foo`可能会变成`$env3_$env1_foo`。如果存在非本地方法包装时，为了能够高效的确定前缀的序列，会使用中间前缀。因此，在上面的例子中，即时`$env1_foo`不是本地方法，也会应用前缀`$env1_`。

由于前缀是在解析时使用的，而且解析可能会被延期执行，因此只要还存在相关联的、带有前缀的本地方法，就必须设置本地方法前缀。

* 调用阶段： 可能在任意阶段调用
* 回调安全： 无
* 索引位置： 73
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_set_native_method_prefix`: 当解析本地方法失败时，是否能应用前缀，参见方法`SetNativeMethodPrefix`和`SetNativeMethodPrefixes`
* 参数：
    * `prefix`: 
        * 类型为`const char *`，要应用的前缀，使用自定义UTF-8编码
        * JVMTI代理需要传入`char`类型的数组，若参数`prefix`为`NULL`，则会撤销JVMTI执行环境中已存在的所有前缀
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_set_native_method_prefix`，需要调用`AddCapabilities`

<a name="2.6.14.14"></a>
#### 2.6.14.14 SetNativeMethodPrefixes

    ```c
    jvmtiError SetNativeMethodPrefixes(jvmtiEnv* env, jint prefix_count, char** prefixes)
    ```

对于普通的JVMTI代理来说，函数`SetNativeMethodPrefixes`会提供所有需要的本地方法的前缀。对于元代理，即执行多个独立类文件转换的代理(例如，作为另一层JVMTI代理的代理)，该函数可以使每次转换都有其独立的前缀。前缀的应用顺序由参数`prefixes`指定。

使用该函数后，之前所设置的前缀都会被替换掉，因此，若参数`prefix_count`为`0`，则会在目标JVMTI执行环境中禁用前缀。

函数`SetNativeMethodPrefix`和该函数均可用于设置前缀，调用函数`SetNativeMethodPrefix`时，相当于以参数`prefix_count`为`1`调用函数`SetNativeMethodPrefixes`。以参数值`NULL`调用函数`SetNativeMethodPrefix`时，相当于以参数`prefix_count`为`0`调用函数`SetNativeMethodPrefixes`。

* 调用阶段： 可能在任意阶段调用
* 回调安全： 无
* 索引位置： 73
* Since： 1.1
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_set_native_method_prefix`: 当解析本地方法失败时，是否能应用前缀，参见方法`SetNativeMethodPrefix`和`SetNativeMethodPrefixes`
* 参数：
    * `prefix_count`: 类型为`jint`，要应用的前缀的数量
    * `prefixes`: 
        * 类型为`char **`，要应用的前缀，使用自定义UTF-8编码
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 执行环境无法处理功能`can_set_native_method_prefix`，需要调用`AddCapabilities`
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`prefix_count`为`0`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`prefixes`为`NULL`

<a name="2.6.15"></a>
### 2.6.15 原始监视器

原始监视器相关的函数包括：

* [2.6.15.1 CreateRawMonitor][182]
* [2.6.15.2 DestroyRawMonitor][183]
* [2.6.15.3 RawMonitorEnter][184]
* [2.6.15.4 RawMonitorExit][185]
* [2.6.15.5 RawMonitorWait][186]
* [2.6.15.6 RawMonitorNotify][187]
* [2.6.15.7 RawMonitorNotifyAll][188]

<a name="2.6.15.1"></a>
#### 2.6.15.1 CreateRawMonitor

    ```c
    jvmtiError CreateRawMonitor(jvmtiEnv* env, const char* name, jrawMonitorID* monitor_ptr)
    ```

该函数用于创建一个原始监视器。

* 调用阶段： 只能在`OnLoad`阶段或`live`阶段调用
* 回调安全： 可以在堆迭代的回调函数中调用该函数，或是在事件`GarbageCollectionStart` `GarbageCollectionFinish`或`ObjectFree`的处理函数中调用
* 索引位置： 31
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `name`: 
        * 类型为`const char*`，用于标识监视器的名字，使用自定义UTF-8编码
        * JVMTI代理需要传入一个字符数组
    * `monitor_ptr`: 
        * 类型为`jrawMonitorID*`，出参，返回新创建的监视器
        * JVMTI代理需要传入一个指向`jrawMonitorID`的指针
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NULL_POINTER`: 参数`name`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`monitor_ptr`为`NULL`

<a name="2.6.15.2"></a>
#### 2.6.15.2 DestroyRawMonitor

    ```c
    jvmtiError DestroyRawMonitor(jvmtiEnv* env, jrawMonitorID monitor)
    ```

该函数用于销毁一个原始监视器。若当前线程已经进入了目标监视器，则在销毁监视器之前，会先使当前线程退出目标监视器。若已经有其他线程进入了目标监视器，则会抛出错误，且不会销毁目标监视器。

* 调用阶段： 只能在`OnLoad`阶段或`live`阶段调用
* 回调安全： 可以在堆迭代的回调函数中调用该函数，或是在事件`GarbageCollectionStart` `GarbageCollectionFinish`或`ObjectFree`的处理函数中调用
* 索引位置： 32
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `monitor`: 
        * 类型为`jrawMonitorID`，目标监视器
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NOT_MONITOR_OWNER`: 当前线程并不持有目标监视器
    * `JVMTI_ERROR_INVALID_MONITOR`: 参数`monitor`为不是监视器对象

<a name="2.6.15.3"></a>
#### 2.6.15.3 RawMonitorEnter

    ```c
    jvmtiError RawMonitorEnter(jvmtiEnv* env, jrawMonitorID monitor)
    ```

该函数用于获取一个原始监视器，具有排他性。同一个线程可以多次获取同一个监视器，此时线程退出监视器的次数必须与获取监视器的次数相同。若监视器是在`OnLoad`阶段获取的(即在JVMTI连接线程退出之前)，而且在JVMTI连接线程退出时还没有退出监视器，则认为该监视器是在主线程获取的。

* 调用阶段： 只能在`OnLoad`阶段或`live`阶段调用
* 回调安全： 可以在堆迭代的回调函数中调用该函数，或是在事件`GarbageCollectionStart` `GarbageCollectionFinish`或`ObjectFree`的处理函数中调用
* 索引位置： 33
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `monitor`: 
        * 类型为`jrawMonitorID`，目标监视器
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_MONITOR`: 参数`monitor`为不是监视器对象

<a name="2.6.15.4"></a>
#### 2.6.15.4 RawMonitorExit

    ```c
    jvmtiError RawMonitorExit(jvmtiEnv* env, jrawMonitorID monitor)
    ```

该函数用于退出一个已经获取到的、排他性的原始监视器。

* 调用阶段： 只能在`OnLoad`阶段或`live`阶段调用
* 回调安全： 可以在堆迭代的回调函数中调用该函数，或是在事件`GarbageCollectionStart` `GarbageCollectionFinish`或`ObjectFree`的处理函数中调用
* 索引位置： 34
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `monitor`: 
        * 类型为`jrawMonitorID`，目标监视器
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NOT_MONITOR_OWNER`: 当前线程并不持有目标监视器
    * `JVMTI_ERROR_INVALID_MONITOR`: 参数`monitor`为不是监视器对象

<a name="2.6.15.5"></a>
#### 2.6.15.5 RawMonitorWait

    ```c
    jvmtiError RawMonitorWait(jvmtiEnv* env, jrawMonitorID monitor, jlong millis)
    ```

该函数用于等待目标监视器的唤醒通知。

该函数会使当前线程进入等待状态，直到其他线程在目标监视器上调用函数`RawMonitorNotify`或`RawMonitorNotifyAll`，或是等待时间超时。

* 调用阶段： 只能在`OnLoad`阶段或`live`阶段调用
* 回调安全： 可以在堆迭代的回调函数中调用该函数，或是在事件`GarbageCollectionStart` `GarbageCollectionFinish`或`ObjectFree`的处理函数中调用
* 索引位置： 35
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `monitor`: 
        * 类型为`jrawMonitorID`，目标监视器
    * `millis`:
        * 类型为`jlong`，等待超时时间，单位为毫秒，若参数值为`0`，表示永远等待，直到其他线程调用了通知方法
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NOT_MONITOR_OWNER`: 当前线程并不持有目标监视器
    * `JVMTI_ERROR_INTERRUPT`: 等待状态被中断，重试
    * `JVMTI_ERROR_INVALID_MONITOR`: 参数`monitor`为不是监视器对象

<a name="2.6.15.6"></a>
#### 2.6.15.6 RawMonitorNotify

    ```c
    jvmtiError RawMonitorNotify(jvmtiEnv* env, jrawMonitorID monitor)
    ```

该函数用于唤醒等待在目标监视器上的某个线程。

* 调用阶段： 只能在`OnLoad`阶段或`live`阶段调用
* 回调安全： 可以在堆迭代的回调函数中调用该函数，或是在事件`GarbageCollectionStart` `GarbageCollectionFinish`或`ObjectFree`的处理函数中调用
* 索引位置： 36
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `monitor`: 
        * 类型为`jrawMonitorID`，目标监视器
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NOT_MONITOR_OWNER`: 当前线程并不持有目标监视器
    * `JVMTI_ERROR_INVALID_MONITOR`: 参数`monitor`为不是监视器对象

<a name="2.6.15.7"></a>
#### 2.6.15.7 RawMonitorNotifyAll

    ```c
    jvmtiError RawMonitorNotifyAll(jvmtiEnv* env, jrawMonitorID monitor)
    ```

该函数用于唤醒等待在目标监视器上的所有线程。

* 调用阶段： 只能在`OnLoad`阶段或`live`阶段调用
* 回调安全： 可以在堆迭代的回调函数中调用该函数，或是在事件`GarbageCollectionStart` `GarbageCollectionFinish`或`ObjectFree`的处理函数中调用
* 索引位置： 37
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `monitor`: 
        * 类型为`jrawMonitorID`，目标监视器
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NOT_MONITOR_OWNER`: 当前线程并不持有目标监视器
    * `JVMTI_ERROR_INVALID_MONITOR`: 参数`monitor`为不是监视器对象

<a name="2.6.16"></a>
### 2.6.16 JNI方法拦截

JNI方法拦截包括一下函数：

* [2.6.16.1 SetJNIFunctionTable][189]
* [2.6.16.2 GetJNIFunctionTable][190]

这个系列的函数用于获取/重置JNI函数表。下面的代码展示了如何通过重置JNI函数表来统计引用创建的数量。

    ```c
    JNIEnv original_jni_Functions;
    JNIEnv redirected_jni_Functions;
    int my_global_ref_count = 0;

    jobject
    MyNewGlobalRef(JNIEnv *jni_env, jobject lobj) {
        ++my_global_ref_count;
        return originalJNIFunctions->NewGlobalRef(env, lobj);
    }

    void
    myInit() {
        jvmtiError err;

        err = (*jvmti_env)->GetJNIFunctionTable(jvmti_env, &original_jni_Functions);
        if (err != JVMTI_ERROR_NONE) {
            die();
        }
        err = (*jvmti_env)->GetJNIFunctionTable(jvmti_env, &redirected_jni_Functions);
        if (err != JVMTI_ERROR_NONE) {
            die();
        }
        redirectedJNIFunctions->NewGlobalRef = MyNewGlobalRef;
            err = (*jvmti_env)->SetJNIFunctionTable(jvmti_env, redirected_jni_Functions);
        if (err != JVMTI_ERROR_NONE) {
            die();
        }
    }
    ```

在调用函数`myInit`之后，会执行用户代码`MyNewGlobalRef`完成全局引用的创建。注意，一般情况下会保留原始的JNI函数表，以便将来可以恢复。

<a name="2.6.16.1"></a>
#### 2.6.16.1 SetJNIFunctionTable

    ```c
    jvmtiError SetJNIFunctionTable(jvmtiEnv* env, const jniNativeInterface* function_table)
    ```

该函数用于设置新的JNI函数表。在设置目标函数之前，需要通过函数`GetJNIFunctionTable`获取已有的JNI函数表。由于参数`function_table`的定义是常量，某些编译器可能会优化对函数的访问，进而使新设置的函数无法生效。函数表是被拷贝的，因此，修改函数表的局部拷贝，是不会生效的。该函数只会影响JNI函数表，不会影响执行环境的其他部分。

* 调用阶段： 只能在`start`阶段或`live`阶段调用
* 回调安全： 无
* 索引位置： 120
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `function_table`: 
        * 类型为`const jniNativeInterface *`，指向新的JNI函数表，JVMTI代理需要传入指向`jniNativeInterface`的指针
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NULL_POINTER`: 参数`function_table`为不是监视器对象

<a name="2.6.16.2"></a>
#### 2.6.16.2 GetJNIFunctionTable

    ```c
    jvmtiError GetJNIFunctionTable(jvmtiEnv* env, jniNativeInterface** function_table)
    ```

该函数用于获取JNI函数表。JNI函数表会被拷贝到分配的内存中。如果已经调用了函数`SetJNIFunctionTable`，则会返回修改后的JNI函数表。该函数只会拷贝函数表，对执行环境的其他部分没有影响。

* 调用阶段： 只能在`start`阶段或`live`阶段调用
* 回调安全： 无
* 索引位置： 121
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `function_table`: 
        * 类型为`jniNativeInterface **`，出参，`*function_table points`指向新创建的、拷贝了JNI函数表的内存
        * JVMTI代理需要传入指向`jniNativeInterface*`的指针，函数返回时会被赋值一个新创建的数组，该数组需要使用函数`Deallocate`来释放
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NULL_POINTER`: 参数`function_table`为不是监视器对象

<a name="2.6.17"></a>
### 2.6.17 事件管理

事件管理相关的函数包括：

* [2.6.17.1 SetEventCallbacks][191]
* [2.6.17.2 SetEventNotificationMode][192]
* [2.6.17.3 GenerateEvents][193]

<a name="2.6.17.1"></a>
#### 2.6.17.1 SetEventCallbacks

    ```c
    jvmtiError SetEventCallbacks(jvmtiEnv* env, const jvmtiEventCallbacks* callbacks, jint size_of_callbacks)
    ```

该函数用于设置目标事件的回调函数。新设置的回调函数数组会被拷贝到执行代码中，因此修改局部拷贝不会影响最终执行。该函数是原子操作，所有的回调函数都会被设置一次。在调用该函数之前，不会发送相应的事件。当回调函数数组为`NULL`，或者事件超过了`size_of_callbacks`的大熊啊，也不会发送相应的事件。对于事件的详细描述参见后文。若要发送目标事件，必须将之置为**启用**状态，并且为之设置回调函数，该函数和函数`SetEventNotificationMode`的调用顺序不影响最终结果。

* 调用阶段： 只能在`OnLoad`阶段或`live`阶段调用
* 回调安全： 无
* 索引位置： 122
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `callbacks`: 
        * 类型为`const jvmtiEventCallbacks*`，回调函数
        * JVMTI代理需要传入指向`jvmtiEventCallbacks`的指针，若该参数值为`NULL`，则会清除之前设置的回调函数
    * `size_of_callbacks`:
        * 类型为`jint`，`sizeof(jvmtiEventCallbacks)`，该参数为兼容其他版本而存在
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`size_of_callbacks`小于0

<a name="2.6.17.2"></a>
#### 2.6.17.2 SetEventNotificationMode

    ```c
    jvmtiError SetEventNotificationMode(jvmtiEnv* env, jvmtiEventMode mode, jvmtiEvent event_type, jthread event_thread,  ...)
    ```

其中，`jvmtiEventMode`的定义如下：

    ```c
    typedef enum {
        JVMTI_ENABLE = 1,
        JVMTI_DISABLE = 0
    } jvmtiEventMode;
    ```

若参数`thread`为`NULL`，则会对目标事件做全局处理，即全局启用或全局禁用，否则只会在目标线程内生效。若某类事件是在线程层面或全局层面启用的，则会对相应的线程产生事件。

该函数无法在线程层面设置以下事件的模式：

* VMInit
* VMStart
* VMDeath
* ThreadStart
* CompiledMethodLoad
* CompiledMethodUnload
* DynamicCodeGenerated
* DataDumpRequest

在初始的时候，无论是线程层面还是全局层面，事件都是未被启用的。

在调用该函数之前，需要先设置好所需的功能，对应关系如下所示：

    Capability	                                        Events
    can_generate_field_modification_events	            FieldModification 
    can_generate_field_access_events	                FieldAccess 
    can_generate_single_step_events	                    SingleStep 
    can_generate_exception_events	                    Exception ExceptionCatch 
    can_generate_frame_pop_events	                    FramePop 
    can_generate_breakpoint_events	                    Breakpoint 
    can_generate_method_entry_events	                MethodEntry 
    can_generate_method_exit_events	                    MethodExit 
    can_generate_compiled_method_load_events	        CompiledMethodLoad CompiledMethodUnload 
    can_generate_monitor_events	                        MonitorContendedEnter MonitorContendedEntered MonitorWait MonitorWaited 
    can_generate_vm_object_alloc_events	                VMObjectAlloc 
    can_generate_native_method_bind_events	            NativeMethodBind 
    can_generate_garbage_collection_events	            GarbageCollectionStart GarbageCollectionFinish 
    can_generate_object_free_events	                    ObjectFree 


* 调用阶段： 只能在`OnLoad`阶段或`live`阶段调用
* 回调安全： 无
* 索引位置： 2
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `mode`: 
        * 类型为`jvmtiEventMode`，值为`JVMTI_ENABLE`或`JVMTI_DISABLE`
    * `event_type`:
        * 类型为`jvmtiEvent`，目标事件类型
    * `event_thread`:
        * 类型为`jthread`，目标线程，若为空，则表示在全局层面进行设置
    * `...`: 为将来扩展使用
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_INVALID_THREAD`: 参数`event_thread`不是线程对象
    * `JVMTI_ERROR_THREAD_NOT_ALIVE`: 参数参数`event_thread`所表示的线程对象不是存活状态，即已死或未启动
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 目标事件类型不能在线程层面进行控制
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 目标事件类型所需要的功能还未设置好
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`mode`不是`jvmtiEventMode`枚举值
    * `JVMTI_ERROR_INVALID_EVENT_TYPE`: 参数`event_type`不是`jvmtiEvent`对象

<a name="2.6.17.3"></a>
#### 2.6.17.3 GenerateEvents

    ```c
    jvmtiError GenerateEvents(jvmtiEnv* env, jvmtiEvent event_type)
    ```

该函数用于产生表示当前JVM状态的事件。例如，若参数`event_type`的值为`JVMTI_EVENT_COMPILED_METHOD_LOAD`，则会为每个当前已经编译过的方法发送`CompiledMethodLoad`事件。已经载入的方法和还未载入的方法，不会发送该事件。事件发送历史不会影响由该函数发送的事件，例如，每次调用该方法时，所有当前编译的方法都会发送事件。

当JVMTI代理是在应用程序开始运行之后才连接时，可能会错过某些事件，此时可以通过该函数来重新发送目标事件。

执行Java代码或JNI函数时，可能会被暂停住，因此不应该在发送事件的线程中调用Java代码或JNI函数。只有在错误的事件都发送、处理和完成后，该函数才会退出。事件可能会被发送的其他线程来处理。事件的回调函数必须通过函数`SetEventCallbacks`来设置，并且通过函数`SetEventNotificationMode`将事件启用，所则不会发送事件。若JVM没有目标事件相关的信息，就不会发送事件了，也不会返回错误。

该函数仅支持以下事件：

* CompiledMethodLoad
* DynamicCodeGenerated

相关参数信息如下：

* 调用阶段： 只可能在`live`阶段调用
* 回调安全： 无
* 索引位置： 123
* Since： 1.0
* 功能： 
    * 可选，JVM可能不会实现该功能。若要使用该功能，则下面的属性必须为真
        * `can_generate_compiled_method_load_events	`: 是否能生成方法被编译或卸载的事件
* 参数：
    * `event_type`: 类型为`jvmtiEvent`，目标事件类型，仅支持`CompiledMethodLoad`或`DynamicCodeGenerated`
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_MUST_POSSESS_CAPABILITY`: 参数`event_type`为`CompiledMethodLoad`，且`can_generate_compiled_method_load_events`为`false`
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT`: 参数`event_type`的值不是`CompiledMethodLoad`或`DynamicCodeGenerated`
    * `JVMTI_ERROR_INVALID_EVENT_TYPE`: 参数`event_type`不是`jvmtiEvent`对象

<a name="2.6.18"></a>
### 2.6.18 扩展机制

扩展函数的类型包括：

* [2.6.18.1 jvmtiExtensionFunction][194]
* [2.6.18.2 jvmtiExtensionEvent][195]

扩展机制包括的函数有：

* [2.6.18.3 GetExtensionFunctions][196]
* [2.6.18.4 GetExtensionEvents][197]
* [2.6.18.5 SetExtensionEventCallback][198]

这些函数使JVMTI代理能够提供本文未定义的事件和函数。

扩展函数和扩展事件都包含有参数`type`和`kind`，其取值如下所示：


            Extension Function/Event Parameter Types (jvmtiParamTypes)
    Constant	                Value	    Description
    JVMTI_TYPE_JBYTE	        101	        Java语言中的原生类型byte，JNI类型为jbyte
    JVMTI_TYPE_JCHAR	        102	        Java语言中的原生类型char，JNI类型为jchar
    JVMTI_TYPE_JSHORT	        103	        Java语言中的原生类型short，JNI类型为jshort
    JVMTI_TYPE_JINT	            104	        Java语言中的原生类型int，JNI类型为jint
    JVMTI_TYPE_JLONG	        105	        Java语言中的原生类型long，JNI类型为jlong
    JVMTI_TYPE_JFLOAT	        106	        Java语言中的原生类型float，JNI类型为jfloat
    JVMTI_TYPE_JDOUBLE	        107	        Java语言中的原生类型double，JNI类型为jdouble
    JVMTI_TYPE_JBOOLEAN	        108	        Java语言中的原生类型boolean，JNI类型为jboolean
    JVMTI_TYPE_JOBJECT	        109	        Java语言中的对象类型java.lang.Object，JNI类型为jobject，返回值为JNI局部引用，必须管理起来
    JVMTI_TYPE_JTHREAD	        110	        Java语言中的对象类型java.lang.Thread，JNI类型为jthread，返回值为JNI局部引用，必须管理起来
    JVMTI_TYPE_JCLASS	        111	        Java语言中的对象类型java.lang.Class，JNI类型为jclass，返回值为JNI局部引用，必须管理起来
    JVMTI_TYPE_JVALUE	        112	        Java语言中原生类型和对象类型的联合，JNI类型为jvalue，返回值为对象类型的是JNI局部引用，必须管理起来
    JVMTI_TYPE_JFIELDID	        113	        Java语言中的属性标识符，JNI类型为jfieldID
    JVMTI_TYPE_JMETHODID	    114	        Java语言中的方法标识符，JNI类型为jmethodID
    JVMTI_TYPE_CCHAR	        115	        C语言中的类型，char
    JVMTI_TYPE_CVOID	        116	        C语言中的类型，void
    JVMTI_TYPE_JNIENV	        117	        JNI执行环境，JNIEnv，与正确的jvmtiParamKind值使用才能成为指针类型


            Extension Function/Event Parameter Kinds (jvmtiParamKind)
    Constant	                Value	    Description
    JVMTI_KIND_IN	            91	        忽略参数，foo
    JVMTI_KIND_IN_PTR	        92	        忽略指针参数，const foo*
    JVMTI_KIND_IN_BUF	        93	        忽略数组参数，const foo*
    JVMTI_KIND_ALLOC_BUF	    94	        出参分配数组，foo*，使用函数Deallocate使用
    JVMTI_KIND_ALLOC_ALLOC_BUF	95	        出参分配数组的数组，foo***，使用函数Deallocate释放
    JVMTI_KIND_OUT	            96	        出参，foo*
    JVMTI_KIND_OUT_BUF	        97	        出参为JVMTI代理分配的数组，foo*，无需使用函数Deallocate释放

`jvmtiParamInfo`的定义如下：

    ```c
    typedef struct {
        char* name;
        jvmtiParamKind kind;
        jvmtiParamTypes base_type;
        jboolean null_ok;
    } jvmtiParamInfo;
    ```

其字段含义如下：

* `name`: 类型为`char*`，参数名，以自定义UTF-8编码
* `kind`: 类型为`jvmtiParamKind`，表示参数类型
* `base_type`: 类型为`jvmtiParamTypes`，表示参数的基本类型
* `null_ok`: 类型为`jboolean`，表示参数值是否可以为`NULL`，只对指针类型和对象类型有效

<a name="2.6.18.1"></a>
#### 2.6.18.1 jvmtiExtensionFunction

    ```c
    typedef jvmtiError (JNICALL *jvmtiExtensionFunction) (jvmtiEnv* jvmti_env, ...);
    ```

该类型为扩展函数的具体实现。

* `jvmti_env`: 类型为`jvmtiEnv*`，JVMTI执行环境
* `...`: 类型为`...`，扩展函数的具体

<a name="2.6.18.2"></a>
#### 2.6.18.2 jvmtiExtensionEvent

    ```c
    typedef void (JNICALL *jvmtiExtensionEvent)(jvmtiEnv* jvmti_env, ...);
    ```

扩展事件的具体实现。事件处理函数通过函数`SetExtensionEventCallback`来设置。

扩展事件的事件处理函数必须声明匹配该该定义的可变参数。若不遵守的话，在某些平台上可能会导致调用约定不匹配和未定义错误。

例如，若函数`GetExtensionEvents`返回的`jvmtiParamInfo`指定了要有一个`jint`参数，则事件处理函数必须声明为：

    ```c
    void JNICALL myHandler(jvmtiEnv* jvmti_env, jint myInt, ...)
    ```

* `jvmti_env`: 类型为`jvmtiEnv*`，JVMTI执行环境
* `...`: 类型为`...`，扩展事件的具体

<a name="2.6.18.3"></a>
#### 2.6.18.3 GetExtensionFunctions

    ```c
    jvmtiError GetExtensionFunctions(jvmtiEnv* env, jint* extension_count_ptr, jvmtiExtensionFunctionInfo** extensions)
    ```

该函数用于获取扩展函数集合。

其中`jvmtiExtensionFunctionInfo`的定义如下：

    ```c
    typedef struct {
        jvmtiExtensionFunction func;
        char* id;
        char* short_description;
        jint param_count;
        jvmtiParamInfo* params;
        jint error_count;
        jvmtiError* errors;
    } jvmtiExtensionFunctionInfo;
    ```

其字段含义如下：

* `func`: 实际调用的函数
* `id`: 扩展函数的标识符，使用自定义UTF-8编码，通常会使用包名，例如`com.sun.hotspot.bar`
* `short_description`: 函数描述，使用自定义UTF-8编码
* `param_count`: 除了`jvmtiEnv *jvmti_env`以外的参数个数
* `params`: 除了`jvmtiEnv *jvmti_env`以外的参数数组
* `error_count`: 除了通用错误码之外函数可能返回的错误码个数
* `errors`: 除了通用错误码之外函数可能返回的错误码数组

函数相关参数信息如下：

* 调用阶段： 只可能在`live`或`OnLoad`阶段调用
* 回调安全： 无
* 索引位置： 124
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `extension_count_ptr`: 类型为`jint*`，出参，返回扩展函数的数量，JVMTI代理需要提供指向`jint`的指针
    * `extensions`:
        * 类型为`jvmtiExtensionFunctionInfo**`，出参，返回扩展函数数组
        * JVMTI代理需要提供指向`jvmtiExtensionFunctionInfo*`的指针，该函数会创建一个长度为`extension_count_ptr`的数组并返回，需要调用函数`Deallocate`显式释放，对于每个数组元素：
            * `jvmtiExtensionFunctionInfo.id`指向的也是新创建的数组，需要调用函数`Deallocate`显式释放
            * `jvmtiExtensionFunctionInfo.short_description`指向的也是新创建的数组，需要调用函数`Deallocate`显式释放
            * `jvmtiExtensionFunctionInfo.params`指向的也是新创建的数组，需要调用函数`Deallocate`显式释放，对于其中的每个参数：
                * `jvmtiExtensionFunctionInfo.params.name`指向的也是新创建的数组，需要调用函数`Deallocate`显式释放
            * `jvmtiExtensionFunctionInfo.errors`指向的也是新创建的数组，需要调用函数`Deallocate`显式释放，
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NULL_POINTER`: 参数`extension_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`extensions`为`NULL`

<a name="2.6.18.4"></a>
#### 2.6.18.4 GetExtensionEvents

    ```c
    jvmtiError GetExtensionEvents(jvmtiEnv* env, jint* extension_count_ptr, jvmtiExtensionEventInfo** extensions)
    ```

该函数用于获取扩展事件集合。

其中`jvmtiExtensionEventInfo`的定义如下：

    ```c
    typedef struct {
        jint extension_event_index;
        char* id;
        char* short_description;
        jint param_count;
        jvmtiParamInfo* params;
    } jvmtiExtensionEventInfo;
    ```

其字段含义如下：

* `extension_event_index`: 事件的索引标识
* `id`: 扩展事件的标识符，使用自定义UTF-8编码，通常会使用包名，例如`com.sun.hotspot.bar`
* `short_description`: 函数描述，使用自定义UTF-8编码
* `param_count`: 除了`jvmtiEnv *jvmti_env`以外的参数个数
* `params`: 除了`jvmtiEnv *jvmti_env`以外的参数数组

函数相关参数信息如下：

* 调用阶段： 只可能在`live`或`OnLoad`阶段调用
* 回调安全： 无
* 索引位置： 125
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `extension_count_ptr`: 类型为`jint*`，出参，返回扩展事件的数量，JVMTI代理需要提供指向`jint`的指针
    * `extensions`:
        * 类型为`jvmtiExtensionEventInfo**`，出参，返回扩展函数数组
        * JVMTI代理需要提供指向`jvmtiExtensionEventInfo*`的指针，该函数会创建一个长度为`extension_count_ptr`的数组并返回，需要调用函数`Deallocate`显式释放，对于每个数组元素：
            * `jvmtiExtensionEventInfo.id`指向的也是新创建的数组，需要调用函数`Deallocate`显式释放
            * `jvmtiExtensionEventInfo.short_description`指向的也是新创建的数组，需要调用函数`Deallocate`显式释放
            * `jvmtiExtensionEventInfo.params`指向的也是新创建的数组，需要调用函数`Deallocate`显式释放，对于其中的每个参数：
                * `jvmtiExtensionFunctionInfo.params.name`指向的也是新创建的数组，需要调用函数`Deallocate`显式释放
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_NULL_POINTER`: 参数`extension_count_ptr`为`NULL`
    * `JVMTI_ERROR_NULL_POINTER`: 参数`extensions`为`NULL`

<a name="2.6.18.5"></a>
#### 2.6.18.5 SetExtensionEventCallback

    ```c
    jvmtiError SetExtensionEventCallback(jvmtiEnv* env, jint extension_event_index, jvmtiExtensionEvent callback)
    ```

该函数用设置扩展事件的回调函数，并启用该扩展事件。若参数`callback`为`NULL`，则会禁用目标事件。注意，与标准事件不同，设置并启用扩展事件是一个操作。

* 调用阶段： 只可能在`live`或`OnLoad`阶段调用
* 回调安全： 无
* 索引位置： 126
* Since： 1.0
* 功能： 
    * 必选
* 参数：
    * `extension_event_index`: 类型为`jint`，指定要对哪个事件设置回调函数，该值与`jvmtiExtensionEventInfo.extension_event_index`相对应
    * `callback`:
        * 类型为`jvmtiExtensionEvent`，若该值不为`NULL`，则对目标事件设置回调函数，并启用事件，否则会禁用目标事件
* 返回：
    * 通用错误码 
    * `JVMTI_ERROR_ILLEGAL_ARGUMENT	`: 参数`extension_event_index`的值与由函数`GetExtensionEvents`返回的`extension_event_index`字段值不匹配

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
[103]:    #2.6.6.7
[104]:    #2.6.6.8
[105]:    #2.6.6.9
[106]:    #2.6.6.10
[107]:    #2.6.6.11
[108]:    #2.6.6.12
[109]:    #2.6.6.1
[110]:    #2.6.6.2
[111]:    #2.6.6.3
[112]:    #2.6.6.4
[113]:    #2.6.6.5
[114]:    #2.6.6.6
[115]:    #2.6.7.1
[116]:    #2.6.7.2
[117]:    #2.6.7.3
[118]:    #2.6.7.4
[119]:    #2.6.7.5
[120]:    #2.6.7.6
[121]:    #2.6.7.7
[122]:    #2.6.7.8
[123]:    #2.6.8.1
[124]:    #2.6.8.2
[125]:    #2.6.8.3
[126]:    #2.6.8.4
[127]:    #2.6.8.5
[128]:    #2.6.8.6
[129]:    #2.6.8.7
[130]:    #2.6.8.8
[131]:    #2.6.8.9
[132]:    #2.6.8.10
[133]:    #2.6.8.11
[134]:    #2.6.9.1
[135]:    #2.6.9.2
[136]:    #2.6.10.1
[137]:    #2.6.10.2
[138]:    #2.6.10.3
[139]:    #2.6.10.4
[140]:    #2.6.11.1
[141]:    https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-5.html#jvms-5.3
[142]:    #2.6.11.2
[143]:    #2.6.11.3
[144]:    #2.6.11.4
[145]:    #2.6.11.5
[146]:    #2.6.11.6
[147]:    https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html
[148]:    #2.6.11.7
[149]:    #2.6.11.8
[150]:    #2.6.11.9
[151]:    #2.6.11.10
[152]:    #2.6.11.11
[153]:    #2.6.11.12
[154]:    #2.6.11.13
[155]:    #2.6.11.14
[156]:    #2.6.11.15
[157]:    #2.6.11.16
[158]:    #2.6.11.17
[159]:    #2.6.11.18
[160]:    #2.6.12.1
[161]:    #2.6.12.2
[162]:    #2.6.12.3
[163]:    http://blog.caoxudong.info/blog/2017/10/11/jni_functions_note
[164]:    #2.6.13.1
[165]:    #2.6.13.2
[166]:    #2.6.13.3
[167]:    #2.6.13.4
[168]:    #2.6.14.1
[169]:    #2.6.14.2
[170]:    #2.6.14.3
[171]:    #2.6.14.4
[172]:    #2.6.14.5
[173]:    #2.6.14.6
[174]:    #2.6.14.7
[175]:    #2.6.14.8
[176]:    #2.6.14.9
[177]:    #2.6.14.10
[178]:    #2.6.14.11
[179]:    #2.6.14.12
[180]:    #2.6.14.13
[181]:    #2.6.14.14
[182]:    #2.6.15.1
[183]:    #2.6.15.2
[184]:    #2.6.15.3
[185]:    #2.6.15.4
[186]:    #2.6.15.5
[187]:    #2.6.15.6
[188]:    #2.6.15.7
[189]:    #2.6.16.1
[190]:    #2.6.16.2
[191]:    #2.6.17.1
[192]:    #2.6.17.2
[193]:    #2.6.17.3
[194]:    #2.6.18.1
[195]:    #2.6.18.2
[196]:    #2.6.18.3
[197]:    #2.6.18.4
[198]:    #2.6.18.5
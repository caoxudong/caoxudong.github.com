---
title:      Tomcat中通过NIO对HTTP请求的处理
layout:     post
category:   blog
tags:       [lambda, java, jvm]
---

>Tomcat版本 8.5.x
>
>[Tomcat的初始化流水账][1]

Tomcat中通过NIO对HTTP请求的处理，最终会落到[NioEndpoint][2]类来完成。

`NioEndpoint`在启动之后，会创建以下几个组件：

* `processorCache`: 包含了`SocketProcessor`实例的栈
* `eventCache`: 包含了`PollerEvent`实例的栈。
* `nioChannels`: 包含了`NioChannel`实例的栈。
* `executor`: 工作线程池`ThreadPoolExecutor`
* `pollers`: 轮询线程数组`Poller`
* `acceptors`: 用于接收请求连接的线程数组`Acceptor`

# processorCache

包含了`SocketProcessor`实例的栈，复用其中的对象，存储用来处理已接入的HTTP请求。这里之所以要复用对象，是为了免除GC操作。

`SocketProcessor`会调用`ConnectionHandler#process`方法处理已接入的请求，进而使用[`Http11Processor`][8]处理HTTP 1.1的请求。

# eventCache

一个包含了`PollerEvent`实例的栈，复用其中的对象，存储`Poller`要处理的事件。这里之所以要复用对象，是为了免除GC操作。

# nioChannels

包含了`NioChannel`实例的栈，复用其中的对象，表示一个要处理的NIO连接。这里之所以要复用对象，是为了免除GC操作。

`NioChannel`中组合了`SocketChannel`和`SocketBufferHandler`，可用于完成数据的读写操作。

# Acceptor

[Acceptor][3]

连接器，用于接收HTTP请求，完成最初的工作：

* 计算连接数，使用基于**AQS**的[`LimitLatch`][4]来计算已接入的连接，过超过线程，则排队等待
* 调用`ServerSocketChannel.accept()`获取一个连接
* 针对获取到的连接设置属性：
    * 将获取到的连接设置非阻塞属性，`socket.configureBlocking(false);`
    * 从`nioChannels`中复用/创建`NioChannel`实例
    * 将`NioChannel`实例以`PollerEvent`的形式注册到`pollers`中的线程，监听相应的事件
        * `Poller`线程的选择方式是轮询式
        * `PollerEvent`包含：
            * `NioSocket`实例
            * 新创建`NioSocketWrapper`实例，并注册`SelectionKey.OP_READ`事件
            * `NioEndpoint.OP_REGISTER`事件

# Poller

[Poller][5]

事件轮询器，所要做的工作主要是

* 轮询添加到`Poller`中的事件`PollerEvent`，加以处理
* 等待`selector`的返回，处理准备好的`selectKey`
* 处理超时事件

轮询添加到`Poller`中的事件`PollerEvent`，加以处理：

* 如果`PollerEvent`是事件类型是`NioEndPoint.OP_REGISTER`，则在selector上注册`SelectionKey.OP_READ`事件
* 如果`PollerEvent`不是事件类型是`NioEndPoint.OP_REGISTER`，则在当前`SelectionKey`上添加当前`PollerEvent`的事件类型
* 重置该`PollerEvent`事件

通过上述步骤完成对`Poller`中所有事件的处理，以便selector可以开始获取可用的事件。

等待`selector`的返回，处理准备好的`selectKey`：

* 如果是要发送文件的，则[NioEndpoint#processSendfile][6]方法处理
* 对于其他HTTP请求
    * 对`selectKey`取消注册当前的事件
    * 处理可读/可写事件，将请求包装为`SocketProcessorBase`实例，交给`executor`来执行
    * 撤销该`selectKey`

处理超时事件：

* 遍历`selector`中的`selectKey`，包括准备好和未准备好的
* 判断其是否超时，若是，则作为`SocketEvent.ERROR`事件处理，并取消对该`selectKey`的注册

这里需要注意的是，无需在`poller`的每次循环中都处理超时事件，无端浪费操作，而且处理超时事件也没有实时性的要求。只需在以下情况下，处理超时事件即可：

* `selector`超时
* 到达下一次超时时间
* `socket`被关闭

# 处理HTTP请求

对HTTP请求的处理，实际是在[`Http11Processor`][8]中通过[`AbstractProcessorLight#process`][9]方法完成的。

* 











[1]:    http://blog.caoxudong.info/blog/2016/03/24/tomcat_study_initialization
[2]:    http://svn.apache.org/repos/asf/tomcat/tc8.5.x/tags/TOMCAT_8_5_23/java/org/apache/tomcat/util/net/NioEndpoint.java
[3]:    http://svn.apache.org/repos/asf/tomcat/tc8.5.x/tags/TOMCAT_8_5_23/java/org/apache/tomcat/util/net/NioEndpoint.java
[4]:    http://svn.apache.org/repos/asf/tomcat/tc8.5.x/tags/TOMCAT_8_5_23/java/org/apache/tomcat/util/threads/LimitLatch.java
[5]:    http://svn.apache.org/repos/asf/tomcat/tc8.5.x/tags/TOMCAT_8_5_23/java/org/apache/tomcat/util/net/NioEndpoint.java
[6]:    http://svn.apache.org/repos/asf/tomcat/tc8.5.x/tags/TOMCAT_8_5_23/java/org/apache/tomcat/util/net/NioEndpoint.java
[7]:    http://svn.apache.org/repos/asf/tomcat/tc8.5.x/tags/TOMCAT_8_5_23/java/org/apache/coyote/AbstractProtocol.java
[8]:    http://svn.apache.org/repos/asf/tomcat/tc8.5.x/tags/TOMCAT_8_5_23/java/org/apache/coyote/http11/Http11Processor.java
[9]:    http://svn.apache.org/repos/asf/tomcat/tc8.5.x/tags/TOMCAT_8_5_23/java/org/apache/coyote/AbstractProcessorLight.java
---
title:      Mac系统上无法通过JMX连接本地JVM处理方法
layout:     post
category:   blog
tags:       [osx, jmx, jvm]
---

在mac系统上，无法通过JMX工具（jconsole, jvisualvm）连接到本地的JVM进程，解决方法是先设置一个环境变量，然后再启动目标Java程序。

    JAVA_TOOL_OPTIONS=-Djava.rmi.server.hostname=localhost

这样做的原因是，jconsole试图通过外部网卡来连接目标Java进程，进而被防火墙阻拦。使用该环境变量后，Java进程会在RMI中使用`localhost`来处理外部接口。


# Resource

* https://stackoverflow.com/questions/18151923/jconsole-cannot-connect-to-local-processes-on-my-new-mac-air
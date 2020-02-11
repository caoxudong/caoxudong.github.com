---
title:      使用hive-jdbc是多么艰难
layout:     post
category:   blog
tags:       [hive, jdbc, springboot, spring]
---

最近项目中要使用hive-jdbc，鼓捣了好几天，才能够运行起来，领导都觉着是我故意偷懒了。

一开始是参考公司大数据部门给出的wiki，整来整去就是编译，依赖项是个圈，解析依赖项最终会爆栈。查了半天，大数据那边的人说，wiki早已过期，里面额方案也已废弃。WTF。

然后，是找网上的例子，引入`hive-jdbc`的包，

    compile(group: 'org.apache.hive', name: 'hive-jdbc', version: '2.3.0') {
        exclude group: 'org.eclipse.jetty.aggregate'
    }

然后会有一个针对POM文件的包，说是无法解压缩。

    Exception in thread "main" java.lang.IllegalStateException: Failed to get nested archive for entry BOOT-INF/lib/apache-curator-2.12.0.pom
        at org.springframework.boot.loader.archive.JarFileArchive.getNestedArchive(JarFileArchive.java:108)
        at org.springframework.boot.loader.archive.JarFileArchive.getNestedArchives(JarFileArchive.java:86)
        at org.springframework.boot.loader.ExecutableArchiveLauncher.getClassPathArchives(ExecutableArchiveLauncher.java:70)
        at org.springframework.boot.loader.Launcher.launch(Launcher.java:49)
        at org.springframework.boot.loader.JarLauncher.main(JarLauncher.java:51)
    Caused by: java.io.IOException: Unable to open nested jar file 'BOOT-INF/lib/apache-curator-2.12.0.pom'
        at org.springframework.boot.loader.jar.JarFile.getNestedJarFile(JarFile.java:254)
        at org.springframework.boot.loader.jar.JarFile.getNestedJarFile(JarFile.java:239)
        at org.springframework.boot.loader.archive.JarFileArchive.getNestedArchive(JarFileArchive.java:103)
        ... 4 more
    Caused by: java.io.IOException: Unable to find ZIP central directory records after reading 32330 bytes
        at org.springframework.boot.loader.jar.CentralDirectoryEndRecord.<init>(CentralDirectoryEndRecord.java:65)
        at org.springframework.boot.loader.jar.CentralDirectoryParser.parse(CentralDirectoryParser.java:52)
        at org.springframework.boot.loader.jar.JarFile.<init>(JarFile.java:121)
        at org.springframework.boot.loader.jar.JarFile.<init>(JarFile.java:109)
        at org.springframework.boot.loader.jar.JarFile.createJarFileFromFileEntry(JarFile.java:287)
        at org.springframework.boot.loader.jar.JarFile.createJarFileFromEntry(JarFile.java:262)
        at org.springframework.boot.loader.jar.JarFile.getNestedJarFile(JarFile.java:250)
        ... 6 more

这肯定错啊，POM还能解压缩？为啥会把POM文件放在`BOOT-INF/lib`下？gradle方面说对这个问题没有确定答复（https://github.com/gradle/gradle/issues/8582），springboot方面说"那我们改吧"(https://github.com/spring-projects/spring-boot/issues/16001)。看看人家springboot这态度。

接下来需要升级springboot，刚一升级，组里常用的一个公共包崩溃了，程序起不来了。完蛋。再接着查吧，终于有人说，hive-jdbc的包太大了，需要屏蔽掉不需要的依赖，像下面这样：

    compile(group: 'org.apache.hive', name: 'hive-jdbc', version: '2.3.2') {
        exclude group: 'org.eclipse.jetty.aggregate'
        exclude group: 'org.apache.hive'
        exclude group: 'jasper-compiler'
        exclude group: 'jasper-runtime'
        exclude group: 'servlet-api'
        exclude group: 'log4j-slf4j-impl'
        exclude group: 'slf4j-log4j12'
        exclude group: 'tomcat'
        exclude group: 'org.eclipse.jetty.orbit'
        exclude group: 'javax.servlet'
        exclude group: 'org.mortbay.jetty'
    }

果然，这下可以启动了，也不用升级springboot了。

运行之后，会报错找不到`org/apache/hive/service/rpc/thrift/TCLIService$Iface`

    Caused by: java.lang.NoClassDefFoundError: org/apache/hive/service/rpc/thrift/TCLIService$Iface
        at org.apache.hive.jdbc.HiveDriver.connect(HiveDriver.java:107)
        at java.sql.DriverManager.getConnection(DriverManager.java:664)
        at java.sql.DriverManager.getConnection(DriverManager.java:208)

这个类是有的，但是在`hive-service`和`hive-service-rpc`中存在重复代码，因此需要去除掉一个。改为:

    compile(group: 'org.apache.hive', name: 'hive-service', version: '2.3.2')
    compile(group: 'org.apache.hive', name: 'hive-jdbc', version: '2.3.2') {
        exclude group: 'org.eclipse.jetty.aggregate'
        exclude group: 'org.apache.hive'
        exclude group: 'jasper-compiler'
        exclude group: 'jasper-runtime'
        exclude group: 'servlet-api'
        exclude group: 'log4j-slf4j-impl'
        exclude group: 'slf4j-log4j12'
        exclude group: 'tomcat'
        exclude group: 'org.eclipse.jetty.orbit'
        exclude group: 'javax.servlet'
        exclude group: 'org.mortbay.jetty'
        exclude group: 'org.apache.hive', module: 'hive-service-rpc'
        exclude group: 'org.apache.hive', module: 'hive-service'
    }

发上去，还是不行。偶然在公司群里面看到机器人说

>hive-jdbc版本高于server版本导致，请使用1.2.1版本hive-jdbc

真·WTF，这个你咋不写在wiki上。不废话，赶紧换成1.2.1版本。发上去，继续报错

    java.lang.NoClassDefFoundError: org/apache/hadoop/conf/Configuration

再查，说是缺少hadoop包，引入吧

    compile(group: 'org.apache.hadoop', name: 'hadoop-common', version:'2.6.5')

发上去还是报错

    [ERROR][2020-02-11T15:09:18.344+0800][org.apache.juli.logging.DirectJDKLog:182] _undef||_msg=A child container failed during start||exception=java.util.concurrent.ExecutionException: org.apache.catalina.LifecycleException: Failed to start component [StandardEngine[Tomcat].StandardHost[localhost].TomcatEmbeddedContext[]]
        at java.util.concurrent.FutureTask.report(FutureTask.java:122)
        at java.util.concurrent.FutureTask.get(FutureTask.java:192)
        at org.apache.catalina.core.ContainerBase.startInternal(ContainerBase.java:941)
        at org.apache.catalina.core.StandardHost.startInternal(StandardHost.java:872)
        at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:150)
        at org.apache.catalina.core.ContainerBase$StartChild.call(ContainerBase.java:1421)
        at org.apache.catalina.core.ContainerBase$StartChild.call(ContainerBase.java:1411)
        at java.util.concurrent.FutureTask.run(FutureTask.java:266)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
        at java.lang.Thread.run(Thread.java:745)
    Caused by: org.apache.catalina.LifecycleException: Failed to start component [StandardEngine[Tomcat].StandardHost[localhost].TomcatEmbeddedContext[]]
        at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:167)
        ... 6 more
    Caused by: org.apache.catalina.LifecycleException: Failed to start component [Pipeline[StandardEngine[Tomcat].StandardHost[localhost].TomcatEmbeddedContext[]]]
        at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:167)
        at org.apache.catalina.core.StandardContext.startInternal(StandardContext.java:5125)
        at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:150)
        ... 6 more
    Caused by: org.apache.catalina.LifecycleException: Failed to start component [org.apache.catalina.authenticator.NonLoginAuthenticator[]]
        at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:167)
        at org.apache.catalina.core.StandardPipeline.startInternal(StandardPipeline.java:182)
        at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:150)
        ... 8 more
    Caused by: java.lang.NoSuchMethodError: javax.servlet.ServletContext.getVirtualServerName()Ljava/lang/String;
        at org.apache.catalina.authenticator.AuthenticatorBase.startInternal(AuthenticatorBase.java:1186)
        at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:150)
        ... 10 more

这个看起来是servlet api不兼容的问题，看依赖是hadoop-common引入的，那就把老的servlet都干掉。

    compile(group: 'org.apache.hadoop', name: 'hadoop-common', version:'2.6.5') {
        exclude group: 'jasper-compiler'
        exclude group: 'jasper-runtime'
        exclude group: 'servlet-api'
        exclude group: 'javax.servlet'
        exclude group: 'javax.servlet.jsp'
        exclude group: 'tomcat'
    }

欧耶，总算是可以执行sql了。
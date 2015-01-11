---
title:      在Mac OS X 10.8.4上编译OpenJDK 8
category:   blog
layout:     post
tags:       [mac, openjdk, java]
---


官方文档： [https://wikis.oracle.com/display/OpenJDK/Mac+OS+X+Port][1]

官方文档比较简单，照着做就行了，这里只记录编译过程中遇到的一些问题。

1. 如果在编译时报错为缺少某某东西，就添加ALLOW_DOWNLOADS标志，这样程序会自动下载所需的组件

        make ALLOW_DOWNLAODS=true all

2. 编译的时候会有corba文件乱码的问题，需要先做一下编码转换

        find build/macosx-universal/corba/gensrc/org/ -name '*.java' | while read p; do native2ascii -encoding UTF-8 $p > tmpj; mv tmpj $p; done

3. 找不到gamma文件

        make[7]: `precompiled.hpp.gch' is up to date.
        echo "Doing vm.make build:"
        Doing vm.make build:
        All done.
        cd bsd_amd64_compiler2/product && ./test_gamma
        java full version "1.7.0_25-b15"
        Error occurred during initialization of VM
        Unable to load native library: dlopen(/Users/caoxudong/workspace/repositories/openjdk/macosx-port/build/macosx-universal/hotspot/outputdir/bsd_amd64_compiler2/libjava.dylib, 1): image not found
        ./test_gamma: line 13: ./gamma: No such file or directory

    实在找不到，暂时禁用对gamma文件的调用，将test_gamma文件最后几行注释掉。

4. `/bin/sh: /Applications/Xcode.app/Contents/Developer/usr/bin/llvm-gcc: No such file or directory`

    在`/usr/llvm-gcc-4.2`下有，建一个软连接绕过此错误

5. 编译jobjc错误

        BUILD FAILED
        /Users/caoxudong/workspace/repositories/openjdk/macosx-port/jdk/src/macosx/native/jobjc/build.xml:156: exec returned: 65
    	at org.apache.tools.ant.taskdefs.ExecTask.runExecute(ExecTask.java:646)
    	at org.apache.tools.ant.taskdefs.ExecTask.runExec(ExecTask.java:672)
    	at org.apache.tools.ant.taskdefs.ExecTask.execute(ExecTask.java:498)
    	at org.apache.tools.ant.UnknownElement.execute(UnknownElement.java:291)
    	at sun.reflect.GeneratedMethodAccessor4.invoke(Unknown Source)
    	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
    	at java.lang.reflect.Method.invoke(Method.java:606)
    	at org.apache.tools.ant.dispatch.DispatchUtils.execute(DispatchUtils.java:106)
    	at org.apache.tools.ant.Task.perform(Task.java:348)
    	at org.apache.tools.ant.Target.execute(Target.java:390)
    	at org.apache.tools.ant.Target.performTasks(Target.java:411)
    	at org.apache.tools.ant.Project.executeSortedTargets(Project.java:1399)
    	at org.apache.tools.ant.Project.executeTarget(Project.java:1368)
    	at org.apache.tools.ant.helper.DefaultExecutor.executeTargets(DefaultExecutor.java:41)
    	at org.apache.tools.ant.Project.executeTargets(Project.java:1251)
    	at org.apache.tools.ant.Main.runBuild(Main.java:809)
    	at org.apache.tools.ant.Main.startAnt(Main.java:217)
    	at org.apache.tools.ant.launch.Launcher.run(Launcher.java:280)
    	at org.apache.tools.ant.launch.Launcher.main(Launcher.java:109)

6. 编译的时候，电脑太烫手。







[1]:    https://wikis.oracle.com/display/OpenJDK/Mac+OS+X+Port

---
title:      Serviceability 简介 —— 概述
category:   blog
layout:     post
tags:       [java, jvm, serviceability]
---

原文地址： <http://caoxudong818.iteye.com/blog/1565980>

以下内容均已jdk1.7.0_04为准。

啥是 Serviceability ？

[HotSpot Glossary of Terms][1]写道

> Serviceability Agent (SA) The Serviceablity Agent is collection of Sun internal code that aids in debugging HotSpot problems. It is also used by several JDK tools - jstack, jmap, jinfo, and jdb. See SA for more information.

简单说，这部分是用来调试查看hotspot的。

子曰，学而时习之 不亦说乎。这里就先习之，有个直观印象之后，再学之。 平时用来查看hotspot内部信息的常用的工具都在$JAVA_HOME/bin目录下，其中一些工具就是用Serviceability开发的。这里要介绍的是HSDB（其命令版本是CLHSDB），启动方式如下：

    java -classpath $JAVA_HOME/lib/sa-jdi.jar sun.jvm.hotspot.HSDB
    

看到界面后，大家自己琢磨怎么玩吧，内容挺多。

类似的，启动CLHSDB的方式如下：

    java -classpath $JAVA_HOME/lib/sa-jdi.jar sun.jvm.hotspot.CLHSDB
    

这里有一个简单的说明文档：<http://hg.openjdk.java.net/hsx/hotspot-main/hotspot/raw-file/tip/agent/doc/clhsdb.html>

另外，还有一个DebugServer类，功能差不多。

    java -classpath %JAVA_HOME%/lib/sa-jdi.jar sun.jvm.hotspot.DebugServer
    

在sun.jvm.hotspot包下，有个HelloWorld类。我觉着此类是在蛋疼的紧，各位请看代码：

    /*
     * Copyright (c) 2000, 2011, Oracle and/or its affiliates. All rights reserved.
     * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
     *
     * This code is free software; you can redistribute it and/or modify it
     * under the terms of the GNU General Public License version 2 only, as
     * published by the Free Software Foundation.
     *
     * This code is distributed in the hope that it will be useful, but WITHOUT
     * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
     * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
     * version 2 for more details (a copy is included in the LICENSE file that
     * accompanied this code).
     *
     * You should have received a copy of the GNU General Public License version
     * 2 along with this work; if not, write to the Free Software Foundation,
     * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
     *
     * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
     * or visit www.oracle.com if you need additional information or have any
     * questions.
     *
     */
    
    package sun.jvm.hotspot;
    
    import java.lang.reflect.*;
    
    public class HelloWorld {
        private static String helloWorldString = "Hello, world!";
        private static volatile int helloWorldTrigger = 0;
        private static final boolean useMethodInvoke = false;
        private static Object lock = new Object();
    
        public static void main(String[] args) {
            int foo = a();
            System.out.println("HelloWorld exiting. a() = " + foo);
        }
    
        private static int a() {
            return 1 + b();
        }
    
        private static int b() {
            return 1 + c();
        }
    
        private static int c() {
            return 1 + d("Hi");
        }
    
        private static int d(String x) {
            System.out.println("HelloWorld.d() received \"" + x + "\" as argument");
            synchronized(lock) {
                if (useMethodInvoke) {
                    try {
                        Method method = HelloWorld.class.getMethod("e");
                        Integer result = (Integer) method.invoke(null, new Object[0]);
                        return result.intValue();
                    }
                    catch (Exception e) {
                        throw new RuntimeException(e.toString());
                    }
                } else {
                    int i = fib(10); // 89
                    long l = i;
                    float f = i;
                    double d = i;
                    char c = (char) i;
                    short s = (short) i;
                    byte b = (byte) i;
                    int ret = e();
                    System.out.println("Tenth Fibonacci number in all formats: " +
                           i + ", " +
                           l + ", " +
                           f + ", " +
                           d + ", " +
                           c + ", " +
                           s + ", " +
                           b);
    
                    return ret;
                }
            }
        }
    
        public static int e() {
            System.out.println("Going to sleep...");
            int i = 0;
    
            while (helloWorldTrigger == 0) {
                if (++i == 1000000) {
                    System.gc();
                }
            }
    
            System.out.println(helloWorldString);
    
            while (helloWorldTrigger != 0) {}
    
            return i;
        }
    
        // Tree-recursive implementation for test
        public static int fib(int n) {
            if (n &lt; 2) {
                return 1;
            }
            return fib(n - 1) + fib(n - 2);
        }
    }
    

  难道此类是用来硬件测性能的？

sa中的包主要分为以下几个部分： asm，ci，code，debugger，gc，interpreter，jdi，livevm，memory，oops，opto，prims，runtine，tools，types。 后续的文章会进行介绍，可能会跳过一些（我不懂的）。

回到CLHSDB，这个只是一个壳，主要的功能都是靠sun.jvm.hotspot.HotSpotAgent和sun.jvm.hotspot.CommandProcessor完成的。

    CommandProcessor.DebuggerInterface di = new CommandProcessor.DebuggerInterface() {
                public HotSpotAgent getAgent() {
                    return agent;
                }
                public boolean isAttached() {
                    return attached;
                }
                public void attach(String pid) {
                    attachDebugger(pid);
                }
                public void attach(String java, String core) {
                    attachDebugger(java, core);
                }
                public void detach() {
                    detachDebugger();
                }
                public void reattach() {
                    if (attached) {
                        detachDebugger();
                    }
                    if (pidText != null) {
                        attach(pidText);
                    } else {
                        attach(execPath, coreFilename);
                    }
                }
            };
    BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
    CommandProcessor cp = new CommandProcessor(di, in, System.out, System.err);</pre>
    

构造CommandProcessor类的实例前时，会对其中的一个成员变量commandList进行初始化，其中存储的就是预先注册的可执行命令：

    private final Command[] commandList = {
        new Command("reattach", true) {
            public void doit(Tokens t) {
                int tokens = t.countTokens();
                if (tokens != 0) {
                    usage();
                    return;
                }
                preAttach();
                debugger.reattach();
                postAttach();
            }
        },
        new Command("attach", "attach pid | exec core", true) {
            public void doit(Tokens t) {
                int tokens = t.countTokens();
                if (tokens == 1) {
                    preAttach();
                    debugger.attach(t.nextToken());
                    postAttach();
                } else if (tokens == 2) {
                    preAttach();
                    debugger.attach(t.nextToken(), t.nextToken());
                    postAttach();
                } else {
                    usage();
                }
            }
        },
    ......
        new Command("assert", "assert true | false", true) {
            public void doit(Tokens t) {
                if (t.countTokens() != 1) {
                    usage();
                } else {
                    Assert.ASSERTS_ENABLED = Boolean.valueOf(t.nextToken()).booleanValue();
                }
            }
        },
    };
    

 

这样，程序就可以接收并处理用户输入的命令。

HotSpotAgent类的主要功能是根据主机环境设置调试器（debugger），并将debugger attach（这词儿该咋表述）到目标上（目标可以通过PID或dump文件）。流程如下（以Windows为例）： attach($pid) -> setupDebugger() -> setupDebuggerWin32() -> attachDebugger() 在这期间会根据需要，判断是否建立一个远程调式服务器，以便于执行远程调试。

    if (isServer) {
        RemoteDebuggerServer remote = null;
        try {
            remote = new RemoteDebuggerServer(debugger);
        }catch (RemoteException rem) {
            throw new DebuggerException(rem);
        }
        RMIHelper.rebind(serverID, remote);
    } 
    

to be continued...

[1]:    http://openjdk.java.net/groups/hotspot/docs/HotSpotGlossary.html

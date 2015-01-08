---
category:   pages
layout:     post
tags:       [java, jvm, serviceability]
---


转载：Serviceability 简介 —— tools
=======



原文地址： <http://caoxudong818.iteye.com/blog/1576234>

在[前文][1]中提到，$JAVA_HOME/bin下有一些工具也是通过SA实现的，本文就对SA中tools包下的工具做简单介绍。

tools包下一个主要的类是[sun.jvm.hotspot.tools.Tool][2]。使用SA实现的工具类大部分都是继承自此类。子类通过覆盖run方法来实现自定义的功能。例如，类[sun.jvm.hotspot.tools.JInfo][3]在run方法中确定是打印系统属性还是打印虚拟机参数：

    public void run() {
        Tool tool = null;
        switch (mode) {
        case MODE_FLAGS:
            printVMFlags();
            return;
        case MODE_SYSPROPS:
            tool = new SysPropsDumper();
            break;
        case MODE_BOTH: {
            tool = new Tool() {
                    public void run() {
                        Tool sysProps = new SysPropsDumper();
                        sysProps.setAgent(getAgent());
                        System.out.println("Java System Properties:");
                        System.out.println();
                        sysProps.run();
                        System.out.println();
                        System.out.println("VM Flags:");
                        printVMFlags();
                        System.out.println();
                    }
                };
            }
            break;
    
        default:
            usage();
            break;
        }
        tool.setAgent(getAgent());
        tool.run();
    }
    

 

在使用的时候，一般会是如下情况：

1.  启动Java，调用子类的main方法；
2.  子类做一些初步的处理；
3.  调用sun.jvm.hotspot.tools.Tool类的start方法，传入相应的命令行参数；
4.  在start方法中根据接收的参数判断要使用何种调式类型；
5.  根据不同的调式类型使用不同的attach（不知道还用什么词比较好）策略；
6.  调用子类实现的run方法。
7.  调用 sun.jvm.hotspot.tools.Tool类的 方法，一般用于从目标JVM中detach

所以，如果想自己编写调试工具的话，只需要继承Tool类，实现run方法，再调用类似下面的代码（以[FinalizerInfo][4]类为例）即可：

    public static void main(String[] args) {
        FinalizerInfo finfo = new FinalizerInfo();
        finfo.start(args);
        finfo.stop();
    }
    

  下面看一下Tool类是如何进行调试的。 在Tool类中，定义了3中调试类型，分别是：

    // debugeeType is one of constants below
    protected static final int DEBUGEE_PID    = 0;
    protected static final int DEBUGEE_CORE   = 1;
    protected static final int DEBUGEE_REMOTE = 2;
    

针对不同的调式类型所使用的attach代码：

    switch (debugeeType) {
    case DEBUGEE_PID:
        err.println("Attaching to process ID " + pid + ", please wait...");
        agent.attach(pid);
        break;
    
    case DEBUGEE_CORE:
         err.println("Attaching to core " + coreFileName + " from executable " + executableName + ", please wait...");
         agent.attach(executableName, coreFileName);
         break;
    
    case DEBUGEE_REMOTE:
         err.println("Attaching to remote server " + remoteServer + ", please wait...");
         agent.attach(remoteServer);
         break;
    }
    

 

由上面的代码中可以看到，调式功能主要是通过agent进行的，该变量是一个[sun.jvm.hotspot.bugspot.BugSpotAgent][5]类的实例。

OpenJDK 写道

> This class wraps the basic functionality for connecting to the target process or debug server. It makes it simple to start up the debugging system. This agent (as compared to the HotSpotAgent) can connect to and interact with arbitrary processes. If the target process happens to be a HotSpot JVM, the Java debugging features of the Serviceability Agent are enabled. Further, if the Serviceability Agent's JVMDI module is loaded into the target VM, interaction with the live Java program is possible, specifically the catching of exceptions and setting of breakpoints. The BugSpot debugger requires that the underlying Debugger support C/C++ debugging via the CDebugger interface.

该类的主要功能是简化对JVM的调试。它可以对任意目标进行调试，若目标进行是HotSpot JVM，则启用SA。若目标JVM载入了JVMDI模块，则可以与Java程序进行交互。

在该类中，调试功能（如加断点、挂起线程、恢复线程运行、挂起目标JVM等）都是通过[sun.jvm.hotspot.livejvm.ServiceabilityAgentJVMDIModule][6]类完成的。当然，使用ServiceabilityAgentJVMDIModule类的前提是目标JVM是HotSpot，并且启用了SA的JVMDI模块。例如下面添加断点的代码：

    /** Toggle a Java breakpoint at the given location. */
    public synchronized ServiceabilityAgentJVMDIModule.BreakpointToggleResult
    toggleJavaBreakpoint(String srcFileName, String pkgName, int lineNo) {
        if (!canInteractWithJava()) {
            throw new DebuggerException("Could not connect to SA's JVMDI module; can not toggle Java breakpoints");
        }
        return jvmdi.toggleBreakpoint(srcFileName, pkgName, lineNo);
    }
    

ServiceabilityAgentJVMDIModule类是一个Java语言级的交互式调试工具。

> /** Provides Java programming language-level interaction with a live Java HotSpot VM via the use of the SA's JVMDI module. This is an experimental mechanism. The BugSpot debugger should be converted to use the JVMDI/JDWP-based JDI implementation for live process interaction once the JDI binding for the SA is complete. */

其中，VM与SA交互部分的数据有：

    // Values in target process
    // Events sent from VM to SA
    private CIntegerAccessor saAttached;
    private CIntegerAccessor saEventPending;
    private CIntegerAccessor saEventKind;
    // Exception events
    private JNIHandleAccessor saExceptionThread;
    private JNIHandleAccessor saExceptionClass;
    private JNIid             saExceptionMethod;
    private CIntegerAccessor  saExceptionLocation;
    private JNIHandleAccessor saExceptionException;
    private JNIHandleAccessor saExceptionCatchClass;
    private JNIid             saExceptionCatchMethod;
    private CIntegerAccessor  saExceptionCatchLocation;
    // Breakpoint events
    private JNIHandleAccessor saBreakpointThread;
    private JNIHandleAccessor saBreakpointClass;
    private JNIid             saBreakpointMethod;
    private CIntegerAccessor  saBreakpointLocation;
    // Commands sent by the SA to the VM
    private int               SA_CMD_SUSPEND_ALL;
    private int               SA_CMD_RESUME_ALL;
    private int               SA_CMD_TOGGLE_BREAKPOINT;
    private int               SA_CMD_BUF_SIZE;
    private CIntegerAccessor  saCmdPending;
    private CIntegerAccessor  saCmdType;
    private CIntegerAccessor  saCmdResult;
    private CStringAccessor   saCmdResultErrMsg;
    // Toggle breakpoint command arguments
    private CStringAccessor   saCmdBkptSrcFileName;
    private CStringAccessor   saCmdBkptPkgName;
    private CIntegerAccessor  saCmdBkptLineNumber;
    private CIntegerAccessor  saCmdBkptResWasError;
    private CIntegerAccessor  saCmdBkptResLineNumber;
    private CIntegerAccessor  saCmdBkptResBCI;
    private CIntegerAccessor  saCmdBkptResWasSet;
    private CStringAccessor   saCmdBkptResMethodName;
    private CStringAccessor   saCmdBkptResMethodSig;
    

在继续对ServiceabilityAgentJVMDIModule类进行介绍之前，先说一个这里常用到的类[sun.jvm.hotspot.debugger.Address][7]。该类是在调试过程中对地址进行访问的底层抽象接口，简单的理解话，就当作是指针地址好了。你可以在[使用CLHSDB][8]的过程中看到很多数据后面都会跟着一个类似于“0x32bf4978”这样的数，这个就是地址，Address类对这个进行了封装，便于在Java中进行访问和操作，提供了对地址的加、减、比较和位运算，以及获取、设置指定地址内容等操作。例如：

    public long       getCIntegerAt      (long offset, long numBytes, boolean isUnsigned) throws UnmappedAddressException, UnalignedAddressException;
    /** Sets a C integer numBytes in size at the specified offset. Note that there is no "unsigned" flag for the accessor since the value will not be sign-extended; the number of bytes are simply copied from the value into the target address space. */
    
    public void setCIntegerAt(long offset, long numBytes, long value);
    /** This throws an UnsupportedOperationException if this address happens to actually be an OopHandle, because interior object pointers are not allowed. Negative offsets are allowed and handle the subtraction case. */
    
    public Address    addOffsetTo        (long offset) throws UnsupportedOperationException;
    /** This throws an UnsupportedOperationException if this address happens to actually be an OopHandle. Performs a logical "and" operation of the bits of the address and the mask (least significant bits of the Address and the mask are aligned) and returns the result as an Address. Returns null if the result was zero. */
    
    public Address    andWithMask(long mask) throws UnsupportedOperationException;
    

当然，在使用Address过程中，会有一些需要注意的地方：

1.  地址是不可变的（immutable），但其指向的内容是可变的，可以理解为const void* point；
2.  如果当前的调试目标是一个核心转储文件（core dump），则不可以修改地址指向的内容；
3.  C/C++中的地址一般由无符号整数表示，而Java中不存在无符号原生类型，所以以原始地址数据（例如0x32bf4978）为参数的方法中，都是以long型代替li。相应的，对地址进行运行时，也需要注意类型的处理。

下面以Linux平台为例进行说明。在Linux上，Address类是实现类是[sun.jvm.hotspot.debugger.linux.LinuxAddress][9]。在该类中，对地址指向的数据的读取操作是通过[sun.jvm.hotspot.debugger.linux.LinuxDebugger][10]类完成的，而写操作目前还未实现，调用方法时会抛异常。对[sun.jvm.hotspot.debugger.linux.LinuxDebugger][10]类的说明并不是本文的目的，就此打住，后续的文章中再谈。

现在回到ServiceabilityAgentJVMDIModule类，在前面提到的SA与VM交互的数据中，其类型基本上都是对Address的封装。这里有个奇怪的问题，在挂起VM线程的suspend方法中，会调用[sun.jvm.hotspot.livejvm.CIntegerAccessor][11]类的setValue方法，而这个方法实现是通过调用Address类的setCIntegerAt方法完成的。从目前看到的Address的实现类（包括[LinuxAddress][9]、[WindbgAddress][12]、[DbxAddress][13]、[DummyAddress][14]、[RemoteAddress][15]、[ProcAddress][16]）看，setValue方法都会抛出异常（Win32Address类除外）。

ServiceabilityAgentJVMDIModule类的suspend方法：

    /** Suspend all Java threads in the target VM. Throws DebuggerException if the VM disconnected. */
    public void suspend() {
        saCmdType.setValue(SA_CMD_SUSPEND_ALL);
        saCmdPending.setValue(1);
        waitForCommandCompletion();
        suspended = true;
    }
    

CIntegerAccessor类的setValue方法：

    void setValue(long value) {
        addr.setCIntegerAt(0, numBytes, value);
    }
    

LinuxAddress类setCIntegerAt方法：

    // Mutators -- not implemented for now (FIXME)
    public void setCIntegerAt(long offset, long numBytes, long value) {
        throw new DebuggerException("Unimplemented");
    }
    

只有[Win32Address][17]类中，通过[Win32Debugger][18]接口提供对setCIntegerAt方法的实现，在该接口的实现类[Win32DebuggerLocal][19]的父类[DebuggerBase][20]类中的[writeCInteger][21]方法中会做相应的检查，包括字节对齐和相应成员对象是否存在的检查。在最终实现上，是通过[Win32DebuggerLocal][19]的[writeBytesToProcess][22]方法完成的。

Win32Address类的setCIntegerAt方法：

    public void setCIntegerAt(long offset, long numBytes, long value) {
        debugger.writeCInteger(addr + offset, numBytes, value);
    }
    

DebuggerBase类的writeCInteger方法：

    public void writeCInteger(long address, long numBytes, long value) throws UnmappedAddressException, UnalignedAddressException {
        checkConfigured();
        utils.checkAlignment(address, numBytes);
        byte[] data = utils.cIntegerToData(numBytes, value);
        writeBytes(address, numBytes, data);
    }
    

Win32DebuggerLocal类的writeBytesToProcess方法：

    public synchronized void writeBytesToProcess(long startAddress, long numBytes, byte[] data) throws UnmappedAddressException, DebuggerException {
        try {
            printToOutput("poke 0x" + Long.toHexString(startAddress) + " |");
            writeIntToOutput((int) numBytes);
            writeToOutput(data, 0, (int) numBytes);
            printlnToOutput("");
            if (!in.parseBoolean()) {
                throw new UnmappedAddressException(startAddress);
            }
        } catch (IOException e) {
            throw new DebuggerException(e);
        }
    }
    

到这里就是将内容发送到输出中，至于内容中“poke”是个啥玩意，还不清楚，需要后续跟进一些调试器的知识。这里的输出应该是与本地程序之间建立的socket连接：

    /** Connects to the debug server, setting up out and in streams. */
    private void connectToDebugServer() throws IOException {
        // Try for a short period of time to connect to debug server; time out
        // with failure if didn't succeed
        debuggerSocket = null;
        long endTime = System.currentTimeMillis() + SHORT_TIMEOUT;
    
        while ((debuggerSocket == null) && (System.currentTimeMillis() &lt; endTime)) {
            try {
                // FIXME: this does not work if we are on a DHCP machine which
                // did not get an IP address this session. It appears to use
                // an old cached address and the connection does not actually
                // succeed. Must file a bug.
                // debuggerSocket = new Socket(InetAddress.getLocalHost(), PORT);
                debuggerSocket = new Socket(InetAddress.getByName("127.0.0.1"), PORT);
                debuggerSocket.setTcpNoDelay(true);
            }
            catch (IOException e) {
                // Swallow IO exceptions while attempting connection
                debuggerSocket = null;
                try {
                    // Don't swamp the CPU
                    Thread.sleep(750);
                }
                catch (InterruptedException ex) {
                }
            }
        }
    
        if (debuggerSocket == null) {
            // Failed to connect because of timeout
            throw new DebuggerException("Timed out while attempting to connect to debug server (please start SwDbgSrv.exe)");
        }
    
        out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(debuggerSocket.getOutputStream(), "US-ASCII")), true);
        rawOut = new DataOutputStream(new BufferedOutputStream(debuggerSocket.getOutputStream()));
        in = new InputLexer(new BufferedInputStream(debuggerSocket.getInputStream()));
    }
    

说到这里，有个问题，难道只有win32下可以进行调试么？那么，这个方法会不会有问题呢？到底有没有调用ServiceabilityAgentJVMDIModule类的suspend方法呢？现在手边没有开发环境，等配置好后，再通过btrace查一下。

to be continued......

[1]:    /post/introduction_to_serviceability_overview
[2]:    http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/tools/Tool.java
[3]:    http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/tools/JInfo.java#JInfo
[4]:    http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/tools/FinalizerInfo.java#FinalizerInfo
[5]:    http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/bugspot/BugSpotAgent.java#BugSpotAgent
[6]:    http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/livejvm/ServiceabilityAgentJVMDIModule.java#ServiceabilityAgentJVMDIModule
[7]:    http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/Address.java#Address
[8]:    http://caoxudong818.iteye.com/blog/1565980
[9]:    http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/linux/LinuxAddress.java#LinuxAddress
[10]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/linux/LinuxDebugger.java#LinuxDebugger
[11]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/livejvm/CIntegerAccessor.java#CIntegerAccessor
[12]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/windbg/WindbgAddress.java#WindbgAddress
[13]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/dbx/DbxAddress.java#DbxAddress
[14]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/dummy/DummyAddress.java#DummyAddress
[15]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/remote/RemoteAddress.java#RemoteAddress
[16]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/proc/ProcAddress.java#ProcAddress
[17]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/win32/Win32Address.java#Win32Address
[18]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/win32/Win32Debugger.java#Win32Debugger
[19]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/win32/Win32DebuggerLocal.java#Win32DebuggerLocal
[20]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/DebuggerBase.java#DebuggerBase
[21]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/DebuggerBase.java#DebuggerBase.writeCInteger%28long%2Clong%2Clong%29
[22]:   http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/7-b147/sun/jvm/hotspot/debugger/win32/Win32DebuggerLocal.java#Win32DebuggerLocal.writeBytesToProcess%28long%2Clong%2Cbyte%5B%5D%29

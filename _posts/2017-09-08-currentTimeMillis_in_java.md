---
title:      jdk8中的时间获取
layout:     post
category:   blog
tags:       [java]
---

# 环境信息

    [caoxudong@localhost ~]$ java -version
    java version "1.8.0_65"
    Java(TM) SE Runtime Environment (build 1.8.0_65-b17)
    Java HotSpot(TM) 64-Bit Server VM (build 25.65-b01, mixed mode)

    [caoxudong@localhost ~]$ uname -a
    Linux localhost 2.6.32-573.18.1.el6.toav2.x86_64 #1 SMP Sun Jul 17 12:44:29 CST 2016 x86_64 x86_64 x86_64 GNU/Linux

# 方法说明

方法声明

    /**
     * Returns the current time in milliseconds.  Note that
     * while the unit of time of the return value is a millisecond,
     * the granularity of the value depends on the underlying
     * operating system and may be larger.  For example, many
     * operating systems measure time in units of tens of
     * milliseconds.
     *
     * <p> See the description of the class <code>Date</code> for
     * a discussion of slight discrepancies that may arise between
     * "computer time" and coordinated universal time (UTC).
     *
     * @return  the difference, measured in milliseconds, between
     *          the current time and midnight, January 1, 1970 UTC.
     * @see     java.util.Date
     */
    public static native long currentTimeMillis();

`currentTimeMillis`方法用于获取当前的时间戳，单位为毫秒，但获取数据的精度无法确定，依赖于当前操作系统的具体实现。

本地方法的声明，参见[jvm.cpp][1]

    JVM_LEAF(jlong, JVM_CurrentTimeMillis(JNIEnv *env, jclass ignored))
        JVMWrapper("JVM_CurrentTimeMillis");
        return os::javaTimeMillis();
    JVM_END

在各个操作系统下的实现

aix，参见[os_aix.cpp][2]

    jlong os::javaTimeMillis() {
        timeval time;
        int status = gettimeofday(&time, NULL);
        assert(status != -1, "aix error at gettimeofday()");
        return jlong(time.tv_sec) * 1000 + jlong(time.tv_usec / 1000);
    }

bsd，参见[os_bsd.cpp][3]

    jlong os::javaTimeMillis() {
        timeval time;
        int status = gettimeofday(&time, NULL);
        assert(status != -1, "bsd error");
        return jlong(time.tv_sec) * 1000  +  jlong(time.tv_usec / 1000);
    }

linux，参见[os_linux.cpp][4]

    jlong os::javaTimeMillis() {
        timeval time;
        int status = gettimeofday(&time, NULL);
        assert(status != -1, "linux error");
        return jlong(time.tv_sec) * 1000  +  jlong(time.tv_usec / 1000);
    }

solaris，参见[os_solaris.cpp][5]

    // Must return millis since Jan 1 1970 for JVM_CurrentTimeMillis
    jlong os::javaTimeMillis() {
        timeval t;
        if (gettimeofday(&t, NULL) == -1) {
            fatal("os::javaTimeMillis: gettimeofday (%s)", os::strerror(errno));
        }
        return jlong(t.tv_sec) * 1000  +  jlong(t.tv_usec) / 1000;
    }

windows，参见[os_windows.cpp][6]

    jlong os::javaTimeMillis() {
        if (UseFakeTimers) {
            return fake_time++;
        } else {
            FILETIME wt;
            GetSystemTimeAsFileTime(&wt);
            return windows_to_java_time(wt);
        }
    }

# 代码实验

以linux平台为例，测试gettimeofday方法

Test.java

    public class Test {

        public static void main(String[] args) {
            long result = 0L;
            for (int i=0; i<10000; i++) {
                result += System.currentTimeMillis();
            }
            System.out.println(result);
        }

    }

test.c

    #include <stdio.h>
    #include <sys/time.h>
    #include <time.h>
    #include <unistd.h>

    int main(int argc, char* argv[])
    {
        for (int i=0; i<10000; i++)
        {
            struct timeval tv;
            gettimeofday (&tv, NULL);
        }
    }

运行结果

    [caoxudong@localhost ~]$ gcc -std=c99 test.c
    [caoxudong@localhost ~]$ javac Test.java
    [caoxudong@localhost ~]$ ltrace -c ./a.out
    % time     seconds  usecs/call     calls      function
    ------ ----------- ----------- --------- --------------------
     51.44    2.830242     2830242         1 __libc_start_main
     48.56    2.671857         267     10000 gettimeofday
     0.00     0.000101         101         1
     0.00     0.000094          94         1 SYS_exit_group
    ------ ----------- ----------- --------- --------------------
    100.00    5.502294                 10003 total
    [caoxudong@localhost ~]$ ltrace -c java -cp . Test
    15046761926697740
    % time     seconds  usecs/call     calls      function
    ------ ----------- ----------- --------- --------------------
     33.99   10.181938      181820        56 __libc_start_main
     33.96   10.174553      181688        56 JLI_Launch
     32.04    9.598370      174515        55 SYS_clone
      0.01    0.002999        2999         1 SYS_exit_group
      0.00    0.000301         100         3
    ------ ----------- ----------- --------- --------------------
    100.00   29.958161                   171 total

这里使用ltrace是因为linux支持VDSO之后，gettimeofday属于快速系统调用，使用strace是看不到执行结果的。

如下所示： [gettimeofday.c][8]

    #include <sys/time.h>

    #ifdef SHARED

    # include <dl-vdso.h>
    # include <errno.h>

    static int
    __gettimeofday_syscall (struct timeval *tv, struct timezone *tz)
    {
    return INLINE_SYSCALL (gettimeofday, 2, tv, tz);
    }

    void *gettimeofday_ifunc (void) __asm__ ("__gettimeofday");

    void *
    gettimeofday_ifunc (void)
    {
    PREPARE_VERSION_KNOWN (linux26, LINUX_2_6);

    /* If the vDSO is not available we fall back to syscall.  */
    return (_dl_vdso_vsym ("__vdso_gettimeofday", &linux26)
        ?: (void*) (&__gettimeofday_syscall));
    }
    asm (".type __gettimeofday, %gnu_indirect_function");

    libc_ifunc_hidden_def(__gettimeofday)

    #else

    # include <sysdep.h>
    # include <errno.h>

    int
    __gettimeofday (struct timeval *tv, struct timezone *tz)
    {
    return INLINE_SYSCALL (gettimeofday, 2, tv, tz);
    }
    libc_hidden_def (__gettimeofday)

    #endif
    weak_alias (__gettimeofday, gettimeofday)
    libc_hidden_weak (gettimeofday)

这里面值得注意的是，从上面的运行结果看到，运行c程序的时候，调用了10000次gettimeofday系统调用，而运行java程序的时候，却没有调用gettimeofday。原因待查。

# 参考资料

* [The slow currentTimeMillis()][9]
* [Java的System.currentTimeMillis()会调用系统gettimeofday吗?][10]
* [How does ltrace work?][11]
* [System.nanoTime()的实现分析][12]




[1]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/share/vm/prims/jvm.cpp#l296
[2]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os/aix/vm/os_aix.cpp#l1104
[3]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os/bsd/vm/os_bsd.cpp#l990
[4]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os/linux/vm/os_linux.cpp#l1308
[5]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os/solaris/vm/os_solaris.cpp#l1512
[6]:    https://hg.openjdk.java.net/jdk8u/jdk8u/hotspot/file/aa4ffb1f30c9/src/os/windows/vm/os_windows.cpp#l843
[7]:    https://github.com/torvalds/linux/blob/597f03f9d133e9837d00965016170271d4f87dcf/kernel/time/time.c#L102
[8]:    https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/x86/gettimeofday.c;h=36f7c26ffb0e818709d032c605fec8c4bd22a14e;hb=fdfc9260b61d3d72541f18104d24c7bcb0ce5ca2
[9]:    https://pzemtsov.github.io/2017/07/23/the-slow-currenttimemillis.html
[10]:   https://www.zhihu.com/question/51023490
[11]:   https://blog.packagecloud.io/eng/2016/03/14/how-does-ltrace-work/
[12]:   https://feiyang21687.github.io/SystemNano/
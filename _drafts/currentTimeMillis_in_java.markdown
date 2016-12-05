---
title:      jdk9中的时间获取
layout:     post
category:   blog
tags:       [java]
---

# 环境信息

    sh-3.2$ uname -a
    Darwin localhost 16.1.0 Darwin Kernel Version 16.1.0: Thu Oct 13 21:26:57 PDT 2016; root:xnu-3789.21.3~60/RELEASE_X86_64 x86_64
    sh-3.2$

    sh-3.2$ java -version
    openjdk version "9-internal"
    OpenJDK Runtime Environment (fastdebug build 9-internal+0-2016-10-17-003747.didi.jdk9)
    OpenJDK 64-Bit Server VM (fastdebug build 9-internal+0-2016-10-17-003747.didi.jdk9, mixed mode)
    sh-3.2$

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

以linux为例，是通过`gettimeofday`方法获取到系统当前时间的，而`gettimeofday`的实现如下，参见[timer.c][7]

    SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv, struct timezone __user *, tz)
    {
        if (likely(tv != NULL)) {
            struct timeval ktv;
            do_gettimeofday(&ktv);
            if (copy_to_user(tv, &ktv, sizeof(ktv)))
                return -EFAULT;
        }
        if (unlikely(tz != NULL)) {
            if (copy_to_user(tz, &sys_tz, sizeof(sys_tz)))
                return -EFAULT;
        }
        return 0;
    }


# 参考资料







[1]:    http://hg.openjdk.java.net/jdk9/jdk9/hotspot/file/fcfe55dc547c/src/share/vm/prims/jvm.cpp#l267
[2]:    http://hg.openjdk.java.net/jdk9/jdk9/hotspot/file/fcfe55dc547c/src/os/aix/vm/os_aix.cpp#l1024
[3]:    http://hg.openjdk.java.net/jdk9/jdk9/hotspot/file/fcfe55dc547c/src/os/bsd/vm/os_bsd.cpp#l915
[4]:    http://hg.openjdk.java.net/jdk9/jdk9/hotspot/file/fcfe55dc547c/src/os/linux/vm/os_linux.cpp#l1155
[5]:    http://hg.openjdk.java.net/jdk9/jdk9/hotspot/file/fcfe55dc547c/src/os/solaris/vm/os_solaris.cpp#l1312
[6]:    http://hg.openjdk.java.net/jdk9/jdk9/hotspot/file/fcfe55dc547c/src/os/windows/vm/os_windows.cpp#l900
[7]:    https://github.com/torvalds/linux/blob/597f03f9d133e9837d00965016170271d4f87dcf/kernel/time/time.c#L102
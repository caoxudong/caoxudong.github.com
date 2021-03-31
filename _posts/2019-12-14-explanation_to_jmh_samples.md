---
title:      JMH实例整理
layout:     post
category:   blog
tags:       [java, jmh, jvm, benchmark]
---

# what is jmh

jmh官网地址，[https://openjdk.java.net/projects/code-tools/jmh/][1]

jmh能帮助你做benchmark，测量代码的吞吐量、平均响应时间等指标。

# why jmh

* jmh是openjdk的开发团队搞的，相信专家的水平
* 与jmeter等工具有不同的使用场景，jmh主要用于对java代码本身的质量进行测试，而jmeter可用于对接口性能进行测试

# examples explanation

samples地址，[https://hg.openjdk.java.net/code-tools/jmh/file/40c1cca654c1/jmh-samples/src/main/java/org/openjdk/jmh/samples][2]

下面通过实例说一下jmh如何帮助我们做benchmark。


## dead code elimination

平时在写一些简单的测试的时候往往会写成这个样子(伪代码)

    public void target(int a) {
        Math.log(a)
    }

    long begin = System.nannoTime()
    for (int i=100_000;i++) {
        target(i)
    }
    long end = System.nannoTime()
    long avgTime = (end - begin) / 100_000

这种写法的问题是，经过JIT后，待测试方法被认为可以整体清理掉，这样就达到不测试`target`方法的目的了。

jmh的解决方案是利用上`target`方法的返回值，防止被DCE。示例:

    @Benchmark
    public double target(int a) {
        return Math.log(a)
    }

对于有多个步骤的`target`方法，需要防止每一步的结果被DEC，可以将使各个步骤的结果形成依赖关系并返回最终结果，或者通过`Blackhole`来处理。示例：

    @Benchmark
    public double measureRight_1() {
        return Math.log(x1) + Math.log(x2);
    }

    @Benchmark
    public void measureRight_2(Blackhole bh) {
        bh.consume(Math.log(x1));
        bh.consume(Math.log(x2));
    }

## loop unrolled

还以前面的例子来说，jit会将循环打开，从而节省大量的循环判断操作，循环次数约大，优化效果越明显。因此，为了测试单次操作的平均耗时，不可在代码中直接使用循环，而是应该使用jmh提供的参数来控制。

错误的示例

    private int reps(int reps) {
        int s = 0;
        for (int i = 0; i < reps; i++) {
            s += (x + y);
        }
        return s;
    }

    @Benchmark
    @OperationsPerInvocation(1)
    public int measureWrong_1() {
        return reps(1);
    }

    @Benchmark
    @OperationsPerInvocation(10)
    public int measureWrong_10() {
        return reps(10);
    }

    @Benchmark
    @OperationsPerInvocation(100)
    public int measureWrong_100() {
        return reps(100);
    }

    @Benchmark
    @OperationsPerInvocation(1000)
    public int measureWrong_1000() {
        return reps(1000);
    }

    @Benchmark
    @OperationsPerInvocation(10000)
    public int measureWrong_10000() {
        return reps(10000);
    }

    @Benchmark
    @OperationsPerInvocation(100000)
    public int measureWrong_100000() {
        return reps(100000);
    }

运行上面测试代码，可以看到随着循环次数变大，执行效率越高。

正确的示例

    int x = 1;
    int y = 2;

    @Benchmark
    public int measureRight() {
        return (x + y);
    }

    $ java -jar target/benchmarks.jar JMHSample_11 -wi 5 -i 5 -f 1

使用jmh的参数来控制循环次数才是正经。

## forking

一般来说，我们在写benchmark时，会将多个测试点放在一个jvm中一起运行，实际上这是有问题的，前一个测试程序的运行会对后一个测试程序产生影响，如内存、gc等，因此每次都应该使用新的jvm进程运行测试程序。

jmh可以按照参数指定的规则fork出对应的jvm进程来测试每一个目标方法。

    java -jar target/benchmarks.jar JMHSample_12 -wi 5 -i 5

## false sharing

这个方面jmh没有做什么特别处理，需要开发者想办法，主要的策略还是padding。jmh提供了几种padding的方案：

* 直接加冗余字段:

        @State(Scope.Group)
        public static class StatePadded {
            int readOnly;
            int p01, p02, p03, p04, p05, p06, p07, p08;
            int p11, p12, p13, p14, p15, p16, p17, p18;
            int writeOnly;
            int q01, q02, q03, q04, q05, q06, q07, q08;
            int q11, q12, q13, q14, q15, q16, q17, q18;
        }

* 通过继承添加padding

        public static class StateHierarchy_1 {
            int readOnly;
        }

        public static class StateHierarchy_2 extends StateHierarchy_1 {
            int p01, p02, p03, p04, p05, p06, p07, p08;
            int p11, p12, p13, p14, p15, p16, p17, p18;
        }

        public static class StateHierarchy_3 extends StateHierarchy_2 {
            int writeOnly;
        }

        public static class StateHierarchy_4 extends StateHierarchy_3 {
            int q01, q02, q03, q04, q05, q06, q07, q08;
            int q11, q12, q13, q14, q15, q16, q17, q18;
        }

        @State(Scope.Group)
        public static class StateHierarchy extends StateHierarchy_4 {
        }

* 使用数组添加padding

        @State(Scope.Group)
        public static class StateArray {
            int[] arr = new int[128];
        }

        @Benchmark
        @Group("sparse")
        public int reader(StateArray s) {
            return s.arr[0];
        }

        @Benchmark
        @Group("sparse")
        public void writer(StateArray s) {
            s.arr[64]++;
        }

* 通过`Contended`注解，需要至少JDK8

    @State(Scope.Group)
        public static class StateContended {
            int readOnly;
            @sun.misc.Contended
            int writeOnly;
        }

## sharing object

使用`State`注解标注需要在测试中共享的状态数据，共享数据的层级包括

* `Benchmark`: 整个测试之间
* `Group`: 同一个线程组之间
* `Thread`: 单个线程内


# Resources

[1]:    https://openjdk.java.net/projects/code-tools/jmh/
[2]:    https://hg.openjdk.java.net/code-tools/jmh/file/40c1cca654c1/jmh-samples/src/main/java/org/openjdk/jmh/samples
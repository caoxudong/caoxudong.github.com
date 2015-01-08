---
category:   pages
layout:     post
tags:       [java, jvm, translation]
---


JVM性能优化, Part 5 — 伸缩性
=================



原文地址 <http://www.javaworld.com/javaworld/jw-03-2013/130301-jvm-performance-optimization-java-scalability.html?page=1>

[转载： JVM性能优化， Part 1 — 概述][1]

[转载： JVM性能优化， Part 2 — 编译器][2]

[转载： JVM性能优化， Part 3 — 垃圾回收][3]

[转载： JVM性能优化,  Part 4 — C4 垃圾回收][4]

大部分开发人员在处理JVM性能问题时都没有涉及到问题的本质，也就是说，花费大量的时间来解决应用程序层面的性能瓶颈。而我一直将之视为一个系统性的问题，这个观点也贯穿于本系列的全部文章中。我认为，限制企业级Java应用程序伸缩性的根本因素在于JVM技术本身。在进一步讨论这个问题之前，先看以下几个事实：

*   现代服务器通常都有大量内存可用；
*   分布式系统会消耗大量内存，而对分布式系统的需求在持续增加；
*   普通Java应用程序所使用堆的大小介于1GB与4GB之间，远小于服务器所提供的内存大小，也远小于分布式系统所需要的内存大小。这种情况也称为"Java应用程序的内存墙"，如图-1所示。


!["Figure 1. The Java application memory wall from 1980 to 2010"][17]

Image copyright Azul Systems.

在这里，开发人员面临一个两难的境地：

1.  如果给应用程序分配的内存较少，JVM释放内存的速度跟不上应用程序分配内存的速度，最终，JVM会抛出OOM错误，并退出。有鉴于此，就需要给应用程序分配更多的内存。

2.  如果增加对响应时间比较敏感的应用程序的内存大小，那么最终堆中会充满碎片。这是无法避免的，除非你重启应用程序，或者针对特殊需求实现特殊的架构。当堆中充满碎片时，应用程序会被迫挂起，暂停时间可长可短，具体长度依赖于应用程序特点、堆大小和JVM参数等因素。

大多数关于JVM暂停时间的讨论都只涉及到平均暂停时间和期望暂停时间，而没有涉及最差情况下的暂停时间，即需要对整个堆进行压缩时所需要的时间。在生产环境下，最差情况的暂停时间可能会达到1秒/GB。

大多数企业级应用程序都无法接受2秒到4秒的暂停，所以尽管内存不够用，这些应用程序的内存一般都限制在2到4GB。在64位系统中，为了提升JVM的伸缩性，可能会将堆的大小设置到16GB甚至是20GB，以满足对系统响应时间的要求，但相对于现代应用程序所需要的内存大小来说，仍相差甚远。之所以造成这种窘境，是因为使用了stop-the-world式的垃圾回收算法，也正因如此，导致了Java开发人员的工作略显尴尬：

*   架构和建模时，采用的是“小而多”的策略。虽然这会给监控和管理带来很大麻烦，但不得不这么做。

*   不断的对JVM配置和应用程序进行调优，以避免最差情况出现。大多数开发人员都期望应用程序暂停发生在系统负载较低的时刻，这根本就是不可能的。这也是为什么我将之称为“唐吉珂德式任务”。

下面，就对Java的伸缩性做进一步讨论。

# 两种部署模型

为了能够充分利用内存，很多团队采用在部署应用程序时采用“小而多”的策略，但在管理和监控这些应用程序实例时却有不小的困难。

另一个问题是，开发团队需要为系统负载的峰值做好准备，即需要为应对最差情况下峰值负载而调整堆的大小。实际上，在日常负载情况下，根本不需要这么多内存，造成了大量的浪费。某些开发团队在部署应用程序时，在每台服务器上最多部署两到三个实例。但这种方式造成的资源浪费尤其大，尤其是在系统负载没有达到峰值的时候。

在图2中，有两种部署模型，左侧是“小而多”，右侧是“大而少”。哪种更好？

!["Figure 2. Fewer larger instances"][18]

Image copyright Azul Systems.

我在最近的一片文章中谈到，并发压缩的垃圾回收可以解决这个问题。使用这种垃圾回收方式，开发团队可以部署少量、具有较大内存应用程序实例，消除对伸缩性的限制。目前，只有Azul公司的Zing JVM提供了采用并发压缩方式的垃圾回收器。Zing JVM是一款以服务器模式（server-side）运行的JVM，目前开发人员使用的还不多。希望将来能够有更多的开发人员可以从JVM级解决Java的伸缩性问题。

就目前来说，性能调优仍然是解决Java伸缩性主要方式，下面就谈谈一些主要的调优参数及其功能。

# 参数调优实例

最知名的JVM性能参数，也是大部分Java开发人员在启动Java应用程序时会使用的参数，就是`-Xmx`。该参数指定了Java堆内存的最大值，但要注意的是，不同JVM对该参数的实现略有不同。

某些JVM将内部结构——包括编译器线程、GC对象、代码缓存（code cache）等——所占用的内存计算在`-Xmx`设置的内存，另一些JVM则使用额外的内存来存储这些结构。因此，Java进程所占用的内存往往不等于`-Xmx`所设置的内存。

参数`-Xmx`设置的是可用内存的上限值，应用程序所使用的内存不会超过这个值。如果参数`-Xmx`设置不当，即如果应用程序的内存分配速率较快、对象的存活时间较长，或者对象较大，导致应用程序占用的内存超过了先前设置的上限值，那么JVM会抛出OOM错误，并终止应用程序运行。

如果应用程序在运行过程中内存紧张，那么只好调大参数`-Xmx`的值，并重启应用程序。为了避免频繁重启，大多数生产环境中的JVM都会为最差情况调整参数，也因此造成了很大的资源浪费。

> 提示：生产环境调优
> 
> Java开发人员常犯的一个错误是，只在实验环境对堆大小进行调优，而忘记了在生产环境中重调。这两种环境中的系统负载相差巨大，因此需要对生产环境下的堆大小进行调优。

## 垃圾回收器调优

JVM参数`-Xns`和`-XX:NewSize`用于设置使用了[分代式垃圾回收器][5]的JVM堆中年轻代（young generation, nursery generation）内存的大小。

大多数Java开发人员总是在实验环境下对年轻代大小进行调优，因此应用到生产环境时效果不好。通常情况下，会将堆的1/2或1/3分配给年轻代，大部分时间，这种配置都能正常运转。但是，这种配置方式并非基于真正的规则，因为真正正确的设置要依应用程序的实际运行情况而定。在设置年轻代大小之前，最好能够掌握存活时间较长的对象的实际提升速率（actual promotion rate）和对象本身的大小，这样才不会老年代中出现提升失败（promotion failure）的情况。（提升失败表明老年代空间过小，会频繁触发垃圾回收操作，最终可能会导致OOM错误。详情情况参见[JVM性能优化， Part 3 —— 垃圾回收][3]中的讨论）

另一个与年轻代设置相关的参数是`-XX:SurvivorRatio`。这个参数用于设置提升速率，即对象在被提升到老年代之前要挺过多少次垃圾回收。要想正确设置这个值，就需要清楚的了解年轻代垃圾回收的频率，并正确预估对象的存活时间。注意，正确设置这些参数的依据是清楚的指导线上应用程序的内存分配速率，因此，实验环境下的配置根本不能用于生产环境。

## 垃圾回收器调优

如果应用程序对暂停时间比较敏感，你最好使用并发垃圾回收器——至少在出现了更好的垃圾回收器之前是这样。尽管并行方案在吞吐量上有着更优异的表现，而且应用广泛，但是，并行方案在响应时间方面的表现稍显逊色。目前，并发垃圾回收是唯一能够实现一定程度一致性和最少stop-the-world式操作的解决方案。不同的JVM实现提供了不同的参数来启用并发垃圾回收。如在Oracle JVM中需要使用参数`-XX:+UseConcMarkSweepGC`。最近，使用并发方案的G1成为了Oracle JVM中的默认垃圾回收器。

> GC算法比较
> 
> 参见[JVM性能优化， Part 3 —— 垃圾回收][3]中对各类垃圾回收算法的介绍。

# 性能调优不是银弹

依据我对JVM性能调优的经验，没有“真正正确”的配置。设置的每个JVM性能参数都是针对特定应用程序场景的，若场景发生变化，就需要重新进行调优。

以设置堆大小为例：如果为应用程序设置2GB大小的堆可以应对20万并发请求，那么当并发量达到40万时，这种设置就是错误的。再比如提升速率的设置：测试用例中的设置可以应付没毫秒1万的事务处理，但在生产环境中有可能会达到没毫秒5万事务处理，这时，之前的设置就是错误的。

大多数企业级应用程序的负载都是会动态变化的，这也是Java在这个领域获得成功的原因之一。Java的动态内存管理和动态编译特性决定了要想Java运行的更好，就需要使用更灵活更具动态性的配置。下面的两种配置哪种更适用于你的生产环境？

Listing 1.

    java -Xmx12g 
        -XX:MaxPermSize=64M 
        -XX:PermSize=32M 
        -XX:MaxNewSize=2g 
        -XX:NewSize=1g 
        -XX:SurvivorRatio=16 
        -XX:+UseParNewGC 
        -XX:+UseConcMarkSweepGC 
        -XX:MaxTenuringThreshold=0 
        -XX:CMSInitiatingOccupancyFraction=60 
        -XX:+CMSParallelRemarkEnabled 
        -XX:+UseCMSInitiatingOccupancyOnly 
        -XX:ParallelGCThreads=12 
        -XX:LargePageSizeInBytes=256m 
        …
    

Listing 2.

    java --Xms8g 
        --Xmx8g 
        --Xmn2g 
        -XX:PermSize=64M 
        -XX:MaxPermSize=256M 
        -XX:-OmitStackTraceInFastThrow 
        -XX:SurvivorRatio=2 
        -XX:-UseAdaptiveSizePolicy 
        -XX:+UseConcMarkSweepGC 
        -XX:+CMSConcurrentMTEnabled 
        -XX:+CMSParallelRemarkEnabled 
        -XX:+CMSParallelSurvivorRemarkEnabled 
        -XX:CMSMaxAbortablePrecleanTime=10000 
        -XX:+UseCMSInitiatingOccupancyOnly 
        -XX:CMSInitiatingOccupancyFraction=63 
        -XX:+UseParNewGC 
        --Xnoclassgc 
        …
    

上面两个列表中的配置都可以正常工作，它们所面对的是不同的场景，是专为该场景下应用程序的特性进行调优所得出的结果。遗憾的是，虽然在实验环境下达到了不错的性能，在生产环境却下不尽如人意。Listing 1中的配置在生产环境中很快失败，因为测试环境中并不具有生产环境中的动态负载。Listing 2中的配置在应用程序进行升级之后失败了，因为它并不是适用于新版本中的一些特性。当出现错误时，指责往往会指向开发团队，但真的应该由开发团队背黑锅么？

> “曲线救国”？
> 
> 一些应用通过精确测量事务对象大小并调整应用架构以适应这个大小来节省内存空间。这种方法可以减少内存中的碎片，在某些情况下，即使不执行内存压缩操作也可以运行较长时间。另一种解决方案是使对象的生命周期尽可能的短，这样它们就不会被提升到老年代，也就可以避免出现频繁老年代垃圾回收和对整个堆进行压缩的情况。这两种方案都是可行的，但是给开发人员带来的较多的限制。

# 谁该对应用程序性能负责？

竞选达到白热化时，门户网站宕机了；市场行情出现变化时，交易系统宕机了；假日购物季如火如荼时，网站宕机了。这些都是由于未能根据应用程序自身特点正确设置JVM参数而造成失败的案例。当造成经济损失时，开发团队往往备受责难（一些情况下，确实应该如此），但是，JVM厂商就一点责任都没有么？

JVM厂商认识到性能调优参数的重要性是有重要意义的，至少在短期内是这样的。新的调优参数迎合了应用程序新的需要，满足了应用程序的需求。JVM厂商提供了更多的性能调优参数给应用程序开发人员，将提升应用程序性能的责任推给应用程序开发人员，减少JVM开发人员的工作量，但从长远看，JVM开发人员反而多了很多支持性工作。新的性能调优参数推迟了最差情况的出现时间，但并不能消除最差情况。

毫无疑问，发展JVM技术还有许多工作要做。此外，只有应用程序开发者才能真正了解应用程序的真是特点，但是要他们预测确实勉为其难。过去，JVM厂商解决Java应用程序的性能和伸缩性问题时，并不是进行JVM参数调优，而是开发新的、更好的垃圾回收算法。想象一下，如果OpenJDK社区能够一起重新思考垃圾回收的问题，那将会是多么美妙的事情。

> JVM性能基准测试
> 
> 有时候，性能调优参数也是JVM厂商之间竞争的工具之一，因为不同的调优参数影响JVM的性能。在本系列的终结篇中会对JVM的性能基准测试进行讨论。

# JVM开发人员的所面临的挑战

在企业级应用程序中，对伸缩性的要求是，JVM能够对应用程序负载的变化做出响应。这是保证应用程序在吞吐量和响应时间方面具有良好表现的关键。一般情况下，只有JVM开发人员能够对JVM的表现做调整，其中涉及以下几点：

*   **调优**：对于给定的某个应用程序来说，唯一的问题是，“需要使用多少内存？” 然后，JVM应该能够根据应用程序负载和特性的变化动态做出调整。
*   **部署模型**：现代服务器都提供了大量内存供使用，但为什么JVM实例无法将这些内存有效的利用起来呢？“小而多”的部署模型浪费严重，既不经济，也不环保。Modern JVMs should support sustainable IT.（不懂，没翻）
*   **性能与伸缩性**：Java开发人员本不应该将太多精力花在提升性能和伸缩性上。JVM厂商和OpenJDK社区需要解决JVM所带来的伸缩性问题，消除stop-the-world式的操作。

# 结论

Java开发人员本不应该花时间去学习如何配置JVM。如果JVM自己能够做好这些事，如果有更好垃圾回收器，那么Java自身的伸缩性问题才能得以解决。这样，Java开发人员才能将更多的聪明才智用于开发出色的应用程序，而不是浪费于无尽的JVM调优中。JVM开发人员和JVM厂商，Java的未来就在你们身上。（I challenge JVM developers and vendors to do what's needed and (to cite Oracle) "help make the future Java!"）（这句话翻的太烂）

# 关于作者

Eva Andearsson对JVM计数、SOA、云计算和其他企业级中间件解决方案有着10多年的从业经验。在2001年，她以JRockit JVM开发者的身份加盟了创业公司Appeal Virtual Solutions（即BEA公司的前身）。在垃圾回收领域的研究和算法方面，EVA获得了两项专利。此外她还是提出了确定性垃圾回收（Deterministic Garbage Collection），后来形成了JRockit实时系统（JRockit Real Time）。在技术上，Eva与SUn公司和Intel公司合作密切，涉及到很多将JRockit产品线、WebLogic和Coherence整合的项目。2009年，Eva加盟了Azul System公，担任产品经理。负责新的Zing Java平台的开发工作。最近，她改换门庭，以高级产品经理的身份加盟Cloudera公司，负责管理Cloudera公司Hadoop分布式系统，致力于高扩展性、分布式数据处理框架的开发。

# 相关资源

*   "[Understanding Java Garbage Collection and What You Can Do about It][6]" (Gil Tene, InfoQ, December 2011): Azul cofounder Gil Tene explains the workings of a garbage collector, including terminology, metrics, key mechanisms, and the application memory wall challenge discussed in this article.
*   [Oracle HotSpot FAQ][7]: State-of-the-art tuning advice for long pause times is to decrease heap size.
*   "[Maximum Java heap size of a 32-bit JVM on a 64-bit OS][8]" (Stackoverflow, September 2009): Developers on Stackoverflow discuss the challenge of tuning Java heap size for real-world systems.
*   "[About OpenDJ and Hotspot JVM G1][9]" (Ludovic Poitou, Ludo's Sketches, May 2012): JVM performance has far-reaching implications for innovation on Java projects like the OpenDJ Directory Services Project.

## 本系列的其他文章

[Part 1: Overview][10] (August 2012)

[Part 2: Compilers][11] (September 2012)

[Part 3: Garbage collection][12] (October 2012)

[Part 4: Concurrently compacting (C4) GC][13] (November 2012)

## JavaWorld中的相关文章

*   "[Java performance programming, Part 1: Smart object-management saves the day][14]" (Dennis M. Sosnoski, August 2001).
*   "[Pick up performance with generational garbage collection][5]" (Ken Gottry, 2002)
*   "[Java's garbage-collected heap][15]" (JW Classics, Bill Venners, 1996)
*   "[Building cloud ready, multicore friendly applications, Part 1][16]" (Guerry Semones, March 2009).





[1]:    /post/jvm_performance_optimization_1_overview
[2]:    /post/jvm_performance_optimization_2_compiler
[3]:    /post/jvm_performance_optimization_3_gc
[4]:    /post/jvm_performance_optimization_4_c4_gc
[5]:    http://www.javaworld.com/javaworld/jw-01-2002/jw-0111-hotspotgc.html
[6]:    http://www.infoq.com/presentations/Understanding-Java-Garbage-Collection
[7]:    http://www.oracle.com/technetwork/java/hotspotfaq-138619.html#gc_pause
[8]:    http://stackoverflow.com/questions/1434779/maximum-java-heap-size-of-a-32-bit-jvm-on-a-64-bit-os
[9]:    http://ludopoitou.wordpress.com/2012/05/02/about-opendj-and-hotspot-jvm-g1/
[10]:   http://www.javaworld.com/javaworld/jw-08-2012/120821-jvm-performance-optimization-overview.html
[11]:   http://www.javaworld.com/javaworld/jw-09-2012/120905-jvm-performance-optimization-compilers.html
[12]:   http://www.javaworld.com/javaworld/jw-10-2012/121010-jvm-performance-optimization-garbage-collection.html
[13]:   http://www.javaworld.com/javaworld/jw-11-2012/121107-jvm-performance-optimization-low-latency-garbage-collection.html
[14]:   http://www.javaworld.com/jw-11-1999/jw-11-performance.html
[15]:   http://www.javaworld.com/javaworld/jw-08-1996/jw-08-gc.html
[16]:   http://www.javaworld.com/javaworld/jw-03-2009/jw-03-multicore-and-cloud-ready-1.html
[17]:   /image/jvmperf5-fig1.png
[18]:   /image/jvmperf5-fig2.png

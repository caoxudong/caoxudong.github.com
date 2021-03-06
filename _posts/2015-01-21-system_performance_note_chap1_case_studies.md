---
title:      《System Performance》笔记，chap1，case study
layout:     post
category:   blog
tags:       [tomcat, translation, java, performance]
---


# case 1: slow disks

## 现象

dba通报有些sql的执行时间超过1s，以往并不常见，但在过去的一周内却达到了每小时有几十条慢sql，同时硬盘很忙，使用率达到80%，但其他硬件使用情况（如CPU使用率）却并不高。从历史数据看，过去一周中，硬盘和CPU的使用率一直比较稳定。

## 处理过程

Scott（故事的主人公，系统管理员）的处理过程如下：

1. 检查磁盘错误数量，数值为0；
2. 使用iostat检查读写IO情况，以1分钟为间隔来看的话，磁盘使用率为80%，而以1s为间隔来看的话，常常会得到100%，造成吞吐量饱和，增加了磁盘IO的延迟；
3. 为了证明造成磁盘使用率高不是由于执行sql查询语句引起的，使用基于动态追踪的脚本来记录执行时间和栈引用记录；
4. 步骤3的结果显示，数据库通常会被阻塞在对文件系统的读操作上，即执行查询语句上，时间长达数毫秒，从而证明性能问题是由于磁盘使用率太高造成的；
5. 排查磁盘使用率太高的原因，从统计数据上看，磁盘使用率和负载成正相关关系。使用`iostat`等工具来测算IOPS、吞吐量、磁盘IO的平均延迟、读写比例，以及每次IO操作的平均大小，借以估测是随机IO操作还是顺序IO操作；
6. 为了获得更详细的内容，Scott使用了磁盘IO级追踪技术，结果证明问题就在于磁盘IO遇到了高负载，而非磁盘本身出现了故障；
7. 从磁盘操作日志看，并没有明显的异常行为，而DBA团队反馈"数据库负载并无明显提升，SQL查询频率也比较正常"，这一点也印证了之前的探查结果，"CPU负载并无明显提升"；
8. 思考"在什么情况下会使磁盘负载提升，但却不会引发CPU负载提升"，一位同事提议检查文件系统碎片（file system fragmentation），经检查，碎片化只有30%；
9. 在思考了内核的IO调用栈后，忽然想到文件系统缓存（页缓存）未命中频率太多的话，也会提升磁盘负载；
10. 他检查了文件系统的缓存命中率，数值为91%，看起来还不错，不过由于没有历史数据，无法做纵向比较，但其他数据库服务器的文件系统缓存命中率都超过了97%，此外，还发现问题服务器的文件系统缓存容量也比其他数据库服务器大得多；
11. 这时他注意到一个之前被忽视的事情，在问题服务器上，还运行着一个原型应用程序，虽然不是用于生产环境，但也消耗了不少内存，占用了文件系统缓存，降低了缓存的命中率，进而提升磁盘负载，造成了数据库系统的性能问题；
12. 联系原型应用程序的开发团队，将该应用程序移到其他服务器上，于是乎一切恢复正常。

## 分析

### 查看磁盘I/O信息

使用`iostat -x`可以查看系统的IO情况。

iostat的实现是查看`/proc/diskstats`文件以获取与磁盘相关的统计信息，其每行数据字段的含义如下（详细内容参见[iostats.txt文件][1]）：

1. 自系统启动以来，成功完成的读操作数量。
2. 自系统启动以来，合并的读（写）操作数量（字段6与此类似）。合并相邻的读（写）可以提升执行性能。在具体执行操作之前，合并相邻的读（写）操作，然后再作为一个操作提交到硬盘可以提升整体性能。
3. 自系统启动以来，成功读取的硬盘扇区数目。
4. 自系统启动以来，执行读操作所花费的总时间，单位为毫秒。
5. 自系统启动以来，成功完成的写操作。
6. 参见字段2的说明。
7. 自系统启动以来，成功写入的硬盘扇区数目。
8. 自系统启动以来，执行写操作所花费的总时间，单位为毫秒。
9. 当前系统中正在执行的IO操作的数目。正常情况下，该字段的数值最终应该归为0.
10. 自系统启动以来，存在I/O操作的总时长，单位为毫秒。当字段9的数值不为0时，该字段的数值就会增长。
11. 这个字段的数值会在每次启动I/O操作、完成I/O操作、合并I/O操作，或读取这些统计数字时做累加操作，每次累加的数值等于正在进行的I/O操作数量（即字段9的值）乘以自上次更新本字段之后花费在I/O操作上的时间。最后，该字段的值可用于表示，自系统启动以来，I/O操作的完成和排队情况。

其中，磁盘使用率 = 单位时间内执行I/O操作占用的时间 / 单位时间（参见[man iostat][5]）

### 动态追踪脚本

linux上，可以使用[systemtap][2]对内核运行情况做动态追踪（在某些类Unix上，可以使用[dtrace][3]）。

systemtap的教程中提供了一些示例，例如[iotime.stp][6]和[ioblktime.stp][7]，可用于监控磁盘的IO操作的执行时间和阻塞时间。


### linux IO栈

![Linux-storage-stack-diagram][8]

### 文件系统碎片

[文件系统碎片][9]会增加磁头的移动距离，降低系统吞吐量。使用SSD的话，碎片化所带来的影响会小一些。


### 文件系统缓存

[文件系统缓存][10]

# resources

1. [iostats.txt][1]
2. [systemtap][2]
3. [dtrace][3]
4. [sysstat][4]
5. [man iostat][5]
6. [iotime.stp][6]
7. [ioblktime.stp][7]
8. [File system fragmentation][9]





[1]:    https://www.kernel.org/doc/Documentation/iostats.txt                                        "iostats.txt"
[2]:    https://sourceware.org/systemtap/                                                           "systemtap"
[3]:    https://dtrace.org/                                                                          "dtrace"
[4]:    https://sebastien.godard.pagesperso-orange.fr/                                               "sysstat"
[5]:    https://sebastien.godard.pagesperso-orange.fr/man_iostat.html                                "man_iostat"
[6]:    https://sourceware.org/systemtap/SystemTap_Beginners_Guide/iotimesect.html                  "iotime.stp"
[7]:    https://sourceware.org/systemtap/SystemTap_Beginners_Guide/ioblktimesect.html               "ioblktime.stp"
[8]:    /image/Linux-storage-stack-diagram_v3.17.png                                                "Linux-storage-stack-diagram"
[9]:    https://en.wikipedia.org/wiki/File_system_fragmentation                                      "File_system_fragmentation"
[10]:   https://msdn.microsoft.com/en-us/library/windows/desktop/aa364218(v=vs.85).aspx             "File Caching"
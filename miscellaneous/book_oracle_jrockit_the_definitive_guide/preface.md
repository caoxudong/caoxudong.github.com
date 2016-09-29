Java世界，变幻莫测，风云际会，英雄辈出，各种机缘巧合促成了本书的完成。

那时，互联网还没有在世界范围内普及，本书的两位作者还只是个高中生，整天混迹于BBS，在讨论数学问题的过程中结识了对方，成为好友，并将这份友情延伸到了生活和共同合作的项目中。后来，我们又共同进入了位于斯德哥尔摩的瑞典皇家理工学院（简称KTH）学习。

在KTH，我们结识了更多的朋友，在第3学年的数据库系统课程中，我们找到了足够多的、志同道合的人，准备干点事业。最终，我们决定成立一家名为Appeal Software Solutions（其首字母缩写为A.S.S，当时看来绝对是个完美的名字）的咨询公司。我们中的一些成员是半工半读的，所以预留部分收入，以便当所有成员毕业后可以使公司驶入正轨。我们的长期目标是公司可以开发产品，而不仅仅是做咨询，但当时我们还不知道到底要开发什么。

1997年，由于在Sun公司赞助的大学生竞赛中胜出，Joakim Dahlstedt、Fredrik Stridsman和Mattias Joëlson获得了参加首届JavaOne大会的入场券。有意思的是，下一年，他们又干了一票。

所有的一切都源于我们的3位英雄在1997年和1998年参加的两届JavaOne大会。在会上，他们注意到，Sun公司的自适应JVM，HotSpot，在当时被誉为能够彻底解决Java性能问题的终极JVM，在这两年里缺没有什么实质性的进步。那时的Java主要是解释执行的，市场上有一些针对Java的静态编译器，可以生成运行速度快于字节码的静态代码，但是，这从根本是违反了Java的语义。正如本书中反复强调的，到目前为止，相比静态解决方案，具有自适应调整功能的运行时可以迸发出更强大的威力，但相对的，实现起来也更加困难。

1998年，HotSpot没什么动作，年轻而骄傲的我们喊出了“这难个毛啊？看我们做一个比丫更好、更快的虚拟机出来！”。我们专业背景不错，而且也有了明确的方向，于是就开干了。尽管后来的实践证明了我们当时图样图森破，但在这里需要提醒读者的是，当时是1998年，Java在服务器端的腾飞才刚刚开始，J2EE刚刚出现，几乎没什么人听说过JSP。因此，在1998年，我们所面临的问题还小得多。

我们最初的计划是，用一年时间实现一个JVM的demo，同时继续咨询服务，保证开发JVM所需的资金。最初，新JVM的名字是“RockIT”，结合了“Rock and Roll”（摇滚）、Rock Solid（坚如磐石）和IT三者的意思。后来由于注册商标原因，又在名字前面加了一个字母“J”。

在度过了初期的一些列失败后，我们需要寻找风投。当然，向投资人解释清楚为什么投资一款提供了自适应运行时功能的JVM（同时期的其他竞争对手都是免费提供的）能够赚钱是一大难题。不仅仅是因为当时是1998年，更重要的因素是，投资人还无法理解这种既不需要给用户发广告短信，也不需要发送电子邮件订单的商业模式。

最终，我们获得了一个风投，并在2000年初，发布了JRockit 1.0版本的第一个原型。当时有人将之应用于多线程服务器程序，JRockit 1.0的表现非常好，性能优异，风光一时。以此为契机，我们获得更多的投资，将咨询业务拆分为一个独立的分公司，公司的名字也从“Appeal Software Solutions”变成了“Appeal Virtual Machines”。我们又雇佣了一些销售人员，并就Java证书的问题开始与Sun协商。

JRockit的相关工作越来越多。2001年的时候，处理咨询业务的工程师都转如了与JVM相关的项目中，而子公司也宣告停业。这时，我们清楚的指导如何将JRockit的性能再提升一步，同时也意识到在这个过程中，我们消耗资源的速度太快了。于是管理层开始寻找大公司作为接盘虾。

2002年2月，BEA公司收购Appeal Virtual Machines公司，让投资人送了一口气，同时也保证了我们有足够的资源做进一步的研究和开发。为配合测试，BEA建立了服务器机房，加固了地板，保证了电力供应。那时，有一根电缆从街上的接线盒通过服务器机房的窗户连进来。过了一段时间，这个服务器机房已经无法放下开发测试所需的全部服务器了，于是我们又租了另一个机房来放置服务器。

作为BEA平台的一部分，JRockit的发展相当理想。在BEA的前两年，我们开发了区别于其他Java解决方案的新特性，例如后来发展成为JRockit Mission Control的开发框架。此后，出版物、世界级测试跑分和虚拟化平台等不断涌现。在拥有了JRockit后，BEA与Sun和IBM并列为3大JVM厂商，成了拥有数千用户的平台。JRockit产生的利润，首先是来自工具套件，然后是产品JRockit Real Time提供的无比强大GC性能。

2008年，Oracle收购BEA，这一事件波澜不惊，反倒是JRockit和相关团队得到了更多的关注。

经过这些年的发展，令我们感到骄傲的是，JRockit的用户遍布全球，为关键应用的运行保驾护。同样令我们感到骄傲的是，当初6个少年在斯德哥尔摩老城区（译者注，原文为Old Town，是一个地名）的一个小破屋中的设计已经成长为世界顶级产品。

本书的内容是作者们这十年来与自适应运行时，尤其是JRockit，打交道的经验总结。就我们所知，其中的很多内容，还没有在其他出版物中出现过。

希望本书能对你有所帮助。


# 章节内容

* **[第1章：起步][1]**    这一章对JRockit和JRockit Mission Control做了简要介绍，其内容包括如何获得相关软件及软件对各平台的支持情况。本章中的内容还包括在切换到JVM厂商的产品时所需要注意的问题，JRockit和JRockit Mission Control中版本号的命名规范，以及如何获取更多相关内容。
* **[第2章：自适应代码生成][2]**    在该章中将会对自适应运行时环境中的代码生成做简要介绍。主要内容包括，为什么在JVM中实现自适应代码生成更有难度，而其实现所能发挥的功效却更加强大；JVM针对性能优化所采取的措施；用一个例子对JRockit的代码生成和优化流水线进行介绍；对自适应代码生成和传统代码生成这两种方案的优劣做简单讨论；介绍如何使用命令行选项（flags）和指导文件（directive files）来控制JRockit的代码生成策略。
* **[第3章：自适应内存管理][3]**    这一章对自适应运行时环境中的内存管理做了介绍。主要内容包括，自动内存管理的相关概念和算法，垃圾回收器的工作机制，JVM在位对象分配内存时所作的具体工作，以及为便于执行垃圾回收都需要记录哪些元数据信息。这一章的后半部分所介绍的内容主要包括，可用于控制内存管理的Java API，和可应用于具有确定性延迟要求环境下的JRockit Real Time产品。最后，介绍了如何使用命令行参数来控制JRockit JVM的内存管理。
* **[第4章：线程与同步][4]**    在Java和JVM中，线程与同步是非常重要的概念，该章对与之相关的概念和在JVM中的简要实现做了具体介绍，并对Java内存模型及其内在的复杂性做了深入讨论。像JVM的其他部分一样，自适应优化对线程和同步的执行也有很大影响，该章中会对此做简单介绍。此外，这一章还对多线程编程中常见的一些错误做了介绍，例如双检查锁失效的问题。最后，讲解了如果对JRockit中的锁进行分析，以及如何通过命令行参数控制线程的部分行为。
* **[第5章：基准测试与性能调优][5]**    这一章会针对使用基准测试和制定性能目标的重要性进行讨论，此外还对一些针对Java的工业级基准测试套件进行介绍，最后以JRockit JVM为例介绍如何根据基准测试的结果对应用程序和JVM进行调优，以及相关命令行参数的书用。
* **[第6章: JRockit Mission Control套件][6]**    第6章对JRockit Mission Control工具套件进行了介绍，包括启动和各种详细配置。此外，还介绍了如何在Eclipse中运行JRockit Mission Control，以及如何让Eclipse运行在JRockit JDK上。在该章中，还介绍了与通过JRockit MissionControl远程访问JRockit JVM和故障处理相关的内容。
* **[第7章 Management Console][7]**    第7章对JRocki Mission Control的Management Console组件进行介绍，讲解了诊断命令的概念与如何在线监控一个JVM示例。在该章中，还对触发器规则和通知做了介绍，最后讲解了如何国展Management Console。
* **[第8章 运行时分析器][8]**    第8章对JRockit运行时分析器（JRockit Runtime Analyzer, JRA）进行了简单介绍。JRA是一款可以按需定制的分析框架，用于对JRockit以及运行在其中的应用程序的执行状况做记录，以便进行离线分析。具体的记录内容包括方法、锁、垃圾回收器、优化信息、对象统计，以及延迟事件等信息。得到这些记录信息后，就可以针对问题进行离线分析了。
* **[第9章 Flight Recorder][9]** 第9章对飞行记录仪（JRockit Flight Recorder，JFR）进行了讲解。JFR是新版本JRockit Mission Control套件中对JRA升级。在这一章中，详细介绍了JFR的功能，与JRA的区别，以及如何扩展JFR。
* **[第10章 Memory Leak Detector][10]** 在这一章中对JRockit Mission Control套件中的最后一个工具JRockit Memory Leak Detector进行介绍。具体来说，在该章中，介绍了内存泄漏的概念，Memory Leak Detector的适用场景和内部实现。
* **[第11章 JRCMD][11]** 这一章堆命令行工具JRCMD进行了介绍。通过JRCMD，用户可以操作本机上所有的JVM。在该章用，按字母表顺序列出了JRCMD中最重要的诊断命令，并通过示例讲解介绍了如何使用这些命令。
* **[第12章 JRockit Management API][12]** 这一章中介绍了如何编程实现对JRockit JVM内部功能的访问。JRockit Mission Control套件就是基于此Management API实现的。尽管该章中介绍的JMAPI和JMXMAPI并未得到完整的官方支持，但从中还是可以了解到一些JVM的工作机制。希望读者可以实际动手操练一下以加深理解。
* **[第13章：JRockit Virtual Edtion][13]** 这一章对现代云环境中的虚拟化进行了介绍，主要内容包括了JRockit Virtual Edition产品的相关概念和具体细节。通常来说，操作系统很重要，但对于JRockit Virtual Edition来说，移除软件栈中的操作系统层并不是什么大问题，而且移除之后还可以降低操作系统层所带来的性能开销。在该章的末尾，还对虚拟化Java运行时环境的发展方向做了简单介绍。

# 读书之前的准备工作

请正确安装JRockit JVM和运行时环境。为了更好的理解本书的内容，请使用JRockit R28及其之后的版本，当然使用JRockit R27也是可以的。此外，安装Eclipse for RCP/Plug-in Developer也是很有用的，尤其是在介绍扩展JRockit Mission Control部分的内容时，动手实践一下很有必要。

# 目标读者

本书面向所有以Java编程语言为工作中心的开发人员和系统管理员。本书分为3大部分。

第一部分着重介绍了JVM和自适应运行时的工作原理，包括自适应运行时的优势和劣势，并以JRockit为例专门介绍到底什么是好的Java代码。深入到JVM这个黑盒中，使读者可以审视运行Java应用程序时，JVM会提供哪些关键运行时数据。理解第一部分的内容可以帮助开发人员和架构设计者更好的指定决策。这部分也可以看作是高校中有关姿势运行时的学习资料。

第二部分着重介绍了JRockit Mission Control套件的具体功能，以及如何使用JRockit Mission Control套件来查找应用程序的性能瓶颈。对于想要对JRockit系统做性能调优的系统管理员和开发人员来说，这部分内容非常有用。但应该记住的是，对JVM层面的调优也就这么多了，对应用程序本身的业务逻辑和具体实现做调优其实是更简单更有效的。

第三部分（也就是[第13章][13]）对新近的、以及还未发布的JRockit相关技术做了介绍，主要面向对Java技术发展方向比较感兴趣的读者。这部分内容着重对Java虚拟化进行讲解。

最后，列出了本书中所引用的[参考文献][14]和[术语汇编][15]。
Finally, there is a bibliography and a glossary of all technical terms used in the book.

# 内容约定

在本书中会包含一些代码，包括Java代码、命令行和伪代码等，它们均以等宽字体显示。

一些短小精悍的补充说明信息，会以斜体字显示。

>斜体字的内容是很重要的哦。（译者注：译者自己写的不包括在内哦。）

技术名词和基本概念会作为关键字高亮显示。为便于查询，这些技术名词会罗列在[术语汇编][15]中。

在本书中，`JROCKIT_HOME`和`JAVA_HOME`表示JRockit JDK/JRE的安装目录，例如，默认安装JRockit之后，`java`命令的位置是：

    C:\jrockits\jrockit-jdk1.5.0_17\bin\java.exe

而`JROCKIT_HOME`和`JAVA_HOME`的值则为

    C:\jrockits\jrockit-jdk1.5.0_17\

JRockit JVM有其自己的版本号，目前最新的版本是R28。JRockit的次版本号表示在发行主版本后的第几次发行小版本。例如，R27.1和R27.2。在本书中，使用R27.x表示所有R27版本，R28.x表示所有的R28版本。

默认情况下，本书所介绍的内容是以R28版本来基础的，若是针对其他版本的内容，会在内容中提前说明。

>JRockit Mission Control客户端的版本更加标准，例如4.0。在介绍JRockit Mission Control的相关工具时，工具的版本号3.x和4.0也分别对应了JRockit Mission Control客户端的版本。在本书写作时，JRockit Mission Control客户端的最新版本是4.0，除非特别指明，所有内容均是以此版本为基础来讲解的。

书中内容有时会涉及到一些第三方产品，在阅读过程中，读者无需提前精通这些产品，直接阅读相关内容即可。涉及到的第三方产品包括：

* Oracle WebLogic Server: Oracle J2EE应用服务器，[http://www.oracle.com/weblogicserver][16]
* Oracle Coherence: Oracle内存型分布式缓存技术，[http://www.oracle.com/technology/products/coherence/index.html][17]
* Oracle Enterprise Manager: Oracle应用程序管理套件，[http://www.oracle.com/us/products/enterprise-manager/index.htm][18]
* Eclipse: Java IDE(也可用于其他语言的开发)，[http://www.eclipse.org][19]
* HotSpot: 一种JVM实现，[http://java.sun.com/products/hotspot][20]

有关这些产品的详细内容，请参见链接中的内容。

# 读者反馈

欢迎读者反馈对本书的看法，喜欢的、不喜欢的都可以，这对书籍编写来说非常重要。

发送反馈信息，可以寄直接给[feedback@packtpub.com][21]发邮件，说明具体反馈意见即可。

如果你喜欢本书想买一本的话，请在PacktPub的官网[www.packtpub.com][22]中填写表单，或者发邮件到这个地址[suggest@packtpub.com][23]来说明。

如果读者精于书中的某个领域，并且想贡献一些内容的话，请根据[作者指引][24]中的说明来帮助我们。

# 客户支持

如果你购买了本书，则有很多好处等着你。

>在这里[http://www.packtpub.com/site/default/files/8068_Code.zip][25]可以到下载本书中的示例代码，以及代码的使用说明。

# 勘误

尽管写的很小心，但错误难免。如果读者发现了错误，请告知，感激不尽。这不仅使其他读者免受错误困扰，还可以帮助作为晚上本书的内容。在这里[http://www.packtpub.com/support][26]选择具体的书籍，描述一些错误的具体内容，提及即可。在验证了错误内容后，会在勘误表中做相应的记录。

# 隐私生命

在任何媒体上刊登本书内容均涉及侵权，我们是认真的。如果读者发现有侵权行为，请及时告知我们，我们会及时采取行动的。

若发现侵权行为，请给[copyright@packtpub.com][27]发邮件说明具体情况。

感谢您的帮助，我们会努力写好书来回报您的。

>译者注，翻译是我的错，希望出版社能引进此书。

# 问题

如果读者对本书有任何疑问，请给[questions@packtpub.com][28]发邮件说明，我们会尽力解决。







[1]:    ./chap1/1.md#1                                                      "第1章：起步"
[2]:    ./chap2/2.md#2                                                      "第2章：自适应代码生成"
[3]:    ./chap3/3.md#3                                                      "第3章：自适应内存管理"
[4]:    ./chap4/4.md#4                                                      "第4章：线程与同步"
[5]:    ./chap5/5.md#5                                                      "第5章：基准测试与性能调优"
[6]:    ./chap6/6.md#6                                                      "第6章: JRockit Mission Control套件"
[7]:    ./chap7/7.md#7                                                      "第7章：管理控制台"
[8]:    ./chap8/8.md#8                                                      "第8章：运行时分析器"
[9]:    ./chap9/9.md#9                                                      "第9章：飞行记录仪"
[10]:   ./chap10/10.md#10                                                   "第10章：Memory Leak Detector"
[11]:   ./chap11/11.md#11                                                   "第11章：JRCMD"
[12]:   ./chap12/12.md#12                                                   "第12章：JRockit Management API"
[13]:   ./chap13/13.md#13                                                   "第13章：JRockit Virtual Edtion"
[14]:   ./appendix_a_bibliography.md                                        "参考文献"
[15]:   ./appendix_b_glossary.md                                            "术语汇编"
[16]:   http://www.oracle.com/weblogicserver                                "Oracle J2EE应用服务器"
[17]:   http://www.oracle.com/technology/products/coherence/index.html      "Oracle内存型分布式缓存技术"
[18]:   http://www.oracle.com/us/products/enterprise-manager/index.htm      "Oracle应用程序管理套件"
[19]:   http://www.eclipse.org                                              "Eclipse"
[20]:   http://java.sun.com/products/hotspot                                "HotSpot"
[21]:   mailto:feedback@packtpub.com                                        "PacktPub反馈邮箱"
[22]:   www.packtpub.com                                                    "PacktPub官网"
[23]:   mailto:suggest@packtpub.com                                         "PacktPub意见信箱"
[24]:   www.packtpub.com/authors                                            "作者指引"
[25]:   http://www.packtpub.com/site/default/files/8068_Code.zip            "Oracle权威指南的示例代码"
[26]:   http://www.packtpub.com/support                                     "PacktPub书籍勘误等级"
[27]:   mailto:copyright@packtpub.com                                       "PacktPub版权事宜处理邮箱"
[28]:   questions@packtpub.com                                              "PacktPub问题处理邮箱"
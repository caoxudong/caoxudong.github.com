<a name="appendix_b_glossary" />
# 术语汇编

<a name="AST" />
## 抽象语法树（abstract syntax tree, AST）

抽象语法树（Abstract Syntax Tree，AST）是一种代码表述形式，如果源代码结构良好，则编译器前端可以根据源代码来生成AST。AST中的每个节点都表示高级语言中的一种结构，例如循环或赋值。AST本身的节点不能出现循环结构。

Java字节码是非结构化的，其表现力也强于Java源代码，有时候没办法通过Java字节码来生成AST，因此，会使用JRockit IR是以图而非树的形式来展现的。

>参见[中间表示][IR]。

<a name="access_file" />
## 访问文件（access file）

在JMX中，访问文件用于指定不同角色的访问权限。一般情况下，该文件存放于`JROCKIT_HOME/jre/lib/management/jmxremote.access`。

>参见[密码文件][password_file]和[JMX][JMX]

<a name="adaptive_code_generation" />
## 自适应代码生成（adaptive code generation）

自适应代码生成是指在自适应环境中动态生产代码，例如JIT和混合模式解释执行代码。一般情况下，自适应代码生成会根据运行时反馈信息，对代码做多次优化。JVM是一个自适应环境，可以动态生产代码，而静态编译系统则无法办到。

>参见[JIT][JIT]和[混合模式解释执行][mixed_mode_interpretation]。

<a name="adaptive_memory_management" />
## 自适应内存管理（adaptive memory management）

自动内存管理是指应用某种自适应内存管理技术（例如垃圾回收器）来管理内存。本书中所指的自适应内存管理是指为了提升性能而根据运行时反馈信息来调整垃圾回收器的行为。

<a name="agent" />
## 代理（agent）

本书中的代理有两层含义，分别是JMX代理和JFR引擎，具体是哪个需要根据语境来判断。

>参见[JMX][JMX]和[JFR][JFR]。

<a name="ahead_of_time_compilation" />
## AOT编译（ahead-of-time compilation）

一般来说，AOT编译是指在执行代码之前现对全部或部分进行编译。C++编译器在生成二进制可执行文件时就是这样的。

>参见[JIT][JIT]。

<a name="allocation_profiling" />
## 内存分配分析（allocation profiling）

JRockit Management Console的一个特性就是运行用户实时查看应用程序中各个线程的内存分配情况。JFR中划分了多种内存分配分析事件，用户可以查看每个线程中每种事件类型的统计数据。

<a name="atomic_instruction" />
## 原子指令（atomic_instruction）

原子指令在执行时，无论操作对象是什么，指令要么都执行，要么都不执行。根据硬件模型的不同，在执行普通指令时，可能会因弱内存语义而乱序执行，相比之下，原子指令的执行时间通过会比普通指令大几个数量级。大部分CPU架构所支持的[比较并交换][CAS]指令就是一个原子指令。

>参见[比较并交换][CAS]。

<a name="automatic_memory_management" />
## 自动内存管理（automatic_memory_management）

本书中，自动内存管理是指在运行时系统中使用垃圾回收器来管理内存。

<a name="balloon_driver" />
## 膨胀驱动程序（balloon driver）

在虚拟环境中，虚拟机管理程序可以使用名为膨胀驱动程序（其具体形式可能会虚拟设备驱动程序）来隐式的与客户应用程序来协商内存使用情况。通过这种机制，客户应用程序对内存的使用请求就可以跨越虚拟抽象层这道屏障，实现内存使用的动态伸缩。

>参见[虚拟化][virtualization] [客户应用程序][guest]和[虚拟机应用程序][hypervisor]。

<a name="basic_block" />
## 基本块（basic_block）

在编译器的中间表示中，基本块是最小的控制流单元。一般情况下，基本块中会包含0个或多个指令，并且具有"一荣俱荣"的特性，即若是执行了基本块中的某条指令，则肯定会执行该基本块中的所有指令。

>参见[控制流图][control_flow_graph]。

<a name="benchmark_driver" />
## 基准测试驱动（benchmark driver）

基准测试驱动是指在基准测试中通过一台或多台机器来增加负载，然后在衡量基准测试目标操作的实际执行时间时，再将这部分工作时间排除在外的测试方式。

<a name="biased_locking" />
## 偏向锁（biased locking）

>参见[延迟解锁][lazy_unlocking]。

<a name="bytecode" />
## 字节码（bytecode）

字节码是由源代码转化成的、平台无关的二进制表示，就Java来说，字节码由Java源代码编译而成。Java字节码中包含了操作指令（长度为1个字节）和操作数，其结构化程度不如Java源代码，可以任意使用`goto`指令和其他Java源代码中不存在的结构，因此其表现力也远强于Java源代码。

<a name="bytecode_interpertation">
## 字节码解释执行（bytecode interpretation）

字节码解释执行是指，在虚拟执行栈中，以模拟字节码指令、虚拟机状态和本地变量表的形式来运行字节码代码。字节码解释执行的启动速递比编译执行快，但运行性能较低。

<a name="call_profiling" />
## 调用分析（call profiling）

调用分析是指在JIT代码中注入特定代码查看方法的调用频率或调用路径。收集到的调用分析主要用于做代码优化，例如找出应该将哪些方法做内联处理。

>参见[自适应代码生成][adaptive_code_generation]和[JIT][JIT]。

<a name="card" />
## 卡（card）

在本书中， 卡是一中数据结构，用于表示某块堆内存。整个堆内存被划分为多个卡，存储与卡表中。在分代式垃圾回收中，卡表用于判断老年代指定分区是否是脏的（dirty），即该区域中是否有对象包含有指向新生代中对象的引用。

>参见[写屏障][write_barrier]和[分代式垃圾回收][generational_garbage_collection]。

<a name="card_table" />
## 卡表（card table）

>参见[卡][card]。

<a name="class_block">
## 类块（class block）

类块是JRockit中的名词，指对象头中所指向的、包含了类型信息的数据块。

>参见[对象头][object_header]。

<a name="class_garbage_collection" />
## 类型垃圾回收（class garbage collection）

类型垃圾回收是指JVM对运行时中的类型信息进行清理。如果某个类已经被卸载了，而且没有`java.lang.ClassLoader`实例或其他代码引用该类或其方式时，就可以将其清理掉了。

<a name="client_side_template" />
## 客户端模板（client-side template）

JRockit Mission Control的客户端模板用于控制运行时记录的事件设置。解析改模板文件时，采用的全解析策略，即不支持通配符。模板文件可以带有版本信息。

>参见[事件设置][event_settings]和[服务器端模板][server_side_template]。

<a name="cloud" />
## 云（cloud）

云是指集中大量分布式计算资源（可能是虚拟计算资源），用户可以在其中部署自己的应用程序。

>参见[虚拟化][virtualization]。

<a name="code_generation_queue" />
## 代码生成队列

代码生成队列是JRockit中的一个词儿，为了保证Java应用程序的持续运行，JVM会先将代码生成请求放入到指定队列中，而后代码生成线程会从该队列中获取任务，执行代码生成任务，之后JVM再执行新生成的代码。

>参见[优化队列][optimization_queue]。

<a name="color" />
## 着色（color）

在本书中，着色是指对具有某种特性节点进行标记，常用于寄存器分配算法或引用追踪垃圾回收算法。

在寄存器分配算法中，同时正在使用的变量可以表示为图中的两个相邻节点，于是寄存器分配算法就可以转化为"如何对图中的节点进行着色，使相邻节点具有不同的颜色"，其中可用颜色的数量等于可用寄存器的数量。

此外，着色还可应用于引用追踪垃圾回收算法。通常情况下，标记-清理算法会使用若干种颜色来标记垃圾回收过程已经处理过的若干种对象。

>参见[寄存器分配][register_allocation]和[引用追踪垃圾回收][tracing_garbage_collection]。

<a name="compaction" />
## 内存整理（compaction）

内存整理可用于降低堆的碎片化程度。经过内存整理后，对象会被移动到一起，形成一块大的存活区域，消除内存碎片。对整个堆做内存整理操作，往往需要暂停应用程序线程。

>参见[碎片化][fragmentation]。

<a name="CAS" />
## 比较并交换（compare and swap, CAS）

目前很多CPU架构都支持原子指令，例如x86平台的`cmpxchg`指令和SPARK平台的`cas`指令，这种指令会比较内存和寄存器中的值，若相匹配，则用预设的某个值来覆盖内存中的值。如果覆盖成功，则该指令会设置标志寄存器，做分支处理使用。该指令常用于实现自旋锁。

>参见[原子指令][atomic_instruction]和[自旋锁][spinlock]。

<a name="compressed_reference" />
## 压缩引用（compressed reference）

引用压缩是一种Java对象模型的实现机制，在这种机制下，应用程序中对象的引用会比系统级的指针小。例如，在64位系统上，如果Java堆小于4GB，则记录对象地址只需32位就够了，在运行时中使用64位完全是浪费。载入/解压缩Java对象的指针会有一点开销（不过并不大），但却可以极大的提升系统的运行速度。

>参见[引用压缩][reference_compression]和[引用解压缩][reference_decompression]。

<a name="concurrent_garbage_collection" />
## 并发垃圾回收（concurrent garbage collection）

在本书中，并发垃圾回收是指在垃圾回收周期的大部分时间内，Java应用程序还可以继续执行的垃圾回收算法。

>参见[并行垃圾回收][parallel_garbage_collection]。

<a name="conservative_garbage_collection" />
## 保守式垃圾回收(conservative garbage collection)

保守式垃圾回收会将所有有可能是对象的内容都当作对象来处理，之所以这样是因为它不会记录对象的元信息。这种实现方式会降低垃圾回收的执行效率，因为没有元信息，垃圾回收器不得不做一些额外的检查。例如，数字17不是一个对象指针，因为它不在堆空间内，而数字0x471148则有可能是一个对象指针，但也有可能只是个常量值。如果某个常量碰巧指向了堆中的某个对象，则保守式垃圾回收很有可能会把这个常量也当作对象而保留下来。这些特性决定了保守式垃圾回收在移动对象时会受到很大的限制。

>参见[准确式垃圾回收][exact_garbage_collection] [活动对象图][livemap]和[安全点][safepoint]。

<a name="constant_pool" />
## 常量池（constant pool）

常量池是class文件中的一部分，其中存储了方法所使用到的常量字符串的较大的数字。

<a name="continuous_JRA" />
## 持续型JRA

持续型JRA，表示记录任务会一直持续运行，是早期开发JRA时的概念，后来JRA被JFR所取代。

>参见[JFR][JFR]。

<a name="control_flow_graph" />
## 控制流图（control flow graph，CFG）

控制流图是一种程序表示方式，在其中以图的形式展示了程序可能具有的执行路径（通常会以基本块作为节点）。图中节点之间的边可以表示直接跳转（如`goto`）、条件跳转、转换表（table switch）等，

>参见[偏向锁][biased_locking]。

<a name="cpu_profiling" />
## CPU分析（cpu profiling）

CPU分析是JRockit Management Console中的一项功能，可以显示出每个线程的CPU使用情况。

<a name="critical_section" />
## 临界区（critical section）

临界区是指只能被单线程运行的代码片段。实现的时候，一般会在临界区前后用锁（例如同步块）来控制多线程访问。

<a name="dead_code" />
## 死代码（dead code）

死代码是指应用程序中永远也不会被执行的代码。如果编译器能正确某段代码确实是死代码，则编译器通常会删除这段死代码。

<a name="deadlock" />
## 死锁（deadlock）

死锁是指，两个线程都因等待对方释放自己需要的资源而被阻塞住。相关线程自己是无法解锁的，只能永远等下去。虽然不消耗CPU资源，但死锁依然是很严重的问题

>参见[胖锁][fat_lock]和[活锁][livelock]。

<a name="deadlock_detection" />
## 死锁检测（deadlock detection）

死锁检测是JRockit Management Console的一项功能，用于检测系统中是否存在死锁的线程。

>参见[死锁][deadlock]。

<a name="design_mode" />
## 设计模式（design mode）

在运行JFR客户端时，设计模式是禁用的。通过设计模式可以直接访问构建用户界面的各种工具，自定义GUI界面，并将之导出为插件供他人使用。

>参见[运行模式][run_mode]。

<a name="deterministic_garbage_collection" />
## 确定式垃圾回收（deterministic garbage collection）

在本书中，确定式垃圾回收是指JRockit Real Time所使用的低延迟垃圾回收器。

>参见[延迟][latency]和[软实时][soft_real_time]。

<a name="diagnostic_command" />
## 诊断命令

通过JRCMD、MBean`DiagnosticCommand`或JMAPI可以给JRockit JVM发送指定的诊断命令。

>参见[JRCMD][JRCMD]和[JMAPI][JMAPI]。

<a name="double_checked_locking" />
## 双检查锁（double-checked locking）

在双检查锁中，在获取锁之前会先进行一次检查是否满足条件，以期避免执行开销较大的加锁操作。强烈建议不要使用这种"技巧"，在某些内存模型下，这种"技巧"可能具有不同的行为，甚至是错误的行为。

>参见[Java内存模型][JMM]。

<a name="driver" />
## 驱动程序（driver）

>参见[基准测试驱动][benchmark_driver]。

<a name="editor" />
## 编辑器（editor）

编辑器是富客户端平台（RCP）的基本概念，在GUI中，它通常位于RCP应用程序的中间部分，展示相关数据。

>参见[富客户端平台][RCP]。

<a name="escape_analysis" />
## 逃逸分析（escape_analysis）

逃逸分析是一种代码优化手段，用于判断指定对象的作用域，并在可能情况下移除不必要的对象。如果编译器能证明，对象的作用域之间某个有限范围内，绝对不会"逃逸"出这个范围（例如某个对象是作为参数被传入到方法中），则编译器就可以省去为对象分配内存的操作，直接将对象属性保存到局部变量。逃逸分析与C++中在栈中分配对象有异曲同工之妙。

<a name="event" />
## 事件（event）

在JRA延迟分析工具和JFR中，事件是与某个时间点相关的数据集合。事件可以有持续时间属性和事件类型属性。

>参见[事件类型][event_type]。

<a name="event_attribute" />
## 事件属性（event attribute）

事件包含了一系列属性-值得组合，事件属性也称为事件域。

>参见[事件域][event_field]。

<a name="event_field" />
## 事件域（event field）

>参见[事件属性][event_attribute]。

<a name="event_settings" />
## 事件配置（event settings）

事件配置包括事件类型、阈值和是否记录调用栈等内容。

>参见[客户端模板][client_side_template]和[服务器端模板][server_side_template]。

<a name="event_type" />
## 事件类型（event type）

事件类型用于描述JFR中的事件，包含了与事件域、事件路径、事件名和描述等元信息。事件类型和事件的关系就好像是类和实例的关系。

<a name="exact_garbage_collection" />
## 准确式垃圾回收（exact_garbage_collection）

与保守式垃圾回收相反，准确式垃圾回收要求运行时提供元数据信息，以便明确知道寄存器和栈帧中的哪些位置存储了对象指针，这样就免去了垃圾回收器猜测数据到底是不是对象指针的麻烦。元数据虽然增加了内存消耗，却可以加快垃圾回收的执行速度，并提升回收操作的准确性。

>参见[保守式垃圾回收][conservative_garbage_collection]。

<a name="exact_profiling" />
## 准确分析（exact profiling）

准确分析是指以注入代码的形式来获取准确的分析结果，例如方法执行时间和方式执行次数。这种方式通常都会带来一点性能开销。

>参见[采样分析][sample_based_profiling]。

<a name="extension_point" />
## 扩展点（extension point）

在Eclipse Equinox(OSGi)中，插件可以通过扩展点为应用程序增加新功能。例如，在JRockit Management Console中，第三方插件可以通过扩展点来增加新的标签页。

<a name="fairness" />
## 公平性（fairness）

若是系统的中的线程获得时间片的几率相同，则称之为公平调度。对于具体的应用程序来说，公平调度并不是必需的，因为频繁的上下文切换回带来不小的性能开销，不过需要线程能够均等运行的场景中却是非常重要的，

<a name="fat_lock" />
## 胖锁（fat lock）

相对于瘦锁，胖锁更加智能，实现也更加复杂。当线程在等待获取锁的时候，胖锁会将线程置于休眠状态，并为等待线程维护一个优先级队列。胖锁可以降低对CPU资源的消耗，因而更适用于那些竞争激烈或持有时间很长的锁

>参见[瘦锁][thin_lock]。

<a name="fragmentation" />
## 碎片化（fragmentation）

碎片化是内存分配行为和可分配内存的恶化，其成因是对象被垃圾回收器回收后在内存空间中留下无法再被使用的空洞。如果堆中的空洞非常多，而又非常小，此时即便空闲内存不少，但却有可能无法再为新对象分配内存了。碎片化是现代垃圾回收器天敌之一，不少垃圾回收器通过内存整理来解决碎片化问题。

>参见[内存整理][compaction]。

<a name="free_list" />
## 空闲列表（free list）

空闲列表是运行时用来记录堆中可用空间的数据结构。通常情况下，空闲列表会指向堆中那些可以容纳新对象的空洞，其具体结构可能是针对固定大小区域块的优先级队列。在为对象分配内存时，会在对应大小的空闲列表中查找合适的空闲块。

>参见[碎片化][fragmentation]。

<a name="full_virtualization" />
## 全虚拟化（full virtualization）

全虚拟化是指客户应用程序无需任何修改就可以直接运行在虚拟机中，就像运行在物理硬件上一样。

>参见[虚拟化][virtualization]和[客户应用程序][guest]。

<a name="GC_heuristic" />
## 启发式GC（GC heuristic）

启发式GC是指一组规则，例如吞吐量和暂停时间，用于确定如何对垃圾回收器进行配置。

>参见[GC策略][GC_strategy]。

<a name="GC_pause_ratio" />
## GC暂停时间比例（GC pause ratio）

GC暂停时间比例是JRockit Mission Control中的一个概念，是指运行应用程序代码和暂停应用程序运行垃圾回收代码的时间比例。需要注意的是，应用程序运行时间指的是总体运行时间，可能会包含将数据写入到硬盘的延迟时间。

<a name="GC_strategy" />
## GC策略（GC strategy）

在JRockit垃圾回收器中，尤其是R27版本之前的垃圾回收器中，GC策略通常是指符合某种启发式GC规则的垃圾回收器行为。在JMAPI中，GC策略包含以下三种定义：

* 新生代行为（开/关）
* 标记阶段行为（并行/并发）
* 清理阶段行为（并行/并发）

>参见[启发式GC][GC_heuristic] [并行垃圾回收][parallel_garbage_collection]和[并发垃圾回收][concurrent_garbage_collection]。

<a name="generation" />
## 代（generation）

代是堆的一部分，通常情况下，对象会按其年龄（所经历的垃圾回收次数）存放到指定的代中。

>参见[堆][heap]和[分代式垃圾回收][generational_garbage_collection]。

<a name="generational_garbage_collection" />
## 分代式垃圾回收（generational garbage collection）

分代式垃圾回收是指将堆划分为多个区域，或称"代"。新生代（即young generation或nursery）通常比较小，执行垃圾回收的频率较高，相比于老年代来说，垃圾回收的执行速度也较快。当系统中大部分对象的生命周期都很短时，分代式垃圾回收就很适用。不过，分代式垃圾回收也会带来一些执行开销，垃圾回收器需要记录下老年代中哪些对象包含有指向新生代对象的引用。

>参见[新生代][young_space] [老年代][old_space]和[写屏障][write_barrier]。

<a name="graph_coloring" />
## 图着色（graph coloring）

在寄存器分配算法中，图着色算法用于计算寄存器赋值问题。同时使用的变量被抽象为图中相邻的两个节点，寄存器分配器的工作就是，在相邻节点不能同色的前提下，用尽量少的颜色画满途中所有的节点。如果最后计算出所需颜色的数量大于可用寄存器的数量，则需要使用Spilling技术来处理。作为一个NP-hard问题，虽说图着色问题可以求出近似解，但仍是代码生成过程中计算量最大的生产步骤之一。

>参见[着色][color] [寄存器分配][register_allocation] [图融合][graph_fusion]和[Spilling][spilling]

<a name="graph_fusion" />
## 图融合（graph fusion）

图融合是对图着色的扩展。通过某些启发式算法（通常情况下是根据代码块的热度），将IR分拆为几个子区域，然后分别对每个子区域进行着色，再做融合操作。这个过程需要在相邻子区域之间的边上生成一些额外代码来记录关联关系。如果作为划分标准的热度的尺度足够高，处理代码时可以直接从最热的部分开始，那这个算法就非常有用了，可以少生成一些额外的代码了。

>参见[着色][color] [寄存器分配][register_allocation] [图着色][graph_coloring]和[Spilling][spilling]。

<a name="green_thread" />
## 绿色线程（green thread）

绿色线程是指用一个底层线程实例（例如一个操作系统线程）来表示多个高层线程实例（例如`java.lang.Thread`对象）。对于没什么复杂性的应用程序来说，这个实现方式简单有效，但却有很有弊端，最大问题就是多线程处理。在本地代码中，无法对线程施加控制，没法得知线程正在等待IO，因此可能会出现死锁的情况。如果将绿色线程置于休眠状态，通常会将其底层的操作系统线程也一起休眠了，导致该操作系统线程所代理的其他绿色线程都无法运行了。

>参见[多对多线程模型][NxM_thread]。

<a name="guard_page" />
## 保护页（guard page）

保护页是内存管理中的一个特殊页，带有操作系统级页保护标志位。因此，对该页做解引用操作时，会抛出异常。这个特性非常有用，将保护页置于栈结构的底部时，可用于检查是否发生栈溢出。此外，还可以用保护页实现安全点，对指定安全点解引用所涉及的页面加以保护即可。这样，当下一次到达安全点时，运行时就会抛出一个异常，终止控制流。

>参见[活动对象图][livemap]和[安全点][safepoint]。

<a name="guest" />
## 客户应用程序（guest）

运行在虚拟机管理程序上的自包含的系统，例如操作系统，被称为客户应用程序。多个客户应用程序可以运行在同一个虚拟机管理程序中，只不过在全虚拟化下，客户应用程序会认为自己是直接运行在物理机器上，并不会意识到有其他客户应用程序存在。

>参见[虚拟化][virtualization]和[虚拟机管理程序][hypervisor]。

<a name="hard_real_time" />
## 硬实时（hard real-time）

硬实时是指运行环境对实时性的要求很高，需要精确控制延迟时间。对于Java服务器端应用程序来说，通常来说这没必要，软实时就够了，即控制延迟等级水平即可，无需精确控制延迟时间。

>参见[软实时][soft_real_time]。

<a name="hardware_prefetching" />
## 硬件预抓取（hardware prefetching）

硬件预抓取是一种基于硬件的预抓取实现，通常情况下，是指CPU无需与应用程序交互，通过启发式算法，在访问数据之前，预先将目标数据抓取到缓存中。

>参见[预抓取][prefetching]和[软件预抓取][software_prefetching]。

<a name="heap" />
## 堆（heap）

在本书中，堆是指JVM中预留的、专用于存储Java对象的内存空间。

>参见[本地堆][native_memory]。

<a name="HIR" />
## 高级中间表示（HIR，high level intermediate representation）

HIR是JRockit中将字节码转换为本地代码过程中的首份产出。JRockit HR是一个以基本块作为节点的有向控制流图，每个基本块都包含0个或多个操作。JRockit HIR是平台无关的。

>参见[中级中间表示][MIR] [低级中间表示][LIR] [中间表示][IR] [寄存器分配][register_allocation]和[本地代码][native_code]。

<a name="hosted_hypervisor" />
## 托管型虚拟机管理程序（hosted hypervisor）

托管型虚拟机管理程序是指，在当前操作系统中，作为一种用户应用程序来运行的虚拟机管理程序。

>参见[虚拟机管理程序][hypervisor]。

<a name="hypervisor" />
## 虚拟机管理程序（hypervisor）

虚拟机管理程序是一种允许多个操作系统（也称为客户应用程序）同时运行在一台物理机器上的应用软件，可以为客户应用程序提供硬件抽象。

>参见[虚拟化][virtualization] [客户应用程序][guest] [本地型虚拟机管理程序][native_hypervisor]和[托管型虚拟机管理程序][hosted_hypervisor]。

<a name="inline" />
## 内联（inline）

内联始终代码优化手段，通过将被调用函数的代码拷贝到调用函数中以节省函数调用所带来的开销。做得好的话，威力强大；但如果过度优化，或者函数调用频率太低，则可能会带来诸如指令缓存失效的问题。

<a name="IR" />
## 中间表示（intermediate representation，IR）

中间表示是代码在编译器内部的表示形式。通常情况下，中间表示既不是编译语言，也不是本地代码，而是介于两者之间的、更具通用性的表示形式，格式良好的中间表示应该是便于优化和转换的。在JRockit中，中间表示本书也分为多个层次，最上层表示与Java代码类似，最下层表示则更像本地代码，算是一种标准划分形式。

>参见[高级中间表示][HIR] [中级中间表示][MIR] [低级中间表示][LIR] [寄存器分配][register_allocation]和[本地代码][native_code]。

<a name="internal_pointer" />
## 内部指针（internal pointer）

在本书中，内部指针是指带有偏移的Java对象引用，这样就可以直接指向对象本身，而不是位于对象地址开始处的对象头。尽管垃圾回收器需要对内部指针做特殊处理，但内部指针对于生成高性能代码确实非常重要的，例如实现数组遍历时，直接使用对象原始地址是很不方便的。此外，对于某些有限寻址模式的平台（例如IA-64）来说，使用内部指针是必须的。

<a name="invocation_counter" />
## 调用计数器（invocation counter）

调用计数器是一种用来检测热点代码的分析工具。通常情况下，调用计数器是将分析代码注入到方法头中，于是乎在调用目标方法时会先将调用计数器加1。自适应运行时通常会扫描调用计数器，并对那些调用次数达到了阈值的方法重新进行优化。在热点检测方面，调用计数器的粒度还略有些粗放，需要配合其他其他检测机制（例如线程采样）一起使用。

>参见[准确分析][exact_profiling]和[线程采样][thread_sampling]。

<a name="java_bytecode" />
## Java字节码（java bytecode）

>参见[字节码][bytecode]。

<a name="JMM" />
## Java内存模型（Java Memory Model，JMM）

Java是一种平台无关的编程语言，因此需要保证同一份Java代码在不同CPU架构上也能具有相同的行为。如果将字节码的载入（load）和存储(store)操作映射到本地代码的载入（load）和存储(store)操作，则Java程序可能会在不同的CPU架构上表现出不同点行为。究其原因，就在于不同CPU架构之间可能使用不同的内存访问模型。

为了保证Java程序能够在所有CPU架构上具有相同的内存操作行为，JMM出现了，明确规范了Java中的内存访问语义。在Java诞生之初，JMM还很矬，在经过JSR-133之后，终于实现了语义的一致性。

>参见[JSR-133][JSR-133]

<a name="JIT_compilation" />
## 即时编译（just-in-time compilation，JIT compilation）

即时编译是指在首次调用某个方法之前，先将之编译为本地代码的过程。

>参见[静态编译][static_compilation]和[预编译][ahead_of_time_compilation]。

<a name="JMAPI" />
## JMAPI

JMAPI，即JRockit Management API，是一套私有的JVM管理API，用于监控JVM运行状态，并允许在运行过程中修改JVM的行为。在业界标准出现之前，这套API首先给出了对JVM做监控和动态调整的解决方案。在JRockit R28版本中，JMAPI的部分内容已经被废弃掉，转而通过JMXMAPI来完成相应的功能。

>参见[JMXMAPI][JMXMAPI]。

<a name="JMX" />
## JMX

JMX，即Java Management Extensions，是一套对Java应用程序进行监控/管理的标准接口。

>参见[MBean][MBean]。

<a name="JMXMAPI" />
## JMXMAPI

JSR-174为JVM引入了基于JMX的标准管理API，JMXMAPI则是JRockit对JSR-174的扩展实现。JMXMAPI中包含的MBean暴露出了JRockit的专属行为，可以在JRockit Mission Control中调用相关操作，读写相关属性。在JRockit中，JMXMAPI实在JRockit R27版本中出现的，但到目前为止还没有得到官方支持，将来的版本中可能会发生变化。

>参见[JMX][JMX] [JSR-174][JSR-174]和[MBean][MBean]。

<a name="JRCMD" />
## JRCMD

JRCMD（JRockit CoManD）是一个随JRockit运行时一同发行的命令工具，可以向运行在本地的JRockit实例发送诊断命令。安装JRockit运行时后，可以在`JROCKIT_HOME/bin`目录下找到JRCMD。

>参见[诊断命令][diagnostic_command]。

<a name="JRockit" />
## JRockit

实际上，JRockit是一组技术的统称，其主旨是为了提升Java应用程序的性能和可管理性。JRockit技术组主要包括了JRockit Virtual Edition、JRockit Real Time、JRockit Mission Control和旗舰产品JRockit JVM。

<a name="JFR" />
## JRockit Flight Recorder（JFR）

在JRockit R28/JRockit Mission Control 4.0将其之后版本中，JFR成为了性能分析和问题诊断的主力工具。JFR可以在内存和硬盘中持续记录JVM的运行时数据。

<a name="Memleak" />
## JRockit Memory Leak Detector（Memleak）

JRockit Memory Leak Detector（也称为Memleak）是JRockit Mission Control套件中的内存泄漏检测工具，用于检测是否存在内存泄漏以及具体形成原因，还可用于获取一些堆分析信息。

<a name="jrockit_mission_control" />
## JRockit Mission Control（JRMC）

JRockit Mission Control是JRockit中一组管理工具套件，可用于管理、监控、分析运行在JRockit JVM中的应用程序，还以用来追踪应用程序的内存泄漏问题。

>参见[JRockit Memory Leak Detector][Memleak] [JRockit Runtime Analyzer][JRA]和[JRockit Flight Recorder][JFR]。

<a name="JRA" />
## JRockit Runtime Analyzer（JRA）

JRockit Runtime Analyzer（JRA）是JRockit R27及其之前版本中的主力分析工具。到R27.3版本时，JRA中新增了一个强大的延迟分析器，对于查看应用程序空闲原因非常有用。到JRockit R28版本中，JRA被JFR所取代。

>参见[JRockit Flight Recorder][JFR]。

<a name="JSR" />
## Java Specification Request（JSR）

对Java及其API的修改是以一种半公开的方式进行的，称为JCP（即Java Community Process）。当需要在Java标准中做某些修改时，会先将修改内容写成JSR提交给JCP进行投票。众所周知修改，如JMM（JSR-133）和对动态语言的支持（JSR-292），都是JSR的形式提交的。

<a name="JSR-133" />
## JSR-133

JSR-133旨在解决因CPU架构不同而可能导致的Java应用程序行为不一致的问题。

>参见[JSR][JSR]和[JMM][JMM]。

<a name="JSR-174" />
## JSR-174

JSR-174用于改进Java运行时的监控和管理特性。JSR-174带来了`java.lang.management`包和平台MBean服务器的概念。从Java5.0起，JSR-174得到了完整实现。

>参见[JSR][JSR]和[MBean服务器][MBean_server]。

<a name="JSR-292" />
## JSR-292

JSR-292旨在通过修改Java语言和字节码规范来使JVM可以支持动态语言，例如Ruby。

>参见[JSR][JSR]。

<a name="JVM_browser" />
## JVM浏览器（jvm browser）

JVM浏览器是JRockit Mission COntrol中的一个树形视图，用于展示JRockit Mission Control可以连接到的JVM实例。

>参见[JRockit Mission Control][jrockit_mission_control]。

<a name="keystore" />
## 密钥仓库（keystore）

密钥仓库用于保存公钥和私钥，使用密码来保证口令来安全性。

>参见[信任库][truststore]。

<a name="lane" />
## 通道（lane）

在JFR的"Event | Graph"标签页中，通道表示了一条追踪路径，同一父节点下所有的所有事件都会放置在同一个通道中。因此，确保同一父节点下所有事件类型在时间上不重叠可以更好的显式出事件相关性。

>参见[事件][event]。

<a name="large_page" />
## 大内存页（large page）

大内存页是所有现代操作系统都支持的一种机制，即将内存页的大小提升为MB级别。使用大内存页可以加速转换虚拟地址的速度，因为可以降低TLB（translation lookaside buffer
）的丢失率；坏处是大幅增加了内存页的大小，可能会造成本地内存的碎片化。

>参见[本地内存][native_memory]。

<a name="latency" />
## 延迟（latency）

延迟是指执行事务时的开销，而这部分开销对事务本身是没有用的。例如，虚拟机中执行代码生成和内存管理都会带来额外的执行开销，需要开启一个事务来完成。无法预测的延迟会带来不小的麻烦，因为不能预测开销的话，就没办法确定负载等级。有时候，为了能预测延迟，而不得不降低系统总吞吐量。

>参见[Stopping-the-world][STW] [确定式垃圾回收][deterministic_garbage_collection] [并发垃圾回收][concurrent_garbage_collection]和[并行垃圾回收][parallel_garbage_collection]。

<a name="latency_threshold" />
## 延迟阈值（latency threshold）

JFR中的计时事件中包含了有关超时时间阈值的设定，若是事件的持续时间小于该阈值，则不会记录该时间。

>参见[JRockit Flight Recorder][JFR]。

<a name="lazy_unlocking" />
## 延迟解锁（lazy unlocking）

延迟解锁，有时也称偏向锁，是一种对锁行为的优化手段，即假设大部分锁都只是线程局部的，没必要频繁的做释放和获取操作。在延迟解锁中，运行时就是在赌"锁会一直保持在线程局部内"。当第一次释放锁时，运行时可能会选择不去释放它，直接跳过释放操作，这样当下次同一个线程再来获取这个锁时，也就不必在做加锁操作了。当然，最坏的情况是，另一个线程试图获取这个实际上并未被释放的锁，这时只能先将锁转换为普通模式的锁，强制释放该锁，带来额外的性能开销。因此， 所示应用程序中线程竞争非常激烈，就不适宜使用延迟解锁。

一般来说，实现延迟解锁时会应用各种启发式算法，使其在不断变化的运行环境中达到更好的执行性能，例如对那些线程竞争太过激烈的对象禁用延迟解锁。

<a name="LIR" />
## 低级中间表示（low level intermediate representation，LIR）

LIR位于Java代码在JRockit内部表示中的最底层，它包含了类似于硬件寄存器和硬件寻址模式等结构，并且可能会包含分配寄存器的内容。LIR中队寄存器的分配可以直接映射到本地代码或当前CPU架构的寄存器分配操作。

>参见[高级中间表示][HIR] [寄存器分配][register_allocation] [本地代码][native_code]和[中间表示][IR]。

<a name="livelock" />
## 活锁（livelok）

活锁是指，两个线程都持有对方所需要的资源，同时又都在主动获取对方的资源，这时两个线程均处于活动状态，但却无法再继续执行下去，只会不断尝试获取对方的资源。活锁会浪费大量的CPU资源。

>参见[活锁][Deadlock]。

<a name="livemap" />
## 活动对象图（livemap）

活动对象图是由编译器生成的元数据信息，记录了寄存器和本地栈帧存储的对象信息。这些信息对于执行准确式垃圾回收是非常有用的。

>参见[准确式垃圾回收][exact_garbage_collection]。

<a name="live_object" />
## 存活对象（live object）

存活对象是指，从根集合或其他存活对象出发，可以通过引用关系追踪到的对象。"存活（live）"和"使用中（in use）"这两个词往往可以交换使用。被标记为"存活"的对象是不可以被回收掉的。

>参见[根集合][root_set]。

<a name="live_set" />
## 存活集合（live set）

存活集合通常是指那些存活对象所占据的堆空间。

>参见[存活对象][live_object]。

<a name="live_set_fragmentation" />
## 存活集合 + 碎片化（live set + fragmentation）

实际上，（存活集合+碎片化）空间就是堆中正在使用的内存空间。在JRockit Mission Control中，这块空间用来表示运行应用程序所需的最小内存空间。

<a name="lock_deflation" />
## 锁收缩（lock deflation）

锁收缩是指，根据运行时的反馈信息，动态地将胖锁转换为瘦锁。一般情况下，执行锁收缩是因为对目标锁的竞争已经由"竞争激烈"变为"竞争不激烈"了。

>参见[锁膨胀][lock_inflation] [胖锁][fat_lock]和[瘦锁][thin_lock]。

<a name="lock_fusion" />
## 锁融合（lock fusion）

锁融合是指，将两个需要加锁/解锁操作的区域融合，使用一个锁来管理。若是两个被监视器管理的代码块之间只是一些小量的、无副作用的代码，则可以通过锁融合来剔除不必要的解锁、加锁操作，提升系统的整体性能。

>参见[延迟解锁][lazy_unlocking]。

<a name="lock_inflation" />
## 锁膨胀（lock inflation）

锁膨胀是指，在根据运行时的反馈信息，动态地将瘦锁升级为胖锁。一般情况下，执行锁膨胀是因为对目标锁的竞争已经由"竞争不激烈"变为"竞争激烈"了。

>参见[锁收缩][lock_deflation] [胖锁][fat_lock]和[瘦锁][thin_lock]。

<a name="lock_pairing" />
## 锁配对（lock pairing）

虽然在Java源代码中，加锁和解锁操作是自动配对的，胆在Java字节码中，指令`monitorenter`和`monitorexit`并不是自动配对的。因此为了支持某些锁操作，如延迟解锁和递归加锁，代码生成器需要能够自行将加锁和解锁操作配对，这里就涉及到了一个名为"锁符号"的结构，代码生成器通过该锁符号来判断加锁/解锁是否相匹配。

>参见[延迟解锁][lazy_unlocking] [递归加锁][recursive_locking]和[锁符号][lock_token]。

<a name="lock_token" />
## 锁符号（lock token）

锁符号是用来唯一标识某对加锁/解锁操作的记号，锁配对操作通过该符号来判断加锁/解锁是否相匹配。一般情况下，锁符号总包含了指向Java监视器对象的对象指针，并使用一些标记位来记录当前的加锁情况，如当前是胖还是瘦锁，是否是递归加锁等。如果代码生成器无法找到相匹配的加锁/解锁操作，则会将锁符号标记为"未匹配的（unmathed）"，这种情况下虽说比较少见，但确实是可能存在的，因为字节码的表达本就更加自由，当然，相比于正常的、匹配的锁符号来说，未匹配的锁符号在执行同步操作时，效率更低一些。

>参见[锁配对][lock_pairing]。

<a name="lock_word" />
## 锁字（lock word）

锁字是对象头中的一些标记位，记录了对指定对象加锁情况。在JRockit中，还会将一些垃圾回收信息记录到锁字中。

>参见[对象头][object_header]。

<a name="mark_and_sweep" />
## 标记-清理（mark and sweep）

标记-清理一种引用跟踪垃圾回收散发，从存活对象出发，根据引用关系追踪其他存活对象，最终构成存活对象集合。在遍历的所有引用后，就找出了所有的存活对象。标记和清理工作可以以多线程来提高执行效率。目前来看，标记-清理时所有商用JVM中垃圾回收器的基础。

>参见[引用追踪垃圾回收器][tracing_garbage_collection]。

<a name="master_password" />
## 主密码（master password）

主密码用于对存储在JRockit Mission Control中的密码做加密解密操作。

<a name="MBean" />
## MBean

MBean是JMX规范中设备层的一部分，一个MBean实例是一个托管的Java对象，表示对某种资源的管理，可以读写属性，执行操作，以及发出通知。

更多详细信息请参见J2SE中MBean部分的文档，http://java.sun.com/j2se/1.5.0/docs/guide/management/overview.html#mbeans 

<a name="MBean_server" />
## MBean服务器（MBean server）

MBean服务器是JMX架构的核心组件，用于管理MBean的生命周期，并通过连接器将MBean暴露给消费者。

>参见[JMX][JMX]和[MBean][MBean]。

<a name="MD5" />
## MD5

一种哈希算法。

<a name="method_garbage_collection" />
## 方法垃圾回收（method garbage collection）

在本书中，方法垃圾回收是指对代码本书的垃圾回收，即从代码缓冲区中清除那些不再使用的本地代码，例如当某个方法被重新优化或重新生成后，需要清除之前的无用代码。

<a name="micro_benchmark" />
## 微基准测试（micro benchmark）

微基准测试是指简单小巧、便于理解的测试代码，可用于对性能做回归测试。

<a name="MIR" />
## 中级中间表示（middle level intermidiate representation，MIR）

在JRockit中，MIR是一个有向控制流图，其以基本快作为图的节点，每个基本快都包含了0个或多个操作。JRockit中的MIR是平台无关的，同时也是对代码做平台无关优化的阶段，其具体格式类似于三地址码。

>参见[高级中间表示][HIR] [低级中间表示][LIR] [寄存器分配][register_allocation] [本地代码][native_code]和[中间表示][IR]。

<a name="mixed_mode_interpretation" />
## 混合模式解释执行（mixed mode interpretation）

混合模式解释执行是指以字节码解释执行的方式来运行大部分代码，并配以JIT编译对热点代码做动态优化。

>参见[字节码解释执行][bytecode_interpertation] [字节码][bytecode]和[JIT编译][JIT_compilation]。

<a name="monitor" />
## 监视器（monitor）

监视器是一个对象，可用于执行同步操作，也就是说可以使用监视器来限制对临界区排他性访问。

>参见[临界区][critical_section]。

<a name="name_mangling" />
## 名字修饰(name mangling)

名字修饰使用中字节码混淆技术，是指为了防止反编译代码，将编译后的代码中的方法和属性域的名字都提化为自动生成的、无意义的名字。

>参见[混淆][obfuscation]

<a name="native_code" />
## 本地代码（native code）

在本书中，本地代码、汇编语言和机器代码是同一个意思，均指针对于指定硬件架构的专用语言。

<a name="native_hypervisor" />
## 本地型虚拟机管理程序（native hypervisor）

本地型虚拟机管理程序是指直接安装在裸硬件上的虚拟机管理程序。

>参见[虚拟机管理程序][hypervisor]。

<a name="native_memory" />
## 本地内存（native memory）

在本书中，本地内存是指由运行时自身，而非Java堆，使用的部分内存。这部分内存可用做代码缓冲区或系统内存（指运行时为其内部数据结构分配内存时使用）。

>参见[堆][heap]。

<a name="native_thread" />
## 本地线程（native thread）

本地线程（有时又称为操作系统线程），是由专门的平台或操作系统提供的线程实现，例如Linux系统中的POSIX线程。

<a name="non_contiguous_heap" />
## 非连续堆（non-contiguous heap）

非连续堆是指将几块并不相连的系统内存作为一个完整的Java堆使用。由于内存块并不连续，因此使用的时候需要做些额外的记录，虽说会带来一些额外的开销，但却大大增加了可用的堆空间。由于32位系统的内存空间有限，所以有些操作系统会驻留在内存空间的中部，有了非连续堆的帮助就可以将操作系统两侧的内存空间都利用起来了。

<a name="NxM_thread" />
## 多对多线程模型（NxM thread）

多对多线程模型是绿色线程的变种，即使用多个本地线程来运行多个绿色线程。这种实现方式可以避免绿色线程中可能出现的死锁和IO阻塞的问题，但在现代商用JVM中，还是难堪大用。

>参见[绿色线程][green_thread]。

<a name="NUMA" />
## NUMA架构

NUMA，即非一致性内存架构，是一个相对较新的概念。为了能够节省总线带宽，NUMA将多个CPU划分为几组，并配以专门的内存空间。不同属组之间以总线相连，因此CPU对自己属组额内存进行操作的速度快于操作其他属组的内存。NUMA的出现是对自适应内存的一大挑战，因为无法预测对象会位于哪一组内存中。

<a name="nursery" />
## 新生代（nursery）

>参见[新生代][young_space]。

<a name="obfuscation" />
## 混淆（obfuscation）

Java代码混淆是有意对字节码的修改，以便加大逆向工程的难度。名字修饰（name mangling）并不是应用程序的性能，但可能会给调试程序带来些麻烦。通过修改控制流来使用Java中不支持的结构，可能会扰乱，甚至破坏JIT编译器或优化器的工作，应尽量避免。

>参见[名字修饰][name_mangling]。

<a name="object_header" />
## 对象头（obejct header）

在JVM中，每个对象都需要使用些元数据信息，例如类型、垃圾回收状态，以及是否被加锁等。这些信息的使用频率很高，因此将之存储在对象本身的头部，通过对象指针来引用。通常情况下，对象头中会包含锁状态、垃圾回收状态和类型信息。

>参见[锁字][lock_word]和[类块][class_block]。

<a name="object_pooling" />
## 对象池（object pooling）

对象池是为了避免重复内存分配所带来的执行开销而提出的，即重用已有的对象，而不是每次都重复创建新对象，就具体实现来说，就是讲无用对象放置到对象池中，以防止其被回收掉。通常来说，使用对象池并不是个好主意，因为它会熬卵垃圾回收器的反馈信息，延长了对象的生命周期。

<a name="old_space" />
## 老年代（old space）

在分代式垃圾回收中，对象在经历过几轮垃圾回收后，会被移出新生代，统一存放到另一个地方，即老年代。

<a name="OSR">
## 栈上替换（On-stack replacement OSR）

栈上替换是一种代码优化技术，即在方法运行过程中就将控制流切换到优化编译之后的新方法上。JRockit本身并不支持OSR，它会等到目标方法执行结束后在进行替换。对于某些写的稀烂的微基准测试来说，这种实现方式是测不出好结果的，但实践证明，不支持OSR并不是什么大问题。

<a name="operative_set" />
## 操作集（operative set）

在JRockit Mission Control中，操作集是一个用户定义的事件集合，主要用于在不同的标签页之间过滤搜索结果。此外，操作集还可配合关连键来查找与某个事件属性相关联的事件。

>参见[关联键][relational_key]。

<a name="optimization_queue" />
## 优化队列（optimization queue）

优化队列是JRockit中的一个词儿，是指用于存储代码生成请求的队列。优化器线程会通过该队列获取优化请求，对目标代码进行优化。

>参见[代码生成队列][code_generation_queue]。

<a name="out_of_the_box_behavior" />
## 开箱即用（out of the box behavior）

对于自适应运行时来说，应该是不需要做任何额外配置就可以顺畅运行的，然后无需用户参与，根据运行时的反馈信息做调整运行时的行为，优化堆的大小，从而达到稳定的运行状态。但现实是残酷的，这种好事并不多，因此如何做到开箱即用是一个很热门的研究课题。

<a name="overprovisioning" />
## 过渡设计（overprovisioning）

过渡设计是指，为了能够应对系统峰值，而使用比实际所需更多的硬件来部署应用程序。

<a name="OS_thread" />
## 操作系统线程（OS thread）

>参见[本地线程][native_thread]。

<a name="page_protection" />
## 页保护（page protection）

页保护是指将虚拟内存的某个页面标记为不可用或不可执行（如果页面中包含了代码的话），因此，当访问这个页面时会触发一个异常。页保护机制可用于实现栈溢出检测、启动安全点（暂停应用程序线程的位置），以及将无用代码换出等操作。

>参见[保护页][guard_page]和[安全点][safepoint]。

<a name="parallel_garbage_collection" />
## 并行垃圾回收（parallel garbage collection）

在本书中，并行垃圾回收只是一种以最大化系统吞吐量、不考虑系统延迟的垃圾回收策略。相对于以低延迟为优化目标的垃圾回收算法来说，并行垃圾回收所使用的算法相对简单一些，因此使用并行垃圾回收会导致无法预测的应用程序暂停。

>参见[延迟][latency] [确定式垃圾回收][deterministic_garbage_collection]和[并发垃圾回收][concurrent_garbage_collection]。

<a name="paravirtualization" />
## 半虚拟化（paravirtualization）

半虚拟化是指，运行客户应用程序时需要通过预定义的API与底层虚拟机管理程序进行交互。

>参见[全虚拟化][full_virtualization]和[虚拟化][virtualization]。

<a name="password_file" />
## 密码文件（password file）

在JMX中，密码文件记录了不同角色的定义和对应的密码。一般来说，该文件会放置于"JROCKIT_HOME/jre/lib/management/jmxremote.password"。

>参见[访问文件][access_file]。

<a name="PDE" />
## 插件开发环境（plug-in development environment, PDE）

PDE是Eclipse IDE中开发Equinox体系查看的环境，提供了预定义的模板和配置，用户通过这些预定义的内容就可以为新插件生成初始内容，也可以自定义新的模板和配置。

>参见[扩展点][extension_point]。

<a name="perspective" />
## 透视图（perspective）

透视图是RCP中的一个概念，在其中包含预定义的视图。例如，JRockit Mission Control透视图中包含了JRockit Mission Control中最常用的一些视图。菜单"Window | Reset Perspective"可用于重置为默认配置。

>参见[富客户端平台][RCP]。

<a name="phantom_reference" />
## 虚引用（phantom reference）

>参见[软引用][soft_reference]。

<a name="prefetching" />
## 预抓取（prefetching）

预抓取是指在CPU访问某个内存位置之前，就预先将该内存为止处的内容抓取到缓存行（cache line）中缓存起来。尽管预抓取是个比较费时的操作，但如果预抓取和实际内存访问操作的时间间隔（执行其他一些不相关的指令）够大，则采用预抓取是可以带来较大性能提升的。

预抓取工作，可以是由CPU隐式完成的（硬件预抓取），也可以是由程序员显式的将预抓取指令写入到代码中来完成的（软件预抓取）。

一般来说，软件预抓取是由编译器通过一些启发式算法加入到代码中的。例如，在JRockit中，预抓取指令会插入到访问线程局部区域来为对象分配内存的代码中，以及为执行大量属性域访问操作而优化过的代码中。若是将预抓取指令放错位置，则会降低系统的整体性能。

>参见[线程局部区域][TLA] [硬件预抓取][hardware_prefetching]和[软件预抓取][software_prefetching]。

<a name="producer" />
## 生产者（producer）

在JFR中，生产者（或称事件生产者）是指为事件提供命名空间和类型定义的实体。

>参见[事件][event]和[事件类型][event_type]。

<a name="promtion" />
## 提升（promotion）

提升是指将对象提升到一个可以更长久保存对象的内存区域。例如，将对象从线程局部区域提升到堆中，或者将新生代中的对象替身告老年代中。

>参见[分代式垃圾回收][generational_garbage_collection]和[线程局部区域][TLA]。

<a name="read_barrier" />
## 读屏障（read barrier）

读屏障是指编译器在属性域载入代码之前插入的一小段代码。读屏障的作用之一就是执行垃圾回收，以便检查位于线程局部区域（TLA）中对象的作用域是否已经超出了该线程，或者访问某个属性域的线程和创建该对象的线程是否是同一个线程。

>参见[写屏障][write_barrier]。

<a name="real_time" />
## 实时（real time）

在本书中，实时是指运行时环境中需要对系统延迟进行控制的场景，例如软实时。

>参见[软实时][soft_real_time]和[硬实时][hard_real_time]。

<a name="recording_agent" />
## 记录代理（recording agent）

>参见[记录引擎][recording_engine]。

<a name="recording_engine" />
## 记录引擎（recording engine）

记录引擎是JFR的一部分，处理IO和内存缓冲区等事件，提供了控制记录任务生命周期的API。记录引擎也被称为记录代理。

<a name="recursive_locking" />
## 递归加锁（recursive lock）

在Java中，允许在不释放监视器对象的情况下，对该监视器做重复加锁的操作。例如，某个对象的同步方法被内联到另一个同步方法中时，就出现了递归加锁。JVM的同步机制必须要能够正确处理这种情况，记录加锁顺序，以判断加锁/解锁操作是否是配对的。

>参见[锁配对][lock_pairing]和[锁符号][lock_token]。

<a name="reference_compression" />
## 引用压缩（reference compression）

引用压缩是指将原始大小的引用转换为大小较小的形式。

>参见[压缩引用][compressed_reference]和[引用解压缩][reference_decompression]。

<a name="reference_counting" />
## 引用计数（reference counting）

引用计数是一种垃圾回收方法，记录每个对象被引用的次数。当引用计数降为0的时候，会将该对象回收掉。引用计数实现简单，但却有一个固有缺陷，那就是无法处理循环引用的问题。

>参见[引用追踪垃圾回收][tracing_garbage_collection]。

<a name="reference_decompression" />
## 引用解压缩（reference decompression）

引用解压缩是指将被压缩的引用反解回引用的原始形式。

>参见[压缩引用][compressed_reference]和[引用压缩][reference_compression]。

<a name="register_allocation" />
## 寄存器分配（register allocation）

寄存器分配是指，在将IR转换为更靠近底层平台的表示形式时，所涉及到的将硬件寄存器分配给虚拟寄存器/变量的过程。一般来说，硬件寄存器的数量是少于程序中变量的数目的，此时就需要通过"Spilling"技术将一些变量先转存到内存能中（通常是用户栈中）。由于需要执行一些变量在内存和寄存器中的换入换出操作，因而会带来一些性能开销。优化寄存器分配算法是一个非常重要的、计算密集型的问题。

>参见[Spilling][spilling]。

<a name="relational_key" />
## 关联键（relational key）

关联键是与事件类型属性相关的元信息，将不同事件类型关联起来。关联键的值是事件类型属性，以URI的格式表示，而实际属性会与事件配合使用。

<a name="RCP" />
## 富客户端平台（rich client platform, RCP）

使用Eclipse Equinox技术（OSGi在Eclipse中实现）和SWT（Standard Widget Toolki），可以借助Eclipse平台的核心来构建一些其他的应用程序，例如，JRockit Mission Control就是基于Eclipse RCP实现的。

<a name="role" />
## 角色（role）

在JMX中，作为安全框架的一部分，角色用于控制远程访问和管理的安全性。角色是与相应的访问权限相关联的。为了保证有效性，角色必须同时存在于密码文件和访问文件中才行。

>参见[JMX][JMX] [密码文件][password_file]和[访问文件][access_file]

<a name="rollforwarding" />
## Rollforwarding

Rollforwarding是指，在老版本的JRockit中，通过模拟接下来的几个指令将暂停住的应用程序线程带入到安全点，改变该线程的上下文。

>参见[活动对象][livemap]和[安全点][safepoint]。

<a name="根集合" />
## 根集合（root set）

引用追踪垃圾回收器会使用那些从一开始就处于可达状的对象作为初始集合，通常来说，会使用位于寄存器和局部栈帧中的对象作为初始集合。此外，根集合中还包含了一些全局数据，例如静态属性域中的变量。

>参见[活动对象][livemap]和[引用追踪垃圾回收][tracing_garbage_collection]。

<a name="run_mode" />
## 运行模式（run mode）

默认情况下，JFR的用户界面是以运行模式里启动的。

>参见[设计模式][design_mode]。

<a name="safepoint" />
## 安全点（safepoint）

安全点是指Java代码中可以使Java线程暂停的地方。安全点中包含了在其他地方拿不到的信息供运行时使用，例如在寄存器中包含了对象。此外，安全点还可以保证线程上下文中时对象、内部直镇，或者不是对象，而绝不会是中间状态。

>参见[活动对象图][livemap]。

<a name="sample" />
## 采样（sample）

采样是指以预先设计好的时间间隔来收集相关数据。自适应运行时的基础就是这些高质量的采样数据。

<a name="sample_based_profiling" />
## 采样分析（sample-based profiling）

采样分析是指根据统计学原理，从所有可能数据或采样数据中，抽取出一部分数据对应用程序进行分析。如果抽取的正确，可以节省不少分析开销。

>参见[准确分析][exact_profiling]。

<a name="semaphore" />
## 信号量（semaphore）

信号量是一种构建于`wait`和`notify`语义之上的同步机制。Java中的每个对象都有`wait`和`notify`方法。

在同步上下文中执行`wait`方法会使当前进程进入休眠状态，直到接收到唤醒通知。在同步上下文中执行`notify`方法会通知调度器唤醒阻塞在目标监视器上的其他某个线程。Java中的`notifyAll`方法与`wait`方法类似，区别在于`notifyAll`方法会唤醒阻塞在目标监视器上的所有线程，其中一个会获得监视器，其余的线程会再次休眠。`notifyAll`方法可以更好的避免死锁情况的出现，但会带来一点额外的性能消耗。

>参见[死锁][deadlock]和[监视器][monitor]。

<a name="server_side_template" />
## 服务器端模板（server-side template）

服务器端模板是JSON格式的文件，用于控制JFR中事件设置。

>参见[事件设置][event_settings]和[客户端模板][client_side_template]。

<a name="soft_real_time" />
## 软实时（soft real-time）

软实时是指需要对系统延迟做某种程度控制的环境，此外，虽说需要控制延迟，但却不需要严格控制每次暂停的时间边界。通常情况下，软实时会涉及到根据延迟来指定服务等级的质量。JRockit Real Time的垃圾回收器所支持的确定式垃圾回收就是软实时的实现。

>参见[硬实时][hard_real_time]。

<a name="soft_reference" />
## 软引用（soft reference）

软引用是一些垃圾回收器需要特殊对待的对象类型。Java中共有4种类型引用，分别是强引用（strong reference）、软引用（soft reference）、弱引用（weak reference）和虚引用（phantom reference）。当内存不足时，垃圾回收器可以回收掉软引用和弱引用所包装的对象（通常来说，包装对象是一个`Reference`类的实例）。虚引用是个很特殊的存在，它所包装的对象是无法被获取到的，其功能在于实现更安全的"析构函数"（译者注，这里的"析构函数"只是个比喻）。

<a name="software_prefetching" />
## 软件预抓取（software prefetching）

软件预抓取是指在代码通过显式预抓取指令来实现的预抓取。

>参见[硬件预抓取][hardware_prefetching]和[预抓取][prefetching]。

<a name="spilling" />
## Spilling

寄存器分配起需要将一大堆变量映射到少量的物理寄存器上。如果同时使用的变量的数目比可用寄存器的数目多的话，就不得不将一些变量先临时存储到内存中，这就是Spilling。通常情况下，会将这些无法同时处理的变量放到生成这些变量的栈帧中。大量使用Spilling技术会带来巨大的性能损耗。

>参见[Spilling][spilling]和[原子指令][atomic_instruction]。

<a name="spinlock" />
## 自旋锁（spinlock）

自旋锁的实现中通常包含了原子指令和条件跳转，形成一个循环，再完成操作之前，会一直消耗CPU资源。使用自旋锁来实现简单的、没什么竞争的、持有时间也不长的同步锁是挺不错的，不过对于大部分应用程序来说，自旋锁并不是最佳选择。

>参见[瘦锁][thin_lock]和[胖锁][fat_lock]。

<a name="SSA_form" />
## 静态单赋值形式（static single assignment form，SSA form）

静态单赋值形式是一种对中间代码进行的转换，使每个变量仅被赋值以此。经过这种转换后，可以简化其他优化手段和数据流分析。静态单赋值形式定义了一个连接操作符`Φ`，用于连接任意多的来源变量和目标，其中对目标的含义是"任意一个源变量"。由于操作符`Φ`不能用本地代码来表示，因此在发射代码（code emission）之前，需要再将SSA形式转换会普通代码形式。

<a name="static_compilation" />
## 静态编译（static compilation）

静态编译是指在静态环境中，在应用程序运行之前先将所有代码都编译好，不接收运行时的返回信息，例如C++。静态编译的优势是在编译时可以对整个系统代码做一次完整的分析，而且编译后程序在运行时不会发生变化，虽说编译时间会长一点，不过还好，毕竟不影响运行时间。相应的，静态编译的缺点是，无法根据运行时的反馈信息来动态调整优化策略和程序行为。

>参见[预编译][ahead_of_time_compilation] [自适应代码生成][adaptive_code_generation]和[JIT_compilation][JIT编译]。

<a name="stop_and_copy" />
## 暂停-拷贝（stop and copy）

暂停-拷贝是一种引用追踪垃圾回收技术，它会将堆分为相等的两部分，并且每次只会使用其中一个。在执行垃圾回收时，引用追踪算法会增量式的计算存活对象集，并将之移入到另一个违背使用的堆空间，这种方式隐式的实现了内存整理。在垃圾回收之后，另一个堆空间中的全是存活对象，并作为新的堆空间使用，而当前被收集的堆空间则会被全部回收。该算法实现简单，但却会浪费大量的堆空间。

>参见[引用追踪垃圾回收][tracing_garbage_collection] [内存整理][compaction]和[碎片化][fragmentation]。

<a name="STW" />
## Stopping-the-world（STW）

STW是指暂停应用程序中的线程，以便运行时完成一些内部工作，例如运行时执行非并发垃圾回收。STW是造成系统延迟的主要原因（当然还有其他原因，例如等待IO）。

>参见[延迟][latency]。

<a name="strong_reference" />
## 强引用（strong reference）

强引用是Java中的标准引用形式，默认情况下就是强引用，所谓"强引用"，其实只是相对于软引用和弱引用来说的。

>参见[软引用][soft_reference]。

<a name="SWT" />
## SWT

SWT，即Standard Widget Toolkit，是Eclipse RCP平台所使用的一种用户界面工具库。当然，JRockit Mission Control也用上了。
SWT stands for Standard Widget Toolkit. This is the user interface toolkit library
used by the Eclipse RCP platform, and consequently also by JRockit Mission Control.

>参见[富客户端平台][RCP]。

<a name="synthetic_attribute" />
## 合成属性（synthetic attribute）

在JMX中，合成属性并不是MBean的真是属性，而是JRockit Mission Control控台中的一个客户端结构。

>参见[JMX][JMX]和[MBean][MBean]。

<a name="tab_group" />
## 标签组（tab group）

标签组是JRockit Mission Control GUI中一组标签的集合，按功能分类聚合在一起。

>参见[标签组工具栏][tab_group_toolbar]。

<a name="tab_group_toolbar" />
## 标签组工具栏（tab group toolkit）

标签组工具栏位于JRockit Mission Control Console，JRA和JFR编辑器左侧。

>参见[标签组][tab_group]。

<a name="thin_lock" />
## 瘦锁（thin lock）

瘦锁是一种简单小巧的锁实现，适用于竞争不激烈和持锁事件不长的场景，通常用于实现自旋锁。

>参见[胖锁][fat_lock]和[自旋锁][spinlock]。

<a name="thread_local_allocation" />
## 线程局部分配（thrad local allocation）

线程局部分配是指在线程局部区域中为新对象分配内存，然后在必要的时候（线程局部区域已满或需要做某些优化），再将对象提升到堆中。

>参见[线程局部区域][TLA]。

<a name="TLA" />
## 线程局部区域（thread local area, TLA）

TLA是指在线程局部使用的一小块缓冲区，用于为线程局部对象分配内存。由于TLA是线程局部的，使用时无需加锁，因为可以大大降低为对象分配内存的开销。当TLA已满时，需要将其中的对象提升到堆空间中。

<a name="thrad_local_heap" />
## 线程局部堆（thread local heap，TLH）

TLH是对TLA的扩展，实现垃圾回收时，可以使用几个稍大的TLH和一个全局堆。若是应用程序中绝大部分对象都囿于线程局部的话，则大部分对象都不会被提升到全局堆中，也就不会有那么多同步操作了。一般来说，对TLH做垃圾回收操作的开销是很大的，因为读屏障和写屏障都需要检查目标对象是否会被其他线程看到。但在某些场景下（例如专用的操作系统层），是可以降低这种开销的。

>参见[分代式垃圾回收][generational_garbage_collection]和[线程局部区域][TLA]。

<a name="thread_pooling" />
## 线程池（thread pool）

线程池是指在某个资源池始终保持一定数量的活动线程，以降低重复创建线程的开销。线程池不是"十全大补丸"，应根据自身场景和底层线程模型来判断是否使用。

<a name="thread_sampling" />
## 线程采样（thread sampling）

线程采样是一种热点方法检测机制，其具体实现是周期性的检查工作都把时间花在了哪个方法上。通常情况下，在采样时，会先暂停应用程序，此时线程的指令指针寄存器会指向正在执行的方法表或代码块表中的一项。当收集到足够的信息后，就可以判断出哪些是热点方法，从而进行针对性的优化，还可以判断出一个方法中哪条执行路径的使用频率更高。

<a name="throughout" />
## 吞吐量（throughout）

吞吐量通常用于衡量每个时间单位内所处理的事务数。一般来说，只要平均吞吐量足够大的话，就没必要太关注方差的大小了。

>参见[延迟][latency]和[并行垃圾回收][parallel_garbage_collection]。

<a name="tracing_garbage_collection" />
## 引用追踪垃圾回收（tracing garbage collection）

引用追踪垃圾回收是指遍历堆中对象的所有引用，找出所有相关联的对象，从而建立存活对象集。在遍历之后，没有被扫描到的对象将会被认为是无用对象而被回收掉。

>参见[标记-清理][mark_and_sweep]和[暂停-拷贝][stop_and_copy]。

<a name="trampoline" />
## Trampoline

Trampoline是一种用在JIT编译中的代码生成机制。一般来说，Trampoline是一段存储与内存中的本地代码，作为"已经"完整编译过的目标方法使用（实际上可能还没编译完）。当调用目标方法时，会执行Trampoline代码，生成真正的本地代码，并将控制流指向新生成的代码。下一次再调用该目标方法时，就可以直接执行这个新生成的本地代码了，Trampoline代码也可以从代码缓冲区中删除了。

>参见[方法垃圾回收][method_garbage_collection]和[JIT编译][JIT_compilation]。

<a name="trigger_action" />
## 触发器动作（trigger action）

触发器规则是JRockit Management Console中的自定义动作，当满足触发器规则时，会调用该动作。

>参见[触发器规则][trigger_rule]。

<a name="trigger_condition" />
## 触发器条件（trigger condition）

触发条件是指触发器规则的判断条件，包含了属性值和具体条件，例如"在CPU负载已经连续2分钟处于90%了"。

>参见[触发器规则][trigger_rule]。

<a name="trigger_constraint" />
## 触发器约束（trigger constraint）

触发器约束指定了触发器规则的生效时间，例如"只在早8点到晚5点之间生效"

>参见[触发器规则][trigger_rule]。

<a name="trigger_rule" />
## 触发器规则（trigger rule）

触发器规则是Management Console中概念，它包含了触发器条件、触发器动作和可选的触发器约束。

>参见[触发器条件][trigger_condition] [触发器动作][trigger_action]和[触发器约束][trigger_constraint]。

<a name="truststore" />
## 信任库（truststore）

信任库中存储了可信方的证书。

>参见[密钥库][keystore]。

<a name="virtualization" />
## 虚拟化（virtualization）

虚拟化是指在虚拟/模拟硬件上，通过虚拟机管理程序来运行客户应用程序（例如操作系统）。通过虚拟化，可以使多个客户应用程序同时运行在一台物理机器上，提升了机器的资源利用率。此外，借助于统一的管理框架，可以将一组物理机器抽象为计算云，通过虚拟化的方式为客户提供计算资源。

>参见[客户应用程序][guest] [虚拟机管理程序][hypervisor] [全虚拟化][full_virtualization]和[半虚拟化][paravirtualization]。

<a name="virtual_machine_image" />
## 虚拟机镜像（virtual machine image）

在本书中，虚拟机镜像是指用于虚拟化场景的文件包，通常会包含针对于指定虚拟机管理程序的配置文件和若干用于运行预装应用程序的磁盘镜像。有时候，虚拟机镜像也称为虚拟镜像和虚拟容器。

>参见[虚拟化][virtualization]。

<a name="volatile_field" />
## 易变域（volatile field）

在Java中，属性域前的限定符`volatile`规定了对该属性域的访问需要符合更严格的内存语义，所有的线程都会立即看到对该属性域的修改。

>参见[Java内存模型][JMM]。

<a name="warm_up" />
## 热身（warm up）

做基准测试时，需要在进行主测试之前，先执行一些小规模测试，以便使自适应运行时达到相对稳定的运行状态，剔除系统稳定波动而带来的误差。在热身结束后，就可以正式开始做主测试了。

<a name="weak_reference" />
## 弱引用

>参见[软引用][soft_reference]。

<a name="write_barrier" />
## 写屏障（write barrier）

通常来说，写屏障是由编译器生成的小代码块，在执行存储属性域的时候会被调用。当存储属性域会影响到系统其他部分时，需要用到写屏障。例如，在分代式垃圾回收中，由于垃圾回收器需要跟踪从老年代指向新生代的引用，因此通过写屏障来标记是否对堆的某个部分执行过写操作，从而避免了对整个堆的扫描操作。（译者注，这里意译成分较大。）

>参见[读屏障][read_barrier] [分代式垃圾回收][generational_garbage_collection] [老年代][old_space]和[新生代][young_space]。

<a name="young_space" />
## 新生代（young space）

新生代是堆空间的一部分，按大小来说通常会比整个堆小几个数量级，用于存储刚刚创建的新对象。新生代主要用于存储临时对象和短生命周期对象（以实际情况来说，大部分对象确实是这样的），其垃圾回收过程也是独立进行的。由于新生代通常较小，因为其垃圾回收的频率也可以相对频繁一些。当新生代中的对象经过若干轮垃圾回收后依然存活，则需要将之提升到老年代中，那里的存储空间更大，垃圾回收的频率也更低一些。

在本书中，"新生代"和"年轻代"是同一个意思。

>参见[分代式垃圾回收][generational_garbage_collection]。




[AST]:                              #AST                                "抽象语法树"
[IR]:                               #IR                                 "中间表示"
[access_file]:                      #access_file                        "访问文件"
[password_file]:                    #password_file                      "密码文件"
[JMX]:                              #JMX                                "JMX"
[JIT]:                              #JIT                                "JIT"
[mixed_mode_interpretation]:        #mixed_mode_interpretation          "混合模式解释执行"
[adaptive_code_generation]:         #adaptive_code_generation           "自适应代码生成"
[adaptive_memory_management]:       #adaptive_memory_management         "自适应内存管理"
[agent]:                            #agent                              "代理"
[JFR]:                              #JFR                                "JRockit Flight Recorder"
[allocation_profiling]:             #allocation_profiling               "内存分配分析"
[atomic_instruction]:               #atomic_instruction                 "原子指令"
[CAS]:                              #CAS                                "比较并交换"
[automatic_memory_management]:      #automatic_memory_management        "自动内存管理"
[balloon_driver]:                   #balloon_driver                     "膨胀驱动程序"
[virtualization]:                   #virtualization                     "虚拟化"
[guest]:                            #guest                              "客户应用程序"
[hypervisor]:                       #hypervisor                         "虚拟机管理程序"
[control_flow_graph]:               #control_flow_graph                 "控制流图"
[benchmark_driver]:                 #benchmark_driver                   "基准测试驱动"
[biased_locking]:                   #biased_locking                     "偏向锁"
[lazy_unlocking]:                   #lazy_unlocking                     "延迟解锁"
[bytecode]:                         #bytecode                           "字节码"
[bytecode_interpertation]:          #bytecode_interpertation            "字节码解释执行"
[call_profiling]:                   #call_profiling                     "调用分析"
[card]:                             #card                               "卡"
[write_barrier]:                    #write_barrier                      "写屏障"
[generational_garbage_collection]:  #generational_garbage_collection    "分代式垃圾回收"
[card_table]:                       #card_table                         "卡表"
[class_block]:                      #class_block                        "类块"
[object_header]:                    #object_header                      "对象头"
[class_garbage_collection]:         #class_garbage_collection           "类型垃圾回收"
[client_side_template]:             #client_side_template               "客户端模板"
[server_side_template]:             #server_side_template               "服务器端模板"
[optimization_queue]:               #optimization_queue                 "优化队列"
[code_generation_queue]:            #code_generation_queue              "代码生成队列"
[color]:                            #color                              "着色"
[register_allocation]:              #register_allocation                "寄存器分配"
[tracing_garbage_collection]:       #tracing_garbage_collection         "引用追踪垃圾回收"
[compaction]:                       #compaction                         "内存整理"
[fragmentation]:                    #fragmentation                      "碎片化"
[spinlock]:                         #spinlock                           "自旋锁"
[compressed_reference]:             #compressed_reference               "压缩引用"
[reference_compression]:            #reference_compression              "引用压缩"
[reference_decompression]:          #reference_decompression            "引用解压缩"
[concurrent_garbage_collection]:    #concurrent_garbage_collection      "并发垃圾回收"
[parallel_garbage_collection]:      #parallel_garbage_collection        "并行垃圾回收"
[conservative_garbage_collection]:  #conservative_garbage_collection    "保守式垃圾回收"
[exact_garbage_collection]:         #exact_garbage_collection           "准确式垃圾回收"
[livemap]:                          #livemap                            "活动对象图"
[safepoint]:                        #safepoint                          "安全点"
[constant_pool]:                    #constant_pool                      "常量池"
[continuous_JRA]:                   #continuous_JRA                     "持续型JRA"
[cpu_profiling]:                    #cpu_profiling                      "CPU分析"
[critical_section]:                 #critical_section                   "临界区"
[dead_code]:                        #dead_code                          "死代码"
[deadlock]:                         #deadlock                           "死锁"
[fat_lock]:                         #fat_lock                           "胖锁"
[livelock]:                         #livelock                           "活锁"
[deadlock_detection]:               #deadlock_detection                 "死锁检测"
[design_mode]:                      #design_mode                        "设计模式"
[run_mode]:                         #run_mode                           "运行模式"
[deterministic_garbage_collection]: #deterministic_garbage_collection   "确定式垃圾回收"
[latency]:                          #latency                            "延迟"
[diagnostic_command]:               #diagnostic_command                 "诊断命令"
[JRCMD]:                            #JRCMD                              "JRCMD"
[JMAPI]:                            #JMAPI                              "JMAPI"
[JMM]:                              #JMM                                "Java内存模型"
[double_checked_locking]:           #double_checked_locking             "双检查锁"
[driver]:                           #driver                             "驱动程序"
[editor]:                           #editor                             "编辑器"
[RCP]:                              #RCP                                "富客户端平台"
[escape_analysis]:                  #escape_analysis                    "逃逸分析"
[event]:                            #event                              "事件"
[event_type]:                       #event_type                         "事件类型"
[event_attribute]:                  #event_attribute                    "事件属性"
[event_field]:                      #event_field                        "事件域"
[event_settings]:                   #event_settings                     "事件配置"
[exact_profiling]:                  #exact_profiling                    "准确分析"
[sample_based_profiling]:           #sample_based_profiling             "采样分析"
[extension_point]:                  #extension_point                    "扩展点"
[fairness]:                         #fairness                           "公平性"
[thin_lock]:                        #thin_lock                          "瘦锁"
[free_list]:                        #free_list                          "空闲列表"
[GC_strategy]:                      #GC_strategy                        "GC策略"
[GC_heuristic]:                     #GC_heuristic                       "启发式GC"
[GC_pause_ratio]:                   #GC_pause_ratio                     "GC暂停时间比例"
[generation]:                       #generation                         "代"
[heap]:                             #heap                               "堆"
[young_space]:                      #young_space                        "年轻代"
[old_space]:                        #old_space                          "老年代"
[graph_coloring]:                   #graph_coloring                     "图着色"
[spilling]:                         #spilling                           "Spilling"
[graph_fusion]:                     #graph_fusion                       "图融合"
[green_thread]:                     #green_thread                       "绿色线程"
[NxM_thread]:                       #NxM_thread                         "多对多线程模型"
[guard_page]:                       #guard_page                         "保护页"
[hard_real_time]:                   #hard_real_time                     "硬实时"
[soft_real_time]:                   #soft_real_time                     "软实时"
[hardware_prefetching]:             #hardware_prefetching               "硬件预抓取"
[prefetching]:                      #prefetching                        "预抓取"
[software_prefetching]:             #software_prefetching               "软件预抓取"
[native_memory]:                    #native_memory                      "本地堆"
[MIR]:                              #MIR                                "中级中间表示"
[HIR]:                              #HIR                                "高级中间表示"
[LIR]:                              #LIR                                "低级中间表示"
[native_code]:                      #native_code                        "本地代码"
[hosted_hypervisor]:                #hosted_hypervisor                  "托管型虚拟机管理程序"
[native_hypervisor]:                #native_hypervisor                  "本地型虚拟机管理程序"
[inline]:                           #inline                             "内联"
[internal_pointer]:                 #internal_pointer                   "内部指针"
[invocation_counter]:               #invocation_counter                 "调用计数器"
[exact_profiling]:                  #exact_profiling                    "准确分析"
[thread_sampling]:                  #thread_sampling                    "线程采样"
[java_bytecode]:                    #java_bytecode                      "Java字节码"
[JIT_compilation]:                  #JIT_compilation                    "即时编译"
[JMXMAPI]:                          #JMXMAPI                            "JMXMAPI"
[JSR-133]:                          #JSR-133                            "JSR-133"
[JSR-134]:                          #JSR-134                            "JSR-134"
[JSR-292]:                          #JSR-292                            "JSR-292"
[JRCMD]:                            #JRCMD                              "JRCMD"
[JRockit]:                          #JRockit                            "JRockit"
[Memleak]:                          #Memleak                            "JRockit Memory Leak Detector"
[jrockit_mission_control]:          #jrockit_mission_control            "JRockit Mission Control"
[JRA]:                              #JRA                                "JRockit Runtime Analyzer"
[JSR]:                              #JSR                                "JSR"
[MBean_server]:                     #MBean_server                       "MBean服务器"
[keystore]:                         #keystore                           "密钥库"
[truststore]:                       #truststore                         "信任库"
[lane]:                             #lane                               "通道"
[large_page]:                       #large_page                         "大内存页"
[STW]:                              #STW                                "Stopping-the-world"
[latency_threshold]:                #latency_threshold                  "延迟阈值"
[live_object]:                      #live_object                        "存活对象"
[root_set]:                         #root_set                           "根集合"
[live_set]:                         #live_set                           "存活集合"
[live_set_fragmentation]:           #live_set_fragmentation             "存活集合 + 碎片化"
[lock_inflation]:                   #lock_inflation                     "锁膨胀"
[lock_pairing]:                     #lock_pairing                       "锁配对"
[recursive_locking]:                #recursive_locking                  "递归加锁"
[lock_token]:                       #lock_token                         "锁符号"
[lock_word]:                        #lock_word                          "锁字"
[mark_and_sweep]:                   #mark_and_sweep                     "标记-清理"
[master_password]:                  #master_password                    "主密码"
[MD5]:                              #MD5                                "MD5"
[method_garbage_collection]:        #method_garbage_collection          "方法垃圾回收"
[micro_benchmark]:                  #micro_benchmark                    "微基准测试"
[monitor]:                          #monitor                            "监视器"
[name_mangling]:                    #name_mangling                      "名字修饰"
[obfuscation]:                      #obfuscation                        "混淆"
[native_thread]:                    #native_thread                      "本地线程"
[non_contiguous_heap]:              #non_contiguous_heap                "非连续堆"
[NUMA]:                             #NUMA                               "NUMA架构"
[nursery]:                          #nursery                            "新生代"
[object_pooling]:                   #object_pooling                     "对象池"
[OSR]:                              #OSR                                "栈上替换"
[operative_set]:                    #operative_set                      "操作集"
[relational_key]:                   #relational_key                     "关联键"
[out_of_the_box_behavior]:          #out_of_the_box_behavior            "开箱即用"
[overprovisioning]:                 #overprovisioning                   "过渡设计"
[OS_thread]:                        #OS_thread                          "操作系统线程"
[page_protection]:                  #page_protection                    "页保护"
[paravirtualization]:               #paravirtualization                 "半虚拟化"
[PDE]:                              #PDE                                "插件开发环境"
[perspective]:                      #perspective                        "透视图"
[soft_reference]:                   #soft_reference                     "软引用"
[phantom_reference]:                #phantom_reference                  "虚引用"
[TLA]:                              #TLA                                "线程局部区域"
[producer]:                         #producer                           "生产者"
[promotion]:                        #promotion                          "提升"
[read_barrier]:                     #read_barrier                       "读屏障"
[real_time]:                        #real_time                          "实时"
[recording_agent]:                  #recording_agent                    "记录代理"
[recording_engine]:                 #recording_engine                   "记录引擎"
[reference_counting]:               #reference_counting                 "引用计数"
[role]:                             #role                               "角色"
[rollforwarding]:                   #rollforwarding                     "Rollforwarding"
[sample]:                           #sample                             "采样"
[semaphore]:                        #semaphore                          "信号量"
[SSA_form]:                         #SSA_form                           "静态单赋值形式"
[static_compilation]:               #static_compilation                 "静态编译"
[stop_and_copy]:                    #stop_and_copy                      "暂停-拷贝"
[strong_reference]:                 #strong_reference                   "强引用"
[SWT]:                              #SWT                                "Standard Widget Tookit"
[tab_group]:                        #tab_group                          "标签组"
[tab_group_toolbar]:                #tab_group_toolbar                  "标签组工具栏"
[thread_local_allocation]:          #thread_local_allocation            "线程局部分配"
[thread_local_heap]:                #thread_local_heap                  "线程局部堆"
[thread_pooling]:                   #thread_pooling                     "线程池"
[throughout]:                       #throughout                         "吞吐量"
[trampoline]:                       #trampoline                         "Trampoline"
[trigger_action]:                   #trigger_action                     "触发器动作"
[trigger_rule]:                     #trigger_rule                       "触发器规则"
[trigger_condition]:                #trigger_condition                  "触发器条件"
[trigger_constraint]:               #trigger_constraint                 "触发器约束"
[virtual_machine_image]:            #virtual_machine_image              "虚拟机镜像"
[volatile_field]:                   #volatile_field                     "易变域"
[warm_up]:                          #warm_up                            "热身"
[weak_reference]:                   #weak_reference                     "弱引用"
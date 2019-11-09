---
title:      为啥Hikari快
layout:     post
category:   blog
tags:       [java, hikari]
---

# 为啥快

* 只干必要的事情
* 消除线程竞争
* 减少调用消耗
* 业务层面

# 只干必要的事情

只实现了数据源的基本功能，没有什么花哨的功能。

* 代理了`Connection` `Statement` `CallableStatement` `PreparedStatement` `ResultSet`实例，没有提供什么拦截器之类的额外功能。
* 指标监控比较简单，包括`totalConnections` `idleConnections` `activeConnections` `pendingThreads`

# 消除线程竞争

参见`ConcurrentBag`的实现。

使用ThreadLocal将连接与线程绑定，消除了大部分线程竞争的情况。

# 减少调用消耗

使用静态方法代替实例方法减少调用消耗。这部分消耗主要是`invokestatic`和`invokevirtual`字节码使用上有差别造成的。

不过这里不明白为什么要动态生成字节码而不是直接编码。

# 业务考虑

在关闭`Statement`时，需要在`Connection`中取消与该`Statement`的关联。那么如何快速找到`Connection`中的`Statement`呢？

使用`Map`是一个方法，不过空间上略有浪费。另一个方法是使用`List`，但需要遍历，不过对于一般业务来说，数量不太多，遍历倒也还好。不过使用JDK自带的`List`实现来说，在数据源使用这个业务场景下，`remove`方法的性能不太好，因为`remove`方法是从前向后遍历的，而实际的业务场景中，大部分情况是先关闭最后一个即可，即FILO模式。虽然可以使用`LinkedList`来规避问题，但`LinkedList`的空间局部性不好。Hikari的解决方案是自己实现了`List`，即`FastList`，对于`remove`方法的实现就是从后向前遍历，力求尽快退出循环，同时使用 **相同**代替 **相等**作为判断条件，提高效率。

# Resources

* [https://github.com/brettwooldridge/HikariCP/wiki/Down-the-Rabbit-Hole][1]

[1]:    https://github.com/brettwooldridge/HikariCP/wiki/Down-the-Rabbit-Hole
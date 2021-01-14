---
title:      Golang内存模型
layout:     post
category:   blog
tags:       [golang, memory model]
---

# 建议

* 多个协程同时更新一个变量时，需要同步访问
* 同步访问的手段：channel，`sync`或`sync.atomic`包中的工具

严格遵循上面的建议就可以处理绝大部分场景了。

# happens-before

单协程内，代码的执行顺序"可以认为"是与代码的编写顺序一致的。注意，这里之所以是"可以认为"，是因为编译器、处理器可能会对代码做重排序（当然是遵循语言规范，在不产生错误的前提下进行重排序）。在重排序之后，代码的执行顺序实际上是与编写顺序不同的，但如果不去观察重排序的话，单从结果上，是看不出区别的，如果去观察，则涉及到多协程间的交互，需要同步访问，这就脱离了"单协程内"这个讨论前提了。

happens-before，或称之为"先行发生"，用于规定多协程场景下，两个操作的先后顺序，具有传递性。注意，这里并不是说操作在CPU执行层面的先后顺序，而是指可观察到的结果的先后顺序，例如单协程内，每一行代码都先行发生于其后的一行代码。若两个操作没有happens-before关系，则它们是并发执行的。

A happens-before B，对应的是B happends-after A。

对于变量v，若读操作r能保证观察到写操作w的结果，则需要遵循以下两个前置条件

* r happens-before w
* 若有其他对v的写操作w1，则w1 happens-before w，或者，w1 happens-after r

若某个变量超过一个机器字长，则对该变量的读写，实际是多个指令完成，在并发场景下，需要做同步控制。

# synchronization
    
包的初始化方法`init` happens-before 对包中其他方法的调用。`mai.main` happens-before 所有其他包的`init`方法。

## 协程创建

创建协程的`go`调用 happens-before 协程中方法的执行。

## 协程销毁

协程退出与程序中的其他事件，没有happens-before关系。

## channel通信

**绝大部分场景下，应该使用channel做协程间数据交互。**

**发送数据给channel happens-before 从channel完成接收数据。**

    var c = make(chan int, 10)
    var a string

    func f() {
        a = "hello, world"
        c <- 0
    }

    func main() {
        go f()
        <-c
        print(a)
    }

运行这段代码，肯定能打印出"hello, world"，因为对a的赋值happens-before于写入channel，而读取channel则happens-before于打印a。

**关闭channel happens-before 从这个被关闭的channel中接收到0值。**

    var c = make(chan int, 10)
    var a string

    func f() {
        a = "hello, world"
        close(c)
    }

    func main() {
        go f()
        <-c
        print(a)
    }

运行这段代码，肯定能打印出"hello, world"。

**对于非缓冲channel，读取操作 happens-before 发送完成。**

    var c = make(chan int)
    var a string

    func f() {
        a = "hello, world"
        <-c
    }

    func main() {
        go f()
        c <- 0
        print(a)
    }

运行这段代码，肯定能打印出"hello, world"。但对于缓冲channel，则上面的不能保证会打印出"hello, world"。

**对于缓冲channel（假设容量为C），第k次读取操作 happens-before 第(k+C)次写操作完成。**

这个规则可说是上一个规则的泛化版本。

    var limit = make(chan int, 3)

    func main() {
        for _, w := range work {
            go func(w func()) {
                limit <- 1
                w()
                <-limit
            }(w)
        }
        select{}
    }

## lock

**对于`sync.Mutex`和`sync.RWMutex`的变量l，若n<m，则调用m次l.Unlock() happens-before 调用n次l.Lock()。**

    var l sync.Mutex
    var a string

    func f() {
        a = "hello, world"
        l.Unlock()
    }

    func main() {
        l.Lock()
        go f()
        l.Lock()
        print(a)
    }

运行这段代码，肯定能打印出"hello, world"。

**对于`sync.RWMutex`的变量l，l.RLock() happens-after 对l.Unlock()的n次调用，并且l.RUnlock happens-before 对l.Lock()的n+1次调用**

## once

`Once`可以在并发场景下完成初始化操作，多协程调用`once.Do(f)`时，只会有一个协程真正运行`f()`，其他协程被阻塞到`f()`执行完毕。

**once.Do(f)中的调用f() happens-before 所有once.Do(f)调用的返回。**

    var a string
    var once sync.Once

    func setup() {
        a = "hello, world"
    }

    func doprint() {
        once.Do(setup)
        print(a)
    }

    func twoprint() {
        go doprint()
        go doprint()
    }

运行这段代码，肯定能打印出"hello, world"。

# 错误的同步

读操作r可能会读取到并发执行的写操作w的结果，但这并不意味着其他 happens-after r的读操作也能读取到写操作w的结果。

    var a, b int

    func f() {
        a = 1
        b = 2
    }

    func g() {
        print(b)
        print(a)
    }

    func main() {
        go f()
        g()
    }

这个程序可能会打印出2和0。

双检查锁可用来降低同步操作的开销。上面的代码可能会改写成这样，但依然是错误的：

    var a string
    var done bool

    func setup() {
        a = "hello, world"
        done = true
    }

    func doprint() {
        if !done {
            once.Do(setup)
        }
        print(a)
    }

    func twoprint() {
        go doprint()
        go doprint()
    }

错误的原因是，观察到对`done`的写操作，并不意味这能观察到对`a`的写操作，因此这个代码可能会打印出空白字符串。

同理，下面使用忙等待的方式依然是错误的：

    var a string
    var done bool

    func setup() {
        a = "hello, world"
        done = true
    }

    func main() {
        go setup()
        for !done {
        }
        print(a)
    }

# Resources

* [The Go Memory Model][1]




[1]:    https://golang.org/ref/mem
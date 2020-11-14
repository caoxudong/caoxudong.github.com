---
title:      Golang Panic的输出内容
layout:     post
category:   blog
tags:       [golang]
---

记录golang在panic时，在调用栈中输出的参数如何解读。

* int -> 转换为16进制表示
* int64 -> 转换为16进制表示
* float32 -> 转换为16进制表示
* float64 -> 转换为16进制表示
* pointer -> 转换为16进制表示
* string -> 底层字节数组 + 长度
* struct -> 按照每个类型field的表示方式逐个罗列
* interface -> 类型指针 + 内容指针

示例代码如下：

    package main

    import (
        "fmt"
        "runtime/debug"
    )

    type Person struct {
        name string
        age  int
    }

    func main() {

        v_int := 1
        v_int64 := int64(2)
        var v_float32 float32 = 1.2
        v_float64 := 2.3
        v_string := "haha"
        v_struct := Person{name: "abc", age: 49}
        v_pointer := &v_struct
        v_array := [3]int{1, 2, 3}
        v_slice := []int{4, 5, 6}
        start(v_int, v_int64, v_float32, v_float64, v_string, v_struct, v_pointer, v_array, v_slice, &v_struct)
    }

    func start(v_int int, v_int64 int64, v_float32 float32, v_float64 float64, v_string string, v_struct Person, v_pointer *Person, v_array [3]int, v_slice []int, v_interface interface{}) {
        fmt.Printf("v_int=%v\n", v_int)
        fmt.Printf("v_int64=%v\n", v_int64)
        fmt.Printf("v_float32=%v\n", v_float32)
        fmt.Printf("v_float64=%v\n", v_float64)
        fmt.Printf("v_string=%v\n", v_string)
        fmt.Printf("v_struct=%v\n", v_struct)
        fmt.Printf("v_pointer=%v, v_pointer=%p\n", v_pointer, v_pointer)
        fmt.Printf("v_array=%v\n", v_array)
        fmt.Printf("v_slice=%v\n", v_slice)
        fmt.Printf("v_interface=%v\n", v_interface)
        fmt.Printf("\n")
        printPrimitive(v_int, v_int64, v_float32, v_float64, v_string)
        printArray(v_array, v_slice)
        printObject(v_struct, v_pointer, v_interface)
    }

    func printPrimitive(v_int int, v_int64 int64, v_float32 float32, v_float64 float64, v_string string) {
        debug.PrintStack()
        fmt.Printf("\n")
    }

    func printArray(v_array [3]int, v_slice []int) {
        debug.PrintStack()
        fmt.Printf("\n")
    }

    func printObject(v_struct Person, v_pointer *Person, v_interface interface{}) {
        debug.PrintStack()
        fmt.Printf("\n")
    }


执行结果

    v_int=1
    v_int64=2
    v_float32=1.2
    v_float64=2.3
    v_string=haha
    v_struct={abc 49}
    v_pointer=&{abc 49}, v_pointer=0xc00000c060
    v_array=[1 2 3]
    v_slice=[4 5 6]
    v_interface=&{abc 49}

    goroutine 1 [running]:
    runtime/debug.Stack(0x0, 0xc0000d8d10, 0x48ad51)
        /usr/lib/golang/src/runtime/debug/stack.go:24 +0x9d
    runtime/debug.PrintStack()
        /usr/lib/golang/src/runtime/debug/stack.go:16 +0x22
    main.printPrimitive(0x1, 0x2, 0x3f99999a, 0x4002666666666666, 0x4c1e6c, 0x4)
        /root/workspace/tmp/panic.go:45 +0x22
    main.start(0x1, 0x2, 0x3f99999a, 0x4002666666666666, 0x4c1e6c, 0x4, 0x4c1d84, 0x3, 0x31, 0xc00000c060, ...)
        /root/workspace/tmp/panic.go:39 +0x689
    main.main()
        /root/workspace/tmp/panic.go:24 +0x183

    goroutine 1 [running]:
    runtime/debug.Stack(0x1, 0x0, 0x0)
        /usr/lib/golang/src/runtime/debug/stack.go:24 +0x9d
    runtime/debug.PrintStack()
        /usr/lib/golang/src/runtime/debug/stack.go:16 +0x22
    main.printArray(0x1, 0x2, 0x3, 0xc0000181c0, 0x3, 0x3)
        /root/workspace/tmp/panic.go:50 +0x22
    main.start(0x1, 0x2, 0x3f99999a, 0x4002666666666666, 0x4c1e6c, 0x4, 0x4c1d84, 0x3, 0x31, 0xc00000c060, ...)
        /root/workspace/tmp/panic.go:40 +0x6ce
    main.main()
        /root/workspace/tmp/panic.go:24 +0x183

    goroutine 1 [running]:
    runtime/debug.Stack(0x1, 0x0, 0x0)
        /usr/lib/golang/src/runtime/debug/stack.go:24 +0x9d
    runtime/debug.PrintStack()
        /usr/lib/golang/src/runtime/debug/stack.go:16 +0x22
    main.printObject(0x4c1d84, 0x3, 0x31, 0xc00000c060, 0x49cfc0, 0xc00000c060)
        /root/workspace/tmp/panic.go:55 +0x22
    main.start(0x1, 0x2, 0x3f99999a, 0x4002666666666666, 0x4c1e6c, 0x4, 0x4c1d84, 0x3, 0x31, 0xc00000c060, ...)
        /root/workspace/tmp/panic.go:41 +0x720
    main.main()
        /root/workspace/tmp/panic.go:24 +0x183


# Resources

* [Understanding Go panic output][1]
* [Stack Traces In Go][2]




[1]:    https://www.joeshaw.org/understanding-go-panic-output/
[2]:    https://www.ardanlabs.com/blog/2015/01/stack-traces-in-go.html
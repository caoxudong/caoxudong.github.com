---
title:      Golang并发场景下使用slice
layout:     post
category:   blog
tags:       [golang]
---

>记录一个初学者bug。

在并发场景下，使用slice时，需要时刻谨记，**slice是共用底层数组的**。

    intSlice = intSlice[0:0]
    
这里实际上并没有清空slice，只是重置了位置指针，从而造成数据覆盖，后面继续使用`intSlice`时会覆盖之前的数据。

错误示例代码：

    package main

    import (
        "fmt"
        "sync"
        "time"
        "unsafe"
    )

    // 并发度参数
    var consumerCount = 2
    var producerLogicDuration = 100000 * time.Nanosecond			// 减小该参数可增加获取到重复数字的概率
    var consumerLogicDuration = 100000 * time.Nanosecond

    // 业务参数
    var wgStatic sync.WaitGroup
    var dupMap sync.Map
    var intSlice []int
    var sliceChan chan []int

    func main() {
        sliceChan = make(chan []int, 10)
        for i := 0; i < consumerCount; i++ {
            wgStatic.Add(1)
            go consume(sliceChan, i)
        }

        wgStatic.Add(1)
        go produce()

        wgStatic.Wait()
    }

    func produce() {
        defer wgStatic.Done()
        i := 0
        index := 0
        for {
            intSlice = append(intSlice, i)
            if index > 1 {
                sliceChan <- intSlice
                intSlice = intSlice[0:0]	// wrong
                //intSlice = nil 			// correct
                index = 0
            } else {
                index++
            }
            if i > 1000 {
                break
            }
            i++

            // mock to do some logic
            time.Sleep(producerLogicDuration)
        }
        close(sliceChan)
    }

    func consume(sliceChan chan []int, goroutineID int) {
        defer wgStatic.Done()

        for s := range sliceChan {
            fmt.Printf("rid = %v, s = %v, &array = %v, &s = %p\n", goroutineID, s, unsafe.Pointer(&s[0]), &s)
            for _, num := range s {
                actual, loaded := dupMap.LoadOrStore(num, goroutineID)
                if loaded {
                    errMsg := fmt.Sprintf("key is loaded by goroutine already, key = %v, actual_goroutineID = %v," +
                        " current_goroutineID = %v\n", num, actual, goroutineID)
                    panic(errMsg)
                }
            }

            // mock to do some logic
            time.Sleep(consumerLogicDuration)
        }
    }

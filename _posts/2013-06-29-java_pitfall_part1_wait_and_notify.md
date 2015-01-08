---
title:      Java之坑，part1：wait和notify
category:   blog
layout:     post
tags:       [java]
---


Java之坑，part1：wait和notify
=====================



先上一段死锁的代码。

    package test.java.lang.thread;
    
    import java.util.LinkedList;
    
    public class Stack {
    
        private LinkedList<Integer> list = new LinkedList<>();
    
        public synchronized void push(Integer i) {
            synchronized (list) {
                list.add(i);
                notify();
            }
        }
    
        public synchronized Integer pop() throws InterruptedException {
            synchronized (list) {
                if(list.size() <= 0) {
                    wait();
                }
                return list.removeLast();
            }
        }
    
    }
    

之所以会缠上死锁，关键就在于那多此一举的`synchronized`语句块。原本方法就是同步的，偏偏又加了一个同步语句块，而在这个同步语句块中，锁定的对象却是`list`，这样，调用wait的时候，是不会释放掉对`list`的的锁。因此，`push`方法中也就无法再获得锁。

JavaDoc中对`wait`方法的说明：

> Causes the current thread to wait until either another thread invokes the {@link java.lang.Object#notify()} method or the {@link java.lang.Object#notifyAll()} method for this object, or a specified amount of time has elapsed.
> 
> **The current thread must own this object's monitor.** This method causes the current thread (call it T) to place itself in the wait set for this object and then to relinquish any and all synchronization claims on this object. Thread T becomes disabled for thread scheduling purposes and lies dormant until one of four things happens:
> 
> *   Some other thread invokes the notify method for this object and thread T happens to be arbitrarily chosen as the thread to be awakened. 
> *   Some other thread invokes the notifyAll method for this object. 
> *   Some other thread interrupts thread T. 
> *   The specified amount of real time has elapsed, more or less. If timeout is zero, however, then real time is not taken into consideration and the thread simply waits until notified. 
> 
> **The thread T is then removed from the wait set for this object and re-enabled for thread scheduling.**

另外，再记录一下，`java.lang.Thread`类的`sleep`方法是个静态方法，会让当前线程熟睡。

    package test.java.lang.thread;
    
    public class TestThread {
    
        public static void main(String[] args) throws InterruptedException {
            Thread t = new Thread(new Runnable() {
                public void run() {
                    System.out.println("I'm in secondry thread.");
                    try {
                        synchronized (this) {
                            int i = 1;
                            while (i < 5) {
                                wait(1 * 1000);
                                System.out.println("I'm in secondry thread, slept " + i + " seconds");
                                i++;
                            }
                        }
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            });
            t.start();
            t.sleep(3 * 1000);
            System.out.println("Wake up");
        }
    
    }
    

上面的代码并不能让线程`t`睡5秒，却会让主线程睡5秒。 当然，用IDE开发时(例如eclipse)，会在`t.sleep(3 * 1000);`语句下面提示，

> The static method sleep(long) from the type Thread should be accessed in a static way

可以降低犯傻的几率。

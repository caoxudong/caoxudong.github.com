---
title:      循环计算中看到的小问题
layout:     post
category:   blog
tags:       [java, javascript]
---

原文地址： <http://caoxudong818.iteye.com/blog/1150293>

今天一同事说到java的运行效率是js的10倍。吾深感好奇，差这么多吗？遂写个小程序试一下，程序只是循环加1，但是在运行过程中会有执行时间大大增加的时候出现，无论java或是js都是这样。搞不清究竟是什么原因，请高人指点。 先贴上本机配置。

    Intel(R) Core(TM)2 Quard CPU
    Q8400 @ 2.66GHz
    2.66 GHz , 1.98 GB 的内存。
    
    E:\Workspace\java\test> java -version
    java version "1.6.0_26"
    Java(TM) SE Runtime Environment (build 1.6.0_26-b03)
    Java HotSpot(TM) Client VM (build 20.1-b02, mixed mode, sharing)
    

浏览器使用了chrome12和chrome8的两个版本。 先上代码。

    public class Test {
    
        public static void main(String[] args) {
            int i=0,j=0,k=0;
            long beginTime=0,endTime=0,interval=0 ;
            StringBuilder result = new StringBuilder() ;
            for(i=0;i<1000;i++){
                beginTime = System.currentTimeMillis() ;
                for(j=0;j<1000000;j++){
                    k++ ;
                }
                endTime = System.currentTimeMillis() ;
                interval = endTime - beginTime ;
                result.append("cost ") ;
                result.append(interval) ;
                result.append(" milliseconds") ;
                System.out.println(result.toString()) ;
                result.delete(0,result.length()) ;
            }
    
        }
    }
    

然后是执行结果，先是java的：

    cost 0 milliseconds
    cost 0 milliseconds
    cost 16 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 15 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 16 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    

js的执行结果： chrome12的执行结果

    cost 14 milliseconds
    cost 14 milliseconds
    cost 14 milliseconds
    cost 10 milliseconds
    cost 4 milliseconds
    cost 3 milliseconds
    cost 3 milliseconds
    cost 4 milliseconds
    cost 4 milliseconds
    cost 3 milliseconds
    cost 4 milliseconds
    cost 3 milliseconds
    cost 3 milliseconds
    cost 4 milliseconds
    

chrome8的执行结果

    cost 15 milliseconds
    cost 15 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 16 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 15 milliseconds
    cost 16 milliseconds
    cost 0 milliseconds
    cost 15 milliseconds
    cost 0 milliseconds
    cost 16 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    cost 0 milliseconds
    

问题：为什么java和chrome8在运行过程中会有计算时间突然加长的时候？ 坐等高人。

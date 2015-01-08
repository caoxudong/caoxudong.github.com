---
title:      KMP算法的实现 
category:   blog
layout:     post
tags:       [algorithm, java, kmp]
---


转载：KMP算法的实现 
=============


原文地址: <http://caoxudong818.iteye.com/blog/1218109>

用Java实现KMP算法，并与String.indexOf方法做比较。

    public static int kmp1(String pattern,  String src){
        int srcLength = src.length() ;
        int patternLength = pattern.length() ;
        int index = -1 ;
        int count = 0 ;
        for(int i = 0 ; i < srcLength - 1 ; i++){
            count = 0 ;
            for(int j = 0 ; (j < patternLength ) && (i < srcLength) ; i++){
                if(src.charAt(i) == pattern.charAt(j)){
                    count++ ;
                    i++ ;
                }else{
                    break ;
                }
            }
            if(count == patternLength){
                return i - count ;
            }
            if(count == 0){
                i++ ;
            }
        }
        return index ;
    }
    

测试程序如下：

    public static void main(String[] args){
        String src = "1234567890abcdefghijk" ;
        String pattern = "abcd" ;
        long beginTime = System.nanoTime() ;
        int index = kmp1(pattern, src) ;
        System.out.println("My KMP : index = " + index + " and time = " + (System.nanoTime() - beginTime) + "ns");
        beginTime = System.nanoTime() ;
        index = src.indexOf(pattern) ;
        System.out.println("String.indexOf : index = " + index + " and time = " + (System.nanoTime() - beginTime) + "ns");
    }
    

结果很悲剧，输出如下

    My KMP : index = 10 and time = 58012 ns
    String.indexOf : index = 10 and time = 9895 ns
    

对代码进行修改，发现方法kmp1在内层循环中对条件判断的使用有些费操作，遂修改如下：

    public static int kmp2(String pattern,  String src){
        int srcLength = src.length() ;
        int patternLength = pattern.length() ;
        int index = -1 ;
        int count = 0 ;
        for(int i = 0 ; i < srcLength - 1 ; i++){
            count = 0 ;
            for(int j = 0 ; (j < patternLength ) && (i < srcLength) && (src.charAt(i) == pattern.charAt(j)); j++,i++,count++) ;
            if(count == patternLength){
                return i - count ;
            }
            if(count == 0){
                i++ ;
            }
        }
        return index ;
    }
    

执行后发现没什么效果，输出如下：

    My KMP : index = 10 and time = 57070 ns
    String.indexOf : index = 10 and time = 9961 ns
    

再将字符串改为对字符数组的操作

    public static int kmp3(char[] patternArray , char[] srcArray){
        int index = -1 ;
        int count = 0 ;
        for(int i = 0 ; i < srcArray.length - 1 ; i++){
            count = 0 ;
            for(int j = 0 ; (j < patternArray.length ) && (i < srcArray.length) && (srcArray[i] == patternArray[j]); j++,i++,count++) ;
            if(count == patternArray.length){
                return i - count ;
            }
            if(count == 0){
                i++ ;
            }
        }
        return index ;
    }
    

效果依然不好：

    My KMP : index = 10 and time = 55805 ns
    String.indexOf : index = 10 and time = 10277 ns
    

各位看官，给点提醒吧，还可以从哪里优化吗？还是说，我写的KMP本身就有问题？

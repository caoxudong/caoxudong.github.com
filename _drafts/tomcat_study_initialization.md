---
title:      Tomcat初始化
layout:     post
category:   blog
tags:       [tomcat, java]
---

1. org.apache.catalina.startup.BootStrap
    1. 初始化`catalina.home` 
        * 获取参数`catalina.home`，判断相应目录是否存在，若不存在则
        * 查看当前工作目录是否存在bootstrap.jar文件，若存在，则以父目录作为`catalina.home`的值，否则
        * 使用当前目录作为`catalina.home`的值
    1. 初始化`catalina.base`
        * 获取参数`catalina.base`，若值不为空，则根据其值设置相应的变量，否则
        * 设置为`catalina.home`的值

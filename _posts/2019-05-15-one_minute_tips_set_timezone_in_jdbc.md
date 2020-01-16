---
title:      JDBC中设置时区
layout:     post
category:   blog
tags:       [java, database, jdbc, one-minute-tips]
---

偶然发现，数据库中写入的时间(`DATETIME`类型)与程序中打印的时间相差14个小时，初步判断是时区的问题。

解决方案是修改jdbc连接，添加参数`serverTimezone=Asia/Shanghai`。例如:

    jdbc:mysql://127.0.0.1:3306/test?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=Asia/Shanghai
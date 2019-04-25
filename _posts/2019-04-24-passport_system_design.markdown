---
title:      一种支持多端、多角色的用户体系设计
layout:     post
category:   blog
tags:       [design, passport, oauth, authorization]
---

要支持的功能：

* 一个现实中的用户在整个系统中可以同时拥有多种角色
* 一个现实中的用户在整个系统中可以同时拥有同一角色下的多个账号
* 整个系统支持多种客户端，例如native app/web browser/微信小程序等
* 每种客户端只能登陆一种角色
* 同一角色可以同时登陆该角色所对应的多种客户端
* 多种登录方式： 手机号/邮件/微信等
* 一个现实中的用户可以绑定多种登录方式
* 一个现实中的用户在一种客户端只能存在一个登录凭证
* 支持对某个用户/某种客户端/用户的某个客户端/某种角色进行封禁，禁止其登录

系统设计：

* 设定账号-登录方式的关联关系: oauths表
* 设定账号-角色账号的关联关系: roleX_users表
* 设定access-token和refresh-token关联关系: oauth_access_tokens表和oauth_refresh_tokens表

数据表设计：

* passports
* roleA_users
* roleB_users
* oauths
* oauth_client_types
* oauth_access_tokens
* oauth_refresh_tokens
* oauth_wechat_users

![表设计][1]




[1]:    /image/passport_system_design_tables.jpg
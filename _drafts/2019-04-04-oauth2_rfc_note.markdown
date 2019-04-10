---
title:      《The OAuth 2.0 Authorization Framework》笔记
layout:     post
category:   blog
tags:       [note, security, http, oauth]
---

>《The OAuth 2.0 Authorization Framework》，https://tools.ietf.org/html/rfc6749

# 1.  Introduction

## 1.1  4种角色

* **resource owner**: 资源所有者，可以授权其他应用访问受保护的资源。一般指终端用户。
* **resource server**: 资源服务器，存储受保护资源的服务器。可以响应带有 **访问标识(access token)**的资源访问请求。
* **client**: 客户端，能够以资源所有者身份发出访问受保护资源的请求。
* **authorization server**: 授权服务器，在验证资源所有者身份后，可以为客户端颁发 **访问标识(access token)**。

## 1.2  协议流

    +--------+                               +---------------+
    |        |--(A)- Authorization Request ->|   Resource    |
    |        |                               |     Owner     |
    |        |<-(B)-- Authorization Grant ---|               |
    |        |                               +---------------+
    |        |
    |        |                               +---------------+
    |        |--(C)-- Authorization Grant -->| Authorization |
    | Client |                               |     Server    |
    |        |<-(D)----- Access Token -------|               |
    |        |                               +---------------+
    |        |
    |        |                               +---------------+
    |        |--(E)----- Access Token ------>|    Resource   |
    |        |                               |     Server    |
    |        |<-(F)--- Protected Resource ---|               |
    +--------+                               +---------------+

## 1.3  4种授权类型

### 1.3.1  authorization code

**authorization server**介于 **client**和 **resource owner**之间。 **client**先将 **resource owner**导向 **authorization server**完成身份认证，完成认证后，再带着 **authorization code**返回 **client**。

例如第三方登录授权。

### 1.3.2  implicit

流程与 **authorization code**类似，区别在于 **authorization code**是由 **client**自己生成的，例如在浏览器中使用JS直接生一个 **access token**。

这种方式节省了往返 **authorization server**请求，但会产生一些安全隐患，使用的时候需要小心权衡。



### 1.3.3.  resource owner password credentials

直接使用 **resource owner**的密码。

这种方式只应该用在 **resource owner**和 **client**高度互信的场景下，例如 **client**是设备系统的一部分，或者是一个高权限应用的一部分。

例如ATM。

### 1.3.4.  client credentials

当 **client**本身就是 **resource owner**时，或要访问的资源是 **authorization server**已经安排过了。

## 1.4.  access token

**access token**是访问受限资源的证书，由 **resource owner**颁发，由 **resource server**和 **authorization server**强制执行。
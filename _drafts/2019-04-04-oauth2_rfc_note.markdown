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

## 1.5.  refresh token

**refresh token**用于更新 **access token**。整体流程如下：

    +--------+                                           +---------------+
    |        |--(A)------- Authorization Grant --------->|               |
    |        |                                           |               |
    |        |<-(B)----------- Access Token -------------|               |
    |        |               & Refresh Token             |               |
    |        |                                           |               |
    |        |                            +----------+   |               |
    |        |--(C)---- Access Token ---->|          |   |               |
    |        |                            |          |   |               |
    |        |<-(D)- Protected Resource --| Resource |   | Authorization |
    | Client |                            |  Server  |   |     Server    |
    |        |--(E)---- Access Token ---->|          |   |               |
    |        |                            |          |   |               |
    |        |<-(F)- Invalid Token Error -|          |   |               |
    |        |                            +----------+   |               |
    |        |                                           |               |
    |        |--(G)----------- Refresh Token ----------->|               |
    |        |                                           |               |
    |        |<-(H)----------- Access Token -------------|               |
    +--------+           & Optional Refresh Token        +---------------+

## 1.6.  TLS version

截止到本文(指RFC)撰写时，最新的TLS版本是[1.2][1]，不过还在开发阶段。现在广泛使用的是[1.0][2]版本的TLS。

为满足特定安全需求，Oauth2的实现者可以自行添加安全传输层。

## 1.7.  HTTP redirections

本规范中广泛使用了HTTP重定向，**client**或 **authorization server**会将 **resource owner**重定向到其他地址。本规范所使用的例子中，通过HTTP状态码302实现重定向，实现者也可以通过其他方式实现重定向。

## 1.8.  interoperability

作为一套授权框架，Oauth 2.0提供了很多安全属性，并具有高扩展性，包含了一些可选组件，因此会产生一些不具互操作性(non-interoperability)的实现。

此外，Oauth 2.0规范并未完全定义所有组件，实现者可以自行选择实现方案。

## 1.9.  notational conventions

略

# 2.  client registration

该规范并未定义client如何在authorization server注册。

在注册client时，client开发者 **应该(SHALL)**

1. 指定 **client type**
1. 指定 **client redirection uri**
1. 提供authorization server所需的其他信息

## 2.1.  client type

* **confidential**: client可以自行保存证书信息
* **push**: client不能自行保存证书信息

**client type** 的设置取决于authorization server对安全认证的定义，以及client证书的安全等级。authorization server **不应该(SHOULD NOT)** 对client type做假设，应该按照自身安全业务特点来处理。

对于某些应用来说，client可能是一系列分布式组件，每个组件可能有不同的 **client type**。如果authorization server对此无法支持，则每个组件 **应该(SHOULD)**注册为单独的client。

以下是该规范定义的几种client场景:

* **web application**: 该场景下，client是运行在web server的可信应用，resource owner通过自己设备中应用来访问应用界面。client证书存储在web server中，resource owner无法访问到。
* **user-agent-based appplication**: 该场景下，client是开放的，可公开访问的，例如web browser。resource owner可以通过client访问到数据和证书。
* **native application**: 该场景下，应用程序是一个开放客户端，安装在用户设备上。resource owner可以通过client访问到数据和证书，client可以在一定程度上保证access token和refresh token的安全性。

## 2.2.  client identifier

authorization server为注册的client颁发一个唯一的client标识，这个标识不必保密，可被resource owner获取到，但是 **禁止(MUST NOT)**用于client authorization。

## 2.3.  client authorization

如果client type是 **confidential**，则需要在client和authorization server之间建立一种认证方法。此时，client可能会提供一系列认证方法，例如密码和公私钥。

authorization server **可以(MAY)**和 **public**类型的client建立认证方法，但是 **禁止(MUST NOT)**依靠公开的client authorization来识别client。

每次发送请求时，client **禁止(MUST NOT)**使用多种认证方法。

### 2.3.1  client password

client **可以(MAY)**使用[HTML Basic Authorization][3]来完成身份校验。client identifier以[`application/x-www-form-urlencoded`][4]方法进行编码，编码的结果作为用户名使用；client password以[`application/x-www-form-urlencoded`][4]方法进行编码，编码的结果作为密码使用。


和client password分别作为 **username**和 **password**，以`application/x-www-form-urlencoded`的形式提交给authorization server。authorization server **必须(MUST)**对这种方式提供支持。

示例:

    Authorization: Basic czZCaGRSa3F0Mzo3RmpmcDBaQnIxS3REUmJuZlZkbUl3

此外，authorization server **可以(MAY)**支持在请求体中提交client证书:

* `client_id`: **必需(REQUIRED)**，在client registration注册时获取到的client identifier。
* `client_secret`: **必需(REQUIRED)**，client密钥，如果为空的话，client **可以(MAY)**忽略掉该参数。

在请求体中提交client证书这种方式 **不建议(NOT RECOMMENDED)**，而且 **应该(SHOULD)**仅用于无法直接使用HTTP Basic Authentication(或其他基于密码的认证方式)的场景下。密码只能在请求体中发送，**禁止(MUST NOT)**放在请求地址中。

例如，以请求体的方式更新access token时:

    POST /token HTTP/1.1
    Host: server.example.com
    Content-Type: application/x-www-form-urlencoded

    grant_type=refresh_token&refresh_token=tGzv3JOkF0XG5Qx2TlKWIA
    &client_id=s6BhdRkqt3&client_secret=7Fjfp0ZBr1KtDRbnfVdmIw

在使用密码认证来校验client时，authorization server **必须(MUST)**通过TLS来处理请求。

由于client认证方法涉及到密码，authorization server **必须(MUST)**保证不会被暴力破解。

### 2.3.2.  Other Authentication Methods

authorization server **可以(MAY)**根据自身安全需求支持其他认证方法。在使用其他认证方法时，authorization server **必须(MUST)**定义client identifier和校验方式的映射关系。

## 2.4.  Unregistered Clients

该规范并未对client的取消注册做出规定。

# 3.  Protocol Endpoints










[1]:    https://tools.ietf.org/html/rfc5246
[2]:    https://tools.ietf.org/html/rfc2246
[3]:    https://tools.ietf.org/html/rfc2617
[4]:    https://tools.ietf.org/html/rfc6749#appendix-B
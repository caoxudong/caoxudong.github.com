---
title:      再谈网站应用中无状态系统身份认证设计
layout:     post
category:   blog
tags:       [web, authentication, cookie, security]
---

>在之前的一篇[文章][1]中，简单谈了一下基于token的身份校验。不够完整，还有一些错误的地方，这里再谈谈。

# 1 移动端的token

从实际场景看，很多时候，移动端对后端服务器的访问不是从内嵌浏览器中发出的，而是在代码中直接发出一个HTTP请求。对于某些APP来说，可能使用很久才会请求一次服务器。这时再采用Cookie来存储token就不太合适了。服务器可以直接在响应结果中返回token，客户端将token存储在本地，将来发送请求时再带上。没有Cookie也就可以避免CSRF攻击了，但客户端同样需要小心保存token。

# 2 token的生成

使用[JWT（JSON Web Token）][2]，在token中附带上[相关信息][4]，使token自身具有了时效性和指向性。

* 时效性：JWT中包含了当前token的失效时间和起效时间，应用服务器可以根据相应的时间来判断该token是否有效
* 指向性：JWT中包含了当前token的颁发者和审计信息，应用服务器可以根据相应的信息来判断当前token与当前用户是否相匹配











# 参考文档







[1]:    /blog/2015/03/05/stateless_web_system_authentication_design
[2]:    http://jwt.io/
[3]:    http://tools.ietf.org/html/rfc7519
[4]:    http://tools.ietf.org/html/rfc7519#section-4
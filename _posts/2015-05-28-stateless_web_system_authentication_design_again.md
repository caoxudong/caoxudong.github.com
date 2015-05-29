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

使用[JWT（JSON Web Token）][2]，在token中附带上[相关信息][3]，使token自身具有了时效性、指向性和保密性。

* 时效性：JWT中包含了当前token的失效时间和起效时间，应用服务器可以根据相应的时间来判断该token是否有效
* 指向性：JWT中包含了当前token的颁发者和审计信息，应用服务器可以根据相应的信息来判断当前token与当前用户是否相匹配
* 保密性：JWT中包含了签名字段，该字段是由服务器加密生成的（对称或非对称皆可），应用服务器可以校验该签名来判断当前token是否是伪造的

>当然，仅靠token自身数据是不足以保证安全性的，还需要后端服务器的配合才行。后端服务器需要判断该token是否已经被废弃掉了。

# 3 token安全性

由于客户端通过token来标明自身身份，对于服务器来说，就相当于客户端的密码。服务器端在存储该token时，也需要认真对待。

* 不可直接存储该token，应对token做散列处理（例如使用Bcrypt做散列）
* 服务器需要将接收到token和自己的保存的token作比较，防止用户使用已废弃但还未过期的token

# 4 其他

上面所说的token并不支持用户在多个设备上同时登陆，即每个用户只能有一个token。当用户需要同时在多个设备上保持登陆状态时，就需要针对不同的设备生成不同的token。由于移动设备的IP经常换，因此就需要使用一些其他可以标识设备的属性来确定token的唯一性。









# 参考文档

1. [Token Based Authentication for Single Page Apps (SPAs)][4]






[1]:    /blog/2015/03/05/stateless_web_system_authentication_design
[2]:    http://jwt.io/
[3]:    http://tools.ietf.org/html/rfc7519#section-4
[4]:    https://stormpath.com/blog/token-auth-spa/
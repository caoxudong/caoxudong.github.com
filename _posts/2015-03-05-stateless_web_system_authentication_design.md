---
title:      网站应用中无状态系统身份认证设计
layout:     post
category:   blog
tags:       [web, authentication, cookie, security]
---

# 1 无状态

[HTTP协议][3]本身是[无状态的][2]、响应式的，而应用规范（如[servlet规范][1]）则在其中添加了会话跟踪机制（如session）来保存用户状态。

网站规模不断增大，使用负载均衡在所难免，而这给后端服务器保存用户状态带来了不小的麻烦。一般来说，后端服务器在保存session时，会有3种方案：

1. 粘滞session： 通过某些规则，将某个用户的所有请求都固定到某台服务器，这样，用户的session信息就只会存在于其对应的某台服务器上。
2. session复制： 将应用服务器连接起来，若某个用户修改器session信息，则目标服务器会改session广播到所有的应用服务器中，做同步修改。这样，任何一台应用服务器就都可以处理用户请求了。
3. session共享： 设置一个第三方的session服务器（集群）来存储用户session信息，应用服务器自身不再存储session信息。每次使用session信息时，都是从session服务器来存取的。

上面的3种方案，都可以在实现在负载均衡环境下使用session，但却都有一些问题，不利于整个系统的水平扩展，可用性也不甚理想：

1. 方案1中，若是目标服务器宕机，则会造成用户无法访问。此时，若将该用户的请求路由到其他服务器，而其他服务器上并没有该用户的session信息，导致用户重新登陆。而当原服务器恢复后，若是将用户再定向到原服务器，则用户还得登陆一次，若不重定向用户请求，则可能会造成各个服务器之前忙闲不均。
2. 方案2中，随着用户量和服务器数量不断增长，各个服务器之间传递session数据所带来的网络消耗也不断增长，增加系统延时。
3. 方案3中，若是使用单一的第三方服务器，则会产生单点问题，若是使用集群，则又需要花费力气去维护集群。

考虑到上面的方案及其缺陷，越来越多的系统采用了无状态设计，即不在后端服务器中维护用户状态，用户的各个请求之间不再有相互依赖，并且在每个请求中都包含完整的验证信息，后端服务器在接收到请求后，再对用户身份进行验证，若验证通过则可以执行请求。使用无状态设计，后端服务器的角色完全一致，具有较高的扩展性，直接添加新的服务器就行。

# 2 身份验证

## 2.1 有状态系统的身份验证

普通情况下的身份验证是，用户提供用户名和密码，后端服务器进行验证，若成功，则会在该用户的session中记录相关信息，例如将当前登陆用户的对象信息记录在session，以便完成该用户后续的请求。

由于用户后续的请求需要依赖于这个登陆操作，因此说这个是有状态的。正如前面所说，有状态的系统在扩展性和可用性上有些问题，因此要修改为无状态的。

## 2.2 无状态系统的身份验证

### 2.2.1 基本方案

无状态系统中，需要对用户的每个请求做身份验证。让用户在每个请求前都输一遍用户名密码肯定是不行的，用户会骂娘的，因此需要在客户端记录一些身份验证信息，用户提交请求时，将这些身份验证信息提交到服务器，完成身份验证。

[cookie][5]可以完成客户端存储的功能，可以在其中存储身份验证信息，当用户提交请求时，这些信息会随请求一起发送给服务器，从而完成身份验证，当然，不能在cookie中直接存储用户的明文密码，实在太凶残。换个思路，在用户通过用户名密码登录后，由应用服务器为用户生成一个"密码"，并发回给用户，那么下一次用户就可以使用用户名和这个临时"密码"来访问网站的。

具体来说，就是在用户登录后，应用服务器根据用户信息生成一个auth_token，将之以cookie的形式"发回"给用户。用户再次发送请求时，会将这个auth_token带回给服务器。服务器通过userId查找到用户信息，再对比auth_token是否相同，来判断用户身份是否认证通过。这时，如果auth_token不匹配，则说明可能有人试图破解该用户的账户信息，需要提出警告。

一般来说，用户是可以在不同设备（浏览器）上同时登陆的，因此单纯使用一个auth_token就无法满足业务需要了。当用户在某个设备登陆时，就需要为之单独生成一个auth_token，最终形成一个用户对应多个auth_token的情况。

### 2.2.2 安全方面的考虑

auth_token在某种程度上代替了密码的功能，因此就需要非常注意auth_token的安全性。

1. 尽量使用安全连接（例如HTTPS）来传输数据。
2. 将token可ip绑定
3. 若是使用cookie存储各类信息，需要小心设置cookie的属性，包括expire，httponly，secure，domain和path，最小化访问权限。
4. 服务器端存储auth_token时，切不可存储明文，应该加密存储，否则一旦应用服务器被攻破，很有可能会威胁到所有用户的账户安全。
5. 由于各类token只是一个标记，可以任意复制，因此最好能够将之与用户IP（最好是MAC地址，不过太不方便）绑定。
6. token最好能够表达时序语义（参考[github中token][8]的设计），以便确认前后两次访问是否是连续的，例如将上次访问时间进行编码作为token。
7. 在访问/修改关键信息（例如查看/修改银行账户信息，修改电子邮件/手机信息等）时，必需通过用户名密码进行身份校验。

auth_token是如此重要，因此为了提升其安全性，可以在用户每次发送请求后，都为用户换一个新的auth_token，下次用户提交请求时，就应该使用新的auth_token了。但换了auth_token后该如何辨别用户是来自哪个设备（浏览器）呢？针对这种情况，可以在客户端设置一个临时性的、不会持久化的标记session_token，这个标记会在用户登录时设置，并在关闭设备（浏览器）时被客户端清除掉。用户发送请求时，需要将userId, auth_token, session_token一起带回，服务器根据这三个信息来验证用户身份。

当用户关闭浏览器后，客户端session_token失效，用户再次打开浏览器访问时，带回auth_token和userId，再对比ip，若匹配则重新生成新的session_token给用户，同时使原来的session_token失效。

### 2.2.3 场景模拟

>现在来看用户cookie被盗的情况。这里假设使用了安全连接，网站自身没有XSS或CSRF漏洞，而且用户的密码并没有丢失。

#### 2.2.3.1 IP不同

这个好办，IP不同，未经过重新登录，但又拿着之前用过的token的请求，都重定向到登陆页面。

#### 2.2.3.2 IP相同

若用户的所有cookie都被盗了，而且hacker与用户的对外IP相同，这时，hacker可以查看相关信息，但根据前面的设定，对于敏感信息是不能查看修改的。此时，若用户继续使用网站，会带回之前已经用过token。这时就无法确认到底谁才是真正的用户，因此只好将相关的token都清楚，强制重新登录，并通知用户账户有风险。

当然，这种方式并不能阻止hacker再次盗取cookie。

其他的办法，后续再想想。



# 参考文档

1. [HTTP][3]
2. [stateless protocol][2]
3. [Representational state transfer][4]
4. [serlvet3 specification][1]
5. [Hacking Github with Webkit][6]
6. [你会做Web上的用户登录功能吗？][7]






[1]:    https://jcp.org/en/jsr/detail?id=315
[2]:    https://en.wikipedia.org/wiki/Stateless_protocol
[3]:    https://www.ietf.org/rfc/rfc2616.txt
[4]:    https://en.wikipedia.org/wiki/Representational_state_transfer
[5]:    https://en.wikipedia.org/wiki/HTTP_cookie
[6]:    https://homakov.blogspot.com/2013/03/hacking-github-with-webkit.html
[7]:    https://coolshell.cn/articles/5353.html
[8]:    https://github.com
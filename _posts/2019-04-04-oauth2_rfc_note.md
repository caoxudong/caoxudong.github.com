---
title:      《The OAuth 2.0 Authorization Framework》笔记
layout:     post
category:   blog
tags:       [note, security, http, oauth, RFC]
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

<a name="seciton-2.2"></a>
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

2种authorization server的endpoint:

* authorization endpoint: client用于从resource owner处获取授权
* token endpoint: client用授权换取获取access token

1种client的endpoint:

* redirect endpoint: authorization server返回的响应，包含了授权凭证

并非每种grant type都要使用2类endpoint。扩展grant type **可以(MAY)**定义额外的endpoint。

## 3.1.  authorization endpoint

authorization endpoint用于与resource owner交互，获取授权。authorization server **必须(MUST)**首先校验resource owner的身份。规范中没有定义具体的校验方法。

规范中没有定义client获取authorization endpoint的方法。

authorization endpoint的URI **可以(MAY)**包含`application/x-www-form-urlencoded`格式的查询部件(**query component**)，如果添加了额外的查询字符串时，则 **必须(MUST)**保留这个查询部件。

发给authorization endpoint的请求会返回用户证书，因此 **必须(MUST)**使用TLS加以保护。

authorization server **必须(MUST)**支持HTTP`GET`方法来请求authorization endpoint，同时 **可以(MAY)**支持HTTP`POST`方法。

若发送的请求参数没有值，则authorization server **必须(MUST)**忽略该参数，此外authorization server **必须(MUST)**忽略请求中无法识别的参数。最后，请求和响应中的参数 **禁止(MUST)**出现多次。

### 3.1.1.  response type

authorization endpoint一般用于`authorization code`和`implicit`授权类型。client使用参数`response_type`通知authorization server具体的授权类型:

* `response_type`
    * **必要(REQUIRED)**
    * 参数值 **必须(MUST)**是 `code` `token`或其他已注册的扩展值。
        * `code`: 表示authorization code
        * `token`: 表示access token，即implicit授权类型
        * 已注册的扩展值: 即自定义的authorization endpoint

扩展值的`response_type` **可以(MAY)**包含一个以空格`%x20`分隔列表，其中内容的含义由具体实现者定义，列表的顺序无关紧要。

若授权请求中没有`response_type`参数，或者`response_type`值无法识别，则authorization server **必须(MUST)**返回错误信息。

### 3.1.2. redirection endpoint

在完成与resource owner的交互之后，authorization server会将resource owner的user-agent重定向回client。

redirection endpoint URI中 **必须(MUST)**是一个完整URI，其中 **可以(MAY)**一个`application/x-www-form-urlencoded`格式的查询部件，若是添加了额外的查询字符串，则 **必须(MUST)**保留该部件。redirection endpoint URI中 **禁止(MUST NOT)**包含碎片部件。

#### 3.1.2.1  endpoint request confidentially

当response type是`code` `token`或其他会通过开发网络返回敏感证书信息的值时，redirection endpoint **应该(SHOULD)**使用TLS。该规范并未强制使用TLS，因为在编写该规范时，对于大部分client开发者来说，部署TLS有较高的成本。如果无法使用TLS，则在重定向之前，authorization server **应该(SHOULD)**警告resource owner目前正在使用不安全的endpoint。

缺少TLS，会给client和resource带来巨大的安全隐患。

#### 3.1.2.2.  registration requirement

authorization server **必须(MUST)**要求以下client注册其redirection endpoint:

* **public clients**
* 使用 **implicit**授权类型的、受信任的clients

authorization server **应该(SHOULD)**要求所有client在使用authorization endpoint前，都先行注册其redirection endpoint。

authorization server **应该(SHOULD)**要求所有client提供其完整的重定向URI(client **可以**使用`state`请求参数来实现请求定制化)。若无法提供完整的重定向URI，则authorization server **应该(SHOULD)**指定URI格式(**URI scheme**)、授权(**authority**)和路径(**path**)，使client可以根据查询部件的内容动态生成不同的地址。

authorization server **可以(MAY)**允许client注册多个redirection endpoint。

若不要求client注册redirection URI，则攻击者可以将authorization endpoint作为一个开放的重定向转接器，参见[Open Redirectors][5]。

#### 3.1.2.3.  dynamic configuration

若client注册了多个redirection URI，或者只注册了部分redirection URI，或者没有注册redirection URI，则client **必须(MUST)**在请求参数中添加参数`redirect_uri`，在其中指定redirection URI。

若请求参数中指定了redirection URI，则authorization server **必须(MUST)**将参数中指定的redirection URI与至少一个已注册的redirection URI作比较（若是没有注册，则不用比较），参见[][]。若是client registration包含了完整的重定向URI，则authorization server **必须(MUST)**使用字符串比较法来比较两个URI，参见[][]。

#### 3.1.2.4.  invalid endpoint

若授权请求因缺少、无效或不匹配重定向URI而失败，则authorization server **应该(SHOULD)**通知resource owner错误信息，并且 **禁止(MUST NOT)**将user-agent自动重定向到无效的redirection URI。

#### 3.1.2.5.  endpoint content

一般情况下，针对client endpoint的重定向请求会收到一个HTML文档响应，这个响应会有user-agent处理。若HTML响应是重定向请求的直接结果，则HTML文档中的脚本代码将能够访问到其中包含的重定向URI和证书信息。

client **不应该(SHOULD NOT)**在redirection endpoint响应中包含任何第三方脚本(例如分析插件、社交插件等)。相反，client **应该(SHOULD)**从URI中抽取出证书信息，并再次将user-agent重定向到另一个不会暴露证书信息的endpoint。若包含了第三方插件，则client **必须(MUST)**确保优先执行自己的脚本代码。

## 3.2.  token endpoint

client使用token point来获取access token，该access token可以表征client的授权认证和refresh token。除了 **implicit**之外，token endpoint可用于其他所有的授权类型。

token endpoint URI中 **可以(MAY)**包含一个`application/x-www-form-urlencoded`格式的查询部件，若添加了额外的查询参数，则 **必须(MUST)**保留该查询部件。token endpoint URI **禁止(MUST NOT)**包含碎片部件。

由于对token endpoint的请求会返回证书信息，因此authorization server **必须(MUST)**要求使用TLS。

client **必须(MUST)**使用HTTP`POST`方法来请求access token。

若请求参数没有值，则authorization server **必须(MUST)**忽略该参数。此外，authorization server **必须(MUST)**忽略无法识别的参数。最后，请求和响应中的参数 **禁止(MUST NOT)**出现多次。

### 3.2.1.  client authentication

机密client或其他颁发了证书的client，在请求token endpoint时，authorization server **必须(MUST)**对client身份进行校验(authentication)。client身份校验的作用包括:

* 绑定refresh token和发给client的授权码。client校验很重要，尤其是在非安全网络场景下，或者redirection URI没有完全注册的场景下。
* 恢复一个受连累的client(可能是被禁用或更新了证书)，这样可以避免攻击者滥用盗取的refresh token。更新单个client证书会比更新所有证书快得多。
* 实现校验管理的最佳实践，周期性更新证书。更新所有refresh token会是个挑战，但更新单个refresh token会简单得多。

client在请求token endpoint时， **可以(MAY)** 通过请求参数`request_id`来标识自己。在以 **authentication code**这种授权类型请求token endpoint时，未校验的client **必须(MUST)**发送参数`request_id`，以避免不同的client之间误用authentication code。注意，这并不能提升受保护资源的安全性。

## 3.3.  access token scope

authorization endpoint和token endpoint允许client通过请求参数`scope`来指定访问请求的范围。相对的，authorization server通过响应参数`scope`来通知client所颁发的access token的适用范围。

参数`scope`的值是一个以空格分隔的、区分大小写的字符串列表，字符串的内容由authorization server定义，字符串列的顺序无关紧要。其中每个字符串添加了一个额外的访问范围。

    scope       = scope-token *( SP scope-token )
    scope-token = 1*( %x21 / %x23-5B / %x5D-7E )

根据authorization server策略或resource owner的指令，authorization server **可以(MAY)**全部或部分的忽略由client在请求中指定的`scope`。若authorization server颁发的access token的访问范围与client请求的访问范围不同，则authorization server **必须(MUST)**在响应中添加参数`scope`参数来明确告知client实际的访问范围。

若cleint在请求中没有指定`scope`参数，则authorization server **必须(MUST)**以预定义的默认值或者按照无效`scope`值来处理请求。authorization server **应该(SHOULD)**在文档中明确给出可用的`scope`值。

# 4.  obtaining authorization

为了获取access token，client需要从resource owner处获取授权。授权与client请求access token时的授权类型相关。Oauth定义了4中授权类型，**authorization code** **implict** **resource owner password confidential**和 **client confidential**，此外还定义了扩展机制以便自定义授权类型。

## 4.1.  authorization code grant

**authorization code**这种授权类型用于获取access token和refresh token，并且对受信任的client做了优化。由于这种授权类型基于重定向，因此client必须能够与resource owner的user-agent进行交互，并且能够接收来自authorization server的请求(源自重定向)。

    +----------+
    | Resource |
    |   Owner  |
    |          |
    +----------+
         ^
         |
        (B)
    +----|-----+          Client Identifier      +---------------+
    |         -+----(A)-- & Redirection URI ---->|               |
    |  User-   |                                 | Authorization |
    |  Agent  -+----(B)-- User authenticates --->|     Server    |
    |          |                                 |               |
    |         -+----(C)-- Authorization Code ---<|               |
    +-|----|---+                                 +---------------+
      |    |                                         ^      v
     (A)  (C)                                        |      |
      |    |                                         |      |
      ^    v                                         |      |
    +---------+                                      |      |
    |         |>---(D)-- Authorization Code ---------'      |
    |  Client |          & Redirection URI                  |
    |         |                                             |
    |         |<---(E)----- Access Token -------------------'
    +---------+       (w/ Optional Refresh Token)


在上图中，由于需要经过user-agent中转，步骤A/B/C被分为了2部分。

### 4.1.1.  authorization request

client在构造请求authorization endpoint URI时，以`application/x-www-form-urlencoded`格式在查询部件中添加参数，参见[附录B][4]。

* `response_type`
    * **REQUIRED**
    * 参数值 **必须(MUST)**是`code`
* `client_id`
    * **REQUIRED**
    * client标识，参见[2.2节][8]
* `redirect_uri`
    * **OPTIONAL**
    * 参见[3.1.2节][9]
* `scope`
    * **OPTIONAL**
    * 参见[3.3节][10]
* `state`
    * **RECOMMENDED**
    * 透传值，client用来维护其在请求/回调间的状态。authorization serve在重定向会client时会附带该参数值。该参数 **应该(SHOULD)**用于防止CSRF攻击，参见[10.12节][11]
    
client通过重定向将resource owner导向构造好的URI。例如，client借助TLS，以HTTP请求的方式，通过user-agent将resource owner导向authorization endpoint:

    GET /authorize?response_type=code&client_id=s6BhdRkqt3&state=xyz
        &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb HTTP/1.1
    Host: server.example.com

authorization server校验请求参数，确保所有必要参数存在且有效。参数校验通过后，authorization server会校验resource owner身份，根据resource owner的要求完成授权。

完成授权后，authorization server以HTTP重定向的方式，将user-agent导向client提供的redirection URI。

### 4.1.2.  authorization response

若resource owner授权了访问请求，则authorization server会生成一个authorization code，并发送给client。在发送authorization code给client时，会以`application/x-www-form-urlencoded`格式在查询部件中添加以下参数:

* `code`
    * **REQUIRED**
    * authorization code由authorization server生成，并且在颁发之后， **必须(MUST)**仅维持较短的声明周期，防止外泄。**建议(RECOMMENDED)**最大生命周期为10min。client **禁止(MUST NOT)**重复使用同一个authorization code。若client重复使用authorization code，则authorization server **必须(MUST)**拒绝该请求，并 **应该(SHOULD)**撤销基于该authorization code颁发的所有token。authorization code与client id和redirection URI绑定在一起。
* `state`
    * **REQUIRED**
    * 该参数值来自client发出的授权请求中。

下面的示例展示了authorization server通过HTTP响应将user-agent重定向到另一个地址:

    HTTP/1.1 302 Found
    Location: https://client.example.com/cb?code=SplxlOBeZQQYbYS6WxSbIA&state=xyz

client **必须(MUST)**忽略无法识别的响应参数。该规范并未定义authorization code的长度，client实现者也不应该对此做出假设，authorization server **应该(SHOULD)**在文档对此加以说明。

#### 4.1.2.1.  error response

若缺少/无效/不匹配redirection URI，或client id缺少/无效，而导致请求失败，则authorization server **应该(SHOULD)**通知resource owner错误信息，并 **禁止(MUST NOT)**自动将user-agent重定向到无效的redirection URI。

除了上面的原因，若resource owner拒绝了请求，或请求失败，则authorization server **应该(SHOULD)**以`application/x-www-form-urlencoded`格式在响应中添加以下参数来告知client相关信息:

* `error`
    * **REQUIRED**
    * USACII错误码，参见[USASCII][12]
        * `invalid_request`: 缺少必要参数，包含了无效参数值，参数重复出现，或其他错误信息
        * `unauthorized_client`: client未被授权发起该请求
        * `access_denied`: resource owner或authorization server拒绝了该请求
        * `unsupported_response_type`: authorization server不支持通过该方法获取authorization code
        * `invalid_scope`: 请求的访问范围无效/未知/错误
        * `server_error`: authorization server内部出现未预料到的异常，无法完成请求
        * `temporarily_unavailable`: 由于临时的服务过载或系统维护，authorization server暂时无法响应请求
    * 该参数的参数值 **禁止(MUST)**出现 `%x20-21 / %x23-5B / %x5D-7E`之外的字符
* `error_description`
    * **OPTIONAL**
    * ASCII字符，用于提供额外的错误信息描述
    * 该参数的参数值 **禁止(MUST)**出现 `%x20-21 / %x23-5B / %x5D-7E`之外的字符
* `error_uri`
    * **OPTIONAL**
    * 指定一个用于描述错误信息的页面地址。该参数值 **必须(MUST)**遵守URI语法，并且 **禁止(MUST)**出现 `%x21 / %x23-5B / %x5D-7E`之外的字符
* `state`
    * **OPTIONAL**
    * 若在授权请求中提供了`state`参数，则 **必须(MUST)**将参数值透传到响应中。

下面的示例中，authorization server通过HTTP响应将user-agent重定向到目标页面:

   HTTP/1.1 302 Found
   Location: https://client.example.com/cb?error=access_denied&state=xyz

### 4.1.3.  access token request

client在想token endpoint发送请求时，要在请求体中以`application/x-www-form-urlencoded`格式添加如下参数，参数值是UTF-8编码:

* `grant_type`
    * **REQUIRED**
    * 参数值 **必须(MUST)**是`authorization_code`
* `code`
    * **REQUIRED**
    * 来自authorization server颁发的authorization code
* `redirect_uri`
    * **REQUIRED**
    * 若授权请求中包含了`redirect_uri`参数，则该参数值 **必须(MUST)**与授权请求中的`redirect_uri`参数值相同。
* `client_id`
    * **REQUIRED**
    * 若client未经授权，则要添加该参数

若client type是`confidential`，或者client有已经颁发的证书，则authorization server **必须(MUST)**校验client身份。

示例，client发送如下请求

    POST /token HTTP/1.1
    Host: server.example.com
    Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
    Content-Type: application/x-www-form-urlencoded

    grant_type=authorization_code&code=SplxlOBeZQQYbYS6WxSbIA
    &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb

则authorization server **必须(MUST)**:

* 要求客户端校验
* 校验客户端身份
* 确认authorization code颁发给受信任的client，若client是公开的，则需要提供`client_id`参数
* 验证authorization code有效性
* 若授权请求中存在参数`redirect_uri`，则需要确认是否存在参数`redirect_uri`，并且与授权请求中的内容相同

### 4.1.4.  access token response

若access token请求有效且授权成功，则authorization server会颁发access token，并可选择是否颁发refresh token，参见[5.1节][13]。若client验证失败或无效，则返回错误信息，参见[5.2节][14]。

示例如下:

    HTTP/1.1 200 OK
    Content-Type: application/json;charset=UTF-8
    Cache-Control: no-store
    Pragma: no-cache

    {
        "access_token":"2YotnFZFEjr1zCsicMWpAA",
        "token_type":"example",
        "expires_in":3600,
        "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",
        "example_parameter":"example_value"
    }

## 4.2.  implicit grant

implicit授权类型用于获取access token(这种授权类型不支持获取refresh token)，并且针对操作特殊重定向URI的开放client做了优化。这类client一般是运行在浏览器中，使用Javascript编写的应用。

由于是基于重定向的流程，因此client必须能够与user-agent进行交互，能够接收来自authorization server的请求。

在authorization code中，client分2步获取authorization code和access token；而implicit中，client能够在authorization请求中直接得到access token。

implicit授权类型中并不包含client校验步骤，而是依赖于resource owner参与和注册redirect URI。由于access token被直接编码再redirect URI中，因此会直接暴露给resource owner和同一设备上的其他应用。

    +----------+
    | Resource |
    |  Owner   |
    |          |
    +----------+
         ^
         |
        (B)
    +----|-----+          Client Identifier     +---------------+
    |         -+----(A)-- & Redirection URI --->|               |
    |  User-   |                                | Authorization |
    |  Agent  -|----(B)-- User authenticates -->|     Server    |
    |          |                                |               |
    |          |<---(C)--- Redirection URI ----<|               |
    |          |          with Access Token     +---------------+
    |          |            in Fragment
    |          |                                +---------------+
    |          |----(D)--- Redirection URI ---->|   Web-Hosted  |
    |          |          without Fragment      |     Client    |
    |          |                                |    Resource   |
    |     (F)  |<---(E)------- Script ---------<|               |
    |          |                                +---------------+
    +-|--------+
      |    |
     (A)  (G) Access Token
      |    |
      ^    v
    +---------+
    |         |
    |  Client |
    |         |
    +---------+

注意，由于需要经过user-agent，上图中的A和B实际上是分2步的。

* 首先client通过重定向，经user-agent带到authorization endpoint。
* authorization server校验resource owner身份，确定resource owner是否授权client的访问请求。
* 若resource owner授权访问，则将user-agent重定向到client，并在重定向URI中添加access token
* user-agent跟随redirection URI向client resource发出请求，并在本地保存授权信息
* client resource返回一个页面来访问完整的redirection URI信息
* user-agent通过执行脚本代码抽取出access token，并传给client

### 4.2.1.  authorization request

client在构造请求authorization endpoint URI时，以`application/x-www-form-urlencoded`格式在查询部件中添加参数，参见[附录B][4]。

* `response_type`
    * **REQUIRED**
    * 参数值 **必须(MUST)**是`token`
* `client_id`
    * **REQUIRED**
    * client标识，参见[2.2节][8]
* `redirect_uri`
    * **OPTIONAL**
    * 参见[3.1.2节][9]
* `scope`
    * **OPTIONAL**
    * 参见[3.3节][10]
* `state`
    * **RECOMMENDED**
    * 透传值，client用来维护其在请求/回调间的状态。authorization serve在重定向会client时会附带该参数值。该参数 **应该(SHOULD)**用于防止CSRF攻击，参见[10.12节][11]

client通过重定向将resource owner导向构造好的URI。例如，client借助TLS，以HTTP请求的方式，通过user-agent将resource owner导向authorization endpoint:

    GET /authorize?response_type=token&client_id=s6BhdRkqt3&state=xyz
        &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb HTTP/1.1
    Host: server.example.com

authorization server校验请求参数，确保所有必要参数存在且有效。参数校验通过后，authorization server会校验resource owner身份，根据resource owner的要求完成授权。

完成授权后，authorization server以HTTP重定向的方式，将user-agent导向client提供的redirection URI。

### 4.2.2.  access token response

若resource owner授权了访问请求，则authorization server会生成一个access token，并发送给client。在发送access token给client时，会以`application/x-www-form-urlencoded`格式在查询部件中添加以下参数:

* `access_token`
    * **REQUIRED**
    * access token由authorization server生成
* `token_type`
    * **REQUIRED**
    * token的类型，大小写敏感，参见[7.1节][15]
* `expires_in`
    * **RECOMMENDED**
    * access token的有效期，单位是秒。若不提供该参数，则authorization server **应该(SHOULD)**通过其他方式指定或在文档中说明。
* `scope`
    * **OPITONAL**，若与请求中的范围相同；若不同，则为 **REQUIRED**
    * 参见[3.3节][19]

authorization server **禁止(MUST NOT)**颁发refresh token。

下面的示例展示了authorization server通过HTTP响应将user-agent重定向到另一个地址:

    HTTP/1.1 302 Found
    Location: http://example.com/cb#access_token=2YotnFZFEjr1zCsicMWpAA&state=xyz&token_type=example&expires_in=3600

开发者需要注意，某些user-agent不支持在响应头`Location`中添加参数片段，此时需要使用其他重定向方法，例如在返回的新页面中添加一个重定向按钮。

client **必须(MUST)**忽略无法识别的响应参数。该规范没有定义access token的大小，client也要避免对此做假设。authorization server **应该(SHOULD)**在文档中对此加以注明。

#### 4.2.2.1  error response

若缺少/无效/不匹配redirection URI，或client id缺少/无效，而导致请求失败，则authorization server **应该(SHOULD)**通知resource owner错误信息，并 **禁止(MUST NOT)**自动将user-agent重定向到无效的redirection URI。

除了上面的原因，若resource owner拒绝了请求，或请求失败，则authorization server **应该(SHOULD)**以`application/x-www-form-urlencoded`格式在响应中添加以下参数来告知client相关信息:

* `error`
    * **REQUIRED**
    * USACII错误码，参见[USASCII][12]
        * `invalid_request`: 缺少必要参数，包含了无效参数值，参数重复出现，或其他错误信息
        * `unauthorized_client`: client未被授权发起该请求
        * `access_denied`: resource owner或authorization server拒绝了该请求
        * `unsupported_response_type`: authorization server不支持通过该方法获取authorization code
        * `invalid_scope`: 请求的访问范围无效/未知/错误
        * `server_error`: authorization server内部出现未预料到的异常，无法完成请求
        * `temporarily_unavailable`: 由于临时的服务过载或系统维护，authorization server暂时无法响应请求
    * 该参数的参数值 **禁止(MUST)**出现 `%x20-21 / %x23-5B / %x5D-7E`之外的字符
* `error_description`
    * **OPTIONAL**
    * ASCII字符，用于提供额外的错误信息描述
    * 该参数的参数值 **禁止(MUST)**出现 `%x20-21 / %x23-5B / %x5D-7E`之外的字符
* `error_uri`
    * **OPTIONAL**
    * 指定一个用于描述错误信息的页面地址。该参数值 **必须(MUST)**遵守URI语法，并且 **禁止(MUST)**出现 `%x21 / %x23-5B / %x5D-7E`之外的字符
* `state`
    * **OPTIONAL**
    * 若在授权请求中提供了`state`参数，则 **必须(MUST)**将参数值透传到响应中。

下面的示例中，authorization server通过HTTP响应将user-agent重定向到目标页面:

   HTTP/1.1 302 Found
   Location: https://client.example.com/cb#error=access_denied&state=xyz

## 4.3.  resource owner password credential grant

该种授权类型适用于resoruce owner与client具有信任关系的场景，这种场景下的设备操作系统往往具有很高的权限。authorization servey要特别关注这种授权方式，应该仅用于其他授权方式无效的情况下。

这种授权方式适用于client可以获取到resource owner证书的场景，此外还可以用于现有的、使用直接校验(例如HTTP Basic或Digest校验)的client迁移到基于Oauth的认证方式。

    +----------+
    | Resource |
    |  Owner   |
    |          |
    +----------+
        v
        |    Resource Owner
        (A) Password Credentials
        |
        v
    +---------+                                  +---------------+
    |         |>--(B)---- Resource Owner ------->|               |
    |         |         Password Credentials     | Authorization |
    | Client  |                                  |     Server    |
    |         |<--(C)---- Access Token ---------<|               |
    |         |    (w/ Optional Refresh Token)   |               |
    +---------+                                  +---------------+

### 4.3.1.  authorization request and response

规范中没有定义client获取resource owner证书的方法。client在获取到access token后，**必须(MUST)**立刻删除自己保存的resource owner证书。

### 4.3.2.  access token request

client在构造请求authorization endpoint URI时，以`application/x-www-form-urlencoded`格式在查询部件中添加参数，参数值以UTF-8编码，参见[附录B][4]。

* `response_type`
    * **REQUIRED**
    * 参数值 **必须(MUST)**是`password`
* `username`
    * **REQUIRED**
* `password`
    * **REQUIRED**
* `scope`
    * **OPTIONAL**
    * 参见[3.3节][10]

若client type为`confidential`，或者client被颁发了client证书，则client **必须(MUST)**与authorization server校验身份。

例如，client借助TLS，发出HTTP请求:

    POST /token HTTP/1.1
    Host: server.example.com
    Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
    Content-Type: application/x-www-form-urlencoded

    grant_type=password&username=johndoe&password=A3ddj3w

authorization server **必须(MUST)**:

* 对client身份进行校验
* 验证`username`和`password`是否有效

由于这种授权类型会直接用到`password`，authorization server **必须(MUST)**防止被暴力破解。

### 4.3.3.  access token response

若请求有效且成功授权，则authorization server会颁发access token，并可选是否颁发refresh token。若请求失败，则需要返回错误信息。示例:

    HTTP/1.1 200 OK
    Content-Type: application/json;charset=UTF-8
    Cache-Control: no-store
    Pragma: no-cache

    {
        "access_token":"2YotnFZFEjr1zCsicMWpAA",
        "token_type":"example",
        "expires_in":3600,
        "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",
        "example_parameter":"example_value"
    }

## 4.4.  client credentials grant

在该种授权类型下，client可以仅凭自己的证书来换取access token。此种场景下所要访问的资源，都是在client控制之下的，或是其他resource owner与authorization server协商过的资源。

该种授权类型 **必须(MUST)**仅用于受信任的client。

    +---------+                                  +---------------+
    |         |                                  |               |
    |         |>--(A)- Client Authentication --->| Authorization |
    | Client  |                                  |     Server    |
    |         |<--(B)---- Access Token ---------<|               |
    |         |                                  |               |
    +---------+                                  +---------------+

### 4.4.1.  authorization request and response

无需使用额外的authorization request。

### 4.4.2.  access token request

client在构造请求authorization endpoint URI时，以`application/x-www-form-urlencoded`格式在查询部件中添加参数，参数值以UTF-8编码，参见[附录B][4]。

* `response_type`
    * **REQUIRED**
    * 参数值 **必须(MUST)**是`client_credentials`
* `scope`
    * **OPTIONAL**
    * 参见[3.3节][10]

client **必须(MUST)**与authorization server校验身份。

请求示例:

    POST /token HTTP/1.1
    Host: server.example.com
    Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
    Content-Type: application/x-www-form-urlencoded

    grant_type=client_credentials

authorization serve **必须(MUST)**校验client身份。

### 4.4.3.  access token response

若请求有效，且授权通过，则authorization server会返回access token，但 **不应该(SHOULD NOT)**返回refresh token。若请求无效或授权失败，需要返回错误信息。示例如下:

    HTTP/1.1 200 OK
    Content-Type: application/json;charset=UTF-8
    Cache-Control: no-store
    Pragma: no-cache

    {
        "access_token":"2YotnFZFEjr1zCsicMWpAA",
        "token_type":"example",
        "expires_in":3600,
        "example_parameter":"example_value"
    }

## 4.5.  extension grant

client可以使用特殊的授权类型，此时会以一个特殊URI(由authorization server指定)作为参数`grant_type`的值。

例如，为了请求一个使用了[SAML(Security Assertion Markup Language) 2.0][16]断言授权类型的access token，client可以通过TLS发送如下请求:

    POST /token HTTP/1.1
    Host: server.example.com
    Content-Type: application/x-www-form-urlencoded

    grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Asaml2-
    bearer&assertion=PEFzc2VydGlvbiBJc3N1ZUluc3RhbnQ9IjIwMTEtMDU
    [...omitted for brevity...]aG5TdGF0ZW1lbnQ-PC9Bc3NlcnRpb24-

若请求有效，且授权通过，则authorization server会返回access token，并可选返回refresh token。若请求无效或授权失败，需要返回错误信息。

# 5.  issuing an access token

若access token请求有效且授权通过，则authorization server会颁发access token，并可选颁发refresh token。若请求失败，或无效，则返回错误信息。

## 5.1.  successful response

authorization server颁发access token时，会将下面的参数包装在响应体中，此时HTTP状态码为`200(OK)`:

* `access_token`
    * `REQUIRED`
    * authorization server颁发的access token
* `token_type`
    * `REQUIRED`
    * 颁发的token的类型，参见[7.1节][15]
* `expires_in`
    * `RECOMMENDED`
    * access token有效期，单位秒。若没有改参数，则authorization server **应该(SHOULD)**以其他方式提供过期时间，火灾文档中注明。
* `refresh_token`
    * `OPTIONAL`
    * 用于更新access token，授权类型和与access token相同
* `scope`
    * `OPTIONAL`，若实际范围与请求范围相同
    * `REQUIRED`，若实际范围与请求范围不同

响应体的格式为`application/json`。

authorization server在返回token、confidential或其他敏感信息时，**必须(MUST)**添加响应头`Cache-Control:no-store`和`Pragma:no-cache`。示例:

    HTTP/1.1 200 OK
    Content-Type: application/json;charset=UTF-8
    Cache-Control: no-store
    Pragma: no-cache

    {
        "access_token":"2YotnFZFEjr1zCsicMWpAA",
        "token_type":"example",
        "expires_in":3600,
        "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",
        "example_parameter":"example_value"
    }

client **必须(MUST)**忽略响应体中无法识别的参数。规范中未定义access token的长度，client也不要对此做假设，authorization server **应该(SHOULD)**在文档中加以注明。

## 5.2.  error response

若请求失败，会返回HTTP 400(Bad Request)，并返回如下参数:

* `error`
    * `REQUIRED`
    * 一段ASCII字符，表示错误原因
        * `invalid_request`: 缺少必要参数，包含了无效参数值，参数重复出现，或其他错误信息
        * `invalid_client`: 
            * client身份校验失败，此时authorization server **可以(MAY)**返回401错误码
            * 若client期望通过请求头`Authorization`来校验客户端，则authorization server **必须(MUST)**返回HTTP 401，并在响应头中添加`WWW-Authenticate`
        * `invalid_grant`: 授权类型或者refresh token，无效/过期/已撤销/与授权请求中的redirection URI不匹配/已被颁发给其他client
        * `unauthorized_client`: client未被授权发起该请求
        * `unsupported_grant_type`: 当前authorization server不支持该种授权类型
        * `invalid_scope`: 请求的访问范围无效/未知/错误
    * 该参数的参数值 **禁止(MUST)**出现 `%x20-21 / %x23-5B / %x5D-7E`之外的字符
* `error_description`
    * **OPTIONAL**
    * ASCII字符，用于提供额外的错误信息描述
    * 该参数的参数值 **禁止(MUST)**出现 `%x20-21 / %x23-5B / %x5D-7E`之外的字符
* `error_uri`
    * **OPTIONAL**
    * 指定一个用于描述错误信息的页面地址。该参数值 **必须(MUST)**遵守URI语法，并且 **禁止(MUST)**出现 `%x21 / %x23-5B / %x5D-7E`之外的字符

响应体的格式为`application/json`，示例:

    HTTP/1.1 400 Bad Request
    Content-Type: application/json;charset=UTF-8
    Cache-Control: no-store
    Pragma: no-cache

    {
        "error":"invalid_request"
    }

# 6.  refreshing an access token

若authorization server为client颁发了refresh token，则client可以在请求token endpoint时添加以下参数来刷新access token:

* `grant_type`
    * `REQUIRED`
    * 参数值 **必须(MUST)**为`refresh_token`
* `refresh_token`
    * `REQUIRED`
    * refresh token本身
* `scope`
    * `OPTIONAL`
    * access token的访问范围。该值 **禁止(MUST)**包含任何为被授权的范围；若忽略该参数，则默认与初始授权的范围相同。

由于refresh token的生命周期一般较长，因此refresh token是与请求refresh token的client做绑定的。若client type是`confidential`，或者持有client证书，则 **必须(MUST)**校验client身份。

例如，client通过TLS发送如下请求:

    POST /token HTTP/1.1
    Host: server.example.com
    Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
    Content-Type: application/x-www-form-urlencoded

    grant_type=refresh_token&refresh_token=tGzv3JOkF0XG5Qx2TlKWIA

authorization server **必须**:

* 校验client身份
* 校验client与refresh token的绑定关系
* 校验refresh token

若校验通过，则authorization server会颁发新的access token；若请求失败或参数无效，则authorization server会返回相应的错误信息。

authorization server **可以(MAY)**办法一个新的refresh token，此时client **必须(MUST)**抛弃原有的refresh token。在颁发新的refresh token后，authorization server **可以(MAY)**撤销旧的refresh token。颁发新的refresh token时，token的访问范围 **必须(MUST)**与原refresh token的访问范围相同。

# 7. accessing protected resources

client在访问受保护资源时，需要向resource server出示access token。resource server **必须(MUST)**校验access token，确保access token未过期，且要访问的资源在access token所对应的访问范围以内。规范中没有定义resource server校验access token的方法。

client提交access token的方式取决于access token的授权类型，一般情况下，会通过HTTP请求头`Authorization`来提交。

## 7.1.  access token types

access token type为client指定了使用access token的信息。如果client不理解access token type，则 **禁止(MUST NOT)**使用access token。

例如，下面的示例展示了如何在以`bearer`这种类型请求中简单使用access token:

    GET /resource/1 HTTP/1.1
    Host: example.com
    Authorization: Bearer mF_9.B5f-4.1JqM

例如，下面的示例展示了如何在以`mac`这种类型请求中简单使用access token:

    GET /resource/1 HTTP/1.1
    Host: example.com
    Authorization: MAC id="h480djs93hd8",
                        nonce="274312:dj83hs9s",
                        mac="kDZvddkndxvhGRXZhvuDjEWhGeE="

## 7.2.  error response

若请求失败，则resource server **应该(SHOULD)**通知client相应的信息。规范中没有定义具体的错误信息。

# 8.  extensibility

## 8.1.  defining access token types

有2种定义access token type的方式: 

* 注册access token type
* 使用唯一的、绝对路径的URI作为access token type的名字

使用URI名字的access token type， **应该(SHOULD)**仅限于某个具体厂商的实现。

其他类型 **必须(MUST)**以注册实现。类型名 **必须(MUST)**遵循ABNF。示例:

    type-name  = 1*name-char
    name-char  = "-" / "." / "_" / DIGIT / ALPHA

## 8.2.  defining new endpoint parameters

参数名和参数值 **必须(MUST)**遵循ABNF，示例:

    param-name  = 1*name-char
    name-char   = "-" / "." / "_" / DIGIT / ALPHA

## 8.3.  defining new authorization grant types

略

## 8.4.  defining new authorization endpoint response types

响应类型的名字 **必须(MUST)**遵循ABNF，示例:

    response-type  = response-name *( SP response-name )
    response-name  = 1*response-char
    response-char  = "_" / DIGIT / ALPHA

## 8.5.  defining additional error codes

响应码的名字 **必须(MUST)**遵循ABNF，示例:

    error      = 1*error-char
    error-char = %x20-21 / %x23-5B / %x5D-7E

# 9.  native applications

native application指安装/运行在resource server上的client。

略。

# 10.  security consideration

## 10.1.  client authentication

authorization server为client颁发证书，cleint校验方法最好能比密码强些。web application client **必须(MUST)**密码和证书的安全性。

authorization server **禁止(MUST NOT)**将client密码/证书直接颁发给native application或user-agent，但 **可以(MAY)**针对某个特定设备的某个特殊的native application。

当无法校验client时，authorization server **应该(SHOULD)**使用其他方法来校验client身份。

## 10.2.  client impersonation

恶意client可能会伪装为其他client来访问受限资源。

authorization server **必须(MUST)**校验client身份。

authorization server **应该(SHOULD)**强制校验resource owner身份，并为resource owner提供有关client、授权范围和生命周期等信息。

authorization server **不应该(SHOULD NOT)**在未校验client之前，自动处理重复的授权请求。

## 10.3.  access tokens

传输/保存access token时，**必须(MUST)**要确保安全性，并且只能在authorization server，resource server和client之间分享。access token的传输 **必须(MUST)**通过TLS完成。

当使用 **implicit**授权类型时，access token会放在URI中，这时会被暴露给未授权的使用方。

authorization server **必须(MUST)**确保access token不会被伪造/篡改/猜出。

client **应该(SHOULD)**尽可能缩小access token的访问范围，而authorization server也 **应该(SHOULD)**尽可能控制access token的访问范围，并且 **可以(MAY)**返回比请求的更小的访问范围。

## 10.4.  refresh tokens

authorization server **可以(MAY)**给native application和web application client办法refresh token。

refresh token在传输和存储时 **必须(MUST)**严格保密，并且仅在authorization server和请求refresh token的client之间分享。authorization server **必须(MUST)**将refresh token和client绑定在一起。refresh token **必须(MUST)**使用TLS传输。

在校验client身份时，authorization server **必须(MUST)**校验refresh token和client的绑定关系。若无法校验client身份，则authorization server **应该(SHOULD)**提供其他方法来检测refresh token是否被滥用。

## 10.5.  authorization codes

传输authorization codes **应该(SHOULD)**通过TLS完成，client也 **应该(SHOULD)**要求重定向URI通过TLS完成。

authorization codes **必须(MUST)**具有较短的声明周期，并且只能使用一次。若authorization server发现某个authorization code被重复使用，则 **应该(SHOULD)**撤销掉依据该authorization code所颁发的所有token。

## 10.6.  authorization code redirection URI manipulation

略
















[1]:    https://tools.ietf.org/html/rfc5246
[2]:    https://tools.ietf.org/html/rfc2246
[3]:    https://tools.ietf.org/html/rfc2617
[4]:    https://tools.ietf.org/html/rfc6749#appendix-B
[5]:    https://tools.ietf.org/html/rfc6749#section-10.15
[6]:    https://tools.ietf.org/html/rfc3986#section-6
[7]:    https://tools.ietf.org/html/rfc3986#section-6.2.1
[8]:    https://tools.ietf.org/html/rfc6749#section-2.2
[9]:    https://tools.ietf.org/html/rfc6749#section-3.1.2
[10]:   https://tools.ietf.org/html/rfc6749#section-3.3
[11]:   https://tools.ietf.org/html/rfc6749#section-10.12
[12]:   https://tools.ietf.org/html/rfc6749#ref-USASCII
[13]:   https://tools.ietf.org/html/rfc6749#section-5.1
[14]:   https://tools.ietf.org/html/rfc6749#section-5.2
[15]:   https://tools.ietf.org/html/rfc6749#section-7.1
[16]:   https://tools.ietf.org/html/rfc6749#ref-OAuth-SAML2
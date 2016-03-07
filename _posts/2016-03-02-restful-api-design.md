---
title:      RESTful API Design
layout:     post
category:   blog
tags:       [api, restful]
---


> 参考文档  [https://pages.apigee.com/rs/apigee/images/api-design-ebook-2012-03.pdf][reference-book]

<a name="content" />
# 目录

* [核心原则][core-principal]
* [使用名词而非动词][using-noun-not-verb]
* [使用复数描述资源][using-plural-nouns]
* [合理规划资源][using-concrete-names]
* [响应码][response-codes]
* [身份校验][authentication]

<a name="core-principal" />
# 1. 核心原则

* **简单即是美**
* **合理规划业务资源**

<a name="using-noun-not-verb" />
# 2. 使用名词而非动词

查询数据信息时，使用GET方法，在URL中指明资源信息执行放操作。例如:

    GET /dogs               // 查询小狗列表
    GET /dogs/1234          // 查询id为1234的小狗信息

在操作资源时，根据实际业务逻辑选择相应的HTTP方法。例如：

    Resource      POST                GET                 PUT                   DELETE
                  (create)            (read)              (update)              (delete)

    /dogs         创建一只小狗实体    列出所有小狗        批量更新              删除所有小狗实体
    /dogs/1234    错误                列出某只狗的信息    如果存在则更新，
                                                          否则报错

<a name="using-plural-nouns" />
# 3. 使用复数描述资源

在描述业务资源时，使用复数形式来描述。例如：

    GET /dogs             // 查询所有小狗列表
    GET /dogs/1234        // 查询id为1234的小狗信息

<a name="using-concrete-names" />
# 4. 合理规划资源

规划资源之间的关联关系时，要明确易用。例如小狗是属于某位主人的，则在操作时，可以使用如下URL：

    GET /owners/5678/dogs
    GET /owners/5678/dogs/1234
    POST /owners/5678/dogs
    GET /owners/5678/dogs/1234

当根据相关信息查询小狗列表时，可以使用如下形式：

    GET /dogs?color=red&state=running&location=park

<a name="response-codes" />
# 5. 响应码

HTTP代码可以代表一些明显的相应结果，大部分情况，可以使用HTTP代码来表示常见的数据操作。

对于某些特殊的业务请求来说，单纯使用HTTP代码不足以完整表达相应的操作结果，这时可以使用自定义的业务代码来表示。

<a name="authentication" />
# 6 身份校验

使用基于Token的校验方式，方便服务器端实现无状态化处理，便于横向扩展服务器规模。











[reference-book]: https://pages.apigee.com/rs/apigee/images/api-design-ebook-2012-03.pdf
[core-principal]: #core-principal
[using-noun-not-verb]: #using-noun-not-verb
[using-plural-nouns]:  #using-plural-nouns
[handling-errors]: #handling-errors
[response-codes]: #response-codes
[authentication]: #authentication
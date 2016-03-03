RESTful API Design
=========================================

> 参考文档  [https://pages.apigee.com/rs/apigee/images/api-design-ebook-2012-03.pdf][reference-book]

<a name="content" />
# 目录

* [核心原则][core-principal]
* [使用名词而非动词][using-noun-not-verb]

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

<a name="handling-errors" />
# 5. 错误处理











[reference-book]: https://pages.apigee.com/rs/apigee/images/api-design-ebook-2012-03.pdf
[core-principal]: #core-principal
[using-noun-not-verb]: #using-noun-not-verb
[using-plural-nouns]:  #using-plural-nouns
[handling-errors]: #handling-errors
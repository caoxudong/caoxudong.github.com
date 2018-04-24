---
title:      SpringBoot WebFlux中的数据绑定
layout:     post
category:   blog
tags:       [java, spring, springboot, webflux]
---

在使用了WebFlux后，注解`RequestParam`只能获取到查询字符串(query string)中的参数值了。

>Unlike the Servlet API "request paramater" concept that conflate query parameters, form data, and multiparts into one, in WebFlux each is accessed individually through the ServerWebExchange. While @RequestParam binds to query parameters only, you can use data binding to apply query paramerters, form data, and multiparts to a command object.
>
>[web-reactive][spring-framework-reference/web-reactive]

若是想以表单(`x-www-form-urlencoded`)提交数据，此时在做数据绑定的时候，可以为参数值做一个包装类，这样Spring就会自动完成数据绑定。

示例：

以表单(`x-www-form-urlencoded`)提交数据：

    curl -X POST \
        http://localhost:8888/test/callback \
        -H 'cache-control: no-cache' \
        -H 'content-type: application/x-www-form-urlencoded' \
        -H 'postman-token: 3331bf20-6b83-3e51-6ac3-079b5a5eb101' \
        -d params=%7B%22a%22%3D1%7D

包装类:

    package test.web.entity;

    public class CallBackRequest {

        private String params;

        public String getParams() {
            return params;
        }

        public void setParams(String params) {
            this.params = params;
        }

    }

controller类:

    package test.web.controller;

    @RestController
    @RequestMapping("/test")
    public class TestController {

        @PostMapping("/callback")
        public Response<?> callback(CallBackRequest request) {
            LOGGER.info("receive request, params = {}", request.getParams());
            return new Response<String>(0, null, null);
        }
    }



[remove_RequestParam_]:    https://jira.spring.io/browse/SPR-15508
[spring-framework-reference/web-reactive]:    https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html

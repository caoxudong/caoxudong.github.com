---
title:      SpringBoot应用中调整Tomcat参数
layout:     post
category:   blog
tags:       [tomcat, java, spring, springboot]
---


SpringBoot内嵌Tomcat时，并没有暴露出太多的参数，当项目有特殊需求时，没法做定制化调整。本文列出一些可以定制化Tomcat参数的方法，总体来说，就是通过定制化[`TomcatEmbeddedServletContainerFactory`][1]类来实现对目标参数的修改。用户可以创建自己的[`TomcatEmbeddedServletContainerFactory`][1]并在其中调用相关的方法来定制Tomcat。

# 1 修改Connector

## 1.1 设置默认Connector

Tomcat Connector所支持的参数
* [Reference][4]: https://tomcat.apache.org/tomcat-7.0-doc/config/http.html
* [JavaDoc][3]: https://tomcat.apache.org/tomcat-8.5-doc/api/index.html?org/apache/catalina/connector/Connector.html

SpringBoot中的[`TomcatConnectorCustomizer`][2]类可用于对`Connector`进行定制化修改。例如在Connector中设置`disableUploadTimeout`属性：

    @Bean
    public EmbeddedServletContainerFactory servletContainerFactory() {
      TomcatEmbeddedServletContainerFactory factory =
          new TomcatEmbeddedServletContainerFactory();

      factory.addConnectorCustomizers(
          connector -> {
            Http11NioProtocol protocol = 
                (Http11NioProtocol)connector.getProtocolHandler();
            protocol.setDisableUploadTimeout(false);
          }
      );

      return factory;
    }

## 1.2 添加其他的Connector

默认情况下，SpringBoot只启用一个Connector，用户可以根据实际需要创建多个Connector。例如：

    @Bean
    public EmbeddedServletContainerFactory servletContainerFactory() {
      TomcatEmbeddedServletContainerFactory factory =
          new TomcatEmbeddedServletContainerFactory();

      factory.addAdditionalTomcatConnectors(new Connector[] {
          new Connector()   // 省略配置Connector属性的代码
      });

      return factory;
    }





[1]:    http://docs.spring.io/autorepo/docs/spring-boot/1.3.5.RELEASE/api/index.html?org/springframework/boot/context/embedded/tomcat/TomcatEmbeddedServletContainerFactory.html
[2]:    http://docs.spring.io/autorepo/docs/spring-boot/1.3.5.RELEASE/api/index.html?org/springframework/boot/context/embedded/tomcat/TomcatConnectorCustomizer.html
[3]:    https://tomcat.apache.org/tomcat-8.5-doc/api/index.html?org/apache/catalina/connector/Connector.html
[4]:    https://tomcat.apache.org/tomcat-7.0-doc/config/http.html
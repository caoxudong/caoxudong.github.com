---
title:      SpringBoot中按照Profile设定日志配置
layout:     post
category:   blog
tags:       [java, spring, springboot]
---

SpringBoot的Profile概念可以帮助开发者灵活配置不同环境下的设置。对于日志打印来说，不同环境使用不同的日志目录、日志级别是很常见的需求，幸好SpringBoot对此提供了支持，可以实现类似`if...else`的逻辑判断，根据不同的Profile采用不同的日志配置。参见[SpringBoot文档][1]。

以logback为例，可以在配置文件中添加标签`<springProfile name="dev"></springProfile>`标签，并在这对标签中添加普通的logback配置内容。这样，只有当前Profile为`dev`时，标签中的配置才会生效。示例如下：

    <?xml version="1.0" encoding="UTF-8"?>
    <configuration>
        <include resource="org/springframework/boot/logging/logback/base.xml" />
        <springProfile name="dev,staging">
            <logger name="guru.springframework.controllers" level="DEBUG" additivity="false">
                <appender-ref ref="CONSOLE" />
            </logger>>
        </springProfile>
        <springProfile name="prod">
            <logger name="guru.springframework.controllers" level="WARN" additivity="false">
                <appender-ref ref="FILE" />
            </logger>
        </springProfile>
    </configuration>

上面的配置文件中，针对`dev` `staging`和`prod`设置了不同的`logger`。在启动SpringBoot后，对针对不同的Profile采用不同的配置。

需要注意的是，由于日志组件的初始化在Spring之前，因此，采用上面的方法时，需要将日志配置文件命名为`loggback-spring.xml`。






[1]:    https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-logging.html#_profile_specific_configuration
---
title:      SpringBoot应用程序启动流程
layout:     post
category:   blog
tags:       [java, spring, springboot]
---

>springboot版本，1.4.3.RELEASE
>
>流水账，纯记录。
>
>TL;DR.

1. [创建并初始化SpringBoot实例][SpringApplication]
    1. [判断是否是web应用][deduceWebEnvironment] : 通过是否存在Web应用相关的类来判断，`javax.servlet.Servlet` `org.springframework.web.context.ConfigurableWebApplicationContext`
    1. 从`META-INF/spring.factories`中加载`ApplicationContextInitializer`的实现类，为之创建实例，并按照注解`Order`来排序存储，[`getSpringFactoriesInstances`][getSpringFactoriesInstances]
    1. 从`META-INF/spring.factories`中加载`ApplicationListener`的实现类，为之创建实例，并按照注解`Order`来排序存储，[`getSpringFactoriesInstances`][getSpringFactoriesInstances]
    1. [判断应用程序主类][deduceMainApplicationClass] : 分析当前调用栈，找到含有`main`方法的类。不过这里只检查了方法名，若是还有其他名为`main`的方法，容易出现错误。
1. [调用`SpringApplication#run(String... args)`启动应用程序][SpringApplication#run] :
    1. 从`META-INF/spring.factories`中加载`SpringApplicationRunListener`的实现类，为之创建实例，并按照注解`Order`来排序存储，然后在启动加载的实例[`SpringApplicationRunListeners#started`][SpringApplicationRunListeners#started]
1. 处理命令行参数，[`DefaultApplicationArguments`][DefaultApplicationArguments]
    1. 按照是否带有前缀`--`来区分是否是参数选项，分别存储到`CommandLineArgs`的`optionArgs`和`nonOptionArgs`中，参见[`SimpleCommandLineArgsParser#parse`][SimpleCommandLineArgsParser#parse]
1. 准备应用程序的执行环境，[`prepareEnvironment`][prepareEnvironment]
    1. [创建`Environment`实例][getOrCreateEnvironment]，若是Web应用程序，则使用[`StandardServletEnvironment`][StandardServletEnvironment]实例，否则使用[`StandardEnvironment`][StandardEnvironment]实例。在实例化`Environment`时，会获取到系统变量和环境变量，放置到属性列表中。
    1. [配置创建好的`Environment`实例][configureEnvironment]，将命令行参数中的配置项加入到属性列表中，[配置profile信息][configureProfiles]，找出处理active状态的profile
    1. 调用注册的`SpringApplicationRunListeners`，处理`environmentPrepared`事件
    1. 若创建的`Environment`实例是`ConfigurableWebEnvironment`，但前面通过`deduceWebEnvironment`方法判断的不是Web应用，则会[将`ConfigurableWebEnvironment`实例转换为普通`Environment`实例][convertToStandardEnvironment]。
1. [在控制台打印banner文字][printBanner]
1. [创建`ApplicationContext`容器][createApplicationContext]，对于Web应用程序，容器实例是[`AnnotationConfigEmbeddedWebApplicationContext`][AnnotationConfigEmbeddedWebApplicationContext]。容器有两个属性，[`AnnotatedBeanDefinitionReader`][AnnotatedBeanDefinitionReader]和[`ClassPathBeanDefinitionScanner`][ClassPathBeanDefinitionScanner]，分别用来根据注解和类路径来加载Bean。**注意，这时候还没有加载Bean**。
1. [准备容器`ApplicationContext`][prepareContext]
    1. 将`ApplicationContext`与`Environment`相关联: `context.setEnvironment(environment);`
    1. [处理`ApplicationContext`实例][postProcessApplicationContext]，注册Bean`BeanNameGenerator`和`ResourceLoader`
    1. [应用初始化器`ApplicationContextInitializer`][applyInitializers]，对`ApplicationContext`实例，初始化器是在初始化SpringBoot实例时加载的
    1. 调用注册的`SpringApplicationRunListeners`，处理`contextPrepared`事件
    1. 向容器`ApplicationContext`中注册Bean`ApplicationArguments`和`Banner`
    1. [加载应用程][load]
    1. 调用注册的`SpringApplicationRunListeners`，处理`contextLoaded`事件
1. [刷新容器`ApplicationContext`][refreshContext]
    1. [准备刷新][prepareRefresh]
        1. 清空容器属性`ClassPathBeanDefinitionScanner`的缓存
        1. [调用父类，执行基础准备工作][AbstractApplicationContext#prepareRefresh]
            1. 重置容器启动时间，将关闭状态置为`false`，将活动状态置为`true`
            1. 初始化属性源，若当前是Web应用，则使用`GenericWebApplicationContext`来初始化属性源，[`GenericWebApplicationContext#initPropertySources`][GenericWebApplicationContext#initPropertySources]
            1. 校验必要属性是否设置
    1. [刷新`BeanFactory`][AbstractApplicationContext#obtainFreshBeanFactory]，这里其实啥也没做
    1. [准备`BeanFactory`][AbstractApplicationContext#prepareBeanFactory]，做各项基础配置
    1. [`BeanFactory`后续处理][AnnotationConfigEmbeddedWebApplicationContext#postProcessBeanFactory]，这里除了做常规的后续处理之外，还会使用实例`ClassPathBeanDefinitionScanner`和`AnnotatedBeanDefinitionReader`来加载应用程序的Bean
    1. [调用`BeanFactoryPostProcessor`][AbstractApplicationContext#invokeBeanFactoryPostProcessors]
    1. [注册`BeanPostProcessor`][AbstractApplicationContext#registerBeanPostProcessors]
    1. [初始化`MessageSource`][AbstractApplicationContext#initMessageSource]
    1. [初始化事件广播器`ApplicationEventMulticaster`][AbstractApplicationContext#initApplicationEventMulticaster]
    1. [初始化特殊Bean][AbstractApplicationContext#onRefresh]
    1. [注册`ApplicationListener`][AbstractApplicationContext#registerListeners]，如果有早期事件的话，就会广播出去
    1. [实例化单例Bean][AbstractApplicationContext#finishBeanFactoryInitialization]
    1. [广播相关事件][AbstractApplicationContext#finishRefresh]
1. [刷新容器后的后续处理][SpringApplication#afterRefresh]，这里主要是调用`ApplicationRunner`和`CommandLineRunner`完成各自的任务
1. 调用注册的`SpringApplicationRunListeners`，处理`finished`事件


[deduceWebEnvironment]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java
[SpringApplication]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L237
[deduceMainApplicationClass]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L277
[SpringApplication#run]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L298
[getSpringFactoriesInstances]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L398
[SpringApplicationRunListeners#started]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplicationRunListeners.java#L46
[DefaultApplicationArguments]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/DefaultApplicationArguments.java#L40
[SimpleCommandLineArgsParser#parse]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-core/src/main/java/org/springframework/core/env/SimpleCommandLineArgsParser.java#L60
[prepareEnvironment]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L331
[StandardEnvironment]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-core/src/main/java/org/springframework/core/env/StandardEnvironment.java#L54
[StandardServletEnvironment]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-web/src/main/java/org/springframework/web/context/support/StandardServletEnvironment.java#L45
[getOrCreateEnvironment]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L431
[configureEnvironment]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L452
[configureProfiles]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L531
[convertToStandardEnvironment]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L469
[printBanner]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L539
[createApplicationContext]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L583
[AnnotationConfigEmbeddedWebApplicationContext]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/context/embedded/AnnotationConfigEmbeddedWebApplicationContext.java#L49
[AnnotatedBeanDefinitionReader]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/annotation/AnnotatedBeanDefinitionReader.java#L48
[ClassPathBeanDefinitionScanner]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/annotation/ClassPathBeanDefinitionScanner.java#L63
[prepareContext]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L344
[postProcessApplicationContext]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L605
[applyInitializers]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L630
[load]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L687
[refreshContext]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L370
[prepareRefresh]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/context/embedded/AnnotationConfigEmbeddedWebApplicationContext.java#L174
[AbstractApplicationContext#prepareRefresh]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/support/AbstractApplicationContext.java#L584
[GenericWebApplicationContext#initPropertySources]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-web/src/main/java/org/springframework/web/context/support/GenericWebApplicationContext.java#L185
[AbstractApplicationContext#obtainFreshBeanFactory]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/support/AbstractApplicationContext.java#L612
[AbstractApplicationContext#prepareBeanFactory]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/support/AbstractApplicationContext.java#L626
[AnnotationConfigEmbeddedWebApplicationContext#postProcessBeanFactory]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/context/embedded/AnnotationConfigEmbeddedWebApplicationContext.java#L180
[AbstractApplicationContext#invokeBeanFactoryPostProcessors]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/support/AbstractApplicationContext.java#L685
[AbstractApplicationContext#registerBeanPostProcessors]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/support/AbstractApplicationContext.java#L701
[AbstractApplicationContext#initMessageSource]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/support/AbstractApplicationContext.java#L709
[AbstractApplicationContext#initApplicationEventMulticaster]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/support/AbstractApplicationContext.java#L744
[AbstractApplicationContext#onRefresh]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/support/AbstractApplicationContext.java#L798
[AbstractApplicationContext#registerListeners]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/support/AbstractApplicationContext.java#L806
[AbstractApplicationContext#finishBeanFactoryInitialization]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/support/AbstractApplicationContext.java#L833
[AbstractApplicationContext#finishRefresh]:    https://github.com/spring-projects/spring-framework/blob/v4.3.5.RELEASE/spring-context/src/main/java/org/springframework/context/support/AbstractApplicationContext.java#L874
[SpringApplication#afterRefresh]:    https://github.com/spring-projects/spring-boot/blob/v1.4.3.RELEASE/spring-boot/src/main/java/org/springframework/boot/SpringApplication.java#L769
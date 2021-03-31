---
title:      Tomcat初始化流水账
layout:     post
category:   blog
tags:       [tomcat, java]
---


>TL;DR
>
>Tomcat版本为8.0.28

1. org.apache.catalina.startup.BootStrap
    1. 初始化`catalina.home` 
        1. 获取参数`catalina.home`，判断相应目录是否存在，若不存在则
        1. 查看当前工作目录是否存在bootstrap.jar文件，若存在，则以父目录作为`catalina.home`的值，否则
        1. 使用当前目录作为`catalina.home`的值
    1. 初始化`catalina.base`
        1. 获取参数`catalina.base`，若值不为空，则根据其值设置相应的变量，否则
        1. 设置为`catalina.home`的值
    1. 调用init方法，初始化类加载器
        1. 加载`catalina.properties`
        1. 创建common类加载器（commonLoader）
            1. 查询`common.loader`属性的值，拆解其中的类路径，根据创建`Repository`实例组
            1. 遍历`Repository`实例组，去重，创建URLClassLoader实例
        1. 创建server类加载器（catalinaLoader）
            1. 查询`server.loader`属性的值，拆解其中的类路径，根据创建`Repository`实例组
            1. 遍历`Repository`实例组，去重，创建URLClassLoader实例
        1. 创建shared类加载器（sharedLoader）
            1. 查询`shared.loader`属性的值，拆解其中的类路径，根据创建`Repository`实例组
            1. 遍历`Repository`实例组，去重，创建URLClassLoader实例
        1. 设置线程上下文类加载器为`catalinaLoader`
        1. 使用`catalinaLoader`加载基础类
            1. loadCorePackage
                * org.apache.catalina.core.AccessLogAdapter
                * org.apache.catalina.core.ApplicationContextFacade$1
                * org.apache.catalina.core.ApplicationDispatcher$PrivilegedForward
                * org.apache.catalina.core.ApplicationDispatcher$PrivilegedInclude
                * org.apache.catalina.core.AsyncContextImpl
                * org.apache.catalina.core.AsyncContextImpl$DebugException
                * org.apache.catalina.core.AsyncContextImpl$1
                * org.apache.catalina.core.AsyncListenerWrapper
                * org.apache.catalina.core.ContainerBase$PrivilegedAddChild
                * org.apache.catalina.core.DefaultInstanceManager$1
                * org.apache.catalina.core.DefaultInstanceManager$2
                * org.apache.catalina.core.DefaultInstanceManager$3
                * org.apache.catalina.core.DefaultInstanceManager$AnnotationCacheEntry
                * org.apache.catalina.core.DefaultInstanceManager$AnnotationCacheEntryType
                * org.apache.catalina.core.ApplicationHttpRequest$AttributeNamesEnumerator
            1. loadCoyotePackage
                * org.apache.coyote.http11.AbstractOutputBuffer$1
                * org.apache.coyote.http11.Constants
                * org.apache.coyote.Constants
            1. loadLoaderPackage
                * org.apache.catalina.loader.WebappClassLoaderBase$PrivilegedFindResourceByName
            1. loadRealmPackage
                * org.apache.catalina.realm.LockOutRealm$LockRecord
            1. loadServletsPackage
                * org.apache.catalina.servlets.DefaultServlet
            1. loadSessionPackage
                * org.apache.catalina.session.StandardSession
                * org.apache.catalina.session.StandardSession$1
                * org.apache.catalina.session.StandardManager$PrivilegedDoUnload
            1. loadUtilPackage
                * org.apache.catalina.util.ParameterMap
                * org.apache.catalina.util.RequestUtil
            1. loadValvesPackage
                * org.apache.catalina.valves.AbstractAccessLogValve$3
            1. loadJavaxPackage
                * javax.servlet.https.Cookie
            1. loadConnectorPackage
                * org.apache.catalina.connector.RequestFacade$GetAttributePrivilegedAction
                * org.apache.catalina.connector.RequestFacade$GetParameterMapPrivilegedAction
                * org.apache.catalina.connector.RequestFacade$GetRequestDispatcherPrivilegedAction
                * org.apache.catalina.connector.RequestFacade$GetParameterPrivilegedAction
                * org.apache.catalina.connector.RequestFacade$GetParameterNamesPrivilegedAction
                * org.apache.catalina.connector.RequestFacade$GetCharacterEncodingPrivilegedAction
                * org.apache.catalina.connector.RequestFacade$GetHeadersPrivilegedAction
                * org.apache.catalina.connector.RequestFacade$GetHeaderNamesPrivilegedAction
                * org.apache.catalina.connector.RequestFacade$GetCookiesPrivilegedAction
                * org.apache.catalina.connector.RequestFacade$GetLocalePrivilegedAction
                * org.apache.catalina.connector.RequestFacade$GetLocalesPrivilegedAction
                * org.apache.catalina.connector.ResponseFacade$SetContentTypePrivilegedAction
                * org.apache.catalina.connector.ResponseFacade$DateHeaderPrivilegedAction
                * org.apache.catalina.connector.RequestFacade$GetSessionPrivilegedAction
                * org.apache.catalina.connector.ResponseFacade$1
                * org.apache.catalina.connector.OutputBuffer$1
                * org.apache.catalina.connector.CoyoteInputStream$1
                * org.apache.catalina.connector.CoyoteInputStream$2
                * org.apache.catalina.connector.CoyoteInputStream$3
                * org.apache.catalina.connector.CoyoteInputStream$4
                * org.apache.catalina.connector.CoyoteInputStream$5
                * org.apache.catalina.connector.InputBuffer$1
                * org.apache.catalina.connector.Response$1
                * org.apache.catalina.connector.Response$2
                * org.apache.catalina.connector.Response$3
            1. loadTomcatPackage
                * org.apache.tomcat.util.buf.HexUtils
                * org.apache.tomcat.util.buf.StringCache
                * org.apache.tomcat.util.buf.StringCache$ByteEntry
                * org.apache.tomcat.util.buf.StringCache$CharEntry
                * org.apache.tomcat.util.https.FastHttpDateFormat
                * org.apache.tomcat.util.https.HttpMessages
                * org.apache.tomcat.util.https.parser.HttpParser
                * org.apache.tomcat.util.https.parser.MediaType
                * org.apache.tomcat.util.https.parser.MediaTypeCache
                * org.apache.tomcat.util.https.parser.SkipResult
                * org.apache.tomcat.util.net.Constants
                * org.apache.tomcat.util.net.DispatchType
                * org.apache.tomcat.util.net.NioBlockingSelector$BlockPoller$1
                * org.apache.tomcat.util.net.NioBlockingSelector$BlockPoller$2
                * org.apache.tomcat.util.net.NioBlockingSelector$BlockPoller$3
                * org.apache.tomcat.util.security.PrivilegedGetTccl
                * org.apache.tomcat.util.security.PrivilegedSetTccl
        1. 通过反射创建`org.apache.catalina.startup.Catalina`实例（startupInstance）
        1. 通过反射，以`sharedLoader`为实参，调用`org.apache.catalina.startup.Catalina`实例（startupInstance）的setParentClassLoader方法
        1. 将`catalinaDaemon`属性设置为`org.apache.catalina.startup.Catalina`实例（startupInstance）
    1. 加载配置，调用`org.apache.catalina.startup.Catalina#load`方法完成
1. org.apache.catalina.startup.Catalina
    1. 使用`Digester`库解析`server.xml`文件
        1. 创建`org.apache.tomcat.util.digester.Digester`实例
        1. 加载各种Rule，根据`server.xml`文件的内容层次结构，设定遇到哪些标签时应该创建哪些实例
            * Server -> `org.apache.catalina.core.StandardServer`
                * Server/GlobalNamingResources -> `org.apache.catalina.deploy.NamingResourcesImpl`
                    * Server/GlobalNamingResources/Ejb -> `org.apache.tomcat.util.descriptor.web.ContextEjb`
                    * Server/GlobalNamingResources/Environment -> `org.apache.tomcat.util.descriptor.web.ContextEnvironment`
                    * Server/GlobalNamingResources/LocalEjb -> `org.apache.tomcat.util.descriptor.web.ContextLocalEjb`
                    * Server/GlobalNamingResources/Resource -> `org.apache.tomcat.util.descriptor.web.ContextResource`
                    * Server/GlobalNamingResources/ResourceEnvRef -> `org.apache.tomcat.util.descriptor.web.ContextResourceEnvRef`
                    * Server/GlobalNamingResources/ServiceRef -> `org.apache.tomcat.util.descriptor.web.ContextService`
                    * Server/GlobalNamingResources/Transaction -> `org.apache.tomcat.util.descriptor.web.ContextTransaction`
                * Server/Listener -> `org.apache.catalina.LifecycleListener`，监听器的具体类型由`className`属性决定
                * Server/Service -> `org.apache.catalina.core.StandardService`
                    * Server/Service/Listener -> `org.apache.catalina.LifecycleListener`，监听器的具体类型由`className`属性决定
                    * Server/Service/Executor -> `org.apache.catalina.core.StandardThreadExecutor`
                    * Server/Service/Connector -> `org.apache.catalina.connector.Connector`
                        * 根据不同协议（`protocol`属性的值）创建协议处理器
                            * APR available
                                * HTTP/1.1 -> `org.apache.coyote.http11.Http11AprProtocol`
                                * AJP/1.3 -> `org.apache.coyote.ajp.AjpAprProtocol`
                                * 直接以`protocol`的值作为连接器实现类的类名
                                * protocol is null -> `org.apache.coyote.http11.Http11AprProtocol`
                            * APR not available
                                * HTTP/1.1 -> `org.apache.coyote.http11.Http11NioProtocol`
                                * AJP/1.3 -> `org.apache.coyote.ajp.AjpNioProtocol`
                                * 直接以`protocol`的值作为连接器实现类的类名
                        * Server/Service/Connector/Listener -> `org.apache.catalina.LifecycleListener`，监听器的具体类型由`className`属性决定
                    * Server/Service/Engine -> `org.apache.catalina.core.StandardEngine`
                        * Server/Service/Engine/Cluster -> `org.apache.catalina.Cluster`，根据属性名确定使用哪种集群管理器
                            * Server/Service/Engine/Cluster/Manager -> `org.apache.catalina.ha.ClusterManager`，具体类型由`className`属性决定
                                * Server/Service/Engine/Cluster/Manager/SessionIdGenerator -> `org.apache.catalina.util.StandardSessionIdGenerator`，`JSESSIONID`生成器
                            * Server/Service/Engine/Cluster/Channel -> `org.apache.catalina.tribes.Channel`，具体类型由`className`属性决定
                                * Server/Service/Engine/Cluster/Channel/Membership -> `org.apache.catalina.tribes.MembershipService`，具体类型由`className`属性决定
                                * Server/Service/Engine/Cluster/Channel/Sender -> `org.apache.catalina.tribes.ChannelSender`，具体类型由`className`属性决定
                                    * Server/Service/Engine/Cluster/Channel/Sender/Transport -> `org.apache.catalina.tribes.transport.MultiPointSender`，具体类型由`className`属性决定
                                * Server/Service/Engine/Cluster/Channel/Receiver -> `org.apache.catalina.tribes.ChannelReceiver`，具体类型由`className`属性决定
                                * Server/Service/Engine/Cluster/Channel/Interceptor -> `org.apache.catalina.tribes.ChannelInterceptor`，具体类型由`className`属性决定
                                    * Server/Service/Engine/Cluster/Channel/Interceptor/Member -> `org.apache.catalina.tribes.Member`，具体类型由`className`属性决定
                            * Server/Service/Engine/Cluster/Valve -> `org.apache.catalina.Valve`，具体类型由`className`属性决定
                            * Server/Service/Engine/Cluster/Deployer -> `org.apache.catalina.ha.ClusterDeployer`，具体类型由`className`属性决定
                            * Server/Service/Engine/Cluster/Listener -> `org.apache.catalina.LifecycleListener`，具体类型由`className`属性决定
                            * Server/Service/Engine/Cluster/ClusterListener -> `org.apache.catalina.ha.ClusterListener`，具体类型由`className`属性决定
                        * Server/Service/Engine/Listener -> `org.apache.catalina.LifecycleListener`，监听器的具体类型由`className`属性决定
                        * Server/Service/Engine/Valve -> `org.apache.catalina.Valve`，具体类型由`className`属性决定
                        * Server/Service/Engine/Host -> 创建主机
                            * Server/Service/Engine/Host/Context -> `org.apache.catalina.core.StandardContext`
                                * Server/Service/Engine/Host/Context/Listener -> `org.apache.catalina.LifecycleListener`， 监听器的具体类型由`className`属性决定
                                * Server/Service/Engine/Host/Context/Loader -> `org.apache.catalina.loader.WebappLoader`, 监听器的具体类型由`className`属性决定
                                * Server/Service/Engine/Host/Context/Manager -> `org.apache.catalina.session.StandardManager`
                                    * Server/Service/Engine/Host/Context/Manager/Store -> `org.apache.catalina.Store`， 具体存储类型由`className`属性决定
                                    * Server/Service/Engine/Host/Context/Manager/SessionIdGenerator -> `org.apache.catalina.util.StandardSessionIdGenerator`， `JSESSIONID`生成器
                                * Server/Service/Engine/Host/Context/Parameter -> `org.apache.tomcat.util.descriptor.web.ApplicationParameter`
                                * Server/Service/Engine/Host/Context/Resources -> `org.apache.catalina.webresources.StandardRoot`
                                    * Server/Service/Engine/Host/Context/Resources/PreResources -> `org.apache.catalina.WebResourceSet`，具体类型由`className`属性决定
                                    * Server/Service/Engine/Host/Context/Resources/JarResources -> `org.apache.catalina.WebResourceSet`，具体类型由`className`属性决定
                                    * Server/Service/Engine/Host/Context/Resources/PostResources -> `org.apache.catalina.WebResourceSet`，具体类型由`className`属性决定
                                * Server/Service/Engine/Host/Context/ResourceLink -> `org.apache.tomcat.util.descriptor.web.ContextResourceLink`
                                * Server/Service/Engine/Host/Context/Valve -> `org.apache.catalina.Valve`，具体类型由`className`属性决定
                                * Server/Service/Engine/Host/Context/JarScanner -> `org.apache.tomcat.util.scan.StandardJarScanner`
                                    * Server/Service/Engine/Host/Context/JarScanner/JarScanFilter -> `org.apache.tomcat.util.scan.StandardJarScanFilter`
                                * Server/Service/Engine/Host/Context/CookieProcessor -> `org.apache.tomcat.util.https.LegacyCookieProcessor`
                                * Server/Service/Engine/Host/Context/Ejb -> `org.apache.tomcat.util.descriptor.web.ContextEjb`
                                * Server/Service/Engine/Host/Context/Environment -> `org.apache.tomcat.util.descriptor.web.ContextEnvironment`
                                * Server/Service/Engine/Host/Context/LocalEjb -> `org.apache.tomcat.util.descriptor.web.ContextLocalEjb`
                                * Server/Service/Engine/Host/Context/Resource -> `org.apache.tomcat.util.descriptor.web.ContextResource`
                                * Server/Service/Engine/Host/Context/ResourceEnvRef -> `org.apache.tomcat.util.descriptor.web.ContextResourceEnvRef`
                                * Server/Service/Engine/Host/Context/ServiceRef -> `org.apache.tomcat.util.descriptor.web.ContextService`
                                * Server/Service/Engine/Host/Context/Transaction -> `org.apache.tomcat.util.descriptor.web.ContextTransaction`
                            * Server/Service/Engine/Host/Cluster -> 主机集群
                                * Server/Service/Engine/Host/Cluster/Manager -> `org.apache.catalina.ha.ClusterManager`，具体类型由`className`属性决定
                                    * Server/Service/Engine/Host/Cluster/Manager/SessionIdGenerator -> `org.apache.catalina.util.StandardSessionIdGenerator`，`JSESSIONID`生成器
                                * Server/Service/Engine/Host/Cluster/Channel -> `org.apache.catalina.tribes.Channel`，具体类型由`className`属性决定
                                    * Server/Service/Engine/Host/Cluster/Channel/Membership -> `org.apache.catalina.tribes.MembershipService`，具体类型由`className`属性决定
                                    * Server/Service/Engine/Host/Cluster/Channel/Sender -> `org.apache.catalina.tribes.ChannelSender`，具体类型由`className`属性决定
                                        * Server/Service/Engine/Host/Cluster/Channel/Sender/Transport -> `org.apache.catalina.tribes.transport.MultiPointSender`，具体类型由`className`属性决定
                                    * Server/Service/Engine/Host/Cluster/Channel/Receiver -> `org.apache.catalina.tribes.ChannelReceiver`，具体类型由`className`属性决定
                                    * Server/Service/Engine/Host/Cluster/Channel/Interceptor -> `org.apache.catalina.tribes.ChannelInterceptor`，具体类型由`className`属性决定
                                        * Server/Service/Engine/Host/Cluster/Channel/Interceptor/Member -> `org.apache.catalina.tribes.Member`，具体类型由`className`属性决定
                                * Server/Service/Engine/Host/Cluster/Valve -> `org.apache.catalina.Valve`，具体类型由`className`属性决定
                                * Server/Service/Engine/Host/Cluster/Deployer -> `org.apache.catalina.ha.ClusterDeployer`，具体类型由`className`属性决定
                                * Server/Service/Engine/Host/Cluster/Listener -> `org.apache.catalina.LifecycleListener`，具体类型由`className`属性决定
                                * Server/Service/Engine/Host/Cluster/ClusterListener -> `org.apache.catalina.ha.ClusterListener`，具体类型由`className`属性决定
    1. 设置`catalinaHome`和`catalinaBase`
    1. 重定向标准输出和标准错误到系统日志（`SystemLogHandler`）
    1. 初始化`server`（`org.apache.catalina.core.StandardServer`）
        1. 注册MBean(`type=StringCache`和`type=MBeanFactory`)
        1. 初始化`globalNamingResources`(`org.apache.catalina.deploy.NamingResourcesImpl`)
            * 注册MBean
        1. 初始化`services`(`org.apache.catalina.Service`)
            1. 初始化`container`
                * `org.apache.catalina.core.StandardEngine`
                * `org.apache.catalina.core.StandardHost`
                * `org.apache.catalina.core.StandardContext`
                * `org.apache.catalina.core.StandardWrapper`
            1. 初始化`executor`(`org.apache.catalina.core.StandardThreadExecutor`)
                * 注册MBean
            1. 初始化`mapperListener`(`org.apache.catalina.mapper.MapperListener`)
                * 注册MBean
            1. 初始化`connectors`
                * 注册MBean
                * 创建`org.apache.catalina.connector.CoyoteAdapter`实例，用于处理接收到的请求
                * 初始化`protocolHandler`
                    * `org.apache.coyote.ajp.AjpAprProtocol`
                    * `org.apache.coyote.ajp.AjpNio2Protocol`
                    * `org.apache.coyote.ajp.AjpNioProtocol`
                    * `org.apache.coyote.ajp.AjpProtocol`
                    * `org.apache.coyote.http11.Http11Nio2Protocol`
                    * `org.apache.coyote.http11.Http11NioProtocol`
                    * `org.apache.coyote.http11.Http11Protocol`
                    * `org.apache.coyote.http11.Http11AprProtocol`
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
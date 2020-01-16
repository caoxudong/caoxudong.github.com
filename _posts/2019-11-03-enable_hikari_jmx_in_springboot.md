---
title:      在SpringBoot中启用Hikari的JMX监控
layout:     post
category:   blog
tags:       [jmx, springboot, java, hikari]
---

一般情况下，SpringBoot中使用Hikari只需要在yaml文件中配置Hikari的数据源信息即可，例如

    spring:
        datasource:
            url: jdbc:mysql://localhost:3306/test
            username: foo
            password: bar
            hikari:
                connection-timeout: 30000
                minimum-idle: 5
                maximum-pool-size: 12
                idle-timeout: 300000
                max-lifetime: 1200000
                register-mbeans: true


不过，若是你需要手动创建数据源Bean，则很有可能会得到如下错误

    org.springframework.jmx.export.UnableToRegisterMBeanException: Unable to register MBean [HikariDataSource (HikariDataSource)] with key 'dataSource'; nested exception is javax.management.InstanceAlreadyExistsException: MXBean already registered with name com.zaxxer.hikari:type=PoolConfig (HikariDataSource)

错误的原因是，Hikari数据源的创建方法里自带了注册MBean的操作，而SpringBoot在初始化时会搜索所有Bean，并将可能是MBean的Bean注册为MBean（判断方法参见`org.springframework.jmx.support.JmxUtils#isMBean`方法，大意是判断这个类是否继承自`javax.management.DynamicMBean`，或者该类继承/实现了以某个"MBean"和或"MXBean"结尾的类/接口），从而导致重复注册MBean的错误。

解决方法是，将这个手动创建的Bean放到`org.springframework.jmx.export.MBeanExporter`的排除列表里，如下所示：

    @Configuration
    public class BeansConfig {
        @Resource
        private HikariDataSourceConfig hikariDataSourceConfig;
        @Resource
        private ObjectProvider<MBeanExporter> mBeanExporter;
        @Bean("dataSource")
        public DataSource createDataSource() {
            String url = hikariDataSourceConfig.getUrl();
            String username = hikariDataSourceConfig.getUsername();
            String password = hikariDataSourceConfig.getPassword();
            long idleTimeoutInMilliSeconds =
                    hikariDataSourceConfig.getIdleTimeOutInMilliseconds();
            long maxLifetimeInMilliseconds =
                    hikariDataSourceConfig.getMaxLifetimeInMilliseconds();
            int maximumPoolSize = hikariDataSourceConfig.getMaximumPoolSize();
            int minimumIdle = hikariDataSourceConfig.getMinimumIdle();
            String poolName = "HikariDataSource";
            HikariConfig hikariConfig = new HikariConfig();
            hikariConfig.setRegisterMbeans(true);
            hikariConfig.setJdbcUrl(url);
            hikariConfig.setUsername(username);
            hikariConfig.setPassword(password);
            hikariConfig.setIdleTimeout(idleTimeoutInMilliSeconds);
            hikariConfig.setMaxLifetime(maxLifetimeInMilliseconds);
            hikariConfig.setMaximumPoolSize(maximumPoolSize);
            hikariConfig.setMinimumIdle(minimumIdle);
            hikariConfig.setPoolName(poolName);
            HikariDataSource dataSource = new HikariDataSource(hikariConfig);
            mBeanExporter
                    .ifUnique((exporter) -> exporter.addExcludedBean("dataSource"));
            return dataSource;
        }
    }

这里指的注意的是，Bean的名字"dataSource"通过`mBeanExporter.ifUnique((exporter) -> exporter.addExcludedBean("dataSource"));`放入到排除列表里，这样就不会出现重复注册的问题了。
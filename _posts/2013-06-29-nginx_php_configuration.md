---
title:      nginx搭配php环境配置
category:   blog
layout:     post
tags:       [nginx, php]
---


下一步要做的开发需要用php完成，这里做个记录

# windows上开发测试

这里使用fast-cgi的方式使用php。

下载[nginx][1]和[php][2]，这里使用的是*nginx-1.2.7*和*php-5.4.11-Win32-VC9-x86*。

将nginx和php解压缩，分别置于`NGINX_HOME`和`PHP_HOME`。

修改nginx.conf配置为：

    worker_processes 1;
    error_log logs/error.log;
    events { 
        worker_connections 1024; 
    } 
    https { 
        include mime.types; 
        default_type application/octet-stream; 
        sendfile on; 
        keepalive_timeout 65; 
        server { 
            listen 80; 
            server_name localhost; 
    
            location / { 
                root E:/workspace/company/project/playerp2p_config/test; 
                index index.html index.htm index.php; 
            } 
            error_page 500 502 503 504 /50x.html; 
            location = /50x.html { 
                root html; 
            }
            location ~ .php$ { 
                root E:/workspace/company/project/playerp2p_config/test; 
                fastcgi_pass 127.0.0.1:9000; 
                fastcgi_index index.php; 
                fastcgi_param SCRIPT_FILENAME E:/workspace/company/project/playerp2p_config/test/$fastcgi_script_name; 
                include fastcgi_params; 
            } 
        } 
    }
    

复制php.ini-production为php.ini，并修改php.ini：

    763c763
    < cgi.fix_pathinfo=1
    ---
    > ;cgi.fix_pathinfo=1
    

启动 依次执行：

    $PHP_HOME/php-cgi.exe -b 127.0.0.1:9000 -c $PHP_HOME/php.ini 
    $NGINX_HOME/nginx
    

完成。

[1]:    https://nginx.org/
[2]:    https://php.net/

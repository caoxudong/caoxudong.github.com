---
title:      nginx配置反向代理，并启用SSL
layout:     post
category:   blog
tags:       [nginx, ssl, https]
---

这里使用**let's encrypt**的证书，使用cerboot安装和更新证书。参考官网例子：

    # 安装cerboot
    $ sudo apt-get update
    $ sudo apt-get install software-properties-common
    $ sudo add-apt-repository universe
    $ sudo add-apt-repository ppa:certbot/certbot
    $ sudo apt-get update
    $ sudo apt-get install certbot python-certbot-nginx 
    $ sudo certbot --nginx

    #renewal, crontab
    * */12 * * * certbot renew --noninteractive --renew-hook /etc/letsencrypt/renewhook.sh

配置nginx：

    upstream localhost {
        server 127.0.0.1:8080;
    }

    server {
        listen 80;
        server_name your-domain.com;
        index index.html index.htm index.jsp index.php;
        charset utf-8;
        access_log /data1/log/nginx/access.log;
        error_log  /data1/log/nginx/error.log error;
        # https -> https
        location / {
            return  301  https://$server_name$request_uri;
        }
        # validation for renew cert
        location ~ /.well-known/acme-challenge/ {
            root "/var/www/letsencrypt";
            allow all;
        }
    }

    server {
        listen      443 ssl http2;
        server_name your-domain.com;
        include /etc/nginx/snippets/letsencrypt.conf;
        index index.html index.htm index.php;
        charset utf-8;
        ssl_certificate /etc/letsencrypt/live/your-domain/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/your-domain/privkey.pem;
        ssl_trusted_certificate /etc/letsencrypt/live/your-domain/fullchain.pem;
        include /etc/nginx/snippets/ssl.conf;
        access_log /data1/log/nginx/access.log;
        error_log  /data1/log/nginx/error.log error;
        location / {
        proxy_pass https://localhost;
            proxy_set_header X-Real-IP $remote_addr;
            add_header X-Slave $upstream_addr;
        }
    }





# Resources

* https://letsencrypt.org/getting-started/
* https://certbot.eff.org/lets-encrypt/ubuntuxenial-nginx
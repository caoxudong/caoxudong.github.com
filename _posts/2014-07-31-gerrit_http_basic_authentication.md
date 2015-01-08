---
category:   pages
layout:     post
tags:       [git, gerrit]
---


切换gerrit的认证方式为http
========


>gerrit版本为2.8.3

之前在使用gerrit的时候，一直使用的是openid的认证方式，可怜公司使用的google的企业账户，做openid认证时，被功夫网虐的一塌糊涂，各种连接不上，终于下决心换成http认证的。

先配置nginx：

    server {
        #proxy server for gerrit
        listen   80; ## listen for ipv4; this line is default and implied
        listen   [::]:88 default ipv6only=on; ## listen for ipv6
    
        index index.html index.htm;
    
        # Make site accessible from http://localhost/
        server_name localhost;
    
        location / {
            stub_status on;
            auth_basic "Sign in";
            auth_basic_user_file /home/public_internal/etc/nginx/httppassword;
            proxy_pass http://yourhost:yourport;
        }

        error_page 404 /404.html;
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root /usr/share/nginx/www;
        }
    }

其实换成http的认证方式比较简单，参照下面的内容修改gerrit.config文件：

    [gerrit]
        basePath = /home/public_internal/repository/git_repository
        canonicalWebUrl = http://yourhost:yourport/
    [database]
        type = mysql
        hostname = your_db_host
        port = 3506
        database = gerrit_db
        username = username
    [auth]
        type = HTTP
        emailFormat = {0}@your_mail_host
        logoutUrl = /logout
    [sendemail]
        enabled = true
        smtpServer = smtp.yourhost.com
        smtpServerPort = 465
        smtpEncryption = ssl
        smtpUser = user@example.com
        sslVerify = false
        from = git_admin<user@example.com>
    [container]
        user = public_internal
        javaHome = /usr/local/java/jdk1.7.0_51/jre
    [sshd]
        listenAddress = *:29418
    [httpd]
        listenUrl = proxy-http://yourhost:yourport/
    [cache]
        directory = cache
    [gitweb]
        cgi = /usr/share/gitweb/gitweb.cgi

然后，还需要修改原先在gerrit_db数据库中存储的用户登录信息，这里只涉及到`account_external_ids`表的内容。

根据gerrit的文档，使用openid方式时，每个用户在`account_external_ids`表中`external_id`字段存储的内容包括两条，例如：

    account_id    email_address           password        external_id
    14            caoxudong818@gmail.com  null            gerrit:caoxudong
    14            null                    uXIBamf9tzJi    https://www.google.com/accounts/o8/id?id=AItOawmH_ska5aUqh8RXN7JkPiSoo2S6rsC6KSw

这里需要修改的地方是，将`external_id`中的openid内容换成http basic认证的用户名，修改后的数据为：

    account_id    email_address           password        external_id
    14            caoxudong818@gmail.com  null            gerrit:caoxudong
    14            null                    uXIBamf9tzJi    username:caoxudong

OK，然后重启gerrit和nginx即可。


>[这里][1]贴一个密码的批量生成脚本，其中使用到了Apache的`httppassword`工具




[1]:    https://gist.github.com/caoxudong/1ea26b67bd6b0e1bd682
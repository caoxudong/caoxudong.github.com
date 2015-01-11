---
title:      struts2应用中URL里面含有“static”时无法访问
layout:     post
category:   blog
tags:       [java, struts2]
---


原文地址： <http://caoxudong818.iteye.com/admin/blogs/1137571>

今天在同事的应用出了一个小错误，与struts2有关，这里记录一下。

描述：web应用下有一个目录“static”，现在要访问其中的“top.html”文件，即访问“localhost:8080/static/top.html”，服务器总是报404错误。

原因：在struts2的FilterDispatcher类的doFilter方法中，如果请求的是静态资源，struts2会判断该请求是否可以处理，这里的代码如下：

    String resourcePath = RequestUtils.getServletPath(request);
    if ("".equals(resourcePath) && null != request.getPathInfo()) {
        resourcePath = request.getPathInfo();
    }
    if (staticResourceLoader.canHandle(resourcePath)) {
        staticResourceLoader.findStaticResource(resourcePath, request, response);
    } else {
        // this is a normal request, let it pass through
        chain.doFilter(request, response);
    }
    // The framework did its job here
    return;
    



其中，在DefaultStaticContentLoader类的canHandle方法中会对请求路径进行判断:

    public boolean canHandle(String resourcePath) {
        return serveStatic &&(resourcePath.startsWith("/struts") || resourcePath.startsWith("/static"));
    }
    

这里，serveStatic的值为true，再加上要访问的资源以“/static”开头，所以这里返回true。

然后，会进入DefaultStaticContentLoader类的findStaticResource方法，该方法的第一行语句是：

    String name = cleanupPath(path);
    

这里，cleanupPath方法的定义如下：

    /**
     * @param path requested path
     * @return path without leading "/struts" or "/static"
     */
    protected String cleanupPath(String path) {
        //path will start with "/struts" or "/static", remove them
        return path.substring(7);
    }
    

struts2把“/static”截掉了，这样，后面再进行解析的时候，就变成了解析对“/top.html”的请求，所以会报404错误。

总结：悲剧的错误，还以为是自己程序的bug，改了半天。需要加强对开源程序中具体实现的了解。
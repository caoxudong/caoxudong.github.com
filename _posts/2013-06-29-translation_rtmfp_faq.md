---
title:      译文 —— RTMFP FAQ
category:   blog
layout:     post
tags:       [flash, p2p, rtmfp, translation]
---



译文 —— RTMFP FAQ
===================


> 原文地址：<http://www.adobe.com/products/adobe-media-server-extended/rtmfp-faq.html>

# 什么是RTMFP（Real-Time Media Flow Protocol）？

RTMFP是Adobe公司开发一种网络协议，它使用户可以进行点对点的直接、实时通信。

# RTMFP何时可用？使用RTMFP有什么要求？

RTMFP需要Adobe Flash Player 10或更高版本，或者使用Adobe AIR 1.5或更高版本，同时还需要RTMFP服务器来接收客户端请求或发布客户端信息。 Adobe Flash Media Server 4或更高版本支持RTMFP。更多内容请参见[Adobe Media Server][1]

# Flash Player 10和AIR 1.5提供了哪些新功能？

通过RTMFP，依赖于实时信息的应用程序之间，如社交网络和多人在线游戏，可以传输更高质量的信息。Flash Player 10和AIR 1.5及其后版本使终端用户可以通过电脑的麦克风和网络摄像机直接进行交流。Flash Player 10和AIR 1.5不支持文件共享。

# RTMFP有哪些优点？

使用RMTFP可以有效减少直接、实时通信，例如音频、视频聊天和多人在线游戏，所使用的带宽。此外，由于RTMFP使用户之间可以不经过服务器直接进行通信，因此具有较好的伸缩性。

RTMFP提升了使用UDP（User Datagram Protocol）通信的传输质量。在互联网中，UDP可以更有效的进行通信、发送音频/视频数据，而且当网络中有异常发生时也不会使连接中断。

RTMFP连接的可靠性优于其他协议（如TCP）的原因在于：

*   连接快速恢复： 当连接中断时，可以快速恢复，重新建立新的连接
*   IP机动性：即使客户端更换了IP地址，当前网络的session也不会断开。例如，网线环境下，笔记本电脑插上网线，更换了IP地址，连接也不会断开。这对实时通信和直播来说非常重要。

# 什么是RTMP（Real-Time Media Protocol）？

RTMP是Adobe公司开发的一种双通道专有协议，允许Flash Player和服务器之间通过互联网以流的形式进行音频/视频和数据传输。

# RTMFP与RTMP有什么区别？

最主要的区别在于，协议是如何通信的。RTMFP是基于UDP的，RTMP是基于TCP的。相比于基于TCP的协议，基于UDP的协议所具有的重要优势在于：

*   更高效的流媒体传输
*   更低的延迟
*   更高的视频/音频质量
*   更高的可靠性

不同于RTMP，RTMFP支持Adobe Flash Player客户端之间可以不经过服务器，直接发送数据。终端用户之间建立初始连接之前，需要与服务器建立一条连接，以便接收由服务器提供的数据和其他终端用户地址。Adobe Media Server还位客户端需要验证网络地址检索和NAT遍历服务的有效性，防止Flash Player被非法使用。

使用RTMP，终端用户需要通过服务器进行通信 

!["Communication today using RTMP — end users connect and communicate through the server"][2]

使用RTMFP，终端用户可以至今进行通信，减少了带宽消耗

!["Communication using RTMFP — end users connect directly, which reduces bandwidth needs"][3]

# RTMFP有哪些使用案例？

RTMFP使实时通信的能力更强，质量更高，应用场景包括网络电话（Voice over Internet Protocol，VoIP），网络视频聊天，多人在线游戏等。（具体介绍略）

# 什么是UDP（User Datagram Protocol）？为什么UDP对RTMFP很重要？

UDP是一个高效的网络传输协议，可以进行部分有效的、有部分损失的媒体数据传输。不同于TCP，UDP不会试图恢复在传输中丢失的数据，从而使视频/音频可以实时传输，不会因为网络延迟而造成视频/音频播放的延迟，而这一点在实时应用程序中具有很高的优先级。而TCP会等待还没有接收到的数据包，这就会造成播放的延迟。此外，UDP还支持在NAT路由保护下的大型企业网络中进行通信，而TCP无法办到。更多内容参见[wiki][4]

RTMFP与其他基于UDP的传输协议的区别在于它将多媒体流的传输的优先级设为最高。

# 什么是TCP（Transmission Control Protocol）？

TCP是网页浏览、文件传输和电子邮件应用所使用的互联网协议。今天，TCP用于web服务器的HTTP协议和用于发送视频/音频和其他来自与Adobe Media Server和AIR数据的RTMP协议。由于TCP传输的可靠性，所以非常有用，但可靠性增加了传输延迟，降低了实时媒体流的质量。更多内容参见[wiki][5]

# RTMFP如何保证地址安全，保护用户隐私？

RTMFP中的网络传输都是经过128位密钥加密的。客户端若想要播放经由RTMFP发布的媒体流，就需要知道流的名字和发布者的Peer ID。ID是一个256位的数字，其生成方式与发布者身份相关。此外，在建立连接之前，发布者需要先接收peer请求。

# 什么是P2P（peer-to-peer）计算？

在技术行业中，P2P有多种含义，但一般情况下是指建立与两个或多个终端用户之间，旨在传输数据和媒体的连接。

目前有3中类型的P2P方案：

*   端对端（End user to end user）

为降低延迟，实现实时通信，客户端不经过服务器，直接进行通信。这是Adobe使用RTMFP推出的解决方案。

*   swarming

这种类型的正式名称是"多对多"通信，通常用于以下载的方式共享文件。swarming通过收集文件块和并同时从不同用户处下载文件块来加速文件传输速度。一般情况下，swarming需要一个单独的应用程序来定位和连接到其他有相关内容的终端用户。一般来说swarming程序需要文件系统的访问权限，因此RTMFP无法使用swarming。

*   多播（Multicast）

这种类型的正式名称是"一对多"通信。多播可以加速文件传输，降低网络负担，因为数据源只发送一次数据包就可以由大量用户接收到。网络中的节点只在必要时才会复制数据包给其他终端用户。RTMFP无法利用多播。

更多关于P2P的内容参见[wiki][6]。

RTMFP使用P2P技术确保高质量、高效率的网络传输。RTMFP中的连接是可管理的，即它需要服务器的授权。客户端在接收直接连接前必须要先连接到服务器。

# RTMFP与其他P2P应用，如BitTorrent和Kontiki，相同么？RTMFP可以通过与BitTorrent类似的P2P技术传输大文件么？

不同。这些技术都是基于swarming实现的，可以使用多个P2P通信连接在大量客户端之间共享文件。RTMFP是用户之间的直接连接，以便传输实时数据，而非文件。

# 开发人员如何利用RTMFP？

RTMFP使开发人员可以在终端用户之间直接建立连接，传输实时数据。对于C/S模式的连接，RTMFP与RTMP类似，因为RTMFP支持当前RTMP中Adobe Media Server的所有功能，包括实时流、录制、回放、共享对象和远程方法调用。

ActionScript开发人员可以使用AS 2.0或AS 3.0与将来版本的Adobe Media Server建立NetConnection对象。如果要与Flash Player 10客户端直接建立连接，就需要使用NetStream将Flash Player客户端注册为发布者或订阅者。

# RTMFP有哪些限制？

RTMFP无法利用swarming、多播、广播视频。它只能建立从本地视频/音频设备到电脑的连接。

# 还有哪些与RTMFP类似的技术么？

Adobe开发的RTMP与之最为相似。

# RTMFP对CDN（content delivery networks）有什么影响？

RTMFP对CDN没有影响。CDN致力于视频按需传输和大规模实施视频传输，而不是RTMFP所关注的终端用户之间的直接传输。CDN可以帮助RTMFP应用程序的用户初始化连接。

[1]:    http://www.adobe.com/products/adobe-media-server-family.html
[2]:    /image/rtmfp_faq01.jpg
[3]:    /image/rtmfp_faq02.jpg
[4]:    http://en.wikipedia.org/wiki/User_datagram_protocol
[5]:    http://en.wikipedia.org/wiki/Transmission_control_protocol
[6]:    http://en.wikipedia.org/wiki/Peer-to-peer

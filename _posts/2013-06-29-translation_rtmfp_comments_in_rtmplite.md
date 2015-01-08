---
category:   pages
layout:     post
tags:       [flash, p2p, rtmfp, translation]
---


译文 —— rtmplite项目中rtmfp协议部分注释
==================


> rtmplite项目地址： <https://code.google.com/p/rtmplite/>

# RTMFP

协议描述参见Matthew Kaufman的一个[slide][1]

## session

在rtmfp中，session表示了一个可以在两个UDP传输地址之间进行端对端、双向传输的管道。传输地址包含了IP地址和端口号，例如“192.1.2.3:1935”。

在一个session中可以包含一个或多个流（flow），其中流是一个实体通过0个或多个中间实体到达另一个实体的逻辑路径。

包含了经过加密的RTMFP数据的UDP数据包会通过session传递给另一个实体。每个数据包中都包含了一条或多条消息。数据包使用128位密钥的AES算法进行加密。

在下面的协议描述中，所有的数据都是用网络字节序，即大端序。操作符"|"表述数据连接。如果没有特别指明，数字都是无符号的。

## 混淆的session id(Scrambled Session ID)

数据包格式如下所示。

    packet := scrambled-session-id | encrypted-part
    

每个数据包的前32位都是混淆后的session-id，其后紧跟的是加密后的数据。

混淆后的session-id可有效防止中间层（如NAT和layer-4包检查器）破坏数据包（但不能完全阻止）。使用异或操作（XOR）和数据包的前3个32位数字生成混淆后的session-id，反解出session-id也比较容易。

混淆session-id

    scrambled-session-id = a^b^c
    

其中，^表示异或操作，a是原始session-id，b和c是encrypted-part的前8个字节所表示的2个32位数字。

反解出session-id

    session-id = x^y^z
    

其中，z是混淆后的session-id，x和y是encrypted-part的前8个字节所表示的2个32位数字。

session-id决定了要使用哪种密钥对数据进行加解密。在“握手”过程中，第4个消息中包含了非零的session-id，使用的是对称的session密钥来进行加解密。对其他握手消息来说，使用的是非对称的AES加解密，密钥为"Adobe System 02"（不包括双引号）。其后，session中的消息都是用了非对称的密钥进行加解密。

## Encryption

假设AES算法的密钥已知，则对每一个解密操作，初始化一个所有元素为0的vector；对于加密来说（假设原始数据部分已经准备好），也对每一个加密操作初始化一个所有元素为0的vector。解密操作无需字节对齐，此外，加密后的内容与原始内容的大小应该相同。

解密后的原始数据的格式如下所示：

    raw-part := checksum | network-layer-data | padding
    

其中，checksum是一个16位的校验和，其后是网络层数据和padding。

padding是0个或多个字节的'\xff'。由于使用了128位（16字节）的密钥，解密后的数据的字节数就是16的倍数，原始数据不足的字节用padding补齐。因此，padding的字节数总是小于16的，其计算方法如下：

    len(padding) = 16*N - len(network-layer-data) - 1
    

其中，N是一个正整数，使得`0 <= padding-size < 16`。

例如，如果网络层数据有84个字节，则padding的字节数就是`16*6-84-1=11`。这样，就可以凑成96个字节的待加密数据。

## Checksum

校验和共16位，是对网络层数据和padding组合进行计算所得。因此，加密时，应该先添加padding，然后添加校验和，再使用AES加密；解密时，先用AES解密，检查校验和，再剔除padding。其实通常情况下，无需剔除padding，因为网络层数据解码器会忽略padding。

校验和计算方法如下。连接网络层数据和padding作为一个16位数序列（如果数据包本身就是奇数个字节，则单独读取这最后一个字节）。将所有的16位数相加为一个32位数，再将该32位数的前16位和后16位数相加，所得结果的前16位再与本身相加。最后，将和的后16位作为校验和。

下面的代码是Cumulus中对校验和的计算方法

    UInt16 RTMFP::CheckSum(PacketReader& packet) {
        int sum = 0;
        int pos = packet.position();
        while(packet.available()>0)
            sum += packet.available()==1 ? packet.read8() : packet.read16();
        packet.reset(pos);
    
        /* add back carry outs from top 16 bits to low 16 bits */
        sum = (sum >> 16) + (sum & 0xffff);     /* add hi 16 to low 16 */
        sum += (sum >> 16);                     /* add carry */
        return ~sum; /* truncate to 16 bits */
    }
    

## 网络层数据（Network Layer Data）

网络层数据包含标识（flag）、可选的时间戳、可选的时间戳回响（timestamp-echo），和一个或多个chunk：

    network-layer-data = flags | timestamp | timestamp-echo | chunks ...
    

标识的长度为1个字节，包含以下信息信息：

*   关键时间前向通知
*   关键时间反向通知
*   是否包含时间戳
*   是否包含时间戳回响
*   发起者/响应者标记

发起者/响应者标记用于使用对称session密钥，这样防止数据包被会送给发送者。

标识中，位的格式还不清楚，但下面的组合目前可用。在握手消息中，标识为`\x0b`。当标识最右侧4位的值是`1101`时，会包含时间戳回响。貌似时间戳总是会被包含在内。对于session中发送的消息，最后4位是`1101`或者`1001`。

    --------------------------------------------------------------------
     flags      meaning
    --------------------------------------------------------------------
     0000 1011  setup/handshake
     0100 1010  in-session no timestamp-echo (server to Flash Player)
     0100 1110  in-session with timestamp-echo (server to Flash Player)
     xxxx 1001  in-session no timestamp-echo (Flash Player to server)
     xxxx 1101  in-session with timestamp-echo (Flash Player to server)
    --------------------------------------------------------------------
    

TODO: 似乎`\x04`是指定是否包含时间戳回响的；`0x80`指定是否包含时间戳；最后两位若是`11`表明是正在握手，若是`10`表明是服务器给客户端发消息，若是`01`表明是客户端给服务器发消息。

时间戳是一个16位数字，其中包含的时间是4毫秒为1个时间单位。时钟时间用于生成该时间戳。例如，当前时间（以秒计算）为`time = 1319571285.9947701`，则时间戳计算方法为：

    int(time * 1000/4) & 0xffff = 46586
    

时间戳回响，也是一个时间戳值，用于计算RTT。

每个chunk都以一个8位的type开始，其后是16位的payload大小，后跟payload内容。注意，对于`type`的内容来说，`\xff`是保留、未使用的。这在检查网络层数据是否结束、padding是否开始时很有用，因为padding的内容都是`\xff`。其实，使用`\x00`作为padding也是可以的，因为`\x00`在type中也好似保留、未使用的。

    chunk = type | size | payload
    

## 消息流（Message Flow）

有3种session消息，建立（setup）、控制（control）和流（flow）。

建立是四次握手的一部分，控制和流是session内的消息。

### 建立消息

    initiator hello 
    responder hello 
    initiator initial keying 
    responder initial keying 
    responder hello cookie change 
    responder redirect
    

### 控制消息

    ping 
    ping reply 
    re-keying initiate 
    re-keying response 
    close 
    close acknowledge 
    forwarded initiator acknowledge 
    forwarded initiator hello
    

### 流消息

    user data
    next user data
    buffer probe
    user data ack(bitmap)
    user data ack(range)
    flow exception report
    

通过握手中session的建立消息来建立一个新的session。在一般的C/S模式下，消息流如下所示：

     initiator (client)                target (server)
        |-------initiator hello---------->|
        |<------responder hello-----------|
    

在P2P模式下，对于NAT traversal来说，服务器就好比是forwarder，将'hello'转给另一个已连接的客户端，如下所示：

     initiator (client)                forwarder (server)                     target (client) 
        |-------initiator hello---------->|                                       |
        |                                 |---------- forwarded initiator hello-->|
        |                                 |<--------- ack ----------------------->|
        |<------------responder hello---------------------------------------------|
    

此外，服务器也可以通过提供一个可选目标地址列表来进行重定向工作。

     initiator (client)                redirector (server)                     target (client) 
        |-------initiator hello---------->|                                   
        |<------responder redirect--------| 
        |-------------initiator hello-------------------------------------------->|
        |<------------responder hello---------------------------------------------|
    

注意，initiator、target、forwarder和redirecttor仅仅是建立过程中的角色，而客户端和服务器色是具体实现。服务器可以发送一个"initiator hello"给客户端，此时，服务器是initiator，客户端是target。

"initiator hello"可能会被转发给另一个目标，但是"responder hello"是直接发送的。此后，双方交换"initiator initial keying"和"responder initial keying"（initiator和responder直接交换），建立session key。四次握手可以防止DoS。

正如上面提到的，在session的建立消息中，使用对称AES密钥（密钥是"Adobe System 02"），而session内的消息则使用后来建立的非对称AES密钥。发送session建立消息以建立AES加密机制，它为这个新的session创建新的、非对称AES密钥。注意，session-id实在新session的密钥初始化过程中建立的，所以前3次消息发送（指initiator-hello，responder-hello和initiator-initial-keying）的session-id都是0，最后的"responder-initial-keying"使用了刚刚创建的session-id

## 消息类型（Message Types）

类型表如下：

    ---------------------------------
    type  meaning
    ---------------------------------
    \x30  initiator hello
    \x70  responder hello
    \x38  initiator initial keying
    \x78  responder initial keying
    \x0f  forwarded initiator hello
    \x71  forwarded hello response
    
    \x10  normal user data
    \x11  next user data
    \x0c  session failed on client side
    \x4c  session died
    \x01  causes response with \x41, reset keep alive
    \x41  reset times keep alive
    \x5e  negative ack
    \x51  some ack
    ---------------------------------
    

TODO: 似乎`\x01`标识否是包含传输地址

## 变长数据（Variable Length Data）

rtmfp使用了变长数据，其具体长度由一个表示数据长度的数字指定。数据长度是一个28位的无符号数，依据其所实际标识的值，可以被解码为1到4个字节。下面的示例中，该数字被分解为4个7位长的数字：

    number = 0000dddd dddccccc ccbbbbbb baaaaaaa (in binary)
    

其中，A=aaaaaaa, B=bbbbbbb, C=ccccccc, D=ddddddd

数据长度的表示如下所示：

    0aaaaaaa (1 byte)  if B = C = D = 0
    0bbbbbbb 0aaaaaaa (2 bytes) if C = D = 0 and B != 0
    0ccccccc 0bbbbbbb 0aaaaaaa (3 bytes) if D = 0 and C != 0
    0ddddddd 0ccccccc 0bbbbbbb 0aaaaaaa (4 bytes) if D != 0
    

这样，数据长度本身可以是1到4个字节，从而节省了网络带宽。

## 握手（Handshake）

消息"initiator-hello"包含了一个EPD（endpoint discriminator）和一个标签，格式如下：

    initiator-hello payload = first | epd | tag
    

其中`first`（8个字节）未知，接下来的EPD一个变长数据，包含了EPD类型（8位）和EPD数据。（注意，任何变长数据前都会有一个指明数据长度的值）。一般情况下，EPD长度小于127个字节。tag的长度为128位随机数。

    epd = epd-type | epd-value
    

epd-type的值是`\x0a`表示是C/S模式，`\x0f`标识P2P模式。如果是P2P模式，epd-value就是peer-id；如果是C/S模式，epd-value就是客户端连接的RTMFP URL。initiator设置epd-value，以便responder能辨别出"initiator-hello"是发给它而不是别人的。这种推断可以通过一次hash完成。

tag的内容是由initiator随机生成的，以便匹配session的建立消息。一旦建立完成，就可以无视tag了。

当目标接收到"initiator-hello"时，它要检查epd的内容，判断这否是发给自己的。如果是发给另一个目标的，就忽略掉该消息。如果当前目标是一个"introducer（服务器）"，那么可以给出响应，或者发送"forwarded-initiator-hello"消息给实际目标。通常情况下，目标会响应“responder-hello”。

"responder-hello"消息的内容包含，标签回响，新建的coookie和响应者证书，格式如下：

    responder-hello payload = tag-echo | cookie | responder-certificate
    

tag-echo与来自"initiator-hello"消息的原始标签相同，但使用变长数据存储。

cookie是随机的、无状态的变长数据，仅由响应者用来接收下一条消息（如果这条消息实际上是发起者接收的）。这可以消除"SYN flood"攻击的可能。如果服务器存储初始化状态，那么攻击者可以通过发送大量伪造的"initiator-hello"消息来消耗服务器资源。"SYN flood"常见于TCP服务中。

cookie的长度是64字节，使用变长数据存储。

responder-certificate是变长数据，包含一些未知数据，这些数据由应用程序的上层密码系统解释。在该应用程序中，使用了diffie-hellman (DH)作为密码系统。

注意，多个EPD可能会被映射到同一个目标，而目标本身只有一个证书。服务器不关心中间人攻击，也不会使用随机证书来创建安全EPD。

    certificate = \x01\x0A\x41\x0E | dh-public-num | \x02\x15\x02\x02\x15\x05\x02\x15\x0E
    

其中，dh-public-num是一个用于DH安全密钥交换的64字节的随机数。

在已经建立了session的情况下，发起者不会再对同一个响应者发起新的session。如果响应者检测到已经有了可用的session，就会将新的流请求放到这个session中，而不是创建新session。响应者不存储任何状态，也就无需关系session是否已经创建过（在实现中，为简化实现，存储了初始状态，这在后续的实现中可能会进行修改）。这也是为什么API是基于流的，而不是基于session的，以及session是由底层进行处理的原因。

如果发起者想保持session打开状态，需要发送"initiator-initial-keying"消息，格式如下：

    initiator-initial-keying payload = initiator-session-id | cookie-echo | initiator-certificate | initiator-component | 'X'
    

注意，payload以`\x58`（字符'X'）结束。

发起者以session-id（32位数字）来标识一个session，以此分离出接收到的数据包。响应者使用"initiator-session-id"作为"session-id"，生成混淆后的session-id，并在该session中发送数据。

cookie-echo是变长数据，由"responder-hello"中获得，这样就可以使响应者将该条消息与先前发送的"responder-hello"消息关联起来。只有当响应者认为cookie-echo有效时，才会处理该条信息。在创建cookie之后，如果源地址发生了变化，则响应者认为cookie-echo无效，此时它会发送cookie发生变化的消息给发起者。

在DH密码系统中，p和g是公开的。特殊地，g等于2，p是一个1024位长的数字。发起者生成一个随机的1024位长的私有数字（x1），以此创建1024位长的DH公开数(y1)。

    y1 = g ^ x1 % p
    

initiator-certificate由密码系统解释，包含了发起者的DH公开数，存储在最后的128个字节中。

initiator-component由密码系统解释，包含了用于DH算法的"initiator-nonc"。

当目标接收到这条消息后。它会生成一个新的1024位随机数作为DH私有数(x2)，和1024位的DH公开数(y2)

    y2 = g ^ x2 % p
    

现在，目标已经知道了发起者的公开数（y1）和它自己生成的共享数

    shared-secret = y1 ^ x2 % p
    

目标生成一个"responder-nonce"，并发回给发起者。

    responder-nonce = \x03\x1A\x00\x00\x02\x1E\x00\x81\x02\x0D\x02 | y2
    

peer-id是一个256位的SHA256证书。此时，响应者可以通过发起者证书获取peer-id。

目标使用一个新的32位的响应者的session-id分离出该session后续发来的数据包。此时，服务器创建一个新的session上下文来标识该session，并使用共享密钥、initiator-nonce和responder-nonce为该session创建非对称AES密钥。

    decode key = HMAC-SHA256(shared-secret, HMAC-SHA256(responder nonce, initiator nonce))[:16] 
    encode key = HMAC-SHA256(shared-secret, HMAC-SHA256(initiator nonce, responder nonce))[:16]
    

解码密钥由目标用于对接收到的、包含了该响应者的session-id的数据包进行解密。加密密钥用于对发出的数据包进行加密。实际上，只是用的密钥的前16字节用于AES的加密解密。

目标发送"responder-initial-keying"消息给发起者

    responder-initial-keying payload = responder session-id | responder's nonce | 'X'
    

注意，payload以`\x58`（字符'X'）结束，此外，这条消息使用对称AES进行加密，而非新创建的非对称AES密钥。

当发起者接收到该消息后，它也会为该session计算AES密钥。

    encode key = HMAC-SHA256(shared-secret, HMAC-SHA256(responder nonce, initiator nonce))[:16] 
    decode key = HMAC-SHA256(shared-secret, HMAC-SHA256(initiator nonce, responder nonce))[:16]
    

注意，实际只用到了前16字节用于加解密。发起者的加密密钥与响应者的解密密钥相同，发起者的加密密钥与响应者的加密密钥相同。

当服务器作为forwarder提供服务器时，它接收"initiator-hello"消息，发送"forwarded-initiator-hello"消息给目标

    forwarded initiator hello payload := first | epd | transport-address | tag
    

其中，first是一个8位数字，值为`\x22`。epd与"initiator-hello"中的相同，是一个变长数据，包含了epd-type和epd-value。其中，epd-type是`\x0f`，表示session是p2p类型的，epd-value是目标的peer-id，该值存储于原"initiator-hello"消息中的epd-value字段。

tag是一个16位长度的数值，是接收到"initiator-hello"的响应。

transport-address包含了一个标记（指明地址是私有还是公开的）、ip地址（以2进制表示）和端口号（可选）。

    transport-address := flag | ip-address | port-number
    

flag是一个8位数字。如果transport-address包含端口号，则最高位为1，否则为0。如果是公开地址，则最低两位为'10'，如果是私有IP地址，则最低两位为'01'。

IP地址可以是4字节（ipv4）或16字节（ipv6），均用2进制表示。

port-number是一个16位数字，如果flag中指明了含有端口号，则包含在transport-address总。

服务器会发送"forwarded-hello-response"消息给发起者：

    forwarded-hello-response = transport-address | transport-address | ...
    

该消息实际上是一个或多个transport-address，其中第一个是公开地址。

在此之后，发起者会将后续的数据包直接发给响应者。

"normal-user-data"消息用于处理流中任何消息，格式如下：

    normal-user-data payload := flags | flow-id | seq | forward-seq-offset | options | data
    

其中，flag是一个8位数组，指明参数属性和操作。具体内容参见下表：

    bit   meaning
    0x80  options are present if set, otherwise absent
    0x40
    0x20  with beforepart
    0x10  with afterpart
    0x08
    0x04
    0x02  abandon
    0x01  final
    

flow-id、seq和forward-seq-offset都是变长数据。flow-id是流标识符，seq是序列号，forward-seq-offset用于部分可靠的顺序传送（partially reliable in-order delivery）。

option中的内容只有当flag中指定了才会出现。option的内容如下所示：

TODO: 定义option

data使用"next-user-data"消息发送，格式如下：

    next-user-data := flags | data
    

当有多个数据消息在同一个数据包中发送时，会将用户数据进行压缩。flow-id、seq和forward-seq-offset合并，即flow-id是相同的，后继的"next-user-data"会增加seq和forward-seq-offset的值，取消option的内容。单一数据包不会包含来自多个流的数据，这样就避免了出现head-of-line阻塞的情况，而且当出现问题时可以反转优先级。

TODO: 完成对剩余消息流的说明。添加对中间人（man-in-middle）模式的描述，该模式使服务器可以传输音频/视频。

[1]:    http://www.ietf.org/proceedings/10mar/slides/tsvarea-1.pdf

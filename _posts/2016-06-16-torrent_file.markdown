---
title:      Torrent文件格式
layout:     post
category:   blog
tags:       [torrent, p2p, bencode]
---

>记录一下[torrent文件][1]的结构

# 1 B编码

>B编码解析库: [https://github.com/caoxudong/bencode][4]

torrent文件使用[B编码][2]存储，其内容通常包含多个待下载文件以及目标资源的元信息，可能还会包含一些tracker服务器信息。

>虽然比用纯二进制编码效率低，但由于结构简单而且不受字节存储顺序影响（所有数字以十进制编码）。这对于跨平台性非常重要。而且具有较好的灵活性，即使存在故障的字典键，只要将其忽略并更换新的就能兼容补充。

B编码包含4中数据类型：

* 字符串
* 整数
* 列表
* 字典

B编码使用ASCII字符作为定界符。

* 整数
    * 整数的基本格式为`i<ASCCI编码中的数字>e`
    * 不允许前导零（但0依然为整数0）
    * 负数在编码后直接加前导负号，不允许负零
    * 示例： 42 -> `i42e`, 0 -> `i0e`, -42 -> `i-42e`
* 字符串
    * 字符串以`（长度）:（内容）`编码
    * 长度的值和数字编码方法一样，只是不允许负数
    * 内容就是字符串的内容，如字符串`spam`就会编码为`4:spam`
    * 默认情况下，B编码的字符串只支持ASCII字符，
* 列表
    * 列表的基本格式为`l<contents>e`
    * 列表的内容可以是B编码所支持的任一中数据类型
    * 注意，列表中的各个元素之间是没有特定分隔符的
* 字典   
    * 字典的基本格式为`d<contents>e`
    * key必须是字符串类型，且按照字典顺序排列
    * 字典元素的key和value紧跟在一起，并无特殊分隔符
    * 示例： "bar->spam" -> `d3:bar4:spame`, "foo:42" -> `d3:fooi42ee`, "bar->spam, foo->42" -> `d3:bar4:spam3:fooi42ee`

列表和字典的取值范围并无限制，可以是其他列表或字典，以便组成复杂的数据结构

B编码的特点

* 数据内容和编码是[一一映射（双向单射）][3]的，应用程序可以在不解码的情况下完成数据对比的任务
* 不便于人类阅读
* 跨平台，非结构化

# 2 torrent文件

>解析torrent文件: [https://github.com/caoxudong/bencode/blob/master/src/test/java/bencode/parse/ParserTest.java#L252][5]

torrent文件内容格式如下，所有的字符串均使用UTF-8编码：

* announce: tracker服务器的地址
* announce-list: 
* created by: 创建者
* creation date: 创建时间
* encoding: UTF-8
* info: 待下载的文件信息
    * files:
        * length: 文件长度
        * path: 文件下载路径
    * name: 下载文件时所使用的文件名
    * piece length: 每个数据块的大小，通常是256KB
    * pieces:  哈希列表，包含了每个数据表的哈希值（SHA-1），将每个数据块的哈希值拼接在一起。由于SHA-1计算出的哈希值是160位的，因此pieces的值也是160的整数倍。如果torrent文件中包含了多个待下载文件，则这些文件的数据块的哈希值会按顺序排列在pieces中。


# 3 Resources

1. [Wiki: Torrent file][1]
1. [Wiki: Bencode][2]
1. [Wiki: Bijection][3]






[1]:    https://en.wikipedia.org/wiki/Torrent_file
[2]:    https://en.wikipedia.org/wiki/Bencode
[3]:    https://en.wikipedia.org/wiki/Bijection
[4]:    https://github.com/caoxudong/bencode
[5]:    https://github.com/caoxudong/bencode/blob/master/src/test/java/bencode/parse/ParserTest.java#L252
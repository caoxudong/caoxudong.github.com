---
title:      File.list()返回值的顺序
layout:     post
category:   blog
tags:       [java]
---

>JDK代码版本为JDK8u60


在获取目录中文件列表时，常用`File.List()`方法，该方法的注释中写到：

    There is no guarantee that the name strings in the resulting array
    will appear in any specific order; they are not, in particular,
    guaranteed to appear in alphabetical order.

即，方法返回的目录项并不保证是按照某种顺序排列的，实际内容取决于所使用文件系统。

## Windows系统

在Windows系统上，文件系统的实现类是[`WinNTFileSystem`][5]，获取目录内容最终是通过本地方法`WinNTFileSystem.list(File f)`实现的(参见[这里][1])。其中在搜索目录内容时，是通过[`FindFirstFileW`][3]方法和[`FindNextFileW`][2]方法完成的（他们是`FindFirstFile`方法和`FindNextFile`方法的Unicode版本。

在`FindNextFile`方法的说明文档中写到：

    This function uses the same search filters that were used to create the search handle passed in the hFindFile parameter. For additional information, see FindFirstFile and FindFirstFileEx.
    
    The order in which the search returns the files, such as alphabetical order, is not guaranteed, and is dependent on the file system. If the data must be sorted, the application must do the ordering after obtaining all the results.
    
    **Note** In rare cases or on a heavily loaded system, file attribute information on NTFS file systems may not be current at the time this function is called. To be assured of getting the current NTFS file system file attributes, call the GetFileInformationByHandle function.
    
    The order in which this function returns the file names is dependent on the file system type. With the NTFS file system and CDFS file systems, the names are usually returned in alphabetical order. With FAT file systems, the names are usually returned in the order the files were written to the disk, which may or may not be in alphabetical order. However, as stated previously, these behaviors are not guaranteed.

如上述内容所说，该方法也保证返回内容的顺序，实际结果取决于当前所使用的文件系统。在NTFS和CDFS文件系统上，返回值**通常**以字母顺序排列；在FAT文件系统上，返回内容**通常**是按照写入磁盘的顺序排列的，与字母顺序可能有关，也可能无关。因此函数返回的顺序并不可靠。

## Linux系统

在Linux系统上，`FileSystem`的实现类是[`UnixFileSystem`][4]，获取目录内容最终是通过本地方法`UnixFileSystem.list(File f)`实现的(参见[这里][6])。其中，在获取目录项的时候，是通过标准库函数`readdir_r`来实现的。

glibc对`readdir_r`的[说明文档][7]中也并未提到过和顺序相关的内容，因此在Linux上也不能保证返回内容是按照某种顺序排列的。





[1]:    https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/windows/native/java/io/WinNTFileSystem_md.c#l618    "`WinNTFileSystem.list(File f)"
[2]:    https://msdn.microsoft.com/en-us/library/windows/desktop/aa364428(v=vs.85).aspx    "FindNextFile "
[3]:    https://msdn.microsoft.com/en-us/library/windows/desktop/aa364418(v=vs.85).aspx    "FindFirstFileW"
[4]:    https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/solaris/classes/java/io/UnixFileSystem.java    "UnixFileSystem"
[5]:    https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/windows/classes/java/io/WinNTFileSystem.java    "WinNTFileSystem"
[6]:    https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/solaris/native/java/io/UnixFileSystem_md.c#l278    "UnixFileSystem_md.c#l278"
[7]:    https://www.gnu.org/software/libc/manual/html_node/Reading_002fClosing-Directory.html    "Reading and Closing a Directory Stream"
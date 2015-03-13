---
title:      Gerrit FAQ
category:   blog
layout:     post
tags:       [gerrit, git]
---


# 1 提交

## 1.1 如何生成结构干净的提交？

善用`rebase`可以使提交记录整齐干净，没有那些看着就让人烦躁的Merge提交，例如：

    Merge branch 'opsPolicy' of ssh://127.0.0.1:29418/flymaster_ops into ops

解决方案是在将代码提交到远程之前，先在本地针对远程分支执行一次`rebase`，将新提交的内容放到当前本地分支的尾部。在使用`rebase`命令时，加上参数`-i`，git会将需要应用的commit都列出来，以便选择实际需要的commit。完整操作如下：

方案一：

    $ vim Something.java
    $ git commit -am 'some comments'            (实际情况下，不要这么干，使用编辑器填写详细的提交信息)
    $ git pull --rebase                         (将远程库中的代码抓取到本地，再通过`rebase`的方式衍合到当前工作目录，而不是单纯的执行`merge`操作)    
    $ git push origin HEAD:refs/for/your_branch (现在你的本地分支应该是洁净如新的，没有烦人的Merge提交，可以推送到远程库进行审核了)

方案二：

    $ vim Something.java
    $ git commit -am 'some comments'            (实际情况下，不要这么干，使用编辑器填写详细的提交信息)
    $ git fetch                                 (将远程库中的代码抓到本地的远程分支，但并不合并到本地分支)
    $ git rebase -i origin/your_branch          (针对刚刚抓取下来的远程分支的代码执行一次衍合，这样，会将刚刚生成的提交放到融合了远程库最新代码的本地分支的尾部)
    $ git push origin HEAD:refs/for/your_branch (现在你的本地分支应该是洁净如新的，没有烦人的Merge提交，可以推送到远程库进行审核了)

使用方案二可以清楚的知道有哪些commit对象会被衍合。

在执行`rebase`的过程中，可能会出现冲突，此时，有几种选择：

* 需要保留该提交，则解决冲突，提交，再执行`git rebase --continue`
* 不需要应用该提交，则跳过，`git rebase --skip`

当所有commit都应用之后，若代码通过了审核，则代码可以以Fast-Forward的形式合并到目标分支中。

# 2 审核

## 2.1 提交审核请求后，审核人没有及时审核，该怎么办？

提交请求CommitA后，若审核人ReviewerA没有及时审核，则可能会被别人抢先将代码合并到分支中。这时，若审核人ReviewerA再审核提交CommitA并合并到分支中时，则可能会产生以下几种情况：

* 合并产生冲突。此时需废弃掉本次提交，通知提交人在抓取最新代码后，重新提交。
* 若审核页面上，有 **Rebase**按钮，则说明已经有人抢先合并了代码，则此时，可以先在审核页面点击 **Rebase**按钮，尝试将本次提交在远程库的分支上重演。

    * 若重演成功，则万事大吉，执行具体的审核工作。在合并代码后，此时远程分支的代码提交顺序可能和提交者本地分支中的顺序不同，需要提交者自行校对，以便和远程库中的分支保持一致。
    * 若重演失败，废弃本次提交，通知提交人在抓取最新代码后，重新提交。

综上所述，提交者应在提交代码审核之前，抓取最新的代码到本地，通过衍合生成干净的提交记录后，再发送代码审核请求。

# 3 合并代码

## 3.1 合并分支

在合并分支的时候，如果分支的差别较大，使用`merge`命令合并时很容易出现冲突。这时，即使在本地解决了冲突，提交到gerrit后，仍然会有文件冲突无法合并代码的问题。

解决方案是，在本地做`rebase`，然后再将结果代码提交到gerrit。下面将 **featureA**分支合并到 **featureB**分支，步骤如下：

    $ git pull                           (更新代码)
    $ git co featureA       
    $ git rebase -i featureB featureA    (以featureB为基准，重做featureA的提交)
    $ git co featureB
    $ git merge featureA

这样，featureA就可以以Fast-Forward的方式合并到featureB，然后提交到gerrit后，可以顺利合并代码。

在使用`rebase`合并分支代码时，提交对象可能会很多，这样提交到gerrit后会产生大量的 **review**，非常麻烦。这时可以在`rebase`的交互编辑器中，将多个commit进行合并（压缩合并不好，并不太好，将来再想对某个commit做cherry-pick就没法做）例如：

    pick ee8593d blablabla...
    squash 927ac28 blablabla...
    squash 5646abc blablabla...
    squash ef11a93 blablabla...
    squash 371eb21 blablabla...
    squash 02ba3b8 blablabla...

这样，rebase后会将这些commit合并为一个，并保留相关提交信息，提交到gerrit后，就只会有一个review。
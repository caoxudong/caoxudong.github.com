---
title:      Mac电脑的音频故障
layout:     post
category:   blog
tags:       [osx, audio]
---

若你的mac电脑无法听音乐、无法播视频，试试执行下面的命令

    sudo kill `ps -ax | grep 'coreaudiod' | grep 'sbin' |awk '{print $1}'`

秘籍来源： https://gist.github.com/felipecsl/5177790
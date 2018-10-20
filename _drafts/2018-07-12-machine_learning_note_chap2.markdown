---
title:      《机器学习》笔记-chap2-模型评估与选择
layout:     post
category:   blog
tags:       [machine_learning, note]
---

>《机器学习》，https://book.douban.com/subject/26708119/

# glossary

* **错误率(error rate)**: 指分类错误的样本数占样本总数的比例，即若在`m`个样本中有`a`个样本分类错误，则错误率为`E = a / m`
* **精度(accuracy)**: `1 - a / m`，即 **精度 = 1 - 错误率**
* **误差(error)**: 指学习器的实际预测输出与样本的真实输出之间的差异
* **训练误差(training error)**: 也称为 **经验误差(empirical error)**，指学习器在训练集上的误差
* **泛化误差(generalization error)**: 指学习器在新样本上的误差
* **过拟合(overfitting)**: 指学习器把训练样本自身的一些特点当做所有潜在样本都会有的一般性质，从而导致泛化性能下降
* **欠拟合(underfitting)**: 与 **过拟合**相对，指学习器对训练样本的一般性质尚未学好
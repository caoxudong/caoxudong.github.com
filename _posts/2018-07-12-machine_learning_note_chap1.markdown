---
title:      《机器学习》笔记-chap1
layout:     post
category:   blog
tags:       [machine_learning, note]
---

>《机器学习》，https://book.douban.com/subject/26708119/

# glossary

**属性(attribute)**，也称为 **特征(feature)**，反映事件或对象在某方面的表现或性质的事项。例如"色泽"，"根蒂"，"敲声"

**属性值(attribute value)**，属性上的取值。

**示例(instance)**，也称为 **样本(sample)**，由一组属性和属性值组成的关于一个事件或对象的描述。例如"(色泽=青绿，根蒂=蜷缩，敲声=浊响)"

**数据集(data set)**: 一组示例的集合。

**属性空间(attribute space)**，也称为 **样本空间(sample space)**，有一组属性表示的多度空间。

**特征向量(feature vector)**，由于每个示例都可以在属性空间中找到对应的点，因此示例也可成为特征向量。

**学习(learning)**，也称为 **训练(training)**，指从数据中学得模型的过程，这个过程通过执行某个学习算法来完成。

**训练数据(training data)**，训练过程中所使用的数据。

**训练样本(training sample)**，训练数据中的一个样本。

**训练集(training set)**，训练样本的集合。

**预测(prediiction)**，在有了示例数据之后，对新数据的结果、状态进行评估。

**分类(classfication)**，指结果为离散值的预测，例如"好瓜"、"坏瓜"。

**回归(regression)**，指结果为连续值的预测，例如西瓜的成熟度，0.95，0.37。

**样例(example)**，指带有标记信息的示例，例如"((色泽=青绿; 根蒂=蜷缩; 敲声=浊响), 好瓜)"，前面的"色泽"、"根蒂"和"敲声"属性及其属性值是训练数据，"好瓜"的一个"结果"，他们共同组成了一个样例。

**测试(testing)**，指学得模型之后，使用该模型进行预测的过程。

**测试样本(testing sample)**，指被预测的样本。

**监督学习(supervised learning)**，也称为 **有导师学习**，指训练数据中包含有标记信息。

**无监督学习(unsupervised learning)**，也称为 **无导师学习**，指训练数据中不包含标记信息。

**泛化(generalization)**，指学得的模型适用于新样本的能力。

**特化(specialization)**，指从基础原理推演出具体状况。


---
title: "gcc中-l选项的位置问题"
description: 
date: 2024-07-17T13:32:09+08:00
image: 99947891_p0.jpg
math: 
license: 
hidden: false
comments: true
draft: false
categories:
    - coding
tags:
    - 坑
    - cpp
---

使用fftw库时发现连接器死活找不到符号。增加了-L并检查了LIBRARY_PATH都包含了对应库的路径。

## 解决方法

把 -lfftw3 放在输出文件后面即可。官网的FAQ里甚至也提到了这个错误的解决方法...

## 原理

以下是来自gcc手册对此的解释：

> It  makes  a  difference  where in the command you write this option; the linker searches and processes libraries and object
> files in the order they are specified.  Thus, foo.o -lz bar.o searches library z after file  foo.o  but  before  bar.o
> If bar.o refers to functions in z, those functions may not be loaded.


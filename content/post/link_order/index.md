---
title: "Link_order"
description: 
date: 2024-07-17T13:32:09+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: true
---

使用fftw库时发现连接器死活找不到符号。增加了-L并检查了LIBRARY_PATH都包含了对应库的路径。

## 解决方法

把 -lfftw3 放在输出文件后面即可。官网的FAQ里甚至也提到了这个错误的解决方法...
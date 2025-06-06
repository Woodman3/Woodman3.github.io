---
title: "cublas的gemv踩坑"
description: 
date: 2024-05-13T18:57:13+08:00
image: 112545261_p0.png
math: 
hidden: false
draft: false 
categories:
    - 踩坑和折腾
tags:
    - nvidia 
    - hpc
    - 坑
---

gemv是我接触的第一个cublas function，然而由于cublas中矩阵是按列保存的，所以对于一个$ m*n$的按行保存的矩阵$A$，调用的正确姿势是
```cpp
    cublasSgemv(handle, CUBLAS_OP_T, n, m, &alpha, A, n, x, 1, &beta, y2, 1);
```

可能是按列储存的原因，cublas的gemv效率相比于自己手写的kernel低不少，但是自己手写的kernel和cublas的可能有一定的精度差异


---
title: 切刚矩阵的组装及其相关推导
description:
date: 2026-03-13T17:20:09+08:00
image:
math:
license:
hidden: false
comments: true
draft: true
---
每次推导切刚矩阵都挺痛苦的，记录下，免得下次痛苦。

## 一些约定

我们假设材料的弹性张量如下：

$$
C_{ijkl} =
\lambda \delta_{ij}\delta_{kl}
+
\mu(\delta_{ik}\delta_{jl}+\delta_{il}\delta_{jk})
$$
显然$C$有这奇妙的对称性，即：

$$
\begin{aligned}
C_{ijkl}=C_{jikl} \\
 = C_{ijlk} \\
 = C_{klij} 
\end{aligned}
$$


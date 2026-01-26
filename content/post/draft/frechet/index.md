---
title: 使用Gateaux导数在矩阵相关计算中求导
description:
date: 2026-01-09T17:25:51+08:00
image:
math: true
license:
hidden: false
comments: true
draft: false
---

## 引

假设我们需要对这个函数求导
$$
W(C) = det(C)
$$

## 一个比较粗浅的方法

设
$$
J(A) = det(A)
$$
那么显然有
$$
J(A) = \sum_k^na_{ik}c_{ik}
$$

其中 $c_{ik}$ 是 $a_{ik}$的代数余子式

那么
$$
\partial J / \partial a_{ij} = c_{ij}
$$
又有

$$
A A^* = det(A)I
$$
于是可以得到一个看上去挺对的结论
$$
\partial J / \partial A =det(A) A^{-T}
$$
但是有些漏洞：比如我们只需要矩阵某些元素变化而导致的变换，就像方向导数那样，这个时候这种表达方式就有点不足了，于是让我们来引入frechet导数来推导一遍。

## Frechet导数和Gateaux导数

首先让我们看看Frechet导数的定义：

存在有界线性算子 $A: X \to Y$ 使得
$$
\lim_{\|h\| \to 0} \frac{\| f(x+h) - f(x) - Ah \|_Y}{\|h\|_X} = 0
$$
则称 $f$ 在 $x$ 处 Fréchet 可导，记 $A = f'_F(x)$，称为 Fréchet 微分。

这东西看着就复杂，没学过泛函的话连定义都看不懂，一问gpt上来就抛给你一串公式啥也看不懂，这个微分也不好求，有没有什么更适合工程的方法？有的有的，下面是Gateaux导数的定义

给定两个赋范线性空间 $X$ 和 $Y$，映射 $f: U \subset X \to Y$，其中 $U$ 是开集。  
在点 $x \in U$ 处，若存在有界线性算子 $A: X \to Y$，使得对任意方向 $h \in X$ 有

$$
\lim_{t \to 0} \frac{f(x+th)-f(x) - tAh}{t} = 0
$$

则称 $f$ 在 $x$ 处 Gateaux 可导，记 $A = f'_G(x)$，称为 Gateaux 微分。  
等价地，对每个固定的 $h$，导数 $D_h f(x) = \left. \frac{d}{dt} f(x+th) \right|_{t=0}$ 存在且是 $h$ 的线性连续映射。

看着舒服多了，至少能知道怎么求。下面我们用这个法子来求前文提到的导数。

## 行列式的Gateaux导数

我们有
$$
DJ(A)[H] = \lim_{t \to 0} \frac{J(A+tH)-J(A)}{t}
$$

其中
$$
J(A+tH) = J(A)J(I+tA^{-1}H)
$$
令$C=A^{-1}H$ 假设$C$的特征值为$\lambda_i$，那么显然$I+tC$的特征值为$1+t\lambda_i$

又
$$
J(C)=\prod_{i=1}^n \lambda
$$
则
$$
\begin{aligned}
J(I+tC) &= \prod_{i=1}^n 1+t \lambda_i \\
&=1+t\sum_i\lambda_i+O(t^2)\\
&=1+t\mathrm{tr}(C) + O(t^2)
\end{aligned}
$$
又有
$$
\mathrm{tr}(AB) =A^T : B
$$

回到原式

$$
\begin{aligned}
\lim_{t \to 0} \frac{J(A+tH)-J(A)}{t} &= J(A)*\mathrm{tr}(C)\\
&=J(A)*\mathrm{tr}(A^{-1}H)\\
&=J(A) A^{-T}:H
\end{aligned}
$$

和前面求的差不多，就是多了一个$H$，他的作用就像二阶导数中的方向，这也告诉我们，Gateaux导数得到的是一个映射，输入一个方向（或者叫扰动量），得到对应的导数，记住这个概念，后面链式法则要用。

## 链式法则

叠甲：本文不考虑不可导的情况。严谨的证明留给专门的人来做，我只介绍如何计算。

设 $X, Y, Z$ 是赋范空间，$U \subset X$，$V \subset Y$，  
$g: U \to V$ 在 $x$ 处 Gateaux 可导，  
$f: V \to Z$ 在 $y = g(x)$ 处 Fréchet 可导。  
那么复合函数 $h = f \circ g$ 在 $x$ 处 Gateaux 可导，且  
$$
D_h(x) = Df(g(x)) \circ Dg(x),
$$
这里 $Dg(x)$ 是 $g$ 在 $x$ 处的 Gateaux 导数（线性算子），$Df(y)$ 是 $f$ 在 $y$ 处的 Fréchet 导数。

这个看上去和高中时学的链式法则还挺像的，区别就是中间的乘号变成了一个圆圈。现在我们来求另一个简单的导数$\partial W/\partial F$：

$$
W(C) = det(C),C=F^TF
$$
显然
$$
DC(F)[H] = F^TH + H^TF
$$
那么
$$
\begin{aligned}
D_H(F)&=det(C)C^{-T} :(F^TH + H^TF) \\
&=2det(F)F^{-1}F^{-T} : (F^TH + H^TF) 
\end{aligned}
$$

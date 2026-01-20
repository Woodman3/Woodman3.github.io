---
title: Frechet
description:
date: 2026-01-09T17:25:51+08:00
image:
math: true
license:
hidden: false
comments: true
draft: true
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

看着舒服多了，至少有求的方式。


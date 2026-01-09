---
title: "Frechet"
description: 
date: 2026-01-09T17:25:51+08:00
image: 
math: 
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
\part J / \part a_{ij} = c_{ij}
$$
又有

 
$$
A A^* = det(A)I
$$
于是可以得到一个看上去挺对的结论
$$
\part J / \part A =det(A) A^{-T}
$$

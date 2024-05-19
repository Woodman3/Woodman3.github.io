---
title: "Policy Gradient算法的损失函数"
description: 
date: 2024-05-19T20:56:20+08:00
image: 
math: true
license: 
hidden: false
comments: true
draft: true
---
Policy Gradient是我动手写的第一个RL的算法。在编写损失函数的时候，我们需要注意到Policy Gradient的中心思想是最大化我们的收益$J(\theta)$，即
$$
\begin{aligned}
    J(\theta)&=E_{\tau\sim\pi_\theta(\tau)}[r(\tau)]  \\
    &\approx \sum r(\tau)\pi_\theta(\tau)
\end{aligned}
$$

---
title: "Glassman 傅里叶变换的基本原理"
description: 
date: 2024-07-12T20:45:43+08:00
image: 
math: true
license: 
hidden: false
comments: true
draft: true 
---

## 文前

在优化某个粒子计算的程序时，发现分配2核所耗的时间比1核、4核、8核都久，十分疑惑，经过查找后发现是由于一处傅里叶变换的耗时过大导致，在研究这个傅里叶变换时就顺便把其中的要点记下来。

## 符号约定

为方便起见，本文中所有矩阵的元素的下标从0开始

**本文中所有$w$的上标皆为幂，请不要与行号列号搞混**

$$
n,m:行、列下标，范围若无特殊说明皆为0到N-1\\
n_A,m_A,同为下标但是范围为0到A-1\\
i=\sqrt{-1}\\
w_N=e^{-2{\pi}i/N}\\
W_N:傅里叶变换矩阵，大小为N*N\\
W_N中位置为(n,m)元素的值为w_N^{nm}\\
$$


## 前置知识

### 离散傅里叶变换的矩阵形式
对于离散傅里叶变换，其变换可以写为矩阵形式：

$$
v=W_Nu
$$

### 张量积

也称克罗内克积，记为$\otimes$ ，我们对于张量积的定义为：

$$
A\otimes B=\begin{bmatrix}
a_{11}B&\cdots&a_{1n}B\\
\vdots&\ddots&\vdots\\
a_{m1}B&\cdots&a_{mn}B
\end{bmatrix}
$$

值得注意的是，如果你去查阅[2]这篇论文的话，你会发现他对于张量积的定义与我们上述的定义相反，我在此采取上述定义，因为维基百科也是这么定义的。

除此之外，还有一些性质是我们在后文中会用到的，在此列出。

#### 结合性

$$
(A \otimes B) \otimes C = A \otimes (B \otimes C)
$$

#### 混合乘积性质

如果$A$、$B$、$C$和$D$是四个矩阵，且矩阵乘积$AC$和$BD$存在，那么：

$$
(A \otimes B)(C \otimes D)=AC\otimes BD
$$

#### 疑似分配律

这个是我自己推出来的，维基上没写，我也不确定是否严谨，但是这个规律对后面的推导用处不小，故列出，若$A$ 和$B \otimes C$ 为大小相等的方阵，那么：

$$
(AB)\otimes C = (A\otimes C)(B \otimes C)
$$


## 矩阵的分解

我们先假设

$$
N=AB
$$

那么变换的矩阵的每一个元素可以分解为

$$
\begin{aligned}
w_N^{nm} &= w_N^{n(m_A+Am_B)}\\
&=w_N^{nm_A}w_{AB}^{Anm_B}\\
&=w_N^{nm_A}w_B^{nm_B}
\end{aligned}
$$

令:

$$
\gamma_{N,A}^n:=\{w_N^{n*0},w_N^{n*1}...w_N^{n*(A-1)}\}\\
$$

后文简写为$\gamma^n$ ，我们可以把$W$ 矩阵中的第$n$ 行写为

$$
\{\gamma^nw^{n*0}_B,\gamma^nw^{n*1}_B...\gamma^nw^{nm_B}_B\}
$$

我们可以把$W$ 矩阵的前$B$行进一步分解：

$$
W_{0:B-1,:}=
\begin{bmatrix}
\gamma^0&0&...&0\\
0&\gamma^1&...&0\\
\vdots&\vdots&\ddots&0\\
0&0&\cdots&\gamma^{(B-1)}
\end{bmatrix}\begin{bmatrix}
I_A&I_A&...&I_A\\
I_A&w^{1}_BI_A&...&w_B^{1*(B-1)}I_A\\
\vdots&\vdots&\ddots&\vdots\\
I_A&w_B^{(B-1)*1}I_A& ... &w_B^{(B-1)*(B-1)}I_A
\end{bmatrix}
$$

我们发现了一些有趣的规律，于是进一步分解整个矩阵为

$$
W=
\begin{bmatrix}
\gamma^0&0&...&0\\
0&\gamma^1&...&0\\
\vdots&\vdots&\ddots&0\\
0&0&\cdots&\gamma^{B-1}\\
\gamma^B&0&...&0\\
0&\gamma^{B+1}&...&0\\
\vdots&\vdots&\ddots&0\\
0&0&\cdots&\gamma^{AB-1}\\
\end{bmatrix}\begin{bmatrix}
I_A&I_A&...&I_A\\
I_A&w^{1}_BI_A&...&w_B^{1*(B-1)}I_A\\
\vdots&\vdots&\ddots&\vdots\\
I_A&w_B^{(B-1)*1}I_A&...&w_B^{(B-1)*(B-1)} I_A
\end{bmatrix}

$$
我们记左边的矩阵为 $F^{A,B}$ ，表示每个 $\gamma$ 有$A$ 个元素，每一行有$B$个$/gamma$么原式化简可得
$$

W_N = F^{A/B} (W_B \otimes I_A)

$$

我们成功提出了一个更小的矩阵，现在我们拓展一下$ N=N_1N_2...N_k $ ，这么递归下去，可以得到

$$
\begin{aligned}
W_N &= F^{N_1,N/N_1} (W_{N_2...N_k} \otimes I_{N_1})\\
&= F^{N_1,N/N_1} ((F_{N_2,N_3...N_k}(W_{N_3...N_k} \otimes I_{N_2}))\otimes I_{N_1})\\
&=F^{N_1,N/N_1}((F^{N_2,N_3...N_k} \otimes I_{N_1})(W_{N_3...N_k}\otimes I_{N_2}\otimes I_{N_1}))\\
&=F^{N_1,N/N_1}(F^{N_2,N_3...N_k} \otimes I_{N_1})(F{N_3,N_4...N_k)}\otimes I_{N_1}\otimes I_{N_2})...(F^{N_{k-1},N_k} \otimes I_{N_1} \otimes ... \otimes I_{N_{k-2}})(W_{N_k} \otimes ...)
\end{aligned}
$$

又因为

$$
I_{N_1} \otimes I_{N_2} = I_{N_1N_2}
$$

于是各种符号可以简化以下，比如令
$$
\begin{aligned}
F_t = F^{N_t,N_{t+1}...} \otimes I_{N_1} \otimes ... \otimes I_{N_{t-1}}
&=F^{N_t,N_{t+1}...} \otimes I_{N_1N_2...N_{t-1}}
\end{aligned}
$$
便有了

$$
W_N = F_1F_2...F_k
$$

至此，这就是glassman的基本思想：把一个大矩阵分解成一堆简单的矩阵，下面介绍具体算法如何实现。

## 实现

让我们再次回到起点，我们的目标是计算这么一个简单的式子：

$$
v=W_Nu
$$

经过分解，可以化简为

$$
v=F_1F_2...F_ku
$$

矩阵乘法符合结合律，所以我们从右往左计算，我们发现每一步都可以作一定程度上的化简，比如把$v$分块：

$$
\begin{aligned}  
F_tu  =\\
&=F^{N_t,N_{}...N_k} \otimes I_{N_1N_2...N_{t-1}} u\\
&= \begin{bmatrix}
f_{0,0}I&f_{0,1}I&0&0&...\\
0&0&f_{1,2}I&f_{1,3}I&...\\
\vdots 
\end{bmatrix}
\begin{bmatrix}
v_0\\
v_1\\
\vdots \\
v_{N_t ... N_k}
\end{bmatrix}\\
&= \begin{bmatrix}
f_{0,0}v_0&f_{0,1}v_1&...&0&...\\
0&...&f_{1,N_t}v_{N_t}&f_{1,N_t+1}v_{N_t+1}&...\\
\vdots 
\end{bmatrix}
\end{aligned}
$$

然后递归求和即可。


​                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               


## 引用

- [1] J. A. Glassman, "A Generalization of the Fast Fourier Transform," in IEEE Transactions on Computers, vol. C-19, no. 2, pp. 105-116, Feb. 1970, doi: 10.1109/T-C.1970.222875.
  keywords: {Cooley-Tukey algorithm, discrete Fourier transform, fast Fourier transform, mixed radix, spectral analysis.},
- [2][impl] Warren E. Ferguson,
  A simple derivation of Glassman's general N fast fourier transform,
  Computers & Mathematics with Applications,
  Volume 8, Issue 6,
  1982,
  Pages 401-411,
  ISSN 0898-1221,
  https://doi.org/10.1016/0898-1221(82)90016-5.
  (https://www.sciencedirect.com/science/article/pii/0898122182900165)
  Abstract: A simple derivation of Glassman's general N fast Fourier transform, and corresponding FORTRAN program, is presented. This fast Fourier transform is based upon a representation of the discrete Fourier transform matrix as a product of sparse matrices.
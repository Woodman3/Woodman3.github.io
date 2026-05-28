---
title: 超弹性材料模型下TL隐式迭代相关的矩阵的组装及推导
description: 每次推导切刚矩阵都挺痛苦的，记录下，免得下次痛苦。
date: 2026-03-13T17:20:09+08:00
image: 135886648_p1.jpg
math: true
license:
hidden: false
comments: true
draft: false
categories:
  - 学习
tags:
  - 算法
  - 数学
---

## 弱形式

我们先从动量守恒定律出发，有：
$$
\rho_0\partial_t^2\boldsymbol{\chi}=\rho_0\partial_t^2\mathbf{u}=\nabla\cdot\mathbf{P}+\rho_0\mathbf{b}
$$
变化为弱形式，这里的点乘符号表示两个向量的内积，$\mathbf{v}$是由测试函数组成的一个三维向量：
$$
\int_{\Omega_0}\rho_0\partial_t^2\mathbf{u}\cdot\mathbf{v}\:\mathrm{d}\mathbf{X}=\int_{\Omega_0}(\nabla\cdot\mathbf{P})\cdot\mathbf{v}\:\mathrm{d}\mathbf{X}+\int_{\Omega_0}\rho_0\mathbf{b}\cdot\mathbf{v}\:\mathrm{d}\mathbf{X}.
$$
$\mathbf{v}$是我们自己选取的，因此上述方程可以拆成下面这种形式：
$$\int_{\Omega_{0}}\rho_{0}\partial_{t}^{2}\mathbf{u}\cdot\hat{\mathbf{e}}_{i}v_{i}\:\mathrm{d}\mathbf{X}=\int_{\Omega_{0}}(\nabla\cdot\mathbf{P})\cdot\hat{\mathbf{e}}_{i}v_{i}\:\mathrm{d}\mathbf{X}+\int_{\Omega_{0}}\rho_{0}\mathbf{b}\cdot\hat{\mathbf{e}}_{i}v_{i}\:\mathrm{d}\mathbf{X},\quad \forall i=1,2,3.$$
注意到
$$\nabla\cdot(\mathbf{v}\cdot\mathbf{P})=(\nabla\cdot\mathbf{P})\cdot\mathbf{v}+\mathbf{P}:\nabla\mathbf{v},$$
$$\int_{\Omega_0}(\nabla\cdot\mathbf{P})\cdot\mathbf{v}\:\mathrm{d}\mathbf{X}=\int_{\partial\Omega_0}\mathbf{v}\cdot\mathbf{P}\cdot\mathbf{n}\:\mathrm{d}A-\int_{\Omega_0}\mathbf{P}:\nabla\mathbf{v}\:\mathrm{d}\mathbf{X}.$$
带入可得
$$\int_{\Omega_{0}}\rho_{0}\partial_{t}^{2}\mathbf{u}\cdot \hat{\mathbf{e}}_{i}v_{i}\:\mathrm{d}\mathbf{X}=\int_{\partial\Omega_{0}}(\hat{\mathbf{e}}_{i}v_{i})\cdot\mathbf{P}\cdot\mathbf{n}\:\mathrm{d}A+\int_{\Omega_{0}}\rho_{0}b_{i}v_{i}\:\mathrm{d}\mathbf{X}-\int_{\Omega_{0}}\mathbf{P}:\nabla(\hat{\mathbf{e}}_{i}v_{i})\:\mathrm{d}\mathbf{X},\quad\forall i=1,2,3.$$
## 质量矩阵
$$\begin{aligned}
\int_{\Omega_{0}}\rho_{0}\partial_{t}^{2}\mathbf{u}\cdot\mathbf{v}\mathrm{d}\mathbf{X}&=
\sum_{e}\int_{\Omega_{0}^{e}}\rho_{0}^{e}\partial_{t}^{2}\mathbf{u}^{e}\cdot\mathbf{v}^{e}\:\mathrm{d}\mathbf{X}\\&=
\sum_{e}\int_{\Omega_{0}^{e}}\rho_{0}^{e}\left[\left(\sum_{p=1}^{N_{e}}\sum_{i=1}^{3}u_{p}^{i}\phi_{p}\hat{\mathbf{e}}_{i}\right)\cdot\left(\sum_{q=1}^{N_{e}}\sum_{j=1}^{3}v_{q}^{j}\phi_{q}\hat{\mathbf{e}}_{j}\right)\right]\\&=
\sum_{e}\sum_{i,j=1}^{3}\sum_{p,q=1}^{N_{e}}v_{q}^{j}\left(\int_{\Omega_{0}^{e}}\rho_{0}^{e}\phi_{p}\phi_{q}\delta_{ij}\mathrm{d}\mathbf{X}\right)u_{p}^{i}\\&=
\sum_{e}(\mathbf{V}^{e})^{\top}\mathbf{M}^{e}\partial_{t}^{2}\mathbf{U}^{e}\\&=\mathbf{V}^{\top}\mathbf{M}\partial_{t}^{2}\mathbf{U}^{e}
\end{aligned}$$
显然我们的单元质量矩阵为
$$M_{p,q}^{e,i,j}=\int_{\Omega_{0}^{e}}\rho_{0}^{e}\phi_{p}\phi_{q}\delta_{ij}\mathrm{d}\mathbf{X},$$
## 外力
$$\begin{aligned} \int_{\partial \Omega_0} \mathbf{P} \cdot \mathbf{n} \cdot \mathbf{v} d A_0+\int_{\Omega_0} \rho_0 \mathbf{b} \cdot \mathbf{v} \mathrm{~d} \mathbf{X} & =\sum_e\left[\int_{\partial \Omega_0^e}(\mathbf{P} \cdot \mathbf{n})^e \cdot \mathbf{v}^e d A_0+\int_{\Omega_0^e} \rho_0^e \mathbf{b}^e \cdot \mathbf{v}^e \mathrm{~d} \mathbf{X}\right] \\ & =\sum_e\left[\int_{\partial \Omega_0^e}(\mathbf{P} \cdot \mathbf{n})_{j}^e \sum_{q=1}^{N_{e, \partial}} \sum_{j=1}^3 v_q^j \phi_q \mathrm{~d} A+\int_{\Omega_0^e} \rho_0^e b_{j}^e \sum_{q=1}^{N_e} \sum_{j=1}^3 v_q^j \phi_q \mathrm{~d} \mathbf{X}\right] \\ & =\sum_e\left[\sum_{q=1}^{N_{e, \partial}} \sum_{j=1}^3 v_q^j \int_{\partial \Omega_0^e}(\mathbf{P} \cdot \mathbf{n})_{j}^e \phi_q \mathrm{~d} A+\sum_{q=1}^{N_t} \sum_{j=1}^3 v_q^j \int_{\Omega_0^e} \rho_0^e b_{j}^e \phi_q \mathrm{~d} \mathbf{X}\right] \\ & =\sum_e\left(\mathbf{V}^e\right)^{\top} \mathbf{f}_{\text { ext }}^e=\mathbf{V}^{\top} \mathbf{f}_{\text { ext }}\end{aligned}$$
可分为两个部分
$$\mathbf{f}_{\mathrm{ext}}^{e}=[f_{\mathrm{ext},1,q}^{e,j}+f_{\mathrm{ext},2,q}^{e,j}]_{3N_{e,\partial}},
$$
$$
f_{\mathrm{ext},1,q}^{e,j}=\int_{\partial\Omega_{0}^{e}}(\mathbf{P}\cdot\mathbf{n})_{j}^{e}\phi_{q}\mathrm{d}A,\quad f_{\mathrm{ext},2,q}^{e,j}=\int_{\Omega_{0}^{e}}\rho_{0}^{e}b_{j}^{e}\phi_{q}\mathrm{d}\mathbf{X},\quad(j=1,2,3,\quad q=1,...N_{e})$$
## 内力（基于PK1应力）
$$\begin{aligned}&\int_{\Omega_{0}}\mathbf{P}:\nabla\mathbf{v}\mathrm{dX}\\&=\sum_{e}\int_{\Omega_{0}^{e}}\sum_{j,k=1}^{3}P_{jk}\frac{\partial v^{j}}{\partial X_{k}}\mathrm{dX}\\&=\sum_{e}\int_{\Omega_{0}^{e}}\sum_{j,k=1}^{3}P_{jk}\frac{\partial\sum_{q=1}^{N_{e}}v_{q}^{j}\phi_{q}}{\partial X_{k}}\mathrm{dX}\\&=\sum_{e}\int_{\Omega_{0}^{e}}\sum_{j,k=1}^{3}v_{q}^{j}\int_{\Omega_{0}^{e}}\sum_{k=1}^{3}P_{jk}\frac{\partial\phi_{q}}{\partial X_{k}}\mathrm{dX}\\&=\sum_{e}(\mathbf{V}^{e})^{\top}\mathbf{f}_{\mathrm{int}}^{e}=\mathbf{V}^{\top}\mathbf{f}_{\mathrm{int}}\end{aligned}$$
$$f_{\mathrm{int},q}^{e,j}=\int_{\Omega_{0}^{e}}\sum_{k=1}^{3}P_{jk}\frac{\partial\phi_{q}}{\partial X_{k}}\mathrm{d}\mathbf{X},$$

## 内力（基于PK2应力）
$$\begin{aligned}&\int_{\Omega_{0}}\mathbf{S}:(\mathbf{F}^{\top}\nabla\mathbf{v})\mathrm{d}\mathbf{X}\\&=\sum_{e}\int_{\Omega_{0}^{e}}\sum_{j,k,m=1}^{3}F_{jm}S_{mk}\frac{\partial v^{j}}{\partial X_{k}}\mathrm{d}\mathbf{X}\\&=\sum_{e}\int_{\Omega_{0}^{e}}\sum_{j,k,m=1}^{3}F_{jmk}\frac{\partial\sum_{q=1}^{N_{e}}v_{q}^{j}\phi_{q}}{\partial X_{k}}\mathrm{d}\mathbf{X}\\&=\sum_{e}\sum_{q=1}^{N_{e}}\sum_{j=1}^{3}v_{q}^{j}\int_{\Omega_{0}^{e}}\sum_{k,m=1}^{3}F_{jm}S_{jm}\frac{\partial\phi_{q}}{\partial X_{k}}\mathrm{d}\mathbf{X}\\&=\sum_{e}(\mathbf{V}^{e})^{\top}\mathbf{f}_{\mathrm{int}}^{e}=\mathbf{V}^{\top}\mathbf{f}_{\mathrm{int}}\end{aligned}$$
$$f_{\mathrm{int},q}^{e,j}=\int_{\Omega_0^e}\sum_{k,m=1}^3F_{jm}S_{mk}\frac{\partial\phi_q}{\partial X_k}\mathrm{d}\mathbf{X}$$
## 刚度矩阵
首先对内力项线性化，其过程类似求gateaux导数
$$\begin{aligned}\int_{\Omega_{0}}\mathbf{S}_{t+\Delta t}:\left(\mathbf{F}_{t+\Delta t}^{\top}\nabla\mathbf{v}\right)\:\mathrm{d}\mathbf{X}&\approx\int_{\Omega_{0}}\left[\mathbf{S}_{t}+\left(\frac{\partial\mathbf{S}}{\partial\mathbf{E}}\right)_{t}:\mathrm{sym}(\mathbf{F}_{t}^{\top}\nabla\Delta\mathbf{u}_{t})\right]:\left[\left(\mathbf{F}_{t}+\nabla\Delta\mathbf{u}_{t}\right)^{\top}\nabla\mathbf{v}\right]\mathrm{d}\mathbf{X}\\&=\int_{\Omega_{0}}\mathbf{S}_{t}:\left(\mathbf{F}_{t}^{\top}\nabla\mathbf{v}\right)\mathrm{d}\mathbf{X}\\&+\int_{\Omega_{0}}\left[\left(\frac{\partial\mathbf{S}}{\partial\mathbf{E}}\right)_{t}:\mathrm{sym}\left(\mathbf{F}_{t}^{\top}\nabla\Delta\mathbf{u}_{t}\right)\right]:\left(\mathbf{F}_{t}^{\top}\nabla\mathbf{v}\right)\:\mathrm{d}\mathbf{X}\\&+\int_{\Omega_{0}}\mathbf{S}_{t}:\left((\nabla\Delta\mathbf{u}_{t})^{\top}\nabla\mathbf{v}\right)\:\mathrm{d}\mathbf{X}\:+\:\mathcal{O}(\|\nabla\Delta\mathbf{u}_{t}\|^{2}).\end{aligned}$$
上式的二阶项可以去掉，我们只需要关注第二个和第三个，分别记为$K_{mat}$ 和$K_{geo}$，后者好推
$$
\begin{aligned} \int_{\Omega_0} \mathbf{S}:\left[\left(\nabla_X \Delta \mathbf{u}\right)^{\top} \nabla_X \mathbf{v}\right] \mathrm{d} \mathbf{X} & =\sum_e \int_{\Omega_0^e} \sum_{i, j=1}^3 \sum_{k, l=1}^3 S_{k l} \frac{\partial \Delta u_i}{\partial X_k} \frac{\partial v_j}{\partial X_l} \delta_{i j} \mathrm{~d} \mathbf{X} \\ & =\sum_e \int_{\Omega_0^e} \sum_{i, j=1}^3 \sum_{k, l=1}^3 S_{k l}\left(\sum_{p=1}^{N_e} \frac{\partial \phi_p}{\partial X_k} \Delta u_{n, p, i}\right)\left(\sum_{q=1}^{N_e} \frac{\partial \phi_q}{\partial X_l} v_{q, j}\right) \delta_{i j} \mathrm{~d} \mathbf{X} \\ & =\sum_e \sum_{i, j=1}^3 \sum_{p, q=1}^{N_e} v_{q, j}\left[\int_{\Omega_0^e} \sum_{k, l=1}^3 \frac{\partial \phi_p}{\partial X_k} S_{k l} \frac{\partial \phi_q}{\partial X_l} \delta_{i j} \mathrm{~d} \mathbf{X}\right] \Delta u_{p, i} \\ & =\sum_e\left(\mathbf{V}^e\right)^{\top} \mathbf{K}_{\mathrm{geo}}^e \Delta \mathbf{U}^e=\mathbf{V}^{\top} \mathbf{K}_{\mathrm{geo}} \Delta \mathbf{U} .\end{aligned}$$
对于$K_{mat}$
$$\begin{aligned} 
\int_{\Omega_0} \left[\mathbb{C}:\operatorname{sym}\left(\mathbf{F}^{\top}\nabla_X\Delta\mathbf{u}\right)\right]:\left(\mathbf{F}^{\top}\nabla_X\mathbf{v}\right) \mathrm{d}\mathbf{X} 
& =\sum_e \int_{\Omega_0^e} \sum_{k, l, a, b=1}^3 \mathbb{C}_{k l a b}\left(\sum_{i=1}^3 F_{i a} \frac{\partial \Delta u_i}{\partial X_b}\right)\left(\sum_{j=1}^3 F_{j k} \frac{\partial v_j}{\partial X_l}\right) \mathrm{d}\mathbf{X} \\ 
& =\sum_e \int_{\Omega_0^e} \sum_{k, l, a, b=1}^3 \mathbb{C}_{k l a b}\left(\sum_{i=1}^3 \sum_{p=1}^{N_e} F_{i a} \frac{\partial \phi_p}{\partial X_b} \Delta u_{p, i}\right)\left(\sum_{j=1}^3 \sum_{q=1}^{N_e} F_{j k} \frac{\partial \phi_q}{\partial X_l} v_{q, j}\right) \mathrm{d}\mathbf{X} \\ 
& =\sum_e \sum_{i, j=1}^3 \sum_{p, q=1}^{N_e} v_{q, j}\left[\int_{\Omega_0^e} \sum_{k, l, a, b=1}^3 F_{j k} \frac{\partial \phi_q}{\partial X_l} \mathbb{C}_{k l a b} F_{i a} \frac{\partial \phi_p}{\partial X_b} \mathrm{d}\mathbf{X}\right] \Delta u_{p, i} \\ 
& =\sum_e\left(\mathbf{V}^e\right)^{\top} \mathbf{K}_{\mathrm{mat}}^e \Delta \mathbf{U}^e=\mathbf{V}^{\top} \mathbf{K}_{\mathrm{mat}} \Delta \mathbf{U} .
\end{aligned}$$
$K_{mat}$的计算是程序里的大头，所以非常有必要进行针对性的优化，现在我们拆解弹性模量：
$$\mathbb{C}_{ABCD} = \lambda \delta_{AB}\delta_{CD} + \mu (\delta_{AC}\delta_{BD} + \delta_{AD}\delta_{BC})$$
并变换之前积分形式的下标
$$\sum_{A,B,C,D=1}^3 F_{iA} \frac{\partial \phi_p}{\partial X_B} \mathbb{C}_{ABCD} F_{jC} \frac{\partial \phi_q}{\partial X_D}$$
先看$\lambda$ 项，代入 $\lambda \delta_{AB}\delta_{CD}$：
$$\lambda \sum_{A,B,C,D} F_{iA} \frac{\partial \phi_p}{\partial X_B} (\delta_{AB}\delta_{CD}) F_{jC} \frac{\partial \phi_q}{\partial X_D} = \lambda \left(\sum_A F_{iA} \frac{\partial \phi_p}{\partial X_A}\right) \left(\sum_C F_{jC} \frac{\partial \phi_q}{\partial X_C}\right)$$
$\mu$ 的第一项，代入 $\mu \delta_{AC}\delta_{BD}$：

$$\mu \sum_{A,B,C,D} F_{iA} \frac{\partial \phi_p}{\partial X_B} (\delta_{AC}\delta_{BD}) F_{jC} \frac{\partial \phi_q}{\partial X_D} = \mu \sum_{A,B} F_{iA} F_{jA} \frac{\partial \phi_p}{\partial X_B} \frac{\partial \phi_q}{\partial X_B}$$
可以拆解为两组独立的求和相乘：
$$\mu \left( \sum_A F_{iA} F_{jA}^T \right) \left( \sum_B \frac{\partial \phi_p}{\partial X_B} \frac{\partial \phi_q}{\partial X_B} \right) = \mu (\mathbf{F}\mathbf{F}^T)_{ij} (\nabla_X \phi_p \cdot \nabla_X \phi_q)$$
$\mu$ 的第二项，代入 $\mu \delta_{AD}\delta_{BC}$：

$$\mu \sum_{A,B,C,D} F_{iA} \frac{\partial \phi_p}{\partial X_B} (\delta_{AD}\delta_{BC}) F_{jC} \frac{\partial \phi_q}{\partial X_D} = \mu \sum_{A,B} F_{iA} \frac{\partial \phi_q}{\partial X_A} F_{jB} \frac{\partial \phi_p}{\partial X_B}$$
重组求和项：
$$\mu \left( \sum_A F_{iA} \frac{\partial \phi_q}{\partial X_A} \right) \left( \sum_B F_{jB} \frac{\partial \phi_p}{\partial X_B} \right)$$
于是最终形式如下

$$(\mathbf{K}_{\mathrm{mat}}^e)_{pi, qj} =\lambda h_{p,i} h_{q,j} + \mu \Big( B_{ij} (\mathbf{G}_p \cdot \mathbf{G}_q) + h_{q,i} h_{p,j} \Big) $$
其中，为了简写：
* $h_{p,i} = (\mathbf{F} \nabla_X \phi_p)_i$  
* $B_{ij} = (\mathbf{F}\mathbf{F}^T)_{ij}$ 
* $\mathbf{G}_p \cdot \mathbf{G}_q = \nabla_X \phi_p \cdot \nabla_X \phi_q$ 

至此，计算量极大减少，速度极大提高，此事以成。

## 附录
### 弱形式拆解
$$\begin{aligned}(\nabla\cdot\mathbf{P})\cdot\mathbf{v}&=\sum_{i}(\nabla\cdot\mathbf{P})_{i}\mathbf{v}_{i}=\sum_{i,j}\left(\frac{\partial P_{ij}}{\partial X_{j}}\right)v_{i}\\&=\sum_{ij}\left(\frac{\partial(P_{ij}v_{i})}{\partial X_{j}}-P_{ij}\frac{\partial v_{i}}{\partial X_{j}}\right)\\&=\sum_{j}\frac{\partial(\mathbf{v}\cdot\mathbf{P})_{j}}{\partial X_{j}}-\sum_{ij}P_{ij}(\nabla\mathbf{v})_{ij}\\&=\nabla\cdot(\mathbf{v}\cdot\mathbf{P})-\mathbf{P}:(\nabla\mathbf{v})\end{aligned}$$

### 变换到PK2应力
$$\begin{aligned}\mathbf{FS}:(\nabla\mathbf{v})&=\sum_{i,j}(\mathbf{FS})_{ij}(\nabla\mathbf{v})_{ij}\\&=\sum_{i,j,k}F_{ik}S_{kj}\frac{\partial v_{i}}{\partial X_{j}}=\sum_{i,j,k}S_{kj}\left(F_{ik}\frac{\partial v_{i}}{\partial X_{j}}\right)\\&=\sum_{i,j,k}S_{kj}\left(F_{ik}(\nabla\mathbf{v})_{ij}\right)\\&=\sum_{j,k}S_{kj}(\mathbf{F}^{\top}(\nabla\mathbf{v}))_{kj}\\&=\mathbf{S}:(\mathbf{F}^{\top}(\nabla\mathbf{v}))\end{aligned}$$
### 弹性模量的对称性
我们假设材料的弹性张量如下：

$$
C_{ijkl} =
\lambda \delta_{ij}\delta_{kl}
+
\mu(\delta_{ik}\delta_{jl}+\delta_{il}\delta_{jk})
$$
显然$C$有着奇妙的对称性，即：

$$
\begin{aligned}
C_{ijkl}&=C_{jikl} \\
 &= C_{ijlk} \\
 &= C_{klij} 
\end{aligned}
$$
进一步的，有：
$$
\begin{aligned}
C:A:B &= C : A^T : B\\
 &=C:A:B^T\\
 &=C:\operatorname{sym}(A):\operatorname{sym}(B)
\end{aligned}
$$
其中定义
$$\operatorname{sym}(\mathbf{A}):=\frac{1}{2}(\mathbf{A}+\mathbf{A}^{\top})$$

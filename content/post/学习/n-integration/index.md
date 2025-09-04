---
title: 高维单纯形上的数值积分
description: 老板要求把之前写的积分拓张到N维情况，但是我想不出来这有啥用
date: 2025-08-27T11:30:35+08:00
image: 641b5c955b9cd5730ae8ddddfd706225161775300.jpg
math: true
license:
hidden: false
comments: true
draft: false
categories:
  - 学习
tags:
  - 数学
  - 算法
  - cpp
---

本文是对[之前写的数值积分]({{< ref "post/学习/有限元中的数值积分.md" >}})的拓展。

## N维空间中的N维单纯形积分

### 变换域和符号约定

积分过程包括了三个映射$\zeta \mapsto \eta \mapsto \xi \mapsto x$,其含义如下

实际积分域：**单纯形** 

$$
S=\text{conv}\{v_0,\dots,v_N\}\subset\mathbb{R}^N
$$

实际积分域内部的点用$x$表示

**标准单纯形**（在 $\mathbb{R}^N$）：

$$
\hat S = \Big\{\, \xi=(\xi_1,\dots,\xi_N)\in\mathbb{R}^N \;\Big|\; \xi_i\ge 0,\; \sum_{i=1}^N \xi_i \le 1 \,\Big\}.
$$

**高斯积分区域和位移放缩后的区域**：

$$
\zeta \in [-1,1]^N, \quad \eta=\frac{\zeta+1}{2}\in [0,1]^N .
$$

### $\eta \to \xi$ 的映射

#### 递归乘积公式1

$$
\begin{aligned}
\xi_1 &= \eta_1, \\
\xi_2 &= (1-\eta_1)\,\eta_2, \\
\xi_3 &= (1-\eta_1)(1-\eta_2)\,\eta_3, \\
&\;\;\vdots \\
\xi_{N} &= \Big(\prod_{j=1}^{N-1}(1-\eta_j)\Big)\eta_N, \\
\xi_0 &= \prod_{j=1}^N (1-\eta_j).
\end{aligned}
$$

令这个变换的雅可比式为$J^{\xi}_{\eta}$，不难发现雅可比矩阵是一个三角阵，其行列式的值为
$$
|\det(J^{\xi}_{\eta})| = \prod_{k=1}^{N-1}(1-\eta_k)^{\,N-k}
$$

#### 递归乘积公式2

$$
\begin{aligned}
\xi_1 &= (1-\eta_2)\eta_1, \\
\xi_2 &= (1-\eta_3)\,\eta_1\,\eta_2, \\
\xi_3 &= (1-\eta_4)\,\eta_1\,\eta_2\,\eta_3, \\
&\;\;\vdots \\
\xi_{N} &= \prod_{j=1}^{N}\eta_j, \\
\xi_0 &= (1-\eta_1).
\end{aligned}
$$

这个变换的雅可比式也是一个三角阵，但是对角线上的一排还有元素，所以不能直接去对角线上的元素相乘作为行列式的值，但是可以把最后一排加到倒数第二排，再把倒数第二排的加到倒数第三排，以此类推可以把对角线上一排的值消掉，得到行列式的值为：

$$
|\det(J^{\xi}_{\eta})| = \prod_{k=1}^{N}\eta_k^{\,N-k}
$$

### 标准单纯形到实际单纯形的映射

$$
x = v_0 + \sum_{i=1}^N \xi_i (v_i - v_0).
$$

这就可以写成矩阵形式：

$$
x = v_0 + A \xi, 
$$

其中

$$
A = \big[ v_1 - v_0 \;\; v_2 - v_0 \;\; \cdots \;\; v_N - v_0 \big] \in \mathbb R^{d \times N}.
$$

这样就把单纯形 $\Delta^N$ 上的点 $\xi$ 映射到物理空间中的点 $x$ 了。

于是实际单纯形内任意点写为

$$
x = \sum_{i=0}^N \xi_i v_i .
$$

其重心坐标为

$$
\xi_0 = 1 - \sum_{i=1}^N \xi_i, \qquad 
\xi_i = \xi_i \quad (i=1,\dots,N).
$$

### 从 $\zeta$ 到 $x$ 的最终映射

$$
x(\zeta) = \sum_{i=0}^N \xi_i(\eta(\zeta))\, v_i, 
\quad \eta = \tfrac{\zeta+1}{2}.
$$

### 雅可比行列式

映射 $\zeta \mapsto \eta \mapsto \xi \mapsto x$ 的雅可比为

$$
\Big|\det\frac{\partial x}{\partial \zeta}\Big|
= |\det A|\,|\det J^{\xi}_{\eta}|\;(\tfrac{1}{2})^N ,
$$

### 最终积分公式

对 $f\colon S\to\mathbb{R}$，

$$
\int_S f(x)\,dx
= \int_{[-1,1]^N} f(x(\zeta))\;
|\det A|\,|\det J^{\xi}_{\eta}|\;(\tfrac{1}{2})^N d\zeta.
$$

然后就可以在 $[-1,1]^N$ 上直接用 **Gauss–Legendre 积分点 $(\zeta,w)$** 做数值积分。

## N维空间中的的M维单纯形积分

### 积分区域

我们在 $\mathbb{R}^N$ 空间里有一个 $M$-维单纯形

$$
F = \mathrm{conv}\{ v_0, v_1, \dots, v_{M} \}, \quad v_i \in \mathbb{R}^N.
$$

### 标准 $M$-单纯形

定义参考单纯形：

$$
\hat F = \{\, \xi = (\xi_1,\dots,\xi_{M}) \in \mathbb{R}^{M} \mid \xi_i \ge 0,\;\; \sum_{i=1}^{M} \xi_i \le 1 \,\}.
$$

重心坐标：

$$
\xi_0 = 1 - \sum_{i=1}^{M} \xi_i, \quad
\xi_i = \xi_i \;\;(i=1,\dots,M).
$$

映射到实际面：

$$
x(\xi) = \sum_{i=0}^{M} \xi_i v_i = v_0 + \sum_{i=1}^{M} \xi_i (v_i - v_0).
$$

### 雅可比（面元因子）

参数矩阵：

$$
B \;=\; \begin{bmatrix}
\;v_1-v_0 & v_2-v_0 & \cdots & v_{M}-v_0\;
\end{bmatrix}
\;\in\; \mathbb R^{\,N\times M}.
$$

面元的度量因子是

$$
J(\xi) = \sqrt{\det(B^\top B)}.
$$

可以类比为缩放因子

特别地：

* 在 2D（边，1D simplex），就是线段长度：$J=|v_1-v_0|$。
* 在 3D（三角形，2D simplex），就是三角形的面积因子：$J=| (v_1-v_0) \times (v_2-v_0)|$。

gpt告诉我这个行列式也叫Gram行列式，详细的推导就涉及微分几何的内容了，我曾在菲赫金哥尔茨的《微积分学教程（第三卷）》上看到过一个三维到二维的推导，大受震撼，感兴趣的读者可以自己去推下试试。

### Jacobian 权重

变换的面积因子为

$$
\Big\|\frac{\partial x}{\partial \zeta}\Big\|
= J \cdot \Big(\tfrac{1}{2}\Big)^{M} \cdot |\det J^{\xi}_{\eta}|,
$$

其中

$$
J = \sqrt{\det(B^\top B)}, \quad B = [\,v_1-v_0,\dots,v_{M}-v_0\,].
$$

### 最终积分公式

对于 $f:\mathbb{R}^N\to\mathbb{R}$，

$$
\int_F f(x)\, dS
= \int_{[-1,1]^{M}} f(x(\zeta))\; J \;\Big(\tfrac{1}{2}\Big)^{M}\; |\det J^{\xi}_{\eta}|\; d\zeta.
$$

然后直接用张量积 Gauss–Legendre 规则在 $[-1,1]^{M}$ 上做。

## 代码

```cpp
// 递归生成 N 维笛卡尔积
template <Arithmetic T, size_t N>
void generate_tensor_nodes(const std::vector<gl_node<T, 1>> &one_d_nodes,
                           size_t dim, gl_node<T, N> &current,
                           std::vector<gl_node<T, N>> &result) {
  if (dim == N) {
    result.push_back(current);
    return;
  }
  for (auto const &node : one_d_nodes) {
    current.x[dim] = node.x[0];
    current.weight *= node.weight;
    generate_tensor_nodes<T, N>(one_d_nodes, dim + 1, current, result);
    current.weight /= node.weight; // 回溯
  }
}

// 返回 o 阶 N 维节点
template <Arithmetic T, size_t N>
constexpr std::vector<gl_node<T, N>> get_gl_nodes_nd(int o) {
  auto one_d = get_gl_node<T>(o);
  std::vector<gl_node<T, N>> result;
  gl_node<T, N> current{};
  current.weight = 1.0;
  generate_tensor_nodes<T, N>(one_d, 0, current, result);
  return result;
}

template <Arithmetic T, size_t N>
std::vector<gl_node<T, N>> get_simplex_nd_gl_nodes(int order) {
  static std::vector<gl_node<T, N>> mapped_nodes[MAX_GL_ORDER];
  static std::once_flag init_flag;
  std::call_once(init_flag, [] {
    for (auto i = 0; i < MAX_GL_ORDER; i++) {
      auto gl_nodes = get_gl_nodes_nd<T, N>(i + 1);
      for (auto &node : gl_nodes) {
        for (size_t j = 0; j < N; j++) {
          node.x[j] = (node.x[j] + 1) / 2;
        }
      }

      for (auto &node : gl_nodes) {
        auto eta = gl_node<T, N>{};
        for (size_t j = 0; j < N; j++) {
          eta.weight = node.weight;
          eta.x[j] = 1;
          for (size_t k = 0; k < j; k++) {
            eta.x[j] *= (1 - node.x[k]);
            eta.weight *= pow((1 - node.x[k]), N - k - 1);
          }
          eta.x[j] *= node.x[j];
        }
        node = eta;
      }
      mapped_nodes[i] = gl_nodes;
    }
  });
  return mapped_nodes[order];
}

template <Arithmetic T, size_t N>
T integrate_on_n_simplex(const Eigen::Matrix<T, N + 1, N> simplex,
                         std::function<T(const Eigen::Vector<T, N> &)> func,
                         size_t o) {
  auto nodes = get_simplex_nd_gl_nodes<T, N>(o);

  Eigen::Matrix<T, N, N> A;

  for (size_t i = 0; i < N; i++) {
    A.col(i) = simplex.row(i + 1) - simplex.row(0);
  }

  T integral = 0.0;
  for (const auto &node : nodes) {
    Eigen::Vector<T, N> x = simplex.row(0);
    for (size_t i = 0; i < N; i++) {
      x += node.x[i] * A.col(i);
    }
    integral += node.weight * func(x);
  }
  integral *= abs(A.determinant());
  integral /= pow(2, N);
  return integral;
}

template <Arithmetic T, size_t N, size_t M>
T integrate_on_m_simplex_in_nd(
    const Eigen::Matrix<T, M + 1, N> simplex,
    std::function<T(const Eigen::Vector<T, N> &)> func, size_t o) {
  auto nodes = get_simplex_nd_gl_nodes<T, M>(o);

  Eigen::Matrix<T, N, M> B;

  for (size_t i = 0; i < M; i++) {
    B.col(i) = simplex.row(i + 1) - simplex.row(0);
  }

  T integral = 0.0;
  for (const auto &node : nodes) {
    Eigen::Vector<T, N> x = simplex.row(0);
    for (size_t i = 0; i < M; i++) {
      x += node.x[i] * B.col(i);
    }
    integral += node.weight * func(x);
  }
  integral *= pow(abs((B.transpose() * B).determinant()), 0.5);
  integral /= pow(2, M);
  return integral;
}
```

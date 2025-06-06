---
title: 有限元中的数值积分
description: 
date: 2025-03-18T16:48:15+08:00
image: GkIr6doaAAMJNYZ.jpg
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

我使用的数值积分方法是高斯勒让德积分，后面全文的所有内容都是基于这种积分方法的。这种积分如何计算在此就略过不表了。

## 一些映射

### 从标准三角形到$[-1,1]^2$上的映射

#### 方法 1

从基函数部分开始，对于一个标准三角形表面，我们定义 $f(\xi_1, \xi_2)$，并希望计算其在三角形上的数值积分 $I$：
$$
I = \int_{\mathbb K_{i,k}} f (\mathbf x) \mathrm d \mathbf x
= \int_0^1 \mathrm d \xi_1 \int_0^{1-\xi_1} f(\xi_1, \xi_2)  \mathrm d \xi_2,
$$
现在我们需要使用求积公式来计算该积分：
$$
I = \sum_{m=1}^{N} c_m f(\xi_{1,m}, \xi_{2,m}),
$$
其中，$c_m$ 是与特定点 $(\xi_{1,m}, \xi_{2,m})$ 相关的权重，$N$ 代表所需精度对应的关键点的数量。

该积分 $I$ 可以通过变量替换变换为单位方形区域 $\{(\eta_1, \eta_2) \ | \ 0 \leq \eta_1,\ \eta_2 \leq 1\}$ 上的积分：
$$
\xi_1 = \eta_1, \quad \xi_2 = (1-\eta_1)\eta_2.
$$

此时，雅可比行列式的行列式和微元面积为：
$$
\frac{\partial (\xi_1, \xi_2)}{\partial (\eta_1, \eta_2)} = \frac{\partial \xi_1}{\partial \eta_1} \frac{\partial \xi_2}{\partial \eta_2} - \frac{\partial \xi_1}{\partial \eta_2}\frac{\partial \xi_2}{\partial \eta_1} = 1 - \eta_1,
$$
以及
$$
\mathrm d \xi_1 \mathrm d \xi_2 = \frac{\partial (\xi_1, \xi_2)}{\partial (\eta_1, \eta_2)} \mathrm d \eta_1 d \eta_2 = (1 - \eta_1) \mathrm d \eta_1 \mathrm d \eta_2.
$$

因此，可以得到：
$$
\int_0^{1}\int_0^{1-\xi_1} f(\xi_1, \xi_2) \mathrm d \xi_2 \mathrm d \xi_1 = \int_0^1 \int_0^1 f(\eta_1, (1-\eta_1)\eta_2) (1 - \eta_1) \mathrm d \eta_1 \mathrm d \eta_2.
$$

进一步通过变量替换转换到标准单位正方形 $\{(\zeta_1, \zeta_2) \ | \ -1 \leq \zeta_1, \zeta_2 \leq 1\}$ 上：
$$
\eta_1 = (1 + \zeta_1) /2, \quad \eta_2 = (1 + \zeta_2) / 2,
$$
于是，雅可比行列式和微元面积变为：
$$
\frac{\partial (\eta_1, \eta_2)}{\partial (\zeta_1, \zeta_2)} = (1/2)(1/2) - (0)(0)= 1/4,
$$
以及
$$
\mathrm d \eta_1 \mathrm d \eta_2 = \frac{1}{4}\mathrm d \zeta_1 \mathrm d \zeta_2.
$$

最终得到：
$$
\begin{align*}
I & = \int_0^{1}\int_0^{1-\xi_1} f(\xi_1, \xi_2)  \mathrm d \xi_2 \mathrm d \xi_1 = \int_0^1 \int_0^1 f(\eta_1, (1-\eta_1)\eta_2) (1-\eta_1)  \mathrm d \eta_1 \mathrm d \eta_2, \\
& = \int_{-1}^1\int_{-1}^1 f\left(\frac{1 + \zeta_1}{2}, \frac{(1-\zeta_1)(1+\zeta_2)}{4}\right)\left(\frac{1 - \zeta_1}{8}\right)  \mathrm d \zeta_1 \mathrm d \zeta_2.
\end{align*}
$$

最终，积分计算可以表示为：
$$
I = \sum_{i=1}^{\alpha}\sum_{j=1}^{\beta} W_{1,i} W_{2,j} f\left(\frac{1+\zeta_{1,i}}{2}, \frac{(1-\zeta_{1,i})(1+\zeta_{2,j})}{4}\right)\left(\frac{1-\zeta_{1,j}}{8}\right)  ,
$$
其中，$\zeta_{1,i}$ 和 $\zeta_{2,j}$ 分别为 $\zeta_1$ 和 $\zeta_2$ 方向上的高斯积分点，$W_{1,i}$ 和 $W_{2,j}$ 是对应的权重。

积分公式可以进一步重写为：
$$
I = \sum_{m=1}^{N= (\alpha)\times (\beta)}c_m f(\xi_{1,m},\xi_{2,m}),
$$
其中，
$$
c_m = W_{1,i} W_{2,j}  \left(\frac{1-\zeta_{1,j}}{8}\right), \quad \xi_{1,m}=\frac{1+\zeta_{1,i}}{2}, \quad \xi_{2,m} = \frac{(1-\zeta_{1,i})(1+\zeta_{2,j})}{4}.
$$

#### 方法 2

通过变量替换：
$$
\xi_1 = \eta_1 \eta_2, \quad \xi_2 = (1-\eta_1)\eta_2,
$$
将积分转换为单位正方形上：
$$
\int_0^{1}\int_0^{1-\xi_1} f(\xi_1, \xi_2) \mathrm d \xi_2 \mathrm d \xi_1 = \int_0^1 \int_0^1 f(\eta_1 \eta_2, (1-\eta_1)\eta_2) \eta_2 \mathrm d \eta_1 \mathrm d \eta_2.
$$

进一步转换到标准正方形：
$$
\eta_1 = (1 + \zeta_1) /2, \quad \eta_2 = (1 + \zeta_2) / 2,
$$
最终积分计算可以表示为：
$$
I = \sum_{i=1}^{m}\sum_{j=1}^{n} W_{1,i} W_{2,j}  f\left(\frac{(1+\zeta_{1,i})(1+\zeta_{2,j})}{4}, \frac{(1-\zeta_{1,i})(1+\zeta_{2,j})}{4}\right)\left(\frac{1+\zeta_{2,j}}{8}\right).
$$

最终，积分公式可以重写为：
$$
I = \sum_{k=1}^{N=m\times n}c_k f(\xi_{1,k},\xi_{2,k}),
$$
其中：
$$
c_k = W_{1,i} W_{1,j}  \left(\frac{1+\zeta_{2,j}}{8}\right), \quad \xi_{1,k}=\frac{(1+\zeta_{1,i})(1+\zeta_{2,j})}{4},\ \xi_{2,k} = \frac{(1-\zeta_{1,i})(1+\zeta_{2,j})}{4}.
$$

### 从标准四面体到$[-1,1]^3$上的映射

#### 方法 1

从基函数部分开始，我们有 $f(\xi_1, \xi_2, \xi_3)$，目标是计算其在标准四面体上的数值积分 $I$：
$$
I = \int_{\mathbb K_{i,k}} f (\mathbf x) \mathrm d \mathbf x
= \int_0^1 \mathrm d \xi_2 \int_0^{1-\xi_2} d \xi_1\int_0^{1 - \xi_1 - \xi_2} f(\xi_1, \xi_2, \xi_3)  \mathrm d \xi_3。
$$

然后，我们希望使用求积公式求出该积分的值：
$$
I = \sum_{m=1}^N c_m f(\xi_{1,m}, \xi_{2,m}, \xi_{3,m}),
$$
其中，$c_m$ 是与采样点 $(\xi_{1,m}, \xi_{2,m}, \xi_{3,m})$ 相关联的权重，$N$ 是与所需精度相关的关键点的数量。

积分 $I$ 可以通过变量替换转换为单位立方体上的积分：$\{(\eta_1, \eta_2, \eta_3) \ | \ 0 \leq \eta_1, \eta_2, \eta_3 \leq 1\}$，变量替换如下：
$$
\xi_1 = \eta_1, \quad \xi_2 = \eta_2 (1 - \eta_1), \quad \xi_3 = \eta_3 (1 - \eta_1) (1 - \eta_2)。
$$

雅可比行列式的行列式以及微分面积为：
$$
\frac{\partial (\xi_1, \xi_2, \xi_3)}{\partial (\eta_1, \eta_2, \eta_3)} =
\begin{bmatrix}
\frac{\partial \xi_1}{\partial \eta_1} & \frac{\partial \xi_1}{\partial \eta_2} & \frac{\partial \xi_1}{\partial \eta_3} \\
\frac{\partial \xi_2}{\partial \eta_1} & \frac{\partial \xi_2}{\partial \eta_2} & \frac{\partial \xi_2}{\partial \eta_3} \\
\frac{\partial \xi_3}{\partial \eta_1} & \frac{\partial \xi_3}{\partial \eta_2} & \frac{\partial \xi_3}{\partial \eta_3}
\end{bmatrix} = (1 - \eta_1)^2 (1 - \eta_2)，
$$
以及
$$
\mathrm d \xi_1 \, \mathrm d \xi_2 \, \mathrm d \xi_3 = (1 - \eta_1)^2 (1 - \eta_2) \, \mathrm d \eta_1 \, \mathrm d \eta_2 \, \mathrm d \eta_3。
$$

因此，我们可以将积分 $I$ 变换为：
$$
I = \int_0^1 \int_0^1 \int_0^1 f \Big( \eta_1, \eta_2 (1 - \eta_1), \eta_3 (1- \eta_1) (1 - \eta_2) \Big) ( 1 - \eta_1)^2 ( 1 - \eta_2) \,  \mathrm d \eta_3 \, \mathrm d \eta_2 \, \mathrm d \eta_1。
$$

进一步地，积分 $I$ 可以转换为标准立方体 $\{(\zeta_1, \zeta_2, \zeta_3) \ | \ -1 \leq \zeta_1, \zeta_2, \zeta_3 \leq 1 \}$ 上的积分，变量替换如下：
$$
\eta_1 = \frac{1 + \zeta_1}{2}, \quad \eta_2 = \frac{1 + \zeta_2}{2}, \quad \eta_3 = \frac{1 + \zeta_3}{2}。
$$

雅可比行列式的行列式及微分面积为：
$$
\frac{\partial (\eta_1, \eta_2, \eta_3)}{\partial (\zeta_1, \zeta_2, \zeta_3)} = \frac{1}{8}，
$$
$$
\mathrm d \eta_1 \, \mathrm d \eta_2 \, \mathrm d \eta_3 = \frac{1}{8} \, \mathrm d \zeta_1 \, \mathrm d \zeta_2 \, \mathrm d \zeta_3。
$$

最终积分表达式为：
$$
I = \int_{-1}^1 \int_{-1}^1 \int_{-1}^1 f\left(\frac{(1 + \zeta_1)}{2}, \frac{(1 + \zeta_2)(1 - \zeta_1)}{4}, \frac{(1+\zeta_3)(1-\zeta_1)(1-\zeta_2)}{8}\right) \frac{(1 - \zeta_1)^2(1 - \zeta_2)}{64} \,  \mathrm d \zeta_1 \, \mathrm d \zeta_2 \, \mathrm d \zeta_3。
$$

高效的求积系数可以从文献中获取，以满足所需精度。

最终积分可表示为：
$$
I = \sum_{i=1}^\alpha \sum_{j=1}^\beta \sum_{k=1}^\gamma W_{1,i} W_{2,j} W_{3,k}  \frac{(1 - \zeta_{1,i})^2 (1 - \zeta_{2,j})}{64} f \left(\frac{(1 + \zeta_{1,i})}{2}, \frac{(1 + \zeta_{2,j})(1 - \zeta_{1,i})}{4}, \frac{(1 + \zeta_{3,k})(1-\zeta_{1,i})(1-\zeta_{2,j})}{8}\right)。
$$

其中，
$$
c_m = W_{1,i} W_{2,j} W_{3,k}  \frac{(1 - \zeta_{1,i})^2 (1 - \zeta_{2,j})}{64}，
$$
$$
\xi_{1,m} = \frac{(1 + \zeta_{1,i})}{2}，
$$
$$
\xi_{2,m} = \frac{(1 + \zeta_{2,j})(1 - \zeta_{1,i})}{4}，
$$
$$
\xi_{3,m} = \frac{(1 + \zeta_{3,k})(1-\zeta_{1,i})(1-\zeta_{2,j})}{8}，
$$
其中，$\zeta_{1,i}, \zeta_{2,j}, \zeta_{3,k}$ 是采样点，$W_{1,i}, W_{2,j}, W_{3,k}$ 是对应的高斯-勒让德求积权重系数，分别对应于阶数 $\alpha$、$\beta$ 和 $\gamma$。

#### 方法 2

积分 $I$ 可通过变量替换转换为单位立方体 $\{(\eta_1, \eta_2, \eta_3) \ | \ 0 \leq \eta_1, \eta_2, \eta_3 \leq 1\}$ 上的积分：

$$
\xi_1 = \eta_1 \eta_2 \eta_3, \quad \xi_2 = \eta_1 \eta_2 (1 - \eta_3), \quad \xi_3 = \eta_1 (1 - \eta_2)
$$

接下来，雅可比行列式的行列式及微分体积为：
$$
\frac{\partial (\xi_1, \xi_2, \xi_3)}{\partial (\eta_1, \eta_2, \eta_3)} =
\begin{bmatrix}
\frac{\partial \xi_1}{\partial \eta_1} & \frac{\partial \xi_1}{\partial \eta_2} & \frac{\partial \xi_1}{\partial \eta_3} \\
\frac{\partial \xi_2}{\partial \eta_1} & \frac{\partial \xi_2}{\partial \eta_2} & \frac{\partial \xi_2}{\partial \eta_3} \\
\frac{\partial \xi_3}{\partial \eta_1} & \frac{\partial \xi_3}{\partial \eta_2} & \frac{\partial \xi_3}{\partial \eta_3}
\end{bmatrix} = -\eta_1^2 \eta_2
$$
$$
\mathrm d \xi_1 \, \mathrm d \xi_2 \, \mathrm d \xi_3 = \left| \frac{\partial (\xi_1, \xi_2, \xi_3)}{\partial (\eta_1, \eta_2, \eta_3)} \right| \, \mathrm d \eta_1 \, \mathrm d \eta_2 \, \mathrm d \eta_3 = \eta_1^2 \eta_2 \, \mathrm d \eta_1 \, \mathrm d \eta_2 \, \mathrm d \eta_3.
$$

于是积分 $I$ 变为：
$$
I = \int_0^1 \int_0^1 \int_0^1 f(\eta_1 \eta_2 \eta_3, \eta_1 \eta_2 (1 - \eta_3), \eta_1 (1 - \eta_2)) \times \eta_1^2 \eta_2 \,  \mathrm d \eta_3 \, \mathrm d \eta_2 \, \mathrm d \eta_1.
$$

进一步地，积分 $I$ 可通过变量替换转换为标准 2-立方体区域 $\{(\zeta_1, \zeta_2, \zeta_3) \ | \ -1 \leq \zeta_1, \zeta_2, \zeta_3 \leq 1 \}$ 上的积分：
$$
\eta_1 = \frac{1 + \zeta_1}{2}, \quad \eta_2 = \frac{1 + \zeta_2}{2}, \quad \eta_3 = \frac{1 + \zeta_3}{2}
$$

此时，雅可比行列式的行列式及微分体积为：
$$
\frac{\partial (\eta_1, \eta_2, \eta_3)}{\partial (\zeta_1, \zeta_2, \zeta_3)} = \frac{1}{8}, \quad \mathrm d \eta_1 \, \mathrm d \eta_2 \, \mathrm d \eta_3 = \frac{1}{8} \, \mathrm d \zeta_1 \, \mathrm d \zeta_2 \, \mathrm d \zeta_3.
$$

最终，积分变为：
$$
I = \int_{-1}^1 \int_{-1}^1 \int_{-1}^1 f\left(\frac{(1 + \zeta_1)(1 + \zeta_2)(1 + \zeta_3)}{8}, \frac{(1 + \zeta_1)(1 + \zeta_2)(1 - \zeta_3)}{8}, \frac{(1+\zeta_1)(1-\zeta_2)}{4}\right) \times \frac{(1 + \zeta_1)^2(1 + \zeta_2)}{64} \,  \mathrm d \zeta_1 \, \mathrm d \zeta_2 \, \mathrm d \zeta_3.
$$


最终，积分可表示为：
$$
I = \sum_{i=1}^{\alpha} \sum_{j=1}^{\beta} \sum_{k=1}^{\gamma} \frac{(1 + \zeta_{1,i})^2 (1 + \zeta_{2,j})}{64} W_i W_j W_k f\left(\frac{(1 + \zeta_{1,i})(1 + \zeta_{2,j})(1 + \zeta_{3,k})}{8}, \frac{(1 + \zeta_{1,i})(1 + \zeta_{2,j})(1 - \zeta_{3,k})}{8}, \frac{(1+\zeta_{1,i})(1-\zeta_{2,j})}{4}\right)
$$
$$
= \sum_{m=1}^{N=(\alpha)\times(\beta)\times(\gamma)} c_m f(\xi_{1,m}, \xi_{2,m}, \xi_{3,m})
$$
其中，
$$
c_m = \frac{(1 + \zeta_{1,i})^2 (1 + \zeta_{2,j})}{64} \times W_i W_j W_k 
$$
$$
\xi_{1,m} = \frac{(1 + \zeta_{1,i})(1 + \zeta_{2,j})(1 + \zeta_{3,k})}{8}, \quad
\xi_{2,m} = \frac{(1 + \zeta_{1,i})(1 + \zeta_{2,j})(1 - \zeta_{3,k})}{8}, \quad
\xi_{3,m} = \frac{(1+\zeta_{1,i})(1-\zeta_{2,j})}{4}
$$
其中，$\zeta_{1,i}, \zeta_{2,j}, \zeta_{3,k}$ 是采样点，$W_i, W_j, W_k$ 是高斯-勒让德求积的相应权重系数，分别对应于阶数 $\alpha, \beta, \gamma$。

> 任意三角形和四面体如何映射到标准的三角形和四面体上这一部分，就暂且不表了

### 三维空间中三角形到标准三角形上的映射


设三角形由三个顶点 $\mathbf{p}_1, \mathbf{p}_2, \mathbf{p}_3$ 定义，并使用重心坐标 $(\lambda_1, \lambda_2, \lambda_3)$ 进行参数化，使得：
$$
\mathbf{p} = \lambda_1 \mathbf{p}_1 + \lambda_2 \mathbf{p}_2 + \lambda_3 \mathbf{p}_3, \quad \text{其中} \quad \lambda_1 + \lambda_2 + \lambda_3 = 1.
$$
标准三角形一般定义在二维平面上，例如单位三角形：
$$
T_{\text{ref}} = \{ (u,v) \mid 0 \leq u \leq 1, 0 \leq v \leq 1-u \}.
$$
从 $(u,v)$ 变换到三维空间中的三角形，映射函数可以写成：
$$
\mathbf{p}(u, v) = \mathbf{p}_1 + u (\mathbf{p}_2 - \mathbf{p}_1) + v (\mathbf{p}_3 - \mathbf{p}_1).
$$

定义映射 $\mathbf{p}(u, v)$ 的偏导数：
$$
J = \begin{bmatrix} 
\frac{\partial \mathbf{p}}{\partial u} & \frac{\partial \mathbf{p}}{\partial v}
\end{bmatrix}
= \begin{bmatrix} 
\mathbf{p}_2 - \mathbf{p}_1 & \mathbf{p}_3 - \mathbf{p}_1
\end{bmatrix}.
$$
这里 $\mathbf{p}_i$ 是三维向量，所以 $J$ 是一个 $3 \times 2$ 的矩阵。

由于 $J$ 不是方阵，我们计算它的 **面积缩放因子**，即**行列式的范数**：
$$
| \det(J^T J) |^{1/2}.
$$
其中：
$$
J^T J = \begin{bmatrix} 
(\mathbf{p}_2 - \mathbf{p}_1) \cdot (\mathbf{p}_2 - \mathbf{p}_1) & (\mathbf{p}_2 - \mathbf{p}_1) \cdot (\mathbf{p}_3 - \mathbf{p}_1) \\ 
(\mathbf{p}_3 - \mathbf{p}_1) \cdot (\mathbf{p}_2 - \mathbf{p}_1) & (\mathbf{p}_3 - \mathbf{p}_1) \cdot (\mathbf{p}_3 - \mathbf{p}_1)
\end{bmatrix}.
$$
其行列式为：
$$
\det(J^T J) = (\mathbf{p}_2 - \mathbf{p}_1) \cdot (\mathbf{p}_2 - \mathbf{p}_1) (\mathbf{p}_3 - \mathbf{p}_1) \cdot (\mathbf{p}_3 - \mathbf{p}_1) - ((\mathbf{p}_2 - \mathbf{p}_1) \cdot (\mathbf{p}_3 - \mathbf{p}_1))^2.
$$
这实际上是三角形两个边向量构成的**行列式的平方**，其平方根给出了映射的面积缩放因子：
$$
\text{Jacobian determinant} = \sqrt{\det(J^T J)} = \| (\mathbf{p}_2 - \mathbf{p}_1) \times (\mathbf{p}_3 - \mathbf{p}_1) \|.
$$
其中 $\times$ 表示向量叉积，$\|\cdot\|$ 是范数（即向量长度）。

## 代数精度的细节

从三角形变换到方形或四面体变换到正方体的时候，可能会增加原方程的最高次幂数，因此代数精度不能直接沿用原方程的最高次幂数。

## 基函数与形函数

如果我们在一个单元中定义了一次线性基函数，这个单元在积分过程中被映射到标准三角形或四面体的同时，我们的基函数也被变换成了这个单元的形状函数，这意味不少计算上的简便。
至于如何证明这个变换成立，就交由读者了。

当然，如果积分函数的内部有梯度算子，还需要乘上变换的雅可比矩阵的逆。如果是三维的三角形变换为二维的标准三角形的情况下，则需要乘上雅可比矩阵的伪逆矩阵。

## 代码

```cpp
// 定义节点和权重的结构体
template <Arithmetic T>
struct gl_node {
    T x;
    T weight;
};

// 获取 n 阶高斯-勒让德节点和权重
template <Arithmetic T>
std::vector<gl_node<T>> get_gl_node(int n) {
    std::vector<gl_node<T>> nodes;
    switch (n) {
        case 1:
            nodes = {
                {static_cast<T>(0.0), static_cast<T>(2.0)}
            };
            break;
        case 2:
            nodes = {
                {static_cast<T>(-0.5773502691896257), static_cast<T>(1.0)},
                {static_cast<T>(0.5773502691896257), static_cast<T>(1.0)}
            };
            break;
        case 3:
            nodes = {
                {static_cast<T>(-0.7745966692414834), static_cast<T>(0.5555555555555556)},
                {static_cast<T>(0.0), static_cast<T>(0.8888888888888888)},
                {static_cast<T>(0.7745966692414834), static_cast<T>(0.5555555555555556)}
            };
            break;
        case 4:
            nodes = {
                {static_cast<T>(-0.8611363115940526), static_cast<T>(0.3478548451374538)},
                {static_cast<T>(-0.3399810435848563), static_cast<T>(0.6521451548625461)},
                {static_cast<T>(0.3399810435848563), static_cast<T>(0.6521451548625461)},
                {static_cast<T>(0.8611363115940526), static_cast<T>(0.3478548451374538)}
            };
            break;
        case 5: 
            nodes = {
                {static_cast<T>(-0.9061798459386640), static_cast<T>(0.2369268850561891)},
                {static_cast<T>(-0.5384693101056831), static_cast<T>(0.4786286704993665)},
                {static_cast<T>(0.0), static_cast<T>(0.5688888888888889)},
                {static_cast<T>(0.5384693101056831), static_cast<T>(0.4786286704993665)},
                {static_cast<T>(0.9061798459386640), static_cast<T>(0.2369268850561891)}
            };
            break;
        case 6:
            nodes = {
                {static_cast<T>(-0.9324695142031521), static_cast<T>(0.1713244923791704)},
                {static_cast<T>(-0.6612093864662645), static_cast<T>(0.3607615730481386)},
                {static_cast<T>(-0.2386191860831969), static_cast<T>(0.4679139345726910)},
                {static_cast<T>(0.2386191860831969), static_cast<T>(0.4679139345726910)},
                {static_cast<T>(0.6612093864662645), static_cast<T>(0.3607615730481386)},
                {static_cast<T>(0.9324695142031521), static_cast<T>(0.1713244923791704)}
            };
            break;
        default :
            throw std::invalid_argument("Unsupported order of Gauss-Legendre quadrature.");
    }
    // 可以根据需要添加更多的节点和权重
    return nodes;
}

template<Function3d Func>
double integrate_on_triangle(const Triangle &tri,
                           Func func,
                           int order,int method=1) {
    double integral = 0.0;
    auto nodes = get_gl_node<double>(order);
    for (auto &node_u : nodes) {
        for (auto &node_v : nodes) {
            if(method ==1){
                double u = (1+node_u.x) / 2;
                double v = (1-node_u.x) *(1+node_v.x) / 4;
                double jacobian = (1-node_u.x) / 8; 
                double x = tri.vertices(0,0) + u * tri.J(0,0) + v * tri.J(1,0);
                double y = tri.vertices(0,1) + u * tri.J(0,1) + v * tri.J(1,1);
                double z = tri.vertices(0,2) + u * tri.J(0,2) + v * tri.J(1,2);
                integral += node_u.weight * node_v.weight * func(x, y, z)*jacobian;
            }else{
                double u = (1+node_u.x)*(1+node_v.x) / 4;
                double v = (1-node_u.x)*(1+node_v.x) / 4;
                double jacobian = (1+node_v.x) / 8;
                double x = tri.vertices(0,0) + u * tri.J(0,0) + v * tri.J(1,0);
                double y = tri.vertices(0,1) + u * tri.J(0,1) + v * tri.J(1,1);
                double z = tri.vertices(0,2) + u * tri.J(0,2) + v * tri.J(1,2);
                integral += node_u.weight * node_v.weight * func(x, y, z)*jacobian;
            }
        }
    }
    return tri.det_J * integral;
}

template <Function3d Func>
double integrate_on_tetra(Tetra &t,Func func,int order,
    int method=1) {
    double integral = 0.0;
    auto vertices = t.vertices;
    auto J = t.J;
    auto det_J = t.det_J;
    auto nodes = get_gl_node<double>(order);
    for (const auto& node_x : nodes) {
        for (const auto& node_y : nodes) {
            for (const auto& node_z : nodes) {
                if(method==1){
                    double mapped_x = (1+node_x.x) / 2;
                    double mapped_y = (1-node_x.x)*(1+node_y.x) / 4;
                    double mapped_z = (1-node_x.x)*(1-node_y.x)*(1+node_z.x) / 8;
                    double jacobian = (1-node_x.x)*(1-node_x.x)*(1-node_y.x) / 64;
                    double x = vertices(0,0) + mapped_x * J(0,0) + mapped_y * J(1,0) + mapped_z * J(2,0);
                    double y = vertices(0,1) + mapped_x * J(0,1) + mapped_y * J(1,1) + mapped_z * J(2,1);
                    double z = vertices(0,2) + mapped_x * J(0,2) + mapped_y * J(1,2) + mapped_z * J(2,2);
                    double val = func(x,y,z);
                    integral += node_x.weight * node_y.weight * node_z.weight * val*jacobian*abs(det_J);
                }else{
                    double mapped_x = (1+node_x.x)*(1+node_y.x)*(1+node_z.x) / 8;
                    double mapped_y = (1+node_x.x)*(1+node_y.x)*(1-node_z.x) / 8;
                    double mapped_z = (1+node_x.x) *(1-node_y.x)  / 4;
                    double jacobian = (1+node_x.x) *(1+node_x.x)*(1+node_y.x) / 64;
                    double x = vertices(0,0) + mapped_x * J(0,0) + mapped_y * J(0,1) + mapped_z * J(2,0);
                    double y = vertices(0,1) + mapped_x * J(0,1) + mapped_y * J(1,1) + mapped_z * J(2,1);
                    double z = vertices(0,2) + mapped_x * J(0,2) + mapped_y * J(1,2) + mapped_z * J(2,2);
                    double val = func(x,y,z);
                    integral += node_x.weight * node_y.weight * node_z.weight * val*jacobian*abs(det_J);
                }
            }
        }
    }
    return integral;
}
template<Function3d Func>
double integrate_on_triangle(const Triangle &tri,
                           Func func,
                           int order,int method=1) {
    double integral = 0.0;
    auto nodes = get_gl_node<double>(order);
    for (auto &node_u : nodes) {
        for (auto &node_v : nodes) {
            if(method ==1){
                double u = (1+node_u.x) / 2;
                double v = (1-node_u.x) *(1+node_v.x) / 4;
                double jacobian = (1-node_u.x) / 8; 
                double x = tri.vertices(0,0) + u * tri.J(0,0) + v * tri.J(1,0);
                double y = tri.vertices(0,1) + u * tri.J(0,1) + v * tri.J(1,1);
                double z = tri.vertices(0,2) + u * tri.J(0,2) + v * tri.J(1,2);
                integral += node_u.weight * node_v.weight * func(x, y, z)*jacobian;
            }else{
                double u = (1+node_u.x)*(1+node_v.x) / 4;
                double v = (1-node_u.x)*(1+node_v.x) / 4;
                double jacobian = (1+node_v.x) / 8;
                double x = tri.vertices(0,0) + u * tri.J(0,0) + v * tri.J(1,0);
                double y = tri.vertices(0,1) + u * tri.J(0,1) + v * tri.J(1,1);
                double z = tri.vertices(0,2) + u * tri.J(0,2) + v * tri.J(1,2);
                integral += node_u.weight * node_v.weight * func(x, y, z)*jacobian;
            }
        }
    }
    return tri.det_J * integral;
}
//基函数定义在在标准三角形上
template<Function3d Func1,Function2d Func2>
double integrate_on_triangle_by_base(const Triangle &tri,
                           Func1 func,
                           Func2 base,
                           int order,int method=1) {
    double integral = 0.0;
    auto nodes = get_gl_node<double>(order);
    for (auto &node_u : nodes) {
        for (auto &node_v : nodes) {
            if(method ==1){
                double u = (1+node_u.x) / 2;
                double v = (1-node_u.x) *(1+node_v.x) / 4;
                double jacobian = (1-node_u.x) / 8; 
                double x = tri.vertices(0,0) + u * tri.J(0,0) + v * tri.J(1,0);
                double y = tri.vertices(0,1) + u * tri.J(0,1) + v * tri.J(1,1);
                double z = tri.vertices(0,2) + u * tri.J(0,2) + v * tri.J(1,2);
                double val = func(x, y, z)*base(u,v);
                integral += node_u.weight * node_v.weight * val*jacobian;
            }else{
                double u = (1+node_u.x)*(1+node_v.x) / 4;
                double v = (1-node_u.x)*(1+node_v.x) / 4;
                double jacobian = (1+node_v.x) / 8;
                double x = tri.vertices(0,0) + u * tri.J(0,0) + v * tri.J(1,0);
                double y = tri.vertices(0,1) + u * tri.J(0,1) + v * tri.J(1,1);
                double z = tri.vertices(0,2) + u * tri.J(0,2) + v * tri.J(1,2);
                double val = func(x, y, z)*base(u,v);
                integral += node_u.weight * node_v.weight * val*jacobian;
            }
        }
    }
    return tri.det_J * integral;
}

//基函数定义在标准四面体上
template<Function3d Func1,Function3d Func2>
double intergate_on_tetra_by_base(
    const Tetra &t,
    Func1 func,
    Func2 base,
    int order,
    int method=1){
    double integral = 0.0;
    auto vertices = t.vertices;
    auto J = t.J;
    auto det_J = t.det_J;
    auto nodes = get_gl_node<double>(order);
    for (const auto& node_x : nodes) {
        for (const auto& node_y : nodes) {
            for (const auto& node_z : nodes) {
                if(method==1){
                    double mapped_x = (1+node_x.x) / 2;
                    double mapped_y = (1-node_x.x)*(1+node_y.x) / 4;
                    double mapped_z = (1-node_x.x)*(1-node_y.x)*(1+node_z.x) / 8;
                    double jacobian = (1-node_x.x)*(1-node_x.x)*(1-node_y.x) / 64;
                    double x = vertices(0,0) + mapped_x * J(0,0) + mapped_y * J(1,0) + mapped_z * J(2,0);
                    double y = vertices(0,1) + mapped_x * J(0,1) + mapped_y * J(1,1) + mapped_z * J(2,1);
                    double z = vertices(0,2) + mapped_x * J(0,2) + mapped_y * J(1,2) + mapped_z * J(2,2);
                    double val = func(x,y,z)*base(mapped_x,mapped_y,mapped_z);
                    integral += node_x.weight * node_y.weight * node_z.weight * val*jacobian*abs(det_J);
                }else{
                    double mapped_x = (1+node_x.x)*(1+node_y.x)*(1+node_z.x) / 8;
                    double mapped_y = (1+node_x.x)*(1+node_y.x)*(1-node_z.x) / 8;
                    double mapped_z = (1+node_x.x) *(1-node_y.x)  / 4;
                    double jacobian = (1+node_x.x) *(1+node_x.x)*(1+node_y.x) / 64;
                    double x = vertices(0,0) + mapped_x * J(0,0) + mapped_y * J(0,1) + mapped_z * J(2,0);
                    double y = vertices(0,1) + mapped_x * J(0,1) + mapped_y * J(1,1) + mapped_z * J(2,1);
                    double z = vertices(0,2) + mapped_x * J(0,2) + mapped_y * J(1,2) + mapped_z * J(2,2);
                    double val = func(x,y,z)*base(mapped_x,mapped_y,mapped_z);
                    integral += node_x.weight * node_y.weight * node_z.weight * val*jacobian*abs(det_J);
                }
            }
        }
    }
    return integral;
}
```

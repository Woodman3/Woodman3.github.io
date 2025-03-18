---
title: "有限元中的数值积分"
description: 
date: 2025-03-18T16:48:15+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: true
---

我使用的数值积分是高斯勒让德积分，后面全文的所有内容都是基于这种积分方法的。这种积分如何计算在此就略过不表了。

## 从标准三角形到$[-1,1]^2$上的映射

### 法1

H. T. Rathod, K. V. Nagaraja, B. Venkatesudu, and N. L. Ramesh, "Gauss Legendre Quadrature over Triangle", J. Indian Inst. Sci, Spet.-Oct. 2004, 84, 183-188

Starting from the Basis Function section, for a triangle surface, we have $f(\xi_1, \xi_2)$ and aim at getting its numerical integration $I$ for triangle
$$
I = \int_{\mathbb K_{i,k}} f (\mathbf x) \mathrm d \mathbf x
= \int_0^1 \mathrm d \xi_1 \int_0^{1-\xi_1} f(\xi_1, \xi_2) \mathfrak J_{\mathbf x} \mathrm d \xi_2,
$$
it is now required to find the value of the integral by a quadrature formula:
$$
I = \sum_{m=1}^{N} c_m f(\xi_{1,m}, \xi_{2,m}),
$$
where $c_m$ are the weights associated with specific points $(\xi_{1,m}, \xi_{2,m})$ and $N$ is the number of pivotal points related to the required precision.

The integral $I$ can be transformed into an integral over the surface of the square: $\{(\eta_1, \eta_2) \ | \ 0 \leq \eta_1,\ \eta_2 \leq 1\}$ by substitution:
$$
\xi_1 = \eta_1, \quad \xi_2 = (1-\eta_1)\eta_2.
$$

Then the determinant of the Jacobian and the differential area are
$$
\frac{\partial (\xi_1, \xi_2)}{\partial (\eta_1, \eta_2)} = \frac{\partial \xi_1}{\partial \eta_1} \frac{\partial \xi_2}{\partial \eta_2} - \frac{\partial \xi_1}{\partial \eta_2}\frac{\partial \xi_2}{\partial \eta_1} = 1 - \eta_1,
$$
and
$$
\mathrm d \xi_1 \mathrm d \xi_2 = \frac{\partial (\xi_1, \xi_2)}{\partial (\eta_1, \eta_2)} \mathrm d \eta_1 d \eta_2 = (1 - \eta_1) \mathrm d \eta_1 \mathrm d \eta_2.
$$

Then we have
$$
\int_0^{1}\int_0^{1-\xi_1} f(\xi_1, \xi_2) \mathrm d \xi_2 \mathrm d \xi_1 = \int_0^1 \int_0^1 f(\eta_1, (1-\eta_1)\eta_2) (1 - \eta_1) \mathrm d \eta_1 \mathrm d \eta_2.
$$

It can further into an integral over the standard 2-square: $\{(\zeta_1, \zeta_2) \ | \ -1 \leq \zeta_1, \zeta_2 \leq 1\}$ by the substitution
$$
\eta_1 = (1 + \zeta_1) /2, \quad \eta_2 = (1 + \zeta_2) / 2,
$$
Then clearly the determinant of the Jacobian and the differential area are:
$$
\frac{\partial (\eta_1, \eta_2)}{\partial (\zeta_1, \zeta_2)} = \frac{\partial \eta_1}{\partial \zeta_1} \frac{\partial \eta_2}{\partial \zeta_2} - \frac{\partial \eta_1}{\partial \zeta_2}\frac{\partial \eta_2}{\partial \zeta_1} = (1/2)(1/2) - (0)(0)= 1/4,
$$
and
$$
\mathrm d \eta_1 \mathrm d \eta_2 = \frac{\partial (\eta_1, \eta_2)}{\partial (\zeta_1, \zeta_2)} \mathrm d \zeta_1 d \zeta_2 = \frac{1}{4}\mathrm d \zeta_1 \mathrm d \zeta_2.
$$

Now, we have
$$
\begin{align*}
I & = \int_0^{1}\int_0^{1-\xi_1} f(\xi_1, \xi_2) \mathfrak J_{\mathbf x} \mathrm d \xi_2 \mathrm d \xi_1 = \int_0^1 \int_0^1 f(\eta_1, (1-\eta_1)\eta_2) (1-\eta_1) \mathfrak J_{\mathbf x} \mathrm d \eta_1 \mathrm d \eta_2, \\
& = \int_{-1}^1\int_{-1}^1 f\left(\frac{1 + \zeta_1}{2}, \frac{(1-\zeta_1)(1+\zeta_2)}{4}\right)\left(\frac{1 - \zeta_1}{8}\right) \mathfrak J_{\mathbf x} \mathrm d \zeta_1 \mathrm d \zeta_2.
\end{align*}
$$

Efficient quadrature coefficients are readily available in the literature so that any desired accuracy can be readily at M. Abramowicz and I. A. Stegun, "Handbook of mathematical functions" and also the paper containing this section.

Then we can have
$$
I = \sum_{i=1}^{\alpha}\sum_{j=1}^{\beta} W_{1,i} W_{2,j} f\left(\frac{1+\zeta_{1,i}}{2}, \frac{(1-\zeta_{1,i})(1+\zeta_{2,j})}{4}\right)\left(\frac{1-\zeta_{1,j}}{8}\right) \mathfrak J_{\mathbf x} ,
$$
where $\zeta_{1,i}$, $\zeta_{2,j}$ are Gaussian points in the $\zeta_1$, $\zeta_2$ directions, respectively, and $W_{1,i}$, $W_{2,j}$ are the corresponding weights.

We can rewrite the equation
$$
I = \sum_{m=1}^{N= (\alpha)\times (\beta)}c_m f_(\xi_{1,m},\xi_{2,m}),
$$
where $c_m$, $\xi_m$ and $\xi_m$ can be obtained from the relations:
$$
c_m = W_{1,i} W_{2,j} \mathfrak J_{\mathbf x} \left(\frac{1-\zeta_{1,j}}{8}\right), \quad \xi_{1,m}=\frac{1+\zeta_{1,i}}{2}, \quad \xi_{2,m} = \frac{(1-\zeta_{1,i})(1+\zeta_{2,j})}{4}
$$

### 法2

H. T. Rathod, K. V. Nagaraja, B. Venkatesudu, and N. L. Ramesh, "Gauss Legendre Quadrature over Triangle", J. Indian Inst. Sci, Spet.-Oct. 2004, 84, 183-188

Starting from the Basis Function section, for a triangle surface, we have $f(\xi_1, \xi_2)$ and aim at getting its numerical integration $I$ for triangle
$$
I = \int_0^1 \mathrm d \xi_1 \int_0^{1-\xi_1} f(\xi_1, \xi_2) \mathfrak J_{\mathbf x} \mathrm d \xi_2,
$$
it is now required to find the value of the integral by a quadrature formula:
$$
I = \sum_{m=1}^{N}c_m f(\xi_{1,m}, \xi_{2,m}),
$$
where $c_m$ are the weights associated with specific points $(\xi_{1,m}, \xi_{2,m})$ and $N$ is the number of pivotal points related to the required precision.

The integral $I$ can be transformed into an integral over the surface of the square: $\{(\eta_1, \eta_2) \ | \ 0 \leq \eta_1,\ \eta_2 \leq 1\}$ by substitution:
$$
\xi_1 = \eta_1 \eta_2, \quad \xi_2 = (1-\eta_1)\eta_2.
$$

Then the determinant of the Jacobian and the differential area are
$$
\frac{\partial (\xi_1, \xi_2)}{\partial (\eta_1, \eta_2)} = \frac{\partial \xi_1}{\partial \eta_1} \frac{\partial \xi_2}{\partial \eta_2} - \frac{\partial \xi_1}{\partial \eta_2}\frac{\partial \xi_2}{\partial \eta_1} = \eta_2 (1 - \eta_1) - \eta_1 (-\eta_2) = \eta_2,
$$
and
$$
\mathrm d \xi_1 \mathrm d \xi_2 = \frac{\partial (\xi_1, \xi_2)}{\partial (\eta_1, \eta_2)} \mathrm d \eta_1 d \eta_2 = \eta_2 \mathrm d \eta_1 \mathrm d \eta_2.
$$

Then we have
$$
\int_0^{1}\int_0^{1-\xi_1} f(\xi_1, \xi_2) \mathrm d \xi_2 \mathrm d \xi_1 = \int_0^1 \int_0^1 f(\eta_1 \eta_2, (1-\eta_1)\eta_2) \eta_2 \mathrm d \eta_1 \mathrm d \eta_2.
$$

It can further into an integral over the standard 2-square: $\{(\zeta_1, \zeta_2) \ | \ -1 \leq \zeta_1, \zeta_2 \leq 1\}$ by the substitution
$$
\eta_1 = (1 + \zeta_1) /2, \quad \eta_2 = (1 + \zeta_2) / 2,
$$

Then clearly the determinant of the Jacobian and the differential area are:
$$
\frac{\partial (\eta_1, \eta_2)}{\partial (\zeta_1, \zeta_2)} = \frac{\partial \eta_1}{\partial \zeta_1} \frac{\partial \eta_2}{\partial \zeta_2} - \frac{\partial \eta_1}{\partial \zeta_2}\frac{\partial \eta_2}{\partial \zeta_1} = (1/2)(1/2) - (0)(0)= 1/4,
$$
and
$$
\mathrm d \eta_1 \mathrm d \eta_2 = \frac{\partial (\eta_1, \eta_2)}{\partial (\zeta_1, \zeta_2)} \mathrm d \zeta_1 d \zeta_2 = \frac{1}{4}\mathrm d \zeta_1 \mathrm d \zeta_2.
$$

Now, we have
$$
\begin{align*}
I & = \int_0^{1}\int_0^{1-\xi_1} f(\xi_1, \xi_2) \mathfrak J_{\mathbf x} \mathrm d \xi_2 \mathrm d \xi_1 = \int_0^1 \int_0^1 f(\eta_1 \eta_2, (1-\eta_1)\eta_2) \eta_2 \mathfrak J_{\mathbf x} \mathrm d \eta_1 \mathrm d \eta_2, \\
& = \int_{-1}^1\int_{-1}^1 f\left(\frac{(1 + \zeta_1)(1 + \zeta_2)}{4}, \frac{(1-\zeta_1)(1+\zeta_2)}{4}\right)\left(\frac{1 + \zeta_2}{8}\right) \mathfrak J_{\mathbf x} \mathrm d \zeta_1 \mathrm d \zeta_2.
\end{align*}
$$

Efficient quadrature coefficients are readily available in the literature so that any desired accuracy can be readily at M. Abramowicz and I. A. Stegun, "Handbook of mathematical functions" and also the paper containing this section.

Then we can have
$$
I = \sum_{i=1}^{m}\sum_{j=1}^{n} W_{1,i} W_{2,j} \mathfrak J_{\mathbf x} f\left(\frac{(1+\zeta_{1,i})(1+\zeta_{2,j})}{4}, \frac{(1-\zeta_{1,i})(1+\zeta_{2,j})}{4}\right)\left(\frac{1+\zeta_{2,j}}{8}\right),
$$
where $\zeta_{1,i}$, $\zeta_{2,j}$ are Gaussian points in the $\zeta_1$, $\zeta_2$ directions, respectively, and $W_{1,i}$, $W_{2,j}$ are the corresponding weights.

We can rewrite the equation
$$
I = \sum_{k=1}^{N=m\times n}c_k f_(\xi_{1,k},\xi_{2,k}),
$$
where $c_k$, $\xi_{1,k}$ and $\xi_{2,k}$ can be obtained from the relations:
$$
c_k = W_{1,i} W_{1,j} \mathfrak J_{\mathbf x} \left(\frac{1+\zeta_{2,j}}{8}\right), \quad \xi_{1,k}=\frac{(1+\zeta_{1,i})(1+\zeta_{2,j})}{4},\ \xi_{2,k} = \frac{(1-\zeta_{1,i})(1+\zeta_{2,j})}{4}
$$

## 从标准四面体到$[-1,1]^3$上的映射

### 法1


H. T. Rathod, B. Venkatesudu, and K. V. Nagaraja, "Gauss Legendre Quadrature Formulae for Tetrahedra," International Journal for Computational Methods in Engineering Science and Mechanics, vol. 6, no. 3, pp. 231-242, 2005.

Starting from the Basis Function section, we have $f(\xi_1, \xi_2, \xi_3)$ and aim at getting its numerical integration $I$ for Tetrahedron
$$
I = \int_{\mathbb K_{i,k}} f (\mathbf x) \mathrm d \mathbf x
= \int_0^1 \mathrm d \xi_2 \int_0^{1-\xi_2} d \xi_1\int_0^{1 - \xi_1 - \xi_2} f(\xi_1, \xi_2, \xi_3) \mathfrak J_{\mathbf x} \mathrm d \xi_3,
$$

Then we want to find the value of the integral by a quadrature formula:
$$
I = \sum_{m=1}^N c_m f(\xi_{1,m}, \xi_{2,m}, \xi_{3,m})
$$
where $c_m$ are the weights associated with the sampling points $(\xi_{1,m}, \xi_{2,m}, \xi_{3,m})$ and $N$ is the number of pivotal points related to the required precision.

The integral $I$ can be transformed into an integral over the cube: $\{(\eta_1, \eta_2, \eta_3) \ | \ 0 \leq \eta_1, \eta_2, \eta_3 \leq 1\}$ by substitution
$$
\xi_1 = \eta_1, \quad \xi_2 = \eta_2 (1 - \eta_1), \quad \xi_3 = \eta_3 (1 - \eta_1) (1 - \eta_2)
$$

Then determinant of Jacobian and the differential area are
$$
\begin{align*}
\frac{\partial (\xi_1, \xi_2, \xi_3)}{\partial (\eta_1, \eta_2, \eta_3)} =
\begin{bmatrix}
\frac{\partial \xi_1}{\partial \eta_1} & \frac{\partial \xi_1}{\partial \eta_2} & \frac{\partial \xi_1}{\partial \eta_3} \\
\frac{\partial \xi_2}{\partial \eta_1} & \frac{\partial \xi_2}{\partial \eta_2} & \frac{\partial \xi_2}{\partial \eta_3} \\
\frac{\partial \xi_3}{\partial \eta_1} & \frac{\partial \xi_3}{\partial \eta_2} & \frac{\partial \xi_3}{\partial \eta_3}
\end{bmatrix} = (1 - \eta_1)^2 (1 - \eta_2) 
\end{align*}
$$
and
$$
\begin{align*}
\mathrm d \xi_1 \, \mathrm d \xi_2 \, \mathrm d \xi_3 = \left| \frac{\partial (\xi_1, \xi_2, \xi_3)}{\partial (\eta_1, \eta_2, \eta_3)} \right| \, \mathrm d \eta_1 \, \mathrm d \eta_2 \, \mathrm d \eta_3 = (1 - \eta_1)^2 (1 - \eta_2) \, \mathrm d \eta_1 \, \mathrm d \eta_2 \, \mathrm d \eta_3.
\end{align*}
$$
Then we have
$$
\begin{align*}
I & = \int_0^1 \left( \int_0^{1-\zeta_1} \left( \int_0^{1-\zeta_1-\zeta_2} f(\xi_1, \xi_2, \xi_3) \, \mathfrak J_{\mathbf x} \mathrm d \xi_3 \right) \mathrm d \xi_2 \right) \mathrm d \xi_1 \\
& = \int_0^1 \int_0^1 \int_0^1 f \Big( \eta_1, \eta_2 (1 - \eta_1), \eta_3 (1- \eta_1) (1 - \eta_2) \Big) ( 1 - \eta_1)^2 ( 1 - \eta_2) \, \mathfrak J_{\mathbf x} \mathrm d \eta_3 \, \mathrm d \eta_2 \, \mathrm d \eta_1
\end{align*}
$$

The integral $I$ can be further transformed into an integral over the standard 2-cube: $\{(\zeta_1, \zeta_2, \zeta_3) \ | \ -1 \leq \zeta_1, \zeta_2, \zeta_3 \leq 1 \}$ by the substitution
$$
\eta_1 = \frac{1 + \zeta_1}{2}, \quad \eta_2 = \frac{1 + \zeta_2}{2}, \quad \eta_3 = \frac{1 + \zeta_3}{2}
$$

Then clearly the determinant of the Jacobian and the differential area are:
$$
\frac{\partial (\eta_1, \eta_2, \eta_3)}{\partial (\zeta_1, \zeta_2, \zeta_3)} = \frac{1}{8}
$$
and 
$$
\mathrm d \eta_1 \, \mathrm d \eta_2 \, \mathrm d \eta_3 = \frac{\partial (\eta_1, \eta_2, \eta_3)}{\partial (\zeta_1, \zeta_2, \zeta_3)} \, \mathrm d \zeta_1 \, \mathrm d \zeta_2 \, \mathrm d \zeta_3
= \frac{1}{8} \, \mathrm d \zeta_1 \, \mathrm d \zeta_2 \, \mathrm d \zeta_3
$$

Now we have
$$
I = \int_{-1}^1 \int_{-1}^1 \int_{-1}^1 f\left(\frac{(1 + \zeta_1)}{2}, \frac{(1 + \zeta_2)(1 - \zeta_1)}{4}, \frac{(1+\zeta_3)(1-\zeta_1)(1-\zeta_2)}{8}\right) \frac{(1 - \zeta_1)^2(1 - \zeta_2)}{64} \, \mathfrak J_{\mathbf x} \mathrm d \zeta_1 \, \mathrm d \zeta_2 \, \mathrm d \zeta_3
$$

Efficient quadrature coefficients are readily available in the literature so that any desired accuracy can be readily at M. Abramowicz and I. A. Stegun, "Handbook of mathematical functions" and also the paper containing this section.

Then the final integral becomes
$$
\begin{align*}
I & = \sum_{i=1}^\alpha \sum_{j=1}^\beta \sum_{k=1}^\gamma W_{1,i} W_{2,j} W_{3,k} \mathfrak J_{\mathbf x} \frac{(1 - \zeta_{1,i})^2 (1 - \zeta_{2,j})}{64} f \left(\frac{(1 + \zeta_{1,i})}{2}, \frac{(1 + \zeta_{2,j})(1 - \zeta_{1,i})}{4}, \frac{(1 + \zeta_{3,k})(1-\zeta_{1,i})(1-\zeta_{2,j})}{8}\right) \\
& = \sum_{m=1}^{N=(\alpha)\times(\beta)\times(\gamma)} c_m f(\xi_{1,m}, \xi_{2,m}, \xi_{3,m})
\end{align*}
$$
where, it is obvious that
$$
\begin{align*}
c_m & = W_{1,i} W_{2,j} W_{3,k} \mathfrak J_{\mathbf x} \frac{(1 - \zeta_{1,i})^2 (1 - \zeta_{2,j})}{64} \\
\xi_{1,m} & = \frac{(1 + \zeta_{1,i})}{2} \\
\xi_{2,m} & = \frac{(1 + \zeta_{2,j})(1 - \zeta_{1,i})}{4} \\
\xi_{3,m} & = \frac{(1 + \zeta_{3,k})(1-\zeta_{1,i})(1-\zeta_{2,j})}{8}
\end{align*}
$$
in which $\zeta_{1,i}$, $\zeta_{2,j}$, $\zeta_{3,k}$ are the sampling points and $W_{1,i}$, $W_{2,j}$, $W_{3,k}$ are the corresponding weight coefficients of Gauss Legendre quadrature for orders $\alpha$, $\beta$, $\gamma$ respectively.

### 法2


H. T. Rathod, B. Venkatesudu, and K. V. Nagaraja, "Gauss Legendre Quadrature Formulae for Tetrahedra," International Journal for Computational Methods in Engineering Science and Mechanics, vol. 6, no. 3, pp. 231-242, 2005.

Starting from the Basis Function section, we have $f(\xi_1, \xi_2, \xi_3)$ and aim at getting its numerical integration $I$ for Tetrahedron
$$
I = \int_0^1 \mathrm d \xi_2 \int_0^{1-\xi_2} d \xi_1\int_0^{1 - \xi_1 - \xi_2} f(\xi_1, \xi_2, \xi_3) \mathfrak J_{\mathbf x} \mathrm d \xi_3,
$$
then we want to find the value of the integral by a quadrature formula:
$$
I = \sum_{m=1}^N c_m f(\xi_{1,m}, \xi_{2,m}, \xi_{3,m})
$$
where $c_m$ are the weights associated with the sampling points $(\xi_{1,m}, \xi_{2,m}, \xi_{3,m})$ and $N$ is the number of pivotal points related to the required precision.

The integral $I$ can be transformed into an integral over the cube: $\{(\eta_1, \eta_2, \eta_3) \ | \ 0 \leq \eta_1, \eta_2, \eta_3 \leq 1\}$ by substitution
$$
\xi_1 = \eta_1 \eta_2 \eta_3, \quad \xi_2 = \eta_1 \eta_2 (1 - \eta_3), \quad \xi_3 = \eta_1 (1 - \eta_2)
$$

Then determinant of Jacobian and the differential area are
$$
\begin{align*}
\frac{\partial (\xi_1, \xi_2, \xi_3)}{\partial (\eta_1, \eta_2, \eta_3)} =
\begin{bmatrix}
\frac{\partial \xi_1}{\partial \eta_1} & \frac{\partial \xi_1}{\partial \eta_2} & \frac{\partial \xi_1}{\partial \eta_3} \\
\frac{\partial \xi_2}{\partial \eta_1} & \frac{\partial \xi_2}{\partial \eta_2} & \frac{\partial \xi_2}{\partial \eta_3} \\
\frac{\partial \xi_3}{\partial \eta_1} & \frac{\partial \xi_3}{\partial \eta_2} & \frac{\partial \xi_3}{\partial \eta_3}
\end{bmatrix} = -\eta_1^2 \eta_2
\end{align*}
$$
and
$$
\begin{align*}
\mathrm d \xi_1 \, \mathrm d \xi_2 \, \mathrm d \xi_3 = \left| \frac{\partial (\xi_1, \xi_2, \xi_3)}{\partial (\eta_1, \eta_2, \eta_3)} \right| \, \mathrm d \eta_1 \, \mathrm d \eta_2 \, \mathrm d \eta_3 = \eta_1^2 \eta_2 \, \mathrm d \eta_1 \, \mathrm d \eta_2 \, \mathrm d \eta_3.
\end{align*}
$$

Then we have
$$
I = \int_0^1 \left( \int_0^{1-\zeta_1} \left( \int_0^{1-\zeta_1-\zeta_2} f(\xi_1, \xi_2, \xi_3) \, \mathfrak J_{\mathbf x} \mathrm d \xi_3 \right) \mathrm d \xi_2 \right) \mathrm d \xi_1
$$
$$
= \int_0^1 \int_0^1 \int_0^1 f(\eta_1 \eta_2 \eta_3, \eta_1 \eta_2 (1 - \eta_3), \eta_1 (1 - \eta_2)) \times \eta_1^2 \eta_2 \, \mathfrak J_{\mathbf x} \mathrm d \eta_3 \, \mathrm d \eta_2 \, \mathrm d \eta_1
$$

The integral $I$ can be further transformed into an integral over the standard 2-cube: $\{(\zeta_1, \zeta_2, \zeta_3) \ | \ -1 \leq \zeta_1, \zeta_2, \zeta_3 \leq 1 \}$ by the substitution
$$
\eta_1 = \frac{1 + \zeta_1}{2}, \quad \eta_2 = \frac{1 + \zeta_2}{2}, \quad \eta_3 = \frac{1 + \zeta_3}{2}
$$

Then clearly the determinant of the Jacobian and the differential area are:
$$
\frac{\partial (\eta_1, \eta_2, \eta_3)}{\partial (\zeta_1, \zeta_2, \zeta_3)} = \frac{1}{8} \quad \text{and} \quad \mathrm d \eta_1 \, \mathrm d \eta_2 \, \mathrm d \eta_3 = \frac{\partial (\eta_1, \eta_2, \eta_3)}{\partial (\zeta_1, \zeta_2, \zeta_3)} \, \mathrm d \zeta_1 \, \mathrm d \zeta_2 \, \mathrm d \zeta_3
$$
$$
= \frac{1}{8} \, \mathrm d \zeta_1 \, \mathrm d \zeta_2 \, \mathrm d \zeta_3
$$

Now we have
$$
I = \int_{-1}^1 \int_{-1}^1 \int_{-1}^1 f\left(\frac{(1 + \zeta_1)(1 + \zeta_2)(1 + \zeta_3)}{8}, \frac{(1 + \zeta_1)(1 + \zeta_2)(1 - \zeta_3)}{8}, \frac{(1+\zeta_1)(1-\zeta_2)}{4}\right) \times \frac{(1 + \zeta_1)^2(1 + \zeta_2)}{64} \, \mathfrak J_{\mathbf x} \mathrm d \zeta_1 \, \mathrm d \zeta_2 \, \mathrm d \zeta_3
$$

Efficient quadrature coefficients are readily available in the literature so that any desired accuracy can be readily at M. Abramowicz and I. A. Stegun, "Handbook of mathematical functions" and also the paper containing this section.

Then the final integral becomes
$$
I = \sum_{i=1}^{\alpha} \sum_{j=1}^{\beta} \sum_{k=1}^{\gamma} \frac{(1 + \zeta_{1,i})^2 (1 + \zeta_{2,j})}{64} W_i W_j^{\beta} W_k^{\gamma} \mathfrak J_{\mathbf x} f\left(\frac{(1 + \zeta_{1,i})(1 + \zeta_{2,j})(1 + \zeta_{3,k})}{8}, \frac{(1 + \zeta_{1,i})(1 + \zeta_{2,j})(1 - \zeta_{3,k})}{8}, \frac{(1+\zeta_{1,i})(1-\zeta_{2,j})}{4}\right)
$$
$$
= \sum_{m=1}^{N=(\alpha)\times(\beta)\times(\gamma)} c_m f(\xi_{1,m}, \xi_{2,m}, \xi_{3,m})
$$
where, it is obvious that
$$
\begin{align*}
c_m & = \frac{(1 + \zeta_{1,i})^2 (1 + \zeta_{2,j})}{64} \times W_i W_j W_k \mathfrak J_{\mathbf x} \\
\xi_{1,m} & = \frac{(1 + \zeta_{1,i})(1 + \zeta_{2,j})(1 + \zeta_{3,k})}{8} \\
\xi_{2,m} & = \frac{(1 + \zeta_{1,i})(1 + \zeta_{2,j})(1 - \zeta_{3,k})}{8} \\
\xi_{3,m} & = \frac{(1+\zeta_{1,i})(1-\zeta_{2,j}^{(\beta})}{4}
\end{align*}
$$
in which $\zeta_{1,i}$, $\zeta_{2,j}$, $\zeta_{3,k}$ are the sampling points and $W_i$, $W_j$, $W_k$ are the corresponding weight coefficients of Gauss Legendre quadrature for orders $\alpha, \beta, \gamma$, respectively.

## 三维空间中三角形上的面积分



## 代数精度的细节
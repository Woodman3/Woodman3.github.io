---
title: "有限元中的微积分"
description: 一些在写二阶单元的有限元热传导求解器过程中遇到的数学问题 
date: 2025-04-16T16:56:01+08:00
image: 
math: true
license: 
hidden: false
comments: true
draft: false 
categories:
  - 学习
tags:
  - 数学
  - cpp
---

这个公式被gpt称作Dirichlet积分公式,但是我用搜索引擎搜不到这个公式的具体名字,那么我也就这么叫他好了,gpt总不会骗我吧(


## Dirichlet积分公式

计算积分：
$$
I = \int_T L_1^a L_2^b L_3^c L_4^d \, dL_1dL_2dL_3,
$$
其中：
- $T$ 是三维标准四面体；
- $L_1, L_2, L_3, L_4$ 是体积坐标（$L_1 + L_2 + L_3 + L_4 = 1$）；
- $a, b, c, d$ 是非负整数。

在体积坐标下，积分区域为：
$$
L_1 \in [0,1], \quad L_2 \in [0,1-L_1], \quad L_3 \in [0,1-L_1-L_2].
$$
因此积分变为：
$$
I = \int_0^1 \int_0^{1-L_1} \int_0^{1-L_1-L_2} L_1^a L_2^b L_3^c (1-L_1-L_2-L_3)^d \, dL_3 \, dL_2 \, dL_1.
$$

**对 $L_3$ 积分**

设 $u = \frac{L_3}{1-L_1-L_2}$，则 $L_3 = u(1-L_1-L_2)$，$dL_3 = (1-L_1-L_2)du$：
$$
\int_0^{1-L_1-L_2} L_3^c (1-L_1-L_2-L_3)^d \, dL_3 = (1-L_1-L_2)^{c+d+1} \int_0^1 u^c (1-u)^d \, du.
$$
利用 **Beta 函数**：
$$
\int_0^1 u^c (1-u)^d \, du = B(c+1, d+1) = \frac{c! \, d!}{(c+d+1)!}.
$$

**对 $L_2$ 积分**

将剩余部分写为：
$$
I = \frac{c! \, d!}{(c+d+1)!} \int_0^1 \int_0^{1-L_1} L_1^a L_2^b (1-L_1-L_2)^{c+d+1} \, dL_2 \, dL_1.
$$
再次变量替换 $v = \frac{L_2}{1-L_1}$，类似可得：
$$
\int_0^{1-L_1} L_2^b (1-L_1-L_2)^{c+d+1} \, dL_2 = (1-L_1)^{b+c+d+2} \frac{b! \, (c+d+1)!}{(b+c+d+2)!}.
$$

**对 $L_1$ 积分**

最终积分简化为：
$$
I = \frac{c! \, d!}{(c+d+1)!} \frac{b! \, (c+d+1)!}{(b+c+d+2)!} \int_0^1 L_1^a (1-L_1)^{b+c+d+2} \, dL_1.
$$
利用 Beta 函数：
$$
\int_0^1 L_1^a (1-L_1)^{b+c+d+2} \, dL_1 = \frac{a! \, (b+c+d+2)!}{(a+b+c+d+3)!}.
$$

将所有部分组合：
$$
I = \frac{c! \, d!}{(c+d+1)!} \cdot \frac{b! \, (c+d+1)!}{(b+c+d+2)!} \cdot \frac{a! \, (b+c+d+2)!}{(a+b+c+d+3)!}.
$$
约简后得到 **Dirichlet 积分公式**：
$$
I = \frac{a! \, b! \, c! \, d!}{(a+b+c+d+3)!}.
$$


推广到其他维度

- **二维三角形**：分母为 $(a+b+c+2)!$，分子为$a! \, b! \, c!$。
- **$n$ 维单纯形**：分母为 $(\sum a_i + n)!$，分子类似  


## 从笛卡尔坐标到体积坐标的变换

四面体上的拉格朗日基函数变换到体积坐标下会带来不少便利.举个例子,我们需要计算以下积分

$$
\tag{1}
I = \int \phi_i \  \phi_j dV 
$$

我们可以把任意构建任意四面体到标准四面体的变换,于是变换后的积分变成了

$$
I = 6V \int_T N_i \ N_j \ dV_L
$$

其中$N_i$为形函数,至于为什么...说实话我也写不出一个严谨的证明.而雅可比矩阵行列式的值恰好等于这个四面体的体积乘6,这也十分直观,因为标准四面体的体积就是$1/6$

当然有时候也不会那么自然,比如你需要计算对基函数求梯度的积分,比如这样:

$$
\tag{2}
I = \int \nabla \phi_i \cdot \nabla \phi_j dV 
$$

需要注意,这里的求梯度运算是在笛卡尔坐标系下对$xyz$求梯度的,当变换到标准四面体下时,显然不可能再对原本的坐标系下求梯度,对于体积坐标求梯度才是我们想要的,于是有了

$$
\nabla \phi_i = J^{-1} \nabla N_i
$$

原积分变为

$$
I = |det J| \int_T \nabla N_i^T J^{-T} J^{-1}  \nabla N_j \ dV_L 
$$

再来考虑另一种情况:我们需要在四面体上的某一面上进行面积分,形式如下:

$$
\tag{3}
I = \int_S \phi_i \  \phi_j dS
$$

如果基函数取值为1的点不再我们要积分的三角形内,那么显然基函数在这个三角形上的取值全为0.因为基函数在三角形的三个顶点上的取值都为0,而三角形的其他区域上的点可以表示为顶点坐标的线性组合.所以我们只需要关注在这个三角形上有取值为1的点的基函数即可.

当我们把这些基函数变换到标准三角形上时,基函数也变为了三角形的形函数.至于为什么变换成立,其严谨的证明过程我也写不出来...尽管这个变换非常符合直觉.除此之外,我们还需要注意:当我们把三维的三角形变换到二维的三角形上时,变换矩阵并不是一个方阵,这意味着我们不能直接求解其行列式.回忆一下微积分方面的知识,我们可以计算缩放因子.因为标准三角形的面积为$1/2$,所以缩放因子恰为$2A$,这是显然的.所以原式变为

$$
I = 2A\int_{S_L} N_i \  N_j dS_L
$$

## 实例:二阶基

一阶线性基的情况过于简单,在此不表

我们的三维二阶基函数如下所示

$$
\phi = a_0 + a_1x + a_2y+a_3z+a_4x^2+a_5xy+a_6xz+a_7y^2+a_8yz+a_9z^2 
$$

其顶点和中点的形函数如下
$$
N_i = L_i(2L_i-1)
$$

$$
N_{ij}=4L_iL_j
$$

我们去求解方程(1),其结果表示为矩阵在如下所示

$$
M = \frac{6 \cdot \text{volume}}{2520}
\begin{bmatrix}
6 & 1 & 1 & 1 & -4 & -4 & -4 & -6 & -6 & -6 \\
1 & 6 & 1 & 1 & -4 & -6 & -6 & -4 & -4 & -6 \\
1 & 1 & 6 & 1 & -6 & -4 & -6 & -4 & -6 & -4 \\
1 & 1 & 1 & 6 & -6 & -6 & -4 & -6 & -4 & -4 \\
-4 & -4 & -6 & -6 & 32 & 16 & 16 & 16 & 16 & 8 \\
-4 & -6 & -4 & -6 & 16 & 32 & 16 & 16 & 8 & 16 \\
-4 & -6 & -6 & -4 & 16 & 16 & 32 & 8 & 16 & 16 \\
-6 & -4 & -4 & -6 & 16 & 16 & 8 & 32 & 16 & 16 \\
-6 & -4 & -6 & -4 & 16 & 8 & 16 & 16 & 32 & 16 \\
-6 & -6 & -4 & -4 & 8 & 16 & 16 & 16 & 16 & 32 \\
\end{bmatrix}
$$

方程(3)的结果如下所示(忽略了零元)

$$
K = \frac{2 \cdot \text{area}}{360}
\begin{bmatrix}
6 & -1 & -1 & 0 & 0 & -4 \\
-1 & 6 & -1 & 0 & -4 & 0 \\
-1 & -1 & 6 & -4 & 0 & 0 \\
0 & 0 & -4 & 32 & 16 & 16 \\
0 & -4 & 0 & 16 & 32 & 16 \\
-4 & 0 & 0 & 16 & 16 & 32 \\
\end{bmatrix}
$$

部分计算代码如下

```cpp
class Tetra10: public TetraBase{
    public:

    int index[10]={-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};
    Eigen::Matrix<double,10,3> vertices;
    Eigen::Matrix<double,10,10> basis;

    Tetra10(Eigen::Matrix<double,10,3> vertices)
        :TetraBase(vertices.topRows(4)){
        this->vertices = vertices;


        Eigen::Matrix<double,10,10> vertices_h;
        for(int i=0;i<10;i++){
            // return 1 x y z x^2 xy xz y^2 yz z^2
            auto v = vertices.row(i);
            vertices_h.row(i) << 1 , v(0), v(1), v(2),
                                  v(0)*v(0), v(0)*v(1), v(0)*v(2),
                                  v(1)*v(1), v(1)*v(2),
                                  v(2)*v(2);
        }
        this->basis = vertices_h.transpose().inverse();
    }

    ~Tetra10() = default;
};
Eigen::Matrix<double,10,10> compute_element_mass_matrix(Tetra10 &ter) {
    Eigen::Matrix<double,10,10> M;
    for(int i=0;i<10;i++){
        for(int j=0;j<10;j++){
            double e = integrate_on_tetra(ter,
                [i,j,&ter](double x,double y,double z){
                    auto b_i = ter.basis.row(i);
                    auto b_j = ter.basis.row(j);
                    double phi_i = b_i(0) + b_i(1)*x + b_i(2)*y + b_i(3)*z
                        + b_i(4)*x*x + b_i(5)*x*y + b_i(6)*x*z
                        + b_i(7)*y*y + b_i(8)*y*z + b_i(9)*z*z;
                    double phi_j = b_j(0) + b_j(1)*x + b_j(2)*y + b_j(3)*z
                        + b_j(4)*x*x + b_j(5)*x*y + b_j(6)*x*z
                        + b_j(7)*y*y + b_j(8)*y*z + b_j(9)*z*z;
                    return phi_i * phi_j ;

            },6);
            M(i,j) = e;
        }
    }
    M *= global_config.rho * global_config.capacity;
    return M;
}
Eigen::Matrix<double,10,10> compute_stiffness_matrix(Tetra10 &ter) {
    Eigen::Matrix<double,10,10> K_e;
    K_e.setZero();
    for(int i=0;i<10;i++){
        for(int j=0;j<10;j++){
            double e = integrate_on_tetra(ter,[i,j,&ter](double x,double y,double z){
                auto b_i = ter.basis.row(i);
                auto b_j = ter.basis.row(j);
                double dx_i = b_i(1) + 2*x*b_i(4) + y * b_i(5) + z * b_i(6);
                double dy_i = b_i(2) + 2*y*b_i(7) + x * b_i(5) + z * b_i(8);
                double dz_i = b_i(3) + 2*z*b_i(9) + x * b_i(6) + y * b_i(8);
                double dx_j = b_j(1) + 2*x*b_j(4) + y * b_j(5) + z * b_j(6);
                double dy_j = b_j(2) + 2*y*b_j(7) + x * b_j(5) + z * b_j(8);
                double dz_j = b_j(3) + 2*z*b_j(9) + x * b_j(6) + y * b_j(8);
                double e= dx_i * dx_j + dy_i * dy_j + dz_i * dz_j;
                return e * kappa(x,y,z);
            } ,4 );
            K_e(i,j) = e;
        }
    }
    return K_e;
}

void test_mass_matrix(auto &tetra) {
    Eigen::Matrix<double,10,10> m = compute_element_mass_matrix(tetra);
    m /= tetra.volume*6; 
    Eigen::Matrix<double, 10, 10> mat;
    mat << 
        6,   1,   1,   1,  -4,  -4,  -4,  -6,  -6,  -6,
        1,   6,   1,   1,  -4,  -6,  -6,  -4,  -4,  -6,
        1,   1,   6,   1,  -6,  -4,  -6,  -4,  -6,  -4,
        1,   1,   1,   6,  -6,  -6,  -4,  -6,  -4,  -4,
       -4,  -4,  -6,  -6,  32,  16,  16,  16,  16,   8,
       -4,  -6,  -4,  -6,  16,  32,  16,  16,   8,  16,
       -4,  -6,  -6,  -4,  16,  16,  32,   8,  16,  16,
       -6,  -4,  -4,  -6,  16,  16,   8,  32,  16,  16,
       -6,  -4,  -6,  -4,  16,   8,  16,  16,  32,  16,
       -6,  -6,  -4,  -4,   8,  16,  16,  16,  16,  32;

    mat *= 1/2520.0;

    for(int i=0;i<10;i++){
        for(int j=0;j<10;j++){
            if(abs(m(i,j)-mat(i,j))>1e-20){
                cout << "mass matrix test failed!" <<endl;
                cout << m(i,j) << " " << mat(i,j) <<endl;
                return;
            }
        }
    }

}

void test_stiffness_matrix(auto &tetra) {
    Eigen::Matrix<double,10,10> k = compute_stiffness_matrix(tetra);
    cout << k <<endl;
}

void test_robin_boundary(Tetra10 &ter,Triangle6 &tri) {
    MatrixXd K(10,10);
    VectorXd F(10);
    double threshold = 1e-10;
    for(int i=0;i<10;i++){
        for(int j=0;j<10;j++){
            double k_e = integrate_on_triangle(tri,
                [i,j,ter](double x,double y,double z){
                    auto b_i = ter.basis.row(i);
                    auto b_j = ter.basis.row(j);
                    double phi_i = b_i(0) + b_i(1)*x + b_i(2)*y + b_i(3)*z
                        + b_i(4)*x*x + b_i(5)*x*y + b_i(6)*x*z
                        + b_i(7)*y*y + b_i(8)*y*z + b_i(9)*z*z;
                    double phi_j = b_j(0) + b_j(1)*x + b_j(2)*y + b_j(3)*z
                        + b_j(4)*x*x + b_j(5)*x*y + b_j(6)*x*z
                        + b_j(7)*y*y + b_j(8)*y*z + b_j(9)*z*z;
                    return phi_i * phi_j ;
            } ,4 );
            if(k_e < threshold)
                k_e = 0;
            K.coeffRef(i,j) = k_e;
        }
        double f_e = integrate_on_triangle(tri,
            [i,ter](double x,double y,double z){
                auto b_i = ter.basis.row(i);
                double phi_i = b_i(0) + b_i(1)*x + b_i(2)*y + b_i(3)*z
                    + b_i(4)*x*x + b_i(5)*x*y + b_i(6)*x*z
                    + b_i(7)*y*y + b_i(8)*y*z + b_i(9)*z*z;
                return phi_i;
        },4);
        if(f_e < threshold)
            f_e = 0;
        F.coeffRef(i) += f_e ;
    }
    K /= tri.area *2;
    F /= tri.area *2;

    cout << K << endl;
    cout << F << endl;
}

int main() {
    global_config.rho = 1;
    global_config.capacity = 1;
    global_config.kappa =1;
    global_config.q_args = Q_Exp_Args{1,0};
    Matrix<double,10,3> vertices;    
    vertices.topRows(4) << 5,5,5,
                2,0,0,
                0,3,0,
                0,0,4;

    int nextRow = 4; // 从第5行开始填充
    for(int i = 0; i < 3; i++) {
        for(int j = i + 1; j < 4; j++) {  // 注意：初始化了前4行，应遍历到3
            vertices.row(nextRow++) = (vertices.row(i) + vertices.row(j)) / 2.0;
        }
    }
    Tetra10 tetra(vertices);
    MatrixXd tri_vertices(6,3);
    tri_vertices<<vertices.row(0),
                  vertices.row(1),
                  vertices.row(2),
                  vertices.row(4),
                  vertices.row(5),
                  vertices.row(7);
    cout<<tri_vertices<<endl;
    Triangle6 tri(tri_vertices);
    test_load_vector(tetra);
    test_robin_boundary(tetra, tri);
    return 0;
}
```
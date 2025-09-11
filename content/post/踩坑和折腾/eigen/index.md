---
title: Eigen中的运行时选择稀疏矩阵求解器
description: 
date: 2025-07-01T17:36:12+08:00
image: 131114090_p0.jpg
math: 
license: 
hidden: false
comments: true
draft: false
categories:
  - 踩坑和折腾
tags:
  - cpp
---

## 起因

因为eigen中的稀疏矩阵求解器使用CRTP，无法直接使用基类指针来实现运行时分发，因此使用`variant`来实现，实现的源码如下：

```cpp
#pragma once
#include <exception>
#include <variant>

#include <Eigen/Sparse>
#ifdef EIGEN_USE_MKL_ALL
#include <Eigen/PardisoSupport>
#endif

class SparseSolverWrapper {
public:
    using VectorXd = Eigen::VectorXd;
    using SparseMatrix = Eigen::SparseMatrix<double>;
    
    using SolverVariant = std::variant<
    #ifdef EIGEN_USE_MKL_ALL
        Eigen::PardisoLLT<SparseMatrix, Eigen::Upper>,
        Eigen::PardisoLU<SparseMatrix>,
        Eigen::PardisoLDLT<SparseMatrix, Eigen::Upper>,
    #endif
        Eigen::SimplicialLLT<SparseMatrix, Eigen::Upper>,
        Eigen::SimplicialLDLT<SparseMatrix, Eigen::Upper>
    >;

    SolverVariant solver;

    void compute(const SparseMatrix& A);
    VectorXd solve(const VectorXd& b);
    bool success() const;
    void init(SparseMatrix A);

private:
    template <typename SolverType>
    void emplace(auto&&... args){
        solver.emplace<SolverType>(std::forward<decltype(args)>(args)...);
    }
};
```

```cpp
#include "sparse_solver_wrapper.h"
#include <iostream>

using VectorXd = Eigen::VectorXd;
using SparseMatrix = Eigen::SparseMatrix<double>;

void SparseSolverWrapper::compute(const SparseMatrix& A) {
    std::visit([&](auto& s) { s.compute(A); }, solver);
}

SparseSolverWrapper::VectorXd SparseSolverWrapper::solve(const VectorXd& b) {
    return std::visit([&](auto& s) -> VectorXd {
        return s.solve(b);
    }, solver);
}

bool SparseSolverWrapper::success() const {
    return std::visit([](const auto& s) {
        return s.info() == Eigen::Success;
    }, solver);
}

void SparseSolverWrapper::init(SparseMatrix A) {
    if (A.rows() == 0 || A.cols() == 0) {
        throw std::runtime_error("Sparse matrix is empty, cannot initialize sparse martix solver.");
    }
    
    #ifdef EIGEN_USE_MKL_ALL
    std::cout<< "Using MKL Pardiso solvers." << std::endl;
    emplace<Eigen::PardisoLDLT<SparseMatrix, Eigen::Upper>>(A);
    if (success()) return;

    emplace<Eigen::PardisoLLT<SparseMatrix, Eigen::Upper>>(A);
    if (success()){
        std::cout<< "Using PardisoLLT solver." << std::endl;
        return;
    } 

    emplace<Eigen::PardisoLU<SparseMatrix>>(A);
    if (success()){
        std::cout<< "Using PardisoLU solver." << std::endl;
        return;
    }
    #endif

    emplace<Eigen::SimplicialLDLT<SparseMatrix, Eigen::Upper>>(A);
    if (success()){
        std::cout<< "Using Eigen SimplicialLDLT solver." << std::endl;
        return;
    } 

    emplace<Eigen::SimplicialLLT<SparseMatrix, Eigen::Upper>>(A);
    if( success()){
        std::cout<< "Using Eigen SimplicialLLT solver." << std::endl;
        return;
    } 

    throw std::runtime_error("All solver methods failed to initialize.");
}
```

看上去似乎没啥问题，但是如果你把以上代码用gcc编译成一个库，并启用mkl的话，在运行时就会报段错误。在gdb中，段错误的地方是`getenv.c`，这是一个查找环境变量的函数，并且查找的环境变量名字还被去掉了头两个字母，我也不知道这两个字母是怎么没的，比如`INTEL_LIBITTNOTIFY64`变成了`TEL_LIBITTNOTIFY64`这种奇怪的名字。但是哪怕你手动设置了这两个环境变量，他还是会在这个地方报错。

如果是用intel自家的icpx来编译的话，则会出现另一个问题，在调用`init`后再使用`compute`的时候，`solver`内部的size变了，意思内存错误。

## 解决方法

如果连接的库使用了`EIGEN_USE_MKL_ALL`这个宏，那么链接这个库的程序也要启用`EIGEN_USE_MKL_ALL`这个宏，启用后就没问题了。具体大概率是头文件里的类型定义和实际编译的库里的类型不一致。

## 其他问题

后面我试图添加其他求解器时，发现不应该使用值传递，因为有些求解器不会复制矩阵而是保存矩阵的引用。

在调用的时候我还发现，我在编译的时候加了`-march=native`这个参数，回导致abi接口不一致，如果用了那么必须把这个参数也传给所有链接这个库的程序。


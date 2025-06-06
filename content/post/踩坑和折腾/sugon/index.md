---
title: "pgc++编译时指定c++版本则无法编译"
description: 
date: 2024-07-08T17:48:02+08:00
image: 120269913_p0.png
math: 
license: 
hidden: false
comments: true
draft: false 
categories:
    - 踩坑和折腾
tags:
    - hpc
    - 坑
---


## 背景

由于需要在曙光的超算上用openacc写程序，但是我所在的分区只有pgi编译器。在使用pgc++或者nvc++时，一旦指定的c++版本大于11，编译器就会出现以下错误。

```bash
"/opt/rh/devtoolset-7/root/usr/include/c++/7/type_traits", line 347: error:
          class "std::__is_floating_point_helper<long double>" has already been
          defined
      struct __is_floating_point_helper<__float128>
             ^

"/opt/rh/devtoolset-7/root/usr/include/c++/7/bits/std_abs.h", line 102: error:
          function "std::abs(long double)" has already been defined
    abs(__float128 __x)
    ^

2 errors detected in the compilation of "main.cpp"
```

## 解决

这个错误的原因是因为曙光超算在登陆时会自动加载一些模块，使用`module list`查看已加载的模块，发现除了我自己手动加载的pgi模块，还有mpi和一个基础的编译器模块，把这两个模块卸除，只留下pgi模块，即可正常编译。
---
title: "Sugon"
description: 
date: 2024-07-08T17:48:02+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: true
---

# 
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

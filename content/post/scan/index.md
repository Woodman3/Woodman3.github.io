---
title: "前缀和算法及其分段版本"
description: 
date: 2024-07-24T15:03:27+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: false 
---

cmu15418在2012年的课程里还有讲这个算法，但是现在我在他的课程大纲上已经看不到这个算法的讲解。
国内外关于这个算法的资料大多数也是少的可怜。故作此文。

前缀和一般有两种形式，一种在计算时会加上当前的元素（inclusive），另一种则不会（exclusive），本文所述皆为后者。

本文为简便起见，皆使用openmp的方式并行。

## 基础前缀和

### 串行

```cpp
template<typename T, class OP>
void exclusive_scan_seq(T* a,T init, size_t n, OP op){
    T tmp = a[0];
    a[0] = init;
    for(int i=1;i<n;i++){
        T t = a[i];
        a[i] =op(tmp,a[i-1]);
        tmp = t;
    }
}
```
很简单，没啥好说的

### 并行

```cpp
template<typename T, class OP>
void exclusive_scan_par(T* a,T init, size_t n, OP op){
    int offset=1;
    for(;offset<n;offset<<=1){
        #pragma omp parallel for
        #pragma unroll 
        for(int i =n-1-offset;i>=0;i-=offset<<1){
            a[i+offset] = op(a[i],a[i+offset]);
        }
    }
    a[n-1] = init;
    for(;offset>0;offset>>=1){
        #pragma omp parallel for
        #pragma unroll 
        for(int i =(n-1)-offset;i>=0;i-=offset<<1){
            T temp = a[i];
            a[i] = a[i+offset];
            a[i+offset] = op(a[i+offset],temp);
        }
    }
}
```

程序的前半部分我称之为前向传播（在论文原文中为up-sweep），后半部分我称之为反向传播（down-sweep）。

cmu15418的ppt给的配图里的数组长度刚好为2的幂次方，但是如果数组不为2的幂次方，那么情况会有些许麻烦。
我的建议是，先理解反向传播，在去看正向传播。因为我们不难注意到：初始值是在反向传播的过程中才开始被加入到数组中的。
而根据前缀和的定义，这个初始值势必会传播到数组上的所有位置。记住这一点，反向传播的过程就好理解多了。

尽管他的复杂度也为$O(n)$，但是根据实际测试，其所消耗的时间依旧比串行版本更久，推测原因可能是线程划分太密导致的。（我的并行版本与课程所示的不同课程ppt上的更加繁琐一些）

## 分段前缀和

相比传统前缀和，我们额外增加了一个`flags`来把数组分成大小不同的几段，用`1`来表是一个段的开始，`0`来表示处于一个段中。
一般来说，`flags`的第一个元素为`1`。
### 串行
```cpp
template<typename T, class OP>
void exclusive_seg_scan_seq(T* a,int* flags,T init, size_t n, OP op){
    T tmp = a[0];
    for(int i=0;i<n;i++){
        if(flags[i]){
            tmp = a[i];
            a[i] = init;
        }else{
            T t = a[i];
            a[i] =op(tmp,a[i-1]);
            tmp = t;
        }
    }
}
```

### 并行

```cpp
template<typename T, class OP>
void exclusive_seg_scan_par(T* a,int* flags,T init, size_t n, OP op){
    int offset=1;
    int fb[n];
    for(int i=0;i<n;i++){
        fb[i] = flags[i];
    }
    for(;offset<n;offset<<=1){
        #pragma omp parallel for
        #pragma unroll 
        for(int i =n-1-offset;i>=0;i-=offset<<1){
            if(!flags[i+offset]){
                a[i+offset] = op(a[i],a[i+offset]);
                flags[i+offset] |= flags[i];
            }
        }
    }
    a[n-1] = init;
    flags[n-1]=0;
    for(;offset>0;offset>>=1){
        #pragma omp parallel for
        #pragma unroll 
        for(int i =(n-1)-offset;i>=0;i-=offset<<1){
            T temp = a[i];
            a[i]= a[i+offset];
            if(fb[i+1]){
                a[i+offset] = init;
            }
            else if(flags[i]){
                a[i+offset] = op(init,temp);
            }else{
                a[i+offset] = op(a[i+offset],temp);
            }
        }
    }
}
```
这个代码我虽然无法理解，但是他运行的结果和串行版本一致，[ 源码在此 ](https://github.com/Woodman3/hpc_algorithm.git)，如果有纰漏的情况还请指出。

在课程的ppt中，可能是默认初始值为0的缘故，反向的过程有些bug，毕竟在初始值为0的情况下，`+ 0`和啥也不写没区别。

前向过程很好理解，因为flags如果不为0,那么我们可以肯定这一次求和会涉及到其他段。

反向过程我也无法理解，但是不难发现，反向传播我们有时候会需要把其他段的值移到当前位置，这样才能在后续的过程中传递到正确位置。
但是如果在一次求和中，如果我们发现左边的位置恰为他那个段的最后一位，那么则不需要保留其值，这就是第一个if的目的。

后面的我也不会了，留给后人分析吧。

## 参考

1. [cmu](https://www.cs.cmu.edu/afs/cs/academic/class/15418-s12/www/lectures/24_algorithms.pdf)
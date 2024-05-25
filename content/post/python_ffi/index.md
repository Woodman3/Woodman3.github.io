---
title: "关于python调用动态库获取字符串这件事"
description: 
date: 2024-05-25T18:04:54+08:00
image: ug0nba.jfif
math: 
license: 
hidden: false
comments: true
draft: false 
categories:
    - coding
---

# 问题的提出 
假设我们的动态库代码如下

```c
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

char* new_str(){
    char* str = (char*)malloc(10*sizeof(char));
    strcpy(str, "Hello");
    printf("str: %p\n", str);
    return str;
}
```

使用如下命令编译

```bash
gcc -fPIC -shared -o libtest.so test.c
```

我们可以很轻松的写出（有一点危险）的调用方法

```python
from ctypes import *
lib = CDLL("./libtest.so")
lib.new_str.restype = c_char_p 
data = lib.new_str()
```

我们十分顺利的获得了字符串！但是注意到，我们的字符串是分配在堆上的，这个字符串是什么时候被释放掉的呢？
我做了一个小实验，在一个死循环里不断的获取字符串，不一会儿这个小小的python程序的内存占用就到达了100%，看上去这些内存并没有释放。于是我们编写一个对应的释放函数

```c
void free_str(char* str){
    free(str);
}
```

在我试图把指针传回给动态库的时候，我注意到`data`的类型是`bytes`，也就是说如果你就这么调用如下代码的话
```python
lib.free_str(data)
```
是会报错的。事实上，哪怕你不指定函数的返回类型，或者指定返回类型为`c_void_p`，你都无法把这个指针传给动态库。
`ctypes`在调用动态库的时候，默认会把动态库方法的返回类型设置为`int`如果你把这个整形打印出来和动态库那边的指针作比较，你会发现这两个的值完全不同。

# 解决方法
把动态库的放回类型设置为`POINTER(c_char)`即可，代码如下

```python
from ctypes import *
 
lib = CDLL("./libtest.so")
lib.new_str.restype = POINTER(c_char) 

while(1):
    p = lib.new_str() 
    data = cast(p, c_char_p).value
    lib.free_str(p)
    print(data)
```
运行后发现内存占用没有增长，说明内存被成功释放。
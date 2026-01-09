---
title: Cpp_cheatsheet
description: 一个助记的，有些东西老是忘
date: 2025-09-09T15:02:33+08:00
image:
math:
license:
hidden: true
comments: true
draft: false
---

## 类的成员函数修饰符

`= default`

强制编译器自动生成

`= delete`

强制编译器不自动生成

`= 0`

纯虚函数，这个函数必须被override，同时也必须搭配`virtual`

`noexcept`

这个函数不会抛出异常

`const`

这个函数不会改变成员变量

`volatile`

会修改被`volatile`修饰的成员变量

`virtual`

声明为虚函数，一般写在父类，子类也可以写但是有点冗余，一般子类写个`override`就够了

`final`

和`override`差不多，但是阻止后面的子类继续重写这个函数

`explicit`

防止隐式转换

## 杂项

- 短路表达式是标准的一部分，放心使用

- 有返回值的函数在结尾没有返回属于UB，但是这个有时候会被编译器的内联优化给忽略。使用nvcc编译的时候，没有返回值会导致`Illegal instruction`或`CUDA error: an illegal memory access was encountered`



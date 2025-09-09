---
title: "Cpp_cheatsheet"
description: 一个助记的，有些东西老是忘
date: 2025-09-09T15:02:33+08:00
image: 
math: 
license: 
hidden: false
comments: true
draft: true
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

声明为虚函数

---
title: 备忘录：使用pprof 分析cpp程序
description: 老板的任务罢了
date: 2025-09-30T14:37:44+08:00
image: G2tOID9aoAAq-wu.jpg
math:
license:
hidden: false
comments: true
draft: false
categories:
  - 踩坑和折腾
tags:
  - cpp
  - 坑
  - hpc
---

## gperftools

如果是用的ubuntu，可以直接使用apt来安装 `libgoogle-perftools-dev`，包管理器会自动安装好unwind和graphiz，但是并不会安装pprof。

在链接选项里加上`-lprofiler`，但是如果代码里没用上`libprofiler.so`里的东西的话实际产物是不会链接这个库的，所以你还许要加一个`-Wl,--no-as-needed`来强制链接。

运行前要设置一个环境变量`CPUPROFILE=./profile ./myprogram`

## pprof

pprof是go里的工具，所以你还需要把go装上才能用。哪怕你手动编译安装gperftool也没有。apt里的go版本太老，得自己去官网下载安装并设置对应的环境变量，在此不多说。

go直接装包大概率会因为连不上github而装不上，可以配置goproxy的值来更改下载的地方，这个proxy类似镜像站。

下载后的pprof在`~/go/bin`下。

使用

```bash
pprof --pdf a.out test.prof > test.pdf
```

来生成分析的pdf报告。

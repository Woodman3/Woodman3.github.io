---
title: "关于如何在windows下打开摄像头这件事"
description: 
date: 2024-05-18T21:48:53+08:00
image: 118584014_p0.png
math: 
license: 
hidden: false
comments: true
draft: false 
categories:
    - 踩坑和折腾
---

# 起因
在下girl band cry种子的时候发现字幕组推荐使用mpv播放器，了解到mpv+anime4k之后，忽然觉得正在用的potplayer似乎没那么香了。在准备投入mpv的怀抱之前，还有最后一件事需要解决：potplayer除了用了播放视频之外，我还用它来采集视频，比如ns的游戏画面。那么，mpv也可以用来采集游戏视频吗？

在此之前，我不是没有试过别的采集方案。我分别用obs player和vlc来采集视频，但是这两种方案都有相同的缺点——延迟非常大。于是我也只能继续用potplayer，mpv会不一样吗？

# potplayer采集的缺点
potplayer采集的视频延迟不大，但是如果声音延迟会逐渐变大，而且会有不少杂音。所以我一直都不会有potplayer去采集音频，而是直接在windows的声音设置的麦克风里开启侦听选项，延迟会小不少。

# 摄像头
采集视频时，选项里既有笔记本自带的摄像头，也有采集卡。所以我认为打开摄像头和打开采集卡本质上是一回事，所以我起了这么一个标题。在linux上打开摄像头十分简单，arch wiki对此有详细的[介绍](https://wiki.archlinux.org/title/webcam_setup)，在此就不说了。然而很不幸的是我使用的是windows，wsl里也没有我的摄像头。那么如何在windows下打开摄像头呢？

最常见的方法是使用windows自带的相机应用，延迟也低。但是这种方法无法全屏，很是遗憾。

# 设备名
不同于linux可以直接在`\dev\`下查看设备名，windows下可以在设备管理器来查看设备名，也可以用ffmpeg来查看。
```powershell
ffmpeg -list_devices true -f dshow -i dummy
```

# mpv 和 mpv.net
我并没有直接使用mpv，而是使用mpv.net。我在mpv.net打开选项里没有看到设备，但是可以使用命令行打开摄像头。

```powershell
mpvnet av://dshow:video="Integrated Camera"
```

遗憾的是，这样打开后的视频延迟也非常慢，我怀疑mpv打开会好一些，mpv打开的命令类似：

```powershell
mpv av://dshow:video="Integrated Camera"
```
打开的延迟也很大，远远不如potplayer。

# ffplay
但是我在这过程中发现了另一个延迟不大的方法，那就是装ffmpag时附带的ffplay来打开摄像头
```powershell
ffplay -f dshow -i video="Integrated Camera" -fs
```
`-fs`是全屏显示用的，如无必要也可以去掉
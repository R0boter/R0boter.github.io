---
layout: post
title: Archlinux 桌面环境安装脚本介绍
categories: [Archlinux,个人]
---

## 简介

> 关于我为什么选择 Archlinux，以及我使用 Archlinux 所遵循的原则，请您参考[这篇博文](我的Archlinux)

此脚本主要是为我使用的平铺式窗口 DWM 准备的安装脚本，用于配置安装 DWM 前的 X11 窗口服务，和安装后我日常中会用到的常用软件

先简单介绍一下，我日常使用的 Archlinux 桌面环境

- 窗口管理器：DWM
- 终端：ST
- 程序启动器：Dmenu
- 文件管理器：ranger(其实不太常用，主要是预览图片的时候用的多一些)
- 输入法：fcitx5(支持中文，主题有类似 windows10 的那种单行显示，单行显示支持的应用程序很多但终端不多)
- 视频播放器：mpv(还可以看直播)
- 浏览器：firefox
- 邮件：mutt
- 消息通知：dunst
- 编辑器：neovim(最重要的工具，日常使用基本就是浏览器和编辑器和终端)
- 其他各种语言的解释器或编译器

## 脚本执行流程

1. 首先会要求您输入您的 CPU 型号，如 intel、amd、vmware、virtualbox。(这一点可能是里面最重要的一点了)
2. 安装桌面环境最基础的依赖
    - xorg-server：X11 服务
    - xorg-xinit：用于设置 X11 窗口启动文件
    - xclip：X11 窗口剪贴板程序(neovim要共享系统剪贴板，则必须安装)
    - xorg-xsetroot：根窗口设置工具(用于设置 DWM 状态栏)
    - alsa-utils：声卡驱动和终端下的声音管理工具(无论你使用什么桌面管理工具，也一定会有这个作为依赖的)
3. 向 `.zprofile` 写入自动启动桌面环境。`.zprofile` 是 `zsh` 的环境配置文件，类似于 `bash` 的 `.profile`
4. 将我的 `.xinitrc` 配置文件拷贝到家目录下
5. 创建家目录下的常用文件夹：下载、文档、图片、音乐、视频(因为是平铺式，所以我觉得桌面文件夹没什么必要)
6. 下载我的 dwm、st、dmenu 源码，方便安装完成后我进行编译安装
7. 安装输入驱动、中文字体和中文输入法
    - xf86-input-libinput：输入驱动
    - 思源宋体和思源黑体
    - fcitx5：输入法框架
    - fcitx5--chinese-addons：中文输入法
    - fctix5-gtk：fcitx5 对 gtk 程序的支持
    - fcitx5-qt：fcitx5 对 QT 程序的支持
    - fcitx5-material-color：fcitx5 单行主题包
8. 拷贝我准备好的 nerdfonts(因为 archlinux 官方仓库里没有 nerdfonts 的包，所以我将 fira 字体的 nerdfonts 补丁版放在我的配置仓库里，直接拷贝过去就行)
9. 拷贝我的字体配置文件
10. 安装日常使用的软件
    - xcompmgr：窗口渲染器
    - patch：补丁工具
    - dunst：消息通知程序，它依赖于 libnotify
    - ranger：文件管理器
    - ueberzug：ranger 预览图片的依赖
    - feh：图片查看和壁纸设置软件
    - mpv：视频播放器
    - firefox：浏览器
11. 安装各种语言解释器或编译器和它们的包管理工具及配置

Tips：**最后，在脚本跑完后，进入到下载好的dwm、st、dmenu的目录分别编译安装，重启后就进入到我的桌面环境中了**
## 后记

以上就是我日常使用的archlinux的环境，使用之前的 Archlinux 安装脚本，和这个桌面环境安装脚本，可以省去每次对新环境安装 archlinux 的烦琐，或者是滚挂后的快速恢复(即使在没有备份的情况下，也可以快速恢复)

提醒：如果您不是使用的平铺式窗口管理器，不建议直接使用此脚本，因为有些东西你在安装类似kde、gnome、xfce等桌面环境时它会自动给你安装，有些则不需要，因为桌面环境有它自己的一些工具

我比较建议的是您根据此脚本，编写属于您自己环境的 archlinux 安装脚本，且我的配置文件都是根据我个人习惯编写，不一定适合您，只有适合自己的才是最好的













































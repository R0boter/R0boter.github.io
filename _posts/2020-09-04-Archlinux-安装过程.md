---
layout: post
title: Archlinux 安装过程
categories: [Archlinux]
---

## 简介

此文是我整理之前笔记时发现的当初尝试 Archlinux 时写的安装笔记，现在移植到我的博客。

此文仅用于初次接触 Archlinux 的朋友，了解官方 wiki 上写的安装步骤中，每个操作的含义，以及为什么怎么操作

如果您想搭建您自己的 Archlinux ，建议看我另两篇博文(配合安装脚本一起食用，效果更好)

[Archlinux 安装脚本](Archlinux-安装脚本)和[Archlinux 桌面环境安装脚本](Archlinux-桌面环境安装脚本)

**Tips：此文章所写安装方法及安装的软件和我现在使用的出入比较大，但和 WIKI 上推荐的安装方法还是一样，所以仅有参考价值。建议看另两篇文章**

## 准备

1. 下载镜像

2. 验证镜像

3. 刻录

4. 启动到 live 环境

5. 查看和设置键盘布局 `ls /usr/share/kbd/keymaps/**/*.map.gz && loadkeys de-latin1` 示例是加载德国键盘

6. 查看启动类型是否是 UEFI `ls /sys/firmware/efi/efivars` 有输出就是，反之不是

7. 联网，有线使用 `dhcpcd`自动分配一个 IP 就行 无线使用 `wifi-menu`
8. WIFI 联网`wpa_supplicant`创建配置文件，和使用配置文件连接 WIFI，连接后

9. 校准时间 `timedatectl set-ntp true && timedatectl status`

10. 分区 `cfdisk /dev/sda` EFI 模式下一个 260M-512M 的 EFI 分区

11. 格式化分区 `mkfs.fat -F32 /dev/sda1 && mkfs.ext4 /dev/sda2`

12. 挂载 `mount /dev/sda2 /mnt && mkdir /mnt/boot && mount /dev/sda1 /mnt/boot`

## 安装 Arch 基本系统

1. 选择镜像源 `vim /etc/pacman.d/mirrorlist` 选择一个合适的源剪切到最前面，或者注释其他源

2. 安装基本包 `pacstrap /mnt base linux linux-firmware`

   1. 必须的：

      > base : arch 基础包
      > linux : 内核
      > linux-firmware : 固件
      > Tips : 也可以不安装内核和固件 :)

   2. 非必须
      > 文件系统：用于挂载其他文件系统如 ntfs-3g 用于挂载 NTFS 文件系统。也可以以后再安装
      > 访问 RAID 或 LVM 的工具
      > 不包含在 linux-firmware 中的额外的固件
      > 网络管理工具 netctl 和它的可选依赖包：DHCP : dhcpcd、WPA : wpa_supplicant、WIFI-menus : dialog
      > 文本编辑器 vim、nano
      > 手册 man-db、man-pages、texinfo

3. 配置系统

   1. 创建 fstab 文件，`genfstab -L /mnt >> /mnt/etc/fstab`，`-L` 用标签标识分区、`-U` 用 UUID 标识分区。UUID 在格式化分区时自动生成，标签可以自定义但必须具有唯一性。此文件用于定义磁盘分区，和其他块设备或远程文件如何装入文件系统(挂载)，可用于自动挂载

   2. 切换根到新系统 `arch-chroot /mnt`

   3. 设置时区 `ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime`

   4. 设置硬件时钟为 UTC 并生成文件 `hwclock --systohc`

   5. 设置本地编码

      1. 在 `/etc/locale.gen` 中取消需要的字符编码的注释，常用的有 `en_US.UTF-8 zh_CN.UTF-8 zh_CN.GBK`

      2. 生成文件 `locale-gen`

      3. 设置默认环境变量 `echo 'LANG=en_US.UTF-8' > /etc/locale.conf`

   6. 网络设置

      1. 设置主机名 `echo 'Parrt0' > /etc/hostname`

      2. 添加主机匹配项到文件 `/etc/hosts`

      ```ini
          127.0.0.1   localhost
          ::1         localhost
          127.0.0.1   Parrt0.localdomain  Parrt0
      ```

   7. 设置 root 密码 `passwd`

   8. 安装启动引导程序和 CPU Microcode 更新

      1. 安装 grub 和 efibootmgr `pacman -S grub efibootmgr` GRUB 是启动引导器，efibootmgr 被 GRUB 脚本用来将启动项写入 NVRAM

      2. 部署 GRUB `grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB` 这是 EFI 的部署方式，BOIS 引导参考 Wiki 。目录是指定 EFI 分区的挂载点。id 可以自行设置。详细介绍看 Wiki

      3. 安装 CPU Microcode 更新 `pacman -S intel-ucode` GRUB 在生成配置文件时会自动加载这个，其他启动器需要手动添加，查看 Wiki。AMD 处理器应该安装 `amd-ucode`

      4. 生成配置文件 `grub-mkconfig -o /boot/grub/grub.cfg`

   9. 退出、卸载、重启 `exit && umount -R /mnt && reboot`

## 安装日常工具和桌面环境及配置

1. 安装桌面及终端

   1. dwm demun

   2. intel 开源显卡驱动 xf86-video-intel

   3. 触摸板输入设备驱动 xf86-input-libinput

   4. 终端及默认 shell oh-my-zsh 和 st

   5. 软件 git wget curl unrar unzip tar

   6. 登录管理器 lightdm lightdm-gtk-greeter

   7. 字体 adobe-source-han-sans-cn-fonts tty-dejavu

2. 系统管理

   1. 用户和用户组

      > 添加用户：`useradd -m -g users -G wheel,uucp -s /bin/zsh leon`
      > 设定密码：`passwd leon`

   2. 权限提升，安装 sudo，修改 `/etc/sudoer` 去掉 `%wheel` 前的注释(其中一条即可)

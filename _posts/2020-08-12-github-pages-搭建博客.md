---
layout: post
title: github pages 搭建博客
categories: [博客, 建站]
---

## 基础

使用 github pages 搭建博客的可以选择的开源的静态博客生成器有三种

1. [jekyll](http://jekyllcn.com/)：使用 ruby 构建，github 原生支持。可以直接将源码布置到 github 上
2. [hexo](https://hexo.io/)：使用 nodejs 构建，各种模板、插件丰富。博客生成速度比 jekyll 快一些
3. [hugo](https://gohugo.io)：使用 go 构建，速度极快，文档简洁

以下为可选项：

- 使用自定义域名访问自己的博客
- 为自己的域名做 cdn 加速

## 建立博客仓库

1. 申请一个 github 账号
2. 新建一个仓库，仓库名为 用户名.github.io 以我的为例，我用户名为 R0boter ,则仓库名为 R0boter.github.io
3. 仓库设置为公共仓库，即 Public
4. 本地搭建 jekyll 环境，关于 jekyll 的基本使用和基础知识我会在[这篇博文](./2020-08-12-jekyll-github官方静态网页生成器)里做详细介绍

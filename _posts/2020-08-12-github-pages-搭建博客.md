---
layout: post
title: Github Pages 搭建博客
categories: [博客, 建站]
---

## 基础

使用 github pages 搭建博客的可以选择的开源的静态博客生成器有三种

1. [jekyll](http://jekyllcn.com/)：使用 ruby 构建，github 原生支持。可以直接将源码布置到 github 上
2. [hexo](https://hexo.io/)：使用 nodejs 构建，各种模板、插件丰富。博客生成速度比 jekyll 快一些
3. [hugo](https://gohugo.io)：使用 go 构建，速度极快，文档简洁

> 以下为可选项：

- 使用自定义域名访问自己的博客
- 为自己的域名做 cdn 加速

## 建立自己的博客

1. 申请一个 github 账号
2. 新建一个仓库，仓库名为`username.github.io`以我的为例，我用户名为`R0boter` ,则仓库名为`R0boter.github.io`。仓库必须设置为公共仓库，即 Public
3. 本地搭建 jekyll 环境，关于 jekyll 的基本使用和基础知识我会在[这篇博文](Jekyll-Github-官方静态网页生成器)里做详细介绍
4. 使用 jekyll 初始化博客文件夹，或者下载别人已经做好的使用 jekyll 的博客
5. 将本地的文件夹初始化为 git 仓库，并关联到之前新建的仓库。关于 git 的基本使用方法我会在[这篇博文](Git-初体验)里做详细介绍
6. 写文章，并推送到 github 远程仓库，访问你的博客地址`username.github.io`

## 后续设置说明

一般来说，这个时候属于你的私人博客就已经搭建完毕了，你的 Github 仓库名就是你博客的访问地址。

而 github 在国内的访问速度不尽如人意，且一般我们都希望有一个专属于我们自己的域名(即访问地址)。

所以下面就是如何设置自己的域名，以及为国内访问进行加速

> Tips：以下为可选项

## 设置域名

首先，你需要购买一个域名，建议在域名注册商处购买，而不是代理商处购买。所有的域名注册商可以在[这里](https://www.icann.org/registrar-reports/accreditation-qualified-list.html)查询到

推荐几个国内的域名注册商：

1. 阿里云旗下[万网](https://wanwang.aliyun.com/)
2. 腾讯旗下[DNSPod](https://dnspod.cloud.tencent.com/)
3. [华为云](https://www.huaweicloud.com/product/domain.html)
4. [西部数据](https://www.west.cn/services/domain/)
5. [新网](http://www.xinnet.com/domain/domain.html)

国外的域名注册商：

1. [GoDaddy](https://sg.godaddy.com/zh/domains/domain-name-search)
2. [NameSilo](https://www.namesilo.com/)
3. [NameCheap](https://www.namecheap.com/)
4. 免费域名注册商[Freenom](https://www.freenom.com/)，关于免费域名，如果想要了解，可以查看[这篇博文](如何获取一个免费的域名)

在拥有了一个自己的域名后，首先到 github 的仓库处设置自定义域名

首先点击仓库的设置，进入设置界面

![](/assets/2020-08-12-github-pages-搭建博客/22-45-48.png)

然后一直向下，找到 Github Pages 设置

![](/assets/2020-08-12-github-pages-搭建博客/22-48-05.png)

再去域名注册商处对域名添加 DNS 解析记录，以我的为例：

![](/assets/2020-08-12-github-pages-搭建博客/11-30-40.png)

![](/assets/2020-08-12-github-pages-搭建博客/11-32-44.png)

获取 github pages 的 IP 地址，使用[站长工具](https://ping.chinaz.com/)

![](/assets/2020-08-12-github-pages-搭建博客/11-38-14.png)

记录下有效的 IP 地址

![](/assets/2020-08-12-github-pages-搭建博客/11-39-44.png)

添加 A 记录和 CNAME 记录

![](/assets/2020-08-12-github-pages-搭建博客/11-41-01.png)

有多少个有效 IP 就添加多少条 A 记录，也可以只选择最快的一个或多个 IP，而 CNAME 记录指向 github 为你分配的域名，稍等一会，你就可以使用自己的域名访问你的博客了

## 使用 CDN 为域名加速

如果你是在阿里云或腾讯云这些地方购买的域名，他们本身也提供 CDN 加速功能，价格也不贵，国内的加速效果很好

但如果你想使用免费的 CDN 加速，则需要多一点的设置，以我使用的[CloudFlare](https://cloudflare.com)为例

注册后登录你的 CloudFlare 账号

![](/assets/2020-08-12-github-pages-搭建博客/12-47-31.png)

填写自己的自定义站点，应该填写主域名，就是没有前缀的域名，例如：`baidu.com`

选择免费套餐，他会自动解析到你之前的 DNS 记录，确认就行，如果没有，也可以在设置完后自己添加

![](/assets/2020-08-12-github-pages-搭建博客/12-53-51.png)

最后需要修改你域名的 nameserver

![](/assets/2020-08-12-github-pages-搭建博客/12-57-09.png)

回到你注册域名的地方

![](/assets/2020-08-12-github-pages-搭建博客/12-59-16.png)

![](/assets/2020-08-12-github-pages-搭建博客/13-02-15.png)

更换完成后回到刚刚的 cloudflare，点击重新检查，稍等一会，如果成功他会发邮件给你注册是使用的邮箱，你需要去邮箱确认操作

![](/assets/2020-08-12-github-pages-搭建博客/13-03-42.png)

如果之前你没有添加 DNS 解析记录，现在你就需要在 cloudflare 里添加，以后对这个域名的所有解析管理都需要在 cloudflare 里进行管理，且 CloudFlare 还免费提供 SSL 加密，保证你的博客更加安全

![](/assets/2020-08-12-github-pages-搭建博客/13-09-48.png)

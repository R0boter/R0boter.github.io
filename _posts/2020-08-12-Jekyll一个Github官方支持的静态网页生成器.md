---
layout: post
title: Jekyll 一个 Github 官方支持的静态网页生成器
categories: [博客, jekyll]
---

## 介绍

[Jekyll](http://jekyllcn.com/)一个简单的将纯文本转换为静态博客网站的工具，将你的注意力集中在你的博客内容之上，支持自定义地址，博客分类，页面、文章以及自定义的布局设计。

以上是官网对它的介绍

Jekyll 是由 Ruby 语言编写的，可以使用 Ruby 的包管理工具 Gem 进行安装，使用 Liquid 的模板语言解析 Markdownn 或 Textile 文本，构建可发布的静态网站，Github 官方支持。

所以你可以直接将你博客源码上传到 Github 上，它会自动帮你编译构建成静态页面，而使用 Hexo 或 Hugo 则需要你在本地构建好静态页面再上传到 Github 上

本文只做一些日常使用会用到的介绍以及，jekyll 的基本介绍，想要详细介绍的请移步[Jekyll 官方文档](http://jekyllcn.com/docs)

## 安装

因为在 Windows 上安装 Ruby 比较麻烦(主要是下载很慢)，所以我推荐的是在 Linux 上进行安装

Windows 可以使用 Linux 子系统进行安装。

以 Debian 系为例

```shell
# 首先修改软件源为国内源，源推荐中科大的源。请自行百度或查看我关于 linux 的文章
# 更新源，在 root 权限下操作，如果是普通用户前面应该加上 sudo
apt-get update
# 安装 Ruby
apt-get install ruby ruby-dev
# 安装 Jekyll 可构建工具 bundler
gem install jekyll bundler
```

## 基本使用

`jekyll new myblog`：生成一个博客文件夹，文件夹名为 myblog。这个名字可以自己定义

`jekyll new .`：将当前文件夹作为根文件夹，此时 Jekyll 不会生成新的文件夹，会将当前你所在的文件夹作为你的博客文件夹的根目录。如果当前目录不为空的话你需要加上`--force`参数

`jekyll build`：生成静态网页，此命令必须在博客根目录使用，它会将当前文件夹下的内容生成到当前文件夹下的`_site`文件夹中。此命令有三个参数

> `--destination <destination>`：指定生成的目标文件夹，将生成的内容生成到指定的文件夹，而不是当前目录的`_site`文件夹
>
> `--source <source>`：指定源文件夹，默认将当前文件夹下的内容生成到`_site`文件夹，此选项可以将指定的文件夹下的内容生成到当前文件夹下的`_site`目录。这两个选项可以相互配合
>
> `--watch`：一般用于调试，将当前文件夹中的内容生成到当前目录的`_site`文件夹中，且当前文件夹中内容发生改变时，会自动生成。但不会监视配置文件的修改

`jekyll server`：启动 jekyll 服务器，默认在 4000 端口，这是你访问 `http://localhost:4000` 就可以看到自己的博客了。使用`--detach`选项可以使 Jekyll 服务在后台运行

## 目录结构

```shell
# 说明一下，注释中说用大括号包裹或双大括号包裹的，请自行将后面跟的字符串使用大括号包裹，因为我如果直接写大括号会被 Jekyll 解析，见谅
.
├── _includes           # 在这个文件夹下的内容可以使用大括号包裹的 % include filename.ext 包含到你的任意一个页面。一般用来存放一下网页头部和脚部以及个人定义的包含文件
|   ├── footer.html
|   └── header.html
├── _layouts            # 布局文件夹，即包裹在文章或其他页面外部的模板，在文章中的 YAML 头信息中的 layout 字段定义要使用的模板
|   ├── default.html    # 文件中的使用双大括号包裹的 content 就表示被包含的文章内容或文件内容
|   └── post.html
├── _drafts             # 草稿文件夹，不带日期的文章
|   ├── begin-with-the-crazy-ideas.textile
|   └── on-simplicity-in-technology.markdown
├── _posts              # 文章文件夹，命名规范为日期和文件名相结合，隔开字符使用 - 短横线
|   ├── 2007-10-29-why-every-programmer-should-play-nethack.textile
|   └── 2009-04-26-barcamp-boston-4-roundup.textile
├── _data               # 有些博客会有，用于存放格式化好的网站数据文件，使用 site.date.filename 可以获取对应文件的内容
├── _site               # 默认生成静态网站的文件夹
├── .jekyll-metadata    # jekyll 追踪文件，用于监视哪些文件做过修改，生成时哪些需要重新生成
├── index.html          # 主页文件
└── _config.yml         # 配置文件
```

> **Tips：对应的文件一定要放在对应的文件夹中**

## 配置文件的编写

Jekyll 的配置文件中有很多项，但不是每一项都需要在配置文件中写明，因此我们可以只写自己需要定义的项

Jekyll 配置文件中可以使用 `#` 作为注释，方便我们为配置项进行说明

以下为默认设置，如果你没有更改可以不写在配置文件中：

```yml
# 目录结构
source: . # 根目录
destination: ./_site # 站点生成目录
plugins: ./_plugins # 插件目录
layouts: ./_layouts # 布局目录
data_source: ./_data # 数据目录
collections: null

# 阅读处理
safe: false # 是否禁用自定义插件
include: [".htaccess"] # 构建网站时强制包含的文件或目录
exclude: [] # 构建网站时排除的文件或目录
keep_files: [".git", ".svn"] # 生成网站时保留的文件或目录
encoding: "utf-8" # 文件编码
markdown_ext: "markdown,mkdown,mkdn,mkd,md" # markdown 文件后缀

# 内容过滤
show_drafts: null # 显示草稿
limit_posts: 0 # 限制文章数量，0 表示不限制
future: true
unpublished: false # 是否显示未发表文章

# 插件
whitelist: [] # 插件白名单
gems: [] # gens 安装的插件

# 转换
markdown: kramdown # 指定 markdown 解析器
highlighter: rouge # 指定 高亮主题
lsi: false
excerpt_separator: "\n\n" # 摘录的分隔符
incremental: false

# 服务器选项
detach: false # 是否后台运行
port: 4000 # 指定服务器端口
host: 127.0.0.1 # 指定服务器地址
baseurl: "" # 不包含 host 的根目录，留空为默认的根目录

# 输出
permalink: date # 设置永久链接
paginate_path: /page:num # 使用分页功能时，显示的分页路径
timezone: null # 设置时区

quiet: false
defaults: [] # 设置文章或文件的默认的 YAML 头

# Markdown 处理器
rdiscount:
  extensions: []

redcarpet:
  extensions: []

kramdown:
  auto_ids: true
  footnote_nr: 1
  entity_output: as_char
  toc_levels: 1..6
  smart_quotes: lsquo,rsquo,ldquo,rdquo
  enable_coderay: false
  input: GFM # 设置解析器使用 github 风格

  coderay:
    coderay_wrap: div
    coderay_line_numbers: inline
    coderay_line_number_start: 1
    coderay_tab_width: 4
    coderay_bold_every: 10
    coderay_css: style
```

另外，你也可以在配置文件中定义自己的变量，用于在其他页面中引用。例如

```yaml
# 友情链接
links:
  - title: xxxxxxxx
    url: https://xxx.xxx.xxx
  - title: xxxxxxxx
    url: https://xxx.xxx.xxx
```

所有定义的变量都可以使用`site.xxx`进行引用，在配置文件中定义的变量，可以在整个博客网站中任意文件中使用

## YAML 头信息

在 Jekyll 中任何包含 YAML 头信息的文件，都会当中一个特殊文件进行处理

YAML 头信息的格式为写在两行三虚线之间的成对的字符串，用冒号隔开。在头信息中你可以定义一些自己的变量，然后再包含这个文件中的任何文件中使用自定义变量

```YAML
---
title: My First Blog
---
```

然后你就可以此文件中，或包含此文件的文件中使用 `page.title` 使用这个变量

下面是 Jekyll 中默认的一些 YAML 头信息中的变量

```YAML
---
layout: xxx # 设置此文件构建时使用的模板，模板存放在 _layouts 文件夹下
parmalink: /year/month/day/titile.html  # 设置此文件的永久链接，可以在配置文件中为所有文件设置永久链接
published: false    # 是否隐藏此文件，默认不隐藏 false
date: YYYY-MM-DD    # 设置文章日期，会覆盖文章文件名中的日期
category: xxx
categories: [xxx,xxx]   # 文章分类，一个是只有一个分类，一个是多个分类
tags: [xxx,xxx,xxx] # 文章标签
---
```

你也可以在配置文件中为某些文件设置默认的 YAML 头信息

```YAML
defaults:
    - scope:
        path: ""    # 指定应用的文件夹路径，空字符串表示当前项目中的所有文件
        type: ”posts“   # 指定应用的文件类型，有 pages(代表html文件) posts(md文件即文章文件) drafts(草稿文件)，如果你指定了类型则必须指定path，没有可不写
      values:
        layout: "xxx"   # 设置默认布局
        author: "Mr.xxx" # 也可以自定义变量
    - scope:
        path:
        type:
      values:
        layout: "xxx"
```

如果你设置了默认头信息，又在文件中指定了头信息，则文件中的头信息会覆盖默认头信息

## 关于文章

我一直使用的都是 Markdown 标记语言，因为我个人觉得这种标记语言，学习成本低，简单易用，有条理，结构清晰

Github 更是将 Markdown 作为项目说明文件的默认格式，所以虽然 Jekyll 支持大量的文本格式，但我更喜欢使用 Markdown，我相信大多数使用 Jekyll 的人也选择的 Markdown

如果您想了解或学习 Markdown 不妨看看我[这篇博文](Markdown-基础语法)

文章是由 YAML 头信息和文章主体构成，YAML 头信息可以在配置文件中提前定义默认的头信息，但一般还是在文章头部写明

文章主体则使用 Markdown 编写，遵循 Markdown 语法即可，同时也可以在文章中嵌入 HTML 标签，同样会被 Jekyll 解析

而文章的文件名，需要按照`年-月-日-文章标题.md`的方式来命名，如果标题中存在空格则使用`-`连接。Jekyll 在解析时会忽略这些`-`。

**最后，做一个提醒：**

> 1. 默认情况下，你的文章一定是放在 \_posts 文件夹下，文件名一定是按照规则来命名的
>
> 2. 如果您对 Jekyll 的其他文件做了修改，请先在本地调试正常后再上传到 github 否则，出现问题时不好及时排查
>
> 3. 如果你上传到 github 上，刷新界面后却一直没有发生更改，请留意你的邮箱，如果发生构建错误，github 会发邮件给你

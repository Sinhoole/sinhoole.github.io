---
title: 'Github+Vercel+PicGO搭建图床'
date: '2025-09-03 16:00:00'
lastmod: '2025-09-04 07:25:44'
draft: false
description: '只需要一个域名就能白嫖！'
author: Ta0X1
tags:
  - '图床'
  - '搭建'
  - '博客'
categories:
  - '技术'
---
# 创建Github仓库

首先注册一个全新的账号用作图床存储，目前仓库仅支持似乎为1Gb的内容，所以建仓五个。


# 登录Vercel

Vercel可以托管你的Github项目，根据优选IP可以为你加速。


[**Go to Vercel](https://vercel.com)




添加新的仓库，选择你创建的图床仓库，进行配置。





看到这个Deploy了没，点他！





去控制台配置一下域名，Go to dashboard.点击domains配置一个自己的域名。


# 解析域名

按照要求添加这些解析，refresh后会添加证书，等到证书添加成功以后，再添加优选IP。等待证书生成，然后添加Cname解析到vercel-cname.xingpingcn.top。就已经完成了。


# PicGo

[**Go to PicGO](https://picgo.github.io/PicGo-Doc/zh/guide/)

下载PicGO并安装，安装完成后申请一个Tokens(Classic)


[**Tokens](https://github.com/settings/tokens)




记住你的Tokens，配置PicGO要用到。


现在配置你的PicGoOkay,大功告成了！

---
title: '大份制造机'
date: 2026-01-09
lastmod: 2026-01-09
draft: false
description: '大份制造机 - Story Forge AI'
tags:
  - 项目
  - AI
  - 写作
categories:
  - 项目
---

# 大份制造机 (Story Forge AI)

## 核心理念 (Manifesto)

*   想要看 **安倍晋三** 与 **山上彻也** 在异世界重逢并组建乐队？**可以。**
*   想要看 **爱因斯坦** 与 **霍金** 在秋名山进行轮椅漂移对决？**没问题。**
*   想要模仿 **鲁迅** 的笔触描写 **赛博朋克 2077**？**安排。**

## 技术栈 (Tech Stack)

*   **Frontend**: React 19, TypeScript
*   **Build Tool**: Vite
*   **Styling**: Tailwind CSS
*   **AI SDK**: Google GenAI SDK
*   **Icons**: Lucide React

## 开始使用 (Start)

这里是已经部署的网站。

[大份制造机](https://shitmaker.taoxi.ink)

一开始的页面会有配置，你可以选择你使用的服务商，本次演示过程中推荐使用DeepSeek。
![](https://po1.taoxi.ink//20260109185408729.png)
点击获取密钥，会跳转到DeepSeek的密钥获取页面，你需要登录你的DeepSeek账号，获取到密钥后，复制到大份制造机的配置页面中。
![](https://po1.taoxi.ink//20260109185547886.png)
复制以后保存不要让给别人看，否则会被消耗余额，本Api会自行删除。
![](https://po1.taoxi.ink//20260109185622606.png)
复制以后选择对应的模型即可，本次演示过程中推荐使用DeepSeek的`deepseek-chat`模型。
![](https://po1.taoxi.ink//20260109190115630.png)
点击写入配置保存，即可开始使用。
输入你的Prompt，点击生成，即可开始制造你的大份。
![](https://po1.taoxi.ink//20260109190807606.png)

## 自行部署 (Self Deployment)

### Vercel部署 (Vercel Deployment)

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2FSinhoole%2Fstory-forge-ai)

点击之后你会进入下面这个界面，你需要点击登录一下你的github账号。
![](https://po1.taoxi.ink//20260109184123330.png)
由于这一步实在是过于简单而且不在本教程的范围之内，不再赘述。但是为了方便插入一篇文章。

[知乎文章](https://zhuanlan.zhihu.com/p/805391882)

### 本地运行 (Local Deployment)

1.  **克隆仓库**
    ```bash
    git clone https://github.com/Sinhoole/story-forge-ai.git
    cd story-forge-ai
    ```

2.  **安装依赖**
    ```bash
    npm install
    ```

3.  **启动开发服务器**
    ```bash
    npm run dev
    ```

4.  **构建生产版本**
    ```bash
    npm run build
    ```

---
title: 'Hexo博客一键部署脚本.已过期'
date: 2026-01-21
lastmod: 2026-01-21
draft: false
description: '详细介绍Hexo博客一键部署脚本的使用方法，帮助小白用户轻松搭建自己的GitHub Pages博客'
keywords:
  - Hexo
  - '博客搭建'
  - '一键部署'
  - 'GitHub Pages'
  - '脚本'
  - '小白教程'
tags:
  - Hexo
  - '博客'
  - '一键部署'
  - '脚本'
  - 'GitHub Pages'
---
# Hexo博客一键部署脚本
## 小白也能轻松搭建的GitHub Pages博客

### 什么是Hexo一键部署脚本？

Hexo一键部署脚本是一个自动化工具，能够帮助你在几分钟内完成从环境配置到博客上线的全过程。这个脚本特别适合刚接触博客搭建的小白用户，无需手动输入复杂命令，只需按照提示填写几个信息，就能轻松拥有自己的GitHub Pages博客。

### 脚本功能与优势

- 🚀 **全自动部署**：从环境检查到博客上线，全程自动化
- 📦 **自动安装依赖**：自动检查并安装Git和Node.js
- 🔧 **智能配置**：自动配置Git身份、Hexo设置和SSH密钥
- 🌐 **网络优化**：使用国内镜像加速，解决网络连接问题
- 💡 **错误处理**：提供清晰的错误提示和解决方案
- 📱 **小白友好**：只需输入GitHub用户名和邮箱，其余全自动化

### 脚本工作原理

1. **环境检查**：检查并安装Git和Node.js
2. **Git配置**：设置Git用户名、邮箱和SSL配置
3. **Hexo初始化**：创建Hexo博客项目
4. **依赖安装**：安装必要的npm包
5. **配置修改**：自动修改Hexo配置文件
6. **SSH处理**：生成SSH密钥并复制到剪贴板
7. **部署发布**：生成静态文件并部署到GitHub Pages

### 详细使用步骤

#### 步骤1：准备工作

1. 确保你的电脑是Windows系统（脚本仅支持Windows）
2. 拥有一个GitHub账号（没有的话先去注册）
3. 稳定的网络连接（建议使用VPN，因为需要访问GitHub）

#### 步骤2：创建脚本文件

1. 在桌面上创建一个新的文本文件
2. 将下面的完整源代码复制粘贴到文本文件中
3. 将文件扩展名从`.txt`改为`.bat`（例如：`hexo-deploy.bat`）

#### 步骤3：运行脚本

1. 右键点击创建好的`.bat`文件
2. 选择"以管理员身份运行"（重要！否则可能无法安装软件）
3. 按照屏幕提示输入信息：
   - GitHub用户名：你的GitHub账号名称
   - GitHub邮箱：你的GitHub注册邮箱
   - 仓库名：直接回车使用默认的`用户名.github.io`

#### 步骤4：等待部署完成

脚本会自动执行以下操作：
1. 安装Git和Node.js（如果没有的话）
2. 初始化Hexo博客
3. 配置GitHub连接
4. 生成并复制SSH密钥

#### 步骤5：添加SSH密钥到GitHub

当脚本提示你需要添加SSH密钥时：
1. 浏览器会自动打开GitHub的SSH密钥设置页面
2. 点击"New SSH key"按钮
3. 在"Title"字段输入一个名称（例如：`My PC`）
4. 在"Key"字段粘贴已复制的SSH密钥（脚本已经自动复制到剪贴板）
5. 点击"Add SSH key"保存
6. 回到脚本窗口，按任意键继续

#### 步骤6：完成部署

1. 脚本会自动部署博客到GitHub Pages
2. 部署完成后，浏览器会打开GitHub Pages设置页面
3. 确保"Branch"选择为`main`，然后点击"Save"
4. 等待约1分钟后，博客即可访问

### 完整源代码

```bat
@echo off

:: 使用 65001 强制 UTF-8 编码，防止乱码导致命令碎裂
chcp 65001 >nul
title Hexo 博客全自动助手 - 稳定修复版
color 0b


echo ======================================================
echo           🚀 Hexo + GitHub 博客一键搭建助手.Ta0X1
echo ======================================================
echo.


:: 1. 采集信息
set /p githubUser= [?] 1. 请输入 GitHub 用户名: 
set /p githubEmail= [?] 2. 请输入 GitHub 邮箱: 
set /p repoName= [?] 3. 请输入仓库名 (直接回车为 %githubUser%.github.io): 
if "%repoName%"=="" set repoName=%githubUser%.github.io


echo.
echo ------------------------------------------------------
echo [1/7] 正在检查环境 (Git 和 Node.js)...
echo [进度: ■□□□□□□ 15%%]

:: 环境检查与实时刷新 Path
where node >nul 2>nul || (echo    - 安装 Node.js... && winget install OpenJS.NodeJS --source winget --quiet)
where git >nul 2>nul || (echo    - 安装 Git... && winget install Git.Git --source winget --quiet)
set "PATH=%ProgramFiles%\nodejs\;%AppData%\npm;%ProgramFiles%\Git\cmd;%PATH%"


echo.
echo [2/7] 正在配置 Git 身份与安全信任...
call git config --global user.name "%githubUser%"
call git config --global user.email "%githubEmail%"
:: 修复网络问题：尝试关闭 Git 的 SSL 验证（防止 Connection Reset）
call git config --global http.sslVerify false
if not exist "%USERPROFILE%\.ssh" mkdir "%USERPROFILE%\.ssh"
ssh-keyscan github.com >> "%USERPROFILE%\.ssh\known_hosts" 2>nul


echo.
echo [3/7] 正在初始化 Hexo (网络波动时请稍候)...
echo [进度: ■■■□□□□ 45%%]
:: 解决 Connection reset 问题：如果 init 失败，提示用户检查网络
if not exist myblog (
    call npx hexo-cli init myblog || (echo [!] 网络连接失败，请检查梯子或重试 && pause && exit)
)
cd myblog


echo.
echo [4/7] 正在安装必要依赖...
:: 使用加速镜像安装依赖
call npm install --registry=https://registry.npmmirror.com --silent
call npm install hexo-deployer-git --save --silent


echo.
echo [5/7] 正在适配仓库路径并修改配置...
powershell -Command "$u='%githubUser%'; $r='%repoName%'; $c=Get-Content _config.yml -Raw; if($r -eq \"$u.github.io\"){ $url='https://'+$u+'.github.io'; $root='/'; } else { $url='https://'+$u+'.github.io/'+$r; $root='/'+$r+'/'; }; $c = $c -replace 'url: .*', \"url: $url\"; $c = $c -replace 'root: .*', \"root: $root\"; $c = $c -replace '(?ms)deploy:.*', \"deploy:`n  type: git`n  repo: git@github.com:$u/$r.git`n  branch: main\"; Set-Content _config.yml $c"


echo.
echo [6/7] 正在处理 SSH 密钥...
if not exist "%USERPROFILE%\.ssh\id_rsa.pub" (
    ssh-keygen -t rsa -b 4096 -C "%githubEmail%" -N "" -f "%USERPROFILE%\.ssh\id_rsa"
)
type "%USERPROFILE%\.ssh\id_rsa.pub" | clip
start https://github.com/settings/keys
echo [+] 我们已为您自动复制在剪切板，请在网页点击New ssh key后，粘贴密钥，保存后，勾选全部可勾选项，回到这里按任意键。
pause


echo.
echo [7/7] 正在执行最终发布...
echo [进度: ■■■■■■■ 100%%]
call npx hexo g -d


echo.
echo ======================================================
echo ✨ 部署完成！请在下方网页将 Branch 改为 main 并 Save。
echo ======================================================


start https://github.com/%githubUser%/%repoName%/settings/pages

set "finalUrl=https://%githubUser%.github.io/%repoName%/"
if "%repoName%"=="%githubUser%.github.io" set "finalUrl=https://%githubUser%.github.io"
echo 博客地址: %finalUrl%
echo 等待一分钟后点击任意键自动访问。
pause
start %finalUrl%
pause
```

### 注意事项

1. **以管理员身份运行**：必须右键点击脚本文件，选择"以管理员身份运行"，否则可能无法安装Git和Node.js
2. **网络连接**：确保网络连接稳定，建议使用VPN
3. **GitHub账号**：确保你有一个GitHub账号，并且已经验证了邮箱
4. **仓库名**：如果使用个人主页，仓库名必须是`用户名.github.io`
5. **耐心等待**：脚本执行过程中请耐心等待，不要中途关闭窗口
6. **错误处理**：如果遇到错误，请仔细阅读错误提示，按照提示解决问题

### 常见问题与解决方案

#### 问题1：脚本运行时提示"winget不是内部或外部命令"

**解决方案**：
- 确保你的Windows版本是Windows 10 1809或更高版本
- 打开Microsoft Store，搜索并安装"App Installer"
- 重新运行脚本

#### 问题2：网络连接失败，提示"Connection reset"

**解决方案**：
- 检查你的VPN连接是否正常
- 尝试关闭防火墙或杀毒软件
- 重新运行脚本

#### 问题3：部署失败，提示"Permission denied"

**解决方案**：
- 确保你已经正确添加了SSH密钥到GitHub
- 检查SSH密钥是否正确生成
- 重新运行脚本，确保以管理员身份运行

#### 问题4：博客访问404

**解决方案**：
- 确保仓库名是`用户名.github.io`
- 等待5-10分钟，GitHub Pages需要时间更新
- 检查GitHub Pages设置中的Branch是否为`main`

### 脚本升级与更新

这个脚本会持续更新，以适应GitHub和Hexo的变化。如果你在使用过程中遇到问题，可以查看脚本的最新版本或提交issue。

### 扩展与自定义

部署完成后，你可以：
1. 进入`myblog`文件夹，编辑博客内容
2. 安装Hexo主题，美化你的博客
3. 添加插件，扩展博客功能
4. 自定义配置，打造个性化博客

### 写在最后

Hexo一键部署脚本的目的是让更多人能够轻松拥有自己的博客，无需担心复杂的命令和配置。博客是一个记录生活、分享知识的好地方，希望这个脚本能够帮助你开启博客之旅！

如果你在使用过程中遇到任何问题，欢迎在评论区留言，我会尽力帮助你解决。

祝你博客搭建成功！🎉

---

**作者**：Ta0X1  
**发布日期**：2026-01-21  
**更新日期**：2026-01-21  
**版权声明**：本教程和脚本仅供学习使用，请勿用于商业用途

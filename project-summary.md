# Hugo 博客迁移与配置 —— 完整项目总结

> 项目路径：`C:\Users\sinho\Desktop\CodingBlog\my-blog`
> 仓库：`sinhoole/sinhoole.github.io`
> 正式域名：`https://blog.taoxi.ink`

---

## 一、项目背景

将原 Hexo + Butterfly 主题的博客迁移到 Hugo + PaperMod 主题。原 Hexo 仓库位于项目中 `hexorepo/hexoBlog/` 目录下（仅作数据源，不参与构建）。

---

## 二、迁移完成的内容

### 2.1 文章迁移

- 原 Hexo `source/_posts` 共 **44 篇**文章 → Hugo `content/blog/` **45 篇**（含额外测试文）
- 迁移方式：
  - 第一批标准文章：用 [scripts/migrate_hexo_first_batch.js](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/scripts/migrate_hexo_first_batch.js) 批量处理并清理 AI 副标题
  - AI 副标题清理脚本：[scripts/trim_ai_titles.js](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/scripts/trim_ai_titles.js)
  - 特殊文章 `steamtools.md`（含 Hexo `{% btn %}` 语法）：用 [scripts/migrate_special_steamtools.js](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/scripts/migrate_special_steamtools.js) 将按钮语法转为普通 Markdown 链接
- 特殊映射：`2025-09-04-laojunshan.md` → `laojunshan.md`
- 文章 permalink 格式：`/:year/:month/:day/:slug/`（与 Hexo 一致）

### 2.2 页面迁移

| 页面 | Hugo 路径 | 说明 |
|---|---|---|
| 关于 | [content/about/index.md](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/content/about/index.md) | 从 Hexo `source/about/index.md` 迁移 |
| 游记→文章 | [content/blog/bingxu-19.md](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/content/blog/bingxu-19.md) | 原 `tour` 页面改为文章发布 |
| 音乐 | [content/music/index.md](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/content/music/index.md) | 含网易云音乐 iframe |
| 摄影 | [content/photo/index.md](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/content/photo/index.md) | 图库入口页 |
| 未镜 | [content/weijing/index.md](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/content/weijing/index.md) | 自媒体页面 |
| 自画像 | [content/self/index.md](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/content/self/index.md) | 自拍记录页 |
| 专栏 | [content/post/index.md](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/content/post/index.md) | 游戏/搞钱专栏索引 |
| 大份制造机 | [content/projects/rdtl.md](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/content/projects/rdtl.md) | AI 写作项目 |
| 财务报告 | [content/financial-report/index.md](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/content/financial-report/index.md) | 投资记录 |
| 友链 | [content/link/index.md](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/content/link/index.md) | 自定义 `layouts/links/single.html` + [data/links.yml](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/data/links.yml) |
| 搜索 | [content/search/index.md](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/content/search/index.md) | PaperMod 原生搜索 |
| 标签 | [content/tags/_index.md](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/content/tags/_index.md) | 标题为「标签」 |

### 2.3 不迁移的内容

- `shuoshuo` 页面：纯 JS 功能页，不迁移

---

## 三、站点配置

配置文件：[hugo.toml](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/hugo.toml)

### 3.1 站点基本信息

- `baseURL = 'https://blog.taoxi.ink/'`
- `locale = 'zh-CN'`，`defaultContentLanguage = 'zh'`
- `hasCJKLanguage = true`（中文排版优化）
- `title = 'Ta0X1 | 一年写'`
- `timezone = 'Asia/Shanghai'`
- `copyright = '© 2025-2026 Ta0X1 | 一年写'`

### 3.2 首页模式

- **个人信息名片页**（`profileMode`）
  - 标题：`Ta0X1`
  - 副标题：`难走才是上坡路`
- `disableSpecial1stPost = true`（首篇文章不特殊显示）

### 3.3 主题外观

- `defaultTheme = 'light'`（浅色模式）
- `disableThemeToggle = true`（禁用主题切换按钮）

### 3.4 文章元信息

- `DateFormat = '2006-01-02'`
- `ShowReadingTime = true`
- `ShowWordCount = true`
- `ShowCodeCopyButtons = true`
- `ShowPostNavLinks = true`（上/下篇文章导航）
- `ShowBreadCrumbs = true`（面包屑导航）
- `comments = true`（全局启用评论）
- `ShowFullTextinRSS = true`（RSS 输出全文）
- `disableAnchoredHeadings = true`（禁用锚点标题）

### 3.5 搜索

- `ShowSearch = true`
- 首页输出含 JSON：`[outputs] home = ['HTML', 'RSS', 'JSON']`
- 搜索页路径：`/search/`

### 3.6 编辑链接

```toml
[params.editPost]
URL = 'https://github.com/Sinhoole/sinhoole.github.io/blob/main/content'
Text = '编辑此页'
appendFilePath = true
```

---

## 四、导航菜单

当前菜单（从左到右）：

| 名称 | 链接 | 优先级 |
|---|---|---|
| 文章 | `/blog/` | 10 |
| 标签 | `/tags/` | 20 |
| 摄影 | `/photo/` | 30 |
| 友链 | `/link/` | 40 |
| 关于 | `/about/` | 50 |
| 搜索 | `/search/` | 60 |

---

## 五、社交图标

- GitHub：`https://github.com/Sinhoole`
- 邮箱：`mailto:zhang60809@qq.com`
- Bilibili：`https://space.bilibili.com/547777207`

---

## 六、评论系统 — Giscus

- 仓库：`sinhoole/cuisds`
- 分类：`Announcements`
- 主题：`noborder_light`
- 模板：[layouts/_partials/comments.html](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/layouts/_partials/comments.html)

注意事项：
- Giscus 偶尔会报 `Unable to fetch token from Valkey` —— 这是服务端临时故障，等几分钟自动恢复
- 如果 Giscus 长期不可用，备选方案是 utterances（基于 GitHub Issues）

---

## 七、自定义布局

### 7.1 文章列表页

[layouts/blog/list.html](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/layouts/blog/list.html)
- 简约清单风格，按年份→月份两级归档
- 显示：标题、日期、阅读时长、字数、作者
- 无卡片 / 无封面图 / 无摘要

### 7.2 菜单（相对链接修复）

[layouts/_partials/header.html](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/layouts/_partials/header.html)
- 覆盖 PaperMod 默认 header，将菜单链接从 `absLangURL` 改为 `relLangURL`
- 解决本地预览时菜单跳转到 `blog.taoxi.ink` 的问题

### 7.3 友链页

[layouts/links/single.html](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/layouts/links/single.html)
- 从 [data/links.yml](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/data/links.yml) 渲染友链

### 7.4 评论模板

[layouts/_partials/comments.html](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/layouts/_partials/comments.html)
- Giscus 配置通过 `hugo.toml` 的 `[params.Comment.giscus]` 管理

---

## 八、字体

- 自用字体：**京華老宋体**（静态文件位于 [static/fonts/京華老宋体.ttf](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/static/fonts/京華老宋体.ttf)）
- `@font-face` 声明在 [assets/css/extended/custom.css](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/assets/css/extended/custom.css) 中
- 字体名 `Jinghua Lao Song`，全局 `!important` 确保覆盖 PaperMod 默认样式
- 代码块同样使用该字体

---

## 九、已修复的技术问题

### 9.1 PaperMod 弃用警告

已修复 3 处模板：
- [opengraph.html](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/themes/PaperMod/layouts/_partials/templates/opengraph.html)：`LanguageCode` → `Locale`
- [baseof.html](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/themes/PaperMod/layouts/baseof.html)：`LanguageDirection` → `Direction`
- [rss.xml](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/themes/PaperMod/layouts/rss.xml)：`LanguageCode` → `Locale`

### 9.2 字体 CDN 加载失败

- 最初用 `cn-font.claude-code-best.win` 307 重定向导致无法加载
- 最终方案：本地 TTF 文件通过 `@font-face` + `!important` 加载

### 9.3 本地预览跳转正式域名

- 根因：PaperMod 的 `header.html` 使用 `absLangURL` 生成菜单链接
- 修复：覆盖 `layouts/_partials/header.html`，全部改为 `relLangURL`

---

## 十、部署脚本

### 10.1 创建新文章

[new-post.ps1](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/new-post.ps1)

```powershell
.\new-post.ps1
```

流程：
1. 输入标题（或传参 `.\new-post.ps1 -Title "我的文章"`）
2. 自动生成 `content/blog/2026-xx-xx-标题.md`
3. 自动用 Typora 打开
4. 写完将 `draft: true` 改为 `draft: false`

### 10.2 发布

[deploy.ps1](file:///c:/Users/sinho/Desktop/CodingBlog/my-blog/deploy.ps1)

```powershell
.\deploy.ps1
```

流程：`hugo` 构建 → `git add / commit / push`

---

## 十一、SEO

- `enableRobotsTXT = true`
- `keywords = ['Ta0X1', '一年写', '博客', '个人博客']`
- PaperMod 自带 Open Graph / Twitter Cards / Schema JSON 输出

---

## 十二、本地的 Hugo 服务器启动

```powershell
cd C:\Users\sinho\Desktop\CodingBlog\my-blog
hugo server --bind 127.0.0.1 --port 1313 --baseURL http://localhost:1313/ --disableFastRender
```

访问地址：`http://localhost:1313/`

---

## 十三、技术栈

| 工具 | 版本 / 说明 |
|---|---|
| Hugo | v0.162.1（extended） |
| 主题 | PaperMod（git submodule） |
| 字体 | 京華老宋体（本地 TTF） |
| 评论 | Giscus（基于 GitHub Discussions） |
| 搜索 | PaperMod 内置 Fuse.js |

---

## 十四、Git 仓库

- 远程：`origin https://github.com/sinhoole/sinhoole.github.io.git`
- 分支：`master`
- `.gitignore` 排除：`public/`、`hexorepo/`、`.hugo_build.lock`

注意：当前环境可能无法直接连接 GitHub（`Failed to connect to github.com`），如需推送需在你的本机执行 `git push -u origin master`。

# GitHub Pages 部署问题排查

> 🔧 本文档记录了 DesignHub 网站部署到 GitHub Pages 时遇到的问题及解决方案。

---

## 📑 目录

1. [问题描述](#问题描述)
2. [根本原因](#根本原因)
3. [修复方法](#修复方法)
4. [排查步骤](#排查步骤)
5. [相关文件](#相关文件)

---

## ❌ 问题描述

点击文档链接后提示：

> **"无法加载文档: 文档加载失败 (404)"**

控制台显示 fetch 路径为：`/docs/经验文档/AI安装与应用/VSCode_Continue_MiniMax_Setup.md`

---

## 🔍 根本原因

网站部署在 GitHub Pages 的子路径 `/designhub/` 下，但 `DocumentDetail.vue` 中的 fetch 路径写成了 `/docs/...`，**缺少了 `/designhub/` 前缀**。

---

## ✅ 修复方法

### 1️⃣ 路径拼接问题

这是最关键的问题。

❌ **错误写法：**

```js
return `/docs/${type.value}/${category.value}/${docId.value}.md`
```

✅ **正确写法：**

```js
return `/designhub/docs/${type.value}/${category.value}/${docId.value}.md`
```

---

### 2️⃣ marked v18 异步渲染问题

marked v18 默认返回 Promise，需要使用 `marked.parse()` 而不是直接调用。

❌ **错误写法：**

```js
return marked(rawContent.value)
```

✅ **正确写法：**

```js
marked.use({ gfm: true, breaks: true })
return marked.parse(rawContent.value)
```

---

### 3️⃣ Vue Router 参数解码问题

Vue Router 已经自动解码路由参数，不需要额外调用 `decodeURIComponent()`。

❌ **错误写法：**

```js
return `/docs/${type.value}/${decodeURIComponent(category.value)}/${decodeURIComponent(docId.value)}.md`
```

✅ **正确写法：**

```js
return `/designhub/docs/${type.value}/${category.value}/${docId.value}.md`
```

---

### 4️⃣ 文档 ID 与文件名必须匹配

`DocumentList.vue` 中硬编码的文档 ID 必须与实际的 markdown 文件名**完全一致**。

例如：

| 项目 | 值 |
|------|-----|
| 文件名 | `VSCode_Continue_MiniMax_Setup.md` |
| 对应 ID | `VSCode_Continue_MiniMax_Setup` |

---

## 🔎 排查步骤

当遇到文档加载问题时，按以下步骤排查：

1. **打开开发者工具** - 按 `F12` 或 `Ctrl+Shift+I`
2. **切换到 Console 标签页**
3. **点击文档链接**，查看控制台输出的路径信息
4. **检查路径** - 是否正确包含 `/designhub/` 前缀
5. **验证文件存在** - 确认 markdown 文件是否存在于 `public/docs/` 目录下

**控制台应该显示类似：**

```
Fetching doc from: /designhub/docs/经验文档/AI安装与应用/VSCode_Continue_MiniMax_Setup.md
type: 经验文档 category: AI安装与应用 docId: VSCode_Continue_MiniMax_Setup
```

---

## 📁 相关文件

| 文件 | 说明 |
|------|------|
| `src/views/DocumentDetail.vue` | 文档详情页，负责加载和渲染 markdown |
| `src/views/DocumentList.vue` | 文档列表页，定义文档 ID 和分类 |
| `vite.config.js` | 配置了 `base: '/designhub/'` |

---

## 📝 经验总结

部署到 GitHub Pages 子路径时，需要注意：

1. **所有资源路径**都要加上 base 前缀
2. **fetch 请求**也要使用完整的绝对路径
3. **前端路由**使用 hash 模式可以避免刷新 404 问题
4. **文档文件名**与代码中的 ID 必须严格匹配

---

> 💡 **提示**：使用 `console.log()` 输出关键路径信息是排查此类问题最有效的方法。

---

## 🎨 文档渲染引擎

DesignHub 采用 **CSDN 风格 5 层渲染管线**，为经验文档提供专业排版。

### 渲染管线架构

| 层 | 组件 | 功能 |
|---|---|---|
| ① 解析 | marked.js | Markdown → HTML |
| ② 高亮 | highlight.js | 代码语法着色 |
| ③ 排版 | 自研 CSS | 表格/标题/引用/列表美化 |
| ④ 交互 | Vue 组件 | 暗色模式切换 |
| ⑤ 适配 | 响应式 | 移动端横滚 |

### 核心实现

**1. 路径加载**

```js
// public 目录下的 markdown 文件会被复制到 dist
const getDocPath = () => {
  return `/designhub/docs/${type.value}/${category.value}/${docId.value}.md`
}

// fetch 加载
const response = await fetch(docPath)
const text = await response.text()
```

**2. marked 渲染**

```js
import { marked } from 'marked'
import hljs from 'highlight.js'

// marked 配置
marked.use({ gfm: true, breaks: true })

// 渲染
const renderedContent = computed(() => {
  return marked.parse(rawContent.value)
})
```

**3. 增强样式（经验文档专用）**

```html
<div v-html="renderedContent" :class="isExpDoc ? 'exp-doc' : ''"></div>
```

**4. CSS 排版规则**

```css
/* 表格 - 边框 + 斑马纹 */
.exp-doc table {
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  overflow: hidden;
}
.exp-doc th {
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  color: #ffffff;
}
.exp-doc tr:nth-child(even) {
  background-color: #f8fafc;
}
.exp-doc tr:hover {
  background-color: #f1f5f9;
}

/* 引用块 - 左边框 */
.exp-doc blockquote {
  border-left: 4px solid #6366f1;
  background: #f8fafc;
  border-radius: 0 6px 6px 0;
}

/* 代码块 - 暗色背景 */
.exp-doc pre {
  background-color: #1e293b;
  border-radius: 8px;
}

/* 标题 - 层级 + 底部边框 */
.exp-doc h1 {
  border-bottom: 3px solid #6366f1;
}
.exp-doc h2 {
  border-bottom: 2px solid #e2e8f0;
}
```

**5. 暗色模式**

```js
const toggleDark = () => {
  isDark.value = !isDark.value
  document.documentElement.classList.toggle('dark', isDark.value)
  localStorage.setItem('darkMode', isDark.value ? '1' : '0')
}
```

```css
.dark .exp-doc {
  color: #cbd5e1;
}
.dark .exp-doc h1 {
  color: #f1f5f9;
  border-bottom-color: #818cf8;
}
```

### 文件结构

```
phase2/
├── public/
│   └── docs/
│       └── 经验文档/
│           ├── AI安装与应用/
│           │   └── *.md          ← markdown 源文件
│           ├── 硬件设计经验/
│           └── 软件编程经验/
└── src/
    └── views/
        └── DocumentDetail.vue    ← 渲染引擎
```

### 效果预览

- ✅ 表格：边框 + 渐变表头 + 斑马纹
- ✅ 标题：H1/H2/H3 分级，底部边框装饰
- ✅ 代码块：暗色背景 (#1e293b)，语法高亮
- ✅ 引用块：紫色左边框，浅灰背景
- ✅ 列表：紫色标记符号
- ✅ 暗色模式：一键切换，自动记忆

---

---

## 🔧 工具模块路由与键名不一致问题

### 问题现象

首页「实用工具」里有 BOM辅助工具、设计工具、日常工具等卡片，点击后右侧显示"暂无工具"，或者点击具体工具后页面空白。

### 根本原因

**两处配置不一致**：

1. **Home.vue 路由链接** → 跳转到 `/tool/BOM辅助工具`、`/tool/设计工具` 等
2. **ToolCategory.vue 的 toolsMap** → 用英文缩写键名 `'bom'`、`'design'`
3. **ToolDetail.vue 的 toolsData** → 用英文缩写键名 `'bom-bom-match'`、`'design-serial'`

路由参数是**中文全称**，但 toolsMap 和 toolsData 的键名是**英文缩写**，导致查询失败。

### 受影响文件

| 文件 | 问题 |
|------|------|
| `src/views/Home.vue` | 链接跳转到 `/tool/BOM辅助工具` 等 |
| `src/views/ToolCategory.vue` | `toolsMap` 键名用 `'bom'` 而不是 `'BOM辅助工具'` |
| `src/views/ToolDetail.vue` | `toolsData` 键名用 `'bom-bom-match'` 而不是 `'BOM辅助工具-bom-match'` |

### 修复方法

**ToolCategory.vue** - toolsMap 键名必须与 Home.vue 传入的路由参数一致：

```js
// ❌ 错误 - 键名不匹配
const toolsMap = {
  'bom': { name: 'BOM辅助工具', children: [...] },
  'design': { name: '设计工具', children: [...] },
  'daily': { name: '日常工具', children: [...] },
}

// ✅ 正确 - 键名与路由参数一致
const toolsMap = {
  'BOM辅助工具': { name: 'BOM辅助工具', children: [...] },
  '设计工具': { name: '设计工具', children: [...] },
  '日常工具': { name: '日常工具', children: [...] },
}
```

**ToolDetail.vue** - toolsData 键名格式为 `{toolId}-{toolDetailId}`：

```js
// ❌ 错误 - toolId 不匹配
const toolsData = {
  'bom-bom-match': { name: 'BOM匹配工具', type: 'external', url: '...' },
  'design-serial': { name: '串口助手', type: 'serial' },
  'daily-word': { name: 'Word文档', type: 'office', officeType: 'word' },
}

// ✅ 正确 - toolId 使用中文全称
const toolsData = {
  'BOM辅助工具-bom-match': { name: 'BOM匹配工具', type: 'external', url: '...' },
  '设计工具-serial': { name: '串口助手', type: 'serial' },
  '日常工具-word': { name: 'Word文档', type: 'office', officeType: 'word' },
}
```

### 如何避免此类问题

1. **统一 ID 命名规范**：工具分类 ID 在 Home.vue、ToolCategory.vue、ToolDetail.vue 三处必须完全一致
2. **工具定义只在一处维护**：在 `src/views/ToolList.vue` 的 `tools` 数组定义一次，作为数据源
3. **ToolCategory 和 ToolDetail 通过 ID 查找**：不要在 ToolCategory/ToolDetail 硬编码重复的工具数据
4. **修改工具时全局搜索**：用 `grep` 搜索工具 ID，确保所有引用都同步更新

### 正确的架构（建议改进）

```js
// src/data/tools.js - 工具数据统一在一处
export const tools = [
  {
    id: 'BOM辅助工具',
    name: 'BOM辅助工具',
    icon: '📋',
    children: [
      { id: 'bom-match', name: 'BOM匹配工具' }
    ]
  },
  {
    id: '设计工具',
    name: '设计工具',
    children: [
      { id: 'serial', name: '串口助手' }
    ]
  },
  {
    id: '日常工具',
    name: '日常工具',
    children: [
      { id: 'word', name: 'Word文档' },
      { id: 'excel', name: 'Excel表格' },
      { id: 'ppt', name: 'PPT演示' }
    ]
  },
]

export const toolsData = {
  'BOM辅助工具-bom-match': { name: 'BOM匹配工具', type: 'external', url: '...' },
  '设计工具-serial': { name: '串口助手', type: 'serial' },
  '日常工具-word': { name: 'Word文档', type: 'office', officeType: 'word' },
  // ...
}
```

然后在 Home.vue、ToolCategory.vue、ToolDetail.vue 中 import 这个数据源，而不是各自硬编码。

> 📅 文档更新日期：2026-05-11

---

## 🔀 master 与 gh-pages 分支历史分离问题

### 问题现象

执行 `git push origin master:gh-pages --force` 后，远程 gh-pages 没有更新，网站显示旧版本。或者推送显示 "Everything up-to-date" 但网站确实没变。

点击实用工具分类后，BOM辅助工具、设计工具、日常工具的子工具全部消失。

### 根本原因

**master 和 gh-pages 是两个完全独立的 git 历史**，没有共同的 commit 祖先。

正常情况应该是：
```
A -- B -- C  (master 和 gh-pages 共祖先)
```

你的情况：
```
master:     X -- Y -- Z  (一个独立历史)
gh-pages:   A -- B -- C  (另一个独立历史)
```

"Everything up-to-date" 是 git 在说"你的 master 和远程 master 一样"，但没考虑你是要把 master 的内容覆盖到 gh-pages。

### 症状判断

```powershell
# 查看本地分支状态
git branch -vv

# 结果示例：
# * gh-pages 1bac912 添加开发环境检查脚本     ← 旧代码
#   master   b55e6bd 添加一键部署脚本         ← 新代码，有工具
```

如果 master 和 gh-pages 的 commit hash 不同，且 gh-pages 没有最新的代码，说明分支历史已经分离。

### 修复方法

强制推送 master 到 gh-pages：

```powershell
git push origin master:gh-pages --force
```

### 预防措施

**使用 deploy.bat 一键部署**，它会自动处理所有步骤：
1. 构建项目 `npm run build`
2. 清空旧资源（先删再复制，不会残留）
3. 强制同步 `git push origin master:gh-pages --force`

**禁止手动执行**：
- ❌ `git add . && git commit && git push` （会提交到错误分支）
- ❌ `git push` （只推送当前分支，不同步网站）
- ❌ `cp -r phase2/dist/. .` （跳过已存在文件，导致旧资源残留）

### 一键部署脚本（deploy.bat）

```bat
@echo off
chcp 65001 >nul
cd /d G:\AI\designhub

REM 构建
cd phase2 && call npm run build && cd ..

REM 清空旧资源（关键步骤）
if exist assets rmdir /s /q assets
if exist designhub rmdir /s /q designhub

REM 复制新构建
xcopy phase2\dist\* . /e /h /r /y >nul

REM 提交并强制推送到 gh-pages
git add -A
git commit -m "deploy: %date% %time%"
git push origin master:gh-pages --force
```

### 永久避免问题的原则

1. **始终使用 deploy.bat** - 不需要记任何命令，双击即可
2. **强制推送** - `--force` 确保网站分支完全同步
3. **先删再复制** - `rmdir + xcopy` 避免旧资源残留
4. **不手动 git push** - 避免推到错误分支

---

## 🏗️ Next.js 静态站点部署到 GitHub Pages 子路径 - Jekyll 忽略 `_next` 目录

### 问题现象

Next.js 静态导出部署到 `https://greatwallcy.github.io/designhub-bom/`（子路径），所有 JS 资源（`_next/static/chunks/...`）返回 **404**。

浏览器访问 `https://greatwallcy.github.io/designhub-bom/_next/static/chunks/main-app.js` 报错，但直接打开 URL 可以看到 JS 内容正常。

### 根本原因

**GitHub Pages 默认启用 Jekyll**，Jekyll 会忽略以下文件和目录：
- 以下划线 `_` 开头的文件
- 以下划线 `_` 开头的目录（如 `_next`、`_posts` 等）

Next.js 静态导出的所有资源都在 `_next` 目录下，Jekyll 直接忽略了整个目录，导致浏览器请求这些文件时全部返回 404。

### 修复方法

在部署分支（gh-pages）的**根目录**添加 `.nojekyll` 文件：

```powershell
cd G:\AI\designhub-bom-site
echo "" | Out-File -FilePath ".nojekyll" -Encoding ASCII
git add .nojekyll
git commit -m "Add .nojekyll to prevent Jekyll from ignoring _next directory"
git push -f origin main:gh-pages
```

或者手动在 GitHub 网页上创建 `.nojekyll` 文件（文件名就是 `.nojekyll`，内容为空）。

### 为什么 `.nojekyll` 能解决问题

`.nojekyll` 是 Jekyll 的禁用标志。GitHub Pages 在构建站点时，如果发现仓库根目录有 `.nojekyll` 文件，就**不会对该仓库内容进行 Jekyll 处理**，从而保留 `_next`、`_static` 等目录。

### 排查步骤

1. 打开浏览器访问 `https://greatwallcy.github.io/designhub-bom/_next/static/chunks/main-app.js`
2. 如果返回 404 → 检查是否有 `.nojekyll` 文件
3. 如果返回 JS 内容 → 说明 `.nojekyll` 已生效，问题在其他地方

### 预防措施

Next.js 静态导出部署到 GitHub Pages 子路径时：
1. 确认 `next.config.js` 设置了正确的 `basePath`
2. 确认构建输出中有 `.nojekyll` 文件
3. 部署前在本地测试子路径访问：`next start` 或 Vercel preview

### 相关配置参考

**next.config.js**
```js
const nextConfig = {
  output: 'export',
  basePath: '/designhub-bom',
  images: { unoptimized: true },
}
```

**GitHub Pages 设置**
- Repository → Settings → Pages → Source: `gh-pages` branch, `/ (root)` folder
- 确认 Branch 名称正确（不是 `main` 而是 `gh-pages`）

### 受影响项目

| 项目 | 仓库 | 部署地址 |
|------|------|---------|
| DesignHub 主站 | `greatwallcy/designhub` | `https://greatwallcy.github.io/designhub/` |
| BOM 工具站 | `greatwallcy/designhub-bom` | `https://greatwallcy.github.io/designhub-bom/` |

> 📅 文档更新日期：2026-05-11

---

## 🔴 紧急：Steam++ 加速器导致 GitHub 连接失败

### 问题现象

- `git push` 报错 `Failed to connect to github.com port 443`
- `curl` 和浏览器访问 GitHub 超时
- 之前能推送的仓库突然无法推送
- BOM 站点能推送，主站不行

### 根本原因

**Steam++（Steam 加速器）在 Windows hosts 文件中把 GitHub 全系列域名解析到 127.0.0.1**，导致所有 GitHub 连接被劫持到本地而失败。

受影响的域名包括但不限于：
```
github.com, api.github.com, github.io, raw.githubusercontent.com,
githubusercontent.com, objects.githubusercontent.com, gist.github.com,
hub.docker.com, greasyfork.org, dropbox.com, mega.co.nz 等几十个
```

### 快速修复

用文本编辑器（管理员权限）打开 `C:\Windows\System32\drivers\etc\hosts`，找到 `# Steam++ Start` 到 `# Steam++ End` 之间的所有条目，**全部在前面加 `#` 注释掉**。

修改后保存，hosts 文件立即生效。

### 预防措施

1. **关闭 Steam++ 后再操作 Git** - 加速器的 DNS 劫持会影响所有 Git 操作
2. **或者只注释 GitHub 相关条目** - 保留 Steam 相关解析，继续加速 Steam
3. **WSL 用户注意** - Windows hosts 修改后，WSL 内部可能还在用旧的 DNS 解析（WSL 有自己的 hosts 生成机制），需要重启 WSL 或手动修改 WSL 的 `/etc/hosts`

### WSL 额外问题

即使 Windows hosts 修复了，WSL 内部可能还在用旧的 DNS 解析。

**临时解决方案**（WSL 内手动加 IP）：
创建 `/etc/wsl.conf` 禁用自动 hosts 生成：
```ini
[network]
generateHosts = false
```
然后手动编辑 `/etc/hosts` 添加 GitHub IP：
```
140.82.114.4 github.com
140.82.114.4 api.github.com
140.82.114.4 github.io
```

### GitHub IP 参考

```
140.82.114.4  github.com
140.82.113.4  api.github.com
```

> 📅 文档更新日期：2026-05-11

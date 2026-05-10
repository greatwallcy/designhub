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

> 📅 文档更新日期：2026-05-10

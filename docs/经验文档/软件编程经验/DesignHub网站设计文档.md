# DesignHub 网站设计文档

> 本文档详细记录 DesignHub 网站的架构、设计思路、文件组织，以及日常维护和内容更新的操作指南。

---

## 一、项目概述

**项目名称**：DesignHub  
**技术栈**：Vue 3 + Vite + TailwindCSS v4 + Vue Router (Hash 模式)  
**部署地址**：https://greatwallcy.github.io/designhub/  
**GitHub 仓库**：https://github.com/greatwallcy/designhub

---

## 二、技术架构

### 2.1 路由架构（Hash 模式）

网站使用 **Hash 模式**路由，URL 格式为 `https://greatwallcy.github.io/designhub/#/路径`。

```javascript
// src/router/index.js
const routes = [
  { path: '/', name: 'Home', component: Home },                              // 首页
  { path: '/platform', name: 'PlatformHome', component: PlatformHome },      // 平台开发首页
  { path: '/platform/:platform', name: 'Platform', component: Platform },     // 平台分类（stm32/esp32/c51/web）
  { path: '/project/:id', name: 'ProjectDetail', component: ProjectDetail },  // 项目详情
  { path: '/documents/:type', name: 'DocumentList', component: DocumentList },    // 文档分类列表
  { path: '/documents/:type/:category', name: 'DocumentCategory', component: DocumentList }, // 文档子分类
  { path: '/documents/:type/:category/:docId', name: 'DocumentDetail', component: DocumentDetail }, // 文档详情
  { path: '/tool', name: 'ToolList', component: ToolList },                  // 工具分类列表
  { path: '/tool/:toolId', name: 'ToolCategory', component: ToolCategory },  // 工具子分类
  { path: '/tool/:toolId/:toolDetailId', name: 'ToolDetail', component: ToolDetail }, // 工具详情
  { path: '/tool/design/serial', name: 'SerialPort', component: SerialPort }  // 串口助手（独立路由）
]
```

### 2.2 文件目录结构

```
G:\AI\designhub\phase2\
├── src/                          # 源代码（开发时使用）
│   ├── main.js                    # Vue 应用入口
│   ├── App.vue                    # 根组件（侧边栏 + 主内容区布局）
│   ├── style.css                  # 全局样式（Tailwind + 自定义）
│   ├── router/
│   │   └── index.js               # 路由配置
│   └── views/                     # 页面组件
│       ├── Home.vue               # 首页（平台/文档/工具三大分类入口）
│       ├── DocumentList.vue       # 文档列表（分类 + 子分类）
│       ├── DocumentDetail.vue     # 文档详情（Markdown 渲染）
│       ├── ToolList.vue           # 工具分类列表
│       ├── ToolCategory.vue       # 工具子分类
│       ├── ToolDetail.vue         # 工具详情（iframe/串口/办公工具）
│       ├── Platform.vue           # 平台详情页
│       ├── PlatformHome.vue       # 平台首页
│       ├── ProjectDetail.vue      # 项目详情（含 Giscus 评论）
│       └── Tools/
│           └── SerialPort.vue     # 串口助手（独立页面）
├── public/                        # 公共静态资源（构建时原样复制到 dist）
│   └── docs/                      # Markdown 文档（按 URL 结构组织）
│       └── 经验文档/
│           └── AI安装与应用/
│               └── VSCode_Continue_MiniMax_Setup.md
├── dist/                          # 构建产物目录（推送到 GitHub Pages）
│   ├── index.html
│   ├── assets/
│   └── docs/                      # 编译后的文档（URL 与 public/docs 一致）
└── vite.config.js                 # Vite 配置
```

### 2.3 关键配置文件

**vite.config.js**
```javascript
export default defineConfig({
  plugins: [vue()],
  base: './'         // ⚠️ 注意：构建时相对于当前目录，GitHub Pages 部署后生效
})
```

**package.json**
```json
{
  "scripts": {
    "dev": "vite",          // 本地开发（热更新）
    "build": "vite build",  // 生产构建（输出到 dist/）
    "preview": "vite preview" // 预览构建结果
  }
}
```

---

## 三、核心模块设计

### 3.1 首页（Home.vue）

首页三大模块，链接分别指向：
- **平台开发** → `/documents/平台开发/${platformId}` （如 `/documents/平台开发/STM32开发`）
- **经验文档** → `/documents/经验文档/${categoryId}` （如 `/documents/经验文档/AI安装与应用`）
- **实用工具** → `/tool/${toolId}` （如 `/tool/BOM辅助工具`）

**注意**：Home.vue 中的 ID 必须与 ToolCategory.vue、ToolDetail.vue 中的 ID 完全一致。

### 3.2 文档系统

#### URL 与文件路径对照

| URL 路径 | Markdown 文件路径 |
|---------|----------------|
| `/documents/经验文档` | 列出所有子分类（AI安装与应用、硬件设计经验等） |
| `/documents/经验文档/AI安装与应用` | 列出该子分类下所有文档 |
| `/documents/经验文档/AI安装与应用/VSCode_Continue_MiniMax_Setup` | `public/docs/经验文档/AI安装与应用/VSCode_Continue_MiniMax_Setup.md` |

#### 文档分类数据

文档分类在 **两处** 硬编码（需要同步维护）：
1. `DocumentList.vue` 的 `experienceCategories`、`platformCategories` 数组
2. `Home.vue` 的 `experienceCategories`、`platformCategories`、`toolCategories` 数组

添加新文档需要同时更新这两个文件。

#### 文档渲染

`DocumentDetail.vue` 使用 `marked` 库将 Markdown 转为 HTML：
- 经验文档（`/documents/经验文档/...`）使用**增强样式**（标题序号、代码高亮、暗色模式）
- 其他文档使用**基础样式**

### 3.3 工具系统

工具定义在 **三个文件** 中，键名必须完全一致：

| 文件 | 位置 | 示例键名 |
|-----|------|---------|
| `Home.vue` `toolCategories` | ID | `'BOM辅助工具'`、`'设计工具'` |
| `ToolList.vue` `tools` | ID | `'bom'`、`'design'` |
| `ToolCategory.vue` `toolsMap` | 键名 | `'BOM辅助工具'`、`'设计工具'` |
| `ToolDetail.vue` `toolsData` | 完整键 | `'BOM辅助工具-bom-match'`、`'设计工具-serial'` |

**典型错误**：键名不匹配导致"暂无工具"或空白页面。

#### 工具类型

| type 值 | 渲染方式 |
|---------|---------|
| `external` | iframe 嵌入外部 URL（如 BOM 匹配工具） |
| `serial` | 渲染 `SerialPort.vue` 组件（Web Serial API 串口助手） |
| `office` | 内置 Word/Excel/PPT 编辑器（基于 contenteditable） |

### 3.4 串口助手（SerialPort.vue）

基于 **Web Serial API**，只能在 Chrome/Edge 浏览器中使用。

**关键限制**：
- `navigator.serial.getPorts()` 只返回**曾经授权过**的端口（用户通过"选择新端口"点过的）
- `navigator.serial.requestPort()` 弹出系统端口选择器，但可能看不到某些 CH340 端口（USB 枚举时序问题）
- **不能**看到内置 COM 口（非 USB-Serial 转换器）

**端口信息显示格式**：`USB VID:PID`（如 `USB 1A86:7523` 表示 CH340）

### 3.5 搜索功能（App.vue）

侧边栏搜索框使用硬编码的 `allItems` 数组，包含项目、平台、文档、工具的静态数据。添加新内容时需要手动同步更新此数组。

---

## 四、部署流程（重要）

### 4.1 标准部署步骤

**每次代码改动后必须执行以下步骤：**

```bash
# 1. 进入项目根目录
cd G:\AI\designhub\phase2

# 2. 构建生产版本
npm run build

# 3. 进入 dist 目录
cd dist

# 4. 检查 git 状态
git status
# 如果看到 "Untracked files"（新生成的 JS/CSS 文件），必须继续执行 add + commit + push

# 5. 添加所有文件并提交
git add -A
git commit -m "Deploy"

# 6. 推送到 GitHub Pages
git push -f origin master:gh-pages
```

### 4.2 判断是否需要 push

```bash
git status
# 输出 "nothing to commit, working tree clean" → 可以直接 push
# 输出 "Untracked files" → 必须 add + commit + push
```

### 4.3 GitHub Pages 设置

- 仓库 Settings → Pages → Source: **Deploy from a branch**
- Branch: **gh-pages** / **root**
- 等待 **3-5 分钟**（不是 1-2 分钟）后再访问

### 4.4 验证部署成功

访问 https://greatwallcy.github.io/designhub/ ，检查：
- 页面正常加载（不是 404）
- Console 无报错
- JS 文件路径包含 `/designhub/assets/index-xxx.js`

---

## 五、日常内容更新

### 5.1 上传新文档

**步骤1**：在 `public/docs/` 下创建 Markdown 文件，路径结构必须与 URL 对应：
```
public/docs/经验文档/AI安装与应用/新文档名.md
```

**步骤2**：在 `DocumentList.vue` 的 `allDocuments` 数组中添加条目：
```javascript
{
  id: '新文档名（不含.md）',
  category: 'AI安装与应用',    // 子分类文件夹名
  title: '显示标题',
  description: '描述',
  icon: '📝',
  bgColor: 'bg-blue-100'
}
```

**步骤3**：如果文档路径特殊（如文件名与文件夹名不一致），在 `DocumentDetail.vue` 的 `pathMap` 中添加映射。

**步骤4**：构建并部署。

### 5.2 上传视频

视频建议上传到 **Bilibili**，在文档中使用 Bilibili 嵌入式播放器：
```html
<iframe src="//player.bilibili.com/player.html?bvid=BV号&page=1"
        scrolling="no" border="0" frameborder="no" framespacing="0"
        allowfullscreen="true"> </iframe>
```

### 5.3 添加新工具

**步骤1**：在 `ToolDetail.vue` 的 `toolsData` 中添加工具定义：
```javascript
'分类ID-工具ID': {
  name: '工具名称',
  description: '描述',
  type: 'external',  // 或 'serial' / 'office'
  url: 'https://...'  // external 类型需要提供 URL
}
```

**步骤2**：在 `ToolCategory.vue` 的 `toolsMap` 中添加分类（如果新分类不存在）：
```javascript
'分类ID': {
  name: '分类名称',
  description: '描述',
  children: [{ id: '工具ID', name: '工具名称' }]
}
```

**步骤3**：在 `Home.vue` 的 `toolCategories` 和 `ToolList.vue` 的 `tools` 中同步添加。

**注意**：键名在所有文件中必须完全一致。

---

## 六、已知问题和限制

### 6.1 串口助手 COM 端口问题

**问题**：某些 CH340 USB-Serial 端口在 `requestPort()` 选择器中不出现。  
**原因**：Web Serial API 的 USB 枚举与 Windows COM 端口列表存在时序差异。  
**临时解决方案**：重新插拔 USB、换 USB 口、换浏览器。  
**长期方案**：暂无（Web Serial API 固有限制）。

### 6.2 搜索数据不同步

`App.vue` 的 `allItems` 数组是硬编码的静态数据，添加新文档/项目/工具后不会自动出现在搜索结果中，需要手动添加到 `allItems` 数组。

### 6.3 文档分类数据重复

`DocumentList.vue` 和 `Home.vue` 中都有 `experienceCategories`、`platformCategories` 等数组定义，添加新分类时需要**同时修改两个文件**。

### 6.4 BOM 匹配工具是独立部署

BOM 匹配工具托管在 `https://greatwallcy.github.io/designhub-bom/`，通过 iframe 嵌入。更新 BOM 工具需要在 `greatwallcy/designhub-bom` 仓库中进行。

---

## 七、代码规范与注意事项

### 7.1 键名一致性

工具系统的键名在 Home.vue、ToolList.vue、ToolCategory.vue、ToolDetail.vue 四处必须完全一致。建议在添加新工具前先确认所有相关文件中该分类/工具的 ID 命名。

### 7.2 dist 目录的 git 特殊性

`phase2/dist` 是一个**独立的 git 仓库**，与源代码仓库 `phase2/` 是分开的。源代码的 git 历史不会影响 dist 的推送。dist 的 HEAD 指向 master 分支，push 到远程的 gh-pages 分支。

### 7.3 不要用 git checkout 恢复文件

dist 仓库的 git 历史只有一个 "Initial commit"，`git checkout HEAD -- file` 会恢复到旧版本，丢失所有修改。恢复文件只能手动重写正确代码。

### 7.4 Giscus 评论系统

`ProjectDetail.vue` 使用 Giscus 做 GitHub Issues 评论，通过 `onMounted` 动态创建 `<script>` 标签加载。不能直接在 Vue template 中写 `<script>` 标签。

---

## 八、快速参考

| 操作 | 命令/步骤 |
|-----|---------|
| 本地开发 | `cd G:\AI\designhub\phase2 && npm run dev` |
| 生产构建 | `npm run build` |
| 预览构建结果 | `npm run preview` |
| 部署到 GitHub Pages | `cd dist && git add -A && git commit -m "Deploy" && git push -f origin master:gh-pages` |
| 验证部署 | 访问 https://greatwallcy.github.io/designhub/ |
| 添加新文档 | 在 `public/docs/` 创建 .md 文件 + 在 `DocumentList.vue` 添加条目 + 构建 + 部署 |
| 添加新工具 | 在 `ToolDetail.vue`、`ToolCategory.vue`、`Home.vue`、`ToolList.vue` 同步添加 + 构建 + 部署 |

---

## 九、项目维护记录

| 日期 | 修改内容 |
|-----|---------|
| 2026-05-11 | 修复串口助手标签格式不统一；修复 ProjectDetail.vue Giscus script 标签错误；更新 skill 文档 |

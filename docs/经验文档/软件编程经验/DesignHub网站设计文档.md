# DesignHub 网站设计文档

> 本文档详细记录 DesignHub 网站的架构、设计思路、文件组织，以及日常维护和内容更新的操作指南。

---

## 一、项目概述

**项目名称**：DesignHub
**主站技术栈**：Vue 3 + Vite + TailwindCSS v4 + Vue Router (Hash 模式)
**主站部署地址**：https://greatwallcy.github.io/designhub/
**主站 GitHub 仓库**：https://github.com/greatwallcy/designhub

**BOM工具技术栈**：Next.js (App Router) + TailwindCSS + xlsx (静态导出)
**BOM工具部署地址**：https://greatwallcy.github.io/designhub-bom/
**BOM工具 GitHub 仓库**：https://github.com/greatwallcy/designhub-bom

---

## 二、核心设计原则：模块独立性

### 2.1 独立性分级

为防止单个工具的更新、崩溃或错误扩散到其他功能，网站采用严格的模块隔离设计：

| 级别 | 模块示例 | 隔离方式 | 影响范围 |
|-----|---------|---------|---------|
| 一级 | 平台开发、经验文档、实用工具 | 路由隔离 + 页面独立 | 互不影响 |
| 二级 | STM32开发、ESP32开发、网页开发 | 路由参数隔离 | 互不影响 |
| 三级 | BOM匹配工具、BOM升级工具 | **iframe沙盒隔离** | 最多只影响本iframe |
| 更多级 | 同上 | 独立页面/路由 | 互不影响 |

### 2.2 iframe 隔离策略

所有三级功能模块（BOM匹配、BOM升级等）通过 `<iframe sandbox>` 加载，具备以下保护：

- **JS隔离**：iframe内脚本无法访问父页面DOM
- **样式隔离**：iframe内样式不影响主页面
- **崩溃隔离**：一个工具崩溃只显示重试界面，不影响其他工具
- **加载隔离**：每个工具独立超时检测（5秒），超时自动重试

```jsx
<iframe
  src={src}
  title={title}
  sandbox="allow-scripts allow-same-origin allow-forms allow-popups"
  onLoad={handleLoad}
  onError={handleError}
/>
```

### 2.3 文档/工具上传的影响控制

任何文档上传、文件上传、代码上传、工具修改、工具新建操作，最多只影响本页面无法正常显示，绝不影响其他任何功能模块。

---

## 三、技术架构

### 3.1 路由架构（Hash 模式）

主站使用 **Hash 模式**路由，URL 格式为 `https://greatwallcy.github.io/designhub/#/路径`。

```javascript
// src/router/index.js
const routes = [
  { path: '/', name: 'Home', component: Home },                              // 首页
  { path: '/platform', name: 'PlatformHome', component: PlatformHome },      // 平台开发首页
  { path: '/platform/:platform', name: 'Platform', component: Platform },     // 平台分类（stm32/esp32/c51/web）
  { path: '/project/:id', name: 'ProjectDetail', component: ProjectDetail }, // 项目详情
  { path: '/documents/:type', name: 'DocumentList', component: DocumentList },    // 文档分类列表
  { path: '/documents/:type/:category', name: 'DocumentCategory', component: DocumentList }, // 文档子分类
  { path: '/documents/:type/:category/:docId', name: 'DocumentDetail', component: DocumentDetail }, // 文档详情
  { path: '/tool', name: 'ToolList', component: ToolList },                  // 工具分类列表（已废弃，重定向到首页）
  { path: '/tool/:toolId', name: 'ToolCategory', component: ToolCategory },  // 工具子分类
  { path: '/tool/:toolId/:toolDetailId', name: 'ToolDetail', component: ToolDetail }, // 工具详情
  { path: '/tool/design/serial', name: 'SerialPort', component: SerialPort }  // 串口助手（独立路由）
]
```

### 3.2 文件目录结构

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
│       ├── ToolList.vue           # 工具分类列表（已废弃，仅重定向）
│       ├── ToolCategory.vue       # 工具子分类
│       ├── ToolDetail.vue         # 工具详情（iframe/串口/办公工具）
│       ├── Platform.vue           # 平台详情页
│       ├── PlatformHome.vue       # 平台首页
│       ├── ProjectDetail.vue      # 项目详情（含 Giscus 评论）
│       └── Tools/
│           └── SerialPort.vue     # 串口助手（独立页面）
├── public/                        # 公共静态资源（构建时原样复制到 dist）
│   └── docs/                      # Markdown 文档（按 URL 结构组织）
├── dist/                          # 构建产物目录（推送到 GitHub Pages）
│   ├── index.html
│   ├── assets/
│   └── docs/                      # 编译后的文档（URL 与 public/docs 一致）
└── vite.config.js                 # Vite 配置

G:\AI\designhub-bom\               # BOM工具独立仓库
├── app/                          # Next.js App Router 页面
│   ├── layout.jsx                 # 根布局
│   ├── page.jsx                   # 首页（iframe加载两个工具）
│   ├── bom-match/
│   │   └── page.jsx              # BOM匹配工具（独立页面）
│   └── bom-upgrade/
│       └── page.jsx              # BOM升级工具（独立页面）
├── out/                          # Next.js 静态导出目录（构建产物）
└── next.config.js                # Next.js 配置（output: 'export', basePath: '/designhub-bom'）
```

### 3.3 关键配置文件

**vite.config.js（主站）**
```javascript
export default defineConfig({
  plugins: [vue()],
  base: './'         // ⚠️ 注意：构建时相对于当前目录，GitHub Pages 部署后生效
})
```

**next.config.js（BOM工具）**
```javascript
const nextConfig = {
  reactStrictMode: true,
  output: 'export',           // 静态导出到 out/
  images: { unoptimized: true },
  basePath: '/designhub-bom', // 适配 GitHub Pages 子目录
}
module.exports = nextConfig
```

**package.json（主站）**
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

## 四、主站核心模块设计

### 4.1 首页（Home.vue）

首页三大模块，链接分别指向：
- **平台开发** → `/documents/平台开发/${platformId}` （如 `/documents/平台开发/STM32开发`）
- **经验文档** → `/documents/经验文档/${categoryId}` （如 `/documents/经验文档/AI安装与应用`）
- **实用工具** → `/tool/${toolId}` （如 `/tool/BOM辅助工具`）

**注意**：Home.vue 中的 ID 必须与 ToolCategory.vue、ToolDetail.vue 中的 ID 完全一致。

### 4.2 文档系统

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

### 4.3 工具系统

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

### 4.4 串口助手（SerialPort.vue）

基于 **Web Serial API**，只能在 Chrome/Edge 浏览器中使用。

**关键限制**：
- `navigator.serial.getPorts()` 只返回**曾经授权过**的端口（用户通过"选择新端口"点过的）
- `navigator.serial.requestPort()` 弹出系统端口选择器，但可能看不到某些 CH340 端口（USB 枚举时序问题）
- **不能**看到内置 COM 口（非 USB-Serial 转换器）

**端口信息显示格式**：`USB VID:PID`（如 `USB 1A86:7523` 表示 CH340）

### 4.5 搜索功能（App.vue）

侧边栏搜索框使用硬编码的 `allItems` 数组，包含项目、平台、文档、工具的静态数据。添加新内容时需要手动同步更新此数组。

---

## 五、BOM工具模块设计

### 5.1 架构概述

BOM工具使用 Next.js App Router 开发，打包为静态 HTML 后独立部署在 `designhub-bom` 仓库。主站通过 iframe 加载。

```
主站 (designhub)
└── /tool/BOM辅助工具 → ToolDetail.vue → iframe src="https://greatwallcy.github.io/designhub-bom/"
    ├── BOM匹配工具 (iframe)
    │   └── /designhub-bom/bom-match → bom-match.html
    └── BOM升级工具 (iframe)
        └── /designhub-bom/bom-upgrade → bom-upgrade.html
```

### 5.2 页面结构

**首页 (`/`)**：纯导航页，用 iframe 加载两个工具
- iframe sandbox 隔离，崩溃不影响主站
- 5秒超时检测 + 重试按钮
- 加载动画

**BOM匹配工具 (`/bom-match`)**：独立完整页面，无Header
- 极速匹配算法（Set O(1) 精确匹配 + 短描述优先遍历）
- 支持 SAP物料号、旧物料号、中文物料描述 列名

**BOM升级工具 (`/bom-upgrade`)**：独立完整页面，无Header
- 匹配规则：Comment值 + Footprint封装 同时匹配
- 三态显示：完整匹配（绿）、部分匹配（橙）、未匹配（红）
- 导出Excel

### 5.3 匹配算法详解

**BOM匹配工具**（substring包含匹配）：
```
BOM描述 → 物料大全描述（完全包含关系）
算法：预建 Set（所有描述小写） + 按长度排序的数组
匹配：先O(1)精确查找，再遍历短描述优先数组找包含
```

**BOM升级工具**（AND匹配）：
```
原理图BOM.Comment 在 旧BOM.描述 中（值匹配）
AND
原理图BOM.Footprint 在 旧BOM.描述 中（封装匹配）
封装格式处理：C_0603 → 0603（去掉C_前缀）
```

### 5.4 Next.js 静态导出与共享Chunk

Next.js App Router 的 `output: 'export'` 模式下：
- 每个页面独立生成 HTML（如 `bom-match.html`、`bom-upgrade.html`）
- 框架代码（React/Tailwind）抽取为共享 chunk：`23-*.js`（31.5KB）、`fd9d*.js`（172KB）
- 页面级 chunk 完全独立：`app/bom-match/page-*.js`、`app/bom-upgrade/page-*.js`
- 更新一个工具，共享 chunk 不变，浏览器可复用缓存

**注意**：框架共享 chunk 在 Next.js App Router 下无法完全拆分到每个页面，这是 Next.js 的固有架构。选择 iframe 隔离作为解决方案。

---

## 六、部署流程

### 6.1 主站部署（designhub）

```powershell
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

### 6.2 BOM工具部署（designhub-bom）

```powershell
# 1. 进入 BOM 工具项目
cd G:\AI\designhub-bom

# 2. 构建生产版本
npm run build

# 3. 同步到本地 gh-pages 克隆目录
# （先删除旧_next避免残留）
Remove-Item -Recurse -Force G:\AI\designhub-bom-site\_next
Copy-Item -Recurse G:\AI\designhub-bom\out\* G:\AI\designhub-bom-site\

# 4. 进入 gh-pages 目录
cd G:\AI\designhub-bom-site

# 5. 添加所有文件并提交
git add -A
git commit -m "Deploy: 描述本次改动"

# 6. 推送到 GitHub Pages
git push -f origin gh-pages
```

### 6.3 部署检查清单

- [ ] 主站和BOM工具是**两个独立仓库**，需要分别部署
- [ ] 主站 `phase2/dist/` 是独立的 git 仓库（不是 phase2 的子目录）
- [ ] BOM工具本地同步目录 `designhub-bom-site` 也要在正确的 gh-pages 分支上
- [ ] 推送后等待 **3-5分钟** 再访问（GitHub Pages 构建需要时间）
- [ ] `.nojekyll` 文件存在（防止 Jekyll 忽略 `_next` 目录）

### 6.4 GitHub Pages 设置

**主站仓库 (greatwallcy/designhub)**：
- Settings → Pages → Source: **Deploy from a branch**
- Branch: **gh-pages** / **root**

**BOM工具仓库 (greatwallcy/designhub-bom)**：
- Settings → Pages → Source: **Deploy from a branch**
- Branch: **gh-pages** / **root**

---

## 七、日常内容更新

### 7.1 上传新文档

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

**步骤4**：构建并部署主站。

### 7.2 上传视频

视频建议上传到 **Bilibili**，在文档中使用 Bilibili 嵌入式播放器：
```html
<iframe src="//player.bilibili.com/player.html?bvid=BV号&page=1"
        scrolling="no" border="0" frameborder="no" framespacing="0"
        allowfullscreen="true"> </iframe>
```

### 7.3 添加新工具到主站

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

### 7.4 修改/新增BOM工具功能

BOM工具是独立的 Next.js 项目，修改步骤：

**步骤1**：在 `G:\AI\designhub-bom\` 中修改对应页面文件（如 `app/bom-match/page.jsx`）

**步骤2**：执行 `npm run build` 构建

**步骤3**：同步到 `G:\AI\designhub-bom-site\`（删除旧_next，复制新out）

**步骤4**：提交并推送 `designhub-bom-site` 到 `origin/gh-pages`

---

## 八、已知问题和限制

### 8.1 串口助手 COM 端口问题

**问题**：某些 CH340 USB-Serial 端口在 `requestPort()` 选择器中不出现。
**原因**：Web Serial API 的 USB 枚举与 Windows COM 端口列表存在时序差异。
**临时解决方案**：重新插拔 USB、换 USB 口、换浏览器。
**长期方案**：暂无（Web Serial API 固有限制）。

### 8.2 搜索数据不同步

`App.vue` 的 `allItems` 数组是硬编码的静态数据，添加新文档/项目/工具后不会自动出现在搜索结果中，需要手动添加到 `allItems` 数组。

### 8.3 文档分类数据重复

`DocumentList.vue` 和 `Home.vue` 中都有 `experienceCategories`、`platformCategories` 等数组定义，添加新分类时需要**同时修改两个文件**。

### 8.4 Next.js 共享 Chunk 限制

Next.js App Router 架构下，React/Tailwind 等框架代码抽取为共享 chunk，无法完全拆分到每个页面。因此更新一个工具时，`23-*.js` 和 `fd9d*.js` 不会改变，浏览器可复用缓存。但这两个文件本身更新时，所有工具页面都会被影响。**解决方案**：iframe 隔离确保崩溃不传播，共享 chunk 更新时浏览器会重新加载但不会导致错误。

### 8.5 GitHub Pages Jekyll 限制

GitHub Pages 默认启用 Jekyll，会忽略以 `_` 开头的目录和文件（如 `_next`）。**解决方案**：在部署目录添加 `.nojekyll` 空文件。

---

## 九、代码规范与注意事项

### 9.1 键名一致性

工具系统的键名在 Home.vue、ToolList.vue、ToolCategory.vue、ToolDetail.vue 四处必须完全一致。建议在添加新工具前先确认所有相关文件中该分类/工具的 ID 命名。

### 9.2 dist 目录的 git 特殊性

`phase2/dist` 是一个**独立的 git 仓库**，与源代码仓库 `phase2/` 是分开的。源代码的 git 历史不会影响 dist 的推送。dist 的 HEAD 指向 master 分支，push 到远程的 gh-pages 分支。

### 9.3 不要用 git checkout 恢复文件

dist 仓库的 git 历史只有一个 "Initial commit"，`git checkout HEAD -- file` 会恢复到旧版本，丢失所有修改。恢复文件只能手动重写正确代码。

### 9.4 Giscus 评论系统

`ProjectDetail.vue` 使用 Giscus 做 GitHub Issues 评论，通过 `onMounted` 动态创建 `<script>` 标签加载。不能直接在 Vue template 中写 `<script>` 标签。

### 9.5 页面版本和时间显示

每个页面都会在顶部导航栏右侧和底部 footer 显示当前版本号和更新时间。

**实现方式**：

1. `version.json` 存储版本信息（位于 `phase2/version.json`）：
   ```json
   {
     "version": "V1.0.1",
     "updated": "2026-05-12 00:41"
   }
   ```

2. `App.vue` 导入并使用：
   ```javascript
   import versionData from '../version.json'
   const siteVersion = ref(versionData.version)
   const siteUpdated = ref(versionData.updated)
   ```

3. **顶部导航栏**（右上角）显示：`{{ siteVersion }} {{ siteUpdated }}`

4. **底部 footer** 显示：`版本 {{ siteVersion }} ({{ siteUpdated }})` + `© {{ currentYear }}`

**更新版本流程**：
- 修改 `phase2/version.json` 中的 `version` 和 `updated` 字段
- 重新构建并部署：`npm run build` → `cd dist && git add -A && git commit -m "Version Vx.x.x" && git push -f origin master:gh-pages`

**注意**：之前路径写成了 `../../version.json`（相对于 `src/App.vue` 会指向 `designhub/` 而不是 `phase2/`），已修复为 `../version.json`。

### 9.6 BOM工具链接注意

BOM工具首页（iframe加载器）的工具链接格式：
- BOM匹配工具 → `/designhub-bom/bom-match`
- BOM升级工具 → `/designhub-bom/bom-upgrade`

**注意**：链接前没有 `/`，因为在 iframe 内使用相对路径。首页本身的 src 是绝对路径 `https://greatwallcy.github.io/designhub-bom/`。

---

## 十、快速参考

| 操作 | 命令/步骤 |
|-----|---------|
| 主站本地开发 | `cd G:\AI\designhub\phase2 && npm run dev` |
| 主站生产构建 | `npm run build` |
| 主站预览构建结果 | `npm run preview` |
| 主站部署 | `cd dist && git add -A && git commit -m "Deploy" && git push -f origin master:gh-pages` |
| BOM工具本地构建 | `cd G:\AI\designhub-bom && npm run build` |
| BOM工具部署 | `cd G:\AI\designhub-bom-site && git add -A && git commit -m "Deploy" && git push -f origin gh-pages` |
| 验证主站部署 | 访问 https://greatwallcy.github.io/designhub/ |
| 验证BOM工具部署 | 访问 https://greatwallcy.github.io/designhub-bom/ |
| 添加新文档 | 在 `public/docs/` 创建 .md 文件 + 在 `DocumentList.vue` 添加条目 + 构建 + 部署主站 |
| 添加新工具到主站 | 在 `ToolDetail.vue`、`ToolCategory.vue`、`Home.vue`、`ToolList.vue` 同步添加 + 构建 + 部署主站 |
| 修改BOM工具 | 在 `designhub-bom/app/` 修改 + `npm run build` + 同步 + 部署 designhub-bom-site |

---

## 十一、项目维护记录

| 日期 | 修改内容 |
|-----|---------|
| 2026-05-11 | 修复串口助手标签格式不统一；修复 ProjectDetail.vue Giscus script 标签错误 |
| 2026-05-11 | 完成 BOM 匹配工具和 BOM 升级工具开发，部署到 designhub-bom 仓库 |
| 2026-05-11 | 修复 BOM 升级工具数量显示问题；修复 BOM 匹配工具性能问题（关键词索引→Set O(1)精确匹配） |
| 2026-05-11 | 完成 iframe 沙盒隔离架构改造：主站首页用 iframe 加载两个 BOM 工具，各工具完全独立，崩溃互不影响 |

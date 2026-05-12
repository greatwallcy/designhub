# DesignHub 网站设计文档

## 概述

DesignHub 是一个基于 Vue 3 + Vite 的静态网站，用于展示项目平台、经验文档和本地工具导航。

**线上地址**: https://greatwallcy.github.io/designhub/

**GitHub 仓库**: https://github.com/greatwallcy/designhub

---

## 技术栈

- **前端框架**: Vue 3 (Composition API)
- **构建工具**: Vite
- **路由**: Vue Router 4
- **样式**: Tailwind CSS
- **部署**: GitHub Pages (gh-pages 分支)
- **编程语言**: Go (本地工具启动器)

---

## 项目结构

```
G:\AI\designhub\phase2\
├── src/
│   ├── views/           # 页面组件
│   │   ├── Home.vue           # 首页
│   │   ├── Platform.vue       # 平台页面
│   │   ├── ProjectDetail.vue  # 项目详情
│   │   ├── DocumentList.vue   # 文档列表
│   │   ├── DocumentDetail.vue # 文档详情
│   │   ├── ToolList.vue       # 工具分类列表
│   │   └── ToolCategory.vue   # 工具分类页面
│   ├── router/
│   │   └── index.js           # 路由配置
│   ├── data/
│   │   └── tools.js           # 工具分类数据
│   ├── assets/          # 静态资源
│   └── main.js         # 应用入口
├── public/             # 静态文件（部署时直接复制）
├── dist/              # 构建输出目录
├── scripts/
│   └── increment-version.cjs  # 版本号自动递增脚本
└── package.json
```

---

## 路由配置

```javascript
const routes = [
  { path: '/', name: 'Home', component: Home },
  { path: '/platform/:platform', name: 'Platform', component: Platform },
  { path: '/project/:id', name: 'ProjectDetail', component: ProjectDetail },
  { path: '/documents/:category', name: 'DocumentList', component: DocumentList },
  { path: '/documents/:category/:docId', name: 'DocumentDetail', component: DocumentDetail },
  { path: '/tool', name: 'ToolList', component: ToolList },
  { path: '/tool/:category', name: 'ToolCategory', component: ToolCategory }
]
```

---

## 工具系统架构

### 概述

工具系统通过 URL Protocol (`designhub://`) 实现浏览器与本地程序的通信。

**工作原理**:
1. 用户在网页点击"启动"按钮
2. 浏览器打开 `designhub://open?tool={tool-id}`
3. Windows 将 URL 路由到已注册的 DesignHub-Launcher.exe
4. Launcher 解析参数，启动对应的本地 exe

### 目录结构

```
D:\DesignHub-Tools\
├── design\           # 设计工具
│   └── {tool-id}\
│       └── {tool-id}.exe
├── bom\              # 辅助工具（BOM相关）
│   └── {tool-id}\
│       └── {tool-id}.exe
├── daily\            # 日常工具
│   └── {tool-id}\
│       └── {tool-id}.exe
└── debug\            # 调试软件
    └── {tool-id}\
        └── {tool-id}.exe
```

**规则**: 每个工具必须放在独立文件夹中，exe 文件名必须与文件夹名一致。

### 工具分类定义

`src/data/tools.js`:

```javascript
export const toolCategories = [
  { id: 'design', name: '设计工具', icon: '🎨', bgColor: 'bg-blue-100', description: 'PCB设计和建模工具' },
  { id: 'bom', name: '辅助工具', icon: '📋', bgColor: 'bg-green-100', description: 'BOM表处理工具' },
  { id: 'daily', name: '日常工具', icon: '🛠️', bgColor: 'bg-yellow-100', description: '日常使用的小工具' },
  { id: 'debug', name: '调试软件', icon: '📐', bgColor: 'bg-purple-100', description: '调试和下载工具' },
]
```

### 工具页面

**ToolList.vue**: 显示所有工具分类卡片

**ToolCategory.vue**: 显示某个分类下的工具列表，支持通过 `designhub://` 协议启动本地程序。

---

## 本地工具启动器 (DesignHub-Launcher)

### 功能

- 通过 `designhub://` URL 协议启动本地程序
- 自动扫描工具目录发现工具
- 可选：本地 HTTP 服务（用于调试）

### 编译

```powershell
# 安装 Go 后
cd D:\tools-launcher
go build -ldflags="-s -w" -o DesignHub-Launcher.exe main.go
```

### 命令行参数

| 参数 | 说明 |
|------|------|
| `designhub://open?tool=xxx` | 启动指定工具 |
| `--install` | 注册 URL Protocol 到系统 |
| `--scan` | 扫描本地工具并更新配置 |
| `--list` | 列出所有可用工具 |
| `--serve` | 启动本地 HTTP 服务（端口 8765） |

### 安装步骤

1. 编译生成 `DesignHub-Launcher.exe`
2. 以管理员权限运行 `--install` 注册协议
3. 创建工具目录结构

### 已知问题

**问题**: `--install` 注册时 command 键可能为空

**解决**: 手动执行:

```powershell
$exePath = (Get-Item "D:\tools-launcher\DesignHub-Launcher.exe").FullName
$command = "`"$exePath`" `"%1`""
reg add "HKEY_CLASSES_ROOT\designhub\shell\open\command" /ve /d $command /f
```

---

## 部署流程

### 自动部署（推荐）

在 PowerShell 中执行:

```powershell
cd G:\AI\designhub\phase2
npm run build
cd dist
git add -A
git commit -m "Update"
git push -f origin master:gh-pages
```

### 手动部署步骤

1. **修改代码**（在 `src/` 目录）
2. **构建**: `npm run build`（自动递增版本号）
3. **提交**: `git add -A && git commit -m "描述"`
4. **推送**: `git push -f origin master:gh-pages`

### 版本管理

`scripts/increment-version.cjs` 自动读取当前版本，格式为 `V1.0.1 (YYYY-MM-DD HH:MM)`

---

## WSL 与 Windows 文件同步

项目文件位于 WSL 备份目录:
```
/home/lenovo/designhub_backup_20260509/designhub/phase2/
```

Windows 实际工作目录:
```
G:\AI\designhub\phase2\
```

**从 WSL 复制到 Windows**:
```powershell
copy \\wsl$\Ubuntu\home\lenovo\designhub_backup_20260509\designhub\phase2\src\views\Home.vue G:\AI\designhub\phase2\src\views\Home.vue
```

---

## 工具 Launch 参数说明

### URL 格式
```
designhub://open?tool={tool-id}
```

### 示例
- `designhub://open?tool=serial-assistant` - 启动串口助手

### 注册表配置

```
HKEY_CLASSES_ROOT\designhub
    @ = "URL:DesignHub Protocol"
    URL Protocol = ""

HKEY_CLASSES_ROOT\designhub\shell\open\command
    @ = "D:\tools-launcher\DesignHub-Launcher.exe" "%1"
```

---

## 常用命令

### 本地开发
```bash
cd G:\AI\designhub\phase2
npm run dev
```

### 构建生产版本
```bash
npm run build
```

### 扫描本地工具
```powershell
cd D:\tools-launcher
.\DesignHub-Launcher.exe --scan
```

### 列出可用工具
```powershell
.\DesignHub-Launcher.exe --list
```

### 重新注册协议
```powershell
.\DesignHub-Launcher.exe --install
```

---

## 注意事项

1. **工具 exe 命名**: 必须与所在文件夹名称一致
2. **协议注册**: 需要管理员权限
3. **浏览器缓存**: 更新后按 `Ctrl+F5` 强制刷新
4. **GitHub Pages**: 部署后可能需要几分钟生效

---

## 更新日志

### V1.0.1 (2026-05-12)

- 新增工具系统架构
- 实现 designhub:// URL Protocol
- 添加设计工具、辅助工具、日常工具、调试软件四个分类
- 完成本地工具启动器 (Go)

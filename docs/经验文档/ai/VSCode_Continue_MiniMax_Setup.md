# VS Code Continue 插件安装与 MiniMax 模型配置指南

> 📝 更新日期：2026-05-10 | Continue 是 VS Code 的 AI 代码助手插件，支持多种模型。本指南整合自 hermes 和 designhub 两处文档。

---

## 📑 目录

1. [安装 Continue 插件](#1-安装-continue-插件)
2. [配置 MiniMax 模型](#2-配置-minimax-模型)
3. [验证配置](#3-验证配置)
4. [添加多个模型](#4-添加多个模型)
5. [常见问题](#5-常见问题)
6. [Agent 模式说明](#6-agent-模式说明)
7. [MCP 服务器配置](#7-mcp-服务器配置)
8. [参考信息](#8-参考信息)

---

## 1. 安装 Continue 插件

### 方法一：VS Code 扩展商店安装

1. 打开 VS Code
2. 按 `Ctrl+Shift+X` 打开扩展面板
3. 搜索 `Continue`
4. 找到 **Continue - open-source AI code agent**（发布者：`continue`，ID：`continue.continue`）
5. 点击 **安装**

### 方法二：命令行安装

```powershell
code --install-extension continue.continue
```

### 方法三：VS Code 命令面板安装

1. 按 `Ctrl+Shift+P` 打开命令面板
2. 输入 `Extensions: Install Extension`
3. 搜索 `continue.continue`
4. 选择安装

---

## 2. 配置 MiniMax 模型

### 配置文件位置

```
%USERPROFILE%\.continue\config.yaml
```

即：`C:\Users\<用户名>\.continue\config.yaml`

### 配置内容

编辑 `config.yaml`，添加 MiniMax 模型配置：

```yaml
name: Local Config
version: 1.0.0
schema: v1

models:
  - name: MiniMax-M2.7-highspeed
    provider: openai
    model: MiniMax-M2.7-highspeed
    apiBase: https://api.minimaxi.com/v1
    apiKey: <你的MiniMax API Key>
    capabilities:
      - tool_use
    roles:
      - chat
      - edit
      - apply

context:
  - provider: file
  - provider: code
  - provider: diff
  - provider: terminal
```

### 配置说明

| 字段 | 说明 |
|------|------|
| `name` | 在 Continue 界面中显示的模型名称 |
| `provider` | 使用 `openai`，因为 MiniMax 兼容 OpenAI API 格式 |
| `model` | MiniMax 模型名称，如 `MiniMax-M2.7-highspeed` |
| `apiBase` | MiniMax API 端点：`https://api.minimaxi.com/v1` |
| `apiKey` | 你的 MiniMax API Key（以 `sk-` 开头） |
| `capabilities` | 声明模型能力（虽然 MiniMax 不原生支持，但建议声明） |
| `roles` | 模型可用角色：`chat`（对话）、`edit`（编辑）、`apply`（应用修改） |

### 可用的 MiniMax 模型

| 模型名称 | 说明 |
|----------|------|
| `MiniMax-M2.7-highspeed` | MiniMax M2.7 高速版，适合日常编码 |
| `MiniMax-M2.7` | MiniMax M2.7 标准版 |
| `MiniMax-Text-01` | MiniMax Text-01 |

---

## 3. 验证配置

1. 按 `Ctrl+L` 打开 Continue 侧边栏
2. 在模型下拉菜单中选择 **MiniMax-M2.7-highspeed**
3. 输入测试消息（如 `hello`）
4. 如果收到回复，说明配置成功

---

## 4. 添加多个模型

可以在 `models` 列表中添加多个模型：

```yaml
models:
  - name: MiniMax-M2.7-highspeed
    provider: openai
    model: MiniMax-M2.7-highspeed
    apiBase: https://api.minimaxi.com/v1
    apiKey: <API Key>

  - name: 本地 Qwen2.5 7B
    provider: openai
    model: qwen2.5-7b-instruct-q4_k_m.gguf
    apiBase: http://127.0.0.1:18800/v1
    apiKey: no-key-needed
```

---

## 5. 常见问题

### Q: 配置后模型不显示？

**A:** 重新加载 VS Code 窗口：`Ctrl+Shift+P` → `Developer: Reload Window`

### Q: API 调用失败？

**A:** 检查以下几点：
- API Key 是否正确（以 `sk-` 开头）
- 网络是否可以访问 `api.minimaxi.com`
- `apiBase` 是否包含 `/v1` 后缀

### Q: 如何查看请求日志？

**A:** 打开 VS Code 输出面板（`Ctrl+Shift+U`），选择 `Continue` 输出通道

### Q: MiniMax 说"无法访问本地文件"？

**A:** MiniMax API **不原生支持 function calling / tool_use**。这意味着：
- Chat 模式：可以对话，但只能输出命令
- Agent 模式：会显示可用工具，但 MiniMax 无法自动调用它们

**解决方案：**
1. 点击 Continue 输出的命令右侧的 **Apply** 按钮执行
2. 或复制命令到终端手动执行
3. 如需真正的自动执行，建议使用支持 tool_use 的模型（如 Claude、GPT-4）

### Q: 点击 Apply 报错 "Could not resolve filepath"？

**A:** 这是 VS Code 打开的文件夹路径问题。解决方法：
1. VS Code → File → Close Folder
2. VS Code → File → Open Folder
3. 选择项目根目录（如 `G:\AI\designhub`）
4. 重新在 Continue 中执行操作

### Q: 如何让 MiniMax 自动执行命令而不是只输出？

**A:** MiniMax API 本身不支持 function calling，这是 API 层面的限制。配置 `capabilities: [tool_use]` 只是声明意图，MiniMax 不会真正调用工具。

如需自动执行，建议：
- 使用 **Claude 3.5/3.7**（完整支持 tool_use）
- 使用 **GPT-4o**（支持 function calling）

---

## 6. Agent 模式说明

### 模式切换

- 按 `Ctrl + .` 循环切换模式：Chat → Agent → Plan → Chat...
- 或在 Continue 输入框下方找到模式选择器手动切换

### Agent 模式下的内置工具

**只读工具（Plan 模式也可用）：**

| 工具名 | 功能 |
|--------|------|
| `read_file` | 读取文件内容 |
| `read_currently_open_file` | 读取当前打开的文件 |
| `ls` | 列出目录内容 |
| `glob_search` | 通配符搜索文件 |
| `grep_search` | 搜索文件内容 |
| `fetch_url_content` | 获取网页内容 |
| `search_web` | 搜索引擎搜索 |
| `view_diff` | 查看代码差异 |
| `view_repo_map` | 查看仓库结构 |
| `view_subdirectory` | 查看子目录 |
| `codebase_tool` | 代码库语义搜索 |

**读写工具（仅 Agent 模式）：**

| 工具名 | 功能 |
|--------|------|
| `create_new_file` | 创建新文件 |
| `edit_existing_file` | 编辑现有文件 |
| `run_terminal_command` | 在终端运行命令 |
| `create_rule_block` | 创建规则 |

### 工具自动执行设置

1. 在 Agent 模式下，当弹出工具确认时，选择 **Always Allow** 而不是只点 Continue
2. 或者在工具确认界面中将特定工具的策略设为 `Automatic`

---

## 7. MCP 服务器配置

### 什么是 MCP

MCP（Model Context Protocol）用于扩展 Continue 的能力，如浏览器搜索、文件系统访问等。

### 配置 MCP 服务器

**方法一：在主 config.yaml 中添加**

编辑 `%USERPROFILE%\.continue\config.yaml`：

```yaml
mcpServers:
  - name: Browser search
    command: npx
    args:
      - "@playwright/mcp@latest"
```

**方法二：在工作区中添加独立 MCP 配置文件**

1. 在项目根目录创建 `.continue/mcpServers/` 文件夹
2. 添加 YAML 或 JSON 配置文件
3. Continue 自动加载

例如创建 `.continue/mcpServers/filesystem.yaml`：

```yaml
name: Filesystem MCP
version: 0.0.1
schema: v1
mcpServers:
  - name: Filesystem
    command: npx
    args:
      - "-y"
      - "@modelcontextprotocol/server-filesystem"
      - "."
```

### 从 Claude/Cursor/Cline 迁移 MCP

如果你在 Claude Desktop 或其他工具中已有 MCP JSON 配置，可以直接复制到 Continue：

1. 将 JSON 配置文件放到 `.continue/mcpServers/mcp.json`
2. Continue 自动识别并加载

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "."],
      "env": {}
    }
  }
}
```

---

## 8. 参考信息

| 项目 | 链接 |
|------|------|
| Continue 官方文档 | https://docs.continue.dev |
| Continue Agent 指南 | https://docs.continue.dev/ide-extensions/agent/quick-start |
| Continue MCP 配置 | https://docs.continue.dev/customize/deep-dives/mcp |
| Continue config.yaml 参考 | https://docs.continue.dev/reference |
| MiniMax API 文档 | https://platform.minimaxi.com/document |
| Continue GitHub | https://github.com/continuedev/continue |
| 插件 ID | `continue.continue` |
| 配置文件 | `%USERPROFILE%\.continue\config.yaml` |

---

> 📅 文档更新日期：2026-05-10
> 📅 原始文档生成日期：2026-05-08

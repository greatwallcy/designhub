# VS Code Continue 插件安装与 MiniMax 模型配置指南

> 📝 Continue 是 VS Code 的 AI 代码助手插件，支持多种模型。本指南教你如何配置 MiniMax 模型。

---

## 📑 目录

1. [安装 Continue 插件](#安装-continue-插件)
2. [配置 MiniMax 模型](#配置-minimax-模型)
3. [验证配置](#验证配置)
4. [添加多个模型](#添加多个模型)
5. [常见问题](#常见问题)

---

## 📦 安装 Continue 插件

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

## ⚙️ 配置 MiniMax 模型

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
```

### 配置说明

| 字段 | 说明 |
|------|------|
| `name` | 在 Continue 界面中显示的模型名称 |
| `provider` | 使用 `openai`，因为 MiniMax 兼容 OpenAI API 格式 |
| `model` | MiniMax 模型名称，如 `MiniMax-M2.7-highspeed` |
| `apiBase` | MiniMax API 端点：`https://api.minimaxi.com/v1` |
| `apiKey` | 你的 MiniMax API Key（以 `sk-` 开头） |

### 可用的 MiniMax 模型

| 模型名称 | 说明 |
|----------|------|
| `MiniMax-M2.7-highspeed` | MiniMax M2.7 高速版，适合日常编码 |
| `MiniMax-M2.7` | MiniMax M2.7 标准版 |
| `MiniMax-Text-01` | MiniMax Text-01 |

---

## ✅ 验证配置

1. 按 `Ctrl+L` 打开 Continue 侧边栏
2. 在模型下拉菜单中选择 **MiniMax-M2.7-highspeed**
3. 输入测试消息（如 `hello`）
4. 如果收到回复，说明配置成功

---

## 🔄 添加多个模型

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

## ❓ 常见问题

### Q: 配置后模型不显示？

**A:** 重新加载 VS Code 窗口：`Ctrl+Shift+P` → `Developer: Reload Window`

### Q: API 调用失败？

**A:** 检查以下几点：
- API Key 是否正确（以 `sk-` 开头）
- 网络是否可以访问 `api.minimaxi.com`
- `apiBase` 是否包含 `/v1` 后缀

### Q: 如何查看请求日志？

**A:** 打开 VS Code 输出面板（`Ctrl+Shift+U`），选择 `Continue` 输出通道

---

## 📖 参考信息

| 项目 | 链接 |
|------|------|
| Continue 官方文档 | https://docs.continue.dev |
| MiniMax API 文档 | https://platform.minimaxi.com/document |
| Continue GitHub | https://github.com/continuedev/continue |
| 插件 ID | `continue.continue` |
| 配置文件 | `%USERPROFILE%\.continue\config.yaml` |

---

> 📅 文档生成日期：2026-05-08

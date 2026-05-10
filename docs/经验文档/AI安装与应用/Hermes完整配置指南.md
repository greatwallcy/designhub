# Hermes AI Agent 配置与重装完整指南

> 🤖 Hermes 是一个 AI Agent 软件，可以通过命令行与她对话。她能帮你完成代码编写、问题排查等各种任务。
>
> **官方网站**: https://hermes-agent.nousresearch.com/

---

## 📑 目录

1. [安装位置](#安装位置)
2. [重装配置步骤](#重装配置步骤)
3. [常用命令](#常用命令)
4. [Windows 编码问题](#windows-编码问题)
5. [API Key 配置](#api-key-配置)
6. [WSL 环境问题](#wsl-环境问题)
7. [Docker Desktop 与 WSL 冲突](#docker-desktop-与-wsl-冲突)
8. [常见问题](#常见问题)
9. [日志与配置](#日志与配置)

---

## 📍 安装位置

| 类型 | 路径 |
|------|------|
| 主程序 | `C:\Users\Lenovo\AppData\Local\hermes\hermes-agent` |
| 虚拟环境 | `C:\Users\Lenovo\AppData\Local\hermes\hermes-agent\venv` |
| 可执行文件 | `C:\Users\Lenovo\AppData\Local\hermes\hermes-agent\venv\Scripts\hermes.exe` |
| 配置文件 | `C:\Users\Lenovo\AppData\Local\hermes\config.yaml` |
| 环境变量 | `C:\Users\Lenovo\AppData\Local\hermes\.env` |
| 日志目录 | `C:\Users\Lenovo\AppData\Local\hermes\logs` |

---

## 🔧 重装配置步骤

### 第一步：安装 Hermes

打开 PowerShell 或 CMD，运行以下命令：

```cmd
npm install -g hermes-ai-agent
```

或使用国内镜像：

```cmd
npm install -g hermes-ai-agent --registry https://registry.npmmirror.com
```

### 第二步：启动 Hermes

直接运行：
```cmd
hermes
```

或者使用完整路径：
```cmd
C:\Users\Lenovo\AppData\Local\hermes\hermes-agent\venv\Scripts\hermes.exe
```

### 第三步：首次配置

首次运行时会提示配置，按提示操作即可。如果需要手动配置，运行：

```cmd
hermes setup
```

### 第四步：设置模型

运行以下命令选择模型：

```cmd
hermes model
```

**当前配置：**
- **模型**: MiniMax-M2.7-highspeed
- **提供商**: MiniMax (China)
- **API 地址**: https://api.minimaxi.com/v1/

### 第五步：设置 API Key

编辑配置文件：

```
C:\Users\Lenovo\AppData\Local\hermes\.env
```

添加或修改：

```
MINIMAX_API_KEY=你的API密钥
```

### 第六步：验证安装

运行以下命令验证：

```cmd
set PYTHONIOENCODING=utf-8 && hermes status
```

**成功输出示例：**

```
◆ Paths
  Config:       C:\Users\Lenovo\AppData\Local\hermes\config.yaml
  Secrets:      C:\Users\Lenovo\AppData\Local\hermes\.env
  Install:      C:\Users\Lenovo\AppData\Local\hermes\hermes-agent

◆ Model
  Model:        MiniMax-M2.7-highspeed
  Provider:     MiniMax (China)
  Base URL:     https://api.minimaxi.com/v1/

◆ Terminal
  Backend:      local
  Timeout:      180s
```

---

## ⌨️ 常用命令

| 命令 | 说明 |
|------|------|
| `hermes` | 启动交互式聊天 |
| `hermes status` | 查看状态（需设置编码） |
| `hermes logs` | 查看日志 |
| `hermes setup` | 交互式配置向导 |
| `hermes model` | 选择模型 |
| `hermes config` | 查看配置 |
| `hermes doctor` | 诊断检查 |
| `hermes auth` | 管理认证 |
| `hermes skills` | 管理技能 |

---

## 🪟 Windows 编码问题

由于 Windows CMD 使用 GBK 编码，直接运行会显示乱码。

**解决方法**：在命令前加编码设置

```cmd
set PYTHONIOENCODING=utf-8 && hermes status
```

或者在 PowerShell 中：

```powershell
$env:PYTHONIOENCODING="utf-8"; hermes status
```

---

## 🔑 API Key 配置

### 当前配置

- **模型**: MiniMax-M2.7-highspeed
- **提供商**: MiniMax (China)
- **API 地址**: https://api.minimaxi.com/v1/

### 更换 API Key

1. 打开文件：`C:\Users\Lenovo\AppData\Local\hermes\.env`
2. 添加或修改：`MINIMAX_API_KEY=你的密钥`
3. 保存后重新运行 `hermes`

### 可用模型列表

| 模型名称 | 说明 |
|----------|------|
| `MiniMax-M2.7-highspeed` | MiniMax M2.7 高速版 |
| `MiniMax-M2.7` | MiniMax M2.7 标准版 |
| `MiniMax-Text-01` | MiniMax Text-01 |

---

## 🐧 WSL 环境问题

### 问题描述

终端命令执行时报错：

```
/mnt/c/Users/Lenovo/AppData/Roaming/npm/hermes: 15: exec: node: not found
```

### 原因

WSL Ubuntu 内部没有 node.js，而 Hermes 是 Windows 程序。WSL PATH 包含 Windows 路径，导致冲突。

### 解决方案

**方案一：始终使用 cmd.exe /c 前缀调用 Windows 命令**

```cmd
cmd.exe /c hermes status
```

**方案二：退出 WSL，在 Windows 原生环境运行**

在 WSL 终端输入 `exit` 退回 Windows，然后运行 Hermes 命令。

**方案三：修复 WSL 环境**

1. 检查 WSL 状态：
   ```powershell
   wsl --list --verbose
   ```

2. 如果 Ubuntu 是 Stopped 状态，启动它：
   ```powershell
   wsl -d Ubuntu
   ```

3. 退出 Ubuntu：`exit`

4. 在 PowerShell 中重启 Hermes：`hermes`

---

## 🐳 Docker Desktop 与 WSL 冲突

### 问题描述

Docker Desktop 安装/卸载会修改 WSL 配置，可能导致 WSL 环境损坏。

### 症状

- `wsl --list --verbose` 显示空白或 Ubuntu missing
- 终端输出乱码
- 所有命令返回错误

### 解决方案

**方案一：安装 WSL 发行版**

```powershell
wsl --install -d Ubuntu
# 重启电脑后
wsl --set-default Ubuntu
```

**方案二：清理 docker-desktop**

```powershell
wsl --unregister docker-desktop
```

**方案三：卸载 Docker Desktop**

打开设置 → 应用 → 已安装的应用 → Docker Desktop → 卸载

---

## ❓ 常见问题

### Q1: Hermes 和 OpenClaw 是两个软件吗？

**A:** 是的。Hermes 和 OpenClaw 是两个不同的 AI Agent 软件。

- **Hermes**: Windows 原生应用，通过 npm 安装
- **OpenClaw**: 基于 WSL 的 AI Agent

### Q2: 为什么终端输出乱码？

**A:** WSL Ubuntu 没有 node.js，而 Hermes 是 Windows 程序。WSL PATH 包含 Windows 路径，导致冲突。

**解决方案**：退出 WSL，在 Windows 原生环境运行 Hermes。

### Q3: Docker Desktop 会影响 Hermes 吗？

**A:** 是的。Docker Desktop 安装/卸载会修改 WSL 配置，可能导致 WSL 环境损坏。

### Q4: 如何完全卸载 Docker Desktop？

**A:** 设置 → 应用 → 已安装的应用 → Docker Desktop → 卸载

### Q5: 命令提示 "node: not found"

**A:** 这是因为你当前在 WSL Ubuntu 环境中。输入 `exit` 退出 WSL，然后在 Windows PowerShell 中运行命令。

### Q6: 如何诊断问题？

**A:** 运行诊断命令：

```cmd
hermes doctor
```

---

## 📋 日志与配置

### 日志位置

当出现问题需要排查时，查看日志：

```
C:\Users\Lenovo\AppData\Local\hermes\logs
```

### config.yaml 结构

```yaml
model:
  name: MiniMax-M2.7-highspeed
  provider: minimax
  api_base: https://api.minimaxi.com/v1/

terminal:
  backend: local
  timeout: 180

skills:
  enabled: true
```

### .env 结构

```
MINIMAX_API_KEY=你的密钥
```

---

## 📚 参考资料

- [Hermes 官方文档](https://hermes-agent.nousresearch.com/)
- [WSL 官方文档](https://docs.microsoft.com/windows/wsl/)
- [模型列表](https://models.dev/)
- [MiniMax API 文档](https://platform.minimaxi.com/document)

---

> 📅 文档创建日期：2026-05-08 | 最后更新：2026-05-08

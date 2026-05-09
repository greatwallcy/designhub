<template>
  <!-- 固定导航栏 -->
  <div class="fixed top-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-b border-gray-200 z-50 shadow-sm">
    <div class="p-4 flex items-center">
      <router-link to="/" class="inline-flex items-center text-purple-600 hover:text-purple-700 text-sm">
        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
        </svg>
        返回首页
      </router-link>
      <span class="mx-4 text-gray-300">|</span>
      <button @click="goBack" class="inline-flex items-center text-purple-600 hover:text-purple-700 text-sm">
        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
        </svg>
        上一级
      </button>
    </div>
  </div>

  <div class="p-8 pt-20">
    <div class="bg-white rounded-xl p-8 shadow-sm" v-html="renderedContent"></div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const docId = computed(() => route.params.docId)

const goBack = () => {
  if (window.history.length > 1) {
    router.back()
  } else {
    router.push('/')
  }
}

// 文档数据
const embeddedDocuments = {
  'vscode-continue-minimax': {
    title: 'VSCode Continue 配置 MiniMax',
    content: `
      <h1 class="text-3xl font-bold mb-6">VSCode Continue 配置 MiniMax</h1>
      
      <div class="bg-gray-50 rounded-xl p-6 mb-8">
        <h2 class="text-xl font-bold mb-4">📑 目录</h2>
        <ul class="space-y-2 text-gray-700">
          <li><a href="#section1" class="text-purple-600 hover:underline">1. 安装 Continue 插件</a></li>
          <li><a href="#section2" class="text-purple-600 hover:underline">2. 配置 MiniMax 模型</a></li>
          <li><a href="#section3" class="text-purple-600 hover:underline">3. 验证配置</a></li>
          <li><a href="#section4" class="text-purple-600 hover:underline">4. 常见问题</a></li>
        </ul>
      </div>

      <div id="section1" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">1. 安装 Continue 插件</h2>
        <h3 class="text-xl font-semibold mb-3">方法一：VS Code 扩展商店安装</h3>
        <ol class="list-decimal list-inside space-y-2 text-gray-700 mb-4">
          <li>打开 VS Code</li>
          <li>按 <code class="bg-gray-100 px-2 py-1 rounded">Ctrl+Shift+X</code> 打开扩展面板</li>
          <li>搜索 <code class="bg-gray-100 px-2 py-1 rounded">Continue</code></li>
          <li>找到 <strong>Continue - open-source AI code agent</strong>（发布者：<code class="bg-gray-100 px-2 py-1 rounded">continue</code>，ID：<code class="bg-gray-100 px-2 py-1 rounded">continue.continue</code>）</li>
          <li>点击 <strong>安装</strong></li>
        </ol>
        
        <h3 class="text-xl font-semibold mb-3">方法二：命令行安装</h3>
        <div class="bg-gray-900 rounded-lg p-4 mb-4">
          <code class="text-green-400">code --install-extension continue.continue</code>
        </div>
      </div>

      <hr class="border-gray-200 my-8">

      <div id="section2" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">2. 配置 MiniMax 模型</h2>
        
        <h3 class="text-xl font-semibold mb-3">配置文件位置</h3>
        <div class="bg-gray-100 rounded-lg p-4 mb-4">
          <code>%USERPROFILE%\\.continue\\config.yaml</code>
        </div>
        <p class="text-gray-700 mb-4">即：<code>C:\\Users\\&lt;用户名&gt;\\.continue\\config.yaml</code></p>
        
        <h3 class="text-xl font-semibold mb-3">配置内容</h3>
        <p class="text-gray-700 mb-4">编辑 <code>config.yaml</code>，添加 MiniMax 模型配置：</p>
        
        <div class="bg-gray-900 rounded-lg p-4 mb-4">
          <pre class="text-gray-300 overflow-x-auto"><code>name: Local Config
version: 1.0.0
schema: v1
models:
  - name: MiniMax-M2.7-highspeed
    provider: openai
    model: MiniMax-M2.7-highspeed
    apiBase: https://api.minimaxi.com/v1
    apiKey: &lt;你的MiniMax API Key&gt;</code></pre>
        </div>
        
        <h3 class="text-xl font-semibold mb-3">配置说明</h3>
        <table class="w-full border-collapse border border-gray-300 mb-4">
          <thead>
            <tr class="bg-gray-100">
              <th class="border border-gray-300 px-4 py-2 text-left">字段</th>
              <th class="border border-gray-300 px-4 py-2 text-left">说明</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="border border-gray-300 px-4 py-2"><code>name</code></td>
              <td class="border border-gray-300 px-4 py-2">在 Continue 界面中显示的模型名称</td>
            </tr>
            <tr>
              <td class="border border-gray-300 px-4 py-2"><code>provider</code></td>
              <td class="border border-gray-300 px-4 py-2">使用 <code>openai</code>，因为 MiniMax 兼容 OpenAI API 格式</td>
            </tr>
            <tr>
              <td class="border border-gray-300 px-4 py-2"><code>model</code></td>
              <td class="border border-gray-300 px-4 py-2">MiniMax 模型名称，如 <code>MiniMax-M2.7-highspeed</code></td>
            </tr>
            <tr>
              <td class="border border-gray-300 px-4 py-2"><code>apiBase</code></td>
              <td class="border border-gray-300 px-4 py-2">MiniMax API 端点：<code>https://api.minimaxi.com/v1</code></td>
            </tr>
            <tr>
              <td class="border border-gray-300 px-4 py-2"><code>apiKey</code></td>
              <td class="border border-gray-300 px-4 py-2">你的 MiniMax API Key（以 <code>sk-</code> 开头）</td>
            </tr>
          </tbody>
        </table>
      </div>

      <hr class="border-gray-200 my-8">

      <div id="section3" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">3. 验证配置</h2>
        <ol class="list-decimal list-inside space-y-2 text-gray-700">
          <li>按 <code class="bg-gray-100 px-2 py-1 rounded">Ctrl+L</code> 打开 Continue 侧边栏</li>
          <li>在模型下拉菜单中选择 <strong>MiniMax-M2.7-highspeed</strong></li>
          <li>输入测试消息（如 <code class="bg-gray-100 px-2 py-1 rounded">hello</code>）</li>
          <li>如果收到回复，说明配置成功</li>
        </ol>
      </div>

      <hr class="border-gray-200 my-8">

      <div id="section4" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">4. 常见问题</h2>
        
        <h3 class="text-xl font-semibold mb-3">Q: 配置后模型不显示？</h3>
        <p class="text-gray-700 mb-4">A: 重新加载 VS Code 窗口：<code class="bg-gray-100 px-2 py-1 rounded">Ctrl+Shift+P</code> → <code class="bg-gray-100 px-2 py-1 rounded">Developer: Reload Window</code></p>
        
        <h3 class="text-xl font-semibold mb-3">Q: API 调用失败？</h3>
        <p class="text-gray-700 mb-4">A: 检查以下几点：</p>
        <ul class="list-disc list-inside space-y-2 text-gray-700 mb-4">
          <li>API Key 是否正确（以 <code class="bg-gray-100 px-2 py-1 rounded">sk-</code> 开头）</li>
          <li>网络是否可以访问 <code class="bg-gray-100 px-2 py-1 rounded">api.minimaxi.com</code></li>
          <li><code>apiBase</code> 是否包含 <code>/v1</code> 后缀</li>
        </ul>
      </div>

      <div class="bg-gray-50 rounded-xl p-4 text-center text-gray-500 text-sm">
        <p>文档创建日期：2026-05-08</p>
      </div>
    `
  },
  'hermes-guide': {
    title: 'Hermes 完整配置指南',
    content: `
      <h1 class="text-3xl font-bold mb-6">Hermes AI Agent 配置与重装完整指南</h1>
      
      <div class="bg-gray-50 rounded-xl p-6 mb-8">
        <h2 class="text-xl font-bold mb-4">📑 目录</h2>
        <ul class="space-y-2 text-gray-700">
          <li><a href="#section1" class="text-purple-600 hover:underline">一、简介</a></li>
          <li><a href="#section2" class="text-purple-600 hover:underline">二、安装位置</a></li>
          <li><a href="#section3" class="text-purple-600 hover:underline">三、重装配置步骤</a></li>
          <li><a href="#section4" class="text-purple-600 hover:underline">四、常用命令</a></li>
          <li><a href="#section5" class="text-purple-600 hover:underline">五、Windows 编码问题</a></li>
          <li><a href="#section6" class="text-purple-600 hover:underline">六、API Key 配置</a></li>
          <li><a href="#section7" class="text-purple-600 hover:underline">七、WSL 环境问题</a></li>
          <li><a href="#section8" class="text-purple-600 hover:underline">八、Docker Desktop 冲突</a></li>
          <li><a href="#section9" class="text-purple-600 hover:underline">九、常见问题</a></li>
          <li><a href="#section10" class="text-purple-600 hover:underline">十、日志位置</a></li>
          <li><a href="#section11" class="text-purple-600 hover:underline">十一、配置文件详解</a></li>
        </ul>
      </div>

      <div id="section1" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">一、简介</h2>
        <p class="text-gray-700 mb-4">Hermes 是一个 AI Agent 软件，可以通过命令行与她对话。她能帮你完成代码编写、问题排查等各种任务。</p>
        <p class="text-gray-700">官方网站: <a href="https://hermes-agent.nousresearch.com/" target="_blank" class="text-purple-600 hover:underline">https://hermes-agent.nousresearch.com/</a></p>
      </div>

      <hr class="border-gray-200 my-8">

      <div id="section2" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">二、安装位置</h2>
        <table class="w-full border-collapse border border-gray-300">
          <thead>
            <tr class="bg-gray-100">
              <th class="border border-gray-300 px-4 py-2 text-left">类型</th>
              <th class="border border-gray-300 px-4 py-2 text-left">路径</th>
            </tr>
          </thead>
          <tbody>
            <tr><td class="border border-gray-300 px-4 py-2">主程序</td><td class="border border-gray-300 px-4 py-2"><code>C:\\Users\\Lenovo\\AppData\\Local\\hermes\\hermes-agent</code></td></tr>
            <tr><td class="border border-gray-300 px-4 py-2">虚拟环境</td><td class="border border-gray-300 px-4 py-2"><code>C:\\Users\\Lenovo\\AppData\\Local\\hermes\\hermes-agent\\venv</code></td></tr>
            <tr><td class="border border-gray-300 px-4 py-2">可执行文件</td><td class="border border-gray-300 px-4 py-2"><code>C:\\Users\\Lenovo\\AppData\\Local\\hermes\\hermes-agent\\venv\\Scripts\\hermes.exe</code></td></tr>
            <tr><td class="border border-gray-300 px-4 py-2">配置文件</td><td class="border border-gray-300 px-4 py-2"><code>C:\\Users\\Lenovo\\AppData\\Local\\hermes\\config.yaml</code></td></tr>
            <tr><td class="border border-gray-300 px-4 py-2">环境变量</td><td class="border border-gray-300 px-4 py-2"><code>C:\\Users\\Lenovo\\AppData\\Local\\hermes\\.env</code></td></tr>
            <tr><td class="border border-gray-300 px-4 py-2">日志目录</td><td class="border border-gray-300 px-4 py-2"><code>C:\\Users\\Lenovo\\AppData\\Local\\hermes\\logs</code></td></tr>
          </tbody>
        </table>
      </div>

      <hr class="border-gray-200 my-8">

      <div id="section3" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">三、重装配置步骤</h2>
        
        <h3 class="text-xl font-semibold mb-3">第一步：安装 Hermes</h3>
        <ol class="list-decimal list-inside space-y-2 text-gray-700 mb-4">
          <li>打开 PowerShell 或 CMD</li>
          <li>运行以下命令安装：<br><code class="bg-gray-100 px-2 py-1 rounded ml-2">npm install -g hermes-ai-agent</code></li>
          <li>或使用国内镜像：<br><code class="bg-gray-100 px-2 py-1 rounded ml-2">npm install -g hermes-ai-agent --registry https://registry.npmmirror.com</code></li>
        </ol>

        <h3 class="text-xl font-semibold mb-3">第二步：启动 Hermes</h3>
        <p class="text-gray-700 mb-2">直接运行：</p>
        <div class="bg-gray-900 rounded-lg p-4 mb-4"><code class="text-green-400">hermes</code></div>
        <p class="text-gray-700 mb-2">或者使用完整路径：</p>
        <div class="bg-gray-900 rounded-lg p-4 mb-4"><code class="text-green-400">C:\\Users\\Lenovo\\AppData\\Local\\hermes\\hermes-agent\\venv\\Scripts\\hermes.exe</code></div>

        <h3 class="text-xl font-semibold mb-3">第三步：首次配置</h3>
        <p class="text-gray-700 mb-4">首次运行时会提示配置，按提示操作即可。如果需要手动配置，运行：</p>
        <div class="bg-gray-900 rounded-lg p-4 mb-4"><code class="text-green-400">hermes setup</code></div>

        <h3 class="text-xl font-semibold mb-3">第四步：设置模型</h3>
        <p class="text-gray-700 mb-2">运行以下命令选择模型：</p>
        <div class="bg-gray-900 rounded-lg p-4 mb-4"><code class="text-green-400">hermes model</code></div>
        <p class="text-gray-700 mb-4">当前配置：</p>
        <ul class="list-disc list-inside text-gray-700 mb-4">
          <li>模型: MiniMax-M2.7-highspeed</li>
          <li>提供商: MiniMax (China)</li>
          <li>API 地址: https://api.minimaxi.com/v1/</li>
        </ul>

        <h3 class="text-xl font-semibold mb-3">第五步：设置 API Key</h3>
        <p class="text-gray-700 mb-2">如果需要更换 API Key，编辑以下文件：</p>
        <div class="bg-gray-900 rounded-lg p-4 mb-4"><code class="text-green-400">C:\\Users\\Lenovo\\AppData\\Local\\hermes\\.env</code></div>
        <p class="text-gray-700 mb-2">添加或修改：</p>
        <div class="bg-gray-900 rounded-lg p-4 mb-4"><code class="text-green-400">MINIMAX_API_KEY=*** Key&gt;</code></div>

        <h3 class="text-xl font-semibold mb-3">第六步：验证安装</h3>
        <p class="text-gray-700 mb-2">运行以下命令验证：</p>
        <div class="bg-gray-900 rounded-lg p-4 mb-4"><code class="text-green-400">set PYTHONIOENCODING=utf-8 && hermes status</code></div>
      </div>

      <hr class="border-gray-200 my-8">

      <div id="section4" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">四、常用命令</h2>
        <table class="w-full border-collapse border border-gray-300">
          <thead><tr class="bg-gray-100"><th class="border border-gray-300 px-4 py-2 text-left">命令</th><th class="border border-gray-300 px-4 py-2 text-left">说明</th></tr></thead>
          <tbody>
            <tr><td class="border border-gray-300 px-4 py-2"><code>hermes</code></td><td class="border border-gray-300 px-4 py-2">启动交互式聊天</td></tr>
            <tr><td class="border border-gray-300 px-4 py-2"><code>hermes status</code></td><td class="border border-gray-300 px-4 py-2">查看状态（需设置编码）</td></tr>
            <tr><td class="border border-gray-300 px-4 py-2"><code>hermes logs</code></td><td class="border border-gray-300 px-4 py-2">查看日志</td></tr>
            <tr><td class="border border-gray-300 px-4 py-2"><code>hermes setup</code></td><td class="border border-gray-300 px-4 py-2">交互式配置向导</td></tr>
            <tr><td class="border border-gray-300 px-4 py-2"><code>hermes model</code></td><td class="border border-gray-300 px-4 py-2">选择模型</td></tr>
            <tr><td class="border border-gray-300 px-4 py-2"><code>hermes config</code></td><td class="border border-gray-300 px-4 py-2">查看配置</td></tr>
            <tr><td class="border border-gray-300 px-4 py-2"><code>hermes doctor</code></td><td class="border border-gray-300 px-4 py-2">诊断检查</td></tr>
          </tbody>
        </table>
      </div>

      <hr class="border-gray-200 my-8">

      <div id="section5" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">五、Windows 编码问题</h2>
        <p class="text-gray-700 mb-4">由于 Windows CMD 使用 GBK 编码，直接运行会显示乱码。</p>
        <p class="text-gray-700 mb-4"><strong>解决方法</strong>：在命令前加编码设置</p>
        <div class="bg-gray-900 rounded-lg p-4 mb-2"><code class="text-green-400">set PYTHONIOENCODING=utf-8 && hermes status</code></div>
        <p class="text-gray-700 mb-2">或者在 PowerShell 中：</p>
        <div class="bg-gray-900 rounded-lg p-4"><code class="text-green-400">$env:PYTHONIOENCODING="utf-8"; hermes status</code></div>
      </div>

      <hr class="border-gray-200 my-8">

      <div id="section6" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">六、API Key 配置</h2>
        <h3 class="text-xl font-semibold mb-3">当前配置</h3>
        <ul class="list-disc list-inside text-gray-700 mb-4">
          <li>模型: MiniMax-M2.7-highspeed</li>
          <li>提供商: MiniMax (China)</li>
          <li>API 地址: https://api.minimaxi.com/v1/</li>
        </ul>
        <h3 class="text-xl font-semibold mb-3">可用模型列表</h3>
        <table class="w-full border-collapse border border-gray-300">
          <thead><tr class="bg-gray-100"><th class="border border-gray-300 px-4 py-2 text-left">模型名称</th><th class="border border-gray-300 px-4 py-2 text-left">说明</th></tr></thead>
          <tbody>
            <tr><td class="border border-gray-300 px-4 py-2"><code>MiniMax-M2.7-highspeed</code></td><td class="border border-gray-300 px-4 py-2">MiniMax M2.7 高速版</td></tr>
            <tr><td class="border border-gray-300 px-4 py-2"><code>MiniMax-M2.7</code></td><td class="border border-gray-300 px-4 py-2">MiniMax M2.7 标准版</td></tr>
            <tr><td class="border border-gray-300 px-4 py-2"><code>MiniMax-Text-01</code></td><td class="border border-gray-300 px-4 py-2">MiniMax Text-01</td></tr>
          </tbody>
        </table>
      </div>

      <hr class="border-gray-200 my-8">

      <div id="section9" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">九、常见问题</h2>
        
        <h3 class="text-xl font-semibold mb-3">Q1: Hermes 和 OpenClaw 是两个软件吗？</h3>
        <p class="text-gray-700 mb-4">A: 是的。Hermes 和 OpenClaw 是两个不同的 AI Agent 软件。</p>
        
        <h3 class="text-xl font-semibold mb-3">Q2: 为什么终端输出乱码？</h3>
        <p class="text-gray-700 mb-4">A: WSL Ubuntu 没有 node.js，而 Hermes 是 Windows 程序。WSL PATH 包含 Windows 路径，导致冲突。解决方案：退出 WSL，在 Windows 原生环境运行 Hermes。</p>
        
        <h3 class="text-xl font-semibold mb-3">Q3: 命令提示 "node: not found"</h3>
        <p class="text-gray-700 mb-4">A: 这是因为你当前在 WSL Ubuntu 环境中。退出 WSL：<code>exit</code>，然后在 Windows PowerShell 中运行命令。</p>
        
        <h3 class="text-xl font-semibold mb-3">Q4: 如何诊断问题？</h3>
        <p class="text-gray-700 mb-4">A: 运行诊断命令：<code>hermes doctor</code></p>
      </div>

      <div class="bg-gray-50 rounded-xl p-4 text-center text-gray-500 text-sm">
        <p>文档创建日期：2026-05-08 | 最后更新：2026-05-08</p>
      </div>
    `
  },
  'hermes-config-file': {
    title: 'Hermes 配置文件内容记录',
    content: `
      <h1 class="text-3xl font-bold mb-6">Hermes 配置文件内容记录</h1>
      
      <div class="bg-gray-50 rounded-xl p-6 mb-8">
        <h2 class="text-xl font-bold mb-4">📑 目录</h2>
        <ul class="space-y-2 text-gray-700">
          <li><a href="#section1" class="text-purple-600 hover:underline">1. 首次配置流程</a></li>
          <li><a href="#section2" class="text-purple-600 hover:underline">2. 命令列表</a></li>
          <li><a href="#section3" class="text-purple-600 hover:underline">3. 配置信息</a></li>
          <li><a href="#section4" class="text-purple-600 hover:underline">4. 模型信息</a></li>
        </ul>
      </div>

      <div id="section1" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">1. 首次配置流程</h2>
        <div class="bg-gray-900 rounded-lg p-4 mb-4">
          <pre class="text-green-400 overflow-x-auto">PS C:\\Users\\Lenovo> hermes

It looks like Hermes isn't configured yet -- no API keys or providers found.
Run:  hermes setup

Run setup now? [Y/n]</pre>
        </div>
      </div>

      <hr class="border-gray-200 my-8">

      <div id="section2" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">2. 命令列表</h2>
        <div class="bg-gray-900 rounded-lg p-4 mb-4">
          <pre class="text-gray-300 overflow-x-auto"><code>hermes                        Start interactive chat
hermes chat -q "Hello"        Single query mode
hermes -c                     Resume the most recent session
hermes setup                  Run setup wizard
hermes model                  Select default model
hermes config                 View configuration
hermes logs                   View agent.log (last 50 lines)
hermes logs -f                Follow agent.log in real time</code></pre>
        </div>
      </div>

      <hr class="border-gray-200 my-8">

      <div id="section3" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">3. 配置信息</h2>
        <div class="bg-gray-900 rounded-lg p-4 mb-4">
          <pre class="text-gray-300 overflow-x-auto"><code>◆ Paths
  Config:       C:\\Users\\Lenovo\\AppData\\Local\\hermes\\config.yaml
  Secrets:      C:\\Users\\Lenovo\\AppData\\Local\\hermes\\.env

◆ Model
  Model:        MiniMax-M2.7-highspeed
  Provider:     minimax-cn
  Base URL:     https://api.minimaxi.com/anthropic

◆ Terminal
  Backend:      local
  Timeout:      180s</code></pre>
        </div>
      </div>

      <hr class="border-gray-200 my-8">

      <div id="section4" class="mb-8">
        <h2 class="text-2xl font-bold mb-4">4. 模型信息</h2>
        <ul class="list-disc list-inside text-gray-700 mb-4">
          <li>模型: MiniMax-M2.7-highspeed</li>
          <li>提供商: MiniMax (China)</li>
          <li>API 地址: https://api.minimaxi.com/v1/</li>
        </ul>
      </div>

      <div class="bg-gray-50 rounded-xl p-4 text-center text-gray-500 text-sm">
        <p>文档创建日期：2026-05-08</p>
      </div>
    `
  }
}

// 获取当前文档
const currentDoc = computed(() => {
  return embeddedDocuments[docId.value]
})

// 渲染内容
const renderedContent = computed(() => {
  return currentDoc.value?.content || ''
})
</script>

<style>
/* Markdown 样式 */
.rendered-content h1 {
  font-size: 1.875rem;
  font-weight: 700;
  margin-bottom: 1rem;
}
.rendered-content h2 {
  font-size: 1.5rem;
  font-weight: 600;
  margin-top: 2rem;
  margin-bottom: 1rem;
}
.rendered-content h3 {
  font-size: 1.25rem;
  font-weight: 500;
  margin-top: 1.5rem;
  margin-bottom: 0.75rem;
}
.rendered-content p {
  margin-bottom: 1rem;
  line-height: 1.75;
}
.rendered-content ul, .rendered-content ol {
  margin-bottom: 1rem;
  padding-left: 1.5rem;
}
.rendered-content li {
  margin-bottom: 0.5rem;
}
.rendered-content code {
  background-color: #f3f4f6;
  padding: 0.125rem 0.375rem;
  border-radius: 0.25rem;
  font-size: 0.875rem;
}
.rendered-content pre {
  background-color: #1f2937;
  color: #e5e7eb;
  padding: 1rem;
  border-radius: 0.5rem;
  overflow-x: auto;
  margin-bottom: 1rem;
}
.rendered-content pre code {
  background-color: transparent;
  padding: 0;
  color: inherit;
}
.rendered-content table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 1rem;
}
.rendered-content th, .rendered-content td {
  border: 1px solid #d1d5db;
  padding: 0.5rem 0.75rem;
  text-align: left;
}
.rendered-content th {
  background-color: #f9fafb;
}
.rendered-content hr {
  border: none;
  border-top: 1px solid #e5e7eb;
  margin: 2rem 0;
}
.rendered-content a {
  color: #7c3aed;
}
.rendered-content a:hover {
  text-decoration: underline;
}
.rendered-content blockquote {
  border-left: 4px solid #d1d5db;
  padding-left: 1rem;
  margin-left: 0;
  color: #6b7280;
}
</style>

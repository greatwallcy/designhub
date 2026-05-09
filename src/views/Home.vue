<template>
  <div class="p-8">
    <!-- 欢迎区域 -->
    <div class="hero-gradient rounded-2xl p-8 mb-8 text-white">
      <h1 class="text-4xl font-bold mb-4">🚀 欢迎来到 DesignHub</h1>
      <p class="text-xl opacity-90 mb-2">一站式项目展示与管理平台</p>
      <p class="text-lg opacity-80">选择一个开发平台开始探索</p>
    </div>

    <!-- 开发平台 -->
    <h2 class="text-2xl font-bold mb-6">📂 开发平台</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-12">
      <router-link
        v-for="platform in platforms"
        :key="platform.id"
        :to="`/platform/${platform.id}`"
        class="bg-white rounded-xl p-6 shadow-sm hover:shadow-lg transition card-hover border"
      >
        <div class="flex items-center mb-4">
          <div :class="['w-16 h-16 rounded-xl flex items-center justify-center text-3xl', platform.bgColor]">
            {{ platform.icon }}
          </div>
          <div class="ml-4">
            <h3 class="text-xl font-bold">{{ platform.name }}</h3>
            <p class="text-gray-500 text-sm">{{ platform.description }}</p>
          </div>
        </div>
        <div class="flex items-center justify-between">
          <span class="text-sm text-gray-500">{{ getProjectCount(platform.id) }} 个项目</span>
          <span class="text-purple-600 text-sm">查看 →</span>
        </div>
      </router-link>
    </div>

    <!-- 经验文档 -->
    <h2 class="text-2xl font-bold mb-6">📖 经验文档</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-12">
      <router-link 
        v-for="cat in mainCategories" 
        :key="cat.id"
        :to="`/documents/${cat.id}`"
        class="bg-white rounded-xl p-6 shadow-sm hover:shadow-lg transition card-hover border"
      >
        <div class="flex items-center mb-4">
          <div :class="['w-16 h-16 rounded-xl flex items-center justify-center text-3xl', cat.bgColor]">
            {{ cat.icon }}
          </div>
          <div class="ml-4">
            <h3 class="text-xl font-bold">{{ cat.name }}</h3>
            <p class="text-gray-500 text-sm">{{ cat.description }}</p>
          </div>
        </div>
        <div class="flex items-center justify-between">
          <span class="text-sm text-gray-500">{{ getDocCount(cat.id) }} 篇文档</span>
          <span class="text-purple-600 text-sm">查看 →</span>
        </div>
      </router-link>
    </div>

    <!-- 工具 -->
    <h2 class="text-2xl font-bold mb-6">🛠️ 工具</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <router-link
        v-for="tool in tools"
        :key="tool.id"
        :to="`/tool/${tool.id}`"
        class="bg-white rounded-xl p-6 shadow-sm hover:shadow-lg transition card-hover border"
      >
        <div class="flex items-center mb-4">
          <div :class="['w-16 h-16 rounded-xl flex items-center justify-center text-3xl', tool.bgColor]">
            {{ tool.icon }}
          </div>
          <div class="ml-4">
            <h3 class="text-xl font-bold">{{ tool.name }}</h3>
            <p class="text-gray-500 text-sm">{{ tool.description }}</p>
          </div>
        </div>
        <div class="flex items-center justify-between">
          <span class="text-sm text-gray-500">{{ tool.children.length }} 个工具</span>
          <span class="text-purple-600 text-sm">查看 →</span>
        </div>
      </router-link>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const mainCategories = [
  { 
    id: 'ai', 
    name: 'AI 安装及应用', 
    icon: '🤖', 
    bgColor: 'bg-purple-100',
    description: 'AI 工具安装与应用' 
  },
  { 
    id: 'hardware', 
    name: '硬件设计经验', 
    icon: '🔧', 
    bgColor: 'bg-purple-100',
    description: '嵌入式开发与 PCB 设计' 
  },
  { 
    id: 'software', 
    name: '软件编程经验', 
    icon: '💻', 
    bgColor: 'bg-cyan-100',
    description: '前端与后端开发' 
  },
  { 
    id: 'life', 
    name: '生活经验', 
    icon: '🏠', 
    bgColor: 'bg-yellow-100',
    description: '日常实用技巧' 
  },
]

// AI 安装及应用下的子分类
const aiSubCategories = [
  { 
    id: 'ai-vscode', 
    name: 'VS CODE 安装', 
    icon: '📝', 
    bgColor: 'bg-blue-100',
    description: 'VS Code 插件安装与配置' 
  },
  { 
    id: 'ai-hermes', 
    name: 'Hermes 安装', 
    icon: '🤖', 
    bgColor: 'bg-green-100',
    description: 'Hermes AI Agent 安装与配置' 
  },
]

const allDocuments = [
  // VS CODE 安装
  { id: 'vscode-continue-minimax', category: 'ai-vscode', title: 'VSCode Continue 配置 MiniMax', description: 'VS Code 插件配置教程', icon: '📝', bgColor: 'bg-blue-100' },
  // Hermes 安装
  { id: 'hermes-guide', category: 'ai-hermes', title: 'Hermes 完整配置指南', description: 'Hermes 安装与配置完整记录', icon: '🤖', bgColor: 'bg-green-100' },
  { id: 'hermes-config-file', category: 'ai-hermes', title: 'Hermes 配置文件内容记录', description: 'MiniMax API 等配置记录', icon: '📄', bgColor: 'bg-blue-100' },
  // 硬件设计经验

  { id: 'pcb-design', category: 'hardware', title: 'PCB 设计经验分享', description: '原理图与布线技巧', icon: '🔲', bgColor: 'bg-orange-100' },
  // 软件编程经验
  { id: 'vue-guide', category: 'software', title: 'Vue3 项目开发指南', description: '前端框架使用心得', icon: '🌐', bgColor: 'bg-cyan-100' },
  // 生活经验
  { id: 'daily-tips', category: 'life', title: '日常实用技巧', description: '生活小窍门汇总', icon: '💡', bgColor: 'bg-yellow-100' },
]

const getDocCount = (categoryId) => {
  if (categoryId === 'ai') {
    // AI 安装及应用 统计所有子分类文档数
    const aiCatIds = aiSubCategories.map(c => c.id)
    return allDocuments.filter(doc => aiCatIds.includes(doc.category)).length
  }
  return allDocuments.filter(doc => doc.category === categoryId).length
}

const platforms = [
  { 
    id: 'stm32', 
    name: 'STM32开发', 
    icon: '🔧', 
    bgColor: 'bg-purple-100',
    description: 'ARM Cortex-M 系列微控制器' 
  },
  { 
    id: 'esp32', 
    name: 'ESP32开发', 
    icon: '📡', 
    bgColor: 'bg-green-100',
    description: 'WiFi + 蓝牙双模物联网芯片' 
  },
  { 
    id: 'c51', 
    name: 'C51开发', 
    icon: '🔌', 
    bgColor: 'bg-orange-100',
    description: '经典 8051 单片机系列' 
  },
  { 
    id: 'web', 
    name: '网页开发', 
    icon: '🌐', 
    bgColor: 'bg-blue-100',
    description: '前端与后端 Web 开发' 
  },
]

const allProjects = ref([
  { id: 1, platform: 'stm32' },
  { id: 2, platform: 'esp32' },
  { id: 3, platform: 'c51' },
  { id: 4, platform: 'web' },
])

const getProjectCount = (platformId) => {
  return allProjects.value.filter(p => p.platform === platformId).length
}

const tools = [
  {
    id: 'bom',
    name: 'BOM辅助工具',
    icon: '📋',
    bgColor: 'bg-purple-100',
    description: 'BOM相关辅助工具',
    children: [{ id: 'bom-match', name: 'BOM匹配工具' }]
  },
  {
    id: 'ad',
    name: 'AD辅助工具',
    icon: '📐',
    bgColor: 'bg-blue-100',
    description: 'Altium Designer辅助工具',
    children: []
  },
  {
    id: 'design',
    name: '设计工具',
    icon: '🎨',
    bgColor: 'bg-green-100',
    description: '设计辅助工具',
    children: []
  },
  {
    id: 'daily',
    name: '日常工具',
    icon: '📦',
    bgColor: 'bg-yellow-100',
    description: '日常实用工具',
    children: [
      { id: 'word', name: 'Word文档' },
      { id: 'excel', name: 'Excel表格' },
      { id: 'ppt', name: 'PPT演示' }
    ]
  },
]
</script>

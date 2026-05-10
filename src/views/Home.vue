<template>
  <div class="p-8">
    <!-- 欢迎区域 -->
    <div class="hero-gradient rounded-2xl p-8 mb-8 text-white">
      <h1 class="text-4xl font-bold mb-4">🚀 欢迎来到 DesignHub</h1>
      <p class="text-xl opacity-90 mb-2">一站式项目展示与管理平台</p>
      <p class="text-lg opacity-80">选择一个分类开始探索</p>
    </div>

    <!-- 主分类 -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
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
        <div class="flex items-center justify-end">
          <span class="text-purple-600 text-sm flex items-center">
            查看
            <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </span>
        </div>
      </router-link>
    </div>

    <!-- 经验文档子分类 -->
    <h2 class="text-2xl font-bold mb-6">📖 经验文档</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-12">
      <router-link 
        v-for="cat in experienceCategories" 
        :key="cat.id"
        :to="`/documents/经验文档/${cat.id}`"
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
        <div class="flex items-center justify-end">
          <span class="text-purple-600 text-sm flex items-center">
            查看
            <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </span>
        </div>
      </router-link>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const mainCategories = [
  { 
    id: '平台开发', 
    name: '平台开发', 
    icon: '🖥️', 
    bgColor: 'bg-green-100',
    description: '开发板与平台项目' 
  },
  { 
    id: '经验文档', 
    name: '经验文档', 
    icon: '📖', 
    bgColor: 'bg-purple-100',
    description: '开发经验与技术文档汇总' 
  },
  { 
    id: '实用工具', 
    name: '实用工具', 
    icon: '🛠️', 
    bgColor: 'bg-orange-100',
    description: '日常开发辅助工具' 
  },
]

// 经验文档下的子分类
const experienceCategories = [
  { 
    id: 'AI安装与应用', 
    name: 'AI安装与应用', 
    icon: '🤖', 
    bgColor: 'bg-blue-100',
    description: 'AI 工具安装与应用' 
  },
  { 
    id: '硬件设计经验', 
    name: '硬件设计经验', 
    icon: '🔧', 
    bgColor: 'bg-purple-100',
    description: '嵌入式开发与 PCB 设计' 
  },
  { 
    id: '软件编程经验', 
    name: '软件编程经验', 
    icon: '💻', 
    bgColor: 'bg-cyan-100',
    description: '前端与后端开发' 
  },
  { 
    id: '生活经验', 
    name: '生活经验', 
    icon: '🏠', 
    bgColor: 'bg-yellow-100',
    description: '日常实用技巧' 
  },
]

const allDocuments = [
  // AI安装与应用
  { id: 'VSCODE安装', category: 'AI安装与应用', title: 'VSCode Continue 配置 MiniMax', description: 'VS Code 插件配置教程', icon: '📝', bgColor: 'bg-blue-100' },
  { id: 'Hermes安装', category: 'AI安装与应用', title: 'Hermes 完整配置指南', description: 'Hermes 安装与配置完整记录', icon: '🤖', bgColor: 'bg-green-100' },
  // 硬件设计经验
  { id: 'STM32F103开发板接口定义', category: '硬件设计经验', title: 'STM32F103 开发板接口定义', description: '开发板外设引脚与冲突矩阵', icon: '🔧', bgColor: 'bg-purple-100' },
  // 软件编程经验
  { id: 'Vue3项目开发指南', category: '软件编程经验', title: 'Vue3 项目开发指南', description: '前端框架使用心得', icon: '🌐', bgColor: 'bg-cyan-100' },
  // 生活经验
  { id: '日常实用技巧', category: '生活经验', title: '日常实用技巧', description: '生活小窍门汇总', icon: '💡', bgColor: 'bg-yellow-100' },
]

const getDocCount = (categoryId) => {
  if (categoryId === '经验文档') {
    // 经验文档 统计所有子分类文档数
    const expCatIds = experienceCategories.map(c => c.id)
    return allDocuments.filter(doc => expCatIds.includes(doc.category)).length
  }
  return allDocuments.filter(doc => doc.category === categoryId).length
}


</script>

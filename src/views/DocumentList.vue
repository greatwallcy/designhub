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
    <!-- AI 安装及应用 显示子分类 -->
    <div v-if="category === 'ai'">
      <!-- 分类标题 -->
      <div class="hero-gradient rounded-2xl p-8 mb-8 text-white">
        <h1 class="text-3xl font-bold mb-2">🤖 AI 安装及应用</h1>
        <p class="text-lg opacity-90">AI 工具安装与应用</p>
      </div>
      
      <!-- 子分类卡片 -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <router-link 
          v-for="subCat in subCategories" 
          :key="subCat.id"
          :to="`/documents/${subCat.id}`"
          class="bg-white rounded-xl p-6 shadow-sm hover:shadow-lg transition card-hover border"
        >
          <div class="flex items-center mb-4">
            <div :class="['w-16 h-16 rounded-xl flex items-center justify-center text-3xl', subCat.bgColor]">
              {{ subCat.icon }}
            </div>
            <div class="ml-4">
              <h3 class="text-xl font-bold">{{ subCat.name }}</h3>
              <p class="text-gray-500 text-sm">{{ subCat.description }}</p>
            </div>
          </div>
          <div class="flex items-center justify-between">
            <span class="text-sm text-gray-500">
              {{ getSubDocCount(subCat.id) }} 篇文档
            </span>
            <span class="text-purple-600 text-sm flex items-center">
              查看详情
              <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
              </svg>
            </span>
          </div>
        </router-link>
      </div>
    </div>

    <!-- 其他分类显示文档列表 -->
    <div v-else>
      <!-- 分类标题 -->
      <div :class="['rounded-2xl p-8 mb-8 text-white', categoryInfo.bgColor]" :style="category === 'docs' ? '' : ''">
        <h1 class="text-3xl font-bold mb-2">{{ categoryInfo.icon }} {{ categoryInfo.name }}</h1>
        <p class="text-lg opacity-90">{{ categoryInfo.description }}</p>
      </div>

      <!-- 经验文档总览 -->
      <div v-if="category === 'docs'" class="grid grid-cols-1 md:grid-cols-2 gap-6">
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
            <span class="text-sm text-gray-500">
              {{ getCatDocCount(cat.id) }} 篇文档
            </span>
            <span class="text-purple-600 text-sm flex items-center">
              查看详情
              <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
              </svg>
            </span>
          </div>
        </router-link>
      </div>

      <!-- 文档列表 -->
      <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <router-link 
          v-for="doc in categoryDocs" 
          :key="doc.id"
          :to="`/documents/${category}/${doc.id}`"
          class="bg-white rounded-xl p-6 shadow-sm hover:shadow-lg transition card-hover border"
        >
          <div class="flex items-center mb-2">
            <div :class="['w-10 h-10 rounded-lg flex items-center justify-center text-xl', doc.bgColor]">
              {{ doc.icon }}
            </div>
            <h3 class="ml-3 text-lg font-bold">{{ doc.title }}</h3>
          </div>
          <p class="text-gray-500 text-sm mb-4">{{ doc.description }}</p>
          <span class="text-purple-600 text-sm">阅读详情 →</span>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const category = computed(() => route.params.category)

const goBack = () => {
  if (window.history.length > 1) {
    router.back()
  } else {
    router.push('/')
  }
}

const mainCategories = [
  {
    id: 'ai',
    name: 'AI 安装及应用',
    description: 'AI 工具安装与应用',
    icon: '🤖',
    bgColor: 'bg-blue-100'
  },
  {
    id: 'hardware',
    name: '硬件设计经验',
    description: '嵌入式开发与 PCB 设计',
    icon: '🔧',
    bgColor: 'bg-purple-100'
  },
  {
    id: 'software',
    name: '软件编程经验',
    description: '前端与后端开发',
    icon: '💻',
    bgColor: 'bg-cyan-100'
  },
  {
    id: 'life',
    name: '生活经验',
    description: '日常实用技巧',
    icon: '🏠',
    bgColor: 'bg-yellow-100'
  }
]

const subCategories = [
  {
    id: 'ai-vscode',
    name: 'VS CODE 安装',
    description: 'VS Code 插件安装与配置',
    icon: '📝',
    bgColor: 'bg-blue-100'
  },
  {
    id: 'ai-hermes',
    name: 'Hermes 安装',
    description: 'Hermes AI Agent 安装与配置',
    icon: '🤖',
    bgColor: 'bg-green-100'
  }
]

const categoryInfoMap = {
  'ai': {
    name: 'AI 安装及应用',
    description: 'AI 工具安装与应用',
    icon: '🤖',
    bgColor: 'bg-blue-100'
  },
  'ai-vscode': {
    name: 'VS CODE 安装',
    description: 'VS Code 插件安装与配置',
    icon: '📝',
    bgColor: 'bg-blue-100'
  },
  'ai-hermes': {
    name: 'Hermes 安装',
    description: 'Hermes AI Agent 安装与配置',
    icon: '🤖',
    bgColor: 'bg-green-100'
  },
  'hardware': {
    name: '硬件设计经验',
    description: '嵌入式开发与 PCB 设计',
    icon: '🔧',
    bgColor: 'bg-purple-100'
  },
  'software': {
    name: '软件编程经验',
    description: '前端与后端开发',
    icon: '💻',
    bgColor: 'bg-cyan-100'
  },
  'life': {
    name: '生活经验',
    description: '日常实用技巧',
    icon: '🏠',
    bgColor: 'bg-yellow-100'
  },
  'docs': {
    name: '经验文档',
    description: '所有经验文档汇总',
    icon: '📖',
    bgColor: 'bg-green-100'
  }
}

const categoryInfo = computed(() => {
  return categoryInfoMap[category.value] || { name: '未知分类', description: '', icon: '📄', bgColor: 'bg-gray-100' }
})

const allDocuments = [
  { id: 'vscode-continue-minimax', category: 'ai-vscode', title: 'VSCode Continue 配置 MiniMax', description: 'VS Code 插件配置教程', icon: '📝', bgColor: 'bg-blue-100' },
  { id: 'hermes-guide', category: 'ai-hermes', title: 'Hermes 完整配置指南', description: 'Hermes 安装与配置完整记录', icon: '🤖', bgColor: 'bg-green-100' },
  { id: 'hermes-config-file', category: 'ai-hermes', title: 'Hermes 配置文件内容记录', description: 'MiniMax API 等配置记录', icon: '📄', bgColor: 'bg-blue-100' },
  { id: 'pcb-design', category: 'hardware', title: 'PCB 设计经验分享', description: '原理图与布线技巧', icon: '🔲', bgColor: 'bg-orange-100' },
  { id: 'vue-guide', category: 'software', title: 'Vue3 项目开发指南', description: '前端框架使用心得', icon: '🌐', bgColor: 'bg-cyan-100' },
  { id: 'daily-tips', category: 'life', title: '日常实用技巧', description: '生活小窍门汇总', icon: '💡', bgColor: 'bg-yellow-100' }
]

const categoryDocs = computed(() => {
  return allDocuments.filter(doc => doc.category === category.value)
})

const getSubDocCount = (subCategoryId) => {
  return allDocuments.filter(doc => doc.category === subCategoryId).length
}

const getCatDocCount = (catId) => {
  return allDocuments.filter(doc => doc.category === catId).length
}
</script>

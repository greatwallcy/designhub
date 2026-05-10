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
    <!-- 经验文档主分类视图 (/documents/经验文档) -->
    <div v-if="type === '经验文档' && !category">
      <div class="hero-gradient rounded-2xl p-8 mb-8 text-white">
        <h1 class="text-3xl font-bold mb-2">📖 经验文档</h1>
        <p class="text-lg opacity-90">开发经验与技术文档汇总</p>
      </div>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
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
              查看文档
              <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
              </svg>
            </span>
          </div>
        </router-link>
      </div>
    </div>

    <!-- 子分类文档列表 (/documents/经验文档/AI安装与应用) -->
    <div v-else-if="category">
      <div class="hero-gradient rounded-2xl p-8 mb-8 text-white">
        <h1 class="text-3xl font-bold mb-2">{{ categoryInfo.icon }} {{ categoryInfo.name }}</h1>
        <p class="text-lg opacity-90">{{ categoryInfo.description }}</p>
      </div>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <router-link 
          v-for="doc in categoryDocs" 
          :key="doc.id"
          :to="`/documents/经验文档/${category}/${doc.id}`"
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

    <!-- 平台开发视图 -->
    <div v-else-if="type === '平台开发' && !category">
      <div class="hero-gradient rounded-2xl p-8 mb-8 text-white">
        <h1 class="text-3xl font-bold mb-2">🖥️ 平台开发</h1>
        <p class="text-lg opacity-90">开发板与平台项目</p>
      </div>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <router-link 
          v-for="platform in platformCategories" 
          :key="platform.id"
          :to="`/documents/平台开发/${platform.id}`"
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
          <div class="flex items-center justify-end">
            <span class="text-purple-600 text-sm flex items-center">
              查看项目
              <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
              </svg>
            </span>
          </div>
        </router-link>
      </div>
    </div>

    <!-- 平台子分类项目列表 -->
    <div v-else-if="type === '平台开发' && category">
      <div class="hero-gradient rounded-2xl p-8 mb-8 text-white">
        <h1 class="text-3xl font-bold mb-2">{{ platformInfo.icon }} {{ platformInfo.name }}</h1>
        <p class="text-lg opacity-90">{{ platformInfo.description }}</p>
      </div>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <router-link 
          v-for="project in platformProjects" 
          :key="project.id"
          :to="`/documents/平台开发/${category}/${project.id}`"
          class="bg-white rounded-xl p-6 shadow-sm hover:shadow-lg transition card-hover border"
        >
          <div class="flex items-center mb-2">
            <div :class="['w-10 h-10 rounded-lg flex items-center justify-center text-xl', project.bgColor]">
              {{ project.icon }}
            </div>
            <h3 class="ml-3 text-lg font-bold">{{ project.name }}</h3>
          </div>
          <p class="text-gray-500 text-sm mb-4">{{ project.description }}</p>
          <span class="text-purple-600 text-sm">查看详情 →</span>
        </router-link>
      </div>
    </div>

    <!-- 实用工具视图 -->
    <div v-else-if="type === '实用工具'">
      <div class="hero-gradient rounded-2xl p-8 mb-8 text-white">
        <h1 class="text-3xl font-bold mb-2">🛠️ 实用工具</h1>
        <p class="text-lg opacity-90">日常开发辅助工具</p>
      </div>
      <div class="bg-gray-100 rounded-xl p-8 text-center text-gray-500">
        实用工具内容待添加
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const type = computed(() => route.params.type)
const category = computed(() => route.params.category)

const goBack = () => {
  if (window.history.length > 1) {
    router.back()
  } else {
    router.push('/')
  }
}

const experienceCategories = [
  { id: 'AI安装与应用', name: 'AI安装与应用', icon: '🤖', bgColor: 'bg-blue-100', description: 'AI 工具安装与应用' },
  { id: '硬件设计经验', name: '硬件设计经验', icon: '🔧', bgColor: 'bg-purple-100', description: '嵌入式开发与 PCB 设计' },
  { id: '软件编程经验', name: '软件编程经验', icon: '💻', bgColor: 'bg-cyan-100', description: '前端与后端开发' },
  { id: '生活经验', name: '生活经验', icon: '🏠', bgColor: 'bg-yellow-100', description: '日常实用技巧' },
]

const categoryInfoMap = {
  'AI安装与应用': { name: 'AI安装与应用', icon: '🤖', bgColor: 'bg-blue-100', description: 'AI 工具安装与应用' },
  '硬件设计经验': { name: '硬件设计经验', icon: '🔧', bgColor: 'bg-purple-100', description: '嵌入式开发与 PCB 设计' },
  '软件编程经验': { name: '软件编程经验', icon: '💻', bgColor: 'bg-cyan-100', description: '前端与后端开发' },
  '生活经验': { name: '生活经验', icon: '🏠', bgColor: 'bg-yellow-100', description: '日常实用技巧' },
}

const categoryInfo = computed(() => {
  return categoryInfoMap[category.value] || { name: '', icon: '📄', description: '', bgColor: 'bg-gray-100' }
})

const categoryDocs = computed(() => {
  return allDocuments.filter(doc => doc.category === category.value)
})

// 平台开发数据
const platformCategories = [
  { id: 'STM32开发', name: 'STM32开发', icon: '🔧', bgColor: 'bg-purple-100', description: 'ARM Cortex-M 系列微控制器' },
  { id: 'ESP32开发', name: 'ESP32开发', icon: '📡', bgColor: 'bg-green-100', description: 'WiFi + 蓝牙双模物联网芯片' },
  { id: 'C51开发', name: 'C51开发', icon: '🔌', bgColor: 'bg-orange-100', description: '经典 8051 单片机系列' },
  { id: '网页开发', name: '网页开发', icon: '🌐', bgColor: 'bg-blue-100', description: '前端与后端 Web 开发' },
]

const platformInfoMap = {
  'STM32开发': { name: 'STM32开发', icon: '🔧', bgColor: 'bg-purple-100', description: 'ARM Cortex-M 系列微控制器' },
  'ESP32开发': { name: 'ESP32开发', icon: '📡', bgColor: 'bg-green-100', description: 'WiFi + 蓝牙双模物联网芯片' },
  'C51开发': { name: 'C51开发', icon: '🔌', bgColor: 'bg-orange-100', description: '经典 8051 单片机系列' },
  '网页开发': { name: '网页开发', icon: '🌐', bgColor: 'bg-blue-100', description: '前端与后端 Web 开发' },
}

const platformInfo = computed(() => {
  return platformInfoMap[category.value] || { name: '', icon: '📁', description: '', bgColor: 'bg-gray-100' }
})

const platformProjects = computed(() => {
  return allProjects.filter(doc => doc.platform === category.value)
})

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

const allProjects = [
  // STM32
  { id: 'STM32开发板v1', platform: 'STM32开发', name: 'STM32 开发板 v1.2.1', description: '自主设计的 STM32F103 系列开发板', icon: '🔧', bgColor: 'bg-purple-100' },
  { id: 'STM32平衡车', platform: 'STM32开发', name: 'STM32 平衡车', description: '基于 STM32 的两轮自平衡车', icon: '🚗', bgColor: 'bg-purple-100' },
  // ESP32
  { id: 'ESP32气象站', platform: 'ESP32开发', name: 'ESP32 WiFi 气象站', description: '基于 ESP32 的物联网气象站', icon: '📡', bgColor: 'bg-green-100' },
  { id: 'ESP32智能灯控', platform: 'ESP32开发', name: 'ESP32 智能灯控', description: '手机 APP 控制的智能灯光系统', icon: '💡', bgColor: 'bg-green-100' },
  // C51
  { id: 'C51时钟', platform: 'C51开发', name: 'C51 单片机时钟', description: '经典 8051 单片机制作的数字时钟', icon: '🔌', bgColor: 'bg-orange-100' },
  { id: 'C51计算器', platform: 'C51开发', name: 'C51 计算器', description: '基于 8051 的简易计算器', icon: '🔢', bgColor: 'bg-orange-100' },
  // 网页
  { id: 'Portfolio', platform: '网页开发', name: '个人 Portfolio 网站', description: '响应式个人作品集网站', icon: '🌐', bgColor: 'bg-blue-100' },
  { id: '电商后台', platform: '网页开发', name: '电商后台管理系统', description: 'Vue + Element UI 后台系统', icon: '🛒', bgColor: 'bg-blue-100' },
]

</script>

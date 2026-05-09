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
    <!-- 平台头部 -->
    <div class="mb-8">
      <div class="flex items-center mb-4">
        <div :class="['w-16 h-16 rounded-xl flex items-center justify-center text-3xl mr-4', platform.bgColor]">
          {{ platform.icon }}
        </div>
        <div>
          <h1 class="text-3xl font-bold">{{ platform.name }}</h1>
          <p class="text-gray-500">{{ platform.description }}</p>
        </div>
      </div>
      <div class="text-sm text-gray-500">
        共 {{ projects.length }} 个项目
      </div>
    </div>

    <!-- 子系列卡片 -->
    <div v-if="subPlatforms.length > 0" class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
      <router-link
        v-for="sub in subPlatforms"
        :key="sub.id"
        :to="`/platform/${sub.id}`"
        class="bg-white rounded-xl p-6 shadow-sm hover:shadow-lg transition card-hover border border-purple-200"
      >
        <div class="flex items-center mb-4">
          <div :class="['w-16 h-16 rounded-xl flex items-center justify-center text-3xl', sub.bgColor]">
            {{ sub.icon }}
          </div>
          <div class="ml-4">
            <h3 class="text-xl font-bold">{{ sub.name }}</h3>
            <p class="text-gray-500 text-sm">{{ sub.description }}</p>
          </div>
        </div>
        <div class="text-purple-600 text-sm flex items-center">
          查看项目
          <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
          </svg>
        </div>
      </router-link>
    </div>

    <!-- 项目列表 -->
    <div v-if="projects.length > 0" class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <router-link 
        v-for="project in projects" 
        :key="project.id"
        :to="`/project/${project.id}`"
        class="bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-lg transition card-hover border"
      >
        <div :class="['h-36 bg-gradient-to-br', project.gradient]" class="flex items-center justify-center relative">
          <span class="text-5xl">{{ project.icon }}</span>
          <span class="absolute top-3 right-3 px-2 py-1 bg-black/30 text-white text-xs rounded-full">
            {{ project.tag }}
          </span>
        </div>
        <div class="p-5">
          <h3 class="text-lg font-semibold mb-2">{{ project.title }}</h3>
          <p class="text-gray-600 mb-3 text-sm line-clamp-2">{{ project.description }}</p>
          <div class="flex flex-wrap gap-2 mb-2">
            <span 
              v-for="t in project.tags" 
              :key="t"
              class="px-2 py-1 bg-gray-100 text-gray-600 text-xs rounded"
            >
              {{ t }}
            </span>
          </div>
          <div class="text-purple-600 text-sm flex items-center mt-3">
            查看详情
            <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </div>
        </div>
      </router-link>
    </div>

    <!-- 空状态 -->
    <div v-else class="text-center py-16">
      <span class="text-6xl block mb-4">📭</span>
      <p class="text-gray-500">该平台暂无项目</p>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const goBack = () => {
  router.go(-1)
}

const platforms = {
  stm32: { id: 'stm32', name: 'STM32开发', icon: '🔧', bgColor: 'bg-purple-100', description: 'ARM Cortex-M 系列微控制器' },
  stm32f103: { id: 'stm32f103', name: 'STM32F103', icon: '🔧', bgColor: 'bg-purple-100', description: 'Cortex-M3 高性能系列', parent: 'stm32' },
  stm32f407: { id: 'stm32f407', name: 'STM32F407', icon: '🔧', bgColor: 'bg-purple-100', description: 'Cortex-M4 高性能系列', parent: 'stm32' },
  esp32: { id: 'esp32', name: 'ESP32开发', icon: '📡', bgColor: 'bg-green-100', description: 'WiFi + 蓝牙双模物联网芯片' },
  c51: { id: 'c51', name: 'C51开发', icon: '🔌', bgColor: 'bg-orange-100', description: '经典 8051 单片机系列' },
  web: { id: 'web', name: '网页开发', icon: '🌐', bgColor: 'bg-blue-100', description: '前端与后端 Web 开发' },
}

const allProjects = [
  { id: 1, title: 'STM32 开发板 v1.2.1', description: '自主设计的 STM32F103 系列开发板', icon: '🔧', tags: ['STM32F103', 'PCB'], gradient: 'from-purple-600 to-blue-500', platform: 'stm32f103', tag: '开发板' },
  { id: 2, title: 'STM32 平衡车', description: '基于 STM32 的两轮自平衡车', icon: '🚗', tags: ['STM32F103', '平衡车'], gradient: 'from-purple-500 to-indigo-500', platform: 'stm32f103', tag: '平衡车' },
  { id: 3, title: 'ESP32 WiFi 气象站', description: '基于 ESP32 的物联网气象站', icon: '📡', tags: ['ESP32', '物联网'], gradient: 'from-green-500 to-teal-500', platform: 'esp32', tag: '物联网' },
  { id: 4, title: 'ESP32 智能灯控', description: '手机 APP 控制的智能灯光系统', icon: '💡', tags: ['ESP32', '智能家居'], gradient: 'from-green-400 to-emerald-500', platform: 'esp32', tag: '智能家居' },
  { id: 5, title: 'C51 单片机时钟', description: '经典 8051 单片机制作的数字时钟', icon: '🔌', tags: ['C51', '单片机'], gradient: 'from-orange-500 to-red-500', platform: 'c51', tag: '时钟' },
  { id: 6, title: 'C51 计算器', description: '基于 8051 的简易计算器', icon: '🔢', tags: ['C51', '计算器'], gradient: 'from-orange-400 to-red-400', platform: 'c51', tag: '计算器' },
  { id: 7, title: '个人 Portfolio 网站', description: '响应式个人作品集网站', icon: '🌐', tags: ['Vue', 'HTML'], gradient: 'from-blue-500 to-cyan-500', platform: 'web', tag: '作品集' },
  { id: 8, title: '电商后台管理系统', description: 'Vue + Element UI 后台系统', icon: '🛒', tags: ['Vue', '电商'], gradient: 'from-blue-400 to-cyan-400', platform: 'web', tag: '后台管理' },
]

const platform = computed(() => platforms[route.params.platform] || platforms.stm32)

const subPlatforms = computed(() => {
  if (route.params.platform === 'stm32') {
    return Object.values(platforms).filter(p => p.parent === 'stm32')
  }
  return []
})

const projects = computed(() => {
  if (route.params.platform === 'stm32') {
    return []
  }
  if (route.params.platform.startsWith('stm32f')) {
    return allProjects.filter(p => p.platform === route.params.platform)
  }
  return allProjects.filter(p => p.platform === route.params.platform)
})
</script>

<style scoped>
.line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
</style>

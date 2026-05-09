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
    <!-- 项目头部 -->
    <div :class="['rounded-2xl p-8 mb-8', project.gradient]">
      <div class="flex items-center justify-center mb-6">
        <span class="text-8xl">{{ project.icon }}</span>
      </div>
      <div class="flex justify-center mb-4">
        <span class="px-3 py-1 bg-white/20 text-white text-sm rounded-full">
          {{ platformName }}
        </span>
      </div>
      <h1 class="text-3xl md:text-4xl font-bold text-white text-center mb-4">{{ project.title }}</h1>
      <p class="text-white/90 text-center text-lg">{{ project.description }}</p>
      <div class="flex flex-wrap justify-center gap-2 mt-6">
        <span v-for="tag in project.tags" :key="tag" class="px-3 py-1 bg-white/20 text-white text-sm rounded-full">
          {{ tag }}
        </span>
      </div>
    </div>

    <!-- 1. 项目介绍 -->
    <div class="bg-white rounded-xl p-6 mb-6 shadow-sm">
      <h2 class="text-2xl font-bold mb-6 flex items-center">
        <span class="mr-3">📖</span> 项目介绍
      </h2>
      <div class="prose max-w-none text-gray-700">
        <p>{{ project.fullDescription || project.description }}</p>
      </div>
    </div>

    <!-- 2. 项目视频 -->
    <div class="bg-white rounded-xl p-6 mb-6 shadow-sm">
      <h2 class="text-2xl font-bold mb-6 flex items-center">
        <span class="mr-3">🎥</span> 项目视频
      </h2>
      
      <div v-if="project.bvid" class="aspect-video rounded-lg overflow-hidden bg-gray-900">
        <iframe 
          :src="`https://player.bilibili.com/player.html?bvid=${project.bvid}&page=1&as_wide=1&high_quality=1&autoplay=0`"
          class="w-full h-full"
          scrolling="no"
          border="0"
          frameborder="no"
          framespacing="0"
          allowfullscreen="true"
        ></iframe>
      </div>
      <div v-else class="aspect-video rounded-lg overflow-hidden bg-gray-800 flex items-center justify-center">
        <div class="text-center text-gray-400">
          <span class="text-5xl block mb-4">🎬</span>
          <p>暂无视频</p>
          <p class="text-sm mt-2">请联系管理员添加项目视频</p>
        </div>
      </div>
    </div>

    <!-- 3. 项目资料（合并了资料和文档） -->
    <div class="bg-white rounded-xl p-6 mb-6 shadow-sm">
      <h2 class="text-2xl font-bold mb-6 flex items-center">
        <span class="mr-3">📁</span> 项目资料
      </h2>
      
      <!-- 下载文件 -->
      <div v-if="project.files && project.files.length > 0" class="mb-6">
        <h3 class="font-semibold text-gray-700 mb-3 flex items-center">
          <span class="mr-2">⬇️</span> 文件下载
        </h3>
        <div class="space-y-3">
          <div v-for="file in project.files" :key="file.name" class="flex items-center justify-between p-4 border rounded-lg hover:bg-gray-50">
            <div class="flex items-center">
              <span class="text-2xl mr-4">{{ file.icon }}</span>
              <div>
                <h4 class="font-medium">{{ file.name }}</h4>
                <p class="text-sm text-gray-500">{{ file.format }}<span v-if="file.size"> | {{ file.size }}</span></p>
              </div>
            </div>
            <button class="px-4 py-2 bg-purple-600 text-white text-sm rounded-lg hover:bg-purple-700 transition">
              下载
            </button>
          </div>
        </div>
      </div>

      <!-- 文档列表 -->
      <div v-if="project.docs && project.docs.length > 0">
        <h3 class="font-semibold text-gray-700 mb-3 flex items-center">
          <span class="mr-2">📄</span> 相关文档
        </h3>
        <div class="space-y-3">
          <div v-for="doc in project.docs" :key="doc.title" class="p-4 border rounded-lg hover:bg-gray-50 cursor-pointer">
            <div class="flex items-center">
              <span class="text-2xl mr-4">{{ doc.icon }}</span>
              <div>
                <h4 class="font-medium">{{ doc.title }}</h4>
                <p class="text-sm text-gray-500">{{ doc.description }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 空状态 -->
      <div v-if="(!project.files || project.files.length === 0) && (!project.docs || project.docs.length === 0)" class="text-center py-8 text-gray-500">
        暂无资料
      </div>
    </div>

    <!-- 4. 评论区域 -->
    <div class="bg-white rounded-xl p-6 shadow-sm">
      <h2 class="text-2xl font-bold mb-6 flex items-center">
        <span class="mr-3">💬</span> 项目评论
      </h2>
      
      <!-- Giscus 评论系统 -->
      <script src="https://giscus.app/client.js"
        data-repo="greatwallcy/designhub"
        data-repo-id="R_kgDOSXo6gg"
        data-category="General"
        data-category-id="DIC_kwDOSXo6gs4C8lEi"
        data-mapping="pathname"
        data-strict="0"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="top"
        data-theme="light"
        data-lang="zh-CN"
        crossorigin="anonymous"
        async>
      </script>
      
      <div class="text-center py-4 text-gray-500 text-sm">
        使用 GitHub 账号登录后可发表评论
      </div>
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
  stm32: { id: 'stm32', name: 'STM32开发', icon: '🔧' },
  esp32: { id: 'esp32', name: 'ESP32开发', icon: '📡' },
  c51: { id: 'c51', name: 'C51开发', icon: '🔌' },
  web: { id: 'web', name: '网页开发', icon: '🌐' },
}

const allProjects = [
  {
    id: 1,
    title: 'STM32 开发板 v1.2.1',
    description: '自主设计的 STM32F4 系列开发板，包含完整原理图和 PCB 文件',
    fullDescription: '这是一款自主设计的 STM32F4 系列开发板，适用于嵌入式开发学习。开发板提供了丰富的外设接口，包括 GPIO、USART、SPI、I2C、ADC 等，可以满足各种嵌入式开发需求。',
    icon: '🔧',
    tags: ['STM32', 'PCB', '嵌入式'],
    gradient: 'from-purple-600 to-blue-500',
    platform: 'stm32',
    bvid: '',
    files: [
      { name: 'STM32 开发板 v1.2.1 原理图', format: 'PDF', size: '约 2MB', icon: '📄' },
      { name: 'STM32 开发板 v1.2.1 PCB 文件', format: 'Altium PCB', size: '5.5MB', icon: '🔲' }
    ],
    docs: [
      { title: '快速开始指南', description: '开发板使用入门，包含基本操作说明', icon: '📄' },
      { title: '原理图说明', description: '详细原理图讲解', icon: '🔧' }
    ]
  },
  {
    id: 2,
    title: 'STM32 平衡车',
    description: '基于 STM32 的两轮自平衡车项目',
    fullDescription: '这是一个基于 STM32 的两轮自平衡车项目，使用 MPU6050 陀螺仪进行姿态检测，通过 PID 算法实现平衡控制。',
    icon: '🚗',
    tags: ['STM32', '平衡车', '电机控制'],
    gradient: 'from-purple-500 to-indigo-500',
    platform: 'stm32',
    bvid: '',
    files: [],
    docs: []
  },
  {
    id: 3,
    title: 'ESP32 WiFi 气象站',
    description: '基于 ESP32 的物联网气象站，实时监测温湿度',
    fullDescription: '这是一个基于 ESP32 的物联网气象站项目，通过 DHT11 传感器采集温湿度数据，通过 WiFi 上传至云平台，实现远程监控。',
    icon: '📡',
    tags: ['ESP32', '物联网', 'WiFi'],
    gradient: 'from-green-500 to-teal-500',
    platform: 'esp32',
    bvid: '',
    files: [],
    docs: []
  },
  {
    id: 4,
    title: 'ESP32 智能灯控',
    description: '手机 APP 控制的智能灯光系统',
    fullDescription: '基于 ESP32 的智能灯光控制系统，支持手机 APP 远程控制、语音控制、定时开关等功能。',
    icon: '💡',
    tags: ['ESP32', '智能家居', '蓝牙'],
    gradient: 'from-green-400 to-emerald-500',
    platform: 'esp32',
    bvid: '',
    files: [],
    docs: []
  },
  {
    id: 5,
    title: 'C51 单片机时钟',
    description: '经典 8051 单片机制作的数字时钟',
    fullDescription: '使用经典 8051 单片机制作的数字时钟，支持时间显示、闹钟设置、温度显示等功能。',
    icon: '🔌',
    tags: ['C51', '单片机', '时钟'],
    gradient: 'from-orange-500 to-red-500',
    platform: 'c51',
    bvid: '',
    files: [],
    docs: []
  },
  {
    id: 6,
    title: 'C51 计算器',
    description: '基于 8051 的简易计算器',
    fullDescription: '基于 8051 单片机的简易计算器，支持加减乘除四则运算。',
    icon: '🔢',
    tags: ['C51', '单片机', '计算器'],
    gradient: 'from-orange-400 to-red-400',
    platform: 'c51',
    bvid: '',
    files: [],
    docs: []
  },
  {
    id: 7,
    title: '个人 Portfolio 网站',
    description: '响应式个人作品集网站',
    fullDescription: '使用 Vue 3 + TailwindCSS 构建的响应式个人作品集网站，展示个人项目和技能。',
    icon: '🌐',
    tags: ['Vue', 'HTML', 'CSS'],
    gradient: 'from-blue-500 to-cyan-500',
    platform: 'web',
    bvid: '',
    files: [],
    docs: []
  },
  {
    id: 8,
    title: '电商后台管理系统',
    description: 'Vue + Element UI 管理的后台系统',
    fullDescription: '使用 Vue + Element UI 开发的电商后台管理系统，包含商品管理、订单管理、用户管理等模块。',
    icon: '🛒',
    tags: ['Vue', 'Element UI', '电商'],
    gradient: 'from-blue-400 to-cyan-400',
    platform: 'web',
    bvid: '',
    files: [],
    docs: []
  },
]

const project = computed(() => {
  const id = parseInt(route.params.id)
  return allProjects.find(p => p.id === id) || allProjects[0]
})

const platformName = computed(() => {
  return platforms[project.value.platform]?.name || ''
})
</script>

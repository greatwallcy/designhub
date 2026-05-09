<template>
  <div class="p-8">
    <h2 class="text-2xl font-bold mb-6">📂 平台开发</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
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
  </div>
</template>

<script setup>
const platforms = [
  { id: 'stm32', name: 'STM32开发', icon: '🔧', description: 'STM32单片机开发', bgColor: 'bg-purple-100' },
  { id: 'esp32', name: 'ESP32开发', icon: '📡', description: 'ESP32无线通信开发', bgColor: 'bg-blue-100' },
  { id: 'c51', name: 'C51开发', icon: '🔌', description: 'C51单片机开发', bgColor: 'bg-green-100' },
  { id: 'web', name: '网页开发', icon: '🌐', description: '前端与后端开发', bgColor: 'bg-yellow-100' },
]

const projectsData = {
  1: { id: 1, title: 'STM32 开发板 v1.2.1', platform: 'stm32' },
  2: { id: 2, title: 'STM32 平衡车', platform: 'stm32' },
  3: { id: 3, title: 'ESP32 WiFi 气象站', platform: 'esp32' },
  4: { id: 4, title: 'ESP32 智能灯控', platform: 'esp32' },
  5: { id: 5, title: 'C51 单片机时钟', platform: 'c51' },
  6: { id: 6, title: 'C51 计算器', platform: 'c51' },
  7: { id: 7, title: '个人 Portfolio 网站', platform: 'web' },
  8: { id: 8, title: '电商后台管理系统', platform: 'web' },
}

const getProjectCount = (platformId) => {
  return Object.values(projectsData).filter(p => p.platform === platformId).length
}
</script>

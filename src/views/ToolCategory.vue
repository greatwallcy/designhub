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

  <div class="p-8 pt-16">
    <div class="mb-6">
      <h1 class="text-3xl font-bold mb-2">{{ currentTool?.name || '工具分类' }}</h1>
      <p class="text-gray-500">{{ currentTool?.description }}</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <router-link
        v-for="child in currentTool?.children || []"
        :key="child.id"
        :to="`/tool/${toolId}/${child.id}`"
        class="bg-white rounded-xl p-6 shadow-sm hover:shadow-lg transition card-hover border"
      >
        <div class="flex items-center">
          <div class="w-12 h-12 rounded-xl flex items-center justify-center text-2xl mr-4 bg-purple-100">
            📄
          </div>
          <div class="flex-1">
            <h3 class="text-lg font-bold">{{ child.name }}</h3>
          </div>
          <span class="text-purple-600 text-sm">→</span>
        </div>
      </router-link>

      <div v-if="!currentTool?.children?.length" class="col-span-2 bg-white rounded-xl p-8 text-center text-gray-400">
        暂无工具
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const toolId = computed(() => route.params.toolId)

const goBack = () => {
  if (window.history.length > 1) {
    window.history.back()
  } else {
    window.location.href = '/'
  }
}

const toolsMap = {
  'bom': {
    name: 'BOM辅助工具',
    description: 'BOM相关辅助工具',
    children: [
      { id: 'bom-match', name: 'BOM匹配工具' }
    ]
  },
  'ad': {
    name: 'AD辅助工具',
    description: 'Altium Designer辅助工具',
    children: []
  },
  'design': {
    name: '设计工具',
    description: '设计辅助工具',
    children: [
      { id: 'serial', name: '串口助手' }
    ]
  },
  'daily': {
    name: '日常工具',
    description: '日常实用工具',
    children: [
      { id: 'word', name: 'Word文档' },
      { id: 'excel', name: 'Excel表格' },
      { id: 'ppt', name: 'PPT演示' }
    ]
  }
}

const currentTool = computed(() => toolsMap[toolId.value] || { name: '未知', description: '', children: [] })
</script>

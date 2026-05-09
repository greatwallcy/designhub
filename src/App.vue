<template>
  <div class="min-h-screen bg-gray-50">
    <div class="flex">
      <!-- 左侧边栏 -->
      <aside class="w-64 bg-white shadow-lg fixed left-0 top-0 bottom-0 overflow-y-auto hidden md:block">
        <div class="p-6 relative">
          <!-- Logo -->
          <div class="mb-6">
            <router-link to="/" class="text-2xl font-bold bg-gradient-to-r from-purple-600 to-blue-500 bg-clip-text text-transparent">
              DesignHub
            </router-link>
          </div>

          <!-- 作者信息 -->
          <div class="text-center mb-6 pb-6 border-b">
            <div class="w-16 h-16 mx-auto bg-gradient-to-br from-purple-600 to-blue-500 rounded-full flex items-center justify-center text-white text-2xl mb-3">
              👤
            </div>
            <h3 class="font-bold text-sm">GreatWallCY</h3>
            <p class="text-gray-500 text-xs">嵌入式开发 / 网页设计</p>
            <div class="mt-3 space-y-1">
              <a href="https://github.com/greatwallcy" target="_blank" class="flex items-center justify-center text-gray-600 hover:text-purple-600 text-xs transition">
                <span class="mr-1">💻</span> GitHub
              </a>
              <a href="https://space.bilibili.com/403125592" target="_blank" class="flex items-center justify-center text-gray-600 hover:text-purple-600 text-xs transition">
                <span class="mr-1">📺</span> GPS人生导航
              </a>
            </div>
          </div>

          <!-- 搜索框 -->
          <div class="mb-6">
            <div class="relative">
              <input 
                type="text" 
                v-model="searchQuery"
                placeholder="搜索文档/项目/工具..."
                class="w-full px-4 py-2 pl-10 text-sm border rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500"
                @focus="showSearchResults = true"
                @blur="hideSearch"
              />
              <svg class="w-4 h-4 absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
              </svg>
            </div>
            
            <!-- 搜索结果下拉 -->
            <div v-if="showSearchResults && searchQuery && searchResults.length > 0" class="absolute z-50 mt-1 w-64 bg-white rounded-lg shadow-lg border max-h-80 overflow-y-auto">
              <div v-for="(item, idx) in searchResults" :key="idx">
                <div class="px-4 py-2 text-xs text-gray-500 bg-gray-50">{{ item.category }}</div>
                <router-link
                  :to="item.url"
                  class="block px-4 py-2 hover:bg-purple-50 text-sm cursor-pointer"
                  @click="clearSearch"
                >
                  <span class="mr-2">{{ item.icon }}</span>
                  {{ item.name }}
                </router-link>
              </div>
            </div>
            <div v-if="showSearchResults && searchQuery && searchResults.length === 0" class="absolute z-50 mt-1 w-64 bg-white rounded-lg shadow-lg border p-4 text-center text-gray-500 text-sm">
              未找到结果
            </div>
          </div>

          <!-- 快捷目录 -->
          <div class="mb-6">
            <h4 class="font-semibold text-gray-700 mb-3 flex items-center text-sm">
              <span class="mr-2">📑</span> 快捷目录
            </h4>
            <div class="space-y-1">
              <!-- 平台开发 -->
              <router-link 
                to="/platform"
                class="flex items-center px-3 py-2 rounded-lg transition text-sm"
                :class="$route.path === '/platform' || $route.path.startsWith('/platform/') 
                  ? 'bg-purple-600 text-white' 
                  : 'hover:bg-gray-100 text-gray-600'"
              >
                <span class="mr-3 text-lg">📂</span>
                <span>平台开发</span>
              </router-link>

              <!-- 经验文档 -->
              <router-link 
                to="/documents/docs"
                class="flex items-center px-3 py-2 rounded-lg transition text-sm"
                :class="$route.path.startsWith('/documents') 
                  ? 'bg-purple-600 text-white' 
                  : 'hover:bg-gray-100 text-gray-600'"
              >
                <span class="mr-3 text-lg">📖</span>
                <span>经验文档</span>
              </router-link>

              <!-- 实用工具 -->
              <router-link 
                to="/tool"
                class="flex items-center px-3 py-2 rounded-lg transition text-sm"
                :class="$route.path.startsWith('/tool') 
                  ? 'bg-purple-600 text-white' 
                  : 'hover:bg-gray-100 text-gray-600'"
              >
                <span class="mr-3 text-lg">🛠️</span>
                <span>实用工具</span>
              </router-link>
            </div>
          </div>

          <!-- 快捷链接 -->
          <div class="pt-4 border-t">
            <h4 class="font-semibold text-gray-700 mb-3 flex items-center text-sm">
              <span class="mr-2">🔗</span> 快捷链接
            </h4>
            <div class="space-y-1">
              <a href="https://aistudio.xiaomimimo.com/#/" target="_blank" class="flex items-center px-3 py-2 text-gray-600 hover:bg-gray-100 rounded-lg text-sm transition">
                <span class="mr-3">🤖</span> AI Studio
              </a>
              <a href="https://www.szlcsc.com/" target="_blank" class="flex items-center px-3 py-2 text-gray-600 hover:bg-gray-100 rounded-lg text-sm transition">
                <span class="mr-3">🔌</span> 立创商城
              </a>
              <a href="https://www.semiee.com/" target="_blank" class="flex items-center px-3 py-2 text-gray-600 hover:bg-gray-100 rounded-lg text-sm transition">
                <span class="mr-3">📋</span> 半岛小芯
              </a>
            </div>
          </div>
        </div>
      </aside>

      <!-- 主内容区 -->
      <main class="flex-1 md:ml-64">
        <!-- 顶部导航 -->
        <nav class="fixed top-0 right-0 left-0 md:left-64 bg-white/95 backdrop-blur-sm shadow-sm z-40">
          <div class="px-6 py-4 flex items-center">
            <router-link to="/" class="text-gray-600 hover:text-purple-600 transition text-sm flex items-center">
              <span class="mr-1">🏠</span> 首页
            </router-link>
            <span v-if="$route.path.startsWith('/platform')" class="text-gray-400 mx-2">/</span>
            <span v-if="$route.path.startsWith('/platform') && !$route.params.platform" class="text-purple-600 text-sm">
              平台开发
            </span>
            <span v-if="$route.params.platform" class="text-gray-400 mx-2">/</span>
            <span v-if="$route.params.platform" class="text-purple-600 text-sm">
              {{ platformName }}
            </span>
            <span v-if="$route.params.platform && $route.params.id" class="text-gray-400 mx-2">/</span>
            <span v-if="$route.params.id" class="text-gray-600 text-sm">
              {{ projectName }}
            </span>
            <span v-if="$route.path.startsWith('/documents')" class="text-gray-400 mx-2">/</span>
            <span v-if="$route.path.startsWith('/documents')" class="text-purple-600 text-sm">
              {{ docName }}
            </span>
            <span v-if="$route.path.startsWith('/tool')" class="text-gray-400 mx-2">/</span>
            <span v-if="$route.path.startsWith('/tool')" class="text-purple-600 text-sm">
              {{ toolName }}
            </span>
          </div>
        </nav>

        <!-- 页面内容 -->
        <div class="pt-14">
          <router-view />
        </div>

        <!-- 底部 -->
        <footer class="bg-gray-900 text-white py-6 text-center mt-12">
          <p>&copy; {{ currentYear }} DesignHub. All rights reserved.</p>
        </footer>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const currentYear = new Date().getFullYear()

// 搜索相关
const searchQuery = ref('')
const showSearchResults = ref(false)

// 所有可搜索内容
const allItems = [
  // 项目
  { category: '项目', name: 'STM32 开发板 v1.2.1', icon: '🔧', url: '/project/1' },
  { category: '项目', name: 'STM32 平衡车', icon: '🔧', url: '/project/2' },
  { category: '项目', name: 'ESP32 WiFi 气象站', icon: '📡', url: '/project/3' },
  { category: '项目', name: 'ESP32 智能灯控', icon: '📡', url: '/project/4' },
  { category: '项目', name: 'C51 单片机时钟', icon: '🔌', url: '/project/5' },
  { category: '项目', name: 'C51 计算器', icon: '🔌', url: '/project/6' },
  { category: '项目', name: '个人 Portfolio 网站', icon: '🌐', url: '/project/7' },
  { category: '项目', name: '电商后台管理系统', icon: '🌐', url: '/project/8' },
  // 平台
  { category: '平台', name: 'STM32开发', icon: '🔧', url: '/platform/stm32' },
  { category: '平台', name: 'ESP32开发', icon: '📡', url: '/platform/esp32' },
  { category: '平台', name: 'C51开发', icon: '🔌', url: '/platform/c51' },
  { category: '平台', name: '网页开发', icon: '🌐', url: '/platform/web' },
  // 文档
  { category: '文档', name: 'VSCode Continue 配置 MiniMax', icon: '📝', url: '/documents/ai-vscode/vscode-continue-minimax' },
  { category: '文档', name: 'Hermes 完整配置指南', icon: '🤖', url: '/documents/ai-hermes/hermes-guide' },
  { category: '文档', name: 'Hermes 配置文件内容记录', icon: '📄', url: '/documents/ai-hermes/hermes-config-file' },

  { category: '文档', name: 'PCB 设计经验分享', icon: '🔲', url: '/documents/hardware/pcb-design' },
  { category: '文档', name: 'Vue3 项目开发指南', icon: '🌐', url: '/documents/software/vue-guide' },
  { category: '文档', name: '日常实用技巧', icon: '💡', url: '/documents/life/daily-tips' },
  // 工具
  { category: '工具', name: 'BOM匹配工具', icon: '📋', url: '/tool/bom/bom-match' },
  { category: '工具', name: 'Word文档', icon: '📄', url: '/tool/daily/word' },
  { category: '工具', name: 'Excel表格', icon: '📊', url: '/tool/daily/excel' },
  { category: '工具', name: 'PPT演示', icon: '📽️', url: '/tool/daily/ppt' },
  { category: '工具', name: '串口助手', icon: '🔌', url: '/tool/design/serial' },
]

const searchResults = computed(() => {
  if (!searchQuery.value) return []
  const query = searchQuery.value.toLowerCase()
  return allItems.filter(item => 
    item.name.toLowerCase().includes(query)
  ).slice(0, 10) // 最多显示10条
})

const hideSearch = () => {
  setTimeout(() => {
    showSearchResults.value = false
  }, 200)
}

const clearSearch = () => {
  searchQuery.value = ''
  showSearchResults.value = false
}

const platforms = [
  { id: 'stm32', name: 'STM32开发', icon: '🔧' },
  { id: 'esp32', name: 'ESP32开发', icon: '📡' },
  { id: 'c51', name: 'C51开发', icon: '🔌' },
  { id: 'web', name: '网页开发', icon: '🌐' },
]

const mainCategories = [
  { id: 'docs', name: '经验文档', icon: '📖', description: '技术文档与笔记' },
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

const platformName = computed(() => {
  const p = platforms.find(p => p.id === route.params.platform)
  return p ? p.name : ''
})

const projectName = computed(() => {
  if (route.params.id) {
    const p = projectsData[route.params.id]
    return p ? p.title : ''
  }
  return ''
})

const docName = computed(() => {
  if (route.params.docId) {
    return '文档详情'
  } else if (route.path.startsWith('/documents')) {
    return '经验文档'
  }
  return ''
})

const toolName = computed(() => {
  if (route.params.toolDetailId) {
    // 找到具体工具名称
    const toolsMap = {
      'bom': { 'bom-match': 'BOM匹配工具' },
      'daily': { 'word': 'Word文档', 'excel': 'Excel表格', 'ppt': 'PPT演示' }
    }
    const toolChildren = toolsMap[route.params.toolId] || {}
    return toolChildren[route.params.toolDetailId] || '工具详情'
  } else if (route.params.toolId) {
    const names = { 'bom': 'BOM辅助工具', 'ad': 'AD辅助工具', 'design': '设计工具', 'daily': '日常工具' }
    return names[route.params.toolId] || '工具分类'
  } else if (route.path.startsWith('/tool')) {
    return '实用工具'
  }
  return ''
})
</script>

<template>
  <div class="p-8">
    <!-- 二级工具分类（2列布局） -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div
        v-for="tool in tools"
        :key="tool.id"
        class="bg-white rounded-xl p-6 shadow-sm hover:shadow-lg transition card-hover border"
      >
        <router-link
          :to="`/tool/${tool.id}`"
          class="flex items-center justify-between"
        >
          <div class="flex items-center">
            <div :class="['w-16 h-16 rounded-xl flex items-center justify-center text-3xl mr-4', tool.bgColor]">
              {{ tool.icon }}
            </div>
            <div>
              <h3 class="text-xl font-bold">{{ tool.name }}</h3>
              <p class="text-gray-500 text-sm">{{ tool.description }}</p>
            </div>
          </div>
          <div class="flex items-center">
            <span class="text-sm text-gray-500 mr-2">{{ tool.children.length }} 个工具</span>
            <span class="text-purple-600 text-sm">查看 →</span>
          </div>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
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

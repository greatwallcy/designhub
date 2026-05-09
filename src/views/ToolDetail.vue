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
    <div class="mb-6">
      <h1 class="text-3xl font-bold mb-2">📄 {{ toolName }}</h1>
      <p class="text-gray-500">{{ toolDescription }}</p>
    </div>

    <!-- 外部工具（iframe嵌入） -->
    <div v-if="toolData.type === 'external'" class="bg-white rounded-xl shadow-sm border overflow-hidden">
      <iframe
        :src="toolData.url"
        class="w-full h-screen"
        style="min-height: 800px;"
        frameborder="0"
      ></iframe>
    </div>

    <!-- 串口助手 -->
    <div v-else-if="toolData.type === 'serial'" class="bg-white rounded-xl shadow-sm border p-4">
      <SerialPortTool />
    </div>

    <!-- 办公工具 -->
    <div v-else-if="toolData.type === 'office'" class="bg-white rounded-xl shadow-sm border overflow-hidden">
      <!-- 工具栏 -->
      <div class="p-4 border-b flex items-center gap-2 flex-wrap bg-gray-50">
        <button @click="handleNew" class="px-4 py-2 bg-purple-600 text-white rounded-lg text-sm hover:bg-purple-700 flex items-center">
          <span class="mr-1">➕</span> 新建
        </button>
        <button @click="handleOpen" class="px-4 py-2 bg-blue-600 text-white rounded-lg text-sm hover:bg-blue-700 flex items-center">
          <span class="mr-1">📂</span> 打开
        </button>
        <button @click="handleSave" class="px-4 py-2 bg-green-600 text-white rounded-lg text-sm hover:bg-green-700 flex items-center">
          <span class="mr-1">💾</span> 保存
        </button>
        <button @click="handleDownload" class="px-4 py-2 bg-orange-600 text-white rounded-lg text-sm hover:bg-orange-700 flex items-center">
          <span class="mr-1">📥</span> 下载
        </button>
        <input type="file" ref="fileInput" @change="handleFileOpen" :accept="fileAccept" class="hidden" />
        
        <span class="ml-auto text-sm text-gray-500">{{ currentFileName }}</span>
      </div>

      <!-- Word 编辑器 -->
      <div v-if="toolData.officeType === 'word'" class="p-6">
        <div contenteditable="true" 
             ref="wordEditor" 
             class="min-h-[600px] outline-none prose max-w-none"
             @input="markDirty"
        ></div>
      </div>

      <!-- Excel 编辑器 -->
      <div v-else-if="toolData.officeType === 'excel'" class="p-4">
        <div class="mb-4 flex items-center gap-2">
          <span class="text-sm text-gray-600">当前工作表:</span>
          <input type="text" v-model="currentSheetName" class="px-3 py-1 border rounded text-sm" />
          <button @click="addSheet" class="px-3 py-1 bg-gray-100 rounded text-sm hover:bg-gray-200">➕ 添加工作表</button>
        </div>
        <div class="overflow-auto border rounded">
          <table class="w-full border-collapse">
            <thead>
              <tr>
                <th class="w-12 bg-gray-100 border p-2 text-left text-xs text-gray-500">#</th>
                <th v-for="col in maxCols" :key="col" class="w-24 bg-gray-100 border p-2 text-center text-xs text-gray-500">
                  {{ String.fromCharCode(64 + col) }}
                </th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in maxRows" :key="row">
                <td class="bg-gray-100 border p-2 text-center text-xs text-gray-500">{{ row }}</td>
                <td v-for="col in maxCols" :key="col" class="border p-1">
                  <input 
                    type="text" 
                    v-model="excelData[row - 1][col - 1]"
                    class="w-full p-1 outline-none text-sm"
                    @input="markDirty"
                    @paste="handlePaste($event, row - 1, col - 1)"
                  />
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- PPT 编辑器 -->
      <div v-else-if="toolData.officeType === 'ppt'" class="p-4">
        <!-- 幻灯片缩略图 -->
        <div class="flex gap-4">
          <div class="w-48 border rounded bg-gray-50 p-2">
            <div class="text-xs text-gray-500 mb-2">幻灯片列表</div>
            <div class="space-y-2">
              <div 
                v-for="(slide, idx) in slides" 
                :key="idx"
                @click="currentSlide = idx"
                :class="['p-2 border rounded cursor-pointer text-sm text-center', currentSlide === idx ? 'border-purple-500 bg-purple-50' : 'hover:bg-gray-100']"
              >
                幻灯片 {{ idx + 1 }}
              </div>
              <button @click="addSlide" class="w-full p-2 border border-dashed rounded text-sm text-gray-500 hover:bg-gray-100">
                ➕ 添加
              </button>
            </div>
          </div>
          
          <!-- 编辑区域 -->
          <div class="flex-1">
            <div class="border rounded bg-white p-4" style="min-height: 450px;">
              <textarea
                v-model="slides[currentSlide].content"
                class="w-full h-80 p-4 outline-none resize-none text-lg"
                placeholder="输入幻灯片内容..."
                @input="markDirty"
              ></textarea>
            </div>
            <div class="mt-4 flex items-center gap-4">
              <label class="text-sm text-gray-600">背景颜色:</label>
              <input type="color" v-model="slides[currentSlide].bgColor" @change="markDirty" class="w-10 h-8 rounded cursor-pointer" />
              <label class="text-sm text-gray-600 ml-4">字体大小:</label>
              <select v-model="slides[currentSlide].fontSize" @change="markDirty" class="px-2 py-1 border rounded text-sm">
                <option value="24px">24px</option>
                <option value="32px">32px</option>
                <option value="48px">48px</option>
                <option value="64px">64px</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 其他工具 -->
    <div v-else class="bg-white rounded-xl shadow-sm border p-8 text-center text-gray-500">
      <p>即将推出...</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import SerialPortTool from './Tools/SerialPort.vue'

const route = useRoute()

const goBack = () => {
  if (window.history.length > 1) {
    window.history.back()
  } else {
    window.location.href = '/'
  }
}

const wordEditor = ref(null)
const fileInput = ref(null)
const isDirty = ref(false)
const currentFileName = ref('未命名')

const toolsData = {
  'bom-bom-match': {
    name: 'BOM匹配工具',
    description: '通过上传物料主数据和原理图BOM进行智能匹配',
    type: 'external',
    url: 'https://greatwallcy.github.io/designhub-bom/'
  },
  'daily-word': {
    name: 'Word文档',
    description: '新建、编辑、下载Word文档',
    type: 'office',
    officeType: 'word'
  },
  'daily-excel': {
    name: 'Excel表格',
    description: '新建、编辑、下载Excel表格',
    type: 'office',
    officeType: 'excel'
  },
  'daily-ppt': {
    name: 'PPT工具',
    description: '新建、编辑、下载PPT演示文稿',
    type: 'office',
    officeType: 'ppt'
  },
  'design-serial': {
    name: '串口助手',
    description: 'Web Serial API 串口调试工具',
    type: 'serial'
  }
}

const toolKey = computed(() => `${route.params.toolId}-${route.params.toolDetailId}`)
const toolData = computed(() => toolsData[toolKey.value] || {})
const toolName = computed(() => toolData.value.name || '工具')
const toolDescription = computed(() => toolData.value.description || '')
const fileAccept = computed(() => {
  if (toolData.value.officeType === 'word') return '.doc,.docx,.txt'
  if (toolData.value.officeType === 'excel') return '.xlsx,.xls,.csv'
  if (toolData.value.officeType === 'ppt') return '.ppt,.pptx'
  return '*'
})

// Excel data
const maxRows = 20
const maxCols = 10
const excelData = ref(
  Array.from({ length: maxRows }, () => Array(maxCols).fill(''))
)
const currentSheetName = ref('Sheet1')

// PPT data
const slides = ref([
  { content: '欢迎使用PPT工具', bgColor: '#ffffff', fontSize: '48px' }
])
const currentSlide = ref(0)

const markDirty = () => {
  isDirty.value = true
}

const handleNew = () => {
  if (isDirty.value && !confirm('当前有未保存的更改，确定要新建吗？')) return
  
  if (toolData.value.officeType === 'word' && wordEditor.value) {
    wordEditor.value.innerHTML = ''
  } else if (toolData.value.officeType === 'excel') {
    excelData.value = Array.from({ length: maxRows }, () => Array(maxCols).fill(''))
    currentSheetName.value = 'Sheet1'
  } else if (toolData.value.officeType === 'ppt') {
    slides.value = [{ content: '新幻灯片', bgColor: '#ffffff', fontSize: '48px' }]
    currentSlide.value = 0
  }
  currentFileName.value = '未命名'
  isDirty.value = false
}

const handleOpen = () => {
  fileInput.value.click()
}

const handleFileOpen = (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  currentFileName.value = file.name
  const reader = new FileReader()
  
  if (toolData.value.officeType === 'word') {
    reader.onload = (e) => {
      if (wordEditor.value) {
        wordEditor.value.innerHTML = e.target.result
        isDirty.value = false
      }
    }
    reader.readAsText(file)
  } else if (toolData.value.officeType === 'excel') {
    // 使用 SheetJS 解析 Excel
    const script = document.createElement('script')
    script.src = 'https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js'
    script.onload = () => {
      const data = new Uint8Array(e.target.result)
      const workbook = XLSX.read(data, { type: 'array' })
      const sheetName = workbook.SheetNames[0]
      const worksheet = workbook.Sheets[sheetName]
      const json = XLSX.utils.sheet_to_json(worksheet, { header: 1, defval: '' })
      
      excelData.value = Array.from({ length: maxRows }, (_, i) => 
        Array(maxCols).fill('').map((_, j) => (json[i] && json[i][j]) ? String(json[i][j]) : '')
      )
      isDirty.value = false
    }
    document.head.appendChild(script)
    reader.readAsArrayBuffer(file)
  } else if (toolData.value.officeType === 'ppt') {
    reader.onload = (e) => {
      // 简单的PPT解析（实际生产需要更复杂的库）
      slides.value = [{ content: e.target.result, bgColor: '#ffffff', fontSize: '48px' }]
      currentSlide.value = 0
      isDirty.value = false
    }
    reader.readAsText(file)
  }
}

const addSheet = () => {
  currentSheetName.value = '新工作表'
  excelData.value = Array.from({ length: maxRows }, () => Array(maxCols).fill(''))
}

const handlePaste = (event, row, col) => {
  event.preventDefault()
  const clipboardData = event.clipboardData.getData('text')
  if (!clipboardData) return
  
  // 按换行分割成行
  const rows = clipboardData.split('\n').filter(line => line.trim())
  
  rows.forEach((rowData, i) => {
    // 按制表符分割成列
    const cells = rowData.split('\t')
    cells.forEach((cell, j) => {
      const targetRow = row + i
      const targetCol = col + j
      if (targetRow < maxRows && targetCol < maxCols) {
        excelData.value[targetRow][targetCol] = cell.trim()
      }
    })
  })
  markDirty()
}

const addSlide = () => {
  slides.value.push({ content: '新幻灯片', bgColor: '#ffffff', fontSize: '48px' })
  currentSlide.value = slides.value.length - 1
  markDirty()
}

const handleSave = () => {
  // 保存到本地存储
  const data = {
    type: toolData.value.officeType,
    fileName: currentFileName.value,
    content: toolData.value.officeType === 'word' ? wordEditor.value?.innerHTML :
            toolData.value.officeType === 'excel' ? JSON.stringify(excelData.value) :
            toolData.value.officeType === 'ppt' ? JSON.stringify(slides.value) : '',
    sheetName: currentSheetName.value
  }
  localStorage.setItem('office_temp_' + toolData.value.officeType, JSON.stringify(data))
  isDirty.value = false
  alert('已保存到浏览器临时存储')
}

const handleDownload = () => {
  if (toolData.value.officeType === 'word') {
    downloadWord()
  } else if (toolData.value.officeType === 'excel') {
    downloadExcel()
  } else if (toolData.value.officeType === 'ppt') {
    downloadPpt()
  }
}

const downloadWord = () => {
  if (!wordEditor.value) return
  const content = wordEditor.value.innerHTML
  const blob = new Blob(['\ufeff', content], { type: 'application/msword' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = (currentFileName.value === '未命名' ? '文档' : currentFileName.value.replace(/\.[^.]+$/, '')) + '.doc'
  a.click()
  URL.revokeObjectURL(url)
  isDirty.value = false
}

const downloadExcel = () => {
  // 动态加载 SheetJS
  if (typeof XLSX === 'undefined') {
    const script = document.createElement('script')
    script.src = 'https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js'
    script.onload = () => doDownloadExcel()
    document.head.appendChild(script)
  } else {
    doDownloadExcel()
  }
  
  function doDownloadExcel() {
    const wsData = excelData.value.filter(row => row.some(cell => cell !== ''))
    const ws = XLSX.utils.aoa_to_sheet(wsData)
    const wb = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(wb, ws, currentSheetName.value || 'Sheet1')
    const wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'array' })
    const blob = new Blob([wbout], { type: 'application/octet-stream' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = (currentFileName.value === '未命名' ? '表格' : currentFileName.value.replace(/\.[^.]+$/, '')) + '.xlsx'
    a.click()
    URL.revokeObjectURL(url)
    isDirty.value = false
  }
}

const downloadPpt = () => {
  // 简单的 HTML 转 PPT（实际生产需要更复杂的库如 PptxGenJS）
  const content = slides.value.map((slide, i) => `
    <div style="page-break-after: always; padding: 40px; background: ${slide.bgColor}; min-height: 500px;">
      <div style="font-size: ${slide.fontSize}; text-align: center; padding-top: 150px;">
        ${slide.content}
      </div>
    </div>
  `).join('')
  
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>${currentFileName.value}</title>
      <style>
        body { margin: 0; }
        div { page-break-after: always; }
      </style>
    </head>
    <body>
      ${content}
    </body>
    </html>
  `
  
  const blob = new Blob([html], { type: 'application/vnd.ms-powerpoint' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = (currentFileName.value === '未命名' ? '演示文稿' : currentFileName.value.replace(/\.[^.]+$/, '')) + '.ppt'
  a.click()
  URL.revokeObjectURL(url)
  isDirty.value = false
}

onMounted(() => {
  // 从本地存储恢复数据
  const saved = localStorage.getItem('office_temp_' + toolData.value.officeType)
  if (saved) {
    try {
      const data = JSON.parse(saved)
      currentFileName.value = data.fileName || '未命名'
      
      if (toolData.value.officeType === 'word' && wordEditor.value) {
        wordEditor.value.innerHTML = data.content || ''
      } else if (toolData.value.officeType === 'excel') {
        const parsed = JSON.parse(data.content)
        excelData.value = parsed
        currentSheetName.value = data.sheetName || 'Sheet1'
      } else if (toolData.value.officeType === 'ppt') {
        slides.value = JSON.parse(data.content)
      }
    } catch (e) {
      console.log('恢复数据失败')
    }
  }
})
</script>

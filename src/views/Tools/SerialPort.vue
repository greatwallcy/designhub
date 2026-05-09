<template>
  <div class="p-4">
    <div class="mb-4">
      <h1 class="text-2xl font-bold mb-2">🔌 串口助手</h1>
      <p class="text-gray-500 text-sm">Web Serial API 串口调试工具（需使用Chrome/Edge浏览器）</p>
    </div>

    <!-- 连接设置 -->
    <div class="bg-white rounded-xl shadow-sm border p-4 mb-4">
      <div class="flex flex-wrap items-center gap-4">
        <!-- 串口选择 -->
        <div class="flex items-center">
          <label class="text-sm text-gray-600 mr-2">串口:</label>
          <button 
            @click="requestPort"
            class="px-3 py-2 bg-blue-600 text-white rounded-lg text-sm hover:bg-blue-700"
          >
            选择串口
          </button>
        </div>
        
        <select v-model="selectedPort" class="px-3 py-2 border rounded-lg text-sm flex-1 min-w-[200px]">
          <option value="">请先选择串口...</option>
          <option v-for="port in ports" :key="port" :value="port">{{ port }}</option>
        </select>

        <!-- 波特率 -->
        <div class="flex items-center">
          <label class="text-sm text-gray-600 mr-2">波特率:</label>
          <select v-model="baudRate" class="px-3 py-2 border rounded-lg text-sm">
            <option value="9600">9600</option>
            <option value="19200">19200</option>
            <option value="38400">38400</option>
            <option value="57600">57600</option>
            <option value="115200">115200</option>
            <option value="460800">460800</option>
          </select>
        </div>

        <!-- 数据位 -->
        <div class="flex items-center">
          <label class="text-sm text-gray-600 mr-2">数据位:</label>
          <select v-model="dataBits" class="px-3 py-2 border rounded-lg text-sm">
            <option value="7">7</option>
            <option value="8">8</option>
          </select>
        </div>

        <!-- 停止位 -->
        <div class="flex items-center">
          <label class="text-sm text-gray-600 mr-2">停止位:</label>
          <select v-model="stopBits" class="px-3 py-2 border rounded-lg text-sm">
            <option value="1">1</option>
            <option value="2">2</option>
          </select>
        </div>

        <!-- 校验位 -->
        <div class="flex items-center">
          <label class="text-sm text-gray-600 mr-2">校验:</label>
          <select v-model="parity" class="px-3 py-2 border rounded-lg text-sm">
            <option value="none">无</option>
            <option value="even">偶</option>
            <option value="odd">奇</option>
          </select>
        </div>

        <!-- 连接按钮 -->
        <button 
          v-if="!isConnected"
          @click="connect"
          :disabled="!selectedPort"
          class="px-4 py-2 bg-green-600 text-white rounded-lg text-sm hover:bg-green-700 disabled:bg-gray-400"
        >
          连接
        </button>
        <button 
          v-else
          @click="disconnect"
          class="px-4 py-2 bg-red-600 text-white rounded-lg text-sm hover:bg-red-700"
        >
          断开
        </button>
      </div>
      
      <!-- 连接状态 -->
      <div class="mt-3 flex items-center">
        <span class="text-sm text-gray-500 mr-2">状态:</span>
        <span :class="isConnected ? 'text-green-600' : 'text-gray-400'" class="text-sm font-medium">
          {{ isConnected ? '● 已连接 ' + selectedPort : '○ 未连接' }}
        </span>
      </div>
    </div>

    <!-- 发送区域 -->
    <div class="bg-white rounded-xl shadow-sm border p-4 mb-4">
      <div class="flex items-center justify-between mb-3">
        <h3 class="font-bold">发送</h3>
        <div class="flex items-center gap-4">
          <label class="flex items-center text-sm">
            <input type="radio" v-model="sendFormat" value="str" class="mr-1"> 字符串
          </label>
          <label class="flex items-center text-sm">
            <input type="radio" v-model="sendFormat" value="hex" class="mr-1"> HEX
          </label>
          <label class="flex items-center text-sm">
            <input type="checkbox" v-model="sendNewline" class="mr-1"> 换行
          </label>
        </div>
      </div>
      <div class="flex gap-2">
        <textarea 
          v-model="sendText" 
          class="flex-1 p-3 border rounded-lg text-sm font-mono h-20 resize-none"
          placeholder="输入发送内容..."
          @keydown.ctrl.enter="send"
        ></textarea>
        <button 
          @click="send"
          :disabled="!isConnected || !sendText"
          class="px-6 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 disabled:bg-gray-400"
        >
          发送
        </button>
      </div>
      <div class="mt-2 text-xs text-gray-400">
        提示: Ctrl+Enter 快捷发送
      </div>
    </div>

    <!-- 接收区域 -->
    <div class="bg-white rounded-xl shadow-sm border p-4">
      <div class="flex items-center justify-between mb-3">
        <h3 class="font-bold">接收</h3>
        <div class="flex items-center gap-4">
          <label class="flex items-center text-sm">
            <input type="radio" v-model="recvFormat" value="str" class="mr-1"> 字符串
          </label>
          <label class="flex items-center text-sm">
            <input type="radio" v-model="recvFormat" value="hex" class="mr-1"> HEX
          </label>
          <button @click="clearRecv" class="px-3 py-1 bg-gray-100 rounded text-sm hover:bg-gray-200">
            清空
          </button>
        </div>
      </div>
      <div class="border rounded-lg p-3 h-64 overflow-auto bg-gray-50 font-mono text-sm" ref="recvArea">
        <div v-if="receivedData.length === 0" class="text-gray-400 text-center py-8">
          暂无数据...
        </div>
        <div v-for="(item, idx) in receivedData" :key="idx" class="mb-1" :class="item.type === 'recv' ? 'text-green-600' : 'text-blue-600'">
          <span class="text-gray-400 text-xs">[{{ item.time }}]</span>
          <span v-if="item.type === 'recv'"> ← </span>
          <span v-else> → </span>
          <span>{{ item.data }}</span>
        </div>
      </div>
      <div class="mt-2 flex items-center justify-between text-xs text-gray-400">
        <span>接收: {{ recvCount }} 字节 | 发送: {{ sendCount }} 字节</span>
        <span>自动滚动: <input type="checkbox" v-model="autoScroll" class="ml-1"></span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, nextTick, onMounted, onUnmounted } from 'vue'

const ports = ref([])
const selectedPort = ref('')
const isConnected = ref(false)
const baudRate = ref('115200')
const dataBits = ref(8)
const stopBits = ref(1)
const parity = ref('none')

const sendText = ref('')
const sendFormat = ref('str')
const sendNewline = ref(true)

const recvFormat = ref('str')
const receivedData = ref([])
const recvCount = ref(0)
const sendCount = ref(0)
const autoScroll = ref(true)

const recvArea = ref(null)
let reader = null
let port = null
let portPath = ''

// 检查浏览器是否支持 Web Serial API
const isSerialSupported = () => {
  return 'serial' in navigator
}

const requestPort = async () => {
  if (!isSerialSupported()) {
    alert('您的浏览器不支持 Web Serial API，请使用 Chrome 或 Edge 浏览器！')
    return
  }
  
  try {
    // 请求用户选择一个串口
    port = await navigator.serial.requestPort()
    await port.open({
      baudRate: parseInt(baudRate.value),
      dataBits: parseInt(dataBits.value),
      stopBits: parseInt(stopBits.value),
      parity: parity.value
    })
    
    // 获取端口信息
    const info = port.getInfo()
    portPath = info.usbVendorId ? `USB设备 (VID:${info.usbVendorId.toString(16)} PID:${info.usbProductId?.toString(16)})` : '未知设备'
    
    ports.value = [portPath]
    selectedPort.value = portPath
    isConnected.value = true
    
    receivedData.value.push({
      type: 'system',
      data: '连接成功！',
      time: new Date().toLocaleTimeString()
    })
    
    // 开始读取
    readData()
  } catch (e) {
    if (e.name !== 'NotFoundError') {
      alert('选择串口失败: ' + e.message)
    }
  }
}

const refreshPorts = async () => {
  if (!isSerialSupported()) {
    ports.value = []
    return
  }
  
  try {
    // 获取已授权的端口
    const serialPorts = await navigator.serial.getPorts()
    ports.value = serialPorts.map((p, i) => {
      const info = p.getInfo()
      return info.usbVendorId ? `USB设备 ${i + 1}` : `串口 ${i + 1}`
    })
  } catch (e) {
    console.error(e)
  }
}

const connect = async () => {
  if (!selectedPort.value || !port) {
    alert('请先选择串口！')
    return
  }
  
  try {
    await port.open({
      baudRate: parseInt(baudRate.value),
      dataBits: parseInt(dataBits.value),
      stopBits: parseInt(stopBits.value),
      parity: parity.value
    })
    
    isConnected.value = true
    
    receivedData.value.push({
      type: 'system',
      data: '连接成功！',
      time: new Date().toLocaleTimeString()
    })
    
    // 开始读取
    readData()
  } catch (e) {
    alert('连接失败: ' + e.message)
  }
}

const disconnect = async () => {
  try {
    isConnected.value = false
    
    // 先取消读取
    if (reader) {
      reader.cancel()
      reader.releaseLock()
      reader = null
    }
    
    // 等待一小段时间让读取循环退出
    await new Promise(resolve => setTimeout(resolve, 100))
    
    // 再关闭端口
    if (port) {
      await port.close()
      port = null
    }
    
    ports.value = []
    selectedPort.value = ''
    
    receivedData.value.push({
      type: 'system',
      data: '已断开',
      time: new Date().toLocaleTimeString()
    })
  } catch (e) {
    console.error('断开错误:', e)
    receivedData.value.push({
      type: 'system',
      data: '断开完成',
      time: new Date().toLocaleTimeString()
    })
  }
}

const readData = async () => {
  while (port && port.readable) {
    reader = port.readable.getReader()
    try {
      while (true) {
        const { value, done } = await reader.read()
        if (done) break
        
        let text = ''
        if (recvFormat.value === 'hex') {
          text = Array.from(value).map(b => b.toString(16).padStart(2, '0').toUpperCase()).join(' ')
        } else {
          text = new TextDecoder().decode(value)
        }
        
        recvCount.value += value.length
        receivedData.value.push({
          type: 'recv',
          data: text,
          time: new Date().toLocaleTimeString()
        })
        
        if (autoScroll.value) {
          await nextTick()
          if (recvArea.value) {
            recvArea.value.scrollTop = recvArea.value.scrollHeight
          }
        }
      }
    } catch (e) {
      console.error(e)
    } finally {
      reader.releaseLock()
    }
  }
}

const send = async () => {
  if (!port || !sendText.value) return
  
  try {
    const writer = port.writable.getWriter()
    let data
    
    if (sendFormat.value === 'hex') {
      // HEX 模式
      const hexStr = sendText.value.replace(/\s/g, '')
      const match = hexStr.match(/.{1,2}/g)
      if (!match) {
        alert('HEX格式错误，请输入正确的十六进制数')
        writer.releaseLock()
        return
      }
      data = new Uint8Array(match.map(b => parseInt(b, 16)))
    } else {
      // 字符串模式
      let text = sendText.value
      if (sendNewline.value) {
        text += '\r\n'
      }
      data = new TextEncoder().encode(text)
    }
    
    await writer.write(data)
    sendCount.value += data.length
    
    // 显示发送的数据
    let displayText = sendFormat.value === 'hex' 
      ? Array.from(data).map(b => b.toString(16).padStart(2, '0').toUpperCase()).join(' ')
      : new TextDecoder().decode(data)
    
    receivedData.value.push({
      type: 'send',
      data: displayText,
      time: new Date().toLocaleTimeString()
    })
    
    if (autoScroll.value) {
      await nextTick()
      if (recvArea.value) {
        recvArea.value.scrollTop = recvArea.value.scrollHeight
      }
    }
    
    writer.releaseLock()
  } catch (e) {
    alert('发送失败: ' + e.message)
  }
}

const clearRecv = () => {
  receivedData.value = []
  recvCount.value = 0
  sendCount.value = 0
}

onMounted(() => {
  if (isSerialSupported()) {
    refreshPorts()
  } else {
    alert('您的浏览器不支持 Web Serial API，请使用 Chrome 或 Edge 浏览器！')
  }
})

onUnmounted(() => {
  disconnect()
})
</script>

<style scoped>
textarea {
  font-family: 'Consolas', 'Monaco', monospace;
}
</style>

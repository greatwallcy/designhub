import { createRouter, createWebHashHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Platform from '../views/Platform.vue'
import PlatformHome from '../views/PlatformHome.vue'
import ProjectDetail from '../views/ProjectDetail.vue'
import DocumentDetail from '../views/DocumentDetail.vue'
import DocumentList from '../views/DocumentList.vue'
import ToolList from '../views/ToolList.vue'
import ToolCategory from '../views/ToolCategory.vue'
import ToolDetail from '../views/ToolDetail.vue'
import SerialPort from '../views/Tools/SerialPort.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/platform',
    name: 'PlatformHome',
    component: PlatformHome
  },
  {
    path: '/platform/:platform',
    name: 'Platform',
    component: Platform
  },
  {
    path: '/project/:id',
    name: 'ProjectDetail',
    component: ProjectDetail
  },
  {
    path: '/documents/:type',
    name: 'DocumentList',
    component: DocumentList
  },
  {
    path: '/documents/:type/:category',
    name: 'DocumentCategory',
    component: DocumentList
  },
  {
    path: '/documents/:type/:category/:docId',
    name: 'DocumentDetail',
    component: DocumentDetail
  },
  {
    path: '/tool',
    name: 'ToolList',
    component: ToolList
  },
  {
    path: '/tool/:toolId',
    name: 'ToolCategory',
    component: ToolCategory
  },
  {
    path: '/tool/:toolId/:toolDetailId',
    name: 'ToolDetail',
    component: ToolDetail
  },
  {
    path: '/tool/design/serial',
    name: 'SerialPort',
    component: SerialPort
  }
]

const router = createRouter({
  history: createWebHashHistory('/designhub/'),
  routes
})

export default router

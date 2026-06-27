import auth from '@/plugins/auth'
import router, { baseRoutes, readerRoutes, constantRoutes, dynamicRoutes } from '@/router'
import { getRouters } from '@/api/menu'
import Layout from '@/layout/index'
import ParentView from '@/components/ParentView'
import InnerLink from '@/layout/components/InnerLink'

// 匹配views里面所有的.vue文件
const modules = import.meta.glob('./../../views/**/*.vue')
const flattenRootPaths = ['/system', '/library/admin']
const mergedAccountPaths = ['/system/user', '/system/role', '/library/admin/readers']
const accountRoute = {
  path: '/library/admin/accounts',
  name: 'AdminAccountsMenu',
  meta: { title: '账号管理', icon: 'peoples' }
}

function getClientSidebarRoutes(roles = []) {
  const roleList = Array.isArray(roles) ? roles : []
  const isAdmin = roleList.includes('admin')
  const isReader = roleList.includes('reader')
  return isReader && !isAdmin ? baseRoutes.concat(readerRoutes) : baseRoutes
}

function buildAdminMenuRoutes(routes = []) {
  return sortAdminRoutes(mergeAccountRoutes(promoteLoginLogRoutes(flattenMenuGroups(routes))))
}

function flattenMenuGroups(routes = []) {
  const result = []
  routes.forEach(route => {
    if (shouldFlattenMenuGroup(route)) {
      const basePath = normalizePath(route.path)
      ;(route.children || []).forEach(child => {
        result.push({
          ...child,
          path: joinPath(basePath, child.path)
        })
      })
    } else {
      result.push(route)
    }
  })
  return result
}

function shouldFlattenMenuGroup(route) {
  return flattenRootPaths.includes(normalizePath(route.path))
}

function mergeAccountRoutes(routes = []) {
  const result = []
  let accountInserted = false
  routes.forEach(route => {
    if (isMergedAccountRoute(route)) {
      if (!accountInserted) {
        result.push({ ...accountRoute })
        accountInserted = true
      }
      return
    }
    result.push(route)
  })
  return result
}

function promoteLoginLogRoutes(routes = []) {
  const result = []
  routes.forEach(route => {
    const path = normalizePath(route.path)
    if (path === '/system/log' || path === '/log') {
      const loginRoute = (route.children || []).find(child => normalizePath(child.path).endsWith('/logininfor') || child.path === 'logininfor')
      if (loginRoute) {
        result.push({
          ...loginRoute,
          path: joinPath(path, loginRoute.path),
          meta: { ...(loginRoute.meta || {}), title: '登录日志', icon: 'logininfor' }
        })
      }
      return
    }
    if (path.endsWith('/operlog')) {
      return
    }
    result.push(route)
  })
  return result
}

function sortAdminRoutes(routes = []) {
  const order = new Map([
    ['/library/admin/overview', 10],
    ['/library/admin/books', 20],
    ['/library/admin/orders', 30],
    ['/library/admin/queues', 40],
    ['/library/admin/accounts', 50],
    ['/library/admin/rules', 60],
    ['/system/log/logininfor', 70],
    ['/log/logininfor', 70],
    ['/logininfor', 70]
  ])
  return routes.slice().sort((a, b) => {
    const ai = order.get(normalizePath(a.path)) ?? 999
    const bi = order.get(normalizePath(b.path)) ?? 999
    return ai - bi
  })
}

function isMergedAccountRoute(route) {
  return mergedAccountPaths.includes(normalizePath(route.path))
}

function normalizePath(path = '') {
  if (!path) {
    return ''
  }
  if (/^(https?:|mailto:|tel:)/.test(path)) {
    return path
  }
  const withLeadingSlash = path.startsWith('/') ? path : `/${path}`
  return withLeadingSlash.replace(/\/+/g, '/')
}

function joinPath(basePath, routePath) {
  if (/^(https?:|mailto:|tel:)/.test(routePath) || (routePath || '').startsWith('/')) {
    return routePath
  }
  return `${basePath}/${routePath || ''}`.replace(/\/+/g, '/')
}

const usePermissionStore = defineStore(
  'permission',
  {
    state: () => ({
      routes: [],
      addRoutes: [],
      defaultRoutes: [],
      topbarRouters: [],
      sidebarRouters: []
    }),
    actions: {
      setRoutes(routes) {
        this.addRoutes = routes
        this.routes = constantRoutes.concat(routes)
      },
      setDefaultRoutes(routes) {
        this.defaultRoutes = routes
      },
      setTopbarRoutes(routes) {
        this.topbarRouters = routes
      },
      setSidebarRouters(routes) {
        this.sidebarRouters = routes
      },
      generateRoutes(roles = []) {
        return new Promise(resolve => {
          // 向后端请求路由数据
          getRouters().then(res => {
            const sdata = JSON.parse(JSON.stringify(res.data))
            const rdata = JSON.parse(JSON.stringify(res.data))
            const defaultData = JSON.parse(JSON.stringify(res.data))
            const sidebarRoutes = buildAdminMenuRoutes(filterAsyncRouter(sdata))
            const rewriteRoutes = filterAsyncRouter(rdata, false, true)
            const defaultRoutes = buildAdminMenuRoutes(filterAsyncRouter(defaultData))
            const asyncRoutes = filterDynamicRoutes(dynamicRoutes)
            const clientSidebarRoutes = getClientSidebarRoutes(roles)
            asyncRoutes.forEach(route => { router.addRoute(route) })
            this.setRoutes(rewriteRoutes)
            this.setSidebarRouters(clientSidebarRoutes.concat(sidebarRoutes))
            this.setDefaultRoutes(clientSidebarRoutes.concat(sidebarRoutes))
            this.setTopbarRoutes(defaultRoutes)
            resolve(rewriteRoutes)
          })
        })
      }
    }
  })

// 遍历后台传来的路由字符串，转换为组件对象
function filterAsyncRouter(asyncRouterMap, lastRouter = false, type = false) {
  return asyncRouterMap.filter(route => {
    if (type && route.children) {
      route.children = filterChildren(route.children)
    }
    if (route.component) {
      // Layout ParentView 组件特殊处理
      if (route.component === 'Layout') {
        route.component = Layout
      } else if (route.component === 'ParentView') {
        route.component = ParentView
      } else if (route.component === 'InnerLink') {
        route.component = InnerLink
      } else {
        route.component = loadView(route.component)
      }
    }
    if (route.children != null && route.children && route.children.length) {
      route.children = filterAsyncRouter(route.children, route, type)
      if (route.name && route.children.some(child => child.name === route.name)) {
        delete route['name']
      }
    } else {
      delete route['children']
      delete route['redirect']
    }
    return true
  })
}

function filterChildren(childrenMap, lastRouter = false) {
  var children = []
  childrenMap.forEach(el => {
    el.path = lastRouter ? lastRouter.path + '/' + el.path : el.path
    if (el.children && el.children.length && el.component === 'ParentView') {
      children = children.concat(filterChildren(el.children, el))
    } else {
      children.push(el)
    }
  })
  return children
}

// 动态路由遍历，验证是否具备权限
export function filterDynamicRoutes(routes) {
  const res = []
  routes.forEach(route => {
    if (route.permissions) {
      if (auth.hasPermiOr(route.permissions)) {
        res.push(route)
      }
    } else if (route.roles) {
      if (auth.hasRoleOr(route.roles)) {
        res.push(route)
      }
    } else {
      res.push(route)
    }
  })
  return res
}

export const loadView = (view) => {
  let res
  for (const path in modules) {
    const dir = path.split('views/')[1].split('.vue')[0]
    if (dir === view) {
      res = () => modules[path]()
    }
  }
  return res
}

export default usePermissionStore

import defaultSettings from '@/settings'
import useSettingsStore from '@/store/modules/settings'
import useUserStore from '@/store/modules/user'

/**
 * 动态修改标题
 */
export function useDynamicTitle() {
  const settingsStore = useSettingsStore()
  const userStore = useUserStore()
  
  // 根据用户角色确定基础标题
  let baseTitle = defaultSettings.title
  if (userStore.roles && userStore.roles.includes('admin')) {
    baseTitle = '后台管理中心'
  }
  
  if (settingsStore.dynamicTitle) {
    document.title = settingsStore.title + ' - ' + baseTitle
  } else {
    document.title = baseTitle
  }
}
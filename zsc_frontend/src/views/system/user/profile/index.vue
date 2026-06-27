<template>
  <div class="app-container profile-page">
    <el-card class="profile-card" shadow="always">
      <div class="profile-shell">
        <div class="profile-summary">
          <div class="avatar-area">
            <userAvatar />
          </div>
          <div class="summary-main">
            <div class="summary-title">
              <span>{{ state.user.nickName || state.user.userName || '-' }}</span>
              <el-tag type="success" effect="light">{{ state.roleGroup || '未配置角色' }}</el-tag>
            </div>
            <div class="summary-grid">
              <div class="summary-item">
                <span class="label">登录账号</span>
                <span class="value">{{ state.user.userName || '-' }}</span>
              </div>
              <div class="summary-item">
                <span class="label">联系电话</span>
                <span class="value">{{ state.user.phonenumber || '-' }}</span>
              </div>
              <div class="summary-item">
                <span class="label">用户邮箱</span>
                <span class="value">{{ state.user.email || '-' }}</span>
              </div>
              <div class="summary-item">
                <span class="label">创建日期</span>
                <span class="value">{{ formatDate(state.user.createTime) }}</span>
              </div>
            </div>
          </div>
        </div>

        <el-tabs v-model="selectedTab" class="profile-tabs">
          <el-tab-pane label="基本资料" name="userinfo">
            <userInfo :user="state.user" />
          </el-tab-pane>
          <el-tab-pane label="修改密码" name="resetPwd">
            <resetPwd />
          </el-tab-pane>
        </el-tabs>
      </div>
    </el-card>
  </div>
</template>

<script setup name="Profile">
import userAvatar from "./userAvatar"
import userInfo from "./userInfo"
import resetPwd from "./resetPwd"
import { getUserProfile } from "@/api/system/user"

const { proxy } = getCurrentInstance()
const route = useRoute()
const selectedTab = ref("userinfo")
const state = reactive({
  user: {},
  roleGroup: ''
})

function formatDate(value) {
  return value ? proxy.parseTime(value, '{y}-{m}-{d}') : '-'
}

function getUser() {
  getUserProfile().then(response => {
    state.user = response.data || {}
    state.roleGroup = response.roleGroup || ''
  })
}

onMounted(() => {
  const activeTab = route.params && route.params.activeTab
  if (activeTab) {
    selectedTab.value = activeTab
  }
  getUser()
})
</script>

<style scoped lang="scss">
.profile-page {
  .profile-card {
    width: 100%;
  }

  .profile-shell {
    display: grid;
    gap: 20px;
  }

  .profile-summary {
    display: grid;
    grid-template-columns: 160px minmax(0, 1fr);
    gap: 24px;
    align-items: center;
    padding-bottom: 18px;
    border-bottom: 1px solid #ebeef5;
  }

  .avatar-area {
    display: flex;
    justify-content: center;
  }

  .summary-main {
    min-width: 0;
  }

  .summary-title {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 16px;
    font-size: 22px;
    font-weight: 700;
    color: #1f2d3d;
  }

  .summary-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 12px;
  }

  .summary-item {
    min-width: 0;
    padding: 12px 14px;
    border: 1px solid #edf1f7;
    border-radius: 6px;
    background: #fafcff;
  }

  .label,
  .value {
    display: block;
  }

  .label {
    margin-bottom: 6px;
    color: #8c97a8;
    font-size: 13px;
  }

  .value {
    color: #334155;
    font-weight: 600;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .profile-tabs {
    :deep(.el-tabs__content) {
      max-width: 860px;
      padding-top: 10px;
    }
  }

  @media (max-width: 1200px) {
    .summary-grid {
      grid-template-columns: repeat(2, minmax(0, 1fr));
    }
  }

  @media (max-width: 768px) {
    .profile-summary {
      grid-template-columns: 1fr;
    }

    .summary-grid {
      grid-template-columns: 1fr;
    }
  }
}
</style>

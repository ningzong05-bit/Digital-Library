<template>
  <div class="app-container reader-profile">
    <el-alert
      v-if="!readerId && profileLoadFailed"
      title="未能加载读者资料，请确认当前账号为读者账号"
      type="warning"
      :closable="false"
      show-icon
      class="profile-alert"
    />

    <el-row :gutter="16" type="flex" class="profile-overview">
      <el-col :xs="24" :lg="12">
        <el-card class="profile-card account-card" shadow="always">
          <template #header>
            <div class="card-header">
              <span class="card-title">个人中心</span>
              <el-button type="primary" link icon="Refresh" @click="refreshAll">刷新</el-button>
            </div>
          </template>

          <div class="account-summary">
            <div class="avatar-wrap">
              <userAvatar />
            </div>
            <div class="account-info">
              <div class="account-name-row">
                <span class="account-name">{{ account.user.nickName || account.user.userName || '-' }}</span>
                <el-tag type="success" effect="light" size="small">{{ account.roleGroup || '读者' }}</el-tag>
              </div>
              <div class="account-list">
                <div class="account-item">
                  <span>登录账号</span>
                  <strong>{{ account.user.userName || '-' }}</strong>
                </div>
                <div class="account-item">
                  <span>联系电话</span>
                  <strong>{{ account.user.phonenumber || '-' }}</strong>
                </div>
                <div class="account-item">
                  <span>用户邮箱</span>
                  <strong>{{ account.user.email || '-' }}</strong>
                </div>
                <div class="account-item">
                  <span>创建日期</span>
                  <strong>{{ formatDate(account.user.createTime) }}</strong>
                </div>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="24" :lg="12">
        <el-card class="profile-card reader-card" shadow="always">
          <template #header>
            <div class="card-header">
              <span class="card-title">读者权益</span>
              <el-button type="primary" link icon="Wallet" :disabled="!readerId" @click="openRecharge">充值押金</el-button>
            </div>
          </template>

          <div class="reader-summary-grid">
            <div class="metric-item">
              <span>读者姓名</span>
              <strong>{{ profile?.readerName || '-' }}</strong>
            </div>
            <div class="metric-item">
              <span>联系电话</span>
              <strong>{{ profile?.mobile || '-' }}</strong>
            </div>
            <div class="metric-item">
              <span>所在城市</span>
              <strong>{{ profile?.city || '-' }}</strong>
            </div>
            <div class="metric-item">
              <span>读者状态</span>
              <el-tag :type="profile?.status === 'NORMAL' ? 'success' : 'danger'" size="small" effect="light">
                {{ profile?.status === 'NORMAL' ? '正常' : '停用' }}
              </el-tag>
            </div>
            <div class="metric-item">
              <span>押金余额</span>
              <strong>{{ money(profile?.depositBalance) }}</strong>
            </div>
            <div class="metric-item">
              <span>冻结押金</span>
              <strong>{{ money(profile?.depositFrozen) }}</strong>
            </div>
            <div class="metric-item">
              <span>年费到期</span>
              <strong>{{ formatDate(profile?.annualExpireDate) }}</strong>
            </div>
            <div class="metric-item">
              <span>可借数量</span>
              <strong>{{ profile?.maxBorrowCount ?? '-' }} 本</strong>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-card class="profile-card center-card" shadow="always">
      <el-tabs v-model="activeTab" class="profile-tabs">
        <el-tab-pane label="基本资料" name="userinfo">
          <div class="tab-panel narrow-panel">
            <userInfo :user="account.user" />
          </div>
        </el-tab-pane>

        <el-tab-pane label="修改密码" name="resetPwd">
          <div class="tab-panel narrow-panel">
            <resetPwd />
          </div>
        </el-tab-pane>

        <el-tab-pane label="借阅数据" name="readerStats">
          <div class="tab-panel">
            <el-descriptions :column="2" border>
              <el-descriptions-item label="年度寄出">{{ profile?.usedOutboundCount || 0 }} / {{ profile?.maxOutboundCount || 0 }} 次</el-descriptions-item>
              <el-descriptions-item label="年度寄回">{{ profile?.usedInboundCount || 0 }} / {{ profile?.maxInboundCount || 0 }} 次</el-descriptions-item>
              <el-descriptions-item label="进行中订单">{{ summary?.activeOrders ?? '-' }} 单</el-descriptions-item>
              <el-descriptions-item label="排队中">{{ summary?.waitingQueues ?? '-' }} 条</el-descriptions-item>
              <el-descriptions-item label="历史借阅">{{ summary?.totalOrders ?? '-' }} 单</el-descriptions-item>
              <el-descriptions-item label="已归还">{{ summary?.returnedOrders ?? '-' }} 单</el-descriptions-item>
            </el-descriptions>
          </div>
        </el-tab-pane>

        <el-tab-pane label="收货地址" name="addresses">
          <div class="tab-panel">
            <div class="address-toolbar">
              <span class="address-tip">最多维护 5 个收货地址</span>
              <el-button type="primary" icon="Plus" plain :disabled="addresses.length >= 5" @click="openAddressDialog()">新增地址</el-button>
            </div>
            <el-table :data="addresses" v-loading="addrLoading">
              <el-table-column prop="addressId" label="ID" width="80" align="center" />
              <el-table-column prop="receiverName" label="收件人" width="120" />
              <el-table-column prop="receiverMobile" label="联系电话" width="130" />
              <el-table-column prop="city" label="城市" width="100" />
              <el-table-column prop="district" label="区县" width="100" />
              <el-table-column prop="detailAddress" label="详细地址" min-width="220" show-overflow-tooltip />
              <el-table-column prop="defaultFlag" label="默认" width="80" align="center">
                <template #default="{ row }">
                  <el-tag :type="row.defaultFlag === 1 ? 'success' : 'info'">{{ row.defaultFlag === 1 ? '是' : '否' }}</el-tag>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="150" align="center">
                <template #default="{ row }">
                  <div class="row-actions">
                    <el-button link type="primary" icon="Edit" @click="openAddressDialog(row)">编辑</el-button>
                    <el-button link type="danger" icon="Delete" @click="handleDeleteAddress(row)">删除</el-button>
                  </div>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-card>

    <el-dialog v-model="addrDialog.open" title="维护收货地址" width="560px" append-to-body>
      <el-form ref="addrFormRef" :model="addrForm" :rules="addrRules" label-width="110px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="收件人" prop="receiverName">
              <el-input v-model="addrForm.receiverName" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话">
              <el-input v-model="addrForm.receiverMobile" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="城市" prop="city">
              <el-input v-model="addrForm.city" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="区县">
              <el-input v-model="addrForm.district" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="详细地址" prop="detailAddress">
              <el-input v-model="addrForm.detailAddress" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="设为默认">
              <el-switch v-model="addrDefault" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button @click="addrDialog.open = false">取消</el-button>
        <el-button type="primary" @click="submitAddress">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="rechargeDialog.open" title="充值押金" width="420px" append-to-body>
      <el-form ref="rechargeFormRef" :model="rechargeForm" :rules="rechargeRules" label-width="92px">
        <el-form-item label="充值金额" prop="amount">
          <el-input
            v-model="rechargeForm.amount"
            placeholder="请输入充值金额"
            clearable
            @input="onRechargeAmountInput"
            style="width: 100%"
          >
            <template #append>元</template>
          </el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="rechargeDialog.open = false">取消</el-button>
        <el-button type="primary" @click="submitRecharge">充值</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="ReaderProfile">
import { getCurrentInstance, onMounted, reactive, ref } from 'vue'
import { getUserProfile } from '@/api/system/user'
import { deleteAddress, getOrCreateReader, getReader, getReaderAddresses, getReaderSummary, payFee, saveAddress } from '@/api/library'
import useUserStore from '@/store/modules/user'
import userAvatar from '@/views/system/user/profile/userAvatar'
import userInfo from '@/views/system/user/profile/userInfo'
import resetPwd from '@/views/system/user/profile/resetPwd'

const { proxy } = getCurrentInstance()
const userStore = useUserStore()

const activeTab = ref('userinfo')
const readerId = ref(undefined)
const profile = ref(null)
const profileLoadFailed = ref(false)
const summary = ref(null)
const addresses = ref([])
const addrLoading = ref(false)
const addrDefault = ref(true)

const account = reactive({
  user: {},
  roleGroup: ''
})

const addrDialog = reactive({ open: false })
const rechargeDialog = reactive({ open: false })
const addrFormRef = ref(null)
const rechargeFormRef = ref(null)

const addrForm = reactive({
  addressId: undefined,
  readerId: undefined,
  receiverName: undefined,
  receiverMobile: undefined,
  city: undefined,
  district: undefined,
  detailAddress: undefined,
  defaultFlag: 1,
  status: 'ENABLED'
})

const addrRules = {
  receiverName: [{ required: true, message: '收件人不能为空', trigger: 'blur' }],
  city: [{ required: true, message: '城市不能为空', trigger: 'blur' }],
  detailAddress: [{ required: true, message: '详细地址不能为空', trigger: 'blur' }]
}

const rechargeForm = reactive({
  amount: '199'
})

const rechargeRules = {
  amount: [
    { required: true, message: '请输入充值金额', trigger: 'blur' },
    {
      validator: (_rule, value, callback) => {
        /^[1-9]\d*$/.test(String(value || '')) ? callback() : callback(new Error('充值金额必须为正整数'))
      },
      trigger: ['blur', 'change']
    }
  ]
}

function formatDate(value) {
  return value ? proxy.parseTime(value, '{y}-{m}-{d}') : '-'
}

function money(value) {
  return `￥ ${Number(value || 0).toFixed(2)}`
}

function cleanPayload(data) {
  return Object.fromEntries(Object.entries(data).filter(([, v]) => v !== undefined && v !== null && v !== ''))
}

function loadAccount() {
  return getUserProfile().then(response => {
    account.user = response.data || {}
    account.roleGroup = response.roleGroup || ''
  })
}

function loadProfile() {
  if (!readerId.value) return Promise.resolve()
  return getReader(readerId.value).then(res => {
    profile.value = res.data || {}
  }).catch(() => {
    profileLoadFailed.value = true
    proxy.$modal.msgError('未找到该读者信息')
  })
}

function loadAddresses() {
  if (!readerId.value) return Promise.resolve()
  addrLoading.value = true
  return getReaderAddresses(readerId.value).then(res => {
    addresses.value = res.data || []
  }).finally(() => {
    addrLoading.value = false
  })
}

function loadSummary() {
  if (!readerId.value) return Promise.resolve()
  return getReaderSummary(readerId.value).then(res => {
    summary.value = res.data || {}
  }).catch(() => {})
}

function loadReader() {
  const userId = userStore.id
  const readerName = userStore.nickName || undefined
  if (!userId) return Promise.resolve()
  profileLoadFailed.value = false
  return getOrCreateReader(userId, readerName).then(res => {
    readerId.value = res.data?.readerId
    return Promise.all([loadProfile(), loadSummary(), loadAddresses()])
  }).catch(() => {
    profileLoadFailed.value = true
  })
}

function refreshAll() {
  loadAccount()
  loadReader()
}

onMounted(() => {
  refreshAll()
})

function openAddressDialog(row) {
  if (row?.addressId) {
    addrForm.addressId = row.addressId
    addrForm.readerId = row.readerId
    addrForm.receiverName = row.receiverName
    addrForm.receiverMobile = row.receiverMobile
    addrForm.city = row.city
    addrForm.district = row.district
    addrForm.detailAddress = row.detailAddress
    addrForm.defaultFlag = row.defaultFlag
    addrForm.status = row.status
    addrDefault.value = row.defaultFlag === 1
  } else {
    if (addresses.value.length >= 5) {
      proxy.$modal.msgWarning('每位读者最多只能维护 5 个收货地址')
      return
    }
    addrForm.addressId = undefined
    addrForm.readerId = readerId.value
    addrForm.receiverName = profile.value?.readerName || account.user.nickName || undefined
    addrForm.receiverMobile = profile.value?.mobile || account.user.phonenumber || undefined
    addrForm.city = profile.value?.city || undefined
    addrForm.district = undefined
    addrForm.detailAddress = undefined
    addrForm.defaultFlag = 1
    addrForm.status = 'ENABLED'
    addrDefault.value = true
  }
  addrDialog.open = true
}

function handleDeleteAddress(row) {
  proxy.$modal.confirm(`确认删除地址"${row.detailAddress}"？`).then(() => {
    deleteAddress(row.addressId).then(() => {
      proxy.$modal.msgSuccess('删除成功')
      loadAddresses()
    })
  }).catch(() => {})
}

function submitAddress() {
  addrFormRef.value.validate(valid => {
    if (!valid) return
    addrForm.defaultFlag = addrDefault.value ? 1 : 0
    saveAddress(cleanPayload(addrForm)).then(() => {
      proxy.$modal.msgSuccess('地址保存成功')
      addrDialog.open = false
      loadAddresses()
    })
  })
}

function openRecharge() {
  rechargeForm.amount = '199'
  rechargeDialog.open = true
}

function onRechargeAmountInput(value) {
  rechargeForm.amount = String(value || '').replace(/\D/g, '')
}

function submitRecharge() {
  rechargeFormRef.value.validate(valid => {
    if (!valid || !readerId.value) return
    payFee({
      readerId: readerId.value,
      feeType: 'DEPOSIT_RECHARGE',
      amount: Number(rechargeForm.amount || 0),
      payMethod: 'TEST',
      remark: '读者自助押金充值'
    }).then(() => {
      proxy.$modal.msgSuccess('押金充值成功')
      rechargeDialog.open = false
      loadProfile()
      loadSummary()
    })
  })
}
</script>

<style scoped lang="scss">
.reader-profile {
  .profile-alert {
    margin-bottom: 16px;
  }

  .profile-overview {
    margin-bottom: 16px;

    > .el-col {
      display: flex;
    }
  }

  .profile-card {
    border-radius: 6px;
    flex: 1;
    display: flex;
    flex-direction: column;

    :deep(.el-card__body) {
      flex: 1;
      display: flex;
      flex-direction: column;
    }
  }

  .card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  .card-title {
    font-weight: 700;
    color: var(--el-text-color-primary);
  }

  .account-summary {
    display: flex;
    align-items: center;
    gap: 20px;
    flex: 1;
  }

  .avatar-wrap {
    flex-shrink: 0;
    height: 80px;
    margin-top: -6px;

    :deep(.user-info-head) {
      height: 80px;
    }

    :deep(.img-lg) {
      width: 80px;
      height: 80px;
    }
  }

  .account-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 8px;
    margin-top: -6px;
  }

  .account-name-row {
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .account-name {
    color: var(--el-text-color-primary);
    font-size: 18px;
    font-weight: 700;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .account-list {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
    flex: 1;
  }

  .account-item {
    display: grid;
    grid-template-columns: 72px minmax(0, 1fr);
    gap: 8px;
    align-items: center;
    padding: 12px 14px;
    border: 1px solid var(--el-border-color-lighter);
    border-radius: 6px;
    background: var(--el-fill-color-lighter);
    font-size: 14px;

    span {
      color: var(--el-text-color-secondary);
    }

    strong {
      color: var(--el-text-color-primary);
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
  }

  .reader-summary-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 8px;
    flex: 1;
  }

  .metric-item {
    display: grid;
    grid-template-columns: 64px minmax(0, 1fr);
    gap: 8px;
    align-items: center;
    padding: 8px 10px;
    border: 1px solid var(--el-border-color-lighter);
    border-radius: 6px;
    background: var(--el-fill-color-lighter);

    span {
      color: var(--el-text-color-secondary);
      font-size: 13px;
    }

    strong {
      min-width: 0;
      color: var(--el-text-color-primary);
      font-size: 14px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .el-tag {
      width: fit-content;
    }
  }

  .center-card {
    min-height: 320px;
  }

  .profile-tabs {
    :deep(.el-tabs__content) {
      padding-top: 8px;
    }
  }

  .tab-panel {
    padding: 4px 0 8px;
  }

  .narrow-panel {
    max-width: 760px;
  }

  .address-toolbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 12px;
  }

  .address-tip {
    color: var(--el-text-color-secondary);
  }

  .row-actions {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    white-space: nowrap;
  }

  .row-actions :deep(.el-button + .el-button) {
    margin-left: 0;
  }

  @media (max-width: 1200px) {
    .account-list {
      grid-template-columns: 1fr;
    }

    .reader-summary-grid {
      grid-template-columns: 1fr;
    }
  }

  @media (max-width: 768px) {
    .account-summary {
      flex-direction: column;
      align-items: center;
    }

    .account-list {
      grid-template-columns: 1fr;
    }

    .reader-summary-grid {
      grid-template-columns: 1fr;
    }

    .address-toolbar {
      align-items: stretch;
      flex-direction: column;
    }
  }
}
</style>

<template>
  <div class="app-container admin-overview">
    <el-row :gutter="16" class="summary-row">
      <el-col :xs="12" :sm="12" :md="6" v-for="card in summaryCards" :key="card.label">
        <el-card shadow="always" class="summary-card">
          <div class="summary-label">{{ card.label }}</div>
          <div class="summary-value">{{ card.value }}</div>
          <div class="summary-sub">{{ card.sub }}</div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="16" class="overview-row">
      <el-col :xs="24">
        <el-card shadow="always" class="overview-card">
          <template #header>
            <div class="card-header">
              <span>当前借阅规则</span>
              <el-button type="primary" link @click="$router.push('/library/admin/rules')">维护规则</el-button>
            </div>
          </template>
          <el-descriptions :column="2" border>
            <el-descriptions-item label="服务城市">{{ ruleForm.libraryCity || '-' }}</el-descriptions-item>
            <el-descriptions-item label="外借天数">{{ ruleForm.maxLoanDays || '-' }} 天</el-descriptions-item>
            <el-descriptions-item label="年费">{{ money(ruleForm.annualFee) }}</el-descriptions-item>
            <el-descriptions-item label="押金标准">{{ money(ruleForm.depositAmount) }}</el-descriptions-item>
            <el-descriptions-item label="年度寄出">{{ ruleForm.annualOutboundLimit ?? '-' }} 次</el-descriptions-item>
            <el-descriptions-item label="年度寄回">{{ ruleForm.annualInboundLimit ?? '-' }} 次</el-descriptions-item>
            <el-descriptions-item label="逾期/天">{{ money(ruleForm.overdueFeePerDay) }}</el-descriptions-item>
            <el-descriptions-item label="最大在借">{{ ruleForm.maxBorrowCount ?? '-' }} 本</el-descriptions-item>
          </el-descriptions>
        </el-card>
      </el-col>
      <el-col :xs="24">
        <el-card shadow="always" class="overview-card pending-card">
          <template #header>
            <div class="card-header">
              <span>待处理订单</span>
              <el-button type="primary" link @click="$router.push('/library/admin/orders')">查看所有订单</el-button>
            </div>
          </template>
          <el-table :data="orderList">
            <el-table-column prop="orderNo" label="订单号" min-width="150" show-overflow-tooltip />
            <el-table-column prop="borrowType" label="取书方式" width="100">
              <template #default="{ row }">
                <el-tag :type="tagType('borrowType', row.borrowType)">{{ labelOf('borrowType', row.borrowType) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="orderStatus" label="状态" width="110">
              <template #default="{ row }">
                <el-tag :type="tagType('orderStatus', row.orderStatus)">{{ labelOf('orderStatus', row.orderStatus) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="dueDate" label="应还日期" width="150">
              <template #default="{ row }">{{ formatTime(row.dueDate) }}</template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="AdminOverview">
import { computed, getCurrentInstance, onMounted, reactive, ref } from 'vue'
import { getActiveRule, queryBooks, queryOrders, queryQueues, queryReaders } from '@/api/library'

const { proxy } = getCurrentInstance()

const statusOptions = [
  { value: 'ENABLED', label: '启用', type: 'success' },
  { value: 'NORMAL', label: '正常', type: 'success' },
  { value: 'DISABLED', label: '停用', type: 'danger' }
]
const borrowTypeOptions = [
  { value: 'SELF_PICKUP', label: '到馆自取', type: 'success' },
  { value: 'LIBRARY_SHIP', label: '馆方邮寄', type: 'warning' }
]
const orderStatusOptions = [
  { value: 'WAIT_PICKUP', label: '待自取', type: 'warning' },
  { value: 'WAIT_SHIP', label: '待寄出', type: 'warning' },
  { value: 'BORROWING', label: '借阅中', type: 'success' },
  { value: 'RETURNING', label: '归还中', type: 'primary' },
  { value: 'RETURNED', label: '已归还', type: 'info' },
  { value: 'COMPENSATION_PENDING', label: '待赔偿', type: 'danger' }
]
const optionMap = {
  status: statusOptions,
  borrowType: borrowTypeOptions,
  orderStatus: orderStatusOptions
}

const bookList = ref([])
const readerList = ref([])
const orderList = ref([])
const queueList = ref([])
const bookTotal = ref(0)
const readerTotal = ref(0)
const orderTotal = ref(0)
const pendingOrderTotal = ref(0)
const queueTotal = ref(0)

const ruleForm = reactive({
  libraryCity: undefined, maxLoanDays: undefined, annualFee: undefined, depositAmount: undefined,
  annualOutboundLimit: undefined, annualInboundLimit: undefined, overdueFeePerDay: undefined, maxBorrowCount: undefined
})

const summaryCards = computed(() => [
  { label: '图书总数', value: bookTotal.value, sub: `可借 ${bookList.value.reduce((sum, item) => sum + Number(item.availableCount || 0), 0)} 本` },
  { label: '读者数量', value: readerTotal.value, sub: `押金合计 ${money(readerList.value.reduce((sum, item) => sum + Number(item.depositBalance || 0), 0))}` },
  { label: '借阅订单', value: orderTotal.value, sub: `待处理 ${pendingOrderTotal.value} 单` },
  { label: '排队记录', value: queueTotal.value, sub: `排队中 ${queueList.value.filter(item => item.queueStatus === 'WAITING').length} 条` }
])

function labelOf(type, value) {
  const item = (optionMap[type] || []).find(o => o.value === value)
  return item ? item.label : (value || '-')
}

function tagType(type, value) {
  const item = (optionMap[type] || []).find(o => o.value === value)
  return item ? item.type : ''
}

function formatTime(value) { return value ? proxy.parseTime(value, '{y}-{m}-{d}') : '-' }

function money(value) { return `￥${Number(value || 0).toFixed(2)}` }

function loadBooks() {
  return queryBooks({ pageNum: 1, pageSize: 100 }).then(res => {
    bookList.value = res.data?.list || []
    bookTotal.value = Number(res.data?.total || 0)
  })
}

function loadReaders() {
  return queryReaders({ pageNum: 1, pageSize: 100 }).then(res => {
    readerList.value = res.data?.list || []
    readerTotal.value = Number(res.data?.total || 0)
  })
}

function loadOrders() {
  return Promise.all([
    queryOrders({ pageNum: 1, pageSize: 1 }),
    queryOrders({ pageNum: 1, pageSize: 6, pendingOnly: true })
  ]).then(([allRes, pendingRes]) => {
    orderTotal.value = Number(allRes.data?.total || 0)
    orderList.value = pendingRes.data?.list || []
    pendingOrderTotal.value = Number(pendingRes.data?.total || 0)
  })
}

function loadQueues() {
  return queryQueues({ pageNum: 1, pageSize: 100 }).then(res => {
    queueList.value = res.data?.list || []
    queueTotal.value = Number(res.data?.total || 0)
  })
}

function loadRule() {
  getActiveRule().then(res => {
    Object.assign(ruleForm, res.data || {})
  }).catch(() => {})
}

onMounted(() => {
  Promise.allSettled([loadBooks(), loadReaders(), loadOrders(), loadQueues(), loadRule()])
})
</script>

<style scoped lang="scss">
.admin-overview {
  .summary-row { margin-bottom: 16px; }

  .overview-row {
    align-items: stretch;
  }

  .overview-row :deep(.el-col) {
    display: flex;
    margin-bottom: 16px;
  }

  .overview-card {
    width: 100%;
  }

  .pending-card {
    min-height: 360px;
  }

  .overview-card :deep(.el-card__body) {
    padding: 14px 18px 18px;
  }

  .summary-card {
    margin-bottom: 16px;

    .summary-label { color: #606266; font-size: 13px; }
    .summary-value { color: #303133; font-size: 28px; font-weight: 600; line-height: 42px; }
    .summary-sub { color: #909399; font-size: 12px; }
  }

  .card-header { display: flex; align-items: center; justify-content: space-between; font-weight: 600; }
}
</style>

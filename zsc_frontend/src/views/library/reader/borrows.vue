<template>
  <div class="app-container reader-borrows">
    <el-form :inline="true" label-width="100px" class="query-form">
      <el-form-item label="联系电话">
        <el-input v-model="readerContact" placeholder="登录后自动识别" disabled style="width: 220px" />
      </el-form-item>
      <el-form-item label="状态">
        <el-select v-model="statusFilter" placeholder="全部" clearable style="width: 150px">
          <el-option v-for="item in orderStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery" :disabled="!readerId">查询</el-button>
        <el-button icon="Refresh" @click="resetQuery" :disabled="!readerId">重置</el-button>
      </el-form-item>
    </el-form>

    <el-alert
      v-if="!readerId"
      title="登录后将按您的联系电话自动加载借阅记录"
      type="info"
      :closable="false"
      show-icon
      style="margin-bottom: 16px"
    />

    <el-table v-loading="loading" :data="list">
      <el-table-column prop="orderNo" label="订单号" min-width="170" align="left" header-align="left" show-overflow-tooltip />
      <el-table-column prop="bookId" label="图书ID" width="90" align="center" header-align="center" />
      <el-table-column prop="borrowType" label="取书方式" width="110" align="center" header-align="center">
        <template #default="{ row }">
          <el-tag :type="tagType('borrowType', row.borrowType)">{{ labelOf('borrowType', row.borrowType) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="returnType" label="还书方式" width="110" align="center" header-align="center">
        <template #default="{ row }">{{ labelOf('returnType', row.returnType) }}</template>
      </el-table-column>
      <el-table-column prop="orderStatus" label="状态" width="120" align="center" header-align="center">
        <template #default="{ row }">
          <el-tag :type="tagType('orderStatus', row.orderStatus)">{{ labelOf('orderStatus', row.orderStatus) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="开始/应还/实还" width="160" align="center" header-align="center">
        <template #default="{ row }">
          <div class="date-line">{{ formatDate(row.startDate) }}</div>
          <div class="date-line">{{ formatDate(row.dueDate) }}</div>
          <div class="date-line">{{ formatDate(row.libraryReceiveDate) }}</div>
        </template>
      </el-table-column>
      <el-table-column prop="overdueFlag" label="逾期" width="80" align="center" header-align="center">
        <template #default="{ row }">
          <el-tag :type="row.overdueFlag === 1 ? 'danger' : 'success'">{{ row.overdueFlag === 1 ? '是' : '否' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="赔偿" width="100" align="left" header-align="center">
        <template #default="{ row }">{{ money(row.compensationAmount) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="150" fixed="right" align="center" header-align="center">
        <template #default="{ row }">
          <el-button
            v-if="row.orderStatus === 'BORROWING'"
            link
            type="warning"
            icon="Back"
            @click="openReturn(row)"
          >
            我要还书
          </el-button>
          <el-button
            v-else-if="row.orderStatus === 'COMPENSATION_PENDING'"
            link
            type="primary"
            icon="Wallet"
            @click="openPayDialog(row)"
          >
            付款
          </el-button>
          <span v-else-if="row.orderStatus === 'RETURNED'" class="muted">订单已结束</span>
          <span v-else class="muted">-</span>
        </template>
      </el-table-column>
    </el-table>
    <pagination
      v-show="total > 0"
      :total="total"
      :page="query.pageNum"
      :limit="query.pageSize"
      layout="total, prev, pager, next, jumper"
      @update:page="query.pageNum = $event"
      @pagination="getList"
    />

    <!-- 还书对话框 -->
    <el-dialog v-model="returnDialog.open" title="发起还书" width="520px" append-to-body>
      <el-form ref="returnFormRef" :model="returnForm" :rules="returnRules" label-width="110px">
        <el-form-item label="订单ID" prop="orderId">
          <el-input-number v-model="returnForm.orderId" :min="1" controls-position="right" style="width: 100%" />
        </el-form-item>
        <el-form-item label="还书方式" prop="returnType">
          <el-radio-group v-model="returnForm.returnType">
            <el-radio value="LIBRARY_RETURN">到馆还书</el-radio>
            <el-radio value="USER_SHIP">邮寄到图书馆</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="寄出日期" v-if="returnForm.returnType === 'USER_SHIP'">
          <el-date-picker v-model="returnForm.userShipBackDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
        </el-form-item>
        <el-form-item label="物流单号" v-if="returnForm.returnType === 'USER_SHIP'">
          <el-input v-model="returnForm.trackingNo" />
        </el-form-item>
        <el-form-item label="承运方" v-if="returnForm.returnType === 'USER_SHIP'">
          <el-input v-model="returnForm.carrierName" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="returnForm.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="returnDialog.open = false">取消</el-button>
        <el-button type="primary" @click="submitReturn">确定还书</el-button>
      </template>
    </el-dialog>

    <!-- 赔偿付款对话框 -->
    <el-dialog v-model="payDialog.open" title="赔偿付款" width="460px" append-to-body>
      <el-descriptions :column="1" border>
        <el-descriptions-item label="订单号">{{ payForm.orderNo || '-' }}</el-descriptions-item>
        <el-descriptions-item label="赔偿金额">{{ money(payForm.compensationAmount) }}</el-descriptions-item>
        <el-descriptions-item label="支付方式">押金赔偿</el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="payDialog.open = false">取消</el-button>
        <el-button @click="goRecharge">充值押金</el-button>
        <el-button type="primary" @click="submitPay">确认付款</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="ReaderBorrows">
import { getCurrentInstance, onMounted, reactive, ref } from 'vue'
import { getOrCreateReader, payCompensation, queryOrders, requestReturn } from '@/api/library'
import useUserStore from '@/store/modules/user'

const { proxy } = getCurrentInstance()
const userStore = useUserStore()

const borrowTypeOptions = [
  { value: 'SELF_PICKUP', label: '到馆自取', type: 'success' },
  { value: 'LIBRARY_SHIP', label: '馆方邮寄', type: 'warning' }
]
const returnTypeOptions = [
  { value: 'LIBRARY_RETURN', label: '到馆还书', type: 'success' },
  { value: 'USER_SHIP', label: '读者邮寄', type: 'warning' }
]
const orderStatusOptions = [
  { value: 'WAIT_PICKUP', label: '待自取', type: 'warning' },
  { value: 'WAIT_SHIP', label: '待寄出', type: 'warning' },
  { value: 'BORROWING', label: '借阅中', type: 'success' },
  { value: 'RETURNING', label: '归还中', type: 'primary' },
  { value: 'RETURNED', label: '已归还', type: 'info' },
  { value: 'COMPENSATION_PENDING', label: '待赔偿', type: 'danger' }
]
const optionMap = { borrowType: borrowTypeOptions, returnType: returnTypeOptions, orderStatus: orderStatusOptions }

const loading = ref(false)
const list = ref([])
const total = ref(0)
const readerId = ref(undefined)
const readerContact = ref(undefined)
const statusFilter = ref(undefined)

const query = reactive({ pageNum: 1, pageSize: 7 })

const returnDialog = reactive({ open: false })
const payDialog = reactive({ open: false })
const returnFormRef = ref(null)

const returnForm = reactive({
  orderId: undefined, returnType: 'LIBRARY_RETURN', userShipBackDate: undefined, trackingNo: undefined, carrierName: undefined, remark: undefined
})
const payForm = reactive({ orderId: undefined, orderNo: undefined, compensationAmount: 0 })

const returnRules = {
  orderId: [{ required: true, message: '订单ID不能为空', trigger: 'blur' }],
  returnType: [{ required: true, message: '还书方式不能为空', trigger: 'change' }]
}

function labelOf(type, value) {
  const item = (optionMap[type] || []).find(o => o.value === value)
  return item ? item.label : (value || '-')
}
function tagType(type, value) {
  const item = (optionMap[type] || []).find(o => o.value === value)
  return item ? item.type : ''
}
function formatDate(value) { return value ? proxy.parseTime(value, '{y}-{m}-{d}') : '-' }
function money(value) { return `￥${Number(value || 0).toFixed(2)}` }

function cleanPayload(data) {
  return Object.fromEntries(Object.entries(data).filter(([, v]) => v !== undefined && v !== null && v !== ''))
}

function getList() {
  if (!readerId.value) return
  loading.value = true
  const params = { ...query, readerId: readerId.value, orderStatus: statusFilter.value || undefined }
  queryOrders(cleanPayload(params)).then(res => {
    list.value = res.data?.list || []
    total.value = Number(res.data?.total || 0)
  }).finally(() => { loading.value = false })
}

function handleQuery() { query.pageNum = 1; getList() }

function resetQuery() {
  statusFilter.value = undefined
  query.pageNum = 1
  getList()
}

onMounted(() => {
  const userId = userStore.id
  const readerName = userStore.nickName || undefined
  if (userId) {
    getOrCreateReader(userId, readerName).then(res => {
      readerId.value = res.data?.readerId
      readerContact.value = res.data?.mobile
      getList()
    }).catch(() => {})
  }
})

function openReturn(row) {
  returnForm.orderId = row?.orderId
  returnForm.returnType = 'LIBRARY_RETURN'
  returnForm.userShipBackDate = undefined
  returnForm.trackingNo = undefined
  returnForm.carrierName = undefined
  returnForm.remark = undefined
  returnDialog.open = true
}

function submitReturn() {
  returnFormRef.value.validate(valid => {
    if (!valid) return
    requestReturn(cleanPayload(returnForm)).then(() => {
      proxy.$modal.msgSuccess('还书申请已提交，请按选择的方式归还图书')
      returnDialog.open = false
      getList()
    })
  })
}

function openPayDialog(row) {
  payForm.orderId = row?.orderId
  payForm.orderNo = row?.orderNo
  payForm.compensationAmount = row?.compensationAmount || 0
  payDialog.open = true
}

function submitPay() {
  payCompensation({ orderId: payForm.orderId, payMethod: 'DEPOSIT' }).then(() => {
    proxy.$modal.msgSuccess('赔偿已从押金中扣除')
    payDialog.open = false
    getList()
  }).catch(error => {
    proxy.$modal.msgError(error?.msg || error?.message || '押金余额不足，请先充值押金补差价')
  })
}

function goRecharge() {
  proxy.$modal.msgWarning('充值页面将随充值 API 一起补充')
}
</script>

<style scoped lang="scss">
.reader-borrows {
  .query-form { margin-bottom: 10px; }
  .muted { color: #909399; font-size: 12px; margin-top: 2px; }
  .date-line { color: #606266; font-size: 14px; line-height: 22px; }
  :deep(.el-input-number) { width: 100%; }
  :deep(.el-table__body tr:hover > td.el-table__cell),
  :deep(.el-table__body tr.hover-row > td.el-table__cell) {
    background-color: transparent !important;
  }
}
</style>

<template>
  <div class="app-container admin-orders">
    <el-form :model="query" :inline="true" label-width="72px" class="query-form">
      <el-form-item label="订单号">
        <el-input v-model="query.orderNo" placeholder="请输入订单号" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="联系电话">
        <el-input v-model="query.readerContact" placeholder="请输入读者联系电话" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="图书ID">
        <el-input v-model="query.bookId" placeholder="请输入图书ID" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态">
        <el-select v-model="query.orderStatus" placeholder="全部" clearable>
          <el-option v-for="item in orderStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item class="query-actions">
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="list">
      <el-table-column prop="orderNo" label="订单号" min-width="170" align="left" header-align="left" show-overflow-tooltip />
      <el-table-column label="借阅读者" width="120" align="center" header-align="center" show-overflow-tooltip>
        <template #default="{ row }">{{ row.readerName || '-' }}</template>
      </el-table-column>
      <el-table-column label="读者联系电话" min-width="130" align="center" header-align="center" show-overflow-tooltip>
        <template #default="{ row }">{{ row.readerContact || '-' }}</template>
      </el-table-column>
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
      <el-table-column label="操作" width="250" fixed="right" align="center" header-align="center">
        <template #default="{ row }">
          <el-button v-if="['WAIT_PICKUP', 'WAIT_SHIP'].includes(row.orderStatus)" link type="primary" icon="Promotion" @click="openFulfillment(row)">确认交付</el-button>
          <el-button v-if="row.orderStatus === 'BORROWING'" link type="warning" icon="Back" @click="openReturn(row)">发起还书</el-button>
          <el-button v-if="row.orderStatus === 'RETURNING'" link type="danger" icon="CircleCheck" @click="openReturnConfirm(row)">验收</el-button>
          <span v-if="row.orderStatus === 'COMPENSATION_PENDING'" class="muted">待读者缴纳</span>
          <span v-if="row.orderStatus === 'RETURNED'" class="muted">订单已结束</span>
          <span v-if="!['WAIT_PICKUP', 'WAIT_SHIP', 'BORROWING', 'RETURNING', 'COMPENSATION_PENDING', 'RETURNED'].includes(row.orderStatus)" class="muted">订单已结束</span>
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
      @update:limit="query.pageSize = $event"
      @pagination="getList"
    />

    <!-- 确认交付 -->
    <el-dialog v-model="fulfillmentDialog.open" title="确认自取或馆方寄出" width="520px" append-to-body>
      <el-form ref="fulfillmentFormRef" :model="fulfillmentForm" :rules="fulfillmentRules" label-width="110px">
        <el-form-item label="确认日期">
          <el-date-picker v-model="fulfillmentForm.fulfillmentDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
        </el-form-item>
        <el-form-item label="物流单号">
          <el-input v-model="fulfillmentForm.trackingNo" />
        </el-form-item>
        <el-form-item label="承运方">
          <el-input v-model="fulfillmentForm.carrierName" />
        </el-form-item>
        <el-form-item label="配送费用">
          <el-input-number v-model="fulfillmentForm.freightAmount" :min="0" :precision="2" controls-position="right" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="fulfillmentForm.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="fulfillmentDialog.open = false">取消</el-button>
        <el-button type="primary" @click="submitFulfillment">确定</el-button>
      </template>
    </el-dialog>

    <!-- 发起还书 -->
    <el-dialog v-model="returnDialog.open" title="读者发起还书" width="520px" append-to-body>
      <el-form ref="returnFormRef" :model="returnForm" :rules="returnRules" label-width="110px">
        <el-form-item label="还书方式">
          <el-input model-value="到馆还书" disabled />
        </el-form-item>
        <el-form-item label="还书日期">
          <el-date-picker v-model="returnForm.userShipBackDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="returnForm.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="returnDialog.open = false">取消</el-button>
        <el-button type="primary" @click="submitReturn">确定</el-button>
      </template>
    </el-dialog>

    <!-- 验收 -->
    <el-dialog v-model="returnConfirmDialog.open" title="馆员收书验收" width="520px" append-to-body>
      <el-form ref="returnConfirmFormRef" :model="returnConfirmForm" :rules="returnConfirmRules" label-width="110px">
        <el-form-item label="收书日期">
          <el-date-picker v-model="returnConfirmForm.libraryReceiveDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
        </el-form-item>
        <el-form-item label="图书状态">
          <el-select v-model="returnConfirmForm.damageStatus" style="width: 100%">
            <el-option v-for="item in damageStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="赔偿金额">
          <el-input-number v-model="returnConfirmForm.compensationAmount" :min="0" :precision="2" controls-position="right" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="returnConfirmForm.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="returnConfirmDialog.open = false">取消</el-button>
        <el-button type="primary" @click="submitReturnConfirm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="AdminOrders">
import { getCurrentInstance, reactive, ref } from 'vue'
import { confirmFulfillment, confirmReturn, queryOrders, requestReturn } from '@/api/library'

const { proxy } = getCurrentInstance()

const borrowTypeOptions = [
  { value: 'SELF_PICKUP', label: '到馆自取', type: 'success' },
  { value: 'LIBRARY_SHIP', label: '馆方邮寄', type: 'warning' }
]
const returnTypeOptions = [
  { value: 'LIBRARY_RETURN', label: '到馆还书', type: 'success' }
]
const orderStatusOptions = [
  { value: 'WAIT_PICKUP', label: '待自取', type: 'warning' },
  { value: 'WAIT_SHIP', label: '待寄出', type: 'warning' },
  { value: 'BORROWING', label: '借阅中', type: 'success' },
  { value: 'RETURNING', label: '归还中', type: 'primary' },
  { value: 'RETURNED', label: '已归还', type: 'info' },
  { value: 'COMPENSATION_PENDING', label: '待赔偿', type: 'danger' }
]
const damageStatusOptions = [
  { value: 'NORMAL', label: '正常', type: 'success' },
  { value: 'DAMAGED', label: '损坏', type: 'warning' },
  { value: 'LOST', label: '遗失', type: 'danger' }
]
const optionMap = { borrowType: borrowTypeOptions, returnType: returnTypeOptions, orderStatus: orderStatusOptions, damageStatus: damageStatusOptions }

const loading = ref(false)
const list = ref([])
const total = ref(0)

const query = reactive({ pageNum: 1, pageSize: 7, readerContact: undefined, bookId: undefined, orderNo: undefined, orderStatus: undefined, returnType: undefined })

const fulfillmentDialog = reactive({ open: false })
const returnDialog = reactive({ open: false })
const returnConfirmDialog = reactive({ open: false })

const fulfillmentFormRef = ref(null)
const returnFormRef = ref(null)
const returnConfirmFormRef = ref(null)

const fulfillmentForm = reactive({ orderId: undefined, fulfillmentDate: undefined, trackingNo: undefined, carrierName: undefined, freightAmount: 0, remark: undefined })
const returnForm = reactive({ orderId: undefined, returnType: 'LIBRARY_RETURN', userShipBackDate: undefined, trackingNo: undefined, carrierName: undefined, remark: undefined })
const returnConfirmForm = reactive({ orderId: undefined, libraryReceiveDate: undefined, damageStatus: 'NORMAL', compensationAmount: 0, remark: undefined })

const fulfillmentRules = { orderId: [{ required: true, message: '订单ID不能为空', trigger: 'blur' }] }
const returnRules = {
  orderId: [{ required: true, message: '订单ID不能为空', trigger: 'blur' }],
  returnType: [{ required: true, message: '还书方式不能为空', trigger: 'change' }]
}
const returnConfirmRules = { orderId: [{ required: true, message: '订单ID不能为空', trigger: 'blur' }] }

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

function assignForm(target, source) {
  Object.keys(target).forEach(key => delete target[key])
  Object.assign(target, source)
}

function getList() {
  loading.value = true
  queryOrders(cleanPayload(query)).then(res => {
    list.value = res.data?.list || []
    total.value = Number(res.data?.total || 0)
  }).finally(() => { loading.value = false })
}

function handleQuery() { query.pageNum = 1; getList() }

function resetQuery() {
  Object.assign(query, { pageNum: 1, pageSize: 7, readerContact: undefined, bookId: undefined, orderNo: undefined, orderStatus: undefined, returnType: undefined })
  getList()
}

function openFulfillment(row) {
  assignForm(fulfillmentForm, { orderId: row?.orderId, fulfillmentDate: undefined, trackingNo: undefined, carrierName: undefined, freightAmount: 0, remark: undefined })
  fulfillmentDialog.open = true
}

function submitFulfillment() {
  fulfillmentFormRef.value.validate(valid => {
    if (!valid) return
    confirmFulfillment(cleanPayload(fulfillmentForm)).then(() => {
      proxy.$modal.msgSuccess('交付确认成功')
      fulfillmentDialog.open = false
      getList()
    })
  })
}

function openReturn(row) {
  assignForm(returnForm, { orderId: row?.orderId, returnType: 'LIBRARY_RETURN', userShipBackDate: undefined, trackingNo: undefined, carrierName: undefined, remark: undefined })
  returnDialog.open = true
}

function submitReturn() {
  returnFormRef.value.validate(valid => {
    if (!valid) return
    requestReturn(cleanPayload(returnForm)).then(() => {
      proxy.$modal.msgSuccess('还书申请成功')
      returnDialog.open = false
      getList()
    })
  })
}

function openReturnConfirm(row) {
  assignForm(returnConfirmForm, { orderId: row?.orderId, libraryReceiveDate: undefined, damageStatus: 'NORMAL', compensationAmount: 0, remark: undefined })
  returnConfirmDialog.open = true
}

function submitReturnConfirm() {
  returnConfirmFormRef.value.validate(valid => {
    if (!valid) return
    confirmReturn(cleanPayload(returnConfirmForm)).then(() => {
      proxy.$modal.msgSuccess('收书验收成功')
      returnConfirmDialog.open = false
      getList()
    })
  })
}

getList()
</script>

<style scoped lang="scss">
.admin-orders {
  .query-form {
    display: grid;
    grid-template-columns: minmax(220px, 1fr) minmax(270px, 1.15fr) minmax(210px, 0.95fr) minmax(180px, 0.8fr) auto;
    gap: 12px 18px;
    align-items: start;
    margin-bottom: 16px;
  }
  .query-form :deep(.el-form-item) {
    margin: 0;
    min-width: 0;
  }
  .query-form :deep(.el-form-item__label) {
    white-space: nowrap;
    padding-right: 10px;
    line-height: 36px;
  }
  .query-form :deep(.el-input),
  .query-form :deep(.el-select) {
    width: 100%;
  }
  .query-actions {
    justify-self: start;
  }
  .query-form :deep(.el-button + .el-button) {
    margin-left: 8px;
  }
  @media (max-width: 1360px) {
    .query-form {
      grid-template-columns: repeat(2, minmax(260px, 1fr));
    }
    .query-actions {
      grid-column: 1 / -1;
    }
  }
  .muted { color: #909399; font-size: 12px; margin-top: 2px; }
  .date-line { color: #606266; font-size: 14px; line-height: 22px; }
}
</style>

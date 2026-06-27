<template>
  <div class="app-container admin-readers">
    <el-form :model="query" :inline="true" label-width="72px" class="query-form">
      <el-form-item label="姓名">
        <el-input v-model="query.readerName" placeholder="请输入姓名" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="联系电话">
        <el-input v-model="query.readerContact" placeholder="请输入联系电话" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="城市">
        <el-input v-model="query.city" placeholder="请输入城市" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态">
        <el-select v-model="query.status" placeholder="全部" clearable style="width: 140px">
          <el-option label="正常" value="NORMAL" />
          <el-option label="停用" value="DISABLED" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        <el-button type="primary" icon="Plus" plain @click="openDialog()">新增读者</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="list">
      <el-table-column prop="readerId" label="ID" width="80" align="center" />
      <el-table-column prop="readerName" label="姓名" min-width="120" />
      <el-table-column prop="mobile" label="联系电话" min-width="130" />
      <el-table-column prop="city" label="城市" width="120" />
      <el-table-column prop="annualExpireDate" label="年费到期" width="150">
        <template #default="{ row }">{{ formatDate(row.annualExpireDate) }}</template>
      </el-table-column>
      <el-table-column label="押金" width="120" align="right">
        <template #default="{ row }">{{ money(row.depositBalance) }}</template>
      </el-table-column>
      <el-table-column label="寄出/寄回" width="120" align="center">
        <template #default="{ row }">{{ row.usedOutboundCount || 0 }}/{{ row.maxOutboundCount || 0 }} · {{ row.usedInboundCount || 0 }}/{{ row.maxInboundCount || 0 }}</template>
      </el-table-column>
      <el-table-column prop="maxBorrowCount" label="可借数" width="90" align="center" />
      <el-table-column prop="status" label="状态" width="100" align="center">
        <template #default="{ row }">
          <el-tag :type="row.status === 'NORMAL' ? 'success' : 'danger'">{{ row.status === 'NORMAL' ? '正常' : '停用' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="260" fixed="right" align="center">
        <template #default="{ row }">
          <el-button link type="primary" icon="Edit" @click="openDialog(row)">编辑</el-button>
          <el-button link type="success" icon="Money" @click="openFeeDialog(row)">缴费</el-button>
          <el-button link type="warning" icon="Location" @click="openAddressDialog(row)">地址</el-button>
          <el-button link type="info" icon="DataAnalysis" @click="openSummary(row)">概览</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination
      v-show="total > 0"
      :total="total"
      :page="query.pageNum"
      :limit="query.pageSize"
      @update:page="query.pageNum = $event"
      @update:limit="query.pageSize = $event"
      @pagination="getList"
    />

    <!-- 新增/编辑读者 -->
    <el-dialog v-model="dialog.open" :title="dialog.title" width="760px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="120px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="读者姓名" prop="readerName">
              <el-input v-model="form.readerName" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="绑定用户ID">
              <el-input-number v-model="form.userId" :min="1" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话">
              <el-input v-model="form.mobile" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="城市">
              <el-input v-model="form.city" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="年费到期">
              <el-date-picker v-model="form.annualExpireDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态">
              <el-select v-model="form.status" style="width: 100%">
                <el-option label="正常" value="NORMAL" />
                <el-option label="停用" value="DISABLED" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="押金余额">
              <el-input-number v-model="form.depositBalance" :min="0" :precision="2" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="冻结押金">
              <el-input-number v-model="form.depositFrozen" :min="0" :precision="2" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="已寄出">
              <el-input-number v-model="form.usedOutboundCount" :min="0" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="已寄回">
              <el-input-number v-model="form.usedInboundCount" :min="0" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="可借数量">
              <el-input-number v-model="form.maxBorrowCount" :min="1" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="寄出额度">
              <el-input-number v-model="form.maxOutboundCount" :min="0" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="寄回额度">
              <el-input-number v-model="form.maxInboundCount" :min="0" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="默认地址ID">
              <el-input-number v-model="form.defaultAddressId" :min="1" controls-position="right" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button v-if="form.readerId" type="danger" plain @click="handleDeleteReader">删除读者</el-button>
        <el-button @click="dialog.open = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>

    <!-- 缴费 -->
    <el-dialog v-model="feeDialog.open" title="缴纳年费 / 充值押金" width="500px" append-to-body>
      <el-form ref="feeFormRef" :model="feeForm" :rules="feeRules" label-width="110px">
        <el-form-item label="读者ID" prop="readerId">
          <el-input-number v-model="feeForm.readerId" :min="1" controls-position="right" />
        </el-form-item>
        <el-form-item label="关联订单ID">
          <el-input-number v-model="feeForm.orderId" :min="1" controls-position="right" />
        </el-form-item>
        <el-form-item label="费用类型" prop="feeType">
          <el-select v-model="feeForm.feeType" style="width: 100%">
            <el-option v-for="item in feeTypeOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="金额" prop="amount">
          <el-input-number v-model="feeForm.amount" :min="0" :precision="2" controls-position="right" />
        </el-form-item>
        <el-form-item label="支付方式">
          <el-input v-model="feeForm.payMethod" placeholder="现金、微信、支付宝等" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="feeForm.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="feeDialog.open = false">取消</el-button>
        <el-button type="primary" @click="submitFee">确定</el-button>
      </template>
    </el-dialog>

    <!-- 地址维护 -->
    <el-dialog v-model="addrDialog.open" title="维护同城邮寄地址" width="620px" append-to-body>
      <el-form ref="addrFormRef" :model="addrForm" :rules="addrRules" label-width="110px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="读者ID" prop="readerId">
              <el-input-number v-model="addrForm.readerId" :min="1" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="地址ID">
              <el-input-number v-model="addrForm.addressId" :min="1" controls-position="right" />
            </el-form-item>
          </el-col>
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
            <el-form-item label="默认地址">
              <el-switch v-model="addrDefault" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态">
              <el-select v-model="addrForm.status" style="width: 100%">
                <el-option label="启用" value="ENABLED" />
                <el-option label="停用" value="DISABLED" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button @click="addrDialog.open = false">取消</el-button>
        <el-button type="primary" @click="submitAddress">确定</el-button>
      </template>
    </el-dialog>

    <!-- 借阅概览抽屉 -->
    <el-drawer v-model="summaryDrawer.open" title="读者借阅概览" size="420px">
      <el-empty v-if="!summaryDrawer.data" description="暂无数据" />
      <el-descriptions v-else :column="1" border>
        <el-descriptions-item v-for="(value, key) in summaryDrawer.data" :key="key" :label="key">
          {{ value }}
        </el-descriptions-item>
      </el-descriptions>
    </el-drawer>
  </div>
</template>

<script setup name="AdminReaders">
import { getCurrentInstance, reactive, ref } from 'vue'
import { deleteReader, getReader, getReaderSummary, payFee, queryReaders, saveAddress, saveReader } from '@/api/library'

const { proxy } = getCurrentInstance()

const feeTypeOptions = [
  { value: 'ANNUAL_FEE', label: '年度服务费' },
  { value: 'DEPOSIT_RECHARGE', label: '押金充值' },
  { value: 'OVERDUE', label: '逾期费用' },
  { value: 'DAMAGE', label: '损坏赔偿' },
  { value: 'LOST', label: '遗失赔偿' },
  { value: 'COMPENSATION', label: '其他赔偿' }
]

const loading = ref(false)
const list = ref([])
const total = ref(0)
const addrDefault = ref(true)

const query = reactive({ pageNum: 1, pageSize: 10, readerName: undefined, readerContact: undefined, city: undefined, status: undefined })

const dialog = reactive({ open: false, title: '新增读者' })
const feeDialog = reactive({ open: false })
const addrDialog = reactive({ open: false })
const summaryDrawer = reactive({ open: false, data: null })

const formRef = ref(null)
const feeFormRef = ref(null)
const addrFormRef = ref(null)

const form = reactive({
  readerId: undefined, userId: undefined, readerName: undefined, mobile: undefined, city: undefined,
  defaultAddressId: undefined, annualExpireDate: undefined, depositBalance: 0, depositFrozen: 0,
  usedOutboundCount: 0, usedInboundCount: 0, maxOutboundCount: 6, maxInboundCount: 6, maxBorrowCount: 3, status: 'NORMAL'
})

const feeForm = reactive({
  readerId: undefined, orderId: undefined, feeType: 'ANNUAL_FEE', amount: 0, payMethod: '线下登记', remark: undefined
})

const addrForm = reactive({
  addressId: undefined, readerId: undefined, receiverName: undefined, receiverMobile: undefined,
  city: undefined, district: undefined, detailAddress: undefined, defaultFlag: 1, status: 'ENABLED'
})

const rules = { readerName: [{ required: true, message: '读者姓名不能为空', trigger: 'blur' }] }
const feeRules = {
  readerId: [{ required: true, message: '读者ID不能为空', trigger: 'blur' }],
  feeType: [{ required: true, message: '费用类型不能为空', trigger: 'change' }],
  amount: [{ required: true, message: '金额不能为空', trigger: 'blur' }]
}
const addrRules = {
  readerId: [{ required: true, message: '读者ID不能为空', trigger: 'blur' }],
  receiverName: [{ required: true, message: '收件人不能为空', trigger: 'blur' }],
  city: [{ required: true, message: '城市不能为空', trigger: 'blur' }],
  detailAddress: [{ required: true, message: '详细地址不能为空', trigger: 'blur' }]
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
  queryReaders(cleanPayload(query)).then(res => {
    list.value = res.data?.list || []
    total.value = Number(res.data?.total || 0)
  }).finally(() => { loading.value = false })
}

function handleQuery() { query.pageNum = 1; getList() }

function resetQuery() {
  Object.assign(query, { pageNum: 1, pageSize: 10, readerName: undefined, readerContact: undefined, city: undefined, status: undefined })
  getList()
}

function openDialog(row) {
  assignForm(form, { readerId: undefined, userId: undefined, readerName: undefined, mobile: undefined, city: undefined, defaultAddressId: undefined, annualExpireDate: undefined, depositBalance: 0, depositFrozen: 0, usedOutboundCount: 0, usedInboundCount: 0, maxOutboundCount: 6, maxInboundCount: 6, maxBorrowCount: 3, status: 'NORMAL' })
  if (row?.readerId) {
    getReader(row.readerId).then(res => assignForm(form, { ...form, ...res.data }))
    dialog.title = '编辑读者'
  } else {
    dialog.title = '新增读者'
  }
  dialog.open = true
}

function submitForm() {
  formRef.value.validate(valid => {
    if (!valid) return
    saveReader(cleanPayload(form)).then(() => {
      proxy.$modal.msgSuccess('保存成功')
      dialog.open = false
      getList()
    })
  })
}

function handleDeleteReader() {
  proxy.$modal.confirm(`确认删除读者"${form.readerName || form.readerId}"？此操作不可恢复。`).then(() => {
    deleteReader(form.readerId).then(() => {
      proxy.$modal.msgSuccess('删除成功')
      dialog.open = false
      getList()
    })
  }).catch(() => {})
}

function openFeeDialog(row) {
  assignForm(feeForm, { readerId: row?.readerId, orderId: undefined, feeType: 'ANNUAL_FEE', amount: 0, payMethod: '线下登记', remark: undefined })
  feeDialog.open = true
}

function submitFee() {
  feeFormRef.value.validate(valid => {
    if (!valid) return
    payFee(cleanPayload(feeForm)).then(() => {
      proxy.$modal.msgSuccess('缴费登记成功')
      feeDialog.open = false
      getList()
    })
  })
}

function openAddressDialog(row) {
  assignForm(addrForm, { addressId: undefined, readerId: row?.readerId, receiverName: row?.readerName, receiverMobile: row?.mobile, city: row?.city, district: undefined, detailAddress: undefined, defaultFlag: 1, status: 'ENABLED' })
  addrDefault.value = true
  addrDialog.open = true
}

function submitAddress() {
  addrFormRef.value.validate(valid => {
    if (!valid) return
    addrForm.defaultFlag = addrDefault.value ? 1 : 0
    saveAddress(cleanPayload(addrForm)).then(() => {
      proxy.$modal.msgSuccess('地址保存成功')
      addrDialog.open = false
      getList()
    })
  })
}

function openSummary(row) {
  summaryDrawer.open = true
  summaryDrawer.data = null
  getReaderSummary(row.readerId).then(res => {
    summaryDrawer.data = res.data || {}
  })
}

getList()
</script>

<style scoped lang="scss">
.admin-readers {
  .query-form { margin-bottom: 10px; }
  :deep(.el-input-number) { width: 100%; }
}
</style>

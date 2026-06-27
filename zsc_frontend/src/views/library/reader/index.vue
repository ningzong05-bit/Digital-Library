<template>
  <div class="app-container reader-books">
    <el-form :model="query" :inline="true" label-width="72px" class="query-form">
      <el-form-item label="书名">
        <el-input v-model="query.bookName" placeholder="请输入书名" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="ISBN">
        <el-input v-model="query.isbn" placeholder="请输入ISBN" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="作者">
        <el-input v-model="query.author" placeholder="请输入作者" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="分类">
        <el-input v-model="query.categoryName" placeholder="请输入分类" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-checkbox v-model="onlyAvailable" label="仅可借" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="list" @row-click="showDetail">
      <el-table-column prop="bookId" label="ID" width="80" align="center" />
      <el-table-column prop="bookName" label="书名" min-width="200" show-overflow-tooltip />
      <el-table-column prop="isbn" label="ISBN" min-width="140" show-overflow-tooltip />
      <el-table-column prop="author" label="作者" width="120" show-overflow-tooltip />
      <el-table-column prop="publisher" label="出版社" width="140" show-overflow-tooltip />
      <el-table-column prop="categoryName" label="分类" width="120" />
      <el-table-column label="馆藏/可借" width="110" align="center">
        <template #default="{ row }">{{ row.totalCount || 0 }} / {{ row.availableCount || 0 }}</template>
      </el-table-column>
      <el-table-column prop="queueCount" label="排队" width="80" align="center" />
      <el-table-column prop="status" label="状态" width="100" align="center">
        <template #default="{ row }">
          <el-tag :type="row.status === 'ENABLED' ? 'success' : 'danger'">{{ row.status === 'ENABLED' ? '可借' : '停借' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right" align="center">
        <template #default="{ row }">
          <el-button link type="primary" icon="Reading" :disabled="!canBorrow(row)" @click.stop="openBorrow(row)">借书</el-button>
          <el-button link type="warning" icon="Timer" :disabled="!canQueue(row)" @click.stop="openQueue(row)">排队</el-button>
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

    <!-- 图书详情 -->
    <el-dialog v-model="detailDialog.open" :title="detailDialog.title" width="640px" append-to-body>
      <el-descriptions :column="2" border v-if="detailDialog.data">
        <el-descriptions-item label="书名">{{ detailDialog.data.bookName }}</el-descriptions-item>
        <el-descriptions-item label="ISBN">{{ detailDialog.data.isbn || '-' }}</el-descriptions-item>
        <el-descriptions-item label="作者">{{ detailDialog.data.author || '-' }}</el-descriptions-item>
        <el-descriptions-item label="出版社">{{ detailDialog.data.publisher || '-' }}</el-descriptions-item>
        <el-descriptions-item label="分类">{{ detailDialog.data.categoryName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="detailDialog.data.status === 'ENABLED' ? 'success' : 'danger'">{{ detailDialog.data.status === 'ENABLED' ? '可借' : '停借' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="总馆藏">{{ detailDialog.data.totalCount || 0 }}</el-descriptions-item>
        <el-descriptions-item label="可借数量">{{ detailDialog.data.availableCount || 0 }}</el-descriptions-item>
        <el-descriptions-item label="当前排队">{{ detailDialog.data.queueCount || 0 }} 人</el-descriptions-item>
        <el-descriptions-item label="简介" :span="2">{{ detailDialog.data.description || '暂无简介' }}</el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="detailDialog.open = false">关闭</el-button>
        <el-button type="primary" icon="Reading" :disabled="!canBorrow(detailDialog.data)" @click="detailDialog.open = false; openBorrow(detailDialog.data)">我要借书</el-button>
        <el-button type="warning" icon="Timer" :disabled="!canQueue(detailDialog.data)" @click="detailDialog.open = false; openQueue(detailDialog.data)">加入排队</el-button>
      </template>
    </el-dialog>

    <!-- 借书/排队对话框 -->
    <el-dialog v-model="borrowDialog.open" :title="borrowDialog.mode === 'queue' ? '加入排队' : '线上借书'" width="520px" append-to-body>
      <el-form ref="borrowFormRef" :model="borrowForm" :rules="borrowRules" label-width="110px">
        <el-form-item label="书名">
          <el-input :model-value="selectedBookName" disabled style="width: 100%" />
        </el-form-item>
        <el-form-item label="联系电话" prop="mobile">
          <el-input v-model="borrowForm.mobile" placeholder="请输入您的联系电话" style="width: 100%" />
        </el-form-item>
        <el-form-item label="取书方式" prop="borrowType">
          <el-radio-group v-model="borrowForm.borrowType">
            <el-radio value="SELF_PICKUP">到馆自取</el-radio>
            <el-radio value="LIBRARY_SHIP">馆方邮寄</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="收货地址" prop="addressId" v-if="borrowForm.borrowType === 'LIBRARY_SHIP'">
          <div style="display: flex; gap: 8px; width: 100%">
            <el-select v-model="borrowForm.addressId" placeholder="请选择收货地址" clearable style="flex: 1">
              <el-option v-for="addr in readerAddresses" :key="addr.addressId" :label="addr.detailAddress" :value="addr.addressId">
                <span>{{ addr.receiverName }} {{ addr.receiverMobile }}</span>
                <span style="color: #909399; font-size: 12px; margin-left: 8px">{{ addr.city }}{{ addr.district }} {{ addr.detailAddress }}</span>
              </el-option>
            </el-select>
            <el-button icon="Plus" @click="openNewAddressDialog">新增地址</el-button>
          </div>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="borrowForm.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="borrowDialog.open = false">取消</el-button>
        <el-button type="primary" @click="submitBorrow">{{ borrowDialog.mode === 'queue' ? '加入排队' : '提交借阅' }}</el-button>
      </template>
    </el-dialog>

    <!-- 新增地址对话框 -->
    <el-dialog v-model="addrDialog.open" title="新增收货地址" width="560px" append-to-body>
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
        <el-button type="primary" @click="submitNewAddress">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="ReaderBooks">
import { computed, getCurrentInstance, reactive, ref, watch } from 'vue'
import { borrowOnline, getBook, getReaderAddresses, getReaderByMobile, joinQueue, queryBooks, saveAddress } from '@/api/library'

const { proxy } = getCurrentInstance()

const loading = ref(false)
const list = ref([])
const total = ref(0)
const onlyAvailable = ref(false)

const readerAddresses = ref([])
const addrDefault = ref(true)

const query = reactive({ pageNum: 1, pageSize: 14, bookName: undefined, isbn: undefined, author: undefined, categoryName: undefined })

const detailDialog = reactive({ open: false, title: '', data: null })
const borrowDialog = reactive({ open: false, title: '线上借书', mode: 'borrow' })
const addrDialog = reactive({ open: false })

const borrowFormRef = ref(null)
const addrFormRef = ref(null)

const borrowForm = reactive({
  mobile: undefined, bookId: undefined, borrowType: 'SELF_PICKUP', addressId: undefined, remark: undefined
})

const addrForm = reactive({
  addressId: undefined, readerId: undefined, receiverName: undefined, receiverMobile: undefined,
  city: undefined, district: undefined, detailAddress: undefined, defaultFlag: 1, status: 'ENABLED'
})

const borrowRules = {
  mobile: [
    { required: true, message: '请输入您的联系电话', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ],
  addressId: [{ required: true, message: '请选择收货地址', trigger: 'change' }]
}

const addrRules = {
  receiverName: [{ required: true, message: '收件人不能为空', trigger: 'blur' }],
  city: [{ required: true, message: '城市不能为空', trigger: 'blur' }],
  detailAddress: [{ required: true, message: '详细地址不能为空', trigger: 'blur' }]
}

const selectedBookName = computed(() => {
  const book = list.value.find(b => b.bookId === borrowForm.bookId)
  return book ? book.bookName : ''
})

watch([() => borrowForm.mobile, () => borrowForm.borrowType], ([mobile, type]) => {
  if (mobile && type === 'LIBRARY_SHIP' && /^1[3-9]\d{9}$/.test(mobile)) {
    getReaderByMobile(mobile).then(res => {
      loadReaderAddresses(res.data.readerId)
    }).catch(() => {})
  }
})

function cleanPayload(data) {
  return Object.fromEntries(Object.entries(data).filter(([, v]) => v !== undefined && v !== null && v !== ''))
}

function getList() {
  loading.value = true
  query.onlyAvailable = onlyAvailable.value ? 1 : undefined
  queryBooks(cleanPayload(query)).then(res => {
    list.value = res.data?.list || []
    total.value = Number(res.data?.total || 0)
  }).finally(() => { loading.value = false })
}

function handleQuery() { query.pageNum = 1; getList() }

function resetQuery() {
  Object.assign(query, { pageNum: 1, pageSize: 14, bookName: undefined, isbn: undefined, author: undefined, categoryName: undefined, onlyAvailable: undefined })
  onlyAvailable.value = false
  getList()
}

function showDetail(row) {
  getBook(row.bookId).then(res => {
    detailDialog.data = res.data || {}
    detailDialog.title = detailDialog.data.bookName || '图书详情'
    detailDialog.open = true
  })
}

function canBorrow(book) {
  return !!book && book.status === 'ENABLED' && Number(book.availableCount || 0) > 0
}

function canQueue(book) {
  return !!book && book.status === 'ENABLED' && Number(book.availableCount || 0) <= 0
}

function loadReaderAddresses(readerId) {
  getReaderAddresses(readerId).then(res => {
    readerAddresses.value = res.data || []
  })
}

function openBorrow(row) {
  borrowForm.mobile = undefined
  borrowForm.bookId = row?.bookId
  borrowForm.borrowType = 'SELF_PICKUP'
  borrowForm.addressId = undefined
  borrowForm.remark = undefined
  readerAddresses.value = []
  borrowDialog.mode = 'borrow'
  borrowDialog.open = true
}

function openQueue(row) {
  borrowForm.mobile = undefined
  borrowForm.bookId = row?.bookId
  borrowForm.borrowType = 'SELF_PICKUP'
  borrowForm.addressId = undefined
  borrowForm.remark = undefined
  readerAddresses.value = []
  borrowDialog.mode = 'queue'
  borrowDialog.open = true
}

function submitBorrow() {
  borrowFormRef.value.validate(valid => {
    if (!valid) return
    getReaderByMobile(borrowForm.mobile).then(readerRes => {
      const action = borrowDialog.mode === 'queue' ? joinQueue : borrowOnline
      const payload = cleanPayload(borrowForm)
      delete payload.mobile
      payload.readerId = readerRes.data.readerId
      action(payload).then(res => {
        const result = res.data?.borrowResult || res.data?.queueResult || 'SUCCESS'
        if (result === 'QUEUED') {
          proxy.$modal.msgSuccess('库存不足，已自动进入排队')
        } else {
          proxy.$modal.msgSuccess('操作成功')
        }
        borrowDialog.open = false
        getList()
      })
    })
  })
}

function openNewAddressDialog() {
  getReaderByMobile(borrowForm.mobile).then(readerRes => {
    addrForm.addressId = undefined
    addrForm.readerId = readerRes.data.readerId
    addrForm.receiverName = readerRes.data.readerName || undefined
    addrForm.receiverMobile = borrowForm.mobile || undefined
    addrForm.city = readerRes.data.city || undefined
    addrForm.district = undefined
    addrForm.detailAddress = undefined
    addrForm.defaultFlag = readerAddresses.value.length === 0 ? 1 : 0
    addrForm.status = 'ENABLED'
    addrDefault.value = readerAddresses.value.length === 0
    addrDialog.open = true
  })
}

function submitNewAddress() {
  addrFormRef.value.validate(valid => {
    if (!valid) return
    addrForm.defaultFlag = addrDefault.value ? 1 : 0
    saveAddress(cleanPayload(addrForm)).then(() => {
      proxy.$modal.msgSuccess('地址保存成功')
      addrDialog.open = false
      loadReaderAddresses(addrForm.readerId)
    })
  })
}

getList()
</script>

<style scoped lang="scss">
.reader-books {
  .query-form { margin-bottom: 10px; }
  :deep(.el-input-number) { width: 100%; }
}
</style>

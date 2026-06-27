<template>
  <div class="app-container admin-queues">
    <el-form :model="query" :inline="true" label-width="72px" class="query-form">
      <el-form-item label="联系电话">
        <el-input v-model="query.readerContact" placeholder="请输入读者联系电话" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="图书ID">
        <el-input v-model="query.bookId" placeholder="请输入图书ID" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态">
        <el-select v-model="query.queueStatus" placeholder="全部" clearable style="width: 150px">
          <el-option v-for="item in queueStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="list">
      <el-table-column prop="queueId" label="ID" width="80" align="center" />
      <el-table-column prop="queueNo" label="排队号" min-width="160" show-overflow-tooltip />
      <el-table-column prop="readerContact" label="读者联系电话" min-width="130" show-overflow-tooltip />
      <el-table-column prop="bookId" label="图书ID" width="90" align="center" />
      <el-table-column prop="queuePosition" label="顺位" width="80" align="center" />
      <el-table-column prop="borrowType" label="取书方式" width="120">
        <template #default="{ row }">{{ labelOf('borrowType', row.borrowType) }}</template>
      </el-table-column>
      <el-table-column prop="estimatedAvailableDate" label="预计可借" width="160">
        <template #default="{ row }">{{ formatDate(row.estimatedAvailableDate) }}</template>
      </el-table-column>
      <el-table-column prop="queueStatus" label="状态" width="120">
        <template #default="{ row }">
          <el-tag :type="tagType('queueStatus', row.queueStatus)">{{ labelOf('queueStatus', row.queueStatus) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="convertedOrderId" label="转订单" width="100" align="center" />
      <el-table-column prop="remark" label="备注" min-width="180" show-overflow-tooltip />
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
  </div>
</template>

<script setup name="AdminQueues">
import { getCurrentInstance, reactive, ref } from 'vue'
import { queryQueues } from '@/api/library'

const { proxy } = getCurrentInstance()

const borrowTypeOptions = [
  { value: 'SELF_PICKUP', label: '到馆自取', type: 'success' },
  { value: 'LIBRARY_SHIP', label: '馆方邮寄', type: 'warning' }
]
const queueStatusOptions = [
  { value: 'WAITING', label: '排队中', type: 'warning' },
  { value: 'CONVERTED', label: '已转订单', type: 'success' },
  { value: 'EXCEPTION', label: '异常', type: 'danger' },
  { value: 'CANCELLED', label: '已取消', type: 'info' }
]
const optionMap = { borrowType: borrowTypeOptions, queueStatus: queueStatusOptions }

const loading = ref(false)
const list = ref([])
const total = ref(0)

const query = reactive({ pageNum: 1, pageSize: 15, readerContact: undefined, bookId: undefined, queueStatus: undefined })

function labelOf(type, value) {
  const item = (optionMap[type] || []).find(o => o.value === value)
  return item ? item.label : (value || '-')
}
function tagType(type, value) {
  const item = (optionMap[type] || []).find(o => o.value === value)
  return item ? item.type : ''
}
function formatDate(value) { return value ? proxy.parseTime(value, '{y}-{m}-{d}') : '-' }

function cleanPayload(data) {
  return Object.fromEntries(Object.entries(data).filter(([, v]) => v !== undefined && v !== null && v !== ''))
}

function getList() {
  loading.value = true
  queryQueues(cleanPayload(query)).then(res => {
    list.value = res.data?.list || []
    total.value = Number(res.data?.total || 0)
  }).finally(() => { loading.value = false })
}

function handleQuery() { query.pageNum = 1; getList() }

function resetQuery() {
  Object.assign(query, { pageNum: 1, pageSize: 15, readerContact: undefined, bookId: undefined, queueStatus: undefined })
  getList()
}

getList()
</script>

<style scoped lang="scss">
.admin-queues {
  .query-form { margin-bottom: 10px; }
  :deep(.el-input) { width: 220px; }
}
</style>

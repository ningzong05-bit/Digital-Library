<template>
  <div class="app-container admin-books">
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
      <el-form-item label="状态">
        <el-select v-model="query.status" placeholder="全部" clearable style="width: 140px">
          <el-option v-for="item in statusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        <el-button type="primary" icon="Plus" plain @click="openDialog()">新增图书</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="list">
      <el-table-column prop="bookId" label="ID" width="80" align="center" />
      <el-table-column prop="bookName" label="书名" min-width="180" show-overflow-tooltip />
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
          <el-tag :type="row.status === 'ENABLED' ? 'success' : 'danger'">{{ row.status === 'ENABLED' ? '启用' : '停用' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="更新时间" width="160" align="center">
        <template #default="{ row }">{{ formatTime(row.updateTime) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="136" fixed="right" align="center">
        <template #default="{ row }">
          <div class="row-actions">
            <el-button link type="primary" icon="Edit" @click="openDialog(row)">编辑</el-button>
            <el-button link type="danger" icon="Delete" @click="handleDelete(row)">删除</el-button>
          </div>
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

    <!-- 新增/编辑图书对话框 -->
    <el-dialog v-model="dialog.open" :title="dialog.title" width="720px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="书名" prop="bookName">
              <el-input v-model="form.bookName" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="ISBN">
              <el-input v-model="form.isbn" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="作者">
              <el-input v-model="form.author" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="出版社">
              <el-input v-model="form.publisher" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="分类">
              <el-input v-model="form.categoryName" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态">
              <el-select v-model="form.status" style="width: 100%">
                <el-option v-for="item in statusOptions" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="总馆藏">
              <el-input-number v-model="form.totalCount" :min="0" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="可借数量">
              <el-input-number v-model="form.availableCount" :min="0" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="封面地址">
              <el-input v-model="form.coverUrl" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="简介">
              <el-input v-model="form.description" type="textarea" :rows="3" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button @click="dialog.open = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="AdminBooks">
import { getCurrentInstance, reactive, ref } from 'vue'
import { deleteBook, getBook, queryBooks, saveBook } from '@/api/library'

const { proxy } = getCurrentInstance()

const statusOptions = [
  { value: 'ENABLED', label: '启用' },
  { value: 'DISABLED', label: '停用' }
]

const loading = ref(false)
const list = ref([])
const total = ref(0)

const query = reactive({ pageNum: 1, pageSize: 14, bookName: undefined, isbn: undefined, author: undefined, categoryName: undefined, status: undefined })

const dialog = reactive({ open: false, title: '新增图书' })

const formRef = ref(null)

const form = reactive({
  bookId: undefined, isbn: undefined, bookName: undefined, author: undefined, publisher: undefined,
  categoryName: undefined, coverUrl: undefined, description: undefined, totalCount: 1, availableCount: 1, status: 'ENABLED'
})

const rules = { bookName: [{ required: true, message: '图书名称不能为空', trigger: 'blur' }] }

function formatTime(value) { return value ? proxy.parseTime(value, '{y}-{m}-{d}') : '-' }

function cleanPayload(data) {
  return Object.fromEntries(Object.entries(data).filter(([, v]) => v !== undefined && v !== null && v !== ''))
}

function getList() {
  loading.value = true
  queryBooks(cleanPayload(query)).then(res => {
    list.value = res.data?.list || []
    total.value = Number(res.data?.total || 0)
  }).finally(() => { loading.value = false })
}

function handleQuery() { query.pageNum = 1; getList() }

function resetQuery() {
  Object.assign(query, { pageNum: 1, pageSize: 14, bookName: undefined, isbn: undefined, author: undefined, categoryName: undefined, status: undefined })
  getList()
}

function assignForm(target, source) {
  Object.keys(target).forEach(key => delete target[key])
  Object.assign(target, source)
}

function openDialog(row) {
  assignForm(form, { bookId: undefined, isbn: undefined, bookName: undefined, author: undefined, publisher: undefined, categoryName: undefined, coverUrl: undefined, description: undefined, totalCount: 1, availableCount: 1, status: 'ENABLED' })
  if (row?.bookId) {
    getBook(row.bookId).then(res => assignForm(form, { ...form, ...res.data }))
    dialog.title = '编辑图书'
  } else {
    dialog.title = '新增图书'
  }
  dialog.open = true
}

function submitForm() {
  formRef.value.validate(valid => {
    if (!valid) return
    saveBook(cleanPayload(form)).then(() => {
      proxy.$modal.msgSuccess('保存成功')
      dialog.open = false
      getList()
    })
  })
}

function handleDelete(row) {
  proxy.$modal.confirm(`确认删除图书“${row.bookName}”？`).then(() => deleteBook(row.bookId)).then(() => {
    proxy.$modal.msgSuccess('删除成功')
    getList()
  })
}

getList()
</script>

<style scoped lang="scss">
.admin-books {
  .query-form { margin-bottom: 10px; }
  :deep(.el-input-number) { width: 100%; }
  .row-actions {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    white-space: nowrap;
  }
  .row-actions :deep(.el-button + .el-button) { margin-left: 0; }
}
</style>

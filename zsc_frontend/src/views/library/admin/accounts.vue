<template>
  <div class="app-container account-admin-page">
    <el-row :gutter="16" class="account-grid">
      <el-col :xs="24" :xl="12">
        <section class="account-panel">
          <div class="panel-header">
            <div>
              <h3>管理员账号</h3>
            </div>
            <el-button type="primary" icon="Plus" plain @click="openAdminDialog()">新增管理员</el-button>
          </div>

          <el-form :model="adminQuery" :inline="true" label-width="72px" class="query-form">
            <el-form-item label="账号">
              <el-input v-model="adminQuery.userName" placeholder="请输入账号" clearable @keyup.enter="handleAdminQuery" />
            </el-form-item>
            <el-form-item label="联系电话">
              <el-input v-model="adminQuery.phonenumber" placeholder="请输入联系电话" clearable @keyup.enter="handleAdminQuery" />
            </el-form-item>
            <el-form-item label="状态">
              <el-select v-model="adminQuery.status" placeholder="全部" clearable style="width: 120px">
                <el-option label="正常" value="0" />
                <el-option label="停用" value="1" />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="handleAdminQuery">搜索</el-button>
              <el-button icon="Refresh" @click="resetAdminQuery">重置</el-button>
            </el-form-item>
          </el-form>

          <el-table v-loading="adminLoading" :data="adminList" class="account-table">
            <el-table-column prop="userId" label="ID" width="76" align="center" />
            <el-table-column prop="userName" label="登录账号" min-width="120" show-overflow-tooltip />
            <el-table-column prop="nickName" label="姓名" min-width="110" show-overflow-tooltip />
            <el-table-column prop="phonenumber" label="联系电话" min-width="120" />
            <el-table-column prop="status" label="状态" width="86" align="center">
              <template #default="{ row }">
                <el-tag :type="row.status === '0' ? 'success' : 'danger'">
                  {{ row.status === '0' ? '正常' : '停用' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="createTime" label="创建时间" width="152">
              <template #default="{ row }">{{ formatTime(row.createTime) }}</template>
            </el-table-column>
            <el-table-column label="操作" width="136" fixed="right" align="center">
              <template #default="{ row }">
                <div class="row-actions">
                  <el-button link type="primary" icon="Edit" @click="openAdminDialog(row)">编辑</el-button>
                  <el-button v-if="row.userId !== 1" link type="danger" icon="Delete" @click="deleteAdmin(row)">删除</el-button>
                </div>
              </template>
            </el-table-column>
          </el-table>
          <pagination
            v-show="adminTotal > 0"
            :total="adminTotal"
            v-model:page="adminQuery.pageNum"
            v-model:limit="adminQuery.pageSize"
            layout="total, prev, pager, next, jumper"
            @pagination="getAdminList"
          />
        </section>
      </el-col>

      <el-col :xs="24" :xl="12">
        <section class="account-panel">
          <div class="panel-header">
            <div>
              <h3>读者账号</h3>
            </div>
            <el-button type="primary" icon="Plus" plain @click="openReaderDialog()">新增读者</el-button>
          </div>

          <el-form :model="readerQuery" :inline="true" label-width="72px" class="query-form">
            <el-form-item label="姓名">
              <el-input v-model="readerQuery.readerName" placeholder="请输入姓名" clearable @keyup.enter="handleReaderQuery" />
            </el-form-item>
            <el-form-item label="联系电话">
              <el-input v-model="readerQuery.readerContact" placeholder="请输入联系电话" clearable @keyup.enter="handleReaderQuery" />
            </el-form-item>
            <el-form-item label="状态">
              <el-select v-model="readerQuery.status" placeholder="全部" clearable style="width: 120px">
                <el-option label="正常" value="NORMAL" />
                <el-option label="停用" value="DISABLED" />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" icon="Search" @click="handleReaderQuery">搜索</el-button>
              <el-button icon="Refresh" @click="resetReaderQuery">重置</el-button>
            </el-form-item>
          </el-form>

          <el-table v-loading="readerLoading" :data="readerList" class="account-table">
            <el-table-column prop="readerId" label="ID" width="76" align="center" />
            <el-table-column prop="readerName" label="姓名" min-width="110" show-overflow-tooltip />
            <el-table-column prop="mobile" label="联系电话" min-width="120" />
            <el-table-column prop="city" label="城市" min-width="110" show-overflow-tooltip />
            <el-table-column label="借阅额度" width="92" align="center">
              <template #default="{ row }">{{ row.maxBorrowCount || 0 }}</template>
            </el-table-column>
            <el-table-column prop="status" label="状态" width="86" align="center">
              <template #default="{ row }">
                <el-tag :type="row.status === 'NORMAL' ? 'success' : 'danger'">
                  {{ row.status === 'NORMAL' ? '正常' : '停用' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="136" fixed="right" align="center">
              <template #default="{ row }">
                <div class="row-actions">
                  <el-button link type="primary" icon="Edit" @click="openReaderDialog(row)">编辑</el-button>
                  <el-button link type="danger" icon="Delete" @click="deleteReaderAccount(row)">删除</el-button>
                </div>
              </template>
            </el-table-column>
          </el-table>
          <pagination
            v-show="readerTotal > 0"
            :total="readerTotal"
            v-model:page="readerQuery.pageNum"
            v-model:limit="readerQuery.pageSize"
            layout="total, prev, pager, next, jumper"
            @pagination="getReaderList"
          />
        </section>
      </el-col>
    </el-row>

    <el-dialog v-model="adminDialog.open" :title="adminDialog.title" width="640px" append-to-body>
      <el-form ref="adminFormRef" :model="adminForm" :rules="adminRules" label-width="96px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="登录账号" prop="userName">
              <el-input v-model="adminForm.userName" :disabled="!!adminForm.userId" maxlength="30" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="姓名" prop="nickName">
              <el-input v-model="adminForm.nickName" maxlength="30" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item :label="adminForm.userId ? '修改密码' : '初始密码'" :prop="adminForm.userId ? undefined : 'password'">
              <el-input v-model="adminForm.password" type="password" maxlength="20" show-password :placeholder="adminForm.userId ? '不填则保持原密码' : '请输入初始密码'" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话" prop="phonenumber">
              <el-input v-model="adminForm.phonenumber" maxlength="11" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="adminForm.email" maxlength="50" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态">
              <el-radio-group v-model="adminForm.status">
                <el-radio value="0">正常</el-radio>
                <el-radio value="1">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="备注">
              <el-input v-model="adminForm.remark" type="textarea" maxlength="200" show-word-limit />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitAdmin">确定</el-button>
          <el-button @click="adminDialog.open = false">取消</el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog v-model="readerDialog.open" :title="readerDialog.title" width="720px" append-to-body>
      <el-form ref="readerFormRef" :model="readerForm" :rules="readerRules" label-width="104px">
        <el-row :gutter="16">
          <el-col :span="12">
            <el-form-item label="登录账号" prop="userName">
              <el-input v-model="readerForm.userName" :disabled="!!readerForm.userId" maxlength="30" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item :label="readerForm.userId ? '修改密码' : '初始密码'" :prop="readerForm.userId ? undefined : 'password'">
              <el-input v-model="readerForm.password" type="password" maxlength="20" show-password placeholder="不填则保持原密码" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="读者姓名" prop="readerName">
              <el-input v-model="readerForm.readerName" maxlength="30" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话" prop="mobile">
              <el-input v-model="readerForm.mobile" maxlength="11" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="readerForm.email" maxlength="50" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="城市">
              <el-input v-model="readerForm.city" maxlength="50" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="年费到期">
              <el-date-picker v-model="readerForm.annualExpireDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态">
              <el-radio-group v-model="readerForm.status">
                <el-radio value="NORMAL">正常</el-radio>
                <el-radio value="DISABLED">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="押金余额">
              <el-input-number v-model="readerForm.depositBalance" :min="0" :precision="2" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="可借数量">
              <el-input-number v-model="readerForm.maxBorrowCount" :min="1" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="寄送额度">
              <el-input-number v-model="readerForm.maxOutboundCount" :min="0" controls-position="right" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="寄回额度">
              <el-input-number v-model="readerForm.maxInboundCount" :min="0" controls-position="right" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitReader">确定</el-button>
          <el-button @click="readerDialog.open = false">取消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { listRole } from '@/api/system/role'
import { addUser, delUser, getUser, listAdminUser, resetUserPwd, updateUser } from '@/api/system/user'
import { deleteReader, getReader, queryReaders, saveReader } from '@/api/library'

const { proxy } = getCurrentInstance()

const DEFAULT_DEPT_ID = 100
const DEFAULT_ADMIN_ROLE_ID = 1

const roleIds = reactive({
  admin: DEFAULT_ADMIN_ROLE_ID,
  reader: 3
})

const adminLoading = ref(false)
const readerLoading = ref(false)
const adminList = ref([])
const readerList = ref([])
const adminTotal = ref(0)
const readerTotal = ref(0)
const adminFormRef = ref()
const readerFormRef = ref()

const adminQuery = reactive({
  pageNum: 1,
  pageSize: 5,
  userName: undefined,
  phonenumber: undefined,
  status: undefined
})

const readerQuery = reactive({
  pageNum: 1,
  pageSize: 5,
  readerName: undefined,
  readerContact: undefined,
  status: undefined
})

const adminDialog = reactive({
  open: false,
  title: ''
})

const readerDialog = reactive({
  open: false,
  title: ''
})

const adminForm = reactive(defaultAdminForm())
const readerForm = reactive(defaultReaderForm())

const adminRules = {
  userName: [{ required: true, message: '登录账号不能为空', trigger: 'blur' }],
  nickName: [{ required: true, message: '姓名不能为空', trigger: 'blur' }],
  password: [{ required: true, message: '初始密码不能为空', trigger: 'blur' }],
  email: [{ type: 'email', message: '邮箱格式不正确', trigger: ['blur', 'change'] }]
}

const readerRules = {
  userName: [{ required: true, message: '登录账号不能为空', trigger: 'blur' }],
  password: [{ required: true, message: '初始密码不能为空', trigger: 'blur' }],
  readerName: [{ required: true, message: '读者姓名不能为空', trigger: 'blur' }],
  email: [{ type: 'email', message: '邮箱格式不正确', trigger: ['blur', 'change'] }]
}

function defaultAdminForm() {
  return {
    userId: undefined,
    userName: undefined,
    nickName: undefined,
    password: undefined,
    phonenumber: undefined,
    email: undefined,
    sex: '2',
    status: '0',
    remark: undefined
  }
}

function defaultReaderForm() {
  return {
    readerId: undefined,
    userId: undefined,
    userName: undefined,
    password: undefined,
    email: undefined,
    readerName: undefined,
    mobile: undefined,
    city: undefined,
    annualExpireDate: undefined,
    depositBalance: 0,
    depositFrozen: 0,
    usedOutboundCount: 0,
    usedInboundCount: 0,
    maxOutboundCount: 6,
    maxInboundCount: 6,
    maxBorrowCount: 3,
    status: 'NORMAL'
  }
}

function assignForm(target, source) {
  Object.keys(target).forEach((key) => {
    target[key] = source[key]
  })
}

function formatTime(value) {
  return value ? proxy.parseTime(value, '{y}-{m}-{d}') : '-'
}

async function loadRoleIds() {
  try {
    const res = await listRole({ pageNum: 1, pageSize: 100 })
    const rows = res.rows || []
    roleIds.admin = rows.find((role) => role.roleKey === 'admin')?.roleId || DEFAULT_ADMIN_ROLE_ID
    roleIds.reader = rows.find((role) => role.roleKey === 'reader')?.roleId || 3
  } catch (error) {
    roleIds.admin = DEFAULT_ADMIN_ROLE_ID
    roleIds.reader = 3
  }
}

function getAdminList() {
  adminLoading.value = true
  listAdminUser(adminQuery).then((res) => {
    const rows = res.rows || []
    adminList.value = rows
    adminTotal.value = Number(res.total || rows.length)
  }).finally(() => {
    adminLoading.value = false
  })
}

function getReaderList() {
  readerLoading.value = true
  queryReaders(readerQuery).then((res) => {
    const data = res.data || {}
    readerList.value = data.records || data.list || []
    readerTotal.value = data.total || 0
  }).finally(() => {
    readerLoading.value = false
  })
}

function handleAdminQuery() {
  adminQuery.pageNum = 1
  getAdminList()
}

function resetAdminQuery() {
  Object.assign(adminQuery, {
    pageNum: 1,
    pageSize: adminQuery.pageSize,
    userName: undefined,
    phonenumber: undefined,
    status: undefined
  })
  getAdminList()
}

function handleReaderQuery() {
  readerQuery.pageNum = 1
  getReaderList()
}

function resetReaderQuery() {
  Object.assign(readerQuery, {
    pageNum: 1,
    pageSize: readerQuery.pageSize,
    readerName: undefined,
    readerContact: undefined,
    status: undefined
  })
  getReaderList()
}

async function openAdminDialog(row) {
  adminFormRef.value?.resetFields()
  assignForm(adminForm, defaultAdminForm())
  if (row?.userId) {
    adminDialog.title = '编辑管理员账号'
    const res = await getUser(row.userId)
    const user = res.data || row
    assignForm(adminForm, {
      ...defaultAdminForm(),
      ...user,
      password: undefined,
      status: user.status ?? '0'
    })
  } else {
    adminDialog.title = '新增管理员账号'
  }
  adminDialog.open = true
}

function submitAdmin() {
  adminFormRef.value.validate(async (valid) => {
    if (!valid) return
    const payload = {
      ...adminForm,
      deptId: DEFAULT_DEPT_ID,
      roleIds: [roleIds.admin],
      postIds: [],
      userType: '00'
    }
    if (payload.userId) {
      const newPassword = payload.password
      delete payload.password
      await updateUser(payload)
      if (newPassword) {
        await resetUserPwd(payload.userId, newPassword)
      }
    } else {
      await addUser(payload)
    }
    proxy.$modal.msgSuccess('保存成功')
    adminDialog.open = false
    getAdminList()
  })
}

function deleteAdmin(row) {
  proxy.$modal.confirm(`确认删除管理员账号“${row.userName}”？`).then(() => delUser(row.userId)).then(() => {
    proxy.$modal.msgSuccess('删除成功')
    getAdminList()
  })
}

async function openReaderDialog(row) {
  readerFormRef.value?.resetFields()
  assignForm(readerForm, defaultReaderForm())
  if (row?.readerId) {
    readerDialog.title = '编辑读者账号'
    const res = await getReader(row.readerId)
    const reader = res.data || row
    assignForm(readerForm, {
      ...defaultReaderForm(),
      ...reader,
      password: undefined,
      status: reader.status || 'NORMAL'
    })
    if (reader.userId) {
      try {
        const userRes = await getUser(reader.userId)
        const user = userRes.data || {}
        readerForm.userName = user.userName
        readerForm.email = user.email
      } catch (error) {
        readerForm.userName = undefined
      }
    }
  } else {
    readerDialog.title = '新增读者账号'
  }
  readerDialog.open = true
}

function submitReader() {
  readerFormRef.value.validate(async (valid) => {
    if (!valid) return
    await saveReader({
      ...readerForm,
      accountStatus: readerForm.status === 'NORMAL' ? '0' : '1'
    })
    proxy.$modal.msgSuccess('保存成功')
    readerDialog.open = false
    getReaderList()
  })
}

function deleteReaderAccount(row) {
  proxy.$modal.confirm(`确认删除读者账号“${row.readerName}”？`).then(() => deleteReader(row.readerId)).then(() => {
    proxy.$modal.msgSuccess('删除成功')
    getReaderList()
  })
}

loadRoleIds().finally(() => {
  getAdminList()
  getReaderList()
})
</script>

<style scoped>
.account-admin-page {
  min-height: calc(100vh - 84px);
  background: var(--el-bg-color-page);
}

.account-grid {
  align-items: stretch;
}

.account-grid :deep(.el-col) {
  margin-bottom: 16px;
}

.account-panel {
  height: 100%;
  padding: 16px;
  background: var(--el-bg-color);
  border: 1px solid var(--el-border-color-light);
  border-radius: 6px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.08);
}

.panel-header {
  display: flex;
  gap: 12px;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 14px;
}

.panel-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: var(--el-text-color-primary);
}

.query-form {
  padding: 12px 12px 0;
  margin-bottom: 12px;
  background: var(--el-fill-color-lighter);
  border-radius: 4px;
}

.account-table {
  width: 100%;
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

@media (max-width: 768px) {
  .panel-header {
    flex-direction: column;
  }

  .panel-header .el-button {
    width: 100%;
  }
}
</style>

<template>
  <div class="app-container admin-rules">
    <el-card shadow="always" class="rule-card">
      <template #header>
        <div class="card-header">
          <span>借阅与配送规则</span>
          <el-button type="primary" icon="Check" @click="submitRule">保存规则</el-button>
        </div>
      </template>

      <el-form ref="formRef" :model="form" :rules="rules" label-width="120px" class="rule-form">
        <el-form-item label="图书馆城市" prop="libraryCity" class="span-2">
          <el-input v-model="form.libraryCity" placeholder="例如：中山市" />
        </el-form-item>
        <el-form-item label="状态" class="span-2">
          <el-select v-model="form.status" style="width: 100%">
            <el-option label="启用" value="ENABLED" />
            <el-option label="停用" value="DISABLED" />
          </el-select>
        </el-form-item>
        <el-form-item label="年度服务费">
          <el-input-number v-model="form.annualFee" :min="0" :precision="2" controls-position="right" />
        </el-form-item>
        <el-form-item label="押金标准">
          <el-input-number v-model="form.depositAmount" :min="0" :precision="2" controls-position="right" />
        </el-form-item>
        <el-form-item label="最长外借天数">
          <el-input-number v-model="form.maxLoanDays" :min="1" controls-position="right" />
        </el-form-item>
        <el-form-item label="最大在借数量">
          <el-input-number v-model="form.maxBorrowCount" :min="1" controls-position="right" />
        </el-form-item>
        <el-form-item label="年度馆方寄出">
          <el-input-number v-model="form.annualOutboundLimit" :min="0" controls-position="right" />
        </el-form-item>
        <el-form-item label="年度读者寄回">
          <el-input-number v-model="form.annualInboundLimit" :min="0" controls-position="right" />
        </el-form-item>
        <el-form-item label="逾期费/天">
          <el-input-number v-model="form.overdueFeePerDay" :min="0" :precision="2" controls-position="right" />
        </el-form-item>
        <el-form-item label="损坏赔偿">
          <el-input-number v-model="form.damageFee" :min="0" :precision="2" controls-position="right" />
        </el-form-item>
        <el-form-item label="遗失赔偿">
          <el-input-number v-model="form.lostFee" :min="0" :precision="2" controls-position="right" />
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup name="AdminRules">
import { getCurrentInstance, onMounted, reactive, ref } from 'vue'
import { getActiveRule, saveRule } from '@/api/library'

const { proxy } = getCurrentInstance()

const formRef = ref(null)

const form = reactive({
  ruleId: undefined, libraryCity: undefined, annualFee: 0, depositAmount: 0,
  maxLoanDays: 30, annualOutboundLimit: 6, annualInboundLimit: 6, maxBorrowCount: 3,
  overdueFeePerDay: 1, damageFee: 50, lostFee: 100, status: 'ENABLED'
})

const rules = { libraryCity: [{ required: true, message: '图书馆所在城市不能为空', trigger: 'blur' }] }

function cleanPayload(data) {
  return Object.fromEntries(Object.entries(data).filter(([, v]) => v !== undefined && v !== null && v !== ''))
}

function submitRule() {
  formRef.value.validate(valid => {
    if (!valid) return
    saveRule(cleanPayload(form)).then(() => {
      proxy.$modal.msgSuccess('规则保存成功')
    })
  })
}

onMounted(() => {
  getActiveRule().then(res => {
    Object.assign(form, { ...form, ...(res.data || {}) })
  }).catch(() => {})
})
</script>

<style scoped lang="scss">
.admin-rules {
  .rule-card {
    width: 100%;
    border-radius: 6px;
  }

  .card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-weight: 700;
  }

  .rule-form {
    display: grid;
    grid-template-columns: repeat(4, minmax(220px, 1fr));
    gap: 18px 28px;
    align-items: start;
  }

  .rule-form :deep(.el-form-item) {
    margin-bottom: 0;
  }

  .span-2 {
    grid-column: span 2;
  }

  :deep(.el-input-number) {
    width: 100%;
  }

  @media (max-width: 1280px) {
    .rule-form {
      grid-template-columns: repeat(2, minmax(220px, 1fr));
    }
  }

  @media (max-width: 768px) {
    .rule-form {
      grid-template-columns: 1fr;
    }

    .span-2 {
      grid-column: span 1;
    }
  }
}
</style>

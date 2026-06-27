<template>
  <div class="app-container dashboard">
    <el-row :gutter="16" class="dashboard-stats">
      <el-col v-for="card in statCards" :key="card.key" :xs="12" :sm="12" :md="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div :class="['stat-icon', card.iconClass]">
              <el-icon :size="32"><component :is="card.icon" /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ statistics[card.key] }}</div>
              <div class="stat-label">{{ card.label }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="16" class="dashboard-main">
      <el-col :xs="24" :lg="8">
        <el-card class="chart-card" shadow="always">
          <template #header>
            <div class="card-header">
              <span>图书分类统计</span>
            </div>
          </template>
          <div ref="categoryChartRef" class="chart-container"></div>
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="8">
        <el-card class="chart-card" shadow="always">
          <template #header>
            <div class="card-header">
              <span>近7日借阅趋势</span>
            </div>
          </template>
          <div ref="borrowTrendChartRef" class="chart-container"></div>
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="8">
        <el-card class="table-card compact-table-card" shadow="always">
          <template #header>
            <div class="card-header">
              <span>借阅排行榜 & 热门图书</span>
            </div>
          </template>
          <el-table class="ranking-table" :data="hotBooks" height="274" style="width: 100%">
            <el-table-column label="排名" width="64" align="center">
              <template #default="{ $index }">
                <el-tag :type="$index < 3 ? 'danger' : 'info'" effect="dark">{{ $index + 1 }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="title" label="书名" min-width="120" show-overflow-tooltip />
            <el-table-column prop="author" label="作者" width="110" show-overflow-tooltip />
            <el-table-column prop="borrowCount" label="次数" width="76" align="center" />
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="16" class="dashboard-tables">
      <el-col :xs="24">
        <el-card class="table-card" shadow="always">
          <template #header>
            <div class="card-header">
              <span>最新入库</span>
              <el-button type="primary" link @click="viewAllBooks">查看全部</el-button>
            </div>
          </template>
          <el-table :data="newBooks" style="width: 100%">
            <el-table-column prop="title" label="书名" min-width="220" show-overflow-tooltip />
            <el-table-column prop="author" label="作者" min-width="160" show-overflow-tooltip />
            <el-table-column prop="categoryName" label="分类" width="160" />
            <el-table-column prop="createdTime" label="入库时间" width="140" align="center" />
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="Index">
import { computed, nextTick, onBeforeUnmount, onMounted, ref } from 'vue'
import { CircleCheck, DocumentChecked, Menu, Reading } from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import { useRouter } from 'vue-router'
import { getDashboard } from '@/api/library'
import useUserStore from '@/store/modules/user'

const router = useRouter()
const userStore = useUserStore()
const categoryChartRef = ref(null)
const borrowTrendChartRef = ref(null)
let categoryChart
let borrowTrendChart

const statistics = ref({
  totalBooks: 0,
  availableBooks: 0,
  borrowedBooks: 0,
  totalCategories: 0
})
const categoryStats = ref([])
const borrowTrend = ref([])
const hotBooks = ref([])
const newBooks = ref([])

const statCards = [
  { key: 'totalBooks', label: '总图书数', icon: Reading, iconClass: 'book-icon' },
  { key: 'availableBooks', label: '可借图书', icon: CircleCheck, iconClass: 'available-icon' },
  { key: 'borrowedBooks', label: '已借出', icon: DocumentChecked, iconClass: 'borrowed-icon' },
  { key: 'totalCategories', label: '分类数量', icon: Menu, iconClass: 'category-icon' }
]

const bookListPath = computed(() => {
  const roles = userStore.roles || []
  return roles.includes('reader') && !roles.includes('admin') ? '/library/reader/index' : '/library/admin/books'
})

function loadDashboard() {
  getDashboard().then(res => {
    const data = res.data || {}
    statistics.value = { ...statistics.value, ...(data.statistics || {}) }
    categoryStats.value = data.categoryStats || []
    borrowTrend.value = data.borrowTrend || []
    hotBooks.value = data.hotBooks || []
    newBooks.value = data.newBooks || []
    nextTick(renderCharts)
  }).catch(() => {
    nextTick(renderCharts)
  })
}

function renderCharts() {
  renderCategoryChart()
  renderBorrowTrendChart()
}

function renderCategoryChart() {
  if (!categoryChartRef.value) return
  if (!categoryChart) {
    categoryChart = echarts.init(categoryChartRef.value)
  }
  const sortedCategories = [...categoryStats.value]
    .filter(item => Number(item.value) > 0)
    .sort((a, b) => Number(b.value) - Number(a.value))
  const visibleCategories = sortedCategories.slice(0, 8)
  const otherValue = sortedCategories.slice(8).reduce((sum, item) => sum + Number(item.value || 0), 0)
  const categoryData = otherValue > 0
    ? [...visibleCategories, { name: '其他', value: otherValue }]
    : visibleCategories
  categoryChart.setOption({
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    grid: { top: 12, left: 92, right: 38, bottom: 20 },
    xAxis: {
      type: 'value',
      minInterval: 1,
      splitLine: { lineStyle: { color: '#edf1f7' } },
      axisLabel: { color: '#909399' }
    },
    yAxis: {
      type: 'category',
      inverse: true,
      data: categoryData.map(item => item.name),
      axisTick: { show: false },
      axisLine: { show: false },
      axisLabel: {
        color: '#606266',
        width: 76,
        overflow: 'truncate'
      }
    },
    series: [
      {
        name: '图书数量',
        type: 'bar',
        barWidth: 14,
        data: categoryData.map(item => item.value),
        itemStyle: {
          borderRadius: [0, 7, 7, 0],
          color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
            { offset: 0, color: '#6aa5ff' },
            { offset: 1, color: '#45d6b5' }
          ])
        },
        label: {
          show: true,
          position: 'right',
          color: '#606266',
          fontWeight: 600
        }
      }
    ]
  })
}

function renderBorrowTrendChart() {
  if (!borrowTrendChartRef.value) return
  if (!borrowTrendChart) {
    borrowTrendChart = echarts.init(borrowTrendChartRef.value)
  }
  borrowTrendChart.setOption({
    tooltip: { trigger: 'axis' },
    grid: { top: 24, left: 36, right: 16, bottom: 30 },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: borrowTrend.value.map(item => item.label)
    },
    yAxis: { type: 'value', minInterval: 1 },
    series: [
      {
        name: '借阅次数',
        type: 'line',
        smooth: true,
        symbolSize: 6,
        data: borrowTrend.value.map(item => item.value),
        itemStyle: { color: '#409EFF' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(64, 158, 255, 0.38)' },
            { offset: 1, color: 'rgba(64, 158, 255, 0.02)' }
          ])
        }
      }
    ]
  })
}

function resizeCharts() {
  categoryChart?.resize()
  borrowTrendChart?.resize()
}

function viewAllBooks() {
  router.push(bookListPath.value)
}

onMounted(() => {
  loadDashboard()
  window.addEventListener('resize', resizeCharts)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', resizeCharts)
  categoryChart?.dispose()
  borrowTrendChart?.dispose()
})
</script>

<style scoped lang="scss">
.dashboard {
  padding: 14px;

  .dashboard-stats,
  .dashboard-main {
    margin-bottom: 14px;
  }

  .stat-card,
  .chart-card,
  .table-card {
    border-radius: 6px;
  }

  .stat-content {
    display: flex;
    align-items: center;
    justify-content: space-around;
    height: 78px;
  }

  .stat-icon {
    width: 58px;
    height: 58px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;

    &.book-icon {
      background: linear-gradient(135deg, #5b7cfa 0%, #8b5cf6 100%);
    }

    &.available-icon {
      background: linear-gradient(135deg, #f472b6 0%, #fb7185 100%);
    }

    &.borrowed-icon {
      background: linear-gradient(135deg, #38bdf8 0%, #22d3ee 100%);
    }

    &.category-icon {
      background: linear-gradient(135deg, #34d399 0%, #2dd4bf 100%);
    }
  }

  .stat-info {
    text-align: center;
  }

  .stat-value {
    font-size: 30px;
    font-weight: 700;
    color: #303133;
    line-height: 36px;
  }

  .stat-label {
    color: #909399;
    font-size: 14px;
  }

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-weight: 600;
    color: #303133;
  }

  .chart-container {
    width: 100%;
    height: 300px;
  }

  .dashboard-main .chart-card,
  .dashboard-main .compact-table-card {
    height: 100%;
  }

  .compact-table-card :deep(.el-card__body) {
    height: 300px;
    overflow: hidden;
  }

  .ranking-table {
    height: 100%;
  }

  :deep(.el-card__header) {
    padding: 12px 16px;
  }

  :deep(.el-card__body) {
    padding: 14px 16px;
  }

  :deep(.el-table .el-table__cell) {
    padding: 7px 0;
  }
}
</style>

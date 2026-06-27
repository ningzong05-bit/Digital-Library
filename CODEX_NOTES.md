# Codex 项目交接笔记

这份文档面向后续继续接手本项目的 Codex 或开发者，用来快速恢复上下文。公开展示请看 `README.md`。

## 当前工作区

- 工作区根目录：`D:\zinc\JAVA EE 实训\zsc(2)`
- 当前 Git 分支：`zn_v1`
- 远端仓库：`https://gitee.com/zhou-zhiji12/javaee.git`
- 当前主后端：`zsc_backend_v2`
- 当前主前端：`zsc_frontend`
- 旧版/备份目录：`zsc_backend`、`zsc_backend_v1`

注意：`zsc_backend` 和 `zsc_backend_v1` 是本地未跟踪目录，不要误提交。

## 最新进展（2026-06-26）

- 首页 `/index` 已改为真实接口驱动：新增后端 `GET /api/library/dashboard`，返回总册数、可借数、在借数、分类统计、近 7 日借阅趋势、借阅排行榜 & 热门图书前 10、最新入库 5 条；前端首页不再使用硬编码假数据。
- 首页“查看全部”按真实角色分流：纯读者跳 `/library/reader/index`，管理员跳 `/library/admin/books`。
- 管理端借阅订单筛选改为网格排版，图书 ID 为自由输入，默认每页 7 条；排队管理图书 ID 改为自由输入；读者端“我的借阅”默认每页 7 条。
- 数据概览待处理订单只取最新 6 条，按钮文案为“查看所有订单”；概览卡片统计已按全量当前数据汇总。
- 新增 `tools/seed_realistic_library_data.sql`，可重复清理并重建图书、地址、借阅订单、排队、配送、费用样本数据。当前本地库已导入：36 本真实书籍、154 册、12 类，9 个读者全部为“中山市”地址，40 条 2026-04-26 至 2026-06-26 范围内的类真实借还记录。
- 数据样本中读者“赵六”押金 120 元且有 180 元待赔付，状态为 `DISABLED`，用于验证押金不足且存在待赔偿时不可新借的链路。

## 架构总览

### 侧边栏路由来源（两套独立机制）

| 来源 | 机制 | 角色 |
|------|------|------|
| `sys_menu` 表 → 后端 `getRouters()` | 若依菜单系统，`selectMenuTreeAll()` 对 admin 返回全部 `status=0` 的菜单 | 管理员 |
| `router/index.js` → `baseRoutes` / `readerRoutes` / `constantRoutes` | 前端硬编码路由，应用启动即加载；侧边栏由 `permission.js` 按端组装 | 基础路由所有用户，读者菜单仅 reader |

读者端三个页面（图书浏览、我的借阅、个人资料）在 `readerRoutes` 中定义为三个独立的一级菜单项，与首页平级；`constantRoutes = baseRoutes.concat(readerRoutes)` 仅用于路由注册。管理员菜单原始数据仍来自 `sys_menu`，但 `permission.js` 会在前端展示层把“系统管理”“图书馆管理”的二级菜单提升为一级菜单，并把“用户管理 / 角色管理 / 读者管理”合并为单页“账号管理”入口。

**关键坑**：`auth.js` 的 `authRole()` 中 `super_admin === v` 使 admin 角色通过所有 `roles` 检查。因此读者侧边栏不能依赖路由 `roles: ['reader']` 过滤，而是在 `permission.js` 里按真实角色数组做端隔离：`reader && !admin` 才拼入 `readerRoutes`。

### 系统菜单清理

已通过 `UPDATE sys_menu SET status = '1'` 禁用以下无用菜单：
系统监控（在线用户/定时任务/数据监控/服务监控/缓存监控/缓存列表）、系统工具（表单构建/代码生成/系统接口）、菜单管理、部门管理、岗位管理、字典管理、参数设置、通知公告。

保留功能：账号管理（管理员账号 CRUD + 读者账号 CRUD）、日志管理、数据概览、图书管理、借阅订单、排队管理、规则配置。侧边栏不再展示“系统管理”“图书馆管理”两个一级父菜单。

## 已完成事项

### 后端 — 26 个 API 端点

接口统一前缀 `/api/library`，全部 `@Transactional` 按读写分离：

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/books/query` | 分页查询图书 |
| GET  | `/books/{bookId}` | 查询图书详情 |
| POST | `/books` | 新增/修改图书 |
| GET  | `/dashboard` | 首页统计、图表、排行榜、最新入库聚合 |
| POST | `/readers/query` | 分页查询读者 |
| GET  | `/readers/{readerId}` | 查询读者详情 |
| GET  | `/readers/by-user/{userId}` | 按系统用户 ID 获取或创建读者 |
| GET  | `/readers/by-mobile/{mobile}` | 按手机号查读者（含 sys_user 回退） |
| POST | `/readers/sync` | 手动同步 reader 角色用户 |
| POST | `/readers` | 新增/修改读者 |
| DELETE | `/readers/{readerId}` | 删除读者（检查进行中订单） |
| GET  | `/readers/{readerId}/summary` | 读者借阅概览（结构化字段） |
| POST | `/addresses` | 新增/修改地址（保证默认地址唯一） |
| GET  | `/addresses/{addressId}` | 查询地址 |
| GET  | `/addresses/by-reader/{readerId}` | 查询读者所有地址 |
| DELETE | `/addresses/{addressId}` | 删除地址 |
| POST | `/borrow/online` | 线上借书（支持自由文本地址） |
| POST | `/queues/join` | 加入排队 |
| POST | `/queues/query` | 分页查询排队 |
| POST | `/orders/query` | 分页查询订单 |
| POST | `/orders/confirm-fulfillment` | 馆员确认借出 |
| POST | `/orders/request-return` | 读者发起还书 |
| POST | `/orders/confirm-return` | 馆员确认归还 |
| POST | `/orders/pay-compensation` | 读者用押金缴纳待赔偿 |
| POST | `/fees/pay` | 缴费/充值 |
| GET  | `/rules/active` | 当前借阅规则 |
| POST | `/rules` | 新增/修改规则 |

核心服务文件：
- `CloudLibraryController.java` — 控制器
- `CloudLibraryService.java` / `CloudLibraryServiceImpl.java` — 服务层
- `LibraryDto.java` — DTO（BorrowRequest/QueueRequest 含 `receiverAddress` 字段）
- `LibraryConstants.java` — 状态常量

关键设计：
- `@PostConstruct init()` 启动时自动同步 reader 角色用户到 `library_reader`
- `buildDefaultReader()` 公共方法消除重复代码
- `getReaderByMobile()` 先在 `library_reader.mobile` 查，找不到则 JOIN `sys_user.phonenumber` 并自动同步
- `saveAddress()` 保证每个读者只有一个默认地址
- `deleteReader()` 检查进行中订单，有则阻止删除；读者账号页删除读者时同步处理 reader 角色登录账号
- `saveReader()` 可接收 `userName/password/email/accountStatus`，新增/编辑读者时同步维护 `sys_user` 并绑定 reader 角色

### 前端

技术栈：Vue 3 + Vite + Element Plus + Pinia + Vue Router + Axios

#### 管理端（管理员可见）

菜单原始数据来自 `sys_menu` 表，侧边栏由 `permission.js` 扁平化为一级菜单，不再显示"系统管理"和"图书馆管理"父菜单：

| 路径 | 页面 | 功能 |
|------|------|------|
| `/library/admin/accounts` | 账号管理 | 单页维护管理员账号和读者账号的增删改查；界面不再暴露部门、岗位、角色管理等系统模板字段 |
| `/library/admin/overview` | 数据概览 | 读者/图书/订单/排队统计 + 当前规则 |
| `/library/admin/books` | 图书管理 | 增删改查（已移除借书/排队按钮） |
| `/library/admin/orders` | 借阅订单 | 查询、确认借出、确认归还 |
| `/library/admin/queues` | 排队管理 | 查询排队记录 |
| `/library/admin/rules` | 规则配置 | 借阅天数、年费、押金、邮寄次数 |
| `/system/log` | 日志管理 | 操作日志、登录日志 |

#### 读者端（读者可见）

在 `readerRoutes` 中定义，与首页平级的三个一级菜单：

| 路径 | 菜单名 | 功能 |
|------|--------|------|
| `/library/reader/index` | 图书浏览 | 搜索图书、详情、借书（联系电话+收货地址下拉+新增地址弹窗）、排队 |
| `/library/reader/borrows` | 我的借阅 | 查询订单、发起还书，自动关联 readerId |
| `/library/reader/profile` | 个人资料 | 整合三表合一：基本信息+额度+订单统计，收货地址 CRUD |

#### 核心前端文件

| 文件 | 说明 |
|------|------|
| `router/index.js` | `baseRoutes` 含公共路由，`readerRoutes` 含读者三页面，`constantRoutes` 用于注册全部静态路由；`dynamicRoutes` 含系统动态路由和 `/library/admin/accounts` 合并页 |
| `store/modules/permission.js` | `getClientSidebarRoutes()` 按真实角色隔离管理端/读者端侧边栏；`buildAdminMenuRoutes()` 扁平化管理端菜单并合并账号入口；`filterDynamicRoutes` 含 else 分支（无权限标记路由默认放行） |
| `api/library.js` | 图书馆业务 API 函数，对应后端 `/api/library` 端点 |
| `views/library/admin/*.vue` | 管理端页面；`accounts.vue` 是统一账号页，直接维护管理员账号与读者账号 |
| `views/library/reader/*.vue` | 读者端 3 页面 |

#### 借书弹窗设计

- 书名（灰色禁用输入框）→ 联系电话 → 取书方式 → 收货地址（下拉选择已有地址 + "新增地址"按钮弹出完整地址表单）→ 备注
- 可借时排队按钮灰色，无库存时借书按钮灰色
- 提交时通过联系电话查 readerId，再执行借书/排队

## 数据库

### 业务表（`cloud_library_v2.sql`）

| 表 | 说明 |
|----|------|
| `library_rule` | 借阅规则（城市/年费/押金/外借天数/次数上限/罚金） |
| `library_book` | 图书（ISBN/书名/馆藏数/可借数/排队数） |
| `library_reader` | 读者（user_id→sys_user/姓名/手机号/押金/年费到期） |
| `library_address` | 邮寄地址（读者ID/收件人/城市/详细地址/默认标记） |
| `library_borrow_order` | 借阅订单（订单号/借阅方式/状态/借还日期/赔付） |
| `library_queue_record` | 排队记录（排队位置/预计可借日期/轮候转订单） |
| `library_delivery_record` | 物流记录（寄出/寄回/快递单号/签收） |
| `library_fee_record` | 费用记录（年费/押金/逾期/损坏/遗失） |

### sys_user ↔ library_reader 关联

`library_reader.user_id` → `sys_user.user_id`。启动时 `@PostConstruct` 自动将 `role_key='reader'` 的用户同步到 `library_reader`。

### 种子数据

导入顺序：`zsc.sql` → `cloud_library_v2.sql` → `cloud_library_roles.sql`

- `cloud_library_v2.sql` — DROP + CREATE 8 张业务表，插入 1 条规则 + 3 本测试图书
- `cloud_library_roles.sql` — 创建 reader 角色，禁用无用菜单，创建管理员菜单+权限，创建测试读者账号 + library_reader 记录
- `tools/seed_realistic_library_data.sql` — 当前真实化演示数据脚本；保留账号，只重置图书、地址、借阅、排队、配送、费用业务数据。路径包含空格时推荐复制到无空格临时目录后用 mysql `source` 导入，避免 PowerShell 管道把中文转码成问号。

### 测试账号

```
管理员：admin  / admin123
读者：  reader / reader123（已预建 library_reader 记录，押金300元）
```

## 本机环境

- JDK：`D:\major\toor\jdk-17.0.2`
- Maven：`D:\apache-maven-3.9.14`
- MySQL：`D:\major\toor\mysql-8.4.4`（root 空密码，数据库 zsc）
- Redis：`D:\zinc\tools\redis-3.2.100`（空密码，端口 6379）

## 启动

```powershell
# 1. Redis
redis-server

# 2. 后端（端口 8081）
cd "D:\zinc\JAVA EE 实训\zsc(2)\zsc_backend_v2"
mvn -pl zsc-admin spring-boot:run -DskipTests

# 3. 前端（端口 80）
cd "D:\zinc\JAVA EE 实训\zsc(2)\zsc_frontend"
npm run dev
```

首次运行需先 `mvn install -DskipTests`。
Maven 报 JDK 错误时：`$env:JAVA_HOME="D:\major\toor\jdk-17.0.2"; $env:Path="$env:JAVA_HOME\bin;$env:Path"`

访问：http://127.0.0.1/（代理：`/dev-api` → `http://localhost:8081`）

## SQL 导入

```powershell
cd "D:\zinc\JAVA EE 实训\zsc(2)\zsc_backend_v2"
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS zsc DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
cmd /c "mysql -uroot --default-character-set=utf8mb4 zsc < sql\zsc.sql"
cmd /c "mysql -uroot --default-character-set=utf8mb4 zsc < sql\cloud_library_v2.sql"
cmd /c "mysql -uroot --default-character-set=utf8mb4 zsc < sql\cloud_library_roles.sql"
```

注意：`cloud_library_v2.sql` 含 `DROP TABLE IF EXISTS library_*`。

## 重要坑点

1. **PowerShell 重定向**：用 `cmd /c "mysql ... < xxx.sql"`，不能直接用 `<`

2. **Redis 必须先启动**：登录验证码、缓存、权限依赖 Redis

3. **`selectMenuTreeAll()` 绕过 role_menu**：若依框架对 admin（`SecurityUtils.isAdmin`）直接返回全部菜单，不受 `sys_role_menu` 限制。禁用菜单需直接设 `sys_menu.status = '1'`

4. **`authRole()` 的 super_admin 特权**：`auth.js` 中 admin 角色通过所有 `authRole()` 检查，因此 `filterDynamicRoutes` 的 `roles` 过滤对 admin 无效

5. **循环依赖**：`permission.js` → `router` → `layout` → `permission.js`。新增公共/读者路由时优先放在 `baseRoutes` / `readerRoutes`，新增端侧边栏规则时放在 `permission.js`，避免新增跨模块 import

6. **`constantRoutes` 中引用的 Vue 文件必须存在**：否则 Vite import analysis 直接崩溃，整个应用白屏

7. **sys_user ≠ library_reader**：两张独立表，通过 `user_id` 关联。读者端页面通过 `getOrCreateReader` 按需创建

## Git 状态

已推送 `zn_v1`：`b1b3aca`、`bb837a5`、`9babab8`、`69b64e1`

刻意未提交：`zsc_backend`、`zsc_backend_v1`、`node_modules`、`target`、`dist`
## 2026-06-25 full-link regression and fixes

Latest request scope: follow `文档/云端图书馆借阅系统V2.0.docx` and `C:/Users/zinc/Desktop/链路设计测试表.docx`, run multi-round full-link tests, fill missing backend links, and keep this note updated.

Document extraction:
- Added `tools/extract_docx_text.py`.
- Extracted the two docx files into `codex_doc_extract.md`.
- The link table covers tourist browsing, login/permission, reader profile/address, book search/detail, self-pickup borrow, library shipment borrow, no-stock queue and auto conversion, reader borrow/delivery records, library return, shipped return, book entry/edit/offline, fulfillment, return inspection, queue exception handling, overdue/damage compensation, reader/category/rule/notice/stat/log management.

Backend fixes completed:
- Captcha remains disabled for local testing in `SysLoginService`, `CaptchaController`, and `sys_config`.
- `LibraryDto` now accepts date strings for reader annual expiry and supports `yyyy-MM-dd`, `yyyy-MM-dd HH:mm:ss`, and common ISO formats, fixing calendar-picker update failures.
- `CloudLibraryController` exposes the missing API surface:
  - `DELETE /api/library/books/{bookId}`
  - `POST /api/library/queues/handle`
  - `GET /api/library/deliveries/by-reader/{readerId}`
  - `GET /api/library/deliveries/by-order/{orderId}`
  - `GET /api/library/fees/by-reader/{readerId}`
- `CloudLibraryServiceImpl` now:
  - Merges duplicate ISBN book entries by increasing `total_count` and `available_count` instead of creating duplicate rows.
  - Blocks book delete/offline while active borrow orders or active queue records exist.
  - Allows delete after all borrow records are finished.
  - Validates address city during address save, not only at borrow time.
  - Keeps queue count synchronized after join, cancel/exception, and auto-conversion.
  - Supports manual queue handling: `WAITING`, `EXCEPTION`, `CANCELLED`; converted queues are protected.
  - Records and exposes library outbound delivery, reader return delivery, and fee records.
- Frontend API wrapper `zsc_frontend/src/api/library.js` includes the new backend endpoints.

Regression script:
- Added `tools/run_library_link_tests.ps1`.
- Important: PowerShell 5 can corrupt non-ASCII JSON request bodies unless encoded explicitly. The script sends JSON as UTF-8 bytes.
- The script prepares reader capacity through the API before testing, because historical test data can leave active orders that correctly count against max borrow limits.

Verified command sequence:
- Stop old backend on 8081 first, otherwise `clean package` can fail because `zsc-admin.jar` is locked.
- Build: `mvn -pl zsc-admin -am -DskipTests clean package`
- Start: `java -jar zsc_backend_v2/zsc-admin/target/zsc-admin.jar`
- Regression: `powershell -ExecutionPolicy Bypass -File tools/run_library_link_tests.ps1`

Latest regression result:
- Build passed on 2026-06-25 21:18.
- Backend jar PID during verification: 41716, port 8081.
- Final full-link script result: `ALL_LINK_TESTS_PASSED`.
- Covered scenarios:
  - admin and zhangsan login
  - reader detail query
  - cross-city address rejection
  - same-city address save
  - duplicate ISBN merge
  - active-book offline/delete block
  - self-pickup borrow, fulfillment, return request, return inspection, final `RETURNED` record
  - returned-book delete allowed
  - library shipment fulfillment delivery record
  - reader shipped return plus damage compensation fee record
  - queue auto-conversion to borrow order after returned copy becomes available
  - manual queue cancellation
  - reader borrow-history query includes `RETURNED`, `WAIT_PICKUP`, `COMPENSATION_PENDING`, `WAIT_SHIP`, `BORROWING`, `RETURNING`
  - delivery and fee query endpoints return real data
- Last clean run produced examples: returned order `26`, ship order `27`, auto-converted queue `12` to order `29`, cancelled queue `13`.

Operational note:
- For this project, prefer testing the packaged jar after `clean package`. Earlier failures came from running a stale packaged app where newly added module endpoints were not present.

## 2026-06-25 contact-centric UI/order cleanup

Latest request scope: polish reader/admin library workflows after screenshots:
- Reader book detail buttons are stock-aware: available stock enables borrow and disables queue; no available stock disables borrow and enables queue.
- Reader/admin table action buttons now use horizontal `.row-actions` layout for edit/delete style actions.
- Admin borrow-order return flow is library-return only: removed reader mail-return option, tracking number, carrier, and mail date; the date field is now return date.
- Reader business lookup is contact-centric. Admin reader/account/order/queue search uses reader contact instead of reader ID; account tables merge user ID/mobile into one contact column; order table hides the internal ID column.
- Order query now returns display fields `readerName`, `readerContact`, and `bookName`.
- Completed `RETURNED` orders are sorted behind unfinished orders; unfinished orders sort by latest update/create time.
- `OrderQuery.pendingOnly=true` returns only unfinished orders, and admin overview pending list uses this flag.
- Admin overview layout was compacted into summary cards plus current rules/pending orders, reducing the large blank area.

Backend files touched:
- `zsc-module/src/main/java/com/zsc/module/domain/dto/LibraryDto.java`
- `zsc-module/src/main/java/com/zsc/module/domain/entity/LibraryBorrowOrder.java`
- `zsc-module/src/main/java/com/zsc/module/domain/entity/LibraryQueueRecord.java`
- `zsc-module/src/main/java/com/zsc/module/service/impl/CloudLibraryServiceImpl.java`

Frontend files touched:
- `zsc_frontend/src/views/library/reader/index.vue`
- `zsc_frontend/src/views/library/reader/borrows.vue`
- `zsc_frontend/src/views/library/reader/profile.vue`
- `zsc_frontend/src/views/library/admin/accounts.vue`
- `zsc_frontend/src/views/library/admin/books.vue`
- `zsc_frontend/src/views/library/admin/orders.vue`
- `zsc_frontend/src/views/library/admin/queues.vue`
- `zsc_frontend/src/views/library/admin/readers.vue`
- `zsc_frontend/src/views/library/admin/index.vue`

Verification after clean jar rebuild:
- Backend build: `mvn -pl zsc-admin -am -DskipTests clean package` passed at 2026-06-25 22:09.
- Backend restarted from clean packaged jar, PID `66100`, port `8081`.
- API checks passed:
  - `orders-contact-filter`
  - `pending-no-returned`
  - `orders-display-fields`
  - `returned-bottom-window`
  - `queues-contact-filter`
  - `readers-contact-filter`
- Full link regression passed again:
  - `powershell -ExecutionPolicy Bypass -File tools/run_library_link_tests.ps1`
  - Result: `ALL_LINK_TESTS_PASSED`
  - Latest examples: returned order `31`, ship order `32`, auto-converted queue `14` to order `34`, cancelled queue `15`.
- Frontend build: `npm run build:prod` passed.
- Browser UI smoke on `http://localhost/` passed:
  - Admin orders page shows `读者联系方式`, hides internal ID/order ID search, and no longer shows logistics/carrier fields in the return dialog.
  - Admin return dialog labels are `还书方式`, `还书日期`, `备注`; return type is fixed to `到馆还书`.
  - Admin overview pending orders do not include `已归还`.
  - Reader book detail dialog: available copy enables `我要借书` and disables `加入排队`; no available copy disables `我要借书` and enables `加入排队`.

## 2026-06-26 compensation/payment, order table, nav cleanup

Latest request scope: align admin/reader borrow order tables, add reader name column, implement the compensation payment chain, cap reader addresses at 5, hide RuoYi top-right tools, promote login log, and re-run compensation regression.

Backend changes:
- Added `POST /api/library/orders/pay-compensation` with `CompensationPayRequest`.
- `COMPENSATION_PENDING` orders can be paid with deposit. If deposit is insufficient, backend returns a recharge-gap message; after successful deposit payment the order becomes `RETURNED`.
- Borrow qualification now requires deposit balance at least `199.00` and blocks users with pending compensation orders.
- `getReader` / `readerSummary` return effective status `DISABLED` when a normal reader has unpaid compensation, so profile no longer shows "正常" in that state.
- Address saving blocks the 6th address per reader. Current DB was cleaned so no reader has more than 5 addresses; stale `default_address_id` values pointing to deleted addresses were nulled.
- Active rule deposit amount in DB and `cloud_library_v2.sql` was updated to `199.00`.

Frontend changes:
- Admin borrow order table adds `借阅读者` after `订单号`; `订单号` is left aligned, compensation amount is left aligned, all other table headers/content are centered.
- Admin and reader order tables changed `开始/应还` to `开始/应还/实还` with three same-weight date rows.
- Admin `COMPENSATION_PENDING` operation text is `待读者缴纳`; ended orders show `订单已结束`.
- Reader `我的借阅` shows `付款` for pending compensation. The payment dialog supports `押金赔偿` and includes a placeholder `充值押金` button for the future recharge page/API.
- Reader completed orders show `订单已结束`; local table hover background was disabled to avoid stale grey rows after pagination.
- Reader profile has a `充值押金` placeholder button, disables new address at 5, and warns if opening the dialog beyond the limit.
- RuoYi top-right navbar now hides global search, source, docs, theme mode, size selector, fullscreen, and avatar dropdown `布局设置`; Element Plus global size is forced to `default`.
- Admin sidebar order is `首页 / 数据概览 / 图书管理 / 借阅订单 / 排队管理 / 账号管理 / 规则配置 / 登录日志`.

SQL/data actions run against local `zsc`:
- Disabled `sys_menu.menu_id=500`.
- Promoted `sys_menu.menu_id=501` to first level and kept it enabled.
- Updated active `library_rule.deposit_amount` to `199.00`.
- Deleted extra `library_address` rows beyond the newest/default-prioritized 5 per reader; final check returned no reader with more than 5 addresses.

Verification:
- Frontend build passed: `npm run build:prod`.
- Backend build passed after stopping the old jar on port `8081`: `mvn -pl zsc-admin -am -DskipTests clean package`.
- Backend restarted from packaged jar; latest PID during verification: `60332`, port `8081`.
- Full link regression passed: `powershell -ExecutionPolicy Bypass -File tools/run_library_link_tests.ps1`.
  - Result: `ALL_LINK_TESTS_PASSED`.
  - New compensation checks passed: pending order creation, effective `DISABLED` status, insufficient-deposit block, borrow block while unpaid, and deposit payment closing the order as `RETURNED`.
  - Latest examples: returned order `36`, ship order `37`, compensation order `38`, auto-converted queue `16` to order `40`, cancelled queue `17`.
- Browser UI smoke on `http://127.0.0.1/` passed:
  - Admin orders headers include `订单号`, `借阅读者`, `开始/应还/实还`, `赔偿`, `操作`.
  - Top-right search/source/docs/theme/size/fullscreen controls are absent; avatar remains.
  - Admin sidebar order is correct and includes top-level `登录日志`.
  - Admin orders `重置` interaction kept the table rendered and produced no console errors.
  - Reader borrows route renders with `开始/应还/实还`; in the admin login smoke state it has no reader data, which is expected.

## 2026-06-26 profile recharge and admin UI polish

Latest request scope: remove reader profile contact query box, add a deposit recharge dialog for testing, tighten admin overview layout, simplify admin order filters, remove account subtitles, add consistent card shadows, move the top-right avatar left, fix default page sizes, and fold admin password reset into edit.

Frontend changes:
- Reader profile removed the top contact/query form. The profile and address cards now use visible card shadows.
- Reader profile `充值押金` opens a dialog with a free numeric amount input and calls `POST /api/library/fees/pay` using `feeType=DEPOSIT_RECHARGE`; no upper limit is set in the UI.
- Admin business overview now stacks `当前借阅规则` above a larger `待处理订单` table, increases pending order fetch size to 12, and uses card shadows on summary/rules/pending cards.
- Admin borrow orders changed `图书ID` from number stepper to free text input, removed the `取书` filter, kept search/reset on the same row, fixed default page size to 6, and hid the page-size selector.
- Admin account management removed section subtitles, uses 5 rows/page for admin and reader lists, hides the page-size selector, removes the row-level password reset action, and exposes optional `修改密码` inside the admin edit dialog.
- Admin book list defaults to 14 rows/page and hides the page-size selector.
- Admin queue list defaults to 15 rows/page and hides the page-size selector.
- Top-right avatar/account component moved left by increasing the avatar wrapper offset.

Verification:
- Frontend build passed: `npm run build:prod`.
- Frontend dev server restarted for browser QA on port `80`; latest observed PID `62320`.
- Browser QA on `http://localhost/` passed with no relevant console errors:
  - Business overview renders rules above pending orders; pending card height is `520px`; overview card shadows are present.
  - Admin borrow orders has free text `请输入图书ID`, no `取书` filter, no `条/页` selector, search/reset on the same row, and 6 rendered rows.
  - Account management subtitles are absent; account panels have shadows; reader list renders 5 rows; row-level reset action is absent; admin edit dialog contains `修改密码` with placeholder `不填则保持原密码`.
  - Book management renders 14 rows and no `条/页` selector.
  - Queue management renders 15 rows and no `条/页` selector.
  - Reader profile no longer has the contact query form. Recharge dialog opens with default `199.00`, accepted a `0.01` test recharge, showed success, and refreshed the displayed deposit from `￥300.00` to `￥300.01` for the current test profile.

## 2026-06-26 dashboard/title/date polish and git handoff

Latest request scope: shrink the homepage ranking card, fix reader pagination controls, update page title/brand wording, make recharge amount integer-only, rename business overview to data overview, display dates only to day precision, update README/CODEX notes, and commit the work.

Changes completed:
- Homepage ranking card now has the same height as the adjacent chart cards, removes the `查看全部` action, uses an internal scroll area, and shows the top 10 `借阅排行榜 & 热门图书` rows.
- Homepage latest入库 now reads 5 rows from `GET /api/library/dashboard`; backend dashboard keeps `hotBooks` at 10 and `newBooks` at 5.
- Reader `图书浏览` is fixed at 14 rows/page and reader `我的借阅` is fixed at 7 rows/page; both hide the page-size selector.
- Top gray breadcrumb now shows the current page title, e.g. `图书管理` / `图书浏览` / `我的借阅`, instead of staying on `首页`.
- Sidebar brand text is role-aware: pure reader sees `云上图书馆`; admin/management side sees `云上图书馆管理后台`. `.env` titles and package description were updated to the management title.
- Reader profile recharge dialog changed from `el-input-number` to a normal input with integer-only filtering; typing `12.5abc` becomes `125`.
- Admin menu `业务概览` was renamed to `数据概览` in local `sys_menu` and `cloud_library_roles.sql`.
- Library date displays and date pickers now use day precision only (`YYYY-MM-DD`) in the changed library pages.
- README was updated for the `云上图书馆` naming, dashboard endpoint, reader/admin entry points, and current completed scope.

Verification:
- Database update succeeded: `sys_menu.menu_id=2001` is now `数据概览`.
- Frontend build passed: `npm run build:prod`.
- Backend compile passed: `mvn -pl zsc-admin -am -DskipTests compile`.
- Backend packaged successfully after stopping the old jar: `mvn -pl zsc-admin -am -DskipTests package`.
- Backend restarted from packaged jar on port `8081`; latest verification PID `21536`.
- Browser QA on `http://127.0.0.1/` passed:
  - Admin homepage shows `154 / 139 / 15 / 12` stats, ranking top 10, no ranking `查看全部`, latest入库 5 rows, and matching chart/ranking card heights.
  - Admin sidebar shows `数据概览`; brand is `云上图书馆管理后台`.
  - Admin book page gray breadcrumb is `图书管理`, renders 14 rows, hides `条/页`, and dates display as `YYYY-MM-DD`.
  - Reader book page gray breadcrumb is `图书浏览`, renders 14 rows, and hides `条/页`.
  - Reader borrow page gray breadcrumb is `我的借阅`, hides `条/页`, and all borrow dates are date-only.
  - Reader profile recharge dialog has no number spinner and filters non-digits from the amount input.

## 2026-06-26 dashboard chart/ranking correction and no-residue regression

Latest request scope: correct the homepage ranking behavior so the card height matches adjacent charts while the ranking table itself scrolls, redesign overcrowded category statistics, run full-link tests without leaving test data, update docs, commit, and push.

Changes completed:
- Homepage `图书分类统计` was redesigned from an overcrowded doughnut chart into a horizontal bar chart. It sorts categories by count and groups categories after the first 8 into `其他`, avoiding overlapping labels.
- Homepage middle cards now share the same rendered height. `图书分类统计`, `近7日借阅趋势`, and `借阅排行榜 & 热门图书` all render at the same card height in browser QA.
- Ranking data still loads the top 10, but the ranking `el-table` has its own fixed height. It fully shows rows 1-6 and uses the table's internal scrollbar for rows 7-10.
- Ranking card still has no `查看全部` action; latest入库 now shows 5 rows.
- README was updated with the corrected dashboard behavior and no-residue test note.

Verification:
- Frontend build passed: `npm run build:prod`.
- Browser QA on `http://127.0.0.1/index` passed with no console errors:
  - Three middle cards measured `379px` high.
  - Ranking table had 10 rows, 6 fully visible rows, internal scrolling enabled.
  - Latest入库 rendered 5 rows.

## 2026-06-26 dashboard row-count tweak

Latest request scope: show 6 visible rows inside the homepage ranking table, show 5 rows in latest入库, update README/CODEX_NOTES, and commit.

Changes completed:
- Homepage ranking table height increased so rows 1-6 are visible while rows 7-10 remain available through the table's internal scroll.
- Backend dashboard `newBooks` limit changed from 6 back to 5.
- README and CODEX_NOTES were updated to reflect the new row counts.

Verification:
- Frontend build passed: `npm run build:prod`.
- Backend package passed with JDK 17 after refreshing `zsc-admin/target`: `mvn -pl zsc-admin -DskipTests package`.
- Runtime dashboard API verification returned `hotBooks=10` and `newBooks=5`.

## 2026-06-26 admin-reader separation and profile/rules polish

Latest request scope: prevent administrators from also acting as readers, clear administrator-linked reader business data, merge reader profile pages into a single personal center, remove visible department ownership, redesign the admin personal center and rule configuration page, update docs, and commit.

Changes completed:
- Admin users are no longer allowed to become reader accounts. Reader auto-sync now excludes users with the `admin` role, reader binding rejects admin users, and lazy reader creation throws `管理员账号不能同时作为读者使用` for admin accounts.
- Added `tools/cleanup_admin_reader_data.sql` to clean reader-side data for admin users, including borrow orders, queues, addresses, delivery records, fee records, reader rows, and accidental reader role bindings. The script also recalculates book available and queue counts.
- Ran the cleanup against the local `zsc` database. Verification returned `afterAdminReaderConflicts=0` and `adminReaderRoleBindings=0`.
- Reader-side `个人资料` has been merged and renamed to `个人中心`; the top-right avatar dropdown now routes pure readers to `/library/reader/profile` and admins to `/user/profile`.
- Admin personal center was rebuilt as a compact card-based layout with avatar, account details, role tag, editable basic info, and password tab. Visible `所属部门` fields were removed.
- The global visible `所属部门` label was removed from the online-user page as part of the department display cleanup.
- Rule configuration was redesigned as a full-width shadow card with a wider responsive grid, matching the other business panels.
- Date JSON parsing now accepts day-only values (`yyyy-MM-dd`) as well as the previous datetime format, and library order DTO date fields use day precision for receive/fulfillment actions.
- README was updated with the admin-reader isolation, personal center, rule page, and date compatibility notes.

Verification:
- Frontend production build passed: `npm run build:prod`.
- Backend package passed with JDK 17: `mvn -pl zsc-admin -am -DskipTests package`.
- Local JDBC cleanup verification passed with no remaining administrator-reader conflicts.

## 2026-06-26 logo alignment, reader center compaction, and captcha restore

Latest request scope: align the global cloud-library logo/title to the left, reduce blank space in the reader personal center and reader benefits card, restore the previous login captcha flow, clean project clutter, update README/CODEX notes, and commit.

Changes completed:
- Replaced the sidebar brand asset with the new transparent cloud-book logo and kept it proportional at `42x30`.
- Sidebar brand containers now align logo and text from the left in both reader and management titles; collapsed sidebar still centers the icon.
- Reader personal center was compacted: removed forced equal-height top cards, reduced avatar/summary spacing, lowered account and metric font sizes, and shortened reader-benefit metric blocks.
- Login captcha was restored end to end:
  - `zsc_backend_v2` captcha controller now reads `sys.account.captchaEnabled` instead of hard-coding captcha disabled.
  - Local database config `sys.account.captchaEnabled` was set back to `true`.
  - Frontend login cookie restoration now preserves `code` and `uuid`, then fetches a fresh captcha.
- Cleaned generated `zsc_backend_v2/tmp-jar-check*` directories and added `**/tmp-jar-check*/` to `.gitignore`.

Verification:
- Frontend build passed: `npm run build:prod`.
- Backend package passed with JDK 17 after restarting the locked jar: `mvn -pl zsc-admin -am -DskipTests package`.
- Backend restarted from the rebuilt jar on port `8081`; `/captchaImage` returns `captchaEnabled=true`, a `uuid`, and base64 image data.
- Browser QA:
  - Reader profile page renders with left-aligned logo/title (`logo x=20`, title x=74), no console errors, and compact reader benefits card (`readerCard h=221`, metric min-height `62px`).
  - Login page on `http://localhost/login` renders the login form, the captcha input, and a base64 captcha image with no console errors.

## 2026-06-26 reader center restyle, branding, login page, and global text cleanup

Latest request scope: restyle the reader personal center layout (avatar left, info right, aligned cards, no large whitespace), remove reader role tag, rename admin sidebar title, customize login page title/subtitle/defaults, update copyright footer, compact the reader status tag, and globally replace contact/phone field labels.

Changes completed:

### 读者个人中心布局重构 (`views/library/reader/profile.vue`)
- 顶部两张卡片改为等宽弹性布局：`el-row :gutter="16" type="flex"`，左右各 `el-col :xs="24" :lg="12"`，子列 `display: flex` + 卡片 `flex: 1` 实现等高。
- 个人中心卡内部从垂直堆叠改为水平 flex：左侧头像 80px（`avatar-wrap`），右侧账号信息区（`account-info`）包含姓名+标签行和 2×2 网格账号项。
- 删除了个人中心卡中的"读者"角色标签（`el-tag`）及对应 `.role-tag` CSS。
- 读者权益卡从 4 列改为 2 列水平排列（`reader-summary-grid { grid-template-columns: repeat(2, minmax(0, 1fr)) }`），标签宽度 `fit-content`，减少卡片留白。
- 读者状态标签保持原位（网格独立项），但改为紧凑小标签样式：`size="small" effect="light"` + CSS `width: fit-content`，不再横向拉伸。
- 头像垂直居中：`account-summary { align-items: center }`，配合 `margin-top: -6px` 微调头像和右侧信息区上移。
- 账号信息项（`account-item`）放大为 `padding: 12px 14px`、`font-size: 14px`、2 列网格 `repeat(2, 1fr)`，减少底部空白。

### 管理端品牌标题 (`layout/components/Sidebar/Logo.vue`, `.env.*`, `package.json`)
- 管理端侧边栏标题从"云上图书馆管理后台"改为"后台管理中心"。
- `Logo.vue` 角色判断：纯读者显示"云上图书馆"，管理端显示"后台管理中心"。
- `.env.development`、`.env.production` 的 `VITE_APP_TITLE` 同步更新为"后台管理中心"。
- `package.json` 的 `description` 同步更新为"后台管理中心"。

### 登录页定制 (`views/login.vue`)
- 标题从环境变量读取改为硬编码 `<h3 class="title">云上图书馆</h3>`。
- 新增欢迎副标题 `<p class="subtitle">欢迎来到云上图书馆</p>`（14px、#999 灰色、居中）。
- 移除默认填充的账号密码：`loginForm.username` 和 `loginForm.password` 初始值为空字符串。
- 删除了 `const title = import.meta.env.VITE_APP_TITLE`，避免标题联动。

### 版权页脚 (`settings.js`)
- `footerContent` 更新为 `'Copyright © 2026 云上图书馆. All Rights Reserved.'`，与系统品牌一致。

### 全局文本替换（11 个文件）
- "联系方式" → "联系电话"：`accounts.vue`(8)、`orders.vue`(3)、`queues.vue`(3)、`readers.vue`(4)、`borrows.vue`(2)。
- "手机号码" → "联系电话"：`userInfo.vue`(3)、`system/user/index.vue`(7)、`system/role/authUser.vue`(2)、`system/role/selectUser.vue`(2)、`system/dept/index.vue`(1，验证提示)。
- "联系手机" → "联系电话"：`profile.vue` 中已完成。

### 重要教训
- 用户要求"只改样式"时，严格限定改动范围，不要移动元素位置或做额外重构。曾被纠正把读者状态标签从网格项移到姓名行内联，正确做法是保持原位只改样式属性。

Verification:
- Frontend build passed: `npm run build:prod`.

## 2026-06-26 dynamic browser tab title and favicon

Latest request scope: make the browser tab title dynamic based on page/role (login → 云上图书馆, admin → 后台管理中心, reader → 云上图书馆), and replace the favicon with the sidebar cloud-book logo.

Changes completed:

### 动态标签页标题 (`utils/dynamicTitle.js`, `permission.js`, `.env.*`)
- `.env.development`、`.env.production` 的 `VITE_APP_TITLE` 改回 `云上图书馆` 作为默认基础标题。
- `package.json` 的 `description` 同步改回 `云上图书馆`。
- `dynamicTitle.js` 新增用户角色检测：`userStore.roles.includes('admin')` 时使用 `后台管理中心` 作为基础标题，否则使用默认的 `云上图书馆`。`dynamicTitle` 配置仍为 `false`，标签页只显示基础标题，不拼接页面名。
- `permission.js` 路由守卫中，登录页路径显式设置 `document.title = '云上图书馆'`，确保未登录状态下标签页标题正确。

### 页签图标 (`index.html`, `public/logo.png`)
- 将侧边栏使用的云书 logo（`src/assets/logo/logo.png`）复制到 `public/logo.png`。
- `index.html` 中 `<link rel="icon" href="/favicon.ico">` 改为 `<link rel="icon" href="/logo.png">`，与侧边栏品牌图标保持一致。

Verification:
- Frontend build passed: `npm run build:prod`.

## 2026-06-27 realistic seed data state coverage

Latest request scope: enrich local business demo data so testing can cover more real states, especially books that are fully borrowed and require queueing, disabled data, unpaid compensation, and other edge states.

Changes completed:
- Updated `tools/seed_realistic_library_data.sql` and re-imported it into the local `zsc` database.
- Added an enabled no-stock book: `人工智能：一种现代方法` (`book_id=37`) with `total_count=1`, `available_count=0`, `queue_count=1`.
- Added a matching active borrow order for `book_id=37`, so its only copy is genuinely borrowed out; added one `WAITING` queue record and one `EXCEPTION` queue record for the same book.
- Added a disabled book sample: `重构：改善既有代码的设计` (`book_id=38`) for stop-borrow/offline display and filtering.
- Added broader status samples: disabled historical rule, disabled address, expired annual-fee reader, low-deposit reader, reader max-borrow-limit sample, annual-fee payment, deposit recharge, overdue fee, damage fee, lost/unpaid fee, and explicit unpaid compensation records.
- The seed script remains repeatable. Because the project path contains Chinese characters/spaces, importing through a temporary ASCII path is still the safest approach for MySQL `source`.

Verification:
- Local import passed using MySQL 8.4 client against database `zsc`.
- Book status counts: `ENABLED=37`, `DISABLED=1`.
- Queue-required book check passed: `人工智能：一种现代方法` has `total_count=1`, `available_count=0`, `queue_count=1`, active order count `1`, and queue statuses `WAITING=1`, `EXCEPTION=1`.
- Order statuses covered: `WAIT_PICKUP`, `WAIT_SHIP`, `BORROWING`, `RETURNING`, `RETURNED`, `COMPENSATION_PENDING`.
- Queue statuses covered: `WAITING`, `CONVERTED`, `EXCEPTION`, `CANCELLED`.
- Delivery statuses covered: `CREATED`, `SHIPPED`, `RECEIVED`.
- Fee types/statuses covered: `ANNUAL_FEE`, `DEPOSIT_RECHARGE`, `OVERDUE`, `DAMAGE`, `LOST`, `COMPENSATION`; both `PAID` and `UNPAID`.

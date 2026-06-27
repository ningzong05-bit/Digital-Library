# 云上图书馆借阅系统 V2.0

云上图书馆借阅系统 V2.0 是一个面向读者、图书馆管理员和系统管理员的在线图书借阅平台。项目基于若依风格后台框架改造，完成了从图书浏览、线上借阅、同城邮寄、无库存排队、归还验收、押金赔付到后台统计管理的完整业务闭环。

当前 V2 版本已完结，前后端已联调通过，可作为 Java EE 实训项目的最终展示版本。

## 项目目录

当前主项目只需要关注两个目录：

```text
zsc_backend_v2/     后端主项目，Spring Boot + MyBatis-Plus + MySQL + Redis
zsc_frontend/       前端主项目，Vue 3 + Vite + Element Plus
```

仓库中的旧版后端目录、过程文档、截图和临时文件仅用于历史参考，不属于 V2 主运行版本。

## 技术栈

后端：

- JDK 17
- Spring Boot 3
- Maven 多模块
- MyBatis-Plus
- MySQL 8
- Redis
- Druid
- SpringDoc / Swagger

前端：

- Vue 3
- Vite
- Element Plus
- Pinia
- Vue Router
- Axios
- ECharts

## V2 完成功能

### 读者端

- 图书浏览、关键词搜索、分类查看和图书详情查看。
- 支持到馆自取和图书馆同城邮寄两种借阅方式。
- 图书有库存时可直接下单，无库存时可加入排队。
- 读者可查看自己的借阅订单、订单状态、应还日期、赔偿金额。
- 支持读者发起还书、选择到馆归还或用户寄回。
- 个人中心整合账号信息、押金余额、年费状态、借阅统计和收货地址管理。
- 支持读者端押金充值登记，便于测试赔付和余额不足流程。

### 管理端

- 数据概览：首页统计总册数、可借数、在借数、分类统计、近 7 日借阅趋势、借阅排行榜、热门图书和最新入库。
- 图书管理：图书新增、编辑、上下架、库存维护和状态展示。
- 借阅订单：查询订单，确认自取/寄出，发起或确认归还，验收损坏和遗失赔偿。
- 排队管理：查看排队记录，处理等待、异常、取消和已转订单状态。
- 读者与账号管理：维护管理员账号、读者账号、读者押金、年费、状态和地址。
- 规则配置：维护馆藏城市、年费、最低押金、最长借阅天数、邮寄次数上限、最大同时借阅数、逾期费用、损坏和遗失赔偿标准。
- 日志管理：保留登录日志和操作日志入口。

### 业务规则

- 管理员账号与读者账号已隔离，管理员不能同时作为读者借阅。
- 借阅前校验读者状态、年费有效期、押金余额、最大同时借阅数、待赔付订单。
- 同城邮寄校验收货地址城市是否与图书馆所在城市一致。
- 图书无库存时进入排队；归还后可按排队顺序转成借阅订单。
- 还书验收支持正常、损坏、遗失和逾期赔偿。
- 押金不足或存在未还赔偿时，读者会被阻止继续新借。

## 核心代码

后端核心文件：

```text
zsc_backend_v2/zsc-module/src/main/java/com/zsc/module/controller/CloudLibraryController.java
zsc_backend_v2/zsc-module/src/main/java/com/zsc/module/service/CloudLibraryService.java
zsc_backend_v2/zsc-module/src/main/java/com/zsc/module/service/impl/CloudLibraryServiceImpl.java
zsc_backend_v2/zsc-module/src/main/java/com/zsc/module/domain/dto/LibraryDto.java
zsc_backend_v2/zsc-module/src/main/java/com/zsc/module/domain/entity/Library*.java
zsc_backend_v2/zsc-module/src/main/java/com/zsc/module/mapper/Library*.java
```

前端核心文件：

```text
zsc_frontend/src/views/index.vue
zsc_frontend/src/views/library/admin/*.vue
zsc_frontend/src/views/library/reader/*.vue
zsc_frontend/src/api/library.js
zsc_frontend/src/router/index.js
zsc_frontend/src/store/modules/permission.js
```

## 数据库

默认数据库配置：

```text
数据库：zsc
用户名：root
密码：空
端口：3306
```

主要 SQL 文件：

```text
zsc_backend_v2/sql/zsc.sql
zsc_backend_v2/sql/cloud_library_v2.sql
zsc_backend_v2/sql/cloud_library_roles.sql
```

导入顺序：

```powershell
cd "zsc_backend_v2"
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS zsc DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
cmd /c "mysql -uroot --default-character-set=utf8mb4 zsc < sql\zsc.sql"
cmd /c "mysql -uroot --default-character-set=utf8mb4 zsc < sql\cloud_library_v2.sql"
cmd /c "mysql -uroot --default-character-set=utf8mb4 zsc < sql\cloud_library_roles.sql"
```

PowerShell 中建议使用 `cmd /c "mysql ... < xxx.sql"` 执行重定向，避免 `<` 被 PowerShell 解析。

业务表包括：

- `library_rule`
- `library_book`
- `library_reader`
- `library_address`
- `library_borrow_order`
- `library_queue_record`
- `library_delivery_record`
- `library_fee_record`

## 启动方式

### 1. 启动 Redis

```powershell
redis-server
```

### 2. 启动后端

```powershell
cd "zsc_backend_v2"
mvn -pl zsc-admin -am -DskipTests package
java -jar zsc-admin\target\zsc-admin.jar
```

后端默认地址：

```text
http://localhost:8081
```

### 3. 启动前端

```powershell
cd "zsc_frontend"
npm install
npm run dev
```

前端默认地址：

```text
http://127.0.0.1/
```

生产构建：

```powershell
npm run build:prod
```

## 测试账号

```text
管理员：admin / admin123
读者：reader / reader123
```

登录页已恢复验证码流程，若本地配置开启验证码，需要输入页面显示的验证码。

## 接口概览

图书馆业务接口统一前缀：

```text
/api/library
```

常用接口：

- `GET /api/library/dashboard`：首页数据概览
- `POST /api/library/books/query`：分页查询图书
- `POST /api/library/books`：新增或修改图书
- `DELETE /api/library/books/{bookId}`：删除图书
- `POST /api/library/readers/query`：分页查询读者
- `POST /api/library/readers`：新增或修改读者
- `GET /api/library/readers/{readerId}/summary`：读者借阅概览
- `POST /api/library/addresses`：新增或修改地址
- `POST /api/library/fees/pay`：缴费或押金充值
- `POST /api/library/borrow/online`：线上借阅
- `POST /api/library/queues/join`：加入排队
- `POST /api/library/queues/query`：查询排队
- `POST /api/library/queues/handle`：处理排队状态
- `POST /api/library/orders/query`：查询订单
- `POST /api/library/orders/confirm-fulfillment`：确认交付
- `POST /api/library/orders/request-return`：发起还书
- `POST /api/library/orders/confirm-return`：确认归还和验收
- `POST /api/library/orders/pay-compensation`：支付待赔付费用
- `GET /api/library/rules/active`：查询当前规则
- `POST /api/library/rules`：保存规则

## 界面完成度

- 读者端显示品牌为“云上图书馆”。
- 管理端显示品牌为“后台管理中心”。
- 浏览器标签页标题会按登录页、读者端和管理端自动切换。
- 侧边栏、个人中心、规则页、数据概览、订单页、排队页和图书页已完成 V2 展示样式。
- 首页图表已接入真实接口数据，不再使用硬编码假数据。
- 借阅排行榜显示前 10 条，表格内部可滚动；最新入库显示 5 条。

## 完结状态

V2 已完成以下验证：

- 后端 Maven 打包通过：`mvn -pl zsc-admin -am -DskipTests package`
- 前端生产构建通过：`npm run build:prod`
- 全链路接口回归通过，覆盖登录、读者资料、地址、借阅、排队、交付、还书、赔偿、物流、费用、规则和统计。
- 浏览器页面检查通过，核心页面无明显控制台错误。
- 本地演示数据已覆盖正常、停用、待自取、待寄出、借阅中、归还中、已归还、待赔付、排队中、已转订单、异常排队、已取消、物流创建、物流寄出、物流签收、已支付和未支付等状态。

## 项目说明

本仓库 V2 版本以 `zsc_backend_v2` 和 `zsc_frontend` 为最终项目主体。运行、评审和展示时请优先使用这两个目录及本 README 中的启动步骤。

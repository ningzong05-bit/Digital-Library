# 本地一致数据导出

`zsc_local_full_2026-06-27.sql` 是从当前本机 MySQL `zsc` 数据库完整导出的上线测试数据，包含系统表、图书馆业务表、菜单、角色、账号、借阅、排队、费用和物流记录。

导入示例：

```powershell
mysql -uroot --default-character-set=utf8mb4 < database\zsc_local_full_2026-06-27.sql
```

导出时的关键业务表数量：

| 表名 | 数量 |
| --- | ---: |
| `library_book` | 38 |
| `library_reader` | 8 |
| `library_borrow_order` | 41 |
| `library_queue_record` | 10 |
| `library_fee_record` | 10 |

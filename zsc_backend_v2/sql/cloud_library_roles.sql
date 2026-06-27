-- ============================================================
-- 云上图书馆角色、菜单权限与测试账号兼容脚本
--
-- 当前仓库 SQL 已按本地 zsc 数据库重建：
--   1. zsc.sql              包含系统表、角色、菜单、账号、配置等当前本地快照
--   2. cloud_library_v2.sql 包含图书馆业务表及当前本地演示数据快照
--   3. biz_category.sql     包含业务分类表当前本地快照
--
-- 因此本文件保留为旧导入流程兼容占位：
--   zsc.sql -> cloud_library_v2.sql -> cloud_library_roles.sql
--
-- 不再重复 INSERT 读者角色、图书馆菜单、reader 测试账号或 library_reader
-- 记录，避免在新快照导入后产生主键冲突或重复读者数据。
-- ============================================================

SELECT 'cloud_library_roles.sql is already included in zsc.sql snapshot' AS message;

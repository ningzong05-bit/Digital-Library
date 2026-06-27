-- MySQL dump 10.13  Distrib 8.4.4, for Win64 (x86_64)
--
-- Host: localhost    Database: zsc
-- ------------------------------------------------------
-- Server version	8.4.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `zsc`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `zsc` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `zsc`;

--
-- Table structure for table `biz_category`
--

DROP TABLE IF EXISTS `biz_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_category` (
  `category_id` bigint NOT NULL AUTO_INCREMENT COMMENT '类别ID',
  `category_name` varchar(100) NOT NULL COMMENT '类别名称',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='业务类别表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_category`
--

LOCK TABLES `biz_category` WRITE;
/*!40000 ALTER TABLE `biz_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `biz_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `library_address`
--

DROP TABLE IF EXISTS `library_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `library_address` (
  `address_id` bigint NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `reader_id` bigint NOT NULL COMMENT '读者ID',
  `receiver_name` varchar(64) NOT NULL COMMENT '收件人',
  `receiver_mobile` varchar(32) DEFAULT NULL COMMENT '收件电话',
  `city` varchar(64) NOT NULL COMMENT '城市',
  `district` varchar(64) DEFAULT NULL COMMENT '区县',
  `detail_address` varchar(255) NOT NULL COMMENT '详细地址',
  `default_flag` tinyint NOT NULL DEFAULT '0' COMMENT '是否默认地址',
  `status` varchar(32) NOT NULL DEFAULT 'ENABLED' COMMENT '状态',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`address_id`),
  KEY `idx_library_address_reader` (`reader_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='读者邮寄地址表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library_address`
--

LOCK TABLES `library_address` WRITE;
/*!40000 ALTER TABLE `library_address` DISABLE KEYS */;
INSERT INTO `library_address` VALUES (1,1,'读者张三','13900000000','中山市','石岐街道','孙文中路197号附近 3栋502',1,'ENABLED','2026-06-01 09:00:00','2026-06-26 09:30:00'),(2,4,'李思','13900002001','中山市','东区街道','兴中道8号附近 2座806',1,'ENABLED','2026-06-01 09:00:00','2026-06-26 09:30:00'),(3,5,'王五','13900002002','中山市','西区街道','彩虹大道16号D区 5栋1201',1,'ENABLED','2026-06-01 09:00:00','2026-06-26 09:30:00'),(4,6,'赵六','13900002003','中山市','南区街道','城南一路12号 1栋704',1,'ENABLED','2026-06-01 09:00:00','2026-06-26 09:30:00'),(5,7,'钱七','13900002004','中山市','火炬开发区','会展东路1号德仲广场 2幢702',1,'ENABLED','2026-06-01 09:00:00','2026-06-26 09:30:00'),(6,8,'孙八','13900002005','中山市','小榄镇','民安中路163号 6栋901',1,'ENABLED','2026-06-01 09:00:00','2026-06-26 09:30:00'),(7,9,'周九','13900002006','中山市','古镇镇','中兴大道南1号 4栋603',1,'ENABLED','2026-06-01 09:00:00','2026-06-26 09:30:00'),(8,10,'吴十','13900002007','中山市','三乡镇','雅居乐花园柏丽广场 8栋1102',1,'ENABLED','2026-06-01 09:00:00','2026-06-26 09:30:00'),(16,1,'读者张三','13900000000','中山市','石岐街道','旧住址已搬迁，保留用于停用地址筛选测试',0,'DISABLED','2025-12-20 09:00:00','2026-06-26 09:35:00');
/*!40000 ALTER TABLE `library_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `library_book`
--

DROP TABLE IF EXISTS `library_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `library_book` (
  `book_id` bigint NOT NULL AUTO_INCREMENT COMMENT '图书ID',
  `isbn` varchar(64) DEFAULT NULL COMMENT 'ISBN',
  `book_name` varchar(128) NOT NULL COMMENT '图书名称',
  `author` varchar(128) DEFAULT NULL COMMENT '作者',
  `publisher` varchar(128) DEFAULT NULL COMMENT '出版社',
  `category_name` varchar(64) DEFAULT NULL COMMENT '分类',
  `cover_url` varchar(512) DEFAULT NULL COMMENT '封面地址',
  `description` text COMMENT '简介',
  `total_count` int NOT NULL DEFAULT '0' COMMENT '馆藏总数',
  `available_count` int NOT NULL DEFAULT '0' COMMENT '可借数量',
  `queue_count` int NOT NULL DEFAULT '0' COMMENT '当前排队人数',
  `status` varchar(32) NOT NULL DEFAULT 'ENABLED' COMMENT '状态',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`book_id`),
  KEY `idx_library_book_name` (`book_name`),
  KEY `idx_library_book_isbn` (`isbn`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='图书馆图书表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library_book`
--

LOCK TABLES `library_book` WRITE;
/*!40000 ALTER TABLE `library_book` DISABLE KEYS */;
INSERT INTO `library_book` VALUES (1,'9787530221532','活着','余华','北京十月文艺出版社','中国文学','','余华长篇小说代表作。',6,5,1,'ENABLED','2026-04-26 09:10:00','2026-06-26 09:50:00'),(2,'9787536692930','三体','刘慈欣','重庆出版社','科幻文学','','中国科幻文学代表作。',6,5,1,'ENABLED','2026-04-26 09:12:00','2026-06-26 09:50:00'),(3,'9787536693968','三体2：黑暗森林','刘慈欣','重庆出版社','科幻文学','','三体系列第二部。',5,5,0,'ENABLED','2026-04-27 10:00:00','2026-06-26 09:50:00'),(4,'9787229030933','三体3：死神永生','刘慈欣','重庆出版社','科幻文学','','三体系列第三部。',5,5,0,'ENABLED','2026-04-27 10:08:00','2026-06-26 09:50:00'),(5,'9787020002207','红楼梦','曹雪芹、高鹗','人民文学出版社','古典文学','','中国古典长篇小说。',5,4,1,'ENABLED','2026-04-28 10:10:00','2026-06-26 09:50:00'),(6,'9787020098095','围城','钱钟书','人民文学出版社','中国文学','','现代文学经典。',4,4,0,'ENABLED','2026-04-29 11:00:00','2026-06-26 09:50:00'),(7,'9787530216781','平凡的世界','路遥','北京十月文艺出版社','中国文学','','现实主义长篇小说。',6,5,0,'ENABLED','2026-04-30 09:40:00','2026-06-26 09:50:00'),(8,'9787544258609','白夜行','东野圭吾','南海出版公司','悬疑推理','','日本推理小说。',4,4,0,'ENABLED','2026-05-01 09:40:00','2026-06-26 09:50:00'),(9,'9787544270878','解忧杂货店','东野圭吾','南海出版公司','外国文学','','温情长篇小说。',4,3,0,'ENABLED','2026-05-02 09:40:00','2026-06-26 09:50:00'),(10,'9787544241694','嫌疑人X的献身','东野圭吾','南海出版公司','悬疑推理','','推理小说代表作。',4,4,0,'ENABLED','2026-05-03 09:40:00','2026-06-26 09:50:00'),(11,'9787208061644','追风筝的人','卡勒德·胡赛尼','上海人民出版社','外国文学','','阿富汗题材长篇小说。',5,5,0,'ENABLED','2026-05-04 09:40:00','2026-06-26 09:50:00'),(12,'9787020042494','小王子','圣埃克苏佩里','人民文学出版社','外国文学','','经典童话小说。',5,4,0,'ENABLED','2026-05-05 09:40:00','2026-06-26 09:50:00'),(13,'9787544253994','百年孤独','加西亚·马尔克斯','南海出版公司','外国文学','','魔幻现实主义经典。',5,5,0,'ENABLED','2026-05-06 09:40:00','2026-06-26 09:50:00'),(14,'9787508647357','人类简史','尤瓦尔·赫拉利','中信出版社','社会科学','','人类历史通识读物。',4,3,0,'ENABLED','2026-05-07 09:40:00','2026-06-26 09:50:00'),(15,'9787508672069','未来简史','尤瓦尔·赫拉利','中信出版社','社会科学','','未来社会主题通识读物。',4,4,0,'ENABLED','2026-05-08 09:40:00','2026-06-26 09:50:00'),(16,'9787544276986','你当像鸟飞往你的山','塔拉·韦斯特弗','南海出版公司','传记纪实','','个人成长回忆录。',4,4,0,'ENABLED','2026-05-09 09:40:00','2026-06-27 21:06:54'),(17,'9787208171336','置身事内','兰小欢','上海人民出版社','经济管理','','中国政府与经济发展研究。',4,4,0,'ENABLED','2026-05-10 09:40:00','2026-06-26 09:50:00'),(18,'9787301174821','乡土中国','费孝通','北京大学出版社','社会科学','','社会学经典。',5,5,0,'ENABLED','2026-05-11 09:40:00','2026-06-26 09:50:00'),(19,'9787505722460','明朝那些事儿（第1部）','当年明月','中国友谊出版公司','历史传记','','明史通俗读物。',4,4,0,'ENABLED','2026-05-12 09:40:00','2026-06-26 09:50:00'),(20,'9787108009821','万历十五年','黄仁宇','生活·读书·新知三联书店','历史传记','','明史研究经典。',4,3,0,'ENABLED','2026-05-13 09:40:00','2026-06-26 09:50:00'),(21,'9787506394864','苏菲的世界','乔斯坦·贾德','作家出版社','哲学心理','','哲学启蒙小说。',4,4,0,'ENABLED','2026-05-14 09:40:00','2026-06-26 09:50:00'),(22,'9787111495482','被讨厌的勇气','岸见一郎、古贺史健','机械工业出版社','哲学心理','','阿德勒心理学通俗读物。',4,3,0,'ENABLED','2026-05-15 09:40:00','2026-06-26 09:50:00'),(23,'9787210093214','深度工作','卡尔·纽波特','江西人民出版社','经济管理','','专注力与工作方法。',4,4,0,'ENABLED','2026-05-16 09:40:00','2026-06-26 09:50:00'),(24,'9787121022982','代码大全','史蒂夫·迈克康奈尔','电子工业出版社','计算机科学','','软件构建经典。',4,3,1,'ENABLED','2026-05-17 09:40:00','2026-06-26 09:50:00'),(25,'9787111187776','算法导论','Thomas H. Cormen 等','机械工业出版社','计算机科学','','算法教材。',4,4,0,'ENABLED','2026-05-18 09:40:00','2026-06-26 09:50:00'),(26,'9787111544937','深入理解计算机系统','Randal E. Bryant、David R. O\'Hallaron','机械工业出版社','计算机科学','','计算机系统教材。',4,4,0,'ENABLED','2026-05-19 09:40:00','2026-06-26 09:50:00'),(27,'9787302423287','机器学习','周志华','清华大学出版社','计算机科学','','机器学习教材。',4,3,0,'ENABLED','2026-05-20 09:40:00','2026-06-26 09:50:00'),(28,'9787115428028','Python编程：从入门到实践','Eric Matthes','人民邮电出版社','计算机科学','','Python入门实践读物。',4,4,0,'ENABLED','2026-05-21 09:40:00','2026-06-26 09:50:00'),(29,'9787535732309','时间简史','史蒂芬·霍金','湖南科学技术出版社','自然科学','','宇宙学科普经典。',4,4,0,'ENABLED','2026-05-22 09:40:00','2026-06-26 09:50:00'),(30,'9787100023948','物种起源','查尔斯·达尔文','商务印书馆','自然科学','','进化论经典著作。',4,3,1,'ENABLED','2026-05-23 09:40:00','2026-06-26 09:50:00'),(31,'9787532739233','枪炮、病菌与钢铁','贾雷德·戴蒙德','上海译文出版社','社会科学','','文明发展通识读物。',4,3,0,'ENABLED','2026-05-24 09:40:00','2026-06-26 09:50:00'),(32,'9787532748983','了不起的盖茨比','F. Scott Fitzgerald','上海译文出版社','外国文学','','美国文学经典。',4,4,0,'ENABLED','2026-05-25 09:40:00','2026-06-26 09:50:00'),(33,'9787532749003','月亮与六便士','毛姆','上海译文出版社','外国文学','','英国文学经典。',4,3,0,'ENABLED','2026-05-26 09:40:00','2026-06-26 09:50:00'),(34,'9787100004831','西方哲学史','伯特兰·罗素','商务印书馆','哲学心理','','哲学史经典。',3,3,0,'ENABLED','2026-05-27 09:40:00','2026-06-26 09:50:00'),(35,'9787301256909','经济学原理','N. Gregory Mankiw','北京大学出版社','经济管理','','经济学教材。',3,3,0,'ENABLED','2026-05-28 09:40:00','2026-06-26 09:50:00'),(36,'9787544280662','杀死一只知更鸟','哈珀·李','译林出版社','外国文学','','美国文学经典。',3,3,0,'ENABLED','2026-05-29 09:40:00','2026-06-26 09:50:00'),(37,'9787115598110','人工智能：一种现代方法','Stuart Russell、Peter Norvig','人民邮电出版社','计算机科学','','人工智能领域经典教材，仅存馆藏已借出。',1,0,1,'ENABLED','2026-05-30 09:40:00','2026-06-26 09:50:00'),(38,'9787111128069','重构：改善既有代码的设计','Martin Fowler','人民邮电出版社','计算机科学','','馆藏盘点中，临时停借。',2,2,0,'DISABLED','2026-05-31 09:40:00','2026-06-26 09:50:00');
/*!40000 ALTER TABLE `library_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `library_borrow_order`
--

DROP TABLE IF EXISTS `library_borrow_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `library_borrow_order` (
  `order_id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(64) NOT NULL COMMENT '借阅单号',
  `reader_id` bigint NOT NULL COMMENT '读者ID',
  `book_id` bigint NOT NULL COMMENT '图书ID',
  `borrow_type` varchar(32) NOT NULL COMMENT '借阅方式',
  `return_type` varchar(32) DEFAULT NULL COMMENT '还书方式',
  `order_status` varchar(32) NOT NULL COMMENT '订单状态',
  `start_date` datetime DEFAULT NULL COMMENT '借阅起算日期',
  `due_date` datetime DEFAULT NULL COMMENT '应还日期',
  `library_ship_date` datetime DEFAULT NULL COMMENT '图书馆寄出日期',
  `pickup_date` datetime DEFAULT NULL COMMENT '到馆自取确认日期',
  `user_ship_back_date` datetime DEFAULT NULL COMMENT '用户寄回日期',
  `library_receive_date` datetime DEFAULT NULL COMMENT '图书馆收书日期',
  `damage_status` varchar(32) NOT NULL DEFAULT 'NORMAL' COMMENT '验书结果',
  `overdue_flag` tinyint NOT NULL DEFAULT '0' COMMENT '是否逾期',
  `compensation_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '赔付金额',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_library_order_no` (`order_no`),
  KEY `idx_library_order_reader` (`reader_id`),
  KEY `idx_library_order_book_status` (`book_id`,`order_status`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='借阅订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library_borrow_order`
--

LOCK TABLES `library_borrow_order` WRITE;
/*!40000 ALTER TABLE `library_borrow_order` DISABLE KEYS */;
INSERT INTO `library_borrow_order` VALUES (1,'B2606260001',1,1,'SELF_PICKUP',NULL,'BORROWING','2026-06-27 00:00:00','2026-07-27 00:00:00',NULL,'2026-06-27 00:00:00',NULL,NULL,'NORMAL',0,0.00,'读者预约到馆自取','2026-06-26 09:10:00','2026-06-27 21:06:39'),(2,'B2606260002',4,2,'LIBRARY_SHIP',NULL,'WAIT_SHIP',NULL,NULL,NULL,NULL,NULL,NULL,'NORMAL',0,0.00,'馆方待寄出','2026-06-26 08:42:00','2026-06-26 08:42:00'),(3,'B2606250003',5,5,'SELF_PICKUP',NULL,'WAIT_PICKUP',NULL,NULL,NULL,NULL,NULL,NULL,'NORMAL',0,0.00,'读者预约到馆自取','2026-06-25 18:20:00','2026-06-25 18:20:00'),(4,'B2606250004',6,9,'LIBRARY_SHIP',NULL,'WAIT_SHIP',NULL,NULL,NULL,NULL,NULL,NULL,'NORMAL',0,0.00,'馆方待寄出','2026-06-25 17:05:00','2026-06-25 17:05:00'),(5,'B2606240005',7,14,'SELF_PICKUP',NULL,'WAIT_PICKUP',NULL,NULL,NULL,NULL,NULL,NULL,'NORMAL',0,0.00,'读者预约到馆自取','2026-06-24 15:30:00','2026-06-24 15:30:00'),(6,'B2606240006',8,20,'LIBRARY_SHIP',NULL,'WAIT_SHIP',NULL,NULL,NULL,NULL,NULL,NULL,'NORMAL',0,0.00,'馆方待寄出','2026-06-24 13:12:00','2026-06-24 13:12:00'),(7,'B2606220007',9,24,'SELF_PICKUP','LIBRARY_RETURN','BORROWING','2026-06-22 10:00:00','2026-07-22 23:59:59',NULL,'2026-06-22 10:00:00',NULL,NULL,'NORMAL',0,0.00,'正常借阅中','2026-06-22 09:20:00','2026-06-22 10:00:00'),(8,'B2606200008',10,27,'LIBRARY_SHIP','USER_SHIP','BORROWING','2026-06-21 15:00:00','2026-07-21 23:59:59','2026-06-20 16:00:00','2026-06-21 15:00:00',NULL,NULL,'NORMAL',0,0.00,'快递签收后开始计借','2026-06-20 11:30:00','2026-06-21 15:00:00'),(9,'B2606180009',1,31,'SELF_PICKUP','LIBRARY_RETURN','BORROWING','2026-06-18 11:00:00','2026-07-18 23:59:59',NULL,'2026-06-18 11:00:00',NULL,NULL,'NORMAL',0,0.00,'正常借阅中','2026-06-18 09:12:00','2026-06-18 11:00:00'),(10,'B2606140010',1,33,'LIBRARY_SHIP','USER_SHIP','BORROWING','2026-06-15 14:00:00','2026-07-15 23:59:59','2026-06-14 17:20:00','2026-06-15 14:00:00',NULL,NULL,'NORMAL',0,0.00,'正常借阅中','2026-06-14 10:18:00','2026-06-15 14:00:00'),(11,'B2605250011',4,7,'SELF_PICKUP','LIBRARY_RETURN','RETURNING','2026-05-26 10:00:00','2026-06-25 23:59:59',NULL,'2026-05-26 10:00:00','2026-06-26 10:00:00',NULL,'NORMAL',1,1.00,'已发起到馆还书','2026-05-25 14:20:00','2026-06-26 10:00:00'),(12,'B2605270012',5,12,'LIBRARY_SHIP','USER_SHIP','RETURNING','2026-05-28 10:00:00','2026-06-27 23:59:59','2026-05-27 15:40:00','2026-05-28 10:00:00','2026-06-25 16:30:00',NULL,'NORMAL',0,0.00,'读者已寄回，待馆方验收','2026-05-27 09:20:00','2026-06-25 16:30:00'),(13,'B2605310013',6,16,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-06-01 10:00:00','2026-07-01 23:59:59',NULL,'2026-06-01 10:00:00','2026-06-26 09:20:00','2026-06-27 00:00:00','NORMAL',0,0.00,'已发起到馆还书','2026-05-31 13:20:00','2026-06-27 21:06:54'),(14,'B2605110014',8,22,'SELF_PICKUP','LIBRARY_RETURN','COMPENSATION_PENDING','2026-05-12 10:00:00','2026-06-11 23:59:59',NULL,'2026-05-12 10:00:00','2026-06-20 10:00:00','2026-06-20 15:00:00','LOST',1,180.00,'遗失待赔付，押金不足','2026-05-11 10:20:00','2026-06-20 15:00:00'),(15,'B2605160015',10,30,'LIBRARY_SHIP','USER_SHIP','COMPENSATION_PENDING','2026-05-18 10:00:00','2026-06-17 23:59:59','2026-05-17 14:20:00','2026-05-18 10:00:00','2026-06-18 16:00:00','2026-06-19 10:00:00','DAMAGED',1,55.00,'破损待赔付','2026-05-16 15:10:00','2026-06-19 10:00:00'),(16,'B2604270016',1,2,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-04-28 10:00:00','2026-05-28 23:59:59',NULL,'2026-04-28 10:00:00','2026-05-20 10:00:00','2026-05-20 11:30:00','NORMAL',0,0.00,'按期归还','2026-04-27 09:30:00','2026-05-20 11:30:00'),(17,'B2604290017',4,1,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-04-30 11:00:00','2026-05-30 23:59:59',NULL,'2026-04-30 11:00:00','2026-05-18 10:00:00','2026-05-18 11:20:00','NORMAL',0,0.00,'按期归还','2026-04-29 09:40:00','2026-05-18 11:20:00'),(18,'B2605010018',5,13,'LIBRARY_SHIP','USER_SHIP','RETURNED','2026-05-02 15:00:00','2026-06-01 23:59:59','2026-05-01 16:20:00','2026-05-02 15:00:00','2026-05-25 16:00:00','2026-05-26 10:00:00','NORMAL',0,0.00,'邮寄归还完成','2026-05-01 08:50:00','2026-05-26 10:00:00'),(19,'B2605030019',6,11,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-05-04 10:30:00','2026-06-03 23:59:59',NULL,'2026-05-04 10:30:00','2026-05-30 09:50:00','2026-05-30 10:30:00','NORMAL',0,0.00,'按期归还','2026-05-03 12:10:00','2026-05-30 10:30:00'),(20,'B2605060020',7,8,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-05-07 11:20:00','2026-06-06 23:59:59',NULL,'2026-05-07 11:20:00','2026-06-08 10:20:00','2026-06-08 11:10:00','NORMAL',1,2.00,'逾期2天已结清','2026-05-06 13:30:00','2026-06-08 11:10:00'),(21,'B2605080021',8,3,'LIBRARY_SHIP','USER_SHIP','RETURNED','2026-05-09 12:10:00','2026-06-08 23:59:59','2026-05-08 16:10:00','2026-05-09 12:10:00','2026-06-01 14:00:00','2026-06-02 09:20:00','NORMAL',0,0.00,'邮寄归还完成','2026-05-08 09:50:00','2026-06-02 09:20:00'),(22,'B2605100022',9,4,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-05-11 10:00:00','2026-06-10 23:59:59',NULL,'2026-05-11 10:00:00','2026-06-09 10:00:00','2026-06-09 10:30:00','NORMAL',0,0.00,'按期归还','2026-05-10 16:20:00','2026-06-09 10:30:00'),(23,'B2605120023',10,17,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-05-13 10:00:00','2026-06-12 23:59:59',NULL,'2026-05-13 10:00:00','2026-06-12 10:00:00','2026-06-12 10:30:00','NORMAL',0,0.00,'按期归还','2026-05-12 09:20:00','2026-06-12 10:30:00'),(24,'B2605130024',1,18,'LIBRARY_SHIP','USER_SHIP','RETURNED','2026-05-14 13:00:00','2026-06-13 23:59:59','2026-05-13 16:00:00','2026-05-14 13:00:00','2026-06-10 15:00:00','2026-06-11 10:00:00','NORMAL',0,0.00,'邮寄归还完成','2026-05-13 10:00:00','2026-06-11 10:00:00'),(25,'B2605150025',1,19,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-05-16 10:00:00','2026-06-15 23:59:59',NULL,'2026-05-16 10:00:00','2026-06-15 10:00:00','2026-06-15 10:40:00','NORMAL',0,0.00,'按期归还','2026-05-15 15:00:00','2026-06-15 10:40:00'),(26,'B2605160026',4,20,'LIBRARY_SHIP','USER_SHIP','RETURNED','2026-05-17 14:00:00','2026-06-16 23:59:59','2026-05-16 17:00:00','2026-05-17 14:00:00','2026-06-16 15:10:00','2026-06-17 10:00:00','NORMAL',0,0.00,'邮寄归还完成','2026-05-16 10:50:00','2026-06-17 10:00:00'),(27,'B2605180027',5,21,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-05-19 09:30:00','2026-06-18 23:59:59',NULL,'2026-05-19 09:30:00','2026-06-18 09:30:00','2026-06-18 10:00:00','NORMAL',0,0.00,'按期归还','2026-05-18 15:10:00','2026-06-18 10:00:00'),(28,'B2605190028',6,23,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-05-20 11:00:00','2026-06-19 23:59:59',NULL,'2026-05-20 11:00:00','2026-06-19 10:40:00','2026-06-19 11:10:00','NORMAL',0,0.00,'按期归还','2026-05-19 13:40:00','2026-06-19 11:10:00'),(29,'B2605200029',7,24,'LIBRARY_SHIP','USER_SHIP','RETURNED','2026-05-21 15:00:00','2026-06-20 23:59:59','2026-05-20 16:00:00','2026-05-21 15:00:00','2026-06-20 16:00:00','2026-06-21 10:00:00','NORMAL',0,0.00,'邮寄归还完成','2026-05-20 09:50:00','2026-06-21 10:00:00'),(30,'B2605220030',8,25,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-05-23 10:00:00','2026-06-22 23:59:59',NULL,'2026-05-23 10:00:00','2026-06-22 10:20:00','2026-06-22 11:00:00','NORMAL',0,0.00,'按期归还','2026-05-22 14:10:00','2026-06-22 11:00:00'),(31,'B2605230031',9,26,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-05-24 10:00:00','2026-06-23 23:59:59',NULL,'2026-05-24 10:00:00','2026-06-23 09:20:00','2026-06-23 10:00:00','NORMAL',0,0.00,'按期归还','2026-05-23 16:00:00','2026-06-23 10:00:00'),(32,'B2605240032',10,28,'LIBRARY_SHIP','USER_SHIP','RETURNED','2026-05-25 16:00:00','2026-06-24 23:59:59','2026-05-24 16:00:00','2026-05-25 16:00:00','2026-06-24 15:20:00','2026-06-25 10:00:00','DAMAGED',0,30.00,'轻微破损已赔付','2026-05-24 10:20:00','2026-06-25 10:00:00'),(33,'B2605260033',1,29,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-05-27 10:00:00','2026-06-26 23:59:59',NULL,'2026-05-27 10:00:00','2026-06-25 10:00:00','2026-06-25 10:40:00','NORMAL',0,0.00,'按期归还','2026-05-26 11:20:00','2026-06-25 10:40:00'),(34,'B2605310034',1,1,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-06-01 10:00:00','2026-07-01 23:59:59',NULL,'2026-06-01 10:00:00','2026-06-20 11:00:00','2026-06-20 11:40:00','NORMAL',0,0.00,'按期归还','2026-05-31 09:20:00','2026-06-20 11:40:00'),(35,'B2606020035',4,2,'LIBRARY_SHIP','USER_SHIP','RETURNED','2026-06-03 14:00:00','2026-07-03 23:59:59','2026-06-02 16:00:00','2026-06-03 14:00:00','2026-06-23 15:00:00','2026-06-24 10:00:00','NORMAL',0,0.00,'邮寄归还完成','2026-06-02 10:10:00','2026-06-24 10:00:00'),(36,'B2606040036',5,13,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-06-05 10:30:00','2026-07-05 23:59:59',NULL,'2026-06-05 10:30:00','2026-06-25 10:30:00','2026-06-25 11:00:00','NORMAL',0,0.00,'按期归还','2026-06-04 13:10:00','2026-06-25 11:00:00'),(37,'B2606050037',6,11,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-06-06 10:00:00','2026-07-06 23:59:59',NULL,'2026-06-06 10:00:00','2026-06-26 09:00:00','2026-06-26 09:40:00','NORMAL',0,0.00,'按期归还','2026-06-05 15:20:00','2026-06-26 09:40:00'),(38,'B2606070038',7,8,'LIBRARY_SHIP','USER_SHIP','RETURNED','2026-06-08 15:00:00','2026-07-08 23:59:59','2026-06-07 16:00:00','2026-06-08 15:00:00','2026-06-26 10:00:00','2026-06-26 11:00:00','NORMAL',0,0.00,'邮寄归还完成','2026-06-07 10:30:00','2026-06-26 11:00:00'),(39,'B2606090039',8,3,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-06-10 10:00:00','2026-07-10 23:59:59',NULL,'2026-06-10 10:00:00','2026-06-24 10:00:00','2026-06-24 10:30:00','NORMAL',0,0.00,'按期归还','2026-06-09 11:20:00','2026-06-24 10:30:00'),(40,'B2606110040',9,4,'SELF_PICKUP','LIBRARY_RETURN','RETURNED','2026-06-12 10:00:00','2026-07-12 23:59:59',NULL,'2026-06-12 10:00:00','2026-06-26 10:20:00','2026-06-26 11:20:00','NORMAL',0,0.00,'按期归还','2026-06-11 09:45:00','2026-06-26 11:20:00'),(41,'B2606260041',9,37,'SELF_PICKUP','LIBRARY_RETURN','BORROWING','2026-06-26 15:00:00','2026-07-26 23:59:59',NULL,'2026-06-26 15:00:00',NULL,NULL,'NORMAL',0,0.00,'唯一馆藏借阅中，用于无库存排队测试','2026-06-26 14:30:00','2026-06-26 15:00:00');
/*!40000 ALTER TABLE `library_borrow_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `library_delivery_record`
--

DROP TABLE IF EXISTS `library_delivery_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `library_delivery_record` (
  `delivery_id` bigint NOT NULL AUTO_INCREMENT COMMENT '物流ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `reader_id` bigint NOT NULL COMMENT '读者ID',
  `book_id` bigint NOT NULL COMMENT '图书ID',
  `delivery_type` varchar(32) NOT NULL COMMENT '物流类型',
  `address_id` bigint DEFAULT NULL COMMENT '地址ID',
  `receiver_address` varchar(512) DEFAULT NULL COMMENT '收件地址快照',
  `freight_type` varchar(32) NOT NULL COMMENT '运费方式',
  `fee_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '运费金额',
  `tracking_no` varchar(128) DEFAULT NULL COMMENT '快递单号',
  `carrier_name` varchar(64) DEFAULT NULL COMMENT '快递公司',
  `delivery_status` varchar(32) NOT NULL DEFAULT 'CREATED' COMMENT '物流状态',
  `ship_date` datetime DEFAULT NULL COMMENT '寄出时间',
  `receive_date` datetime DEFAULT NULL COMMENT '签收时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`delivery_id`),
  KEY `idx_library_delivery_order` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='物流收发记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library_delivery_record`
--

LOCK TABLES `library_delivery_record` WRITE;
/*!40000 ALTER TABLE `library_delivery_record` DISABLE KEYS */;
INSERT INTO `library_delivery_record` VALUES (1,2,4,2,'LIBRARY_OUT',2,'中山市东区街道兴中道8号附近 2座806 李思 13900002001','CURRENT_SETTLE',8.00,NULL,NULL,'CREATED',NULL,NULL,'2026-06-26 08:42:00','2026-06-26 08:42:00'),(2,4,6,9,'LIBRARY_OUT',4,'中山市南区街道城南一路12号 1栋704 赵六 13900002003','CURRENT_SETTLE',8.00,NULL,NULL,'CREATED',NULL,NULL,'2026-06-25 17:05:00','2026-06-25 17:05:00'),(3,6,8,20,'LIBRARY_OUT',6,'中山市小榄镇民安中路163号 6栋901 孙八 13900002005','CURRENT_SETTLE',8.00,NULL,NULL,'CREATED',NULL,NULL,'2026-06-24 13:12:00','2026-06-24 13:12:00'),(4,8,10,27,'LIBRARY_OUT',8,'中山市三乡镇雅居乐花园柏丽广场 8栋1102 吴十 13900002007','CURRENT_SETTLE',8.00,'SF0620000008','顺丰速运','RECEIVED','2026-06-20 16:00:00','2026-06-21 15:00:00','2026-06-20 11:30:00','2026-06-21 15:00:00'),(5,10,1,33,'LIBRARY_OUT',1,'中山市石岐街道孙文中路197号附近 3栋502 读者张三 13900000000','CURRENT_SETTLE',8.00,'SF0614000010','顺丰速运','RECEIVED','2026-06-14 17:20:00','2026-06-15 14:00:00','2026-06-14 10:18:00','2026-06-15 14:00:00'),(6,12,5,12,'LIBRARY_OUT',3,'中山市西区街道彩虹大道16号D区 5栋1201 王五 13900002002','CURRENT_SETTLE',8.00,'SF0527000012','顺丰速运','RECEIVED','2026-05-27 15:40:00','2026-05-28 10:00:00','2026-05-27 09:20:00','2026-05-28 10:00:00'),(7,15,10,30,'LIBRARY_OUT',8,'中山市三乡镇雅居乐花园柏丽广场 8栋1102 吴十 13900002007','CURRENT_SETTLE',8.00,'SF0517000015','顺丰速运','RECEIVED','2026-05-17 14:20:00','2026-05-18 10:00:00','2026-05-16 15:10:00','2026-05-18 10:00:00'),(8,18,5,13,'LIBRARY_OUT',3,'中山市西区街道彩虹大道16号D区 5栋1201 王五 13900002002','CURRENT_SETTLE',8.00,'SF0501000018','顺丰速运','RECEIVED','2026-05-01 16:20:00','2026-05-02 15:00:00','2026-05-01 08:50:00','2026-05-02 15:00:00'),(9,21,8,3,'LIBRARY_OUT',6,'中山市小榄镇民安中路163号 6栋901 孙八 13900002005','CURRENT_SETTLE',8.00,'SF0508000021','顺丰速运','RECEIVED','2026-05-08 16:10:00','2026-05-09 12:10:00','2026-05-08 09:50:00','2026-05-09 12:10:00'),(10,24,1,18,'LIBRARY_OUT',1,'中山市石岐街道孙文中路197号附近 3栋502 读者张三 13900000000','CURRENT_SETTLE',8.00,'SF0513000024','顺丰速运','RECEIVED','2026-05-13 16:00:00','2026-05-14 13:00:00','2026-05-13 10:00:00','2026-05-14 13:00:00'),(11,26,4,20,'LIBRARY_OUT',2,'中山市东区街道兴中道8号附近 2座806 李思 13900002001','CURRENT_SETTLE',8.00,'SF0516000026','顺丰速运','RECEIVED','2026-05-16 17:00:00','2026-05-17 14:00:00','2026-05-16 10:50:00','2026-05-17 14:00:00'),(12,29,7,24,'LIBRARY_OUT',5,'中山市火炬开发区会展东路1号德仲广场 2幢702 钱七 13900002004','CURRENT_SETTLE',8.00,'SF0520000029','顺丰速运','RECEIVED','2026-05-20 16:00:00','2026-05-21 15:00:00','2026-05-20 09:50:00','2026-05-21 15:00:00'),(13,32,10,28,'LIBRARY_OUT',8,'中山市三乡镇雅居乐花园柏丽广场 8栋1102 吴十 13900002007','CURRENT_SETTLE',8.00,'SF0524000032','顺丰速运','RECEIVED','2026-05-24 16:00:00','2026-05-25 16:00:00','2026-05-24 10:20:00','2026-05-25 16:00:00'),(14,35,4,2,'LIBRARY_OUT',2,'中山市东区街道兴中道8号附近 2座806 李思 13900002001','CURRENT_SETTLE',8.00,'SF0602000035','顺丰速运','RECEIVED','2026-06-02 16:00:00','2026-06-03 14:00:00','2026-06-02 10:10:00','2026-06-03 14:00:00'),(15,38,7,8,'LIBRARY_OUT',5,'中山市火炬开发区会展东路1号德仲广场 2幢702 钱七 13900002004','CURRENT_SETTLE',8.00,'SF0607000038','顺丰速运','RECEIVED','2026-06-07 16:00:00','2026-06-08 15:00:00','2026-06-07 10:30:00','2026-06-08 15:00:00'),(16,12,5,12,'USER_RETURN',NULL,'中山市东区街道兴中道8号 中山纪念图书馆流通部 0760-88888888','COLLECT',0.00,'YT0625000012','圆通速递','SHIPPED','2026-06-25 16:30:00',NULL,'2026-06-25 16:30:00','2026-06-25 16:30:00'),(17,15,10,30,'USER_RETURN',NULL,'中山市东区街道兴中道8号 中山纪念图书馆流通部 0760-88888888','COLLECT',0.00,'YT0618000015','圆通速递','RECEIVED','2026-06-18 16:00:00','2026-06-19 10:00:00','2026-06-18 16:00:00','2026-06-19 10:00:00'),(18,18,5,13,'USER_RETURN',NULL,'中山市东区街道兴中道8号 中山纪念图书馆流通部 0760-88888888','COLLECT',0.00,'YT0525000018','圆通速递','RECEIVED','2026-05-25 16:00:00','2026-05-26 10:00:00','2026-05-25 16:00:00','2026-05-26 10:00:00'),(19,21,8,3,'USER_RETURN',NULL,'中山市东区街道兴中道8号 中山纪念图书馆流通部 0760-88888888','COLLECT',0.00,'YT0601000021','圆通速递','RECEIVED','2026-06-01 14:00:00','2026-06-02 09:20:00','2026-06-01 14:00:00','2026-06-02 09:20:00'),(20,24,1,18,'USER_RETURN',NULL,'中山市东区街道兴中道8号 中山纪念图书馆流通部 0760-88888888','COLLECT',0.00,'YT0610000024','圆通速递','RECEIVED','2026-06-10 15:00:00','2026-06-11 10:00:00','2026-06-10 15:00:00','2026-06-11 10:00:00'),(21,26,4,20,'USER_RETURN',NULL,'中山市东区街道兴中道8号 中山纪念图书馆流通部 0760-88888888','COLLECT',0.00,'YT0616000026','圆通速递','RECEIVED','2026-06-16 15:10:00','2026-06-17 10:00:00','2026-06-16 15:10:00','2026-06-17 10:00:00'),(22,29,7,24,'USER_RETURN',NULL,'中山市东区街道兴中道8号 中山纪念图书馆流通部 0760-88888888','COLLECT',0.00,'YT0620000029','圆通速递','RECEIVED','2026-06-20 16:00:00','2026-06-21 10:00:00','2026-06-20 16:00:00','2026-06-21 10:00:00'),(23,32,10,28,'USER_RETURN',NULL,'中山市东区街道兴中道8号 中山纪念图书馆流通部 0760-88888888','COLLECT',0.00,'YT0624000032','圆通速递','RECEIVED','2026-06-24 15:20:00','2026-06-25 10:00:00','2026-06-24 15:20:00','2026-06-25 10:00:00'),(24,35,4,2,'USER_RETURN',NULL,'中山市东区街道兴中道8号 中山纪念图书馆流通部 0760-88888888','COLLECT',0.00,'YT0623000035','圆通速递','RECEIVED','2026-06-23 15:00:00','2026-06-24 10:00:00','2026-06-23 15:00:00','2026-06-24 10:00:00'),(25,38,7,8,'USER_RETURN',NULL,'中山市东区街道兴中道8号 中山纪念图书馆流通部 0760-88888888','COLLECT',0.00,'YT0626000038','圆通速递','RECEIVED','2026-06-26 10:00:00','2026-06-26 11:00:00','2026-06-26 10:00:00','2026-06-26 11:00:00');
/*!40000 ALTER TABLE `library_delivery_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `library_fee_record`
--

DROP TABLE IF EXISTS `library_fee_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `library_fee_record` (
  `fee_id` bigint NOT NULL AUTO_INCREMENT COMMENT '费用ID',
  `reader_id` bigint NOT NULL COMMENT '读者ID',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `fee_type` varchar(32) NOT NULL COMMENT '费用类型',
  `amount` decimal(10,2) NOT NULL COMMENT '金额',
  `balance_after` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '扣费后押金余额',
  `pay_status` varchar(32) NOT NULL DEFAULT 'PAID' COMMENT '支付状态',
  `pay_method` varchar(32) DEFAULT NULL COMMENT '支付方式',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`fee_id`),
  KEY `idx_library_fee_reader` (`reader_id`),
  KEY `idx_library_fee_order` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='年费押金与罚金记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library_fee_record`
--

LOCK TABLES `library_fee_record` WRITE;
/*!40000 ALTER TABLE `library_fee_record` DISABLE KEYS */;
INSERT INTO `library_fee_record` VALUES (1,4,11,'COMPENSATION',1.00,499.00,'UNPAID','DEPOSIT','赔偿待缴纳','2026-06-26 10:00:00','2026-06-26 10:00:00'),(2,8,14,'COMPENSATION',180.00,140.00,'UNPAID','DEPOSIT','赔偿待缴纳','2026-06-20 15:00:00','2026-06-20 15:00:00'),(3,10,15,'COMPENSATION',55.00,395.00,'UNPAID','DEPOSIT','赔偿待缴纳','2026-06-19 10:00:00','2026-06-19 10:00:00'),(4,7,20,'COMPENSATION',2.00,518.00,'PAID','DEPOSIT','赔偿已从押金扣除','2026-06-08 11:10:00','2026-06-08 11:10:00'),(5,10,32,'COMPENSATION',30.00,420.00,'PAID','DEPOSIT','赔偿已从押金扣除','2026-06-25 10:00:00','2026-06-25 10:00:00'),(8,1,NULL,'ANNUAL_FEE',199.00,230.00,'PAID','线下登记','年度服务费已缴纳','2026-01-05 10:00:00','2026-01-05 10:00:00'),(9,5,NULL,'DEPOSIT_RECHARGE',199.00,150.00,'PAID','微信','测试押金充值记录','2026-03-12 10:00:00','2026-03-12 10:00:00'),(10,7,20,'OVERDUE',2.00,520.00,'PAID','DEPOSIT','逾期费用已扣押金','2026-06-08 11:10:00','2026-06-08 11:10:00'),(11,10,32,'DAMAGE',30.00,450.00,'PAID','DEPOSIT','轻微破损赔偿已结清','2026-06-25 10:00:00','2026-06-25 10:00:00'),(12,8,14,'LOST',180.00,320.00,'UNPAID','DEPOSIT','遗失赔偿待补缴','2026-06-20 15:00:00','2026-06-20 15:00:00');
/*!40000 ALTER TABLE `library_fee_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `library_queue_record`
--

DROP TABLE IF EXISTS `library_queue_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `library_queue_record` (
  `queue_id` bigint NOT NULL AUTO_INCREMENT COMMENT '排队ID',
  `reader_id` bigint NOT NULL COMMENT '读者ID',
  `book_id` bigint NOT NULL COMMENT '图书ID',
  `queue_no` varchar(64) NOT NULL COMMENT '排队单号',
  `queue_position` int NOT NULL COMMENT '排队位置',
  `borrow_type` varchar(32) NOT NULL COMMENT '轮到后借阅方式',
  `address_id` bigint DEFAULT NULL COMMENT '轮到后邮寄地址',
  `estimated_available_date` datetime DEFAULT NULL COMMENT '预计最快可借日期',
  `queue_status` varchar(32) NOT NULL DEFAULT 'WAITING' COMMENT '排队状态',
  `converted_order_id` bigint DEFAULT NULL COMMENT '转成的借阅订单ID',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`queue_id`),
  UNIQUE KEY `uk_library_queue_no` (`queue_no`),
  KEY `idx_library_queue_book_status` (`book_id`,`queue_status`,`queue_position`),
  KEY `idx_library_queue_reader` (`reader_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='排队预约表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library_queue_record`
--

LOCK TABLES `library_queue_record` WRITE;
/*!40000 ALTER TABLE `library_queue_record` DISABLE KEYS */;
INSERT INTO `library_queue_record` VALUES (1,1,2,'Q2606240001',1,'SELF_PICKUP',1,'2026-06-29 10:00:00','WAITING',NULL,'等待同城馆藏回流','2026-06-24 09:00:00','2026-06-24 09:00:00'),(2,4,1,'Q2606240002',1,'LIBRARY_SHIP',2,'2026-06-30 10:00:00','WAITING',NULL,'等待同城馆藏回流','2026-06-24 10:00:00','2026-06-24 10:00:00'),(3,5,13,'Q2606180003',1,'SELF_PICKUP',3,'2026-06-28 10:00:00','CONVERTED',36,'已转成借阅订单','2026-06-18 09:00:00','2026-06-18 09:00:00'),(4,6,11,'Q2606190004',1,'SELF_PICKUP',4,'2026-06-27 10:00:00','CONVERTED',37,'读者到馆前自动转单','2026-06-19 09:00:00','2026-06-19 09:00:00'),(5,7,24,'Q2606250005',1,'LIBRARY_SHIP',5,'2026-07-01 10:00:00','WAITING',NULL,'同城配送优先','2026-06-25 09:00:00','2026-06-25 09:00:00'),(6,8,27,'Q2606210006',1,'SELF_PICKUP',6,'2026-07-03 10:00:00','CANCELLED',NULL,'读者取消排队','2026-06-21 09:00:00','2026-06-21 09:00:00'),(7,9,5,'Q2606250007',1,'SELF_PICKUP',7,'2026-07-02 10:00:00','WAITING',NULL,'古典文学热门排队','2026-06-25 11:00:00','2026-06-25 11:00:00'),(8,10,30,'Q2606250008',1,'LIBRARY_SHIP',8,'2026-07-04 10:00:00','WAITING',NULL,'自然科学热门排队','2026-06-25 15:00:00','2026-06-25 15:00:00'),(9,1,37,'Q2606260009',1,'SELF_PICKUP',1,'2026-07-06 10:00:00','WAITING',NULL,'唯一馆藏借出中，等待归还','2026-06-26 16:00:00','2026-06-26 16:00:00'),(10,5,37,'Q2606260010',2,'LIBRARY_SHIP',3,'2026-07-08 10:00:00','EXCEPTION',NULL,'年费已过期，自动转单失败','2026-06-26 16:20:00','2026-06-26 16:20:00');
/*!40000 ALTER TABLE `library_queue_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `library_reader`
--

DROP TABLE IF EXISTS `library_reader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `library_reader` (
  `reader_id` bigint NOT NULL AUTO_INCREMENT COMMENT '读者ID',
  `user_id` bigint DEFAULT NULL COMMENT '关联系统用户ID',
  `reader_name` varchar(64) NOT NULL COMMENT '读者姓名',
  `mobile` varchar(32) DEFAULT NULL COMMENT '手机号',
  `city` varchar(64) DEFAULT NULL COMMENT '所在城市',
  `default_address_id` bigint DEFAULT NULL COMMENT '默认地址ID',
  `annual_expire_date` datetime DEFAULT NULL COMMENT '年费服务到期时间',
  `deposit_balance` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '押金余额',
  `deposit_frozen` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '冻结押金',
  `used_outbound_count` int NOT NULL DEFAULT '0' COMMENT '本年度图书馆寄出次数',
  `used_inbound_count` int NOT NULL DEFAULT '0' COMMENT '本年度用户寄回次数',
  `max_outbound_count` int DEFAULT NULL COMMENT '个人寄出次数上限',
  `max_inbound_count` int DEFAULT NULL COMMENT '个人寄回次数上限',
  `max_borrow_count` int DEFAULT NULL COMMENT '个人最大同时借阅数',
  `status` varchar(32) NOT NULL DEFAULT 'NORMAL' COMMENT '状态',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`reader_id`),
  KEY `idx_library_reader_user` (`user_id`),
  KEY `idx_library_reader_mobile` (`mobile`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='图书馆读者表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library_reader`
--

LOCK TABLES `library_reader` WRITE;
/*!40000 ALTER TABLE `library_reader` DISABLE KEYS */;
INSERT INTO `library_reader` VALUES (1,3,'读者张三','13900000000','中山市',1,'2027-12-31 23:59:59',230.00,0.00,2,2,50,50,5,'NORMAL','2026-06-25 13:54:34','2026-06-26 09:55:00'),(4,102,'李思','13900002001','中山市',2,'2027-12-31 23:59:59',500.00,0.00,3,2,50,50,5,'NORMAL','2026-06-25 16:29:55','2026-06-26 09:55:00'),(5,103,'王五','13900002002','中山市',3,'2027-12-31 23:59:59',150.00,0.00,2,2,50,50,5,'NORMAL','2026-06-25 16:29:55','2026-06-26 09:55:00'),(6,104,'赵六','13900002003','中山市',4,'2027-12-31 23:59:59',120.00,0.00,1,0,50,50,5,'DISABLED','2026-06-25 16:29:55','2026-06-26 09:55:00'),(7,105,'钱七','13900002004','中山市',5,'2027-12-31 23:59:59',520.00,0.00,2,2,50,50,5,'NORMAL','2026-06-25 16:29:55','2026-06-26 09:55:00'),(8,106,'孙八','13900002005','中山市',6,'2027-12-31 23:59:59',320.00,0.00,2,1,50,50,5,'NORMAL','2026-06-25 16:29:55','2026-06-26 09:55:00'),(9,107,'周九','13900002006','中山市',7,'2027-12-31 23:59:59',260.00,0.00,0,0,50,50,1,'NORMAL','2026-06-25 16:29:55','2026-06-26 09:55:00'),(10,108,'吴十','13900002007','中山市',8,'2027-12-31 23:59:59',450.00,0.00,3,3,50,50,5,'NORMAL','2026-06-25 16:29:55','2026-06-26 09:55:00');
/*!40000 ALTER TABLE `library_reader` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `library_rule`
--

DROP TABLE IF EXISTS `library_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `library_rule` (
  `rule_id` bigint NOT NULL AUTO_INCREMENT COMMENT '规则ID',
  `library_city` varchar(64) NOT NULL COMMENT '图书馆所在城市',
  `annual_fee` decimal(10,2) NOT NULL DEFAULT '199.00' COMMENT '年费',
  `deposit_amount` decimal(10,2) NOT NULL DEFAULT '300.00' COMMENT '最低押金',
  `max_loan_days` int NOT NULL DEFAULT '30' COMMENT '最长外借天数',
  `annual_outbound_limit` int NOT NULL DEFAULT '12' COMMENT '每年图书馆寄出次数上限',
  `annual_inbound_limit` int NOT NULL DEFAULT '12' COMMENT '每年用户寄回次数上限',
  `max_borrow_count` int NOT NULL DEFAULT '5' COMMENT '最大同时借阅数',
  `overdue_fee_per_day` decimal(10,2) NOT NULL DEFAULT '1.00' COMMENT '逾期每日罚金',
  `damage_fee` decimal(10,2) NOT NULL DEFAULT '50.00' COMMENT '损坏默认罚金',
  `lost_fee` decimal(10,2) NOT NULL DEFAULT '100.00' COMMENT '丢失默认罚金',
  `status` varchar(32) NOT NULL DEFAULT 'ENABLED' COMMENT '状态',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`rule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='图书馆借阅规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library_rule`
--

LOCK TABLES `library_rule` WRITE;
/*!40000 ALTER TABLE `library_rule` DISABLE KEYS */;
INSERT INTO `library_rule` VALUES (1,'中山市',199.00,199.00,30,50,50,5,1.00,20.00,50.00,'ENABLED','2026-06-25 11:58:34','2026-06-26 09:00:00'),(2,'中山市',159.00,199.00,21,12,12,3,1.00,50.00,100.00,'DISABLED','2025-01-01 09:00:00','2026-01-01 09:00:00');
/*!40000 ALTER TABLE `library_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_blob_triggers`
--

DROP TABLE IF EXISTS `qrtz_blob_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `QRTZ_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Blob类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_blob_triggers`
--

LOCK TABLES `qrtz_blob_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_blob_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_blob_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_calendars`
--

DROP TABLE IF EXISTS `qrtz_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='日历信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_calendars`
--

LOCK TABLES `qrtz_calendars` WRITE;
/*!40000 ALTER TABLE `qrtz_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_cron_triggers`
--

DROP TABLE IF EXISTS `qrtz_cron_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `QRTZ_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Cron类型的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_cron_triggers`
--

LOCK TABLES `qrtz_cron_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_cron_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_cron_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_fired_triggers`
--

DROP TABLE IF EXISTS `qrtz_fired_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) NOT NULL COMMENT '状态',
  `job_name` varchar(200) DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='已触发的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_fired_triggers`
--

LOCK TABLES `qrtz_fired_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_fired_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_fired_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_job_details`
--

DROP TABLE IF EXISTS `qrtz_job_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) NOT NULL COMMENT '任务组名',
  `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_job_details`
--

LOCK TABLES `qrtz_job_details` WRITE;
/*!40000 ALTER TABLE `qrtz_job_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_job_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_locks`
--

DROP TABLE IF EXISTS `qrtz_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='存储的悲观锁信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_locks`
--

LOCK TABLES `qrtz_locks` WRITE;
/*!40000 ALTER TABLE `qrtz_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_paused_trigger_grps`
--

DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='暂停的触发器表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_paused_trigger_grps`
--

LOCK TABLES `qrtz_paused_trigger_grps` WRITE;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_paused_trigger_grps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_scheduler_state`
--

DROP TABLE IF EXISTS `qrtz_scheduler_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='调度器状态表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_scheduler_state`
--

LOCK TABLES `qrtz_scheduler_state` WRITE;
/*!40000 ALTER TABLE `qrtz_scheduler_state` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_scheduler_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simple_triggers`
--

DROP TABLE IF EXISTS `qrtz_simple_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `QRTZ_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='简单触发器的信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simple_triggers`
--

LOCK TABLES `qrtz_simple_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simple_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simple_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_simprop_triggers`
--

DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `QRTZ_SIMPROP_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='同步机制的行锁表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_simprop_triggers`
--

LOCK TABLES `qrtz_simprop_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_simprop_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrtz_triggers`
--

DROP TABLE IF EXISTS `qrtz_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`),
  CONSTRAINT `QRTZ_TRIGGERS_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='触发器详细信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrtz_triggers`
--

LOCK TABLES `qrtz_triggers` WRITE;
/*!40000 ALTER TABLE `qrtz_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `qrtz_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2026-03-06 01:54:38','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2026-03-06 01:54:38','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2026-03-06 01:54:38','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2026-03-06 01:54:38','','2026-06-26 18:15:22','是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y','admin','2026-03-06 01:54:38','',NULL,'是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2026-03-06 01:54:38','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）'),(7,'用户管理-初始密码修改策略','sys.account.initPasswordModify','1','Y','admin','2026-03-06 01:54:38','',NULL,'0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框'),(8,'用户管理-账号密码更新周期','sys.account.passwordValidateDays','0','Y','admin','2026-03-06 01:54:38','',NULL,'密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `status` char(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'0','若依科技',0,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-06 01:54:36','',NULL),(101,100,'0,100','深圳总公司',1,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-06 01:54:36','',NULL),(102,100,'0,100','长沙分公司',2,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-06 01:54:36','',NULL),(103,101,'0,100,101','研发部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-06 01:54:36','',NULL),(104,101,'0,100,101','市场部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-06 01:54:36','',NULL),(105,101,'0,100,101','测试部门',3,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-06 01:54:36','',NULL),(106,101,'0,100,101','财务部门',4,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-06 01:54:36','',NULL),(107,101,'0,100,101','运维部门',5,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-06 01:54:36','',NULL),(108,102,'0,100,102','市场部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-06 01:54:36','',NULL),(109,102,'0,100,102','财务部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2026-03-06 01:54:36','',NULL);
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2026-03-06 01:54:38','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2026-03-06 01:54:38','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2026-03-06 01:54:38','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2026-03-06 01:54:38','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2026-03-06 01:54:38','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2026-03-06 01:54:38','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2026-03-06 01:54:38','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2026-03-06 01:54:38','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2026-03-06 01:54:38','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2026-03-06 01:54:38','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2026-03-06 01:54:38','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2026-03-06 01:54:38','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2026-03-06 01:54:38','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2026-03-06 01:54:38','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2026-03-06 01:54:38','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2026-03-06 01:54:38','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2026-03-06 01:54:38','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2026-03-06 01:54:38','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2026-03-06 01:54:38','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2026-03-06 01:54:38','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2026-03-06 01:54:38','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2026-03-06 01:54:38','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2026-03-06 01:54:38','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2026-03-06 01:54:38','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2026-03-06 01:54:38','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2026-03-06 01:54:38','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2026-03-06 01:54:38','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2026-03-06 01:54:38','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2026-03-06 01:54:38','',NULL,'停用状态'),(100,0,'学生','1','reader_type',NULL,'info','N','0','admin','2026-03-09 01:49:32','admin','2026-03-09 02:50:35',NULL),(101,1,'职工','2','reader_type',NULL,'primary','N','0','admin','2026-03-09 01:49:44','',NULL,NULL),(102,0,'借出','1','borrow_status',NULL,'primary','N','0','admin','2026-03-09 01:53:09','',NULL,NULL),(103,1,'已归还','2','borrow_status',NULL,'success','N','0','admin','2026-03-09 01:53:29','',NULL,NULL),(104,2,'逾期','3','borrow_status',NULL,'warning','N','0','admin','2026-03-09 01:53:53','',NULL,NULL),(105,3,'遗失','4','borrow_status',NULL,'danger','N','0','admin','2026-03-09 01:54:06','admin','2026-03-09 01:54:22',NULL),(106,0,'启用','1','category_status',NULL,'success','N','0','admin','2026-03-09 02:14:58','',NULL,NULL),(107,1,'禁用','0','category_status',NULL,'danger','N','0','admin','2026-03-09 02:15:15','',NULL,NULL),(108,0,'在架','1','book_status',NULL,'success','N','0','admin','2026-03-09 02:50:02','',NULL,NULL),(109,1,'未上架','2','book_status',NULL,'info','N','0','admin','2026-03-09 02:50:13','admin','2026-03-09 02:50:21',NULL);
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2026-03-06 01:54:38','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2026-03-06 01:54:38','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2026-03-06 01:54:38','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2026-03-06 01:54:38','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2026-03-06 01:54:38','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2026-03-06 01:54:38','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2026-03-06 01:54:38','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2026-03-06 01:54:38','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2026-03-06 01:54:38','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2026-03-06 01:54:38','',NULL,'登录状态列表'),(100,'读者类型','reader_type','0','admin','2026-03-09 01:46:16','admin','2026-03-09 01:46:53',NULL),(101,'借阅状态','borrow_status','0','admin','2026-03-09 01:52:17','',NULL,NULL),(102,'图书分类状态','category_status','0','admin','2026-03-09 02:14:40','',NULL,NULL),(103,'图书状态','book_status','0','admin','2026-03-09 02:49:38','',NULL,NULL),(104,'读者状态','reader_status','0','admin','2026-03-10 09:47:20','',NULL,NULL);
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2026-03-06 01:54:38','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2026-03-06 01:54:38','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2026-03-06 01:54:38','',NULL,'');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) DEFAULT NULL COMMENT '日志信息',
  `status` char(1) DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) DEFAULT '' COMMENT '异常信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
  `status` char(1) DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=460 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (100,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','退出成功','2026-03-06 01:56:19'),(101,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-06 01:56:22'),(102,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-06 03:18:43'),(103,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-06 04:00:50'),(104,'admin','127.0.0.1','内网IP','IntelliJ HTTP Client 2025.3.3','','0','登录成功','2026-03-07 09:23:39'),(105,'admin','127.0.0.1','内网IP','IntelliJ HTTP Client 2025.3.3','','0','登录成功','2026-03-08 01:53:59'),(106,'admin','127.0.0.1','内网IP','IntelliJ HTTP Client 2025.3.3','','0','登录成功','2026-03-08 02:49:17'),(107,'admin','127.0.0.1','内网IP','IntelliJ HTTP Client 2025.3.3','','0','登录成功','2026-03-08 06:35:28'),(108,'admin','127.0.0.1','内网IP','IntelliJ HTTP Client 2025.3.3','','0','登录成功','2026-03-08 08:02:00'),(109,'admin','127.0.0.1','内网IP','IntelliJ HTTP Client 2025.3.3','','0','登录成功','2026-03-08 08:02:00'),(110,'admin','127.0.0.1','内网IP','IntelliJ HTTP Client 2025.3.3','','0','登录成功','2026-03-08 08:41:54'),(111,'admin','127.0.0.1','内网IP','IntelliJ HTTP Client 2025.3.3','','0','登录成功','2026-03-08 08:50:35'),(112,'admin','127.0.0.1','内网IP','IntelliJ HTTP Client 2025.3.3','','0','登录成功','2026-03-09 01:05:32'),(113,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-09 01:12:40'),(114,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-09 02:48:37'),(115,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-09 04:14:42'),(116,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-09 06:21:41'),(117,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-09 08:06:02'),(118,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-09 12:03:30'),(119,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-10 01:08:07'),(120,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-10 08:19:19'),(121,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-10 10:36:59'),(122,'admin','127.0.0.1','内网IP','Edge 145','Windows >=10','0','登录成功','2026-03-12 09:10:09'),(123,'admin','127.0.0.1','内网IP','Edge 146','Windows >=10','0','登录成功','2026-04-01 02:38:13'),(124,'admin','127.0.0.1','内网IP','Edge 146','Windows >=10','0','登录成功','2026-04-01 08:34:33'),(125,'admin','127.0.0.1','内网IP','Edge 146','Windows >=10','0','登录成功','2026-04-03 12:17:10'),(126,'admin','127.0.0.1','内网IP','Edge 146','Windows >=10','1','验证码错误','2026-04-03 13:16:24'),(127,'admin','127.0.0.1','内网IP','Edge 146','Windows >=10','0','登录成功','2026-04-03 13:16:29'),(128,'admin','127.0.0.1','内网IP','Edge 146','Windows >=10','0','登录成功','2026-04-07 11:55:40'),(129,'admin','127.0.0.1','内网IP','Edge 146','Windows >=10','0','登录成功','2026-04-07 13:31:02'),(130,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-05-16 19:51:21'),(131,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','1','验证码错误','2026-05-16 20:23:25'),(132,'admin','127.0.0.1','内网IP','Chrome 148','Windows10','0','登录成功','2026-05-16 20:23:30'),(133,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码错误','2026-06-25 12:05:46'),(134,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 12:05:47'),(135,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 12:46:55'),(136,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 12:58:58'),(137,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 12:59:10'),(138,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 12:59:14'),(139,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 12:59:25'),(140,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:00:25'),(141,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 13:00:44'),(142,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 13:00:52'),(143,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码错误','2026-06-25 13:00:52'),(144,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:09:40'),(145,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:10:26'),(146,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 13:10:37'),(147,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 13:10:46'),(148,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:17:17'),(149,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:17:40'),(150,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 13:17:50'),(151,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 13:18:02'),(152,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码错误','2026-06-25 13:18:02'),(153,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码错误','2026-06-25 13:18:06'),(154,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 13:18:11'),(155,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:18:26'),(156,'reader','127.0.0.1','内网IP','Curl 8.16.0','','1','验证码已失效','2026-06-25 13:23:56'),(157,'admin','127.0.0.1','内网IP','Curl 8.16.0','','1','验证码已失效','2026-06-25 13:26:38'),(158,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:34:12'),(159,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:34:28'),(160,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:34:45'),(161,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:35:36'),(162,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:35:39'),(163,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:38:17'),(164,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:38:20'),(165,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:38:29'),(166,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:38:39'),(167,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:44:40'),(168,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:44:42'),(169,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:44:54'),(170,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:45:02'),(171,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:45:19'),(172,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:45:23'),(173,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:47:01'),(174,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:47:08'),(175,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:47:14'),(176,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:47:18'),(177,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:54:25'),(178,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:54:27'),(179,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 13:54:49'),(180,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 13:55:01'),(181,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 14:12:56'),(182,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 14:13:03'),(183,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 14:13:58'),(184,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 14:14:07'),(185,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 14:31:33'),(186,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 14:31:35'),(187,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 14:35:09'),(188,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 14:35:17'),(189,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 14:40:13'),(190,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 14:40:20'),(191,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 14:41:31'),(192,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 14:41:42'),(193,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:07:11'),(194,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码错误','2026-06-25 15:07:14'),(195,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:07:18'),(196,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:10:25'),(197,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:10:30'),(198,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:14:04'),(199,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 15:14:12'),(200,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码错误','2026-06-25 15:14:23'),(201,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:14:25'),(202,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:16:29'),(203,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:16:32'),(204,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:17:51'),(205,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:18:04'),(206,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:19:56'),(207,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','验证码错误','2026-06-25 15:19:59'),(208,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:20:03'),(209,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:20:07'),(210,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:20:16'),(211,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:22:43'),(212,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:22:45'),(213,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:22:48'),(214,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:22:59'),(215,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:27:23'),(216,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:27:26'),(217,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:27:31'),(218,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:27:39'),(219,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:32:07'),(220,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:32:15'),(221,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:36:41'),(222,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:36:44'),(223,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:36:56'),(224,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:37:05'),(225,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:41:48'),(226,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:41:52'),(227,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:42:20'),(228,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:42:29'),(229,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 15:43:59'),(230,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 15:44:03'),(231,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 16:01:31'),(232,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 16:01:37'),(233,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 16:01:46'),(234,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 16:01:50'),(235,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 16:23:35'),(236,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 16:23:38'),(237,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','1','验证码已失效','2026-06-25 16:59:42'),(238,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 17:02:28'),(239,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 17:02:37'),(240,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 17:03:50'),(241,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 17:03:53'),(242,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 17:14:40'),(243,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 17:14:50'),(244,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 17:15:32'),(245,'reader','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','1','用户不存在/密码错误','2026-06-25 17:15:33'),(246,'reader','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','1','用户不存在/密码错误','2026-06-25 17:15:54'),(247,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 17:15:54'),(248,'reader','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','1','用户不存在/密码错误','2026-06-25 17:16:07'),(249,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 17:16:07'),(250,'reader','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','1','用户不存在/密码错误','2026-06-25 17:16:07'),(251,'reader','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','1','用户不存在/密码错误','2026-06-25 17:16:08'),(252,'reader','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','1','密码输入错误5次，帐户锁定10分钟','2026-06-25 17:16:08'),(253,'reader','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 17:18:22'),(254,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 17:18:23'),(255,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 17:19:19'),(256,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 17:19:53'),(257,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 18:10:50'),(258,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 18:11:54'),(259,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 18:12:00'),(260,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 18:12:03'),(261,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 18:12:39'),(262,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 18:12:40'),(263,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 20:01:07'),(264,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 20:59:20'),(265,'reader','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 20:59:43'),(266,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 21:00:36'),(267,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 21:00:41'),(268,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:14:46'),(269,'reader','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:14:47'),(270,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:15:42'),(271,'reader','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:15:42'),(272,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:16:08'),(273,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:20:55'),(274,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','1','用户不存在/密码错误','2026-06-25 21:20:55'),(275,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:21:07'),(276,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:21:38'),(277,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:21:45'),(278,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:21:45'),(279,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:22:08'),(280,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:22:08'),(281,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:22:38'),(282,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:22:38'),(283,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:23:12'),(284,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:23:12'),(285,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:23:45'),(286,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:23:45'),(287,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:23:54'),(288,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:24:27'),(289,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:24:27'),(290,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:25:07'),(291,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:25:07'),(292,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:25:16'),(293,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:25:16'),(294,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:25:41'),(295,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:25:41'),(296,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:26:00'),(297,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:26:00'),(298,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:26:14'),(299,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:26:50'),(300,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:26:51'),(301,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:28:08'),(302,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:28:08'),(303,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:28:28'),(304,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 21:28:28'),(305,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 21:31:34'),(306,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 21:33:31'),(307,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 21:33:37'),(308,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 21:33:43'),(309,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 21:34:18'),(310,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 21:34:19'),(311,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 21:36:10'),(312,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-25 21:36:18'),(313,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 21:36:20'),(314,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 21:36:47'),(315,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 21:36:48'),(316,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 21:37:18'),(317,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 21:37:35'),(318,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 21:38:00'),(319,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 21:38:01'),(320,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 21:38:31'),(321,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 21:38:35'),(322,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 21:41:20'),(323,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 21:41:21'),(324,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 22:07:42'),(325,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 22:11:04'),(326,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 22:11:15'),(327,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-25 22:11:15'),(328,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 22:13:43'),(329,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 22:19:46'),(330,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 22:20:02'),(331,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 22:21:47'),(332,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 22:21:48'),(333,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 22:22:17'),(334,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 22:22:27'),(335,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 22:22:40'),(336,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 22:22:41'),(337,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 23:05:55'),(338,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 23:06:05'),(339,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-25 23:23:47'),(340,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-25 23:23:48'),(341,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 02:12:49'),(342,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 02:12:50'),(343,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 02:13:58'),(344,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 02:14:05'),(345,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 02:14:38'),(346,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 02:14:38'),(347,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 02:16:12'),(348,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 10:16:51'),(349,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 10:18:37'),(350,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-26 10:18:44'),(351,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 10:18:48'),(352,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 10:22:52'),(353,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 10:22:53'),(354,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 10:43:31'),(355,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 10:45:28'),(356,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 11:02:22'),(357,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 11:02:28'),(358,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 11:28:19'),(359,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 12:09:24'),(360,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 12:09:25'),(361,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 12:24:37'),(362,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 12:31:53'),(363,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 12:31:59'),(364,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 12:32:14'),(365,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 12:32:15'),(366,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 12:49:38'),(367,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 12:49:38'),(368,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 12:52:27'),(369,'zhangsan','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 12:52:27'),(370,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 13:04:28'),(371,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 13:04:59'),(372,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 13:06:57'),(373,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 13:12:21'),(374,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 17:13:10'),(375,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 17:21:35'),(376,'admin','127.0.0.1','内网IP','WindowsPowerShell 5.1.26100.4061','Windows 10.0','0','登录成功','2026-06-26 17:24:49'),(377,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 17:26:34'),(378,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 17:26:36'),(379,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 17:27:56'),(380,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 17:28:02'),(381,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 17:30:51'),(382,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 17:30:52'),(383,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 17:48:57'),(384,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-26 17:49:02'),(385,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 17:49:05'),(386,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 17:54:31'),(387,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 17:54:32'),(388,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 17:55:58'),(389,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:06:35'),(390,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 18:06:41'),(391,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:07:03'),(392,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 18:07:05'),(393,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:07:11'),(394,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 18:07:19'),(395,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:23:50'),(396,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 18:23:56'),(397,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:24:04'),(398,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-26 18:25:11'),(399,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-26 18:25:13'),(400,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-26 18:25:15'),(401,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 18:25:20'),(402,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:34:45'),(403,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 18:34:50'),(404,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:40:14'),(405,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 18:40:22'),(406,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:43:07'),(407,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 18:43:09'),(408,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:47:04'),(409,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 18:47:12'),(410,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:47:34'),(411,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 18:47:37'),(412,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:48:25'),(413,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 18:48:36'),(414,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:54:11'),(415,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 18:54:15'),(416,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 18:55:10'),(417,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 19:01:19'),(418,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 19:07:01'),(419,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 19:07:12'),(420,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 19:08:52'),(421,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 19:09:04'),(422,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 19:14:22'),(423,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 19:14:39'),(424,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-26 19:24:35'),(425,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-26 19:29:27'),(426,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 02:13:43'),(427,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-27 02:25:33'),(428,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 02:25:41'),(429,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-27 02:30:40'),(430,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 02:31:02'),(431,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-27 02:42:55'),(432,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 02:43:09'),(433,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-27 04:07:18'),(434,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 04:07:26'),(435,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-27 04:13:07'),(436,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 04:13:14'),(437,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-27 08:59:49'),(438,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 08:59:54'),(439,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-27 09:11:48'),(440,'reader_zhaoliu','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-27 09:12:00'),(441,'reader_zhaoliu','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 09:12:07'),(442,'reader_zhaoliu','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-27 09:12:47'),(443,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 09:12:57'),(444,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-27 09:13:04'),(445,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-27 09:13:14'),(446,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 09:13:19'),(447,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-27 09:13:25'),(448,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 09:13:29'),(449,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-27 09:13:32'),(450,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 09:13:39'),(451,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 11:06:31'),(452,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-27 11:14:28'),(453,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 11:14:36'),(454,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','1','用户不存在/密码错误','2026-06-27 21:01:42'),(455,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 21:01:46'),(456,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-27 21:02:17'),(457,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 21:04:55'),(458,'admin','127.0.0.1','内网IP','Chrome 149','Windows10','0','退出成功','2026-06-27 21:11:55'),(459,'reader','127.0.0.1','内网IP','Chrome 149','Windows10','0','登录成功','2026-06-27 21:12:03');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2037 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,1,'system',NULL,'','',1,0,'M','0','0','','system','admin','2026-03-06 01:54:37','',NULL,'系统管理目录'),(2,'系统监控',0,2,'monitor',NULL,'','',1,0,'M','0','1','','monitor','admin','2026-03-06 01:54:37','',NULL,'系统监控目录'),(3,'系统工具',0,3,'tool',NULL,'','',1,0,'M','0','1','','tool','admin','2026-03-06 01:54:37','',NULL,'系统工具目录'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2026-03-06 01:54:37','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2026-03-06 01:54:37','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','1','system:menu:list','tree-table','admin','2026-03-06 01:54:37','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','','',1,0,'C','0','1','system:dept:list','tree','admin','2026-03-06 01:54:37','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','','',1,0,'C','0','1','system:post:list','post','admin','2026-03-06 01:54:37','',NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','1','system:dict:list','dict','admin','2026-03-06 01:54:37','',NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','1','system:config:list','edit','admin','2026-03-06 01:54:37','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','1','system:notice:list','message','admin','2026-03-06 01:54:37','',NULL,'通知公告菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2026-03-06 01:54:37','',NULL,'日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','1','monitor:online:list','online','admin','2026-03-06 01:54:37','',NULL,'在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','0','1','monitor:job:list','job','admin','2026-03-06 01:54:37','',NULL,'定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','1','monitor:druid:list','druid','admin','2026-03-06 01:54:37','',NULL,'数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','1','monitor:server:list','server','admin','2026-03-06 01:54:37','',NULL,'服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','1','monitor:cache:list','redis','admin','2026-03-06 01:54:37','',NULL,'缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','1','monitor:cache:list','redis-list','admin','2026-03-06 01:54:37','',NULL,'缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','0','1','tool:build:list','build','admin','2026-03-06 01:54:37','',NULL,'表单构建菜单'),(116,'代码生成',3,2,'gen','tool/gen/index','','',1,0,'C','0','1','tool:gen:list','code','admin','2026-03-06 01:54:37','',NULL,'代码生成菜单'),(117,'系统接口',3,3,'swagger','tool/swagger/index','','',1,0,'C','0','1','tool:swagger:list','swagger','admin','2026-03-06 01:54:37','',NULL,'系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','1','monitor:operlog:list','form','admin','2026-03-06 01:54:37','',NULL,'操作日志菜单'),(501,'登录日志',0,7,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2026-03-06 01:54:37','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2026-03-06 01:54:37','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2026-03-06 01:54:37','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2026-03-06 01:54:37','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2026-03-06 01:54:37','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2026-03-06 01:54:37','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2026-03-06 01:54:37','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2026-03-06 01:54:37','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2026-03-06 01:54:37','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2026-03-06 01:54:37','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2026-03-06 01:54:37','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2026-03-06 01:54:37','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2026-03-06 01:54:37','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2026-03-06 01:54:37','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2026-03-06 01:54:37','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2026-03-06 01:54:37','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2026-03-06 01:54:37','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2026-03-06 01:54:37','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2026-03-06 01:54:37','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2026-03-06 01:54:37','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2026-03-06 01:54:37','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2026-03-06 01:54:37','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2026-03-06 01:54:37','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2026-03-06 01:54:37','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2026-03-06 01:54:37','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2026-03-06 01:54:37','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2026-03-06 01:54:37','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2026-03-06 01:54:37','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2026-03-06 01:54:37','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2026-03-06 01:54:37','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2026-03-06 01:54:37','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2026-03-06 01:54:37','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2026-03-06 01:54:37','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2026-03-06 01:54:37','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2026-03-06 01:54:37','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2026-03-06 01:54:37','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2026-03-06 01:54:37','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2026-03-06 01:54:37','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2026-03-06 01:54:37','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2026-03-06 01:54:37','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2026-03-06 01:54:37','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2026-03-06 01:54:37','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2026-03-06 01:54:37','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2026-03-06 01:54:37','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2026-03-06 01:54:37','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2026-03-06 01:54:37','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2026-03-06 01:54:37','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2026-03-06 01:54:37','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2026-03-06 01:54:37','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2026-03-06 01:54:37','',NULL,''),(2000,'图书馆管理',0,4,'library/admin',NULL,'','LibraryAdmin',1,0,'M','0','0','','education','admin','2026-06-25 13:14:51','',NULL,'图书馆后台管理目录'),(2001,'数据概览',2000,1,'overview','library/admin/index','','AdminOverview',1,0,'C','0','0','','chart','admin','2026-06-25 13:14:51','',NULL,'图书馆数据概览'),(2002,'图书管理',2000,2,'books','library/admin/books','','AdminBooks',1,0,'C','0','0','','component','admin','2026-06-25 13:14:51','',NULL,'图书维护与库存管理'),(2003,'读者管理',2000,3,'readers','library/admin/readers','','AdminReaders',1,0,'C','0','0','','peoples','admin','2026-06-25 13:14:51','',NULL,'读者资料与权益管理'),(2004,'借阅订单',2000,4,'orders','library/admin/orders','','AdminOrders',1,0,'C','0','0','','documentation','admin','2026-06-25 13:14:51','',NULL,'借阅配送订单管理'),(2005,'排队管理',2000,5,'queues','library/admin/queues','','AdminQueues',1,0,'C','0','0','','list','admin','2026-06-25 13:14:51','',NULL,'排队预约记录管理'),(2006,'规则配置',2000,6,'rules','library/admin/rules','','AdminRules',1,0,'C','0','0','','system','admin','2026-06-25 13:14:51','',NULL,'借阅配送规则维护');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) NOT NULL COMMENT '公告标题',
  `notice_type` char(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 若依新版本发布啦','2',0xE696B0E78988E69CACE58685E5AEB9,'0','admin','2026-03-06 01:54:38','',NULL,'管理员'),(2,'维护通知：2018-07-01 若依系统凌晨维护','1',0xE7BBB4E68AA4E58685E5AEB9,'0','admin','2026-03-06 01:54:38','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (100,'创建表',0,'com.ruoyi.generator.controller.GenController.createTableSave()','POST',1,'admin','研发部门','/tool/gen/createTable','127.0.0.1','内网IP','{\"sql\":\"DROP TABLE IF EXISTS `book`;\\nCREATE TABLE `book` (\\n  `book_id` bigint NOT NULL AUTO_INCREMENT COMMENT \'图书的唯一标识符\',\\n  `title` varchar(255) NOT NULL COMMENT \'书名\',\\n  `author` varchar(100) DEFAULT NULL COMMENT \'作者\',\\n  `isbn` varchar(60) NOT NULL,\\n  `publisher` varchar(100) DEFAULT NULL COMMENT \'出版社\',\\n  `publication_year` int DEFAULT NULL COMMENT \'出版年份\',\\n  `cover_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT \'封面图片\',\\n  `price` decimal(10,2) DEFAULT NULL COMMENT \'价格\',\\n  `category_id` bigint unsigned DEFAULT NULL COMMENT \'图书分类号\\\\n\',\\n  `language` varchar(50) DEFAULT NULL COMMENT \'图书语言\',\\n  `total_copies` int unsigned DEFAULT \'0\' COMMENT \'总副本数\',\\n  `available_copies` int unsigned DEFAULT \'0\' COMMENT \'可用副本数\',\\n  `location` varchar(255) DEFAULT NULL COMMENT \'馆藏地址\',\\n  `status` tinyint unsigned DEFAULT \'1\' COMMENT \'状态:AVAILABLE(1, \\\"在架\\\"),\\\\n// 表示书籍下架的状态\\\\nOFF_SHELF(2, \\\"未上架\\\");\\\\n\',\\n  `description` text COMMENT \'图书介绍\',\\n  `remark` varchar(500) DEFAULT NULL COMMENT \'备注\',\\n  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_by` varchar(60) DEFAULT NULL COMMENT \'创建人\',\\n  `updated_by` varchar(60) DEFAULT NULL COMMENT \'更新人\',\\n  `attachment_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT \'图书附件URL\',\\n  PRIMARY KEY (`book_id`),\\n  KEY `idx_isbn` (`isbn`),\\n  KEY `idx_author` (`author`)\\n) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8mb3 COMMENT=\'图书信息表\';\\n\"}','{\"msg\":\"创建表结构异常\",\"code\":500}',0,NULL,'2026-03-06 02:16:57',7),(101,'创建表',0,'com.ruoyi.generator.controller.GenController.createTableSave()','POST',1,'admin','研发部门','/tool/gen/createTable','127.0.0.1','内网IP','{\"sql\":\"DROP TABLE IF EXISTS `book`;\\nCREATE TABLE `book` (\\n  `book_id` bigint NOT NULL AUTO_INCREMENT COMMENT \'图书的唯一标识符\',\\n  `title` varchar(255) NOT NULL COMMENT \'书名\',\\n  `author` varchar(100) DEFAULT NULL COMMENT \'作者\',\\n  `isbn` varchar(60) NOT NULL,\\n  `publisher` varchar(100) DEFAULT NULL COMMENT \'出版社\',\\n  `publication_year` int DEFAULT NULL COMMENT \'出版年份\',\\n  `cover_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT \'封面图片\',\\n  `price` decimal(10,2) DEFAULT NULL COMMENT \'价格\',\\n  `category_id` bigint unsigned DEFAULT NULL COMMENT \'图书分类号\\\\n\',\\n  `language` varchar(50) DEFAULT NULL COMMENT \'图书语言\',\\n  `total_copies` int unsigned DEFAULT \'0\' COMMENT \'总副本数\',\\n  `available_copies` int unsigned DEFAULT \'0\' COMMENT \'可用副本数\',\\n  `location` varchar(255) DEFAULT NULL COMMENT \'馆藏地址\',\\n  `status` tinyint unsigned DEFAULT \'1\' COMMENT \'状态:AVAILABLE(1, \\\"在架\\\"),\\\\n// 表示书籍下架的状态\\\\nOFF_SHELF(2, \\\"未上架\\\");\\\\n\',\\n  `description` text COMMENT \'图书介绍\',\\n  `remark` varchar(500) DEFAULT NULL COMMENT \'备注\',\\n  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_by` varchar(60) DEFAULT NULL COMMENT \'创建人\',\\n  `updated_by` varchar(60) DEFAULT NULL COMMENT \'更新人\',\\n  `attachment_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT \'图书附件URL\',\\n  PRIMARY KEY (`book_id`),\\n  KEY `idx_isbn` (`isbn`),\\n  KEY `idx_author` (`author`)\\n) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8mb3 COMMENT=\'图书信息表\';\\n\"}','{\"msg\":\"创建表结构异常\",\"code\":500}',0,NULL,'2026-03-06 02:17:08',5),(102,'创建表',0,'com.ruoyi.generator.controller.GenController.createTableSave()','POST',1,'admin','研发部门','/tool/gen/createTable','127.0.0.1','内网IP','{\"sql\":\"CREATE TABLE `book` (\\n  `book_id` bigint NOT NULL AUTO_INCREMENT COMMENT \'图书的唯一标识符\',\\n  `title` varchar(255) NOT NULL COMMENT \'书名\',\\n  `author` varchar(100) DEFAULT NULL COMMENT \'作者\',\\n  `isbn` varchar(60) NOT NULL,\\n  `publisher` varchar(100) DEFAULT NULL COMMENT \'出版社\',\\n  `publication_year` int DEFAULT NULL COMMENT \'出版年份\',\\n  `cover_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT \'封面图片\',\\n  `price` decimal(10,2) DEFAULT NULL COMMENT \'价格\',\\n  `category_id` bigint unsigned DEFAULT NULL COMMENT \'图书分类号\\\\n\',\\n  `language` varchar(50) DEFAULT NULL COMMENT \'图书语言\',\\n  `total_copies` int unsigned DEFAULT \'0\' COMMENT \'总副本数\',\\n  `available_copies` int unsigned DEFAULT \'0\' COMMENT \'可用副本数\',\\n  `location` varchar(255) DEFAULT NULL COMMENT \'馆藏地址\',\\n  `status` tinyint unsigned DEFAULT \'1\' COMMENT \'状态:AVAILABLE(1, \\\"在架\\\"),\\\\n// 表示书籍下架的状态\\\\nOFF_SHELF(2, \\\"未上架\\\");\\\\n\',\\n  `description` text COMMENT \'图书介绍\',\\n  `remark` varchar(500) DEFAULT NULL COMMENT \'备注\',\\n  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_by` varchar(60) DEFAULT NULL COMMENT \'创建人\',\\n  `updated_by` varchar(60) DEFAULT NULL COMMENT \'更新人\',\\n  `attachment_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT \'图书附件URL\',\\n  PRIMARY KEY (`book_id`),\\n  KEY `idx_isbn` (`isbn`),\\n  KEY `idx_author` (`author`)\\n) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8mb3 COMMENT=\'图书信息表\';\"}','{\"msg\":\"创建表结构异常\",\"code\":500}',0,NULL,'2026-03-06 02:19:33',146),(103,'创建表',0,'com.ruoyi.generator.controller.GenController.createTableSave()','POST',1,'admin','研发部门','/tool/gen/createTable','127.0.0.1','内网IP','{\"sql\":\"CREATE TABLE `book` (\\n  `book_id` bigint NOT NULL AUTO_INCREMENT COMMENT \'图书的唯一标识符\',\\n  `title` varchar(255) NOT NULL COMMENT \'书名\',\\n  `author` varchar(100) DEFAULT NULL COMMENT \'作者\',\\n  `isbn` varchar(60) NOT NULL,\\n  `publisher` varchar(100) DEFAULT NULL COMMENT \'出版社\',\\n  `publication_year` int DEFAULT NULL COMMENT \'出版年份\',\\n  `cover_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT \'封面图片\',\\n  `price` decimal(10,2) DEFAULT NULL COMMENT \'价格\',\\n  `category_id` bigint unsigned DEFAULT NULL COMMENT \'图书分类号\\\\n\',\\n  `language` varchar(50) DEFAULT NULL COMMENT \'图书语言\',\\n  `total_copies` int unsigned DEFAULT \'0\' COMMENT \'总副本数\',\\n  `available_copies` int unsigned DEFAULT \'0\' COMMENT \'可用副本数\',\\n  `location` varchar(255) DEFAULT NULL COMMENT \'馆藏地址\',\\n  `status` tinyint unsigned DEFAULT \'1\' COMMENT \'状态:AVAILABLE(1, \\\"在架\\\"),\\\\n// 表示书籍下架的状态\\\\nOFF_SHELF(2, \\\"未上架\\\");\\\\n\',\\n  `description` text COMMENT \'图书介绍\',\\n  `remark` varchar(500) DEFAULT NULL COMMENT \'备注\',\\n  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_by` varchar(60) DEFAULT NULL COMMENT \'创建人\',\\n  `updated_by` varchar(60) DEFAULT NULL COMMENT \'更新人\',\\n  `attachment_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT \'图书附件URL\',\\n  PRIMARY KEY (`book_id`),\\n  KEY `idx_isbn` (`isbn`),\\n  KEY `idx_author` (`author`)\\n) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8mb3 COMMENT=\'图书信息表\';\"}','{\"msg\":\"创建表结构异常\",\"code\":500}',0,NULL,'2026-03-06 03:18:49',3),(104,'创建表',0,'com.ruoyi.generator.controller.GenController.createTableSave()','POST',1,'admin','研发部门','/tool/gen/createTable','127.0.0.1','内网IP','{\"sql\":\"drop table if exists sys_student;\\ncreate table sys_student (\\n  student_id           int(11)         auto_increment    comment \'编号\',\\n  student_name         varchar(30)     default \'\'        comment \'学生名称\',\\n  student_age          int(3)          default null      comment \'年龄\',\\n  student_hobby        varchar(30)     default \'\'        comment \'爱好（0代码 1音乐 2电影）\',\\n  student_sex          char(1)         default \'0\'       comment \'性别（0男 1女 2未知）\',\\n  student_status       char(1)         default \'0\'       comment \'状态（0正常 1停用）\',\\n  student_birthday     datetime                          comment \'生日\',\\n  primary key (student_id)\\n) engine=innodb auto_increment=1 comment = \'学生信息表\';\"}','{\"msg\":\"创建表结构异常\",\"code\":500}',0,NULL,'2026-03-06 03:24:12',2),(105,'创建表',0,'com.ruoyi.generator.controller.GenController.createTableSave()','POST',1,'admin','研发部门','/tool/gen/createTable','127.0.0.1','内网IP','{\"sql\":\"drop table if exists sys_student;\\ncreate table sys_student (\\n  student_id           int(11)         auto_increment    comment \'编号\',\\n  student_name         varchar(30)     default \'\'        comment \'学生名称\',\\n  student_age          int(3)          default null      comment \'年龄\',\\n  student_hobby        varchar(30)     default \'\'        comment \'爱好（0代码 1音乐 2电影）\',\\n  student_sex          char(1)         default \'0\'       comment \'性别（0男 1女 2未知）\',\\n  student_status       char(1)         default \'0\'       comment \'状态（0正常 1停用）\',\\n  student_birthday     datetime                          comment \'生日\',\\n  primary key (student_id)\\n) engine=innodb auto_increment=1 comment = \'学生信息表\';\"}','{\"msg\":\"创建表结构异常\",\"code\":500}',0,NULL,'2026-03-06 04:01:53',2),(106,'创建表',0,'com.ruoyi.generator.controller.GenController.createTableSave()','POST',1,'admin','研发部门','/tool/gen/createTable','127.0.0.1','内网IP','{\"sql\":\"DROP TABLE IF EXISTS `book`;\\nCREATE TABLE `book` (\\n  `book_id` bigint NOT NULL AUTO_INCREMENT COMMENT \'图书的唯一标识符\',\\n  `title` varchar(255) NOT NULL COMMENT \'书名\',\\n  `author` varchar(100) DEFAULT NULL COMMENT \'作者\',\\n  `isbn` varchar(60) NOT NULL,\\n  `publisher` varchar(100) DEFAULT NULL COMMENT \'出版社\',\\n  `publication_year` int DEFAULT NULL COMMENT \'出版年份\',\\n  `cover_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT \'封面图片\',\\n  `price` decimal(10,2) DEFAULT NULL COMMENT \'价格\',\\n  `category_id` bigint unsigned DEFAULT NULL COMMENT \'图书分类号\',\\n  `language` varchar(50) DEFAULT NULL COMMENT \'图书语言\',\\n  `total_copies` int unsigned DEFAULT \'0\' COMMENT \'总副本数\',\\n  `available_copies` int unsigned DEFAULT \'0\' COMMENT \'可用副本数\',\\n  `location` varchar(255) DEFAULT NULL COMMENT \'馆藏地址\',\\n  `status` tinyint unsigned DEFAULT \'1\' COMMENT \'状态:AVAILABLE(1, \\\"在架\\\"),表示书籍下架的状态OFF_SHELF(2, \\\"未上架\\\");\',\\n  `description` text COMMENT \'图书介绍\',\\n  `remark` varchar(500) DEFAULT NULL COMMENT \'备注\',\\n  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_by` varchar(60) DEFAULT NULL COMMENT \'创建人\',\\n  `updated_by` varchar(60) DEFAULT NULL COMMENT \'更新人\',\\n  `attachment_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT \'图书附件URL\',\\n  PRIMARY KEY (`book_id`),\\n  KEY `idx_isbn` (`isbn`),\\n  KEY `idx_author` (`author`)\\n) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8mb3 COMMENT=\'图书信息表\';\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-06 04:07:36',475),(107,'创建表',0,'com.ruoyi.generator.controller.GenController.createTableSave()','POST',1,'admin','研发部门','/tool/gen/createTable','127.0.0.1','内网IP','{\"sql\":\"DROP TABLE IF EXISTS `book_category`;\\nCREATE TABLE `book_category` (\\n  `category_id` bigint NOT NULL AUTO_INCREMENT COMMENT \'图书分类ID\',\\n  `category_name` varchar(100) NOT NULL COMMENT \'图书分类名称\',\\n  `status` tinyint DEFAULT \'1\' COMMENT \'分类状态：1=启用，0=禁用\',\\n  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT \'创建时间\',\\n  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_by` varchar(60) DEFAULT NULL COMMENT \'创建人\',\\n  `updated_by` varchar(60) DEFAULT NULL COMMENT \'更新人\',\\n  `description` varchar(150) DEFAULT NULL,\\n  PRIMARY KEY (`category_id`),\\n  KEY `idx_status` (`status`)\\n) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb3 COMMENT=\'图书分类表\';\\n\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-06 04:07:58',104),(108,'创建表',0,'com.ruoyi.generator.controller.GenController.createTableSave()','POST',1,'admin','研发部门','/tool/gen/createTable','127.0.0.1','内网IP','{\"sql\":\"DROP TABLE IF EXISTS `book_copy`;\\nCREATE TABLE `book_copy` (\\n  `copy_id` bigint NOT NULL AUTO_INCREMENT COMMENT \'副本ID\',\\n  `book_id` bigint NOT NULL COMMENT \'图书ID\',\\n  `barcode` varchar(255) NOT NULL COMMENT \'条形码\',\\n  `location` varchar(255) DEFAULT NULL COMMENT \'存放位置\',\\n  `status` tinyint DEFAULT \'1\' COMMENT \'副本状态：AVAILABLE(1, \\\"可借\\\"),\\\\nBORROWED(2, \\\"已借出\\\"),\\\\nDAMAGED(3, \\\"损坏\\\"),\\\\nLOST(4, \\\"遗失\\\");\\\\n\\\\n\',\\n  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT \'创建时间\',\\n  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  PRIMARY KEY (`copy_id`),\\n  UNIQUE KEY `barcode` (`barcode`)\\n) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT=\'图书副本表\';\\n\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-06 04:08:17',108),(109,'创建表',0,'com.ruoyi.generator.controller.GenController.createTableSave()','POST',1,'admin','研发部门','/tool/gen/createTable','127.0.0.1','内网IP','{\"sql\":\"DROP TABLE IF EXISTS `borrow_record`;\\nCREATE TABLE `borrow_record` (\\n  `record_id` bigint NOT NULL AUTO_INCREMENT COMMENT \'借阅记录ID\',\\n  `copy_id` bigint NOT NULL COMMENT \'图书副本ID\',\\n  `reader_id` bigint NOT NULL COMMENT \'读者ID\',\\n  `borrow_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT \'借阅日期\',\\n  `due_date` datetime NOT NULL COMMENT \'应还日期\',\\n  `return_date` datetime DEFAULT NULL COMMENT \'实际还书日期\',\\n  `overdue_days` int DEFAULT \'0\' COMMENT \'逾期天数\',\\n  `status` tinyint DEFAULT \'1\' COMMENT \'借阅状态：BORROWED(1, \\\"借出\\\"),\\\\nRETURNED(2, \\\"已归还\\\"),\\\\nOVERDUE(3, \\\"逾期\\\"),\\\\nLOST(4, \\\"遗失\\\");\\\\n\',\\n  `is_overdue` tinyint(1) DEFAULT NULL COMMENT \'是否逾期\',\\n  `fine` decimal(10,2) DEFAULT \'0.00\' COMMENT \'罚款金额\',\\n  `remark` varchar(500) DEFAULT NULL COMMENT \'备注\',\\n  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT \'创建时间\',\\n  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_by` varchar(60) DEFAULT NULL COMMENT \'创建人\',\\n  `updated_by` varchar(60) DEFAULT NULL COMMENT \'更新人\',\\n  PRIMARY KEY (`record_id`),\\n  KEY `idx_copy_id` (`copy_id`),\\n  KEY `idx_reader_id` (`reader_id`)\\n) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8mb3 COMMENT=\'借阅记录表\';\\n\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-06 04:08:34',158),(110,'创建表',0,'com.ruoyi.generator.controller.GenController.createTableSave()','POST',1,'admin','研发部门','/tool/gen/createTable','127.0.0.1','内网IP','{\"sql\":\"DROP TABLE IF EXISTS `reader`;\\nCREATE TABLE `reader` (\\n  `reader_id` bigint NOT NULL AUTO_INCREMENT,\\n  `reader_number` varchar(50) NOT NULL COMMENT \'学号/工号\',\\n  `name` varchar(100) NOT NULL COMMENT \'读者姓名\',\\n  `grade_major` varchar(150) DEFAULT NULL COMMENT \'年级专业\',\\n  `gender` char(1) DEFAULT NULL COMMENT \'性别，M-男，F-女\',\\n  `avatar_url` varchar(255) DEFAULT NULL COMMENT \'读者相片\',\\n  `type` tinyint DEFAULT \'1\' COMMENT \'读者类型：1=学生，2=职工\',\\n  `borrow_limit` int DEFAULT \'5\' COMMENT \'借书额度\',\\n  `email` varchar(100) DEFAULT NULL COMMENT \'邮箱地址\',\\n  `phone` varchar(20) DEFAULT NULL COMMENT \'联系电话\',\\n  `department_id` bigint NOT NULL COMMENT \'所属部门ID\',\\n  `status` tinyint DEFAULT \'1\' COMMENT \'读者状态：\\\\nNORMAL(1, \\\"正常\\\"),\\\\nLOSS(2, \\\"挂失\\\"),\\\\nCANCEL(3, \\\"注销\\\");\\\\n\',\\n  `user_id` bigint DEFAULT NULL COMMENT \'关联的用户ID\',\\n  `remark` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT \'备注\',\\n  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT \'创建时间\',\\n  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `created_by` varchar(60) DEFAULT NULL COMMENT \'创建人\',\\n  `updated_by` varchar(60) DEFAULT NULL COMMENT \'更新人\',\\n  PRIMARY KEY (`reader_id`),\\n  UNIQUE KEY `email` (`email`),\\n  UNIQUE KEY `phone` (`phone`),\\n  KEY `reader_number` (`reader_number`),\\n  KEY `email_2` (`email`),\\n  KEY `phone_2` (`phone`),\\n  KEY `fk_user_id` (`user_id`)\\n) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb3 COMMENT=\'读者表\';\\n\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-06 04:08:52',189),(111,'创建表',0,'com.ruoyi.generator.controller.GenController.createTableSave()','POST',1,'admin','研发部门','/tool/gen/createTable','127.0.0.1','内网IP','{\"sql\":\"DROP TABLE IF EXISTS `reservation`;\\nCREATE TABLE `reservation` (\\n  `res_id` bigint unsigned NOT NULL AUTO_INCREMENT,\\n  `book_id` bigint NOT NULL COMMENT \'图书ID\',\\n  `reader_id` int NOT NULL COMMENT \'读者ID\',\\n  `reservation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT \'预约日期\',\\n  `status` tinyint DEFAULT \'1\' COMMENT \'预约状态：1=待处理，2=已完成，3=已取消,4-超期作废\',\\n  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT \'创建时间\',\\n  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT \'更新时间\',\\n  `remark` varchar(1024) DEFAULT NULL COMMENT \'备注\',\\n  `created_by` varchar(60) DEFAULT NULL COMMENT \'创建人\',\\n  `updated_by` varchar(60) DEFAULT NULL COMMENT \'更新人\',\\n  PRIMARY KEY (`res_id`),\\n  KEY `reader_id` (`reader_id`),\\n  KEY `book_id` (`book_id`)\\n) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3 COMMENT=\'预约表\';\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-06 04:09:09',100),(112,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"reservation,reader,borrow_record,book_copy,book_category,book\"}',NULL,0,NULL,'2026-03-06 04:09:34',555),(113,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"reader\",\"className\":\"Reader\",\"columns\":[{\"capJavaField\":\"ReaderId\",\"columnId\":52,\"columnName\":\"reader_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ReaderNumber\",\"columnComment\":\"学号/工号\",\"columnId\":53,\"columnName\":\"reader_number\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"读者姓名\",\"columnId\":54,\"columnName\":\"name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"GradeMajor\",\"columnComment\":\"年级专业\",\"columnId\":55,\"columnName\":\"grade_major\",\"columnType\":\"varchar(150)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaFie','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:17:31',170),(114,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"reader\",\"className\":\"Reader\",\"columns\":[{\"capJavaField\":\"ReaderId\",\"columnId\":52,\"columnName\":\"reader_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:17:31\",\"usableColumn\":false},{\"capJavaField\":\"ReaderNumber\",\"columnComment\":\"学号/工号\",\"columnId\":53,\"columnName\":\"reader_number\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:17:31\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"读者姓名\",\"columnId\":54,\"columnName\":\"name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:17:31\",\"usableColumn\":false},{\"capJavaField\":\"GradeMajor\",\"columnComment\":\"年级专业\",\"columnId\":55,\"columnName\":\"grade_major\",\"columnType\":\"varchar(150)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isE','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:27:17',84),(115,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"record\",\"className\":\"BorrowRecord\",\"columns\":[{\"capJavaField\":\"RecordId\",\"columnComment\":\"借阅记录ID\",\"columnId\":37,\"columnName\":\"record_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"recordId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"CopyId\",\"columnComment\":\"图书副本ID\",\"columnId\":38,\"columnName\":\"copy_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"copyId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ReaderId\",\"columnComment\":\"读者ID\",\"columnId\":39,\"columnName\":\"reader_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"BorrowDate\",\"columnComment\":\"借阅日期\",\"columnId\":40,\"columnName\":\"borrow_date\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\"','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:35:38',102),(116,'字典类型',1,'com.ruoyi.web.controller.system.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"读者类型\",\"dictType\":\"reader_type\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:46:16',27),(117,'字典类型',2,'com.ruoyi.web.controller.system.SysDictTypeController.edit()','PUT',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-03-09 01:46:16\",\"dictId\":100,\"dictName\":\"读者类型\",\"dictType\":\"reader_type\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:46:24',39),(118,'字典类型',2,'com.ruoyi.web.controller.system.SysDictTypeController.edit()','PUT',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-03-09 01:46:16\",\"dictId\":100,\"dictName\":\"读者类型\",\"dictType\":\"reader_type\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:46:53',35),(119,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"学生\",\"dictSort\":0,\"dictType\":\"reader_type\",\"dictValue\":\"1\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:49:32',27),(120,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"职工\",\"dictSort\":1,\"dictType\":\"reader_type\",\"dictValue\":\"2\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:49:44',15),(121,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"reader\",\"className\":\"Reader\",\"columns\":[{\"capJavaField\":\"ReaderId\",\"columnId\":52,\"columnName\":\"reader_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:27:17\",\"usableColumn\":false},{\"capJavaField\":\"ReaderNumber\",\"columnComment\":\"学号/工号\",\"columnId\":53,\"columnName\":\"reader_number\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:27:17\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"读者姓名\",\"columnId\":54,\"columnName\":\"name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:27:17\",\"usableColumn\":false},{\"capJavaField\":\"GradeMajor\",\"columnComment\":\"年级专业\",\"columnId\":55,\"columnName\":\"grade_major\",\"columnType\":\"varchar(150)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"is','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:50:53',88),(122,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"reader\",\"className\":\"Reader\",\"columns\":[{\"capJavaField\":\"ReaderId\",\"columnId\":52,\"columnName\":\"reader_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:50:53\",\"usableColumn\":false},{\"capJavaField\":\"ReaderNumber\",\"columnComment\":\"学号/工号\",\"columnId\":53,\"columnName\":\"reader_number\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:50:53\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"读者姓名\",\"columnId\":54,\"columnName\":\"name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:50:53\",\"usableColumn\":false},{\"capJavaField\":\"GradeMajor\",\"columnComment\":\"年级专业\",\"columnId\":55,\"columnName\":\"grade_major\",\"columnType\":\"varchar(150)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"is','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:51:33',79),(123,'字典类型',1,'com.ruoyi.web.controller.system.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"借阅状态\",\"dictType\":\"borrow_status\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:52:17',20),(124,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"借出\",\"dictSort\":0,\"dictType\":\"borrow_status\",\"dictValue\":\"1\",\"listClass\":\"primary\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:53:09',19),(125,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"已归还\",\"dictSort\":1,\"dictType\":\"borrow_status\",\"dictValue\":\"2\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:53:29',37),(126,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"逾期\",\"dictSort\":2,\"dictType\":\"borrow_status\",\"dictValue\":\"3\",\"listClass\":\"warning\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:53:53',26),(127,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"遗失\",\"dictSort\":4,\"dictType\":\"borrow_status\",\"dictValue\":\"3\",\"listClass\":\"danger\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:54:06',25),(128,'字典数据',2,'com.ruoyi.web.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-03-09 01:54:06\",\"default\":false,\"dictCode\":105,\"dictLabel\":\"遗失\",\"dictSort\":3,\"dictType\":\"borrow_status\",\"dictValue\":\"4\",\"isDefault\":\"N\",\"listClass\":\"danger\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:54:22',20),(129,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"reader\",\"className\":\"Reader\",\"columns\":[{\"capJavaField\":\"ReaderId\",\"columnId\":52,\"columnName\":\"reader_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:27:17\",\"usableColumn\":false},{\"capJavaField\":\"ReaderNumber\",\"columnComment\":\"学号/工号\",\"columnId\":53,\"columnName\":\"reader_number\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:27:17\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"读者姓名\",\"columnId\":54,\"columnName\":\"name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:27:17\",\"usableColumn\":false},{\"capJavaField\":\"GradeMajor\",\"columnComment\":\"年级专业\",\"columnId\":55,\"columnName\":\"grade_major\",\"columnType\":\"varchar(150)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isE','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 01:54:31',97),(130,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"record\",\"className\":\"BorrowRecord\",\"columns\":[{\"capJavaField\":\"RecordId\",\"columnComment\":\"借阅记录ID\",\"columnId\":37,\"columnName\":\"record_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"recordId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:35:38\",\"usableColumn\":false},{\"capJavaField\":\"CopyId\",\"columnComment\":\"图书副本ID\",\"columnId\":38,\"columnName\":\"copy_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"copyId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:35:38\",\"usableColumn\":false},{\"capJavaField\":\"ReaderId\",\"columnComment\":\"读者ID\",\"columnId\":39,\"columnName\":\"reader_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:35:38\",\"usableColumn\":false},{\"capJavaField\":\"BorrowDate\",\"columnComment\":\"借阅日期\",\"columnId\":40,\"columnName\":\"borrow_date\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:02:43',105),(131,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"copy\",\"className\":\"BookCopy\",\"columns\":[{\"capJavaField\":\"CopyId\",\"columnComment\":\"副本ID\",\"columnId\":30,\"columnName\":\"copy_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:16\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"copyId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"BookId\",\"columnComment\":\"图书ID\",\"columnId\":31,\"columnName\":\"book_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:16\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"bookId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Barcode\",\"columnComment\":\"条形码\",\"columnId\":32,\"columnName\":\"barcode\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:16\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"barcode\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Location\",\"columnComment\":\"存放位置\",\"columnId\":33,\"columnName\":\"location\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:16\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"lo','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:13:15',47),(132,'字典类型',1,'com.ruoyi.web.controller.system.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"图书分类状态\",\"dictType\":\"category_status\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:14:40',21),(133,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"启用\",\"dictSort\":0,\"dictType\":\"category_status\",\"dictValue\":\"1\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:14:58',15),(134,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"禁用\",\"dictSort\":1,\"dictType\":\"category_status\",\"dictValue\":\"0\",\"listClass\":\"danger\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:15:15',20),(135,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"category\",\"className\":\"BookCategory\",\"columns\":[{\"capJavaField\":\"CategoryId\",\"columnComment\":\"图书分类ID\",\"columnId\":22,\"columnName\":\"category_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"categoryId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"CategoryName\",\"columnComment\":\"图书分类名称\",\"columnId\":23,\"columnName\":\"category_name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"categoryName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Status\",\"columnComment\":\"分类状态：1=启用，0=禁用\",\"columnId\":24,\"columnName\":\"status\",\"columnType\":\"tinyint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"radio\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"status\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"CreatedTime\",\"columnComment\":\"创建时间\",\"columnId\":25,\"columnName\":\"created_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:15:32',43),(136,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"category\",\"className\":\"BookCategory\",\"columns\":[{\"capJavaField\":\"CategoryId\",\"columnComment\":\"图书分类ID\",\"columnId\":22,\"columnName\":\"category_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"categoryId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:15:31\",\"usableColumn\":false},{\"capJavaField\":\"CategoryName\",\"columnComment\":\"图书分类名称\",\"columnId\":23,\"columnName\":\"category_name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"categoryName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:15:31\",\"usableColumn\":false},{\"capJavaField\":\"Status\",\"columnComment\":\"分类状态：1=启用，0=禁用\",\"columnId\":24,\"columnName\":\"status\",\"columnType\":\"tinyint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:58\",\"dictType\":\"category_status\",\"edit\":true,\"htmlType\":\"radio\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"status\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:15:31\",\"usableColumn\":false},{\"capJavaField\":\"CreatedTime\",\"columnComment\":\"创建时间\",\"columnId\":25,\"columnName\":\"created_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:58\",\"dictType\":\"\",\"e','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:16:18',55),(137,'字典类型',1,'com.ruoyi.web.controller.system.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"图书状态\",\"dictType\":\"book_status\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:49:38',17),(138,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"在架\",\"dictSort\":0,\"dictType\":\"book_status\",\"dictValue\":\"1\",\"listClass\":\"success\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:50:02',17),(139,'字典数据',1,'com.ruoyi.web.controller.system.SysDictDataController.add()','POST',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"未上架\",\"dictSort\":1,\"dictType\":\"book_status\",\"dictValue\":\"2\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:50:14',19),(140,'字典数据',2,'com.ruoyi.web.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-03-09 02:50:13\",\"default\":false,\"dictCode\":109,\"dictLabel\":\"未上架\",\"dictSort\":1,\"dictType\":\"book_status\",\"dictValue\":\"2\",\"isDefault\":\"N\",\"listClass\":\"info\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:50:21',22),(141,'字典数据',2,'com.ruoyi.web.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"createTime\":\"2026-03-09 01:49:32\",\"default\":false,\"dictCode\":100,\"dictLabel\":\"学生\",\"dictSort\":0,\"dictType\":\"reader_type\",\"dictValue\":\"1\",\"isDefault\":\"N\",\"listClass\":\"info\",\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:50:35',21),(142,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"book\",\"className\":\"Book\",\"columns\":[{\"capJavaField\":\"BookId\",\"columnComment\":\"图书的唯一标识符\",\"columnId\":1,\"columnName\":\"book_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:36\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"bookId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"书名\",\"columnId\":2,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Author\",\"columnComment\":\"作者\",\"columnId\":3,\"columnName\":\"author\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"author\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Isbn\",\"columnId\":4,\"columnName\":\"isbn\",\"columnType\":\"varchar(60)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"isbn\",\"javaType\":\"String\",\"list\":true,\"','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:50:55',91),(143,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"book\",\"className\":\"Book\",\"columns\":[{\"capJavaField\":\"BookId\",\"columnComment\":\"图书的唯一标识符\",\"columnId\":1,\"columnName\":\"book_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:36\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"bookId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:50:55\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"书名\",\"columnId\":2,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:50:55\",\"usableColumn\":false},{\"capJavaField\":\"Author\",\"columnComment\":\"作者\",\"columnId\":3,\"columnName\":\"author\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"author\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:50:55\",\"usableColumn\":false},{\"capJavaField\":\"Isbn\",\"columnId\":4,\"columnName\":\"isbn\",\"columnType\":\"varchar(60)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:52:28',96),(144,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"reservation\",\"className\":\"Reservation\",\"columns\":[{\"capJavaField\":\"ResId\",\"columnId\":70,\"columnName\":\"res_id\",\"columnType\":\"bigint unsigned\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":false,\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"resId\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"BookId\",\"columnComment\":\"图书ID\",\"columnId\":71,\"columnName\":\"book_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"bookId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ReaderId\",\"columnComment\":\"读者ID\",\"columnId\":72,\"columnName\":\"reader_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"ReservationDate\",\"columnComment\":\"预约日期\",\"columnId\":73,\"columnName\":\"reservation_date\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"reservationDate\",\"j','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 02:52:37',59),(145,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"reservation,reader,borrow_record,book_copy,book_category,book\"}',NULL,0,NULL,'2026-03-09 02:52:43',1159),(146,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"reservation\",\"className\":\"Reservation\",\"columns\":[{\"capJavaField\":\"ResId\",\"columnId\":70,\"columnName\":\"res_id\",\"columnType\":\"bigint unsigned\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":false,\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"resId\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:52:37\",\"usableColumn\":false},{\"capJavaField\":\"BookId\",\"columnComment\":\"图书ID\",\"columnId\":71,\"columnName\":\"book_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"bookId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:52:37\",\"usableColumn\":false},{\"capJavaField\":\"ReaderId\",\"columnComment\":\"读者ID\",\"columnId\":72,\"columnName\":\"reader_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:52:37\",\"usableColumn\":false},{\"capJavaField\":\"ReservationDate\",\"columnComment\":\"预约日期\",\"columnId\":73,\"columnName\":\"reservation_date\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 03:02:08',59),(147,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"reservation\",\"className\":\"Reservation\",\"columns\":[{\"capJavaField\":\"ResId\",\"columnId\":70,\"columnName\":\"res_id\",\"columnType\":\"bigint unsigned\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":false,\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"resId\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 03:02:08\",\"usableColumn\":false},{\"capJavaField\":\"BookId\",\"columnComment\":\"图书ID\",\"columnId\":71,\"columnName\":\"book_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"bookId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 03:02:08\",\"usableColumn\":false},{\"capJavaField\":\"ReaderId\",\"columnComment\":\"读者ID\",\"columnId\":72,\"columnName\":\"reader_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 03:02:08\",\"usableColumn\":false},{\"capJavaField\":\"ReservationDate\",\"columnComment\":\"预约日期\",\"columnId\":73,\"columnName\":\"reservation_date\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 03:02:17',57),(148,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"reader\",\"className\":\"Reader\",\"columns\":[{\"capJavaField\":\"ReaderId\",\"columnId\":52,\"columnName\":\"reader_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:54:31\",\"usableColumn\":false},{\"capJavaField\":\"ReaderNumber\",\"columnComment\":\"学号/工号\",\"columnId\":53,\"columnName\":\"reader_number\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:54:31\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"读者姓名\",\"columnId\":54,\"columnName\":\"name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 01:54:31\",\"usableColumn\":false},{\"capJavaField\":\"GradeMajor\",\"columnComment\":\"年级专业\",\"columnId\":55,\"columnName\":\"grade_major\",\"columnType\":\"varchar(150)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isE','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 03:02:26',75),(149,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"record\",\"className\":\"BorrowRecord\",\"columns\":[{\"capJavaField\":\"RecordId\",\"columnComment\":\"借阅记录ID\",\"columnId\":37,\"columnName\":\"record_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"recordId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:02:43\",\"usableColumn\":false},{\"capJavaField\":\"CopyId\",\"columnComment\":\"图书副本ID\",\"columnId\":38,\"columnName\":\"copy_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"copyId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:02:43\",\"usableColumn\":false},{\"capJavaField\":\"ReaderId\",\"columnComment\":\"读者ID\",\"columnId\":39,\"columnName\":\"reader_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:02:43\",\"usableColumn\":false},{\"capJavaField\":\"BorrowDate\",\"columnComment\":\"借阅日期\",\"columnId\":40,\"columnName\":\"borrow_date\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 03:02:38',75),(150,'菜单管理',1,'com.ruoyi.web.controller.system.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createBy\":\"admin\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"book\",\"menuType\":\"M\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"/book\",\"status\":\"0\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 03:03:43',38),(151,'菜单管理',2,'com.ruoyi.web.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createTime\":\"2026-03-09 03:03:43\",\"icon\":\"education\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"图书管理\",\"menuType\":\"M\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"book\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 03:04:09',24),(152,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"reservation\",\"className\":\"Reservation\",\"columns\":[{\"capJavaField\":\"ResId\",\"columnId\":70,\"columnName\":\"res_id\",\"columnType\":\"bigint unsigned\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":false,\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"resId\",\"javaType\":\"String\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 03:02:17\",\"usableColumn\":false},{\"capJavaField\":\"BookId\",\"columnComment\":\"图书ID\",\"columnId\":71,\"columnName\":\"book_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"bookId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 03:02:17\",\"usableColumn\":false},{\"capJavaField\":\"ReaderId\",\"columnComment\":\"读者ID\",\"columnId\":72,\"columnName\":\"reader_id\",\"columnType\":\"int\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":6,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 03:02:17\",\"usableColumn\":false},{\"capJavaField\":\"ReservationDate\",\"columnComment\":\"预约日期\",\"columnId\":73,\"columnName\":\"reservation_date\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:09:09\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 03:04:26',59),(153,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"reader\",\"className\":\"Reader\",\"columns\":[{\"capJavaField\":\"ReaderId\",\"columnId\":52,\"columnName\":\"reader_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 03:02:26\",\"usableColumn\":false},{\"capJavaField\":\"ReaderNumber\",\"columnComment\":\"学号/工号\",\"columnId\":53,\"columnName\":\"reader_number\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 03:02:26\",\"usableColumn\":false},{\"capJavaField\":\"Name\",\"columnComment\":\"读者姓名\",\"columnId\":54,\"columnName\":\"name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"name\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 03:02:26\",\"usableColumn\":false},{\"capJavaField\":\"GradeMajor\",\"columnComment\":\"年级专业\",\"columnId\":55,\"columnName\":\"grade_major\",\"columnType\":\"varchar(150)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:52\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isE','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 03:04:35',87),(154,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"record\",\"className\":\"BorrowRecord\",\"columns\":[{\"capJavaField\":\"RecordId\",\"columnComment\":\"借阅记录ID\",\"columnId\":37,\"columnName\":\"record_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"recordId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 03:02:38\",\"usableColumn\":false},{\"capJavaField\":\"CopyId\",\"columnComment\":\"图书副本ID\",\"columnId\":38,\"columnName\":\"copy_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"copyId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 03:02:38\",\"usableColumn\":false},{\"capJavaField\":\"ReaderId\",\"columnComment\":\"读者ID\",\"columnId\":39,\"columnName\":\"reader_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"readerId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 03:02:38\",\"usableColumn\":false},{\"capJavaField\":\"BorrowDate\",\"columnComment\":\"借阅日期\",\"columnId\":40,\"columnName\":\"borrow_date\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:34\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"datetime\",\"increment\":false,\"insert\":','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 03:04:45',66),(155,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"copy\",\"className\":\"BookCopy\",\"columns\":[{\"capJavaField\":\"CopyId\",\"columnComment\":\"副本ID\",\"columnId\":30,\"columnName\":\"copy_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:16\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"copyId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:13:15\",\"usableColumn\":false},{\"capJavaField\":\"BookId\",\"columnComment\":\"图书ID\",\"columnId\":31,\"columnName\":\"book_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:16\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"bookId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:13:15\",\"usableColumn\":false},{\"capJavaField\":\"Barcode\",\"columnComment\":\"条形码\",\"columnId\":32,\"columnName\":\"barcode\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:16\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"barcode\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":3,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:13:15\",\"usableColumn\":false},{\"capJavaField\":\"Location\",\"columnComment\":\"存放位置\",\"columnId\":33,\"columnName\":\"location\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:08:16\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 03:05:13',43),(156,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"category\",\"className\":\"BookCategory\",\"columns\":[{\"capJavaField\":\"CategoryId\",\"columnComment\":\"图书分类ID\",\"columnId\":22,\"columnName\":\"category_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:58\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"categoryId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:16:18\",\"usableColumn\":false},{\"capJavaField\":\"CategoryName\",\"columnComment\":\"图书分类名称\",\"columnId\":23,\"columnName\":\"category_name\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:58\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"categoryName\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:16:18\",\"usableColumn\":false},{\"capJavaField\":\"Status\",\"columnComment\":\"分类状态：1=启用，0=禁用\",\"columnId\":24,\"columnName\":\"status\",\"columnType\":\"tinyint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:58\",\"dictType\":\"category_status\",\"edit\":true,\"htmlType\":\"radio\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"status\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":2,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:16:18\",\"usableColumn\":false},{\"capJavaField\":\"CreatedTime\",\"columnComment\":\"创建时间\",\"columnId\":25,\"columnName\":\"created_time\",\"columnType\":\"datetime\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:58\",\"dictType\":\"\",\"e','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 03:05:26',60),(157,'代码生成',2,'com.ruoyi.generator.controller.GenController.editSave()','PUT',1,'admin','研发部门','/tool/gen','127.0.0.1','内网IP','{\"businessName\":\"book\",\"className\":\"Book\",\"columns\":[{\"capJavaField\":\"BookId\",\"columnComment\":\"图书的唯一标识符\",\"columnId\":1,\"columnName\":\"book_id\",\"columnType\":\"bigint\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:36\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":false,\"isIncrement\":\"1\",\"isInsert\":\"0\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"bookId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:52:28\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"书名\",\"columnId\":2,\"columnName\":\"title\",\"columnType\":\"varchar(255)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:52:28\",\"usableColumn\":false},{\"capJavaField\":\"Author\",\"columnComment\":\"作者\",\"columnId\":3,\"columnName\":\"author\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"author\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"LIKE\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"updateTime\":\"2026-03-09 02:52:28\",\"usableColumn\":false},{\"capJavaField\":\"Isbn\",\"columnId\":4,\"columnName\":\"isbn\",\"columnType\":\"varchar(60)\",\"createBy\":\"admin\",\"createTime\":\"2026-03-06 04:07:36\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-09 03:05:42',87),(158,'代码生成',8,'com.ruoyi.generator.controller.GenController.batchGenCode()','GET',1,'admin','研发部门','/tool/gen/batchGenCode','127.0.0.1','内网IP','{\"tables\":\"reservation,reader,borrow_record,book_copy,book_category,book\"}',NULL,0,NULL,'2026-03-09 03:05:47',830),(159,'用户管理',1,'com.ruoyi.web.controller.system.SysUserController.add()','POST',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"admin\":false,\"createBy\":\"admin\",\"deptId\":104,\"nickName\":\"张三\",\"params\":{},\"postIds\":[4],\"roleIds\":[2],\"sex\":\"0\",\"status\":\"0\",\"userId\":100,\"userName\":\"zhangsan\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-10 09:24:30',127),(160,'用户管理',2,'com.ruoyi.web.controller.system.SysUserController.changeStatus()','PUT',1,'admin','研发部门','/system/user/changeStatus','127.0.0.1','内网IP','{\"admin\":false,\"params\":{},\"status\":\"1\",\"updateBy\":\"admin\",\"userId\":100} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-10 09:24:34',11),(161,'用户管理',2,'com.ruoyi.web.controller.system.SysUserController.changeStatus()','PUT',1,'admin','研发部门','/system/user/changeStatus','127.0.0.1','内网IP','{\"admin\":false,\"params\":{},\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":100} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-10 09:24:36',14),(162,'字典类型',9,'com.ruoyi.web.controller.system.SysDictTypeController.refreshCache()','DELETE',1,'admin','研发部门','/system/dict/type/refreshCache','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-10 09:46:45',32),(163,'字典类型',1,'com.ruoyi.web.controller.system.SysDictTypeController.add()','POST',1,'admin','研发部门','/system/dict/type','127.0.0.1','内网IP','{\"createBy\":\"admin\",\"dictName\":\"读者状态\",\"dictType\":\"reader_status\",\"params\":{},\"status\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-03-10 09:47:20',23),(164,'图书管理',2,'com.ruoyi.book.controller.BookController.update()','PUT',1,'admin','研发部门','/api/admin/book/','127.0.0.1','内网IP','{\"author\":\"豆豆\",\"availableCopies\":7,\"bookId\":146,\"categoryId\":10,\"coverUrl\":\"/profile/upload/2026/04/01/1_20260401103936A001.png\",\"description\":\"都市权谋小说极具魅力，央视同名热播剧原著。\",\"isbn\":\"9787540213657\",\"language\":\"中文\",\"location\":\"B区1排3架\",\"publicationYear\":2005,\"publisher\":\"作家出版社\",\"status\":1,\"title\":\"遥远的救世主\",\"totalCopies\":8} ','{\"code\":200,\"message\":\"success\"}',0,NULL,'2026-04-01 02:39:50',31),(165,'图书管理',2,'com.ruoyi.book.controller.BookController.update()','PUT',1,'admin','研发部门','/api/admin/book/','127.0.0.1','内网IP','{\"author\":\"豆豆\",\"availableCopies\":7,\"bookId\":146,\"categoryId\":10,\"coverUrl\":\"/profile/upload/2026/04/01/1_20260401103936A001.png,/profile/upload/2026/04/01/2_20260401163516A002.png\",\"description\":\"都市权谋小说极具魅力，央视同名热播剧原著。\",\"isbn\":\"9787540213657\",\"language\":\"中文\",\"location\":\"B区1排3架\",\"publicationYear\":2005,\"publisher\":\"作家出版社\",\"status\":1,\"title\":\"遥远的救世主\",\"totalCopies\":8} ','{\"code\":200,\"message\":\"success\"}',0,NULL,'2026-04-01 08:35:18',19),(166,'个人信息',2,'com.zsc.web.controller.system.SysProfileController.updateProfile()','PUT',1,'reader','若依科技','/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"reader@example.com\",\"nickName\":\"读者张三\",\"params\":{},\"phonenumber\":\"13800138000\",\"sex\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-25 13:35:26',23),(167,'个人信息',2,'com.zsc.web.controller.system.SysProfileController.updatePwd()','PUT',1,'reader','若依科技','/system/user/profile/updatePwd','127.0.0.1','内网IP','{} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-25 13:45:11',235),(168,'个人信息',2,'com.zsc.web.controller.system.SysProfileController.updateProfile()','PUT',1,'reader','若依科技','/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"reader@example.com\",\"nickName\":\"读者张三\",\"params\":{},\"phonenumber\":\"13900000000\",\"sex\":\"0\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-25 14:52:12',20),(169,'用户管理',2,'com.zsc.web.controller.system.SysUserController.resetPwd()','PUT',1,'admin','研发部门','/system/user/resetPwd','127.0.0.1','内网IP','{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":100} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-25 21:21:38',65),(170,'用户管理',2,'com.zsc.web.controller.system.SysUserController.resetPwd()','PUT',1,'admin','研发部门','/system/user/resetPwd','127.0.0.1','内网IP','{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":3} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-25 21:21:38',62),(171,'用户管理',2,'com.zsc.web.controller.system.SysUserController.resetPwd()','PUT',1,'admin','研发部门','/system/user/resetPwd','127.0.0.1','内网IP','{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":102} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-25 21:21:38',55),(172,'用户管理',2,'com.zsc.web.controller.system.SysUserController.resetPwd()','PUT',1,'admin','研发部门','/system/user/resetPwd','127.0.0.1','内网IP','{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":103} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-25 21:21:38',57),(173,'用户管理',2,'com.zsc.web.controller.system.SysUserController.resetPwd()','PUT',1,'admin','研发部门','/system/user/resetPwd','127.0.0.1','内网IP','{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":104} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-25 21:21:38',57),(174,'用户管理',2,'com.zsc.web.controller.system.SysUserController.resetPwd()','PUT',1,'admin','研发部门','/system/user/resetPwd','127.0.0.1','内网IP','{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":105} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-25 21:21:38',56),(175,'用户管理',2,'com.zsc.web.controller.system.SysUserController.resetPwd()','PUT',1,'admin','研发部门','/system/user/resetPwd','127.0.0.1','内网IP','{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":106} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-25 21:21:38',55),(176,'用户管理',2,'com.zsc.web.controller.system.SysUserController.resetPwd()','PUT',1,'admin','研发部门','/system/user/resetPwd','127.0.0.1','内网IP','{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":107} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-25 21:21:38',57),(177,'用户管理',2,'com.zsc.web.controller.system.SysUserController.resetPwd()','PUT',1,'admin','研发部门','/system/user/resetPwd','127.0.0.1','内网IP','{\"admin\":false,\"params\":{},\"updateBy\":\"admin\",\"userId\":108} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-25 21:21:39',54),(178,'用户头像',2,'com.zsc.web.controller.system.SysProfileController.avatar()','POST',1,'admin','研发部门','/system/user/profile/avatar','127.0.0.1','内网IP','','{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/06/26/9b1d10b0ae244548bd00770348f4e2c8.png\",\"code\":200}',0,NULL,'2026-06-26 18:06:31',146),(179,'个人信息',2,'com.zsc.web.controller.system.SysProfileController.updateProfile()','PUT',1,'admin','研发部门','/system/user/profile','127.0.0.1','内网IP','{\"admin\":false,\"email\":\"ry@163.com\",\"nickName\":\"admin\",\"params\":{},\"phonenumber\":\"16500000000\",\"sex\":\"1\"} ','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-06-26 18:48:06',71);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'ceo','董事长',1,'0','admin','2026-03-06 01:54:37','',NULL,''),(2,'se','项目经理',2,'0','admin','2026-03-06 01:54:37','',NULL,''),(3,'hr','人力资源',3,'0','admin','2026-03-06 01:54:37','',NULL,''),(4,'user','普通员工',4,'0','admin','2026-03-06 01:54:37','',NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2026-03-06 01:54:37','',NULL,'超级管理员'),(2,'普通角色','common',2,'2',1,1,'0','0','admin','2026-03-06 01:54:37','',NULL,'普通角色'),(3,'读者','reader',3,'5',1,1,'0','0','admin','2026-06-25 13:14:51','',NULL,'云端借阅服务读者');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
INSERT INTO `sys_role_dept` VALUES (2,100),(2,101),(2,105);
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (1,2000),(1,2001),(1,2002),(1,2003),(1,2004),(1,2005),(1,2006),(2,1),(2,100),(2,101),(2,108),(2,500),(2,501),(2,1000),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(2,1006),(2,1007),(2,1008),(2,1009),(2,1010),(2,1011),(2,1012),(2,1013),(2,1014),(2,1015),(2,1016),(2,1017),(2,1018),(2,1019),(2,1020),(2,1021),(2,1022),(2,1023),(2,1024),(2,1025),(2,1026),(2,1027),(2,1028),(2,1029),(2,1030),(2,1031),(2,1032),(2,1033),(2,1034),(2,1035),(2,1036),(2,1037),(2,1038),(2,1039),(2,1040),(2,1041),(2,1042),(2,1043),(2,1044),(2,1045),(2,1046),(2,1047),(2,1048),(2,1049),(2,1050),(2,1051),(2,1052),(2,1053),(2,1054),(2,1055),(2,1056),(2,1057),(2,1058),(2,1059),(2,1060),(2,2000),(2,2001),(2,2002),(2,2003),(2,2004),(2,2005),(2,2006),(2,2007),(2,2008),(2,2009),(2,2014),(2,2015),(2,2016),(2,2017),(2,2018),(2,2019),(2,2020),(2,2021),(2,2022),(2,2023),(2,2024),(2,2025),(2,2026),(2,2027),(2,2028),(2,2029),(2,2030),(2,2031),(2,2032),(2,2033),(2,2034),(2,2035),(2,2036);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) DEFAULT '' COMMENT '密码',
  `status` char(1) DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,103,'admin','admin','00','ry@163.com','16500000000','1','/profile/avatar/2026/06/26/9b1d10b0ae244548bd00770348f4e2c8.png','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-06-27 21:04:55','2026-03-06 01:54:37','admin','2026-03-06 01:54:37','admin','2026-06-26 18:48:06','管理员'),(2,105,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-03-06 01:54:37','2026-03-06 01:54:37','admin','2026-03-06 01:54:37','',NULL,'测试员'),(3,100,'reader','读者张三','00','','13900000000','0','','$2a$10$m98qZaFqTpMnGnVKyzEqlef6LkYl3q6A88GCJ6bFFhp7fz7Z3hF0W','0','0','127.0.0.1','2026-06-27 21:12:04','2026-06-25 21:21:38','admin','2026-06-25 13:15:27','admin','2026-06-26 12:52:28','读者测试账号'),(100,104,'zhangsan','张三','00','','','0','','$2a$10$8cYdL4snwLTj6j3rVhQPYu90.4ziRVlbPIXBzG9NmlXXvVaC2O252','0','0','127.0.0.1','2026-06-26 12:52:27','2026-06-25 21:21:38','admin','2026-03-10 09:24:30','','2026-06-25 21:21:38',NULL),(101,100,'admin2','馆务管理员','00','admin2@cloudlib.test','13900001001','2','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','',NULL,NULL,'seed','2026-06-25 16:29:55','',NULL,'仿真测试：第二管理员账号'),(102,100,'reader_lisi','李思','00','','13900002001','2','','$2a$10$SuYpUzj.FQHR9F1A7RktfeRXJSDcmHtyseAshJT7u.4hW/39.gYpy','0','0','',NULL,'2026-06-25 21:21:38','seed','2026-06-25 16:29:55','admin','2026-06-26 12:52:27','仿真测试：正常读者，押金和年费充足'),(103,100,'reader_wangwu','王五','00','wangwu@cloudlib.test','13900002002','2','','$2a$10$ZHU1fjd1ZvzEWuuoWoUCVeGOiolZEN0DVTKVcyO9DLtCZQ3ocjQ4C','0','0','',NULL,'2026-06-25 21:21:38','seed','2026-06-25 16:29:55','','2026-06-25 21:21:38','仿真测试：年费已过期'),(104,100,'reader_zhaoliu','赵六','00','zhaoliu@cloudlib.test','13900002003','2','','$2a$10$dAmIj3A9k.osJzmUNysREejai0zycBOv93vTK0WUMjfMUDS2c1Bb2','0','0','127.0.0.1','2026-06-27 09:12:08','2026-06-25 21:21:38','seed','2026-06-25 16:29:55','','2026-06-25 21:21:38','仿真测试：押金不足'),(105,100,'reader_qianqi','钱七','00','qianqi@cloudlib.test','13900002004','2','','$2a$10$NMyIFD9hQS49baWi5SL2b.ViKBfxMstWEs9Pyq4k6Qg67mGh/H17C','1','0','',NULL,'2026-06-25 21:21:38','seed','2026-06-25 16:29:55','admin','2026-06-25 22:49:08','仿真测试：寄出/寄回次数达到上限'),(106,100,'reader_sunba','孙八','00','sunba@cloudlib.test','13900002005','2','','$2a$10$6x43FH0ck/dHGu5Ybo/8t.J7ncVo0ljhB8IMDCaJVBS9HV/QLMtv2','0','0','',NULL,'2026-06-25 21:21:38','seed','2026-06-25 16:29:55','admin','2026-06-25 22:49:05','仿真测试：停用读者'),(107,100,'reader_zhoujiu','周九','00','zhoujiu@cloudlib.test','13900002006','2','','$2a$10$kjvtQmRBcpQqqWOs/oPkteRspP3UHXbP3AnAjKxfHbKmdmHW2Rf9G','0','0','',NULL,'2026-06-25 21:21:38','seed','2026-06-25 16:29:55','','2026-06-25 21:21:38','仿真测试：排队读者'),(108,100,'reader_wushi','吴十','00','wushi@cloudlib.test','13900002007','2','','$2a$10$x26QBARCVNOjE47ymTl3FOJaG1PfG07pdfPq2bWmbUxluVT/b7Rmy','0','0','',NULL,'2026-06-25 21:21:38','seed','2026-06-25 16:29:55','','2026-06-25 21:21:38','仿真测试：损坏赔付读者');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1),(2,2),(100,4);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(2,2),(3,3),(100,2),(101,1),(102,3),(103,3),(104,3),(105,3),(106,3),(107,3),(108,3);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'zsc'
--

--
-- Dumping routines for database 'zsc'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-27 22:18:46

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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-27 21:28:13

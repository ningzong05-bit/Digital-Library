SET NAMES utf8mb4;

DELETE FROM library_fee_record;
DELETE FROM library_delivery_record;
DELETE FROM library_queue_record;
DELETE FROM library_borrow_order;
DELETE FROM library_address;
DELETE FROM library_book;

ALTER TABLE library_fee_record AUTO_INCREMENT = 1;
ALTER TABLE library_delivery_record AUTO_INCREMENT = 1;
ALTER TABLE library_queue_record AUTO_INCREMENT = 1;
ALTER TABLE library_borrow_order AUTO_INCREMENT = 1;
ALTER TABLE library_address AUTO_INCREMENT = 1;
ALTER TABLE library_book AUTO_INCREMENT = 1;

UPDATE library_rule
SET library_city = '中山市',
    annual_fee = 199.00,
    deposit_amount = 199.00,
    max_loan_days = 30,
    annual_outbound_limit = 50,
    annual_inbound_limit = 50,
    max_borrow_count = 5,
    overdue_fee_per_day = 1.00,
    update_time = '2026-06-26 09:00:00'
WHERE status = 'ENABLED';

INSERT INTO library_rule
(library_city, annual_fee, deposit_amount, max_loan_days, annual_outbound_limit, annual_inbound_limit, max_borrow_count,
 overdue_fee_per_day, damage_fee, lost_fee, status, create_time, update_time)
SELECT '中山市', 159.00, 199.00, 21, 12, 12, 3, 1.00, 50.00, 100.00, 'DISABLED',
       '2025-01-01 09:00:00', '2026-01-01 09:00:00'
WHERE NOT EXISTS (
    SELECT 1 FROM library_rule
    WHERE library_city = '中山市'
      AND status = 'DISABLED'
      AND annual_fee = 159.00
      AND max_loan_days = 21
);

INSERT INTO library_book
(book_id, isbn, book_name, author, publisher, category_name, cover_url, description, total_count, available_count, queue_count, status, create_time, update_time)
VALUES
(1, '9787530221532', '活着', '余华', '北京十月文艺出版社', '中国文学', '', '余华长篇小说代表作。', 6, 6, 0, 'ENABLED', '2026-04-26 09:10:00', '2026-06-26 09:10:00'),
(2, '9787536692930', '三体', '刘慈欣', '重庆出版社', '科幻文学', '', '中国科幻文学代表作。', 6, 6, 0, 'ENABLED', '2026-04-26 09:12:00', '2026-06-26 09:12:00'),
(3, '9787536693968', '三体2：黑暗森林', '刘慈欣', '重庆出版社', '科幻文学', '', '三体系列第二部。', 5, 5, 0, 'ENABLED', '2026-04-27 10:00:00', '2026-06-26 09:13:00'),
(4, '9787229030933', '三体3：死神永生', '刘慈欣', '重庆出版社', '科幻文学', '', '三体系列第三部。', 5, 5, 0, 'ENABLED', '2026-04-27 10:08:00', '2026-06-26 09:14:00'),
(5, '9787020002207', '红楼梦', '曹雪芹、高鹗', '人民文学出版社', '古典文学', '', '中国古典长篇小说。', 5, 5, 0, 'ENABLED', '2026-04-28 10:10:00', '2026-06-26 09:15:00'),
(6, '9787020098095', '围城', '钱钟书', '人民文学出版社', '中国文学', '', '现代文学经典。', 4, 4, 0, 'ENABLED', '2026-04-29 11:00:00', '2026-06-26 09:16:00'),
(7, '9787530216781', '平凡的世界', '路遥', '北京十月文艺出版社', '中国文学', '', '现实主义长篇小说。', 6, 6, 0, 'ENABLED', '2026-04-30 09:40:00', '2026-06-26 09:17:00'),
(8, '9787544258609', '白夜行', '东野圭吾', '南海出版公司', '悬疑推理', '', '日本推理小说。', 4, 4, 0, 'ENABLED', '2026-05-01 09:40:00', '2026-06-26 09:18:00'),
(9, '9787544270878', '解忧杂货店', '东野圭吾', '南海出版公司', '外国文学', '', '温情长篇小说。', 4, 4, 0, 'ENABLED', '2026-05-02 09:40:00', '2026-06-26 09:19:00'),
(10, '9787544241694', '嫌疑人X的献身', '东野圭吾', '南海出版公司', '悬疑推理', '', '推理小说代表作。', 4, 4, 0, 'ENABLED', '2026-05-03 09:40:00', '2026-06-26 09:20:00'),
(11, '9787208061644', '追风筝的人', '卡勒德·胡赛尼', '上海人民出版社', '外国文学', '', '阿富汗题材长篇小说。', 5, 5, 0, 'ENABLED', '2026-05-04 09:40:00', '2026-06-26 09:21:00'),
(12, '9787020042494', '小王子', '圣埃克苏佩里', '人民文学出版社', '外国文学', '', '经典童话小说。', 5, 5, 0, 'ENABLED', '2026-05-05 09:40:00', '2026-06-26 09:22:00'),
(13, '9787544253994', '百年孤独', '加西亚·马尔克斯', '南海出版公司', '外国文学', '', '魔幻现实主义经典。', 5, 5, 0, 'ENABLED', '2026-05-06 09:40:00', '2026-06-26 09:23:00'),
(14, '9787508647357', '人类简史', '尤瓦尔·赫拉利', '中信出版社', '社会科学', '', '人类历史通识读物。', 4, 4, 0, 'ENABLED', '2026-05-07 09:40:00', '2026-06-26 09:24:00'),
(15, '9787508672069', '未来简史', '尤瓦尔·赫拉利', '中信出版社', '社会科学', '', '未来社会主题通识读物。', 4, 4, 0, 'ENABLED', '2026-05-08 09:40:00', '2026-06-26 09:25:00'),
(16, '9787544276986', '你当像鸟飞往你的山', '塔拉·韦斯特弗', '南海出版公司', '传记纪实', '', '个人成长回忆录。', 4, 4, 0, 'ENABLED', '2026-05-09 09:40:00', '2026-06-26 09:26:00'),
(17, '9787208171336', '置身事内', '兰小欢', '上海人民出版社', '经济管理', '', '中国政府与经济发展研究。', 4, 4, 0, 'ENABLED', '2026-05-10 09:40:00', '2026-06-26 09:27:00'),
(18, '9787301174821', '乡土中国', '费孝通', '北京大学出版社', '社会科学', '', '社会学经典。', 5, 5, 0, 'ENABLED', '2026-05-11 09:40:00', '2026-06-26 09:28:00'),
(19, '9787505722460', '明朝那些事儿（第1部）', '当年明月', '中国友谊出版公司', '历史传记', '', '明史通俗读物。', 4, 4, 0, 'ENABLED', '2026-05-12 09:40:00', '2026-06-26 09:29:00'),
(20, '9787108009821', '万历十五年', '黄仁宇', '生活·读书·新知三联书店', '历史传记', '', '明史研究经典。', 4, 4, 0, 'ENABLED', '2026-05-13 09:40:00', '2026-06-26 09:30:00'),
(21, '9787506394864', '苏菲的世界', '乔斯坦·贾德', '作家出版社', '哲学心理', '', '哲学启蒙小说。', 4, 4, 0, 'ENABLED', '2026-05-14 09:40:00', '2026-06-26 09:31:00'),
(22, '9787111495482', '被讨厌的勇气', '岸见一郎、古贺史健', '机械工业出版社', '哲学心理', '', '阿德勒心理学通俗读物。', 4, 4, 0, 'ENABLED', '2026-05-15 09:40:00', '2026-06-26 09:32:00'),
(23, '9787210093214', '深度工作', '卡尔·纽波特', '江西人民出版社', '经济管理', '', '专注力与工作方法。', 4, 4, 0, 'ENABLED', '2026-05-16 09:40:00', '2026-06-26 09:33:00'),
(24, '9787121022982', '代码大全', '史蒂夫·迈克康奈尔', '电子工业出版社', '计算机科学', '', '软件构建经典。', 4, 4, 0, 'ENABLED', '2026-05-17 09:40:00', '2026-06-26 09:34:00'),
(25, '9787111187776', '算法导论', 'Thomas H. Cormen 等', '机械工业出版社', '计算机科学', '', '算法教材。', 4, 4, 0, 'ENABLED', '2026-05-18 09:40:00', '2026-06-26 09:35:00'),
(26, '9787111544937', '深入理解计算机系统', 'Randal E. Bryant、David R. O''Hallaron', '机械工业出版社', '计算机科学', '', '计算机系统教材。', 4, 4, 0, 'ENABLED', '2026-05-19 09:40:00', '2026-06-26 09:36:00'),
(27, '9787302423287', '机器学习', '周志华', '清华大学出版社', '计算机科学', '', '机器学习教材。', 4, 4, 0, 'ENABLED', '2026-05-20 09:40:00', '2026-06-26 09:37:00'),
(28, '9787115428028', 'Python编程：从入门到实践', 'Eric Matthes', '人民邮电出版社', '计算机科学', '', 'Python入门实践读物。', 4, 4, 0, 'ENABLED', '2026-05-21 09:40:00', '2026-06-26 09:38:00'),
(29, '9787535732309', '时间简史', '史蒂芬·霍金', '湖南科学技术出版社', '自然科学', '', '宇宙学科普经典。', 4, 4, 0, 'ENABLED', '2026-05-22 09:40:00', '2026-06-26 09:39:00'),
(30, '9787100023948', '物种起源', '查尔斯·达尔文', '商务印书馆', '自然科学', '', '进化论经典著作。', 4, 4, 0, 'ENABLED', '2026-05-23 09:40:00', '2026-06-26 09:40:00'),
(31, '9787532739233', '枪炮、病菌与钢铁', '贾雷德·戴蒙德', '上海译文出版社', '社会科学', '', '文明发展通识读物。', 4, 4, 0, 'ENABLED', '2026-05-24 09:40:00', '2026-06-26 09:41:00'),
(32, '9787532748983', '了不起的盖茨比', 'F. Scott Fitzgerald', '上海译文出版社', '外国文学', '', '美国文学经典。', 4, 4, 0, 'ENABLED', '2026-05-25 09:40:00', '2026-06-26 09:42:00'),
(33, '9787532749003', '月亮与六便士', '毛姆', '上海译文出版社', '外国文学', '', '英国文学经典。', 4, 4, 0, 'ENABLED', '2026-05-26 09:40:00', '2026-06-26 09:43:00'),
(34, '9787100004831', '西方哲学史', '伯特兰·罗素', '商务印书馆', '哲学心理', '', '哲学史经典。', 3, 3, 0, 'ENABLED', '2026-05-27 09:40:00', '2026-06-26 09:44:00'),
(35, '9787301256909', '经济学原理', 'N. Gregory Mankiw', '北京大学出版社', '经济管理', '', '经济学教材。', 3, 3, 0, 'ENABLED', '2026-05-28 09:40:00', '2026-06-26 09:45:00'),
(36, '9787544280662', '杀死一只知更鸟', '哈珀·李', '译林出版社', '外国文学', '', '美国文学经典。', 3, 3, 0, 'ENABLED', '2026-05-29 09:40:00', '2026-06-26 09:46:00'),
(37, '9787115598110', '人工智能：一种现代方法', 'Stuart Russell、Peter Norvig', '人民邮电出版社', '计算机科学', '', '人工智能领域经典教材，仅存馆藏已借出。', 1, 0, 1, 'ENABLED', '2026-05-30 09:40:00', '2026-06-26 09:47:00'),
(38, '9787111128069', '重构：改善既有代码的设计', 'Martin Fowler', '人民邮电出版社', '计算机科学', '', '馆藏盘点中，临时停借。', 2, 0, 0, 'DISABLED', '2026-05-31 09:40:00', '2026-06-26 09:48:00');

UPDATE library_reader
SET city = '中山市',
    mobile = CASE reader_id
        WHEN 3 THEN '13900002008'
        ELSE mobile
    END,
    annual_expire_date = CASE reader_id
        WHEN 3 THEN '2026-05-31 23:59:59'
        ELSE '2027-12-31 23:59:59'
    END,
    deposit_balance = CASE reader_id
        WHEN 1 THEN 230.00
        WHEN 3 THEN 360.00
        WHEN 4 THEN 500.00
        WHEN 5 THEN 150.00
        WHEN 6 THEN 120.00
        WHEN 7 THEN 520.00
        WHEN 8 THEN 320.00
        WHEN 9 THEN 260.00
        WHEN 10 THEN 450.00
        ELSE 260.00
    END,
    deposit_frozen = 0.00,
    max_outbound_count = 50,
    max_inbound_count = 50,
    max_borrow_count = CASE WHEN reader_id = 9 THEN 1 ELSE 5 END,
    status = CASE WHEN reader_id = 6 THEN 'DISABLED' ELSE 'NORMAL' END,
    update_time = '2026-06-26 09:30:00';

DROP TEMPORARY TABLE IF EXISTS tmp_readers;
CREATE TEMPORARY TABLE tmp_readers AS
SELECT reader_id, reader_name, mobile, deposit_balance, ROW_NUMBER() OVER (ORDER BY reader_id) AS rn
FROM library_reader
ORDER BY reader_id;

INSERT INTO library_address
(reader_id, receiver_name, receiver_mobile, city, district, detail_address, default_flag, status, create_time, update_time)
SELECT reader_id,
       reader_name,
       mobile,
       '中山市',
       CASE MOD(rn - 1, 9)
           WHEN 0 THEN '石岐街道'
           WHEN 1 THEN '东区街道'
           WHEN 2 THEN '西区街道'
           WHEN 3 THEN '南区街道'
           WHEN 4 THEN '火炬开发区'
           WHEN 5 THEN '小榄镇'
           WHEN 6 THEN '古镇镇'
           WHEN 7 THEN '三乡镇'
           ELSE '沙溪镇'
       END,
       CASE MOD(rn - 1, 9)
           WHEN 0 THEN '孙文中路197号附近 3栋502'
           WHEN 1 THEN '兴中道8号附近 2座806'
           WHEN 2 THEN '彩虹大道16号D区 5栋1201'
           WHEN 3 THEN '城南一路12号 1栋704'
           WHEN 4 THEN '会展东路1号德仲广场 2幢702'
           WHEN 5 THEN '民安中路163号 6栋901'
           WHEN 6 THEN '中兴大道南1号 4栋603'
           WHEN 7 THEN '雅居乐花园柏丽广场 8栋1102'
           ELSE '星宝路2号 7栋301'
       END,
       1,
       'ENABLED',
       '2026-06-01 09:00:00',
       '2026-06-26 09:30:00'
FROM tmp_readers;

INSERT INTO library_address
(reader_id, receiver_name, receiver_mobile, city, district, detail_address, default_flag, status, create_time, update_time)
SELECT reader_id,
       reader_name,
       mobile,
       '中山市',
       '石岐街道',
       '旧住址已搬迁，保留用于停用地址筛选测试',
       0,
       'DISABLED',
       '2025-12-20 09:00:00',
       '2026-06-26 09:35:00'
FROM tmp_readers
WHERE rn = 1;

UPDATE library_reader r
JOIN library_address a ON a.reader_id = r.reader_id AND a.default_flag = 1
SET r.default_address_id = a.address_id;

DROP TEMPORARY TABLE IF EXISTS tmp_order_seed;
CREATE TEMPORARY TABLE tmp_order_seed (
  seq INT PRIMARY KEY,
  reader_rn INT NOT NULL,
  book_id BIGINT NOT NULL,
  borrow_type VARCHAR(32) NOT NULL,
  return_type VARCHAR(32),
  order_status VARCHAR(32) NOT NULL,
  start_date DATETIME,
  due_date DATETIME,
  library_ship_date DATETIME,
  pickup_date DATETIME,
  user_ship_back_date DATETIME,
  library_receive_date DATETIME,
  damage_status VARCHAR(32) NOT NULL,
  overdue_flag TINYINT NOT NULL,
  compensation_amount DECIMAL(10,2) NOT NULL,
  create_time DATETIME NOT NULL,
  remark VARCHAR(512)
);

INSERT INTO tmp_order_seed VALUES
(1, 1, 1, 'SELF_PICKUP', NULL, 'WAIT_PICKUP', NULL, NULL, NULL, NULL, NULL, NULL, 'NORMAL', 0, 0.00, '2026-06-26 09:10:00', '读者预约到馆自取'),
(2, 2, 2, 'LIBRARY_SHIP', NULL, 'WAIT_SHIP', NULL, NULL, NULL, NULL, NULL, NULL, 'NORMAL', 0, 0.00, '2026-06-26 08:42:00', '馆方待寄出'),
(3, 3, 5, 'SELF_PICKUP', NULL, 'WAIT_PICKUP', NULL, NULL, NULL, NULL, NULL, NULL, 'NORMAL', 0, 0.00, '2026-06-25 18:20:00', '读者预约到馆自取'),
(4, 4, 9, 'LIBRARY_SHIP', NULL, 'WAIT_SHIP', NULL, NULL, NULL, NULL, NULL, NULL, 'NORMAL', 0, 0.00, '2026-06-25 17:05:00', '馆方待寄出'),
(5, 5, 14, 'SELF_PICKUP', NULL, 'WAIT_PICKUP', NULL, NULL, NULL, NULL, NULL, NULL, 'NORMAL', 0, 0.00, '2026-06-24 15:30:00', '读者预约到馆自取'),
(6, 6, 20, 'LIBRARY_SHIP', NULL, 'WAIT_SHIP', NULL, NULL, NULL, NULL, NULL, NULL, 'NORMAL', 0, 0.00, '2026-06-24 13:12:00', '馆方待寄出'),
(7, 7, 24, 'SELF_PICKUP', 'LIBRARY_RETURN', 'BORROWING', '2026-06-22 10:00:00', '2026-07-22 23:59:59', NULL, '2026-06-22 10:00:00', NULL, NULL, 'NORMAL', 0, 0.00, '2026-06-22 09:20:00', '正常借阅中'),
(8, 8, 27, 'LIBRARY_SHIP', 'USER_SHIP', 'BORROWING', '2026-06-21 15:00:00', '2026-07-21 23:59:59', '2026-06-20 16:00:00', '2026-06-21 15:00:00', NULL, NULL, 'NORMAL', 0, 0.00, '2026-06-20 11:30:00', '快递签收后开始计借'),
(9, 9, 31, 'SELF_PICKUP', 'LIBRARY_RETURN', 'BORROWING', '2026-06-18 11:00:00', '2026-07-18 23:59:59', NULL, '2026-06-18 11:00:00', NULL, NULL, 'NORMAL', 0, 0.00, '2026-06-18 09:12:00', '正常借阅中'),
(10, 1, 33, 'LIBRARY_SHIP', 'USER_SHIP', 'BORROWING', '2026-06-15 14:00:00', '2026-07-15 23:59:59', '2026-06-14 17:20:00', '2026-06-15 14:00:00', NULL, NULL, 'NORMAL', 0, 0.00, '2026-06-14 10:18:00', '正常借阅中'),
(11, 2, 7, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNING', '2026-05-26 10:00:00', '2026-06-25 23:59:59', NULL, '2026-05-26 10:00:00', '2026-06-26 10:00:00', NULL, 'NORMAL', 1, 1.00, '2026-05-25 14:20:00', '已发起到馆还书'),
(12, 3, 12, 'LIBRARY_SHIP', 'USER_SHIP', 'RETURNING', '2026-05-28 10:00:00', '2026-06-27 23:59:59', '2026-05-27 15:40:00', '2026-05-28 10:00:00', '2026-06-25 16:30:00', NULL, 'NORMAL', 0, 0.00, '2026-05-27 09:20:00', '读者已寄回，待馆方验收'),
(13, 4, 16, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNING', '2026-06-01 10:00:00', '2026-07-01 23:59:59', NULL, '2026-06-01 10:00:00', '2026-06-26 09:20:00', NULL, 'NORMAL', 0, 0.00, '2026-05-31 13:20:00', '已发起到馆还书'),
(14, 6, 22, 'SELF_PICKUP', 'LIBRARY_RETURN', 'COMPENSATION_PENDING', '2026-05-12 10:00:00', '2026-06-11 23:59:59', NULL, '2026-05-12 10:00:00', '2026-06-20 10:00:00', '2026-06-20 15:00:00', 'LOST', 1, 180.00, '2026-05-11 10:20:00', '遗失待赔付，押金不足'),
(15, 8, 30, 'LIBRARY_SHIP', 'USER_SHIP', 'COMPENSATION_PENDING', '2026-05-18 10:00:00', '2026-06-17 23:59:59', '2026-05-17 14:20:00', '2026-05-18 10:00:00', '2026-06-18 16:00:00', '2026-06-19 10:00:00', 'DAMAGED', 1, 55.00, '2026-05-16 15:10:00', '破损待赔付'),
(16, 1, 2, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-04-28 10:00:00', '2026-05-28 23:59:59', NULL, '2026-04-28 10:00:00', '2026-05-20 10:00:00', '2026-05-20 11:30:00', 'NORMAL', 0, 0.00, '2026-04-27 09:30:00', '按期归还'),
(17, 2, 1, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-04-30 11:00:00', '2026-05-30 23:59:59', NULL, '2026-04-30 11:00:00', '2026-05-18 10:00:00', '2026-05-18 11:20:00', 'NORMAL', 0, 0.00, '2026-04-29 09:40:00', '按期归还'),
(18, 3, 13, 'LIBRARY_SHIP', 'USER_SHIP', 'RETURNED', '2026-05-02 15:00:00', '2026-06-01 23:59:59', '2026-05-01 16:20:00', '2026-05-02 15:00:00', '2026-05-25 16:00:00', '2026-05-26 10:00:00', 'NORMAL', 0, 0.00, '2026-05-01 08:50:00', '邮寄归还完成'),
(19, 4, 11, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-05-04 10:30:00', '2026-06-03 23:59:59', NULL, '2026-05-04 10:30:00', '2026-05-30 09:50:00', '2026-05-30 10:30:00', 'NORMAL', 0, 0.00, '2026-05-03 12:10:00', '按期归还'),
(20, 5, 8, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-05-07 11:20:00', '2026-06-06 23:59:59', NULL, '2026-05-07 11:20:00', '2026-06-08 10:20:00', '2026-06-08 11:10:00', 'NORMAL', 1, 2.00, '2026-05-06 13:30:00', '逾期2天已结清'),
(21, 6, 3, 'LIBRARY_SHIP', 'USER_SHIP', 'RETURNED', '2026-05-09 12:10:00', '2026-06-08 23:59:59', '2026-05-08 16:10:00', '2026-05-09 12:10:00', '2026-06-01 14:00:00', '2026-06-02 09:20:00', 'NORMAL', 0, 0.00, '2026-05-08 09:50:00', '邮寄归还完成'),
(22, 7, 4, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-05-11 10:00:00', '2026-06-10 23:59:59', NULL, '2026-05-11 10:00:00', '2026-06-09 10:00:00', '2026-06-09 10:30:00', 'NORMAL', 0, 0.00, '2026-05-10 16:20:00', '按期归还'),
(23, 8, 17, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-05-13 10:00:00', '2026-06-12 23:59:59', NULL, '2026-05-13 10:00:00', '2026-06-12 10:00:00', '2026-06-12 10:30:00', 'NORMAL', 0, 0.00, '2026-05-12 09:20:00', '按期归还'),
(24, 9, 18, 'LIBRARY_SHIP', 'USER_SHIP', 'RETURNED', '2026-05-14 13:00:00', '2026-06-13 23:59:59', '2026-05-13 16:00:00', '2026-05-14 13:00:00', '2026-06-10 15:00:00', '2026-06-11 10:00:00', 'NORMAL', 0, 0.00, '2026-05-13 10:00:00', '邮寄归还完成'),
(25, 1, 19, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-05-16 10:00:00', '2026-06-15 23:59:59', NULL, '2026-05-16 10:00:00', '2026-06-15 10:00:00', '2026-06-15 10:40:00', 'NORMAL', 0, 0.00, '2026-05-15 15:00:00', '按期归还'),
(26, 2, 20, 'LIBRARY_SHIP', 'USER_SHIP', 'RETURNED', '2026-05-17 14:00:00', '2026-06-16 23:59:59', '2026-05-16 17:00:00', '2026-05-17 14:00:00', '2026-06-16 15:10:00', '2026-06-17 10:00:00', 'NORMAL', 0, 0.00, '2026-05-16 10:50:00', '邮寄归还完成'),
(27, 3, 21, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-05-19 09:30:00', '2026-06-18 23:59:59', NULL, '2026-05-19 09:30:00', '2026-06-18 09:30:00', '2026-06-18 10:00:00', 'NORMAL', 0, 0.00, '2026-05-18 15:10:00', '按期归还'),
(28, 4, 23, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-05-20 11:00:00', '2026-06-19 23:59:59', NULL, '2026-05-20 11:00:00', '2026-06-19 10:40:00', '2026-06-19 11:10:00', 'NORMAL', 0, 0.00, '2026-05-19 13:40:00', '按期归还'),
(29, 5, 24, 'LIBRARY_SHIP', 'USER_SHIP', 'RETURNED', '2026-05-21 15:00:00', '2026-06-20 23:59:59', '2026-05-20 16:00:00', '2026-05-21 15:00:00', '2026-06-20 16:00:00', '2026-06-21 10:00:00', 'NORMAL', 0, 0.00, '2026-05-20 09:50:00', '邮寄归还完成'),
(30, 6, 25, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-05-23 10:00:00', '2026-06-22 23:59:59', NULL, '2026-05-23 10:00:00', '2026-06-22 10:20:00', '2026-06-22 11:00:00', 'NORMAL', 0, 0.00, '2026-05-22 14:10:00', '按期归还'),
(31, 7, 26, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-05-24 10:00:00', '2026-06-23 23:59:59', NULL, '2026-05-24 10:00:00', '2026-06-23 09:20:00', '2026-06-23 10:00:00', 'NORMAL', 0, 0.00, '2026-05-23 16:00:00', '按期归还'),
(32, 8, 28, 'LIBRARY_SHIP', 'USER_SHIP', 'RETURNED', '2026-05-25 16:00:00', '2026-06-24 23:59:59', '2026-05-24 16:00:00', '2026-05-25 16:00:00', '2026-06-24 15:20:00', '2026-06-25 10:00:00', 'DAMAGED', 0, 30.00, '2026-05-24 10:20:00', '轻微破损已赔付'),
(33, 9, 29, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-05-27 10:00:00', '2026-06-26 23:59:59', NULL, '2026-05-27 10:00:00', '2026-06-25 10:00:00', '2026-06-25 10:40:00', 'NORMAL', 0, 0.00, '2026-05-26 11:20:00', '按期归还'),
(34, 1, 1, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-06-01 10:00:00', '2026-07-01 23:59:59', NULL, '2026-06-01 10:00:00', '2026-06-20 11:00:00', '2026-06-20 11:40:00', 'NORMAL', 0, 0.00, '2026-05-31 09:20:00', '按期归还'),
(35, 2, 2, 'LIBRARY_SHIP', 'USER_SHIP', 'RETURNED', '2026-06-03 14:00:00', '2026-07-03 23:59:59', '2026-06-02 16:00:00', '2026-06-03 14:00:00', '2026-06-23 15:00:00', '2026-06-24 10:00:00', 'NORMAL', 0, 0.00, '2026-06-02 10:10:00', '邮寄归还完成'),
(36, 3, 13, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-06-05 10:30:00', '2026-07-05 23:59:59', NULL, '2026-06-05 10:30:00', '2026-06-25 10:30:00', '2026-06-25 11:00:00', 'NORMAL', 0, 0.00, '2026-06-04 13:10:00', '按期归还'),
(37, 4, 11, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-06-06 10:00:00', '2026-07-06 23:59:59', NULL, '2026-06-06 10:00:00', '2026-06-26 09:00:00', '2026-06-26 09:40:00', 'NORMAL', 0, 0.00, '2026-06-05 15:20:00', '按期归还'),
(38, 5, 8, 'LIBRARY_SHIP', 'USER_SHIP', 'RETURNED', '2026-06-08 15:00:00', '2026-07-08 23:59:59', '2026-06-07 16:00:00', '2026-06-08 15:00:00', '2026-06-26 10:00:00', '2026-06-26 11:00:00', 'NORMAL', 0, 0.00, '2026-06-07 10:30:00', '邮寄归还完成'),
(39, 6, 3, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-06-10 10:00:00', '2026-07-10 23:59:59', NULL, '2026-06-10 10:00:00', '2026-06-24 10:00:00', '2026-06-24 10:30:00', 'NORMAL', 0, 0.00, '2026-06-09 11:20:00', '按期归还'),
(40, 7, 4, 'SELF_PICKUP', 'LIBRARY_RETURN', 'RETURNED', '2026-06-12 10:00:00', '2026-07-12 23:59:59', NULL, '2026-06-12 10:00:00', '2026-06-26 10:20:00', '2026-06-26 11:20:00', 'NORMAL', 0, 0.00, '2026-06-11 09:45:00', '按期归还'),
(41, 7, 37, 'SELF_PICKUP', 'LIBRARY_RETURN', 'BORROWING', '2026-06-26 15:00:00', '2026-07-26 23:59:59', NULL, '2026-06-26 15:00:00', NULL, NULL, 'NORMAL', 0, 0.00, '2026-06-26 14:30:00', '唯一馆藏借阅中，用于无库存排队测试');

INSERT INTO library_borrow_order
(order_id, order_no, reader_id, book_id, borrow_type, return_type, order_status, start_date, due_date, library_ship_date, pickup_date, user_ship_back_date, library_receive_date, damage_status, overdue_flag, compensation_amount, remark, create_time, update_time)
SELECT o.seq,
       CONCAT('B', DATE_FORMAT(o.create_time, '%y%m%d'), LPAD(o.seq, 4, '0')),
       r.reader_id,
       o.book_id,
       o.borrow_type,
       o.return_type,
       o.order_status,
       o.start_date,
       o.due_date,
       o.library_ship_date,
       o.pickup_date,
       o.user_ship_back_date,
       o.library_receive_date,
       o.damage_status,
       o.overdue_flag,
       o.compensation_amount,
       o.remark,
       o.create_time,
       COALESCE(o.library_receive_date, o.user_ship_back_date, o.pickup_date, o.library_ship_date, o.create_time)
FROM tmp_order_seed o
JOIN (SELECT COUNT(*) AS cnt FROM library_reader) reader_count
JOIN tmp_readers r ON r.rn = MOD(o.reader_rn - 1, reader_count.cnt) + 1;

ALTER TABLE library_borrow_order AUTO_INCREMENT = 100;

INSERT INTO library_delivery_record
(order_id, reader_id, book_id, delivery_type, address_id, receiver_address, freight_type, fee_amount, tracking_no, carrier_name, delivery_status, ship_date, receive_date, create_time, update_time)
SELECT o.order_id,
       o.reader_id,
       o.book_id,
       'LIBRARY_OUT',
       a.address_id,
       CONCAT(a.city, a.district, a.detail_address, ' ', a.receiver_name, ' ', a.receiver_mobile),
       'CURRENT_SETTLE',
       8.00,
       CASE WHEN o.library_ship_date IS NULL THEN NULL ELSE CONCAT('SF', DATE_FORMAT(o.library_ship_date, '%m%d'), LPAD(o.order_id, 6, '0')) END,
       CASE WHEN o.library_ship_date IS NULL THEN NULL ELSE '顺丰速运' END,
       CASE WHEN o.library_ship_date IS NULL THEN 'CREATED' WHEN o.pickup_date IS NULL THEN 'SHIPPED' ELSE 'RECEIVED' END,
       o.library_ship_date,
       o.pickup_date,
       o.create_time,
       COALESCE(o.pickup_date, o.library_ship_date, o.create_time)
FROM library_borrow_order o
LEFT JOIN library_address a ON a.reader_id = o.reader_id AND a.default_flag = 1
WHERE o.borrow_type = 'LIBRARY_SHIP';

INSERT INTO library_delivery_record
(order_id, reader_id, book_id, delivery_type, address_id, receiver_address, freight_type, fee_amount, tracking_no, carrier_name, delivery_status, ship_date, receive_date, create_time, update_time)
SELECT o.order_id,
       o.reader_id,
       o.book_id,
       'USER_RETURN',
       NULL,
       '中山市东区街道兴中道8号 中山纪念图书馆流通部 0760-88888888',
       'COLLECT',
       0.00,
       CONCAT('YT', DATE_FORMAT(o.user_ship_back_date, '%m%d'), LPAD(o.order_id, 6, '0')),
       '圆通速递',
       CASE WHEN o.library_receive_date IS NULL THEN 'SHIPPED' ELSE 'RECEIVED' END,
       o.user_ship_back_date,
       o.library_receive_date,
       o.user_ship_back_date,
       COALESCE(o.library_receive_date, o.user_ship_back_date)
FROM library_borrow_order o
WHERE o.return_type = 'USER_SHIP' AND o.user_ship_back_date IS NOT NULL;

INSERT INTO library_fee_record
(reader_id, order_id, fee_type, amount, balance_after, pay_status, pay_method, remark, create_time, update_time)
SELECT reader_id,
       order_id,
       'COMPENSATION',
       compensation_amount,
       GREATEST(0, (SELECT deposit_balance FROM library_reader r WHERE r.reader_id = o.reader_id) - compensation_amount),
       CASE WHEN order_status = 'RETURNED' THEN 'PAID' ELSE 'UNPAID' END,
       'DEPOSIT',
       CASE WHEN order_status = 'RETURNED' THEN '赔偿已从押金扣除' ELSE '赔偿待缴纳' END,
       COALESCE(library_receive_date, update_time),
       COALESCE(library_receive_date, update_time)
FROM library_borrow_order o
WHERE compensation_amount > 0;

INSERT INTO library_fee_record
(reader_id, order_id, fee_type, amount, balance_after, pay_status, pay_method, remark, create_time, update_time)
SELECT r.reader_id, NULL, 'ANNUAL_FEE', 199.00, r.deposit_balance, 'PAID', '线下登记',
       '年度服务费已缴纳', '2026-01-05 10:00:00', '2026-01-05 10:00:00'
FROM tmp_readers r
WHERE r.rn = 1;

INSERT INTO library_fee_record
(reader_id, order_id, fee_type, amount, balance_after, pay_status, pay_method, remark, create_time, update_time)
SELECT r.reader_id, NULL, 'DEPOSIT_RECHARGE', 199.00, r.deposit_balance, 'PAID', '微信',
       '测试押金充值记录', '2026-03-12 10:00:00', '2026-03-12 10:00:00'
FROM tmp_readers r
WHERE r.rn = 3;

INSERT INTO library_fee_record
(reader_id, order_id, fee_type, amount, balance_after, pay_status, pay_method, remark, create_time, update_time)
SELECT o.reader_id, o.order_id, 'OVERDUE', 2.00, (SELECT deposit_balance FROM library_reader r WHERE r.reader_id = o.reader_id),
       'PAID', 'DEPOSIT', '逾期费用已扣押金', '2026-06-08 11:10:00', '2026-06-08 11:10:00'
FROM library_borrow_order o
WHERE o.order_id = 20;

INSERT INTO library_fee_record
(reader_id, order_id, fee_type, amount, balance_after, pay_status, pay_method, remark, create_time, update_time)
SELECT o.reader_id, o.order_id, 'DAMAGE', 30.00, (SELECT deposit_balance FROM library_reader r WHERE r.reader_id = o.reader_id),
       'PAID', 'DEPOSIT', '轻微破损赔偿已结清', '2026-06-25 10:00:00', '2026-06-25 10:00:00'
FROM library_borrow_order o
WHERE o.order_id = 32;

INSERT INTO library_fee_record
(reader_id, order_id, fee_type, amount, balance_after, pay_status, pay_method, remark, create_time, update_time)
SELECT o.reader_id, o.order_id, 'LOST', 180.00, (SELECT deposit_balance FROM library_reader r WHERE r.reader_id = o.reader_id),
       'UNPAID', 'DEPOSIT', '遗失赔偿待补缴', '2026-06-20 15:00:00', '2026-06-20 15:00:00'
FROM library_borrow_order o
WHERE o.order_id = 14;

DROP TEMPORARY TABLE IF EXISTS tmp_queue_seed;
CREATE TEMPORARY TABLE tmp_queue_seed (
  seq INT PRIMARY KEY,
  reader_rn INT NOT NULL,
  book_id BIGINT NOT NULL,
  queue_position INT NOT NULL,
  borrow_type VARCHAR(32) NOT NULL,
  estimated_available_date DATETIME,
  queue_status VARCHAR(32) NOT NULL,
  converted_order_id BIGINT,
  remark VARCHAR(512),
  create_time DATETIME NOT NULL
);

INSERT INTO tmp_queue_seed VALUES
(1, 1, 2, 1, 'SELF_PICKUP', '2026-06-29 10:00:00', 'WAITING', NULL, '等待同城馆藏回流', '2026-06-24 09:00:00'),
(2, 2, 1, 1, 'LIBRARY_SHIP', '2026-06-30 10:00:00', 'WAITING', NULL, '等待同城馆藏回流', '2026-06-24 10:00:00'),
(3, 3, 13, 1, 'SELF_PICKUP', '2026-06-28 10:00:00', 'CONVERTED', 36, '已转成借阅订单', '2026-06-18 09:00:00'),
(4, 4, 11, 1, 'SELF_PICKUP', '2026-06-27 10:00:00', 'CONVERTED', 37, '读者到馆前自动转单', '2026-06-19 09:00:00'),
(5, 5, 24, 1, 'LIBRARY_SHIP', '2026-07-01 10:00:00', 'WAITING', NULL, '同城配送优先', '2026-06-25 09:00:00'),
(6, 6, 27, 1, 'SELF_PICKUP', '2026-07-03 10:00:00', 'CANCELLED', NULL, '读者取消排队', '2026-06-21 09:00:00'),
(7, 7, 5, 1, 'SELF_PICKUP', '2026-07-02 10:00:00', 'WAITING', NULL, '古典文学热门排队', '2026-06-25 11:00:00'),
(8, 8, 30, 1, 'LIBRARY_SHIP', '2026-07-04 10:00:00', 'WAITING', NULL, '自然科学热门排队', '2026-06-25 15:00:00'),
(9, 9, 37, 1, 'SELF_PICKUP', '2026-07-06 10:00:00', 'WAITING', NULL, '唯一馆藏借出中，等待归还', '2026-06-26 16:00:00'),
(10, 3, 37, 2, 'LIBRARY_SHIP', '2026-07-08 10:00:00', 'EXCEPTION', NULL, '年费已过期，自动转单失败', '2026-06-26 16:20:00');

INSERT INTO library_queue_record
(queue_id, reader_id, book_id, queue_no, queue_position, borrow_type, address_id, estimated_available_date, queue_status, converted_order_id, remark, create_time, update_time)
SELECT q.seq,
       r.reader_id,
       q.book_id,
       CONCAT('Q', DATE_FORMAT(q.create_time, '%y%m%d'), LPAD(q.seq, 4, '0')),
       q.queue_position,
       q.borrow_type,
       a.address_id,
       q.estimated_available_date,
       q.queue_status,
       q.converted_order_id,
       q.remark,
       q.create_time,
       q.create_time
FROM tmp_queue_seed q
JOIN (SELECT COUNT(*) AS cnt FROM library_reader) reader_count
JOIN tmp_readers r ON r.rn = MOD(q.reader_rn - 1, reader_count.cnt) + 1
LEFT JOIN library_address a ON a.reader_id = r.reader_id AND a.default_flag = 1;

ALTER TABLE library_queue_record AUTO_INCREMENT = 100;

UPDATE library_book b
LEFT JOIN (
    SELECT book_id, COUNT(*) AS active_count
    FROM library_borrow_order
    WHERE order_status IN ('WAIT_PICKUP', 'WAIT_SHIP', 'BORROWING', 'RETURNING', 'COMPENSATION_PENDING')
    GROUP BY book_id
) active_orders ON active_orders.book_id = b.book_id
LEFT JOIN (
    SELECT book_id, COUNT(*) AS waiting_count
    FROM library_queue_record
    WHERE queue_status = 'WAITING'
    GROUP BY book_id
) active_queues ON active_queues.book_id = b.book_id
SET b.available_count = GREATEST(b.total_count - COALESCE(active_orders.active_count, 0), 0),
    b.queue_count = COALESCE(active_queues.waiting_count, 0),
    b.update_time = '2026-06-26 09:50:00';

UPDATE library_reader r
LEFT JOIN (
    SELECT reader_id,
           SUM(CASE WHEN borrow_type = 'LIBRARY_SHIP' THEN 1 ELSE 0 END) AS out_count,
           SUM(CASE WHEN return_type = 'USER_SHIP' THEN 1 ELSE 0 END) AS in_count
    FROM library_borrow_order
    WHERE create_time >= '2026-01-01 00:00:00'
    GROUP BY reader_id
) stats ON stats.reader_id = r.reader_id
SET r.used_outbound_count = COALESCE(stats.out_count, 0),
    r.used_inbound_count = COALESCE(stats.in_count, 0),
    r.status = CASE WHEN r.reader_id IN (
        SELECT reader_id FROM library_borrow_order WHERE order_status = 'COMPENSATION_PENDING' AND compensation_amount > r.deposit_balance
    ) THEN 'DISABLED' ELSE r.status END,
    r.update_time = '2026-06-26 09:55:00';

DROP TEMPORARY TABLE IF EXISTS tmp_queue_seed;
DROP TEMPORARY TABLE IF EXISTS tmp_order_seed;
DROP TEMPORARY TABLE IF EXISTS tmp_readers;

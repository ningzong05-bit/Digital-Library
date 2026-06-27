-- Ensure administrator accounts are not also readers.
-- Safe to run repeatedly on the local zsc database.

DROP TEMPORARY TABLE IF EXISTS tmp_admin_reader_ids;
CREATE TEMPORARY TABLE tmp_admin_reader_ids AS
SELECT DISTINCT lr.reader_id
FROM library_reader lr
INNER JOIN sys_user u ON lr.user_id = u.user_id
INNER JOIN sys_user_role ur ON u.user_id = ur.user_id
INNER JOIN sys_role r ON ur.role_id = r.role_id
WHERE u.del_flag = '0'
  AND r.del_flag = '0'
  AND r.role_key = 'admin';

DROP TEMPORARY TABLE IF EXISTS tmp_admin_user_ids;
CREATE TEMPORARY TABLE tmp_admin_user_ids AS
SELECT DISTINCT u.user_id
FROM sys_user u
INNER JOIN sys_user_role ur ON u.user_id = ur.user_id
INNER JOIN sys_role r ON ur.role_id = r.role_id
WHERE u.del_flag = '0'
  AND r.del_flag = '0'
  AND r.role_key = 'admin';

DROP TEMPORARY TABLE IF EXISTS tmp_admin_reader_order_ids;
CREATE TEMPORARY TABLE tmp_admin_reader_order_ids AS
SELECT DISTINCT order_id
FROM library_borrow_order
WHERE reader_id IN (SELECT reader_id FROM tmp_admin_reader_ids);

DELETE FROM library_fee_record
WHERE reader_id IN (SELECT reader_id FROM tmp_admin_reader_ids)
   OR order_id IN (SELECT order_id FROM tmp_admin_reader_order_ids);

DELETE FROM library_delivery_record
WHERE reader_id IN (SELECT reader_id FROM tmp_admin_reader_ids)
   OR order_id IN (SELECT order_id FROM tmp_admin_reader_order_ids);

DELETE FROM library_queue_record
WHERE reader_id IN (SELECT reader_id FROM tmp_admin_reader_ids);

DELETE FROM library_address
WHERE reader_id IN (SELECT reader_id FROM tmp_admin_reader_ids);

DELETE FROM library_borrow_order
WHERE order_id IN (SELECT order_id FROM tmp_admin_reader_order_ids);

DELETE FROM library_reader
WHERE reader_id IN (SELECT reader_id FROM tmp_admin_reader_ids);

DELETE ur
FROM sys_user_role ur
INNER JOIN sys_role reader_role ON ur.role_id = reader_role.role_id
INNER JOIN tmp_admin_user_ids au ON ur.user_id = au.user_id
WHERE reader_role.role_key = 'reader'
  AND reader_role.del_flag = '0';

UPDATE library_book b
LEFT JOIN (
  SELECT book_id, COUNT(*) AS active_count
  FROM library_borrow_order
  WHERE order_status IN ('WAIT_PICKUP', 'WAIT_SHIP', 'BORROWING', 'RETURNING')
  GROUP BY book_id
) active_orders ON active_orders.book_id = b.book_id
LEFT JOIN (
  SELECT book_id, COUNT(*) AS waiting_count
  FROM library_queue_record
  WHERE queue_status = 'WAITING'
  GROUP BY book_id
) waiting_queues ON waiting_queues.book_id = b.book_id
SET b.available_count = GREATEST(b.total_count - COALESCE(active_orders.active_count, 0), 0),
    b.queue_count = COALESCE(waiting_queues.waiting_count, 0),
    b.update_time = NOW();

DROP TEMPORARY TABLE IF EXISTS tmp_admin_reader_order_ids;
DROP TEMPORARY TABLE IF EXISTS tmp_admin_user_ids;
DROP TEMPORARY TABLE IF EXISTS tmp_admin_reader_ids;

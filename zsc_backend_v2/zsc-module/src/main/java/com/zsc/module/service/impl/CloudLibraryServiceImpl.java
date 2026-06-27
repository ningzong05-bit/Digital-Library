package com.zsc.module.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zsc.common.utils.SecurityUtils;
import com.zsc.module.common.constants.LibraryConstants;
import com.zsc.module.common.exception.ServiceException;
import com.zsc.module.common.pagination.PageResult;
import com.zsc.module.domain.dto.LibraryDto;
import com.zsc.module.domain.entity.*;
import com.zsc.module.mapper.*;
import com.zsc.module.service.CloudLibraryService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.Resource;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class CloudLibraryServiceImpl implements CloudLibraryService {

    private static final Long DEFAULT_ACCOUNT_DEPT_ID = 100L;
    private static final String ADMIN_ROLE_KEY = "admin";
    private static final String READER_ROLE_KEY = "reader";
    private static final String DEFAULT_READER_PASSWORD = "reader123";
    private static final BigDecimal MIN_BORROW_DEPOSIT = new BigDecimal("199.00");
    private static final int MAX_READER_ADDRESS_COUNT = 5;

    @Resource
    private LibraryBookMapper bookMapper;
    @Resource
    private JdbcTemplate jdbcTemplate;
    @Resource
    private LibraryReaderMapper readerMapper;
    @Resource
    private LibraryAddressMapper addressMapper;
    @Resource
    private LibraryBorrowOrderMapper orderMapper;
    @Resource
    private LibraryQueueRecordMapper queueMapper;
    @Resource
    private LibraryDeliveryRecordMapper deliveryMapper;
    @Resource
    private LibraryFeeRecordMapper feeMapper;
    @Resource
    private LibraryRuleMapper ruleMapper;

    @PostConstruct
    public void init() {
        syncReadersFromUsers();
    }

    @Override
    @Transactional(readOnly = true)
    public LibraryBook getBook(Long bookId) {
        return requiredBook(bookId);
    }

    @Override
    @Transactional
    public void saveBook(LibraryDto.BookSave request) {
        Date now = new Date();
        LibraryBook book = new LibraryBook();
        BeanUtils.copyProperties(request, book);
        book.setUpdateTime(now);
        if (book.getStatus() == null) {
            book.setStatus(LibraryConstants.ENABLED);
        }
        if (book.getTotalCount() == null || book.getTotalCount() < 0) {
            book.setTotalCount(0);
        }
        if (book.getAvailableCount() == null || book.getAvailableCount() < 0) {
            book.setAvailableCount(book.getTotalCount());
        }
        if (book.getQueueCount() == null) {
            book.setQueueCount(0);
        }
        if (book.getBookId() == null) {
            LibraryBook exists = findBookByIsbn(book.getIsbn());
            if (exists != null) {
                exists.setBookName(StringUtils.defaultIfBlank(book.getBookName(), exists.getBookName()));
                exists.setAuthor(StringUtils.defaultIfBlank(book.getAuthor(), exists.getAuthor()));
                exists.setPublisher(StringUtils.defaultIfBlank(book.getPublisher(), exists.getPublisher()));
                exists.setCategoryName(StringUtils.defaultIfBlank(book.getCategoryName(), exists.getCategoryName()));
                exists.setCoverUrl(StringUtils.defaultIfBlank(book.getCoverUrl(), exists.getCoverUrl()));
                exists.setDescription(StringUtils.defaultIfBlank(book.getDescription(), exists.getDescription()));
                exists.setTotalCount(safeInt(exists.getTotalCount()) + safeInt(book.getTotalCount()));
                exists.setAvailableCount(safeInt(exists.getAvailableCount()) + safeInt(book.getAvailableCount()));
                exists.setStatus(book.getStatus());
                exists.setUpdateTime(now);
                bookMapper.updateById(exists);
                return;
            }
            book.setCreateTime(now);
            bookMapper.insert(book);
        } else {
            if (LibraryConstants.DISABLED.equals(book.getStatus())) {
                ensureBookCanStop(book.getBookId());
            }
            bookMapper.updateById(book);
        }
    }

    @Override
    @Transactional
    public void deleteBook(Long bookId) {
        requiredBook(bookId);
        ensureBookCanStop(bookId);
        bookMapper.deleteById(bookId);
    }

    @Override
    @Transactional(readOnly = true)
    public PageResult<LibraryBook> queryBooks(LibraryDto.BookQuery request) {
        Page<LibraryBook> page = bookMapper.selectPage(request.convetToPage(),
                new LambdaQueryWrapper<LibraryBook>()
                        .like(StringUtils.isNotBlank(request.getBookName()), LibraryBook::getBookName, request.getBookName())
                        .like(StringUtils.isNotBlank(request.getIsbn()), LibraryBook::getIsbn, request.getIsbn())
                        .like(StringUtils.isNotBlank(request.getAuthor()), LibraryBook::getAuthor, request.getAuthor())
                        .eq(StringUtils.isNotBlank(request.getCategoryName()), LibraryBook::getCategoryName, request.getCategoryName())
                        .eq(StringUtils.isNotBlank(request.getStatus()), LibraryBook::getStatus, request.getStatus())
                        .gt(request.getOnlyAvailable() != null && request.getOnlyAvailable() == 1, LibraryBook::getAvailableCount, 0)
                        .orderByDesc(LibraryBook::getUpdateTime));
        return PageResult.fromPage(page);
    }

    @Override
    @Transactional(readOnly = true)
    public LibraryReader getReader(Long readerId) {
        LibraryReader reader = requiredReader(readerId);
        applyEffectiveReaderStatus(reader);
        return reader;
    }

    @Override
    @Transactional
    public void deleteReader(Long readerId) {
        LibraryReader reader = requiredReader(readerId);
        Long activeOrders = orderMapper.selectCount(new LambdaQueryWrapper<LibraryBorrowOrder>()
                .eq(LibraryBorrowOrder::getReaderId, readerId)
                .in(LibraryBorrowOrder::getOrderStatus,
                        LibraryConstants.ORDER_WAIT_PICKUP,
                        LibraryConstants.ORDER_WAIT_SHIP,
                        LibraryConstants.ORDER_BORROWING,
                        LibraryConstants.ORDER_RETURNING));
        if (activeOrders != null && activeOrders > 0) {
            throw new ServiceException("该读者有 " + activeOrders + " 笔进行中的订单，无法删除");
        }
        addressMapper.delete(new LambdaQueryWrapper<LibraryAddress>()
                .eq(LibraryAddress::getReaderId, readerId));
        readerMapper.deleteById(readerId);
        deleteReaderAccount(reader.getUserId());
    }

    @Override
    @Transactional
    public void saveReader(LibraryDto.ReaderSave request) {
        Date now = new Date();
        LibraryReader reader = new LibraryReader();
        BeanUtils.copyProperties(request, reader);
        reader.setAnnualExpireDate(parseLibraryDate(request.getAnnualExpireDate()));
        reader.setUpdateTime(now);
        if (reader.getStatus() == null) {
            reader.setStatus(LibraryConstants.NORMAL);
        }
        if (reader.getDepositBalance() == null) {
            reader.setDepositBalance(BigDecimal.ZERO);
        }
        if (reader.getDepositFrozen() == null) {
            reader.setDepositFrozen(BigDecimal.ZERO);
        }
        if (reader.getUsedOutboundCount() == null) {
            reader.setUsedOutboundCount(0);
        }
        if (reader.getUsedInboundCount() == null) {
            reader.setUsedInboundCount(0);
        }
        bindReaderAccount(request, reader, now);
        if (reader.getReaderId() == null) {
            reader.setCreateTime(now);
            readerMapper.insert(reader);
        } else {
            readerMapper.updateById(reader);
        }
    }

    @Override
    @Transactional
    public LibraryReader getOrCreateReader(Long userId, String readerName) {
        if (userId == null) {
            throw new ServiceException("用户ID不能为空");
        }
        ensureUserCanBeReader(userId);
        LibraryReader reader = readerMapper.selectOne(new LambdaQueryWrapper<LibraryReader>()
                .eq(LibraryReader::getUserId, userId)
                .last("limit 1"));
        if (reader != null) {
            return reader;
        }
        reader = buildDefaultReader(userId, readerName);
        readerMapper.insert(reader);
        return reader;
    }

    @Override
    @Transactional
    public LibraryReader getReaderByMobile(String mobile) {
        if (StringUtils.isBlank(mobile)) {
            throw new ServiceException("手机号不能为空");
        }
        // 先查 library_reader.mobile
        LibraryReader reader = readerMapper.selectOne(new LambdaQueryWrapper<LibraryReader>()
                .eq(LibraryReader::getMobile, mobile)
                .last("limit 1"));
        if (reader != null) {
            return reader;
        }
        // 未找到则查 sys_user.phonenumber，通过 user_id 关联
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT r.reader_id FROM library_reader r " +
                "INNER JOIN sys_user u ON r.user_id = u.user_id " +
                "WHERE u.phonenumber = ? AND u.del_flag = '0' LIMIT 1", mobile);
        if (!rows.isEmpty()) {
            Long readerId = ((Number) rows.get(0).get("reader_id")).longValue();
            reader = readerMapper.selectById(readerId);
            // 同步手机号到 library_reader
            if (reader != null) {
                reader.setMobile(mobile);
                reader.setUpdateTime(new Date());
                readerMapper.updateById(reader);
            }
            return reader;
        }
        throw new ServiceException("未找到该手机号对应的读者，请联系管理员创建读者账号");
    }

    @Override
    @Transactional
    public int syncReadersFromUsers() {
        List<Map<String, Object>> users = jdbcTemplate.queryForList(
                "SELECT u.user_id, u.nick_name FROM sys_user u " +
                "INNER JOIN sys_user_role ur ON u.user_id = ur.user_id " +
                "INNER JOIN sys_role r ON ur.role_id = r.role_id " +
                "WHERE r.role_key = 'reader' AND u.del_flag = '0' " +
                "AND NOT EXISTS (" +
                "  SELECT 1 FROM sys_user_role aur " +
                "  INNER JOIN sys_role ar ON aur.role_id = ar.role_id " +
                "  WHERE aur.user_id = u.user_id AND ar.role_key = 'admin' AND ar.del_flag = '0'" +
                ")");
        int created = 0;
        for (Map<String, Object> user : users) {
            Long userId = ((Number) user.get("user_id")).longValue();
            Long count = readerMapper.selectCount(new LambdaQueryWrapper<LibraryReader>()
                    .eq(LibraryReader::getUserId, userId));
            if (count == null || count == 0) {
                readerMapper.insert(buildDefaultReader(userId, (String) user.get("nick_name")));
                created++;
            }
        }
        return created;
    }

    @Override
    @Transactional(readOnly = true)
    public PageResult<LibraryReader> queryReaders(LibraryDto.ReaderQuery request) {
        String contact = StringUtils.defaultIfBlank(request.getReaderContact(), request.getMobile());
        Page<LibraryReader> page = readerMapper.selectPage(request.convetToPage(),
                new LambdaQueryWrapper<LibraryReader>()
                        .like(StringUtils.isNotBlank(request.getReaderName()), LibraryReader::getReaderName, request.getReaderName())
                        .like(StringUtils.isNotBlank(contact), LibraryReader::getMobile, contact)
                        .eq(StringUtils.isNotBlank(request.getCity()), LibraryReader::getCity, request.getCity())
                        .eq(StringUtils.isNotBlank(request.getStatus()), LibraryReader::getStatus, request.getStatus())
                        .orderByDesc(LibraryReader::getUpdateTime));
        page.getRecords().forEach(this::applyEffectiveReaderStatus);
        return PageResult.fromPage(page);
    }

    @Override
    @Transactional
    public void saveAddress(LibraryDto.AddressSave request) {
        requiredReader(request.getReaderId());
        validateAddressCity(request.getCity());
        if (request.getAddressId() == null) {
            Long existing = addressMapper.selectCount(new LambdaQueryWrapper<LibraryAddress>()
                    .eq(LibraryAddress::getReaderId, request.getReaderId()));
            if (existing != null && existing >= MAX_READER_ADDRESS_COUNT) {
                throw new ServiceException("每位读者最多只能维护 5 个收货地址");
            }
        }
        Date now = new Date();
        LibraryAddress address = new LibraryAddress();
        BeanUtils.copyProperties(request, address);
        address.setUpdateTime(now);
        if (address.getStatus() == null) {
            address.setStatus(LibraryConstants.ENABLED);
        }
        if (address.getDefaultFlag() == null) {
            address.setDefaultFlag(0);
        }
        if (address.getDefaultFlag() == 1) {
            // 将该读者其他地址的默认标记取消，确保只有一个默认地址
            for (LibraryAddress other : addressMapper.selectList(new LambdaQueryWrapper<LibraryAddress>()
                    .eq(LibraryAddress::getReaderId, request.getReaderId())
                    .eq(LibraryAddress::getDefaultFlag, 1))) {
                if (!other.getAddressId().equals(address.getAddressId())) {
                    other.setDefaultFlag(0);
                    other.setUpdateTime(now);
                    addressMapper.updateById(other);
                }
            }
        }
        if (address.getAddressId() == null) {
            address.setCreateTime(now);
            addressMapper.insert(address);
        } else {
            addressMapper.updateById(address);
        }
        if (address.getDefaultFlag() == 1) {
            LibraryReader reader = requiredReader(address.getReaderId());
            reader.setDefaultAddressId(address.getAddressId());
            reader.setCity(address.getCity());
            reader.setUpdateTime(now);
            readerMapper.updateById(reader);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public LibraryAddress getAddress(Long addressId) {
        return requiredAddress(addressId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<LibraryAddress> getReaderAddresses(Long readerId) {
        requiredReader(readerId);
        return addressMapper.selectList(new LambdaQueryWrapper<LibraryAddress>()
                .eq(LibraryAddress::getReaderId, readerId)
                .orderByDesc(LibraryAddress::getDefaultFlag)
                .orderByDesc(LibraryAddress::getUpdateTime));
    }

    @Override
    @Transactional
    public void deleteAddress(Long addressId) {
        LibraryAddress address = requiredAddress(addressId);
        addressMapper.deleteById(addressId);
        if (address.getDefaultFlag() != null && address.getDefaultFlag() == 1) {
            LibraryReader reader = requiredReader(address.getReaderId());
            if (addressId.equals(reader.getDefaultAddressId())) {
                reader.setDefaultAddressId(null);
                reader.setUpdateTime(new Date());
                readerMapper.updateById(reader);
            }
        }
    }

    @Override
    @Transactional
    public Map<String, Object> borrowOnline(LibraryDto.BorrowRequest request) {
        LibraryRule rule = getActiveRule();
        LibraryReader reader = validateBorrowQualification(request.getReaderId(), rule);
        LibraryBook book = requiredBook(request.getBookId());
        ensureBookEnabled(book);
        String receiverAddress = validateBorrowType(reader, rule, request.getBorrowType(),
                request.getAddressId(), request.getReceiverAddress());

        if (safeInt(book.getAvailableCount()) <= 0) {
            LibraryDto.QueueRequest queueRequest = new LibraryDto.QueueRequest();
            queueRequest.setReaderId(request.getReaderId());
            queueRequest.setBookId(request.getBookId());
            queueRequest.setBorrowType(request.getBorrowType());
            queueRequest.setAddressId(request.getAddressId());
            queueRequest.setReceiverAddress(request.getReceiverAddress());
            queueRequest.setRemark(StringUtils.defaultIfBlank(request.getRemark(), "馆藏无剩余，自动进入排队"));
            Map<String, Object> result = joinQueue(queueRequest);
            result.put("borrowResult", "QUEUED");
            return result;
        }

        LibraryBorrowOrder order = createWaitingOrder(reader, book, request.getBorrowType(), request.getRemark());
        reduceAvailableBook(book);
        if (LibraryConstants.BORROW_LIBRARY_SHIP.equals(request.getBorrowType())) {
            createOutboundDelivery(order, null, null, null, null, receiverAddress);
        }
        return resultMap("borrowResult", "ORDER_CREATED", "order", order);
    }

    @Override
    @Transactional
    public Map<String, Object> joinQueue(LibraryDto.QueueRequest request) {
        LibraryRule rule = getActiveRule();
        LibraryReader reader = validateBorrowQualification(request.getReaderId(), rule);
        LibraryBook book = requiredBook(request.getBookId());
        ensureBookEnabled(book);
        validateBorrowType(reader, rule, request.getBorrowType(),
                request.getAddressId(), request.getReceiverAddress());

        Long duplicate = queueMapper.selectCount(new LambdaQueryWrapper<LibraryQueueRecord>()
                .eq(LibraryQueueRecord::getReaderId, request.getReaderId())
                .eq(LibraryQueueRecord::getBookId, request.getBookId())
                .eq(LibraryQueueRecord::getQueueStatus, LibraryConstants.QUEUE_WAITING));
        if (duplicate != null && duplicate > 0) {
            throw new ServiceException("该读者已在此图书的排队列表中");
        }

        Long waiting = queueMapper.selectCount(new LambdaQueryWrapper<LibraryQueueRecord>()
                .eq(LibraryQueueRecord::getBookId, request.getBookId())
                .eq(LibraryQueueRecord::getQueueStatus, LibraryConstants.QUEUE_WAITING));
        int position = waiting == null ? 1 : waiting.intValue() + 1;
        Date estimate = estimateAvailableDate(book.getBookId(), position, rule);

        Date now = new Date();
        LibraryQueueRecord queue = new LibraryQueueRecord();
        queue.setReaderId(reader.getReaderId());
        queue.setBookId(book.getBookId());
        queue.setQueueNo(nextNo("Q"));
        queue.setQueuePosition(position);
        queue.setBorrowType(request.getBorrowType());
        queue.setAddressId(request.getAddressId());
        queue.setEstimatedAvailableDate(estimate);
        queue.setQueueStatus(LibraryConstants.QUEUE_WAITING);
        queue.setRemark(request.getRemark());
        queue.setCreateTime(now);
        queue.setUpdateTime(now);
        queueMapper.insert(queue);

        updateBookQueueCount(book.getBookId());
        return resultMap("queueResult", "WAITING", "queue", queue);
    }

    @Override
    @Transactional(readOnly = true)
    public PageResult<?> queryOrders(LibraryDto.OrderQuery request) {
        List<Long> readerIds = findReaderIdsByContact(request.getReaderContact());
        LambdaQueryWrapper<LibraryBorrowOrder> wrapper = new LambdaQueryWrapper<LibraryBorrowOrder>()
                .eq(request.getReaderId() != null, LibraryBorrowOrder::getReaderId, request.getReaderId())
                .in(readerIds != null, LibraryBorrowOrder::getReaderId,
                        readerIds == null || readerIds.isEmpty() ? Collections.singletonList(-1L) : readerIds)
                .eq(request.getBookId() != null, LibraryBorrowOrder::getBookId, request.getBookId())
                .eq(StringUtils.isNotBlank(request.getOrderNo()), LibraryBorrowOrder::getOrderNo, request.getOrderNo())
                .eq(StringUtils.isNotBlank(request.getOrderStatus()), LibraryBorrowOrder::getOrderStatus, request.getOrderStatus())
                .eq(StringUtils.isNotBlank(request.getBorrowType()), LibraryBorrowOrder::getBorrowType, request.getBorrowType())
                .eq(StringUtils.isNotBlank(request.getReturnType()), LibraryBorrowOrder::getReturnType, request.getReturnType());
        if (Boolean.TRUE.equals(request.getPendingOnly())) {
            wrapper.in(LibraryBorrowOrder::getOrderStatus,
                    LibraryConstants.ORDER_WAIT_PICKUP,
                    LibraryConstants.ORDER_WAIT_SHIP,
                    LibraryConstants.ORDER_RETURNING,
                    LibraryConstants.ORDER_COMPENSATION_PENDING);
        }
        wrapper.last("ORDER BY CASE WHEN order_status = 'RETURNED' THEN 1 ELSE 0 END ASC, update_time DESC, create_time DESC");
        Page<LibraryBorrowOrder> page = orderMapper.selectPage(request.convetToPage(),
                wrapper);
        fillOrderDisplayFields(page.getRecords());
        return PageResult.fromPage(page);
    }

    @Override
    @Transactional(readOnly = true)
    public PageResult<?> queryQueues(LibraryDto.QueueQuery request) {
        List<Long> readerIds = findReaderIdsByContact(request.getReaderContact());
        Page<LibraryQueueRecord> page = queueMapper.selectPage(request.convetToPage(),
                new LambdaQueryWrapper<LibraryQueueRecord>()
                        .eq(request.getReaderId() != null, LibraryQueueRecord::getReaderId, request.getReaderId())
                        .in(readerIds != null, LibraryQueueRecord::getReaderId,
                                readerIds == null || readerIds.isEmpty() ? Collections.singletonList(-1L) : readerIds)
                        .eq(request.getBookId() != null, LibraryQueueRecord::getBookId, request.getBookId())
                        .eq(StringUtils.isNotBlank(request.getQueueStatus()), LibraryQueueRecord::getQueueStatus, request.getQueueStatus())
                        .orderByAsc(LibraryQueueRecord::getQueuePosition)
                        .orderByAsc(LibraryQueueRecord::getCreateTime));
        fillQueueDisplayFields(page.getRecords());
        return PageResult.fromPage(page);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> dashboard() {
        List<LibraryBook> books = bookMapper.selectList(new LambdaQueryWrapper<LibraryBook>()
                .orderByDesc(LibraryBook::getCreateTime)
                .orderByDesc(LibraryBook::getBookId));
        List<LibraryBorrowOrder> orders = orderMapper.selectList(new LambdaQueryWrapper<LibraryBorrowOrder>()
                .orderByDesc(LibraryBorrowOrder::getCreateTime)
                .orderByDesc(LibraryBorrowOrder::getOrderId));

        Map<Long, LibraryBook> bookMap = new HashMap<>();
        for (LibraryBook book : books) {
            bookMap.put(book.getBookId(), book);
        }

        int totalBooks = books.stream().mapToInt(book -> safeInt(book.getTotalCount())).sum();
        int availableBooks = books.stream().mapToInt(book -> safeInt(book.getAvailableCount())).sum();
        long borrowedBooks = orders.stream().filter(this::isDashboardActiveOrder).count();
        long totalCategories = books.stream()
                .map(book -> StringUtils.defaultIfBlank(book.getCategoryName(), "未分类"))
                .distinct()
                .count();

        Map<String, Integer> categoryMap = new LinkedHashMap<>();
        books.stream()
                .sorted(Comparator.comparing(LibraryBook::getCategoryName, Comparator.nullsLast(String::compareTo)))
                .forEach(book -> categoryMap.merge(StringUtils.defaultIfBlank(book.getCategoryName(), "未分类"),
                        safeInt(book.getTotalCount()), Integer::sum));
        List<Map<String, Object>> categoryStats = categoryMap.entrySet().stream()
                .map(entry -> resultMap("name", entry.getKey(), "value", entry.getValue()))
                .toList();

        Date trendBase = orders.stream()
                .map(LibraryBorrowOrder::getCreateTime)
                .filter(Objects::nonNull)
                .max(Date::compareTo)
                .orElse(new Date());
        List<Map<String, Object>> borrowTrend = buildBorrowTrend(orders, trendBase);

        Map<Long, Long> borrowCountMap = new HashMap<>();
        for (LibraryBorrowOrder order : orders) {
            if (order.getBookId() != null) {
                borrowCountMap.merge(order.getBookId(), 1L, Long::sum);
            }
        }
        List<Map<String, Object>> hotBooks = borrowCountMap.entrySet().stream()
                .sorted(Map.Entry.<Long, Long>comparingByValue().reversed())
                .limit(10)
                .map(entry -> {
                    LibraryBook book = bookMap.get(entry.getKey());
                    return resultMap(
                            "bookId", entry.getKey(),
                            "title", book == null ? "图书#" + entry.getKey() : book.getBookName(),
                            "author", book == null ? "-" : book.getAuthor(),
                            "categoryName", book == null ? "-" : book.getCategoryName(),
                            "borrowCount", entry.getValue()
                    );
                })
                .toList();

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        List<Map<String, Object>> newBooks = books.stream()
                .limit(5)
                .map(book -> resultMap(
                        "bookId", book.getBookId(),
                        "title", book.getBookName(),
                        "author", book.getAuthor(),
                        "categoryName", book.getCategoryName(),
                        "createdTime", book.getCreateTime() == null ? "-" : dateFormat.format(book.getCreateTime())
                ))
                .toList();

        return resultMap(
                "statistics", resultMap(
                        "totalBooks", totalBooks,
                        "availableBooks", availableBooks,
                        "borrowedBooks", borrowedBooks,
                        "totalCategories", totalCategories
                ),
                "categoryStats", categoryStats,
                "borrowTrend", borrowTrend,
                "hotBooks", hotBooks,
                "newBooks", newBooks
        );
    }

    private boolean isDashboardActiveOrder(LibraryBorrowOrder order) {
        return order != null
                && (LibraryConstants.ORDER_WAIT_PICKUP.equals(order.getOrderStatus())
                || LibraryConstants.ORDER_WAIT_SHIP.equals(order.getOrderStatus())
                || LibraryConstants.ORDER_BORROWING.equals(order.getOrderStatus())
                || LibraryConstants.ORDER_RETURNING.equals(order.getOrderStatus())
                || LibraryConstants.ORDER_COMPENSATION_PENDING.equals(order.getOrderStatus()));
    }

    private List<Map<String, Object>> buildBorrowTrend(List<LibraryBorrowOrder> orders, Date baseDate) {
        SimpleDateFormat labelFormat = new SimpleDateFormat("MM-dd");
        List<Map<String, Object>> trend = new ArrayList<>();
        Calendar base = Calendar.getInstance();
        base.setTime(baseDate);
        clearTime(base);
        base.add(Calendar.DAY_OF_MONTH, -6);
        for (int i = 0; i < 7; i++) {
            Date start = base.getTime();
            Calendar next = (Calendar) base.clone();
            next.add(Calendar.DAY_OF_MONTH, 1);
            long count = orders.stream()
                    .map(LibraryBorrowOrder::getCreateTime)
                    .filter(Objects::nonNull)
                    .filter(date -> !date.before(start) && date.before(next.getTime()))
                    .count();
            trend.add(resultMap("label", labelFormat.format(start), "value", count));
            base.add(Calendar.DAY_OF_MONTH, 1);
        }
        return trend;
    }

    private void clearTime(Calendar calendar) {
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
    }

    private List<Long> findReaderIdsByContact(String readerContact) {
        if (StringUtils.isBlank(readerContact)) {
            return null;
        }
        String keyword = "%" + readerContact.trim() + "%";
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT DISTINCT r.reader_id FROM library_reader r " +
                        "LEFT JOIN sys_user u ON r.user_id = u.user_id AND u.del_flag = '0' " +
                        "WHERE r.mobile LIKE ? OR u.phonenumber LIKE ?",
                keyword, keyword);
        List<Long> ids = new ArrayList<>();
        for (Map<String, Object> row : rows) {
            Object value = row.get("reader_id");
            if (value instanceof Number) {
                ids.add(((Number) value).longValue());
            }
        }
        return ids;
    }

    private void fillOrderDisplayFields(List<LibraryBorrowOrder> records) {
        if (records == null || records.isEmpty()) {
            return;
        }
        Map<Long, LibraryReader> readers = loadReaders(records.stream().map(LibraryBorrowOrder::getReaderId).toList());
        Map<Long, LibraryBook> books = loadBooks(records.stream().map(LibraryBorrowOrder::getBookId).toList());
        for (LibraryBorrowOrder order : records) {
            LibraryReader reader = readers.get(order.getReaderId());
            if (reader != null) {
                order.setReaderName(reader.getReaderName());
                order.setReaderContact(reader.getMobile());
            }
            LibraryBook book = books.get(order.getBookId());
            if (book != null) {
                order.setBookName(book.getBookName());
            }
        }
    }

    private void fillQueueDisplayFields(List<LibraryQueueRecord> records) {
        if (records == null || records.isEmpty()) {
            return;
        }
        Map<Long, LibraryReader> readers = loadReaders(records.stream().map(LibraryQueueRecord::getReaderId).toList());
        Map<Long, LibraryBook> books = loadBooks(records.stream().map(LibraryQueueRecord::getBookId).toList());
        for (LibraryQueueRecord queue : records) {
            LibraryReader reader = readers.get(queue.getReaderId());
            if (reader != null) {
                queue.setReaderName(reader.getReaderName());
                queue.setReaderContact(reader.getMobile());
            }
            LibraryBook book = books.get(queue.getBookId());
            if (book != null) {
                queue.setBookName(book.getBookName());
            }
        }
    }

    private Map<Long, LibraryReader> loadReaders(List<Long> readerIds) {
        List<Long> ids = readerIds.stream().filter(Objects::nonNull).distinct().toList();
        if (ids.isEmpty()) {
            return Collections.emptyMap();
        }
        List<LibraryReader> readers = readerMapper.selectList(new LambdaQueryWrapper<LibraryReader>()
                .in(LibraryReader::getReaderId, ids));
        Map<Long, LibraryReader> result = new HashMap<>();
        for (LibraryReader reader : readers) {
            result.put(reader.getReaderId(), reader);
        }
        return result;
    }

    private Map<Long, LibraryBook> loadBooks(List<Long> bookIds) {
        List<Long> ids = bookIds.stream().filter(Objects::nonNull).distinct().toList();
        if (ids.isEmpty()) {
            return Collections.emptyMap();
        }
        List<LibraryBook> books = bookMapper.selectList(new LambdaQueryWrapper<LibraryBook>()
                .in(LibraryBook::getBookId, ids));
        Map<Long, LibraryBook> result = new HashMap<>();
        for (LibraryBook book : books) {
            result.put(book.getBookId(), book);
        }
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> handleQueue(LibraryDto.QueueHandleRequest request) {
        LibraryQueueRecord queue = requiredQueue(request.getQueueId());
        String status = request.getQueueStatus();
        if (!LibraryConstants.QUEUE_WAITING.equals(status)
                && !LibraryConstants.QUEUE_EXCEPTION.equals(status)
                && !LibraryConstants.QUEUE_CANCELLED.equals(status)) {
            throw new ServiceException("排队处理状态只能是 WAITING、EXCEPTION 或 CANCELLED");
        }
        if (LibraryConstants.QUEUE_CONVERTED.equals(queue.getQueueStatus())) {
            throw new ServiceException("已转订单的排队记录不能再次处理");
        }
        queue.setQueueStatus(status);
        queue.setRemark(appendRemark(queue.getRemark(), request.getRemark()));
        queue.setUpdateTime(new Date());
        queueMapper.updateById(queue);
        updateBookQueueCount(queue.getBookId());
        if (!LibraryConstants.QUEUE_WAITING.equals(status)) {
            autoCreateOrdersFromQueue(queue.getBookId());
        }
        return resultMap("queueResult", status, "queue", queue);
    }

    @Override
    @Transactional
    public Map<String, Object> confirmFulfillment(LibraryDto.FulfillmentRequest request) {
        LibraryBorrowOrder order = requiredOrder(request.getOrderId());
        if (!LibraryConstants.ORDER_WAIT_PICKUP.equals(order.getOrderStatus())
                && !LibraryConstants.ORDER_WAIT_SHIP.equals(order.getOrderStatus())) {
            throw new ServiceException("只有待自取或待寄出的订单可以确认借出");
        }
        LibraryRule rule = getActiveRule();
        Date fulfillmentDate = request.getFulfillmentDate() == null ? new Date() : request.getFulfillmentDate();
        order.setStartDate(fulfillmentDate);
        order.setDueDate(addDays(fulfillmentDate, safePositive(rule.getMaxLoanDays(), 30)));
        order.setOrderStatus(LibraryConstants.ORDER_BORROWING);
        order.setUpdateTime(new Date());
        if (LibraryConstants.BORROW_LIBRARY_SHIP.equals(order.getBorrowType())) {
            order.setLibraryShipDate(fulfillmentDate);
            updateOutboundDelivery(order, request, fulfillmentDate);
            increaseOutboundCount(order.getReaderId(), rule);
        } else {
            order.setPickupDate(fulfillmentDate);
        }
        orderMapper.updateById(order);
        return resultMap("fulfillmentResult", "BORROWING", "order", order);
    }

    @Override
    @Transactional
    public Map<String, Object> requestReturn(LibraryDto.ReturnRequest request) {
        LibraryBorrowOrder order = requiredOrder(request.getOrderId());
        if (!LibraryConstants.ORDER_BORROWING.equals(order.getOrderStatus())) {
            throw new ServiceException("只有借阅中的订单可以发起还书");
        }
        LibraryRule rule = getActiveRule();
        Date now = new Date();
        order.setReturnType(request.getReturnType());
        order.setOrderStatus(LibraryConstants.ORDER_RETURNING);
        order.setRemark(appendRemark(order.getRemark(), request.getRemark()));
        order.setUpdateTime(now);
        if (LibraryConstants.RETURN_USER_SHIP.equals(request.getReturnType())) {
            Date userShipBackDate = request.getUserShipBackDate() == null ? now : request.getUserShipBackDate();
            validateInboundCount(order.getReaderId(), rule);
            order.setUserShipBackDate(userShipBackDate);
            createReturnDelivery(order, request, userShipBackDate);
            increaseInboundCount(order.getReaderId());
        } else if (!LibraryConstants.RETURN_LIBRARY.equals(request.getReturnType())) {
            throw new ServiceException("还书方式只能是到馆归还或用户寄回");
        }
        orderMapper.updateById(order);
        return resultMap("returnResult", "RETURNING", "order", order);
    }

    @Override
    @Transactional
    public Map<String, Object> confirmReturn(LibraryDto.ReturnConfirmRequest request) {
        LibraryBorrowOrder order = requiredOrder(request.getOrderId());
        if (!LibraryConstants.ORDER_RETURNING.equals(order.getOrderStatus())) {
            throw new ServiceException("只有还书处理中的订单可以确认归还");
        }
        LibraryRule rule = getActiveRule();
        Date receiveDate = request.getLibraryReceiveDate() == null ? new Date() : request.getLibraryReceiveDate();
        String damageStatus = StringUtils.defaultIfBlank(request.getDamageStatus(), LibraryConstants.DAMAGE_NORMAL);

        Date returnDeadlineBasis = LibraryConstants.RETURN_USER_SHIP.equals(order.getReturnType())
                ? order.getUserShipBackDate()
                : receiveDate;
        boolean overdue = returnDeadlineBasis != null && order.getDueDate() != null && returnDeadlineBasis.after(order.getDueDate());
        BigDecimal compensation = calculateCompensation(overdue, order.getDueDate(), returnDeadlineBasis, damageStatus, rule);
        if (request.getCompensationAmount() != null) {
            compensation = request.getCompensationAmount();
        }

        order.setLibraryReceiveDate(receiveDate);
        order.setDamageStatus(damageStatus);
        order.setOverdueFlag(overdue ? 1 : 0);
        order.setCompensationAmount(compensation);
        order.setRemark(appendRemark(order.getRemark(), request.getRemark()));
        order.setUpdateTime(new Date());

        if (canRestoreStock(damageStatus)) {
            restoreAvailableBook(order.getBookId());
        }
        boolean paid = compensation.compareTo(BigDecimal.ZERO) <= 0 || deductDeposit(order, compensation);
        order.setOrderStatus(paid ? LibraryConstants.ORDER_RETURNED : LibraryConstants.ORDER_COMPENSATION_PENDING);
        orderMapper.updateById(order);
        updateReturnDelivery(order, receiveDate);
        autoCreateOrdersFromQueue(order.getBookId());
        return resultMap("returnResult", paid ? "RETURNED" : "COMPENSATION_PENDING", "order", order);
    }

    @Override
    @Transactional
    public Map<String, Object> payCompensation(LibraryDto.CompensationPayRequest request) {
        LibraryBorrowOrder order = requiredOrder(request.getOrderId());
        if (!LibraryConstants.ORDER_COMPENSATION_PENDING.equals(order.getOrderStatus())) {
            throw new ServiceException("只有待赔偿订单可以付款");
        }
        if (!LibraryConstants.PAY_METHOD_DEPOSIT.equals(request.getPayMethod())) {
            throw new ServiceException("当前仅支持使用押金赔偿");
        }
        BigDecimal amount = money(order.getCompensationAmount());
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            order.setOrderStatus(LibraryConstants.ORDER_RETURNED);
            order.setUpdateTime(new Date());
            orderMapper.updateById(order);
            return resultMap("payResult", "RETURNED", "order", order);
        }
        LibraryReader reader = requiredReader(order.getReaderId());
        BigDecimal balance = money(reader.getDepositBalance());
        if (balance.compareTo(amount) < 0) {
            BigDecimal gap = amount.subtract(balance).setScale(2, RoundingMode.HALF_UP);
            throw new ServiceException("押金余额不足以支付赔偿金额，请先充值押金补差价：" + gap + " 元");
        }
        BigDecimal balanceAfter = balance.subtract(amount).setScale(2, RoundingMode.HALF_UP);
        reader.setDepositBalance(balanceAfter);
        reader.setUpdateTime(new Date());
        readerMapper.updateById(reader);

        markUnpaidCompensationFeesPaid(order.getOrderId(), balanceAfter);
        insertFee(reader.getReaderId(), order.getOrderId(), LibraryConstants.FEE_COMPENSATION, amount,
                balanceAfter, LibraryConstants.PAY_PAID, LibraryConstants.PAY_METHOD_DEPOSIT,
                StringUtils.defaultIfBlank(request.getRemark(), "读者使用押金支付赔偿"));

        order.setOrderStatus(LibraryConstants.ORDER_RETURNED);
        order.setUpdateTime(new Date());
        orderMapper.updateById(order);
        return resultMap("payResult", "RETURNED", "order", order, "depositBalance", balanceAfter);
    }

    @Override
    @Transactional
    public void payFee(LibraryDto.FeeRequest request) {
        LibraryReader reader = requiredReader(request.getReaderId());
        Date now = new Date();
        BigDecimal amount = money(request.getAmount());
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new ServiceException("缴费金额必须大于 0");
        }
        if (LibraryConstants.FEE_ANNUAL.equals(request.getFeeType())) {
            reader.setAnnualExpireDate(addDays(now, 365));
        } else if (LibraryConstants.FEE_DEPOSIT_RECHARGE.equals(request.getFeeType())) {
            reader.setDepositBalance(money(reader.getDepositBalance()).add(amount));
        } else {
            throw new ServiceException("费用类型只支持年费缴纳或押金充值");
        }
        reader.setUpdateTime(now);
        readerMapper.updateById(reader);
        insertFee(reader.getReaderId(), request.getOrderId(), request.getFeeType(), amount,
                reader.getDepositBalance(), LibraryConstants.PAY_PAID, request.getPayMethod(), request.getRemark());
    }

    @Override
    @Transactional(readOnly = true)
    public List<LibraryDeliveryRecord> getReaderDeliveries(Long readerId) {
        requiredReader(readerId);
        return deliveryMapper.selectList(new LambdaQueryWrapper<LibraryDeliveryRecord>()
                .eq(LibraryDeliveryRecord::getReaderId, readerId)
                .orderByDesc(LibraryDeliveryRecord::getUpdateTime));
    }

    @Override
    @Transactional(readOnly = true)
    public List<LibraryDeliveryRecord> getOrderDeliveries(Long orderId) {
        requiredOrder(orderId);
        return deliveryMapper.selectList(new LambdaQueryWrapper<LibraryDeliveryRecord>()
                .eq(LibraryDeliveryRecord::getOrderId, orderId)
                .orderByDesc(LibraryDeliveryRecord::getUpdateTime));
    }

    @Override
    @Transactional(readOnly = true)
    public List<LibraryFeeRecord> getReaderFees(Long readerId) {
        requiredReader(readerId);
        return feeMapper.selectList(new LambdaQueryWrapper<LibraryFeeRecord>()
                .eq(LibraryFeeRecord::getReaderId, readerId)
                .orderByDesc(LibraryFeeRecord::getUpdateTime));
    }

    @Override
    @Transactional
    public LibraryRule getActiveRule() {
        LibraryRule rule = ruleMapper.selectOne(new LambdaQueryWrapper<LibraryRule>()
                .eq(LibraryRule::getStatus, LibraryConstants.ENABLED)
                .orderByDesc(LibraryRule::getRuleId)
                .last("limit 1"));
        if (rule != null) {
            return rule;
        }
        Date now = new Date();
        rule = new LibraryRule();
        rule.setLibraryCity("本市");
        rule.setAnnualFee(new BigDecimal("199.00"));
        rule.setDepositAmount(new BigDecimal("300.00"));
        rule.setMaxLoanDays(30);
        rule.setAnnualOutboundLimit(12);
        rule.setAnnualInboundLimit(12);
        rule.setMaxBorrowCount(5);
        rule.setOverdueFeePerDay(new BigDecimal("1.00"));
        rule.setDamageFee(new BigDecimal("50.00"));
        rule.setLostFee(new BigDecimal("100.00"));
        rule.setStatus(LibraryConstants.ENABLED);
        rule.setCreateTime(now);
        rule.setUpdateTime(now);
        ruleMapper.insert(rule);
        return rule;
    }

    @Override
    @Transactional
    public void saveRule(LibraryDto.RuleSave request) {
        Date now = new Date();
        LibraryRule rule = new LibraryRule();
        BeanUtils.copyProperties(request, rule);
        if (rule.getStatus() == null) {
            rule.setStatus(LibraryConstants.ENABLED);
        }
        if (rule.getMaxLoanDays() == null || rule.getMaxLoanDays() <= 0) {
            rule.setMaxLoanDays(30);
        }
        rule.setUpdateTime(now);
        if (rule.getRuleId() == null) {
            rule.setCreateTime(now);
            ruleMapper.insert(rule);
        } else {
            ruleMapper.updateById(rule);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> readerSummary(Long readerId) {
        LibraryReader reader = requiredReader(readerId);
        Long activeOrders = orderMapper.selectCount(new LambdaQueryWrapper<LibraryBorrowOrder>()
                .eq(LibraryBorrowOrder::getReaderId, readerId)
                .in(LibraryBorrowOrder::getOrderStatus,
                        LibraryConstants.ORDER_WAIT_PICKUP,
                        LibraryConstants.ORDER_WAIT_SHIP,
                        LibraryConstants.ORDER_BORROWING,
                        LibraryConstants.ORDER_RETURNING));
        Long waitingQueues = queueMapper.selectCount(new LambdaQueryWrapper<LibraryQueueRecord>()
                .eq(LibraryQueueRecord::getReaderId, readerId)
                .eq(LibraryQueueRecord::getQueueStatus, LibraryConstants.QUEUE_WAITING));
        // 统计历史订单数
        Long totalOrders = orderMapper.selectCount(new LambdaQueryWrapper<LibraryBorrowOrder>()
                .eq(LibraryBorrowOrder::getReaderId, readerId));
        Long returnedOrders = orderMapper.selectCount(new LambdaQueryWrapper<LibraryBorrowOrder>()
                .eq(LibraryBorrowOrder::getReaderId, readerId)
                .eq(LibraryBorrowOrder::getOrderStatus, LibraryConstants.ORDER_RETURNED));
        return resultMap(
                "readerName", reader.getReaderName(),
                "mobile", reader.getMobile(),
                "city", reader.getCity(),
                "status", effectiveReaderStatus(reader),
                "depositBalance", reader.getDepositBalance(),
                "annualExpireDate", reader.getAnnualExpireDate(),
                "maxBorrowCount", reader.getMaxBorrowCount(),
                "maxOutboundCount", reader.getMaxOutboundCount(),
                "usedOutboundCount", reader.getUsedOutboundCount(),
                "maxInboundCount", reader.getMaxInboundCount(),
                "usedInboundCount", reader.getUsedInboundCount(),
                "activeOrders", activeOrders,
                "waitingQueues", waitingQueues,
                "totalOrders", totalOrders,
                "returnedOrders", returnedOrders);
    }

    private LibraryReader validateBorrowQualification(Long readerId, LibraryRule rule) {
        LibraryReader reader = requiredReader(readerId);
        if (!LibraryConstants.NORMAL.equals(reader.getStatus()) && !LibraryConstants.ENABLED.equals(reader.getStatus())) {
            throw new ServiceException("读者状态不可借阅");
        }
        if (hasUnpaidCompensation(readerId)) {
            throw new ServiceException("存在待支付赔偿订单，暂不能新借");
        }
        Date now = new Date();
        if (reader.getAnnualExpireDate() == null || reader.getAnnualExpireDate().before(now)) {
            throw new ServiceException("年费服务未开通或已过期");
        }
        if (money(reader.getDepositBalance()).compareTo(MIN_BORROW_DEPOSIT) < 0) {
            throw new ServiceException("押金余额不足，借书前押金需至少 199 元");
        }
        int limit = safePositive(reader.getMaxBorrowCount(), safePositive(rule.getMaxBorrowCount(), 5));
        Long activeOrders = orderMapper.selectCount(new LambdaQueryWrapper<LibraryBorrowOrder>()
                .eq(LibraryBorrowOrder::getReaderId, readerId)
                .in(LibraryBorrowOrder::getOrderStatus,
                        LibraryConstants.ORDER_WAIT_PICKUP,
                        LibraryConstants.ORDER_WAIT_SHIP,
                        LibraryConstants.ORDER_BORROWING,
                        LibraryConstants.ORDER_RETURNING));
        if (activeOrders != null && activeOrders >= limit) {
            throw new ServiceException("已达到最大可借数量");
        }
        return reader;
    }

    private String validateBorrowType(LibraryReader reader, LibraryRule rule, String borrowType,
                                       Long addressId, String receiverAddress) {
        if (LibraryConstants.BORROW_SELF_PICKUP.equals(borrowType)) {
            return null;
        }
        if (!LibraryConstants.BORROW_LIBRARY_SHIP.equals(borrowType)) {
            throw new ServiceException("借阅方式只能是到馆自取或图书馆同城邮寄");
        }
        int outboundLimit = safePositive(reader.getMaxOutboundCount(), safePositive(rule.getAnnualOutboundLimit(), 12));
        if (safeInt(reader.getUsedOutboundCount()) >= outboundLimit) {
            throw new ServiceException("本年度图书馆寄出次数已达上限");
        }
        // 优先使用自由文本地址，否则查询地址库
        if (StringUtils.isNotBlank(receiverAddress)) {
            return receiverAddress.trim();
        }
        LibraryAddress address = requiredAddress(addressId == null ? reader.getDefaultAddressId() : addressId);
        if (!Objects.equals(reader.getReaderId(), address.getReaderId())) {
            throw new ServiceException("邮寄地址不属于当前读者");
        }
        if (!StringUtils.equalsIgnoreCase(StringUtils.trim(rule.getLibraryCity()), StringUtils.trim(address.getCity()))) {
            throw new ServiceException("邮寄地址必须在图书馆所处城市内");
        }
        return formatAddress(address);
    }

    private void validateAddressCity(String city) {
        LibraryRule rule = getActiveRule();
        if (!StringUtils.equalsIgnoreCase(StringUtils.trim(rule.getLibraryCity()), StringUtils.trim(city))) {
            throw new ServiceException("收货地址必须位于图书馆所在城市：" + rule.getLibraryCity());
        }
    }

    private void validateInboundCount(Long readerId, LibraryRule rule) {
        LibraryReader reader = requiredReader(readerId);
        int inboundLimit = safePositive(reader.getMaxInboundCount(), safePositive(rule.getAnnualInboundLimit(), 12));
        if (safeInt(reader.getUsedInboundCount()) >= inboundLimit) {
            throw new ServiceException("本年度寄回图书馆次数已达上限");
        }
    }

    private LibraryBorrowOrder createWaitingOrder(LibraryReader reader, LibraryBook book, String borrowType, String remark) {
        Date now = new Date();
        LibraryBorrowOrder order = new LibraryBorrowOrder();
        order.setOrderNo(nextNo("B"));
        order.setReaderId(reader.getReaderId());
        order.setBookId(book.getBookId());
        order.setBorrowType(borrowType);
        order.setOrderStatus(LibraryConstants.BORROW_LIBRARY_SHIP.equals(borrowType)
                ? LibraryConstants.ORDER_WAIT_SHIP
                : LibraryConstants.ORDER_WAIT_PICKUP);
        order.setDamageStatus(LibraryConstants.DAMAGE_NORMAL);
        order.setOverdueFlag(0);
        order.setCompensationAmount(BigDecimal.ZERO);
        order.setRemark(remark);
        order.setCreateTime(now);
        order.setUpdateTime(now);
        orderMapper.insert(order);
        return order;
    }

    private void autoCreateOrdersFromQueue(Long bookId) {
        LibraryBook book = requiredBook(bookId);
        LibraryRule rule = getActiveRule();
        while (safeInt(book.getAvailableCount()) > 0) {
            LibraryQueueRecord queue = queueMapper.selectOne(new LambdaQueryWrapper<LibraryQueueRecord>()
                    .eq(LibraryQueueRecord::getBookId, bookId)
                    .eq(LibraryQueueRecord::getQueueStatus, LibraryConstants.QUEUE_WAITING)
                    .orderByAsc(LibraryQueueRecord::getQueuePosition)
                    .orderByAsc(LibraryQueueRecord::getCreateTime)
                    .last("limit 1"));
            if (queue == null) {
                updateBookQueueCount(bookId);
                return;
            }
            try {
                LibraryReader reader = validateBorrowQualification(queue.getReaderId(), rule);
                String addr = validateBorrowType(reader, rule, queue.getBorrowType(),
                        queue.getAddressId(), null);
                LibraryBorrowOrder order = createWaitingOrder(reader, book, queue.getBorrowType(), "排队轮候自动生成借阅订单");
                reduceAvailableBook(book);
                if (LibraryConstants.BORROW_LIBRARY_SHIP.equals(queue.getBorrowType())) {
                    createOutboundDelivery(order, null, null, null, null, addr);
                }
                queue.setConvertedOrderId(order.getOrderId());
                queue.setQueueStatus(LibraryConstants.QUEUE_CONVERTED);
                queue.setUpdateTime(new Date());
                queueMapper.updateById(queue);
                book = requiredBook(bookId);
            } catch (ServiceException ex) {
                queue.setQueueStatus(LibraryConstants.QUEUE_EXCEPTION);
                queue.setRemark(appendRemark(queue.getRemark(), ex.getMessage()));
                queue.setUpdateTime(new Date());
                queueMapper.updateById(queue);
            }
        }
        updateBookQueueCount(bookId);
    }

    private Date estimateAvailableDate(Long bookId, int position, LibraryRule rule) {
        int maxLoanDays = safePositive(rule.getMaxLoanDays(), 30);
        List<LibraryBorrowOrder> activeOrders = orderMapper.selectList(new LambdaQueryWrapper<LibraryBorrowOrder>()
                .eq(LibraryBorrowOrder::getBookId, bookId)
                .in(LibraryBorrowOrder::getOrderStatus,
                        LibraryConstants.ORDER_WAIT_PICKUP,
                        LibraryConstants.ORDER_WAIT_SHIP,
                        LibraryConstants.ORDER_BORROWING,
                        LibraryConstants.ORDER_RETURNING));
        Date latest = new Date();
        for (LibraryBorrowOrder order : activeOrders) {
            Date candidate = order.getDueDate();
            if (candidate == null) {
                candidate = addDays(order.getCreateTime() == null ? new Date() : order.getCreateTime(), maxLoanDays);
            }
            if (candidate.after(latest)) {
                latest = candidate;
            }
        }
        return addDays(latest, maxLoanDays * Math.max(position - 1, 0));
    }

    private BigDecimal calculateCompensation(boolean overdue, Date dueDate, Date returnDate, String damageStatus, LibraryRule rule) {
        BigDecimal amount = BigDecimal.ZERO;
        if (overdue && dueDate != null && returnDate != null) {
            long days = Math.max(1L, (returnDate.getTime() - dueDate.getTime()) / (24L * 60L * 60L * 1000L));
            amount = amount.add(money(rule.getOverdueFeePerDay()).multiply(BigDecimal.valueOf(days)));
        }
        if (LibraryConstants.DAMAGE_DAMAGED.equals(damageStatus)) {
            amount = amount.add(money(rule.getDamageFee()));
        }
        if (LibraryConstants.DAMAGE_LOST.equals(damageStatus)) {
            amount = amount.add(money(rule.getLostFee()));
        }
        return amount.setScale(2, RoundingMode.HALF_UP);
    }

    private boolean deductDeposit(LibraryBorrowOrder order, BigDecimal compensation) {
        LibraryReader reader = requiredReader(order.getReaderId());
        BigDecimal balance = money(reader.getDepositBalance());
        if (balance.compareTo(compensation) < 0) {
            insertFee(reader.getReaderId(), order.getOrderId(), LibraryConstants.FEE_COMPENSATION, compensation,
                    balance, LibraryConstants.PAY_UNPAID, LibraryConstants.PAY_METHOD_DEPOSIT, "押金不足，待读者充值后补缴");
            return false;
        }
        BigDecimal balanceAfter = balance.subtract(compensation);
        reader.setDepositBalance(balanceAfter);
        reader.setUpdateTime(new Date());
        readerMapper.updateById(reader);
        insertFee(reader.getReaderId(), order.getOrderId(), LibraryConstants.FEE_COMPENSATION, compensation,
                balanceAfter, LibraryConstants.PAY_PAID, LibraryConstants.PAY_METHOD_DEPOSIT, "异常费用已从押金扣除");
        return true;
    }

    private void markUnpaidCompensationFeesPaid(Long orderId, BigDecimal balanceAfter) {
        List<LibraryFeeRecord> fees = feeMapper.selectList(new LambdaQueryWrapper<LibraryFeeRecord>()
                .eq(LibraryFeeRecord::getOrderId, orderId)
                .eq(LibraryFeeRecord::getFeeType, LibraryConstants.FEE_COMPENSATION)
                .eq(LibraryFeeRecord::getPayStatus, LibraryConstants.PAY_UNPAID));
        Date now = new Date();
        for (LibraryFeeRecord fee : fees) {
            fee.setBalanceAfter(money(balanceAfter));
            fee.setPayStatus(LibraryConstants.PAY_PAID);
            fee.setPayMethod(LibraryConstants.PAY_METHOD_DEPOSIT);
            fee.setRemark(appendRemark(fee.getRemark(), "读者已使用押金补缴"));
            fee.setUpdateTime(now);
            feeMapper.updateById(fee);
        }
    }

    private void applyEffectiveReaderStatus(LibraryReader reader) {
        if (reader != null) {
            reader.setStatus(effectiveReaderStatus(reader));
        }
    }

    private String effectiveReaderStatus(LibraryReader reader) {
        if (reader == null) {
            return LibraryConstants.READER_STATUS_DISABLED;
        }
        if (LibraryConstants.NORMAL.equals(reader.getStatus()) && hasUnpaidCompensation(reader.getReaderId())) {
            return LibraryConstants.READER_STATUS_DISABLED;
        }
        return reader.getStatus();
    }

    private boolean hasUnpaidCompensation(Long readerId) {
        if (readerId == null) {
            return false;
        }
        Long count = orderMapper.selectCount(new LambdaQueryWrapper<LibraryBorrowOrder>()
                .eq(LibraryBorrowOrder::getReaderId, readerId)
                .eq(LibraryBorrowOrder::getOrderStatus, LibraryConstants.ORDER_COMPENSATION_PENDING));
        return count != null && count > 0;
    }

    private void insertFee(Long readerId, Long orderId, String feeType, BigDecimal amount, BigDecimal balanceAfter,
                           String payStatus, String payMethod, String remark) {
        Date now = new Date();
        LibraryFeeRecord fee = new LibraryFeeRecord();
        fee.setReaderId(readerId);
        fee.setOrderId(orderId);
        fee.setFeeType(feeType);
        fee.setAmount(money(amount));
        fee.setBalanceAfter(money(balanceAfter));
        fee.setPayStatus(payStatus);
        fee.setPayMethod(payMethod);
        fee.setRemark(remark);
        fee.setCreateTime(now);
        fee.setUpdateTime(now);
        feeMapper.insert(fee);
    }

    private void createOutboundDelivery(LibraryBorrowOrder order, LibraryAddress address, BigDecimal amount,
                                        String trackingNo, String carrierName, String receiverAddress) {
        Date now = new Date();
        LibraryDeliveryRecord delivery = new LibraryDeliveryRecord();
        delivery.setOrderId(order.getOrderId());
        delivery.setReaderId(order.getReaderId());
        delivery.setBookId(order.getBookId());
        delivery.setDeliveryType(LibraryConstants.DELIVERY_LIBRARY_OUT);
        delivery.setAddressId(address == null ? null : address.getAddressId());
        delivery.setReceiverAddress(address == null ? receiverAddress : formatAddress(address));
        delivery.setFreightType(LibraryConstants.FREIGHT_CURRENT_SETTLE);
        delivery.setFeeAmount(money(amount));
        delivery.setTrackingNo(trackingNo);
        delivery.setCarrierName(carrierName);
        delivery.setDeliveryStatus(LibraryConstants.DELIVERY_CREATED);
        delivery.setCreateTime(now);
        delivery.setUpdateTime(now);
        deliveryMapper.insert(delivery);
    }

    private void updateOutboundDelivery(LibraryBorrowOrder order, LibraryDto.FulfillmentRequest request, Date shipDate) {
        LibraryDeliveryRecord delivery = deliveryMapper.selectOne(new LambdaQueryWrapper<LibraryDeliveryRecord>()
                .eq(LibraryDeliveryRecord::getOrderId, order.getOrderId())
                .eq(LibraryDeliveryRecord::getDeliveryType, LibraryConstants.DELIVERY_LIBRARY_OUT)
                .last("limit 1"));
        if (delivery == null) {
            return;
        }
        delivery.setTrackingNo(request.getTrackingNo());
        delivery.setCarrierName(request.getCarrierName());
        delivery.setFeeAmount(money(request.getFreightAmount()));
        delivery.setDeliveryStatus(LibraryConstants.DELIVERY_SHIPPED);
        delivery.setShipDate(shipDate);
        delivery.setUpdateTime(new Date());
        deliveryMapper.updateById(delivery);
    }

    private void createReturnDelivery(LibraryBorrowOrder order, LibraryDto.ReturnRequest request, Date shipDate) {
        Date now = new Date();
        LibraryDeliveryRecord delivery = new LibraryDeliveryRecord();
        delivery.setOrderId(order.getOrderId());
        delivery.setReaderId(order.getReaderId());
        delivery.setBookId(order.getBookId());
        delivery.setDeliveryType(LibraryConstants.DELIVERY_USER_RETURN);
        delivery.setFreightType(LibraryConstants.FREIGHT_COLLECT);
        delivery.setTrackingNo(request.getTrackingNo());
        delivery.setCarrierName(request.getCarrierName());
        delivery.setDeliveryStatus(LibraryConstants.DELIVERY_SHIPPED);
        delivery.setShipDate(shipDate);
        delivery.setCreateTime(now);
        delivery.setUpdateTime(now);
        deliveryMapper.insert(delivery);
    }

    private void updateReturnDelivery(LibraryBorrowOrder order, Date receiveDate) {
        LibraryDeliveryRecord delivery = deliveryMapper.selectOne(new LambdaQueryWrapper<LibraryDeliveryRecord>()
                .eq(LibraryDeliveryRecord::getOrderId, order.getOrderId())
                .eq(LibraryDeliveryRecord::getDeliveryType, LibraryConstants.DELIVERY_USER_RETURN)
                .last("limit 1"));
        if (delivery == null) {
            return;
        }
        delivery.setDeliveryStatus(LibraryConstants.DELIVERY_RECEIVED);
        delivery.setReceiveDate(receiveDate);
        delivery.setUpdateTime(new Date());
        deliveryMapper.updateById(delivery);
    }

    private void reduceAvailableBook(LibraryBook book) {
        if (safeInt(book.getAvailableCount()) <= 0) {
            throw new ServiceException("当前图书无可借库存");
        }
        book.setAvailableCount(book.getAvailableCount() - 1);
        book.setUpdateTime(new Date());
        bookMapper.updateById(book);
    }

    private void restoreAvailableBook(Long bookId) {
        LibraryBook book = requiredBook(bookId);
        int total = safeInt(book.getTotalCount());
        int available = Math.min(total, safeInt(book.getAvailableCount()) + 1);
        book.setAvailableCount(available);
        book.setUpdateTime(new Date());
        bookMapper.updateById(book);
    }

    private void updateBookQueueCount(Long bookId) {
        LibraryBook book = requiredBook(bookId);
        Long waiting = queueMapper.selectCount(new LambdaQueryWrapper<LibraryQueueRecord>()
                .eq(LibraryQueueRecord::getBookId, bookId)
                .eq(LibraryQueueRecord::getQueueStatus, LibraryConstants.QUEUE_WAITING));
        book.setQueueCount(waiting == null ? 0 : waiting.intValue());
        book.setUpdateTime(new Date());
        bookMapper.updateById(book);
    }

    private void increaseOutboundCount(Long readerId, LibraryRule rule) {
        LibraryReader reader = requiredReader(readerId);
        int limit = safePositive(reader.getMaxOutboundCount(), safePositive(rule.getAnnualOutboundLimit(), 12));
        int used = safeInt(reader.getUsedOutboundCount());
        if (used >= limit) {
            throw new ServiceException("本年度图书馆寄出次数已达上限");
        }
        reader.setUsedOutboundCount(used + 1);
        reader.setUpdateTime(new Date());
        readerMapper.updateById(reader);
    }

    private void increaseInboundCount(Long readerId) {
        LibraryReader reader = requiredReader(readerId);
        reader.setUsedInboundCount(safeInt(reader.getUsedInboundCount()) + 1);
        reader.setUpdateTime(new Date());
        readerMapper.updateById(reader);
    }

    private boolean canRestoreStock(String damageStatus) {
        return !LibraryConstants.DAMAGE_DAMAGED.equals(damageStatus)
                && !LibraryConstants.DAMAGE_LOST.equals(damageStatus);
    }

    private void ensureBookEnabled(LibraryBook book) {
        if (!LibraryConstants.ENABLED.equals(book.getStatus()) && !LibraryConstants.NORMAL.equals(book.getStatus())) {
            throw new ServiceException("图书已下架或不可借阅");
        }
    }

    private LibraryBook requiredBook(Long bookId) {
        if (bookId == null) {
            throw new ServiceException("图书ID不能为空");
        }
        LibraryBook book = bookMapper.selectById(bookId);
        if (book == null) {
            throw new ServiceException("图书不存在");
        }
        return book;
    }

    private LibraryBook findBookByIsbn(String isbn) {
        if (StringUtils.isBlank(isbn)) {
            return null;
        }
        return bookMapper.selectOne(new LambdaQueryWrapper<LibraryBook>()
                .eq(LibraryBook::getIsbn, isbn)
                .last("limit 1"));
    }

    private void ensureBookCanStop(Long bookId) {
        Long activeOrders = orderMapper.selectCount(new LambdaQueryWrapper<LibraryBorrowOrder>()
                .eq(LibraryBorrowOrder::getBookId, bookId)
                .in(LibraryBorrowOrder::getOrderStatus,
                        LibraryConstants.ORDER_WAIT_PICKUP,
                        LibraryConstants.ORDER_WAIT_SHIP,
                        LibraryConstants.ORDER_BORROWING,
                        LibraryConstants.ORDER_RETURNING));
        if (activeOrders != null && activeOrders > 0) {
            throw new ServiceException("该图书存在未完成借阅订单，不能删除或下架");
        }
        Long activeQueues = queueMapper.selectCount(new LambdaQueryWrapper<LibraryQueueRecord>()
                .eq(LibraryQueueRecord::getBookId, bookId)
                .in(LibraryQueueRecord::getQueueStatus,
                        LibraryConstants.QUEUE_WAITING,
                        LibraryConstants.QUEUE_EXCEPTION));
        if (activeQueues != null && activeQueues > 0) {
            throw new ServiceException("该图书存在有效排队记录，不能删除或下架");
        }
    }

    private LibraryReader requiredReader(Long readerId) {
        if (readerId == null) {
            throw new ServiceException("读者ID不能为空");
        }
        LibraryReader reader = readerMapper.selectById(readerId);
        if (reader == null) {
            throw new ServiceException("读者不存在");
        }
        return reader;
    }

    private LibraryAddress requiredAddress(Long addressId) {
        if (addressId == null) {
            throw new ServiceException("邮寄地址不能为空");
        }
        LibraryAddress address = addressMapper.selectById(addressId);
        if (address == null) {
            throw new ServiceException("邮寄地址不存在");
        }
        return address;
    }

    private LibraryBorrowOrder requiredOrder(Long orderId) {
        if (orderId == null) {
            throw new ServiceException("订单ID不能为空");
        }
        LibraryBorrowOrder order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new ServiceException("借阅订单不存在");
        }
        return order;
    }

    private LibraryQueueRecord requiredQueue(Long queueId) {
        if (queueId == null) {
            throw new ServiceException("排队ID不能为空");
        }
        LibraryQueueRecord queue = queueMapper.selectById(queueId);
        if (queue == null) {
            throw new ServiceException("排队记录不存在");
        }
        return queue;
    }

    private void bindReaderAccount(LibraryDto.ReaderSave request, LibraryReader reader, Date now) {
        if (reader.getUserId() == null && StringUtils.isBlank(request.getUserName())) {
            return;
        }
        Long readerRoleId = requiredRoleId(READER_ROLE_KEY);
        if (reader.getUserId() == null) {
            reader.setUserId(createReaderUser(request, reader, now, readerRoleId));
            return;
        }
        ensureUserCanBeReader(reader.getUserId());
        ensureUserNotBoundToOtherReader(reader.getUserId(), reader.getReaderId());
        updateReaderUser(request, reader, now, readerRoleId);
    }

    private Long createReaderUser(LibraryDto.ReaderSave request, LibraryReader reader, Date now, Long readerRoleId) {
        if (StringUtils.isBlank(request.getUserName())) {
            throw new ServiceException("读者登录账号不能为空");
        }
        ensureUniqueAccountField("user_name", request.getUserName(), null, "登录账号已存在");
        ensureUniqueAccountField("phonenumber", reader.getMobile(), null, "手机号已被其他账号使用");
        ensureUniqueAccountField("email", request.getEmail(), null, "邮箱已被其他账号使用");
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(
                    "INSERT INTO sys_user (dept_id, user_name, nick_name, user_type, email, phonenumber, sex, avatar, password, status, del_flag, create_by, create_time, remark) " +
                            "VALUES (?, ?, ?, '00', ?, ?, '2', '', ?, ?, '0', 'admin', ?, ?)",
                    Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, DEFAULT_ACCOUNT_DEPT_ID);
            ps.setString(2, request.getUserName());
            ps.setString(3, reader.getReaderName());
            ps.setString(4, StringUtils.defaultString(request.getEmail()));
            ps.setString(5, StringUtils.defaultString(reader.getMobile()));
            ps.setString(6, SecurityUtils.encryptPassword(StringUtils.defaultIfBlank(request.getPassword(), DEFAULT_READER_PASSWORD)));
            ps.setString(7, resolveAccountStatus(request, reader));
            ps.setObject(8, new java.sql.Timestamp(now.getTime()));
            ps.setString(9, "云上图书馆读者账号");
            return ps;
        }, keyHolder);
        Number key = keyHolder.getKey();
        if (key == null) {
            throw new ServiceException("创建读者登录账号失败");
        }
        Long userId = key.longValue();
        jdbcTemplate.update("INSERT INTO sys_user_role (user_id, role_id) VALUES (?, ?)", userId, readerRoleId);
        return userId;
    }

    private void updateReaderUser(LibraryDto.ReaderSave request, LibraryReader reader, Date now, Long readerRoleId) {
        ensureUniqueAccountField("user_name", request.getUserName(), reader.getUserId(), "登录账号已存在");
        ensureUniqueAccountField("phonenumber", reader.getMobile(), reader.getUserId(), "手机号已被其他账号使用");
        ensureUniqueAccountField("email", request.getEmail(), reader.getUserId(), "邮箱已被其他账号使用");
        if (StringUtils.isNotBlank(request.getUserName())) {
            jdbcTemplate.update("UPDATE sys_user SET user_name = ? WHERE user_id = ?", request.getUserName(), reader.getUserId());
        }
        jdbcTemplate.update(
                "UPDATE sys_user SET nick_name = ?, email = ?, phonenumber = ?, status = ?, update_by = 'admin', update_time = ? WHERE user_id = ? AND del_flag = '0'",
                reader.getReaderName(),
                StringUtils.defaultString(request.getEmail()),
                StringUtils.defaultString(reader.getMobile()),
                resolveAccountStatus(request, reader),
                new java.sql.Timestamp(now.getTime()),
                reader.getUserId());
        if (StringUtils.isNotBlank(request.getPassword())) {
            jdbcTemplate.update(
                    "UPDATE sys_user SET password = ?, pwd_update_date = ?, update_time = ? WHERE user_id = ?",
                    SecurityUtils.encryptPassword(request.getPassword()),
                    new java.sql.Timestamp(now.getTime()),
                    new java.sql.Timestamp(now.getTime()),
                    reader.getUserId());
        }
        Long exists = countSql("SELECT COUNT(1) FROM sys_user_role WHERE user_id = ? AND role_id = ?", reader.getUserId(), readerRoleId);
        if (exists == 0) {
            jdbcTemplate.update("INSERT INTO sys_user_role (user_id, role_id) VALUES (?, ?)", reader.getUserId(), readerRoleId);
        }
    }

    private void deleteReaderAccount(Long userId) {
        if (userId == null) {
            return;
        }
        Long readerRoleId = requiredRoleId(READER_ROLE_KEY);
        jdbcTemplate.update("DELETE FROM sys_user_role WHERE user_id = ? AND role_id = ?", userId, readerRoleId);
        Long otherRoles = countSql("SELECT COUNT(1) FROM sys_user_role WHERE user_id = ?", userId);
        if (otherRoles == 0) {
            jdbcTemplate.update("UPDATE sys_user SET del_flag = '2', update_by = 'admin', update_time = sysdate() WHERE user_id = ?", userId);
        }
    }

    private void ensureUserNotBoundToOtherReader(Long userId, Long readerId) {
        Long count = readerId == null
                ? countSql("SELECT COUNT(1) FROM library_reader WHERE user_id = ?", userId)
                : countSql("SELECT COUNT(1) FROM library_reader WHERE user_id = ? AND reader_id <> ?", userId, readerId);
        if (count > 0) {
            throw new ServiceException("该登录账号已绑定其他读者");
        }
    }

    private void ensureUniqueAccountField(String field, String value, Long userId, String message) {
        if (StringUtils.isBlank(value)) {
            return;
        }
        String sql = userId == null
                ? "SELECT COUNT(1) FROM sys_user WHERE " + field + " = ? AND del_flag = '0'"
                : "SELECT COUNT(1) FROM sys_user WHERE " + field + " = ? AND user_id <> ? AND del_flag = '0'";
        Long count = userId == null ? countSql(sql, value) : countSql(sql, value, userId);
        if (count > 0) {
            throw new ServiceException(message);
        }
    }

    private Long requiredRoleId(String roleKey) {
        try {
            return jdbcTemplate.queryForObject(
                    "SELECT role_id FROM sys_role WHERE role_key = ? AND del_flag = '0' LIMIT 1",
                    Long.class,
                    roleKey);
        } catch (EmptyResultDataAccessException ex) {
            throw new ServiceException("缺少读者角色，请先初始化 reader 角色");
        }
    }

    private void ensureUserCanBeReader(Long userId) {
        if (userId == null) {
            return;
        }
        if (hasRole(userId, ADMIN_ROLE_KEY)) {
            throw new ServiceException("管理员账号不能同时作为读者使用");
        }
    }

    private boolean hasRole(Long userId, String roleKey) {
        Long count = countSql(
                "SELECT COUNT(1) FROM sys_user_role ur " +
                "INNER JOIN sys_role r ON ur.role_id = r.role_id " +
                "WHERE ur.user_id = ? AND r.role_key = ? AND r.del_flag = '0'",
                userId,
                roleKey);
        return count > 0;
    }

    private Long countSql(String sql, Object... args) {
        Long count = jdbcTemplate.queryForObject(sql, Long.class, args);
        return count == null ? 0L : count;
    }

    private String resolveAccountStatus(LibraryDto.ReaderSave request, LibraryReader reader) {
        if (StringUtils.isNotBlank(request.getAccountStatus())) {
            return request.getAccountStatus();
        }
        return LibraryConstants.NORMAL.equals(reader.getStatus()) ? "0" : "1";
    }

    private LibraryReader buildDefaultReader(Long userId, String readerName) {
        Date now = new Date();
        LibraryReader reader = new LibraryReader();
        reader.setUserId(userId);
        reader.setReaderName(StringUtils.isNotBlank(readerName) ? readerName : "读者" + userId);
        reader.setStatus(LibraryConstants.NORMAL);
        reader.setDepositBalance(BigDecimal.ZERO);
        reader.setDepositFrozen(BigDecimal.ZERO);
        reader.setUsedOutboundCount(0);
        reader.setUsedInboundCount(0);
        reader.setMaxOutboundCount(6);
        reader.setMaxInboundCount(6);
        reader.setMaxBorrowCount(3);
        reader.setCreateTime(now);
        reader.setUpdateTime(now);
        return reader;
    }

    private Date addDays(Date date, int days) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date == null ? new Date() : date);
        calendar.add(Calendar.DAY_OF_MONTH, days);
        return calendar.getTime();
    }

    private Date parseLibraryDate(String value) {
        if (StringUtils.isBlank(value)) {
            return null;
        }
        String dateValue = value.trim();
        String[] patterns = {
                "yyyy-MM-dd HH:mm:ss",
                "yyyy-MM-dd",
                "yyyy-MM-dd'T'HH:mm:ss.SSSX",
                "yyyy-MM-dd'T'HH:mm:ss.SSSXXX",
                "yyyy-MM-dd'T'HH:mm:ssX",
                "yyyy-MM-dd'T'HH:mm:ssXXX"
        };
        for (String pattern : patterns) {
            try {
                SimpleDateFormat format = new SimpleDateFormat(pattern, Locale.ROOT);
                format.setLenient(false);
                format.setTimeZone(TimeZone.getTimeZone("GMT+8"));
                return format.parse(dateValue);
            } catch (ParseException ignored) {
            }
        }
        throw new ServiceException("日期格式不正确：" + value);
    }

    private String nextNo(String prefix) {
        return prefix + System.currentTimeMillis() + String.format("%04d", new Random().nextInt(10000));
    }

    private String appendRemark(String oldRemark, String newRemark) {
        if (StringUtils.isBlank(newRemark)) {
            return oldRemark;
        }
        if (StringUtils.isBlank(oldRemark)) {
            return newRemark;
        }
        return oldRemark + "；" + newRemark;
    }

    private String formatAddress(LibraryAddress address) {
        return StringUtils.defaultString(address.getCity())
                + StringUtils.defaultString(address.getDistrict())
                + StringUtils.defaultString(address.getDetailAddress())
                + " " + StringUtils.defaultString(address.getReceiverName())
                + " " + StringUtils.defaultString(address.getReceiverMobile());
    }

    private int safeInt(Integer value) {
        return value == null ? 0 : value;
    }

    private int safePositive(Integer value, int defaultValue) {
        return value == null || value <= 0 ? defaultValue : value;
    }

    private BigDecimal money(BigDecimal amount) {
        return amount == null ? BigDecimal.ZERO : amount.setScale(2, RoundingMode.HALF_UP);
    }

    private Map<String, Object> resultMap(Object... kv) {
        Map<String, Object> result = new LinkedHashMap<>();
        for (int i = 0; i + 1 < kv.length; i += 2) {
            result.put(String.valueOf(kv[i]), kv[i + 1]);
        }
        return result;
    }
}

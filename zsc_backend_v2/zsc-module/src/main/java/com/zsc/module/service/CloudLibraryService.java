package com.zsc.module.service;

import com.zsc.module.common.pagination.PageResult;
import com.zsc.module.domain.dto.LibraryDto;
import com.zsc.module.domain.entity.LibraryAddress;
import com.zsc.module.domain.entity.LibraryBook;
import com.zsc.module.domain.entity.LibraryDeliveryRecord;
import com.zsc.module.domain.entity.LibraryFeeRecord;
import com.zsc.module.domain.entity.LibraryReader;
import com.zsc.module.domain.entity.LibraryRule;

import java.util.List;
import java.util.Map;

public interface CloudLibraryService {

    LibraryBook getBook(Long bookId);

    void saveBook(LibraryDto.BookSave request);

    void deleteBook(Long bookId);

    PageResult<LibraryBook> queryBooks(LibraryDto.BookQuery request);

    LibraryReader getReader(Long readerId);

    LibraryReader getOrCreateReader(Long userId, String readerName);

    LibraryReader getReaderByMobile(String mobile);

    int syncReadersFromUsers();

    void saveReader(LibraryDto.ReaderSave request);

    void deleteReader(Long readerId);

    PageResult<LibraryReader> queryReaders(LibraryDto.ReaderQuery request);

    void saveAddress(LibraryDto.AddressSave request);

    LibraryAddress getAddress(Long addressId);

    List<LibraryAddress> getReaderAddresses(Long readerId);

    void deleteAddress(Long addressId);

    Map<String, Object> borrowOnline(LibraryDto.BorrowRequest request);

    Map<String, Object> joinQueue(LibraryDto.QueueRequest request);

    PageResult<?> queryOrders(LibraryDto.OrderQuery request);

    PageResult<?> queryQueues(LibraryDto.QueueQuery request);

    Map<String, Object> dashboard();

    Map<String, Object> handleQueue(LibraryDto.QueueHandleRequest request);

    Map<String, Object> confirmFulfillment(LibraryDto.FulfillmentRequest request);

    Map<String, Object> requestReturn(LibraryDto.ReturnRequest request);

    Map<String, Object> confirmReturn(LibraryDto.ReturnConfirmRequest request);

    Map<String, Object> payCompensation(LibraryDto.CompensationPayRequest request);

    void payFee(LibraryDto.FeeRequest request);

    List<LibraryDeliveryRecord> getReaderDeliveries(Long readerId);

    List<LibraryDeliveryRecord> getOrderDeliveries(Long orderId);

    List<LibraryFeeRecord> getReaderFees(Long readerId);

    LibraryRule getActiveRule();

    void saveRule(LibraryDto.RuleSave request);

    Map<String, Object> readerSummary(Long readerId);
}

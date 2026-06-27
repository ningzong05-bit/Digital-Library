package com.zsc.module.controller;

import com.zsc.module.common.pagination.PageResult;
import com.zsc.module.common.response.ResultVo;
import com.zsc.module.domain.dto.LibraryDto;
import com.zsc.module.domain.entity.LibraryAddress;
import com.zsc.module.domain.entity.LibraryBook;
import com.zsc.module.domain.entity.LibraryDeliveryRecord;
import com.zsc.module.domain.entity.LibraryFeeRecord;
import com.zsc.module.domain.entity.LibraryReader;
import com.zsc.module.domain.entity.LibraryRule;
import com.zsc.module.service.CloudLibraryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@Tag(name = "Cloud library")
@Validated
@RestController
@RequestMapping("/api/library")
public class CloudLibraryController {

    private final CloudLibraryService cloudLibraryService;

    public CloudLibraryController(CloudLibraryService cloudLibraryService) {
        this.cloudLibraryService = cloudLibraryService;
    }

    @Operation(summary = "Get book")
    @GetMapping("/books/{bookId}")
    public ResultVo<LibraryBook> getBook(@PathVariable Long bookId) {
        return ResultVo.ok(cloudLibraryService.getBook(bookId));
    }

    @Operation(summary = "Save book")
    @PostMapping("/books")
    public ResultVo<?> saveBook(@Valid @RequestBody LibraryDto.BookSave request) {
        cloudLibraryService.saveBook(request);
        return ResultVo.ok();
    }

    @Operation(summary = "Delete book")
    @DeleteMapping("/books/{bookId}")
    public ResultVo<?> deleteBook(@PathVariable Long bookId) {
        cloudLibraryService.deleteBook(bookId);
        return ResultVo.ok();
    }

    @Operation(summary = "Query books")
    @PostMapping("/books/query")
    public ResultVo<PageResult<LibraryBook>> queryBooks(@RequestBody LibraryDto.BookQuery request) {
        return ResultVo.ok(cloudLibraryService.queryBooks(request));
    }

    @Operation(summary = "Library dashboard")
    @GetMapping("/dashboard")
    public ResultVo<Map<String, Object>> dashboard() {
        return ResultVo.ok(cloudLibraryService.dashboard());
    }

    @Operation(summary = "Get reader")
    @GetMapping("/readers/{readerId}")
    public ResultVo<LibraryReader> getReader(@PathVariable Long readerId) {
        return ResultVo.ok(cloudLibraryService.getReader(readerId));
    }

    @Operation(summary = "Get or create reader by user")
    @GetMapping("/readers/by-user/{userId}")
    public ResultVo<LibraryReader> getOrCreateReader(@PathVariable Long userId,
                                                     @RequestParam(required = false) String readerName) {
        return ResultVo.ok(cloudLibraryService.getOrCreateReader(userId, readerName));
    }

    @Operation(summary = "Get reader by mobile")
    @GetMapping("/readers/by-mobile/{mobile}")
    public ResultVo<LibraryReader> getReaderByMobile(@PathVariable String mobile) {
        return ResultVo.ok(cloudLibraryService.getReaderByMobile(mobile));
    }

    @Operation(summary = "Sync reader users")
    @PostMapping("/readers/sync")
    public ResultVo<Map<String, Object>> syncReaders() {
        int created = cloudLibraryService.syncReadersFromUsers();
        return ResultVo.ok(Map.of("created", created));
    }

    @Operation(summary = "Save reader")
    @PostMapping("/readers")
    public ResultVo<?> saveReader(@Valid @RequestBody LibraryDto.ReaderSave request) {
        cloudLibraryService.saveReader(request);
        return ResultVo.ok();
    }

    @Operation(summary = "Delete reader")
    @DeleteMapping("/readers/{readerId}")
    public ResultVo<?> deleteReader(@PathVariable Long readerId) {
        cloudLibraryService.deleteReader(readerId);
        return ResultVo.ok();
    }

    @Operation(summary = "Query readers")
    @PostMapping("/readers/query")
    public ResultVo<PageResult<LibraryReader>> queryReaders(@RequestBody LibraryDto.ReaderQuery request) {
        return ResultVo.ok(cloudLibraryService.queryReaders(request));
    }

    @Operation(summary = "Reader summary")
    @GetMapping("/readers/{readerId}/summary")
    public ResultVo<Map<String, Object>> readerSummary(@PathVariable Long readerId) {
        return ResultVo.ok(cloudLibraryService.readerSummary(readerId));
    }

    @Operation(summary = "Save address")
    @PostMapping("/addresses")
    public ResultVo<?> saveAddress(@Valid @RequestBody LibraryDto.AddressSave request) {
        cloudLibraryService.saveAddress(request);
        return ResultVo.ok();
    }

    @Operation(summary = "Get address")
    @GetMapping("/addresses/{addressId}")
    public ResultVo<LibraryAddress> getAddress(@PathVariable Long addressId) {
        return ResultVo.ok(cloudLibraryService.getAddress(addressId));
    }

    @Operation(summary = "Get reader addresses")
    @GetMapping("/addresses/by-reader/{readerId}")
    public ResultVo<List<LibraryAddress>> getReaderAddresses(@PathVariable Long readerId) {
        return ResultVo.ok(cloudLibraryService.getReaderAddresses(readerId));
    }

    @Operation(summary = "Delete address")
    @DeleteMapping("/addresses/{addressId}")
    public ResultVo<?> deleteAddress(@PathVariable Long addressId) {
        cloudLibraryService.deleteAddress(addressId);
        return ResultVo.ok();
    }

    @Operation(summary = "Borrow online")
    @PostMapping("/borrow/online")
    public ResultVo<Map<String, Object>> borrowOnline(@Valid @RequestBody LibraryDto.BorrowRequest request) {
        return ResultVo.ok(cloudLibraryService.borrowOnline(request));
    }

    @Operation(summary = "Join queue")
    @PostMapping("/queues/join")
    public ResultVo<Map<String, Object>> joinQueue(@Valid @RequestBody LibraryDto.QueueRequest request) {
        return ResultVo.ok(cloudLibraryService.joinQueue(request));
    }

    @Operation(summary = "Query queues")
    @PostMapping("/queues/query")
    public ResultVo<PageResult<?>> queryQueues(@RequestBody LibraryDto.QueueQuery request) {
        return ResultVo.ok(cloudLibraryService.queryQueues(request));
    }

    @Operation(summary = "Handle queue")
    @PostMapping("/queues/handle")
    public ResultVo<Map<String, Object>> handleQueue(@Valid @RequestBody LibraryDto.QueueHandleRequest request) {
        return ResultVo.ok(cloudLibraryService.handleQueue(request));
    }

    @Operation(summary = "Query orders")
    @PostMapping("/orders/query")
    public ResultVo<PageResult<?>> queryOrders(@RequestBody LibraryDto.OrderQuery request) {
        return ResultVo.ok(cloudLibraryService.queryOrders(request));
    }

    @Operation(summary = "Confirm pickup or shipment")
    @PostMapping("/orders/confirm-fulfillment")
    public ResultVo<Map<String, Object>> confirmFulfillment(@Valid @RequestBody LibraryDto.FulfillmentRequest request) {
        return ResultVo.ok(cloudLibraryService.confirmFulfillment(request));
    }

    @Operation(summary = "Request return")
    @PostMapping("/orders/request-return")
    public ResultVo<Map<String, Object>> requestReturn(@Valid @RequestBody LibraryDto.ReturnRequest request) {
        return ResultVo.ok(cloudLibraryService.requestReturn(request));
    }

    @Operation(summary = "Confirm returned book")
    @PostMapping("/orders/confirm-return")
    public ResultVo<Map<String, Object>> confirmReturn(@Valid @RequestBody LibraryDto.ReturnConfirmRequest request) {
        return ResultVo.ok(cloudLibraryService.confirmReturn(request));
    }

    @Operation(summary = "Pay pending compensation")
    @PostMapping("/orders/pay-compensation")
    public ResultVo<Map<String, Object>> payCompensation(@Valid @RequestBody LibraryDto.CompensationPayRequest request) {
        return ResultVo.ok(cloudLibraryService.payCompensation(request));
    }

    @Operation(summary = "Pay annual fee or deposit")
    @PostMapping("/fees/pay")
    public ResultVo<?> payFee(@Valid @RequestBody LibraryDto.FeeRequest request) {
        cloudLibraryService.payFee(request);
        return ResultVo.ok();
    }

    @Operation(summary = "Get reader deliveries")
    @GetMapping("/deliveries/by-reader/{readerId}")
    public ResultVo<List<LibraryDeliveryRecord>> getReaderDeliveries(@PathVariable Long readerId) {
        return ResultVo.ok(cloudLibraryService.getReaderDeliveries(readerId));
    }

    @Operation(summary = "Get order deliveries")
    @GetMapping("/deliveries/by-order/{orderId}")
    public ResultVo<List<LibraryDeliveryRecord>> getOrderDeliveries(@PathVariable Long orderId) {
        return ResultVo.ok(cloudLibraryService.getOrderDeliveries(orderId));
    }

    @Operation(summary = "Get reader fees")
    @GetMapping("/fees/by-reader/{readerId}")
    public ResultVo<List<LibraryFeeRecord>> getReaderFees(@PathVariable Long readerId) {
        return ResultVo.ok(cloudLibraryService.getReaderFees(readerId));
    }

    @Operation(summary = "Get active rule")
    @GetMapping("/rules/active")
    public ResultVo<LibraryRule> activeRule() {
        return ResultVo.ok(cloudLibraryService.getActiveRule());
    }

    @Operation(summary = "Save rule")
    @PostMapping("/rules")
    public ResultVo<?> saveRule(@Valid @RequestBody LibraryDto.RuleSave request) {
        cloudLibraryService.saveRule(request);
        return ResultVo.ok();
    }
}

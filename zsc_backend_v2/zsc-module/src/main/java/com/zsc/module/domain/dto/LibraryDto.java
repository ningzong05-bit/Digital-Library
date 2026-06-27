package com.zsc.module.domain.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.zsc.module.common.pagination.BasePageReq;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

public class LibraryDto {

    @Data
    public static class BookQuery extends BasePageReq {
        private String bookName;
        private String isbn;
        private String author;
        private String categoryName;
        private String status;
        private Integer onlyAvailable;
    }

    @Data
    public static class BookSave {
        private Long bookId;
        private String isbn;
        @NotBlank(message = "图书名称不能为空")
        private String bookName;
        private String author;
        private String publisher;
        private String categoryName;
        private String coverUrl;
        private String description;
        private Integer totalCount;
        private Integer availableCount;
        private String status;
    }

    @Data
    public static class ReaderQuery extends BasePageReq {
        private String readerName;
        private String readerContact;
        private String mobile;
        private String city;
        private String status;
    }

    @Data
    public static class ReaderSave {
        private Long readerId;
        private Long userId;
        private String userName;
        private String password;
        private String email;
        private String accountStatus;
        @NotBlank(message = "读者姓名不能为空")
        private String readerName;
        private String mobile;
        private String city;
        private Long defaultAddressId;
        private String annualExpireDate;
        private BigDecimal depositBalance;
        private BigDecimal depositFrozen;
        private Integer usedOutboundCount;
        private Integer usedInboundCount;
        private Integer maxOutboundCount;
        private Integer maxInboundCount;
        private Integer maxBorrowCount;
        private String status;
    }

    @Data
    public static class AddressSave {
        private Long addressId;
        @NotNull(message = "读者ID不能为空")
        private Long readerId;
        @NotBlank(message = "收件人不能为空")
        private String receiverName;
        private String receiverMobile;
        @NotBlank(message = "城市不能为空")
        private String city;
        private String district;
        @NotBlank(message = "详细地址不能为空")
        private String detailAddress;
        private Integer defaultFlag;
        private String status;
    }

    @Data
    public static class OrderQuery extends BasePageReq {
        private Long readerId;
        private String readerContact;
        private Long bookId;
        private String orderNo;
        private String orderStatus;
        private String borrowType;
        private String returnType;
        private Boolean pendingOnly;
    }

    @Data
    public static class QueueQuery extends BasePageReq {
        private Long readerId;
        private String readerContact;
        private Long bookId;
        private String queueStatus;
    }

    @Data
    public static class BorrowRequest {
        @NotNull(message = "读者ID不能为空")
        private Long readerId;
        @NotNull(message = "图书ID不能为空")
        private Long bookId;
        @NotBlank(message = "借阅方式不能为空")
        private String borrowType;
        private Long addressId;
        private String receiverAddress;
        private String remark;
    }

    @Data
    public static class QueueRequest {
        @NotNull(message = "读者ID不能为空")
        private Long readerId;
        @NotNull(message = "图书ID不能为空")
        private Long bookId;
        @NotBlank(message = "借阅方式不能为空")
        private String borrowType;
        private Long addressId;
        private String receiverAddress;
        private String remark;
    }

    @Data
    public static class QueueHandleRequest {
        @NotNull(message = "Queue ID is required")
        private Long queueId;
        @NotBlank(message = "Queue status is required")
        private String queueStatus;
        private String remark;
    }

    @Data
    public static class FulfillmentRequest {
        @NotNull(message = "订单ID不能为空")
        private Long orderId;
        @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
        private Date fulfillmentDate;
        private String trackingNo;
        private String carrierName;
        private BigDecimal freightAmount;
        private String remark;
    }

    @Data
    public static class ReturnRequest {
        @NotNull(message = "订单ID不能为空")
        private Long orderId;
        @NotBlank(message = "还书方式不能为空")
        private String returnType;
        @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
        private Date userShipBackDate;
        private String trackingNo;
        private String carrierName;
        private String remark;
    }

    @Data
    public static class ReturnConfirmRequest {
        @NotNull(message = "订单ID不能为空")
        private Long orderId;
        @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
        private Date libraryReceiveDate;
        private String damageStatus;
        private BigDecimal compensationAmount;
        private String remark;
    }

    @Data
    public static class FeeRequest {
        @NotNull(message = "读者ID不能为空")
        private Long readerId;
        private Long orderId;
        @NotBlank(message = "费用类型不能为空")
        private String feeType;
        @NotNull(message = "金额不能为空")
        private BigDecimal amount;
        private String payMethod;
        private String remark;
    }

    @Data
    public static class CompensationPayRequest {
        @NotNull(message = "订单ID不能为空")
        private Long orderId;
        @NotBlank(message = "支付方式不能为空")
        private String payMethod;
        private String remark;
    }

    @Data
    public static class RuleSave {
        private Long ruleId;
        @NotBlank(message = "图书馆所在城市不能为空")
        private String libraryCity;
        private BigDecimal annualFee;
        private BigDecimal depositAmount;
        private Integer maxLoanDays;
        private Integer annualOutboundLimit;
        private Integer annualInboundLimit;
        private Integer maxBorrowCount;
        private BigDecimal overdueFeePerDay;
        private BigDecimal damageFee;
        private BigDecimal lostFee;
        private String status;
    }
}

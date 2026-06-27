package com.zsc.module.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
@TableName("library_delivery_record")
public class LibraryDeliveryRecord {

    @TableId(value = "delivery_id", type = IdType.AUTO)
    private Long deliveryId;

    @TableField("order_id")
    private Long orderId;

    @TableField("reader_id")
    private Long readerId;

    @TableField("book_id")
    private Long bookId;

    @TableField("delivery_type")
    private String deliveryType;

    @TableField("address_id")
    private Long addressId;

    @TableField("receiver_address")
    private String receiverAddress;

    @TableField("freight_type")
    private String freightType;

    @TableField("fee_amount")
    private BigDecimal feeAmount;

    @TableField("tracking_no")
    private String trackingNo;

    @TableField("carrier_name")
    private String carrierName;

    @TableField("delivery_status")
    private String deliveryStatus;

    @TableField("ship_date")
    private Date shipDate;

    @TableField("receive_date")
    private Date receiveDate;

    @TableField("create_time")
    private Date createTime;

    @TableField("update_time")
    private Date updateTime;
}

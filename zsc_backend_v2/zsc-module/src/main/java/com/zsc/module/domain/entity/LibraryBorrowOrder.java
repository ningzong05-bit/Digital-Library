package com.zsc.module.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
@TableName("library_borrow_order")
public class LibraryBorrowOrder {

    @TableId(value = "order_id", type = IdType.AUTO)
    private Long orderId;

    @TableField("order_no")
    private String orderNo;

    @TableField("reader_id")
    private Long readerId;

    @TableField(exist = false)
    private String readerName;

    @TableField(exist = false)
    private String readerContact;

    @TableField("book_id")
    private Long bookId;

    @TableField(exist = false)
    private String bookName;

    @TableField("borrow_type")
    private String borrowType;

    @TableField("return_type")
    private String returnType;

    @TableField("order_status")
    private String orderStatus;

    @TableField("start_date")
    private Date startDate;

    @TableField("due_date")
    private Date dueDate;

    @TableField("library_ship_date")
    private Date libraryShipDate;

    @TableField("pickup_date")
    private Date pickupDate;

    @TableField("user_ship_back_date")
    private Date userShipBackDate;

    @TableField("library_receive_date")
    private Date libraryReceiveDate;

    @TableField("damage_status")
    private String damageStatus;

    @TableField("overdue_flag")
    private Integer overdueFlag;

    @TableField("compensation_amount")
    private BigDecimal compensationAmount;

    @TableField("remark")
    private String remark;

    @TableField("create_time")
    private Date createTime;

    @TableField("update_time")
    private Date updateTime;
}

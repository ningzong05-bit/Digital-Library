package com.zsc.module.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
@TableName("library_fee_record")
public class LibraryFeeRecord {

    @TableId(value = "fee_id", type = IdType.AUTO)
    private Long feeId;

    @TableField("reader_id")
    private Long readerId;

    @TableField("order_id")
    private Long orderId;

    @TableField("fee_type")
    private String feeType;

    @TableField("amount")
    private BigDecimal amount;

    @TableField("balance_after")
    private BigDecimal balanceAfter;

    @TableField("pay_status")
    private String payStatus;

    @TableField("pay_method")
    private String payMethod;

    @TableField("remark")
    private String remark;

    @TableField("create_time")
    private Date createTime;

    @TableField("update_time")
    private Date updateTime;
}

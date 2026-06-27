package com.zsc.module.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
@TableName("library_rule")
public class LibraryRule {

    @TableId(value = "rule_id", type = IdType.AUTO)
    private Long ruleId;

    @TableField("library_city")
    private String libraryCity;

    @TableField("annual_fee")
    private BigDecimal annualFee;

    @TableField("deposit_amount")
    private BigDecimal depositAmount;

    @TableField("max_loan_days")
    private Integer maxLoanDays;

    @TableField("annual_outbound_limit")
    private Integer annualOutboundLimit;

    @TableField("annual_inbound_limit")
    private Integer annualInboundLimit;

    @TableField("max_borrow_count")
    private Integer maxBorrowCount;

    @TableField("overdue_fee_per_day")
    private BigDecimal overdueFeePerDay;

    @TableField("damage_fee")
    private BigDecimal damageFee;

    @TableField("lost_fee")
    private BigDecimal lostFee;

    @TableField("status")
    private String status;

    @TableField("create_time")
    private Date createTime;

    @TableField("update_time")
    private Date updateTime;
}

package com.zsc.module.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
@TableName("library_reader")
public class LibraryReader {

    @TableId(value = "reader_id", type = IdType.AUTO)
    private Long readerId;

    @TableField("user_id")
    private Long userId;

    @TableField("reader_name")
    private String readerName;

    @TableField("mobile")
    private String mobile;

    @TableField("city")
    private String city;

    @TableField("default_address_id")
    private Long defaultAddressId;

    @TableField("annual_expire_date")
    private Date annualExpireDate;

    @TableField("deposit_balance")
    private BigDecimal depositBalance;

    @TableField("deposit_frozen")
    private BigDecimal depositFrozen;

    @TableField("used_outbound_count")
    private Integer usedOutboundCount;

    @TableField("used_inbound_count")
    private Integer usedInboundCount;

    @TableField("max_outbound_count")
    private Integer maxOutboundCount;

    @TableField("max_inbound_count")
    private Integer maxInboundCount;

    @TableField("max_borrow_count")
    private Integer maxBorrowCount;

    @TableField("status")
    private String status;

    @TableField("create_time")
    private Date createTime;

    @TableField("update_time")
    private Date updateTime;
}

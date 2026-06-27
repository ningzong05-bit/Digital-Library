package com.zsc.module.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

@Data
@TableName("library_address")
public class LibraryAddress {

    @TableId(value = "address_id", type = IdType.AUTO)
    private Long addressId;

    @TableField("reader_id")
    private Long readerId;

    @TableField("receiver_name")
    private String receiverName;

    @TableField("receiver_mobile")
    private String receiverMobile;

    @TableField("city")
    private String city;

    @TableField("district")
    private String district;

    @TableField("detail_address")
    private String detailAddress;

    @TableField("default_flag")
    private Integer defaultFlag;

    @TableField("status")
    private String status;

    @TableField("create_time")
    private Date createTime;

    @TableField("update_time")
    private Date updateTime;
}

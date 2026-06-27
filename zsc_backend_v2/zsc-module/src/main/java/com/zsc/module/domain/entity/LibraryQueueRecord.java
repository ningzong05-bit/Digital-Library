package com.zsc.module.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

@Data
@TableName("library_queue_record")
public class LibraryQueueRecord {

    @TableId(value = "queue_id", type = IdType.AUTO)
    private Long queueId;

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

    @TableField("queue_no")
    private String queueNo;

    @TableField("queue_position")
    private Integer queuePosition;

    @TableField("borrow_type")
    private String borrowType;

    @TableField("address_id")
    private Long addressId;

    @TableField("estimated_available_date")
    private Date estimatedAvailableDate;

    @TableField("queue_status")
    private String queueStatus;

    @TableField("converted_order_id")
    private Long convertedOrderId;

    @TableField("remark")
    private String remark;

    @TableField("create_time")
    private Date createTime;

    @TableField("update_time")
    private Date updateTime;
}

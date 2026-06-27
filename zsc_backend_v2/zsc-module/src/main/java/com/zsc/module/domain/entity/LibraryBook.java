package com.zsc.module.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

@Data
@TableName("library_book")
public class LibraryBook {

    @TableId(value = "book_id", type = IdType.AUTO)
    private Long bookId;

    @TableField("isbn")
    private String isbn;

    @TableField("book_name")
    private String bookName;

    @TableField("author")
    private String author;

    @TableField("publisher")
    private String publisher;

    @TableField("category_name")
    private String categoryName;

    @TableField("cover_url")
    private String coverUrl;

    @TableField("description")
    private String description;

    @TableField("total_count")
    private Integer totalCount;

    @TableField("available_count")
    private Integer availableCount;

    @TableField("queue_count")
    private Integer queueCount;

    @TableField("status")
    private String status;

    @TableField("create_time")
    private Date createTime;

    @TableField("update_time")
    private Date updateTime;
}

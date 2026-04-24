package com.test.jesiyo.directsale.dto;

import java.sql.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Alias("DirectSaleDto")
@Data
public class DirectSaleDto {
	private Long seq;
	private String name;
	private String description;
	private String status;
	private String productName;
	private String imageUrl;
	private Long price;
	private Date createdAt;
	private Long sellerSeq;
	private Long categorySeq;
	private Long tradeLocationSeq;
	
	// 목록 조회용 정보
	private String dong;
    private Double lat;
    private Double lng;
    private String sellerName;
    private String timeAgo;
}

package com.test.jesiyo.directsale.dto;

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
	private String createdAt;
	private Long sellerSeq;
	private Long categorySeq;
	private Long tradeLocationSeq;
}

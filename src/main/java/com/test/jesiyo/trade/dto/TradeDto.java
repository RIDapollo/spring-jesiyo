package com.test.jesiyo.trade.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class TradeDto {
	private Long seq;
	private String status;
	private Date createdAt;
	private Date completedAt;
	private Long directSaleSeq;
	private Long buyerSeq;
	private Long sellerSeq;
	
	// 목록 조회시 필요한 정보
	private String name;
	private String productName;
	private String buyerNickname;
	private String sellerNickname;
}

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
}

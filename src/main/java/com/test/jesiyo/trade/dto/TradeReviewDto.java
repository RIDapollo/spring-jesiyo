package com.test.jesiyo.trade.dto;

import lombok.Data;

@Data
public class TradeReviewDto {
	private Long seq;
	private Long tradeSeq;
	private Long sellerSeq;
	private Long buyerSeq;
	private Double score;
}

package com.test.jesiyo.auction.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BidDto {

	private int seq;
	private int bidPrice;
	private String bidTime;
	private int status;
	
	private int memberSeq;
	private int auctionSeq;
	
	private String userId;
}

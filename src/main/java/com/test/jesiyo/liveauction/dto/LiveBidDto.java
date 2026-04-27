package com.test.jesiyo.liveauction.dto;

import lombok.Data;

@Data
public class LiveBidDto {

	private int seq;
	private int bidPrice;
	private String bidTime;
	private int status;
	
	private int memberSeq;
	private int liveAuctionSeq;
	
	private String userId;
}

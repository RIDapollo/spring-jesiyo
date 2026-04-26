package com.test.jesiyo.liveauction.dto;

import lombok.Data;

@Data
public class LiveAuctionDto {

	private int seq;
	private String name;
	private int bidOpenPrice; 
	private String image;
	private String description;
	private String createdAt;
	private int status;
	
	private int winnerSeq;
	private int createMemberSeq;
	private int categorySeq;
	
	private int highestBid;
	
	private int auctionSeq;    
    private String sellerId; 
    private int myBidPrice; 
    private String categoryName;
    private int bidSeq;
}

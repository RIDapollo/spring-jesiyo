package com.test.jesiyo.liveauction.dto;

import lombok.Data;

@Data
public class LiveAuctionDto {

	private int seq;
	private String name;
	private Long bidOpenPrice; 
	private String image;
	private String description;
	private String createdAt;
	private int status;
	
	private int winnerSeq;
	private int createMemberSeq;
	private int categorySeq;
	
	private Long highestBid;
	
	private int auctionSeq;    
    private String sellerId; 
    private Long myBidPrice; 
    private String categoryName;
    private int bidSeq;
    
    private int highestBidMemberSeq;   // 최고 입찰자 번호
    private String highestBidUserId;
}

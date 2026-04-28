package com.test.jesiyo.auction.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AuctionDto {

	private int seq;
	private String name;
	private long bidOpenPrice; 
	private String image;
	private String endDate;
	private String description;
	private String createdAt;
	private int status;
	
	private int winnerSeq;
	private int createMemberSeq;
	private int categorySeq;
	
	private long highestBid;
	
	private int auctionSeq;    // a.seq as auctionSeq 와 매핑
    private String sellerName; // m.id as sellerName 와 매핑
    private long myBidPrice;    // 내가 입찰한 금액과 매핑
    private String categoryName;
    private int bidSeq;
    
    private int highestBidMemberSeq;   // 최고 입찰자 번호
    private String highestBidUserId;
    
}

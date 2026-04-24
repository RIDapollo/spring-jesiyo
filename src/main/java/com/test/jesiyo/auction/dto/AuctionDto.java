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
	private int bidOpenPrice; 
	private String image;
	private String endDate;
	private String description;
	private String createdAt;
	private int status;
	
	private int winnerSeq;
	private int createMemberSeq;
	private int categorySeq;
	
	private int highestBid;
}

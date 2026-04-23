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
	private int bid_open_price;
	private String image;
	private String end_date;
	private String description;
	private String created_at;
	private int status;
	
	private int winner_seq;
	private int create_member_seq;
	private int category_seq;
	
}

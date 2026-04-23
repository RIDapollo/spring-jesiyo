package com.test.jesiyo.auction.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberDto {

	private int seq;
	private String name;
	private int point;
	private String id;
	private String pw;
	private String address;
	private String birth;
	private String nickname;
	private int permission;
	private String regdate;
	private String pwToken;
	private String tokenExpiry;
	private int status;
	private String emailAddress;
	
	private int locationSeq;
	
}

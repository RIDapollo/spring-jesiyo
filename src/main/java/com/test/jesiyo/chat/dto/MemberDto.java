package com.test.jesiyo.chat.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberDto {
	private String seq;
	private String name;
	private String point;
	private String id;
	private String pw;
	private String address;
	private String birth;
	private String nickname;
	private String permission;
	private String regDate;
	private String pwToken;
	private String tokenExpiry;
	private String status;
	private String emailAddress;
	private String locationSeq;
}

package com.test.jesiyo.member.dto;

import lombok.Data;

@Data
public class MemberDto {
	private String seq;
	private String userId;
    private String userPw;
    private String name;        
    private String birth;
    private String nickname;
    private String zipcode;
    private String address;
    private String detailAddress;
    private String email;
    private String permission;
    private String profileImg;
    private int usedCount;
    private int auctionCount;
    private int wishCount;
    private String point;
    private double avgScore;
    
}
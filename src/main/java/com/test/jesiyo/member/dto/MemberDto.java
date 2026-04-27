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
    //포인트 추가
    private String point;
    
}
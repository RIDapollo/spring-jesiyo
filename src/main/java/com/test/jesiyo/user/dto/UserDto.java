package com.test.jesiyo.user.dto;

import lombok.Data;

@Data
public class UserDto {
    private String userId;
    private String userPw;
    private String userName; // 로그인 성공 후 세션에 저장할 이름
}
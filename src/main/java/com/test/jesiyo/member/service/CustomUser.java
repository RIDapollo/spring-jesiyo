package com.test.jesiyo.member.service;

import java.util.Collection;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import com.test.jesiyo.member.dto.MemberDto;
import lombok.Getter;

@Getter
public class CustomUser extends User {

    private static final long serialVersionUID = 1L;
    
    private MemberDto memberDto;

    public CustomUser(MemberDto dto, Collection<? extends GrantedAuthority> authorities) {
        super(dto.getUserId(), dto.getUserPw(), authorities);
        this.memberDto = dto;
    }
}
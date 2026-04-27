package com.test.jesiyo.member.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.member.repository.MemberDao;

@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private MemberDao memberDao;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        
        // 1. DB에서 DTO를 가져옵니다.
        MemberDto member = memberDao.getMemberById(username);
        
        if (member == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다.");
        }

        // 2. 권한 목록을 만듭니다. (일단 ROLE_USER로 고정)
        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_USER"));

        // 3. ⭐ 중요: 시큐리티 User 대신 우리가 만든 CustomUser를 반환합니다.
        return new CustomUser(member, authorities);
    }
}
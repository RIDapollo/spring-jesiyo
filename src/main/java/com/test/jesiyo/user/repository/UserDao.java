package com.test.jesiyo.user.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.user.dto.UserDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class UserDao {

    private final SqlSessionTemplate template;
    
    /**
     * 로그인 검증
     * @param dto (userId, userPw 포함)
     * @return 일치하는 회원이 있으면 UserDto 반환, 없으면 null 반환
     */
    public UserDto login(UserDto dto) {
        
        // 매퍼의 namespace를 "user", id를 "login"으로 지정하여 호출합니다.
        UserDto resultDto = template.selectOne("user.login", dto);
        return resultDto;
    }
    
}
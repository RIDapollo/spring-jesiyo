package com.test.jesiyo.member.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.member.dto.MemberDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class MemberDao {

    private final SqlSessionTemplate template;
    
    /**
     * 로그인 검증
     * @param dto (userId, userPw 포함)
     * @return 일치하는 회원이 있으면 UserDto 반환, 없으면 null 반환
     */
    public MemberDto login(MemberDto dto) {
        
        // 매퍼의 namespace를 "user", id를 "login"으로 지정하여 호출합니다.
        MemberDto resultDto = template.selectOne("member.login", dto);
        return resultDto;
    }
    public int regist(MemberDto dto) {
        /* member.xml의 <mapper namespace="member"> 
           내부에 있는 <insert id="regist">를 호출합니다.
        */
        return template.insert("member.regist", dto);
    }
    public int checkId(String id) {
        /* member.xml의 <select id="checkId">를 호출합니다.
        */
        return template.selectOne("member.checkId", id);
    }
}
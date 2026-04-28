package com.test.jesiyo.member.repository;

import java.util.Map;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.category.dto.CategoryDto;
import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.member.dto.WishDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class MemberDao {
	@Autowired
    private SqlSession sqlSession;

    private final SqlSessionTemplate template;
    public MemberDto getMemberById(String userId) {
        // 클래스 내부라면 반드시 이렇게 { } 바디가 있어야 합니다.
        return sqlSession.selectOne("com.test.jesiyo.member.repository.MemberDao.getMemberById", userId);
    }
    
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
 // MemberDao.java 수정
    public int regist(MemberDto dto) {
        // XML의 namespace와 id를 모두 포함한 풀 경로 작성
        return sqlSession.insert("com.test.jesiyo.member.repository.MemberDao.regist", dto);
    }
    
    public int checkId(String id) {
        /* member.xml의 <select id="checkId">를 호출합니다.
        */
        return template.selectOne("com.test.jesiyo.member.repository.MemberDao.checkId", id);
    }
    
    public String findIdByEmail(String email) {
        // namespace.id 형식으로 호출 (mapper 파일의 설정과 일치해야 함)
        return template.selectOne("com.test.jesiyo.member.repository.MemberDao.findIdByEmail", email);
    }
    
    public int checkEmail(String email) {
        return sqlSession.selectOne("com.test.jesiyo.member.repository.MemberDao.checkEmail", email);
    }
    
    public int checkMemberForPwReset(Map<String, String> map) {
        return sqlSession.selectOne("com.test.jesiyo.member.repository.MemberDao.checkMemberForPwReset", map);
    }
    
    public int updateResetToken(Map<String, Object> map) {
        return sqlSession.update("com.test.jesiyo.member.repository.MemberDao.updateResetToken", map);
    }
    
    public MemberDto validateToken(String token) {
        return sqlSession.selectOne("com.test.jesiyo.member.repository.MemberDao.validateToken", token);
    }
    
    public int resetPassword(Map<String, String> map) {
        return sqlSession.update("com.test.jesiyo.member.repository.MemberDao.resetPassword", map);
    }
    
    public MemberDto getMember(String userId) {
        // XML의 id인 "getMemberById"를 호출하도록 수정
        return sqlSession.selectOne("com.test.jesiyo.member.repository.MemberDao.getMemberById", userId);
    }
    
    public List<WishDto> getWishList(String memberSeq) {
        // "네임스페이스.아이디" 형식으로 호출합니다.
        // 앞서 에러 로그에 나타난 경로인 com.test.jesiyo.member.repository.MemberDao를 사용합니다.
        return sqlSession.selectList("com.test.jesiyo.member.repository.MemberDao.getWishList", memberSeq);
    }
    
    public int deleteWish(String seq) {
        return sqlSession.delete("com.test.jesiyo.member.repository.MemberDao.deleteWish", seq);
    }
    
    public List<CategoryDto> getCategoryList() {
        // namespace는 이전 에러 로그에 나온 com.test.jesiyo.member.repository.MemberDao를 기준으로 작성합니다.
        return sqlSession.selectList("com.test.jesiyo.member.repository.MemberDao.getCategoryList");
    }
    
    public int addInterest(Map<String, String> map) {
        return sqlSession.insert("com.test.jesiyo.member.repository.MemberDao.addInterest", map);
    }
}
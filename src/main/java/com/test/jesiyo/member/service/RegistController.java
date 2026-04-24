package com.test.jesiyo.member.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.member.repository.MemberDao;

@Controller
@RequestMapping("/member") // 👈 모든 경로의 시작을 /member 로 통일
public class RegistController {

    @Autowired
    private MemberDao dao;

    @Autowired
    private BCryptPasswordEncoder bcryptEncoder;

    /**
     * 1. 회원가입 화면 (GET: /member/regist)
     */
    @GetMapping("/regist")
    public String registForm() {
        // views/member/regist.jsp 파일을 호출합니다.
        return "regist/regist"; 
    }

    /**
     * 2. 회원가입 처리 (POST: /member/regist)
     */
    @PostMapping("/regist")
    public String regist(MemberDto dto) {
        // 비밀번호 암호화
        String encryptedPw = bcryptEncoder.encode(dto.getUserPw());
        dto.setUserPw(encryptedPw);
        
        int result = dao.regist(dto);
        
        // 성공 시 로그인 페이지로, 실패 시 다시 가입 페이지로
        return (result > 0) ? "redirect:/login" : "regist/regist";
    }

    /**
     * 3. ID 중복 체크 (GET: /member/checkId)
     */
    @GetMapping("/checkId")
    @ResponseBody
    public String checkId(@RequestParam("id") String id) {
        int result = dao.checkId(id);
        return String.valueOf(result);
    }
}
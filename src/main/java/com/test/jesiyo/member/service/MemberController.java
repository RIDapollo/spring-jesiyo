package com.test.jesiyo.member.service;

import java.security.Principal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller; // 추가
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping; // 추가

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.member.repository.MemberDao;

@Controller // 1. 스프링이 컨트롤러임을 인식하도록 추가
@RequestMapping("/member") // 2. 공통 경로 설정
public class MemberController {
	
    @Autowired // 3. 필드 주입은 변수 바로 위에!
    private MemberDao dao;

    // 4. @GetMapping은 실행될 '메서드' 바로 위에 작성해야 합니다.
    @GetMapping("/mypage")
    public String mypage(Principal principal, Model model) {
	    
        if (principal == null) {
            return "redirect:/login/login";
        }
        
        String userId = principal.getName();
        MemberDto member = dao.getMember(userId);
        
        model.addAttribute("member", member);
        
        return "mypage/mypage";
    }
}
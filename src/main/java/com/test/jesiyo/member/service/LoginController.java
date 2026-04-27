package com.test.jesiyo.member.service;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.member.repository.MemberDao;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class LoginController {

    private final MemberDao userDao;

    /**
     * 1. 로그인 화면 띄우기 (GET 요청)
     * 사용자가 네비게이션 바에서 '로그인' 버튼을 클릭하면 실행됩니다.
     */
    @GetMapping("/login")
    public String loginForm() {
        // /WEB-INF/views/login/login.jsp 화면을 사용자에게 보여줍니다.
        return "login/login"; 
    }

    /**
     * 2. 로그인 수행하기 (POST 요청)
     * 사용자가 아이디와 비밀번호를 입력하고 '로그인' 버튼을 누르면 실행됩니다.
     */
    @PostMapping("/login")
    public String loginProcess(MemberDto dto, HttpSession session) {
        
        // 스프링이 폼 데이터(userId, userPw)를 UserDto에 자동으로 담아줍니다.
        MemberDto loginUser = userDao.login(dto);

        if (loginUser != null) {
            // 로그인 성공 시 세션에 사용자 정보 저장 후 메인 페이지('/')로 이동
            session.setAttribute("user", loginUser);
            System.out.println("========== 로그인 성공 ==========");
            System.out.println("세션에 저장된 사용자 정보: " + loginUser.toString());
            System.out.println("사용자 ID: " + loginUser.getUserId()); // DTO에 getUserId가 있다고 가정
            System.out.println("================================");
            return "redirect:/index";
        } else {
            // 로그인 실패 시 다시 로그인 페이지로 리다이렉트 (에러 파라미터 포함)
            return "redirect:/login?error=true"; 
        }
    }
    
    //로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        
        // 1. 세션에 저장된 모든 정보를 삭제하고 무효화합니다.
        session.invalidate(); 
        
        // 2. 로그아웃 후 메인 페이지(index)로 보냅니다.
        return "redirect:/index?msg=logout";
    }
}
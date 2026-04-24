package com.test.jesiyo.user.service;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

// 반드시 폴더명과 동일하게 전체 소문자(user)인지 확인해주세요!
import com.test.jesiyo.user.dto.UserDto;
import com.test.jesiyo.user.repository.UserDao;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class LoginController {

    private final UserDao userDao;

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
    public String loginProcess(UserDto dto, HttpSession session) {
        
        // 스프링이 폼 데이터(userId, userPw)를 UserDto에 자동으로 담아줍니다.
        UserDto loginUser = userDao.login(dto);

        if (loginUser != null) {
            // 로그인 성공 시 세션에 사용자 정보 저장 후 메인 페이지('/')로 이동
            session.setAttribute("user", loginUser);
            return "redirect:/";
        } else {
            // 로그인 실패 시 다시 로그인 페이지로 리다이렉트 (에러 파라미터 포함)
            return "redirect:/login?error=true"; 
        }
    }
}
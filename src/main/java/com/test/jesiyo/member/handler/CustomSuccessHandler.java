package com.test.jesiyo.member.handler;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

@Component
public class CustomSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        
        // 로그인 성공 시 세션에 환영 메시지 등을 담을 수 있습니다.
        HttpSession session = request.getSession();
        session.setAttribute("msg", authentication.getName() + "님 환영합니다!");
        
        // 로그인 성공 후 이동할 페이지
        response.sendRedirect(request.getContextPath() + "/index");
    }
}
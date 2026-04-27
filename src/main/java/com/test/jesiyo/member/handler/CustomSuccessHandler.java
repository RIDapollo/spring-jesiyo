package com.test.jesiyo.member.handler;

import java.io.IOException;
import java.lang.reflect.Field;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.member.service.CustomUser;

@Component("customSuccessHandler")
public class CustomSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        System.out.println("★★★ [Security] 로그인 성공 핸들러 진입 ★★★");
        HttpSession session = request.getSession();

        Object principal = authentication.getPrincipal();

        if (principal instanceof CustomUser) {
            CustomUser customUser = (CustomUser) principal;
            MemberDto loginUser = customUser.getMemberDto();

            if (loginUser != null) {
                // 1. 세션에 유저 객체 저장
                session.setAttribute("user", loginUser);
                
                // 2. [Reflection] MemberDto의 모든 필드와 값 출력
                System.out.println("================ [세션 저장 데이터 상세 내역] ================");
                Field[] fields = loginUser.getClass().getDeclaredFields();
                try {
                    for (Field field : fields) {
                        field.setAccessible(true); // private 필드 접근 허용
                        Object value = field.get(loginUser);
                        System.out.printf("필드명: %-15s | 값: %s%n", field.getName(), value);
                    }
                } catch (IllegalAccessException e) {
                    System.out.println("데이터 출력 중 오류 발생: " + e.getMessage());
                }
                System.out.println("==========================================================");
            }
        }

        session.setAttribute("msg", authentication.getName() + "님 환영합니다!");
        response.sendRedirect(request.getContextPath() + "/index");
    }
}
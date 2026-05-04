package com.test.jesiyo.notification.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.notification.dto.NotificationDto;
import com.test.jesiyo.notification.service.NotificationService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class NotificationController {

	private final NotificationService service;
	
	@GetMapping("/notifications")
	public String list(HttpSession session, Model model) {
		
		MemberDto loginMember = (MemberDto) session.getAttribute("user");
		// 비로그인 처리
        if (loginMember == null) {
            return "redirect:/member/login";
        }
        
        // 내 알림 목록 가져오기
        List<NotificationDto> list = service.getMyNotifications(Long.parseLong(loginMember.getSeq()));
        
        model.addAttribute("list", list); 
		return "/notifications/list";
	}
}

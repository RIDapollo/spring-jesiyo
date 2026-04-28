package com.test.jesiyo.chat.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.test.jesiyo.chat.service.ChatService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ChatController {

	private final ChatService chatService;
	
	@GetMapping(value = "/chat")
	public String chat(Model model, HttpSession session) {
		
		// 세션 임시 저장용 (회원 기능 구현하면 삭제)
//		if(session.getAttribute("loginUser")==null) {
//			MemberDto member = new MemberDto();
//			
//			member = chatService.findBySeq("3");
//			
//			session.setAttribute("user", member);
//		}
		
		model.addAttribute("user", session.getAttribute("user"));
		
		// 여기까지 세션 임시저장
		
		return "chats/chat";
	}
	
}

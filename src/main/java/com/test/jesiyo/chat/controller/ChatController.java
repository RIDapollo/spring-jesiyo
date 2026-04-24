package com.test.jesiyo.chat.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.test.jesiyo.chat.dto.ChatRoomDto;
import com.test.jesiyo.chat.dto.MemberDto;
import com.test.jesiyo.chat.service.ChatService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ChatController {

	private final ChatService chatService;
	
	@GetMapping(value = "/chat.do")
	public String chat(Model model, HttpSession session) {
		
		// 세션 임시 저장용 (회원 기능 구현하면 삭제)
		if(session.getAttribute("loginUser")==null) {
			MemberDto member = new MemberDto();
			
			member = chatService.findBySeq("4");
			
			session.setAttribute("auth", member);
		}
		
		model.addAttribute("auth", session.getAttribute("auth"));
		
		// 여기까지 세션 임시저장
		
		
		// 로그인 된 사용자의 seq를 가지고 채팅방의 내역을 가져와야함
		MemberDto auth = (MemberDto) session.getAttribute("auth");
		List<ChatRoomDto> list = chatService.getChatRoomList(auth.getSeq()); 
		
		model.addAttribute("list", list);
		
		return "chats/chat";
	}
	
}

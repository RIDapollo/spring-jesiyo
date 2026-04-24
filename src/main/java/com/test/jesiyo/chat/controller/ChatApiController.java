package com.test.jesiyo.chat.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.test.jesiyo.chat.dto.ChatRoomDto;
import com.test.jesiyo.chat.dto.MemberDto;
import com.test.jesiyo.chat.service.ChatRoomService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/chat/rooms")  // 공통 prefix를 클래스 레벨에 적용
@RequiredArgsConstructor
public class ChatApiController {
	
	private final ChatRoomService chatRoomService;
	
	// 채팅방 목록 조회 - 세션에서 꺼내기 
	@GetMapping
	public ResponseEntity<List<ChatRoomDto>> getRooms(HttpSession session) {
        MemberDto auth = (MemberDto) session.getAttribute("auth");
        String seq = auth.getSeq(); // 혹은 auth가 UserDto면 getUserSeq() 등
        return ResponseEntity.ok(chatRoomService.getChatRoomList(seq));
    }
	
	// 채팅방 등록
	@PostMapping
	public ResponseEntity<?> add(@RequestBody ChatRoomDto dto){
		
		try {
			chatRoomService.add(dto); // 실패하면 예외 던짐
	        return ResponseEntity.ok("ok");
		} catch (Exception e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	
	}
	
	
}

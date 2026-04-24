package com.test.jesiyo.chat.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.test.jesiyo.chat.dto.ChatRoomDto;
import com.test.jesiyo.chat.service.ChatRoomService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class ChatApiController {
	
	private final ChatRoomService chatRoomService;
	
	@PostMapping("/chat/room") // HTTP 표준 상태코드(200/400/500)로 성공·실패를 표현하기 위해 사용
	public ResponseEntity<?> add(@RequestBody ChatRoomDto dto){
		
		try {
			chatRoomService.add(dto); // 실패하면 예외 던짐
	        return ResponseEntity.ok("ok");
		} catch (Exception e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	
	}
	
	
}

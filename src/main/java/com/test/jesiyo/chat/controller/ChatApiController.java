package com.test.jesiyo.chat.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.test.jesiyo.chat.dto.ChatRoomDto;
import com.test.jesiyo.chat.dto.MemberDto;
import com.test.jesiyo.chat.service.ChatRoomService;
import com.test.jesiyo.chat.service.ChatService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/chat")  // 공통 prefix를 클래스 레벨에 적용
@RequiredArgsConstructor
public class ChatApiController {
	
	private final ChatRoomService chatRoomService;
	private final ChatService chatService;
	
	// 채팅방 목록 조회 - 세션에서 꺼내기 
	@GetMapping("/rooms")
	public ResponseEntity<List<ChatRoomDto>> getRooms(HttpSession session) {
        MemberDto auth = (MemberDto) session.getAttribute("auth");
        String seq = auth.getSeq(); // 혹은 auth가 UserDto면 getUserSeq() 등
        return ResponseEntity.ok(chatRoomService.getChatRoomList(seq));
    }
	
	// 그 채팅방 가져오기
	@GetMapping("/rooms/{seq}")
	public ChatRoomDto getChatRoom(@PathVariable int seq) {
	    return chatRoomService.getChatRoom(seq);
	}
	
	// 채티방 채팅 내역 가져오기
	@GetMapping("/rooms/logs/{seq}")
	public List<ChatRoomDto> getChatlogs(@PathVariable int seq) {
	    return chatRoomService.getChatlogs(seq);
	}
	
	// 채팅방 등록
	@PostMapping("/rooms")
	public ResponseEntity<?> add(@RequestBody ChatRoomDto dto){
		
		try {
			chatRoomService.add(dto); // 실패하면 예외 던짐
	        return ResponseEntity.ok("ok");
		} catch (Exception e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	
	}
	
	// 채팅방에서 자기 seq 가져오기
	@GetMapping("/rooms/member/{seq}")
	public int getChatRoomSeq(@PathVariable int seq) {
	    return chatRoomService.getChatRoomSeq(seq);
	}
	
	
	// 채팅 등록
	@PostMapping
	public ResponseEntity<?> addChat(@RequestBody ChatRoomDto dto){
		
		try {
			chatService.addChat(dto); // 실패하면 예외 던짐
	        return ResponseEntity.ok("ok");
		} catch (Exception e) {
			return ResponseEntity.badRequest().body(e.getMessage());
		}
	
	}
	
}

package com.test.jesiyo.chat.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.web.socket.WebSocketSession;

import com.test.jesiyo.chat.dto.ChatLogDto;
import com.test.jesiyo.chat.dto.ChatRoomDto;
import com.test.jesiyo.chat.dto.MemberDto;
import com.test.jesiyo.chat.repository.ChatDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatService {

	private final ChatDao chatDao;
	
	public MemberDto findBySeq(String seq) {
		
		return chatDao.findBySeq(seq);
	}

	public void addChat(ChatLogDto dto) {

		int resultChat = chatDao.addChat(dto);
		
	}

	public void triggerRecommend(ChatLogDto dto, WebSocketSession session) {
		// 채팅 추천 기능 AOP가 가로챔
		
	}



}

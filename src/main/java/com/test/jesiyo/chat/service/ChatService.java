package com.test.jesiyo.chat.service;

import java.util.List;

import org.springframework.stereotype.Service;

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

	public void addChat(ChatRoomDto dto) {

		int resultChat = chatDao.addChat(dto);
		
	}



}

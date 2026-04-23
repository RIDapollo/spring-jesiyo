package com.test.jesiyo.chat.service;

import org.springframework.stereotype.Service;

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

}

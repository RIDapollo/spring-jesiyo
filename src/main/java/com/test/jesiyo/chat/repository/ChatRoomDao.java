package com.test.jesiyo.chat.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.chat.dto.ChatRoomDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ChatRoomDao {

	private final SqlSessionTemplate template;

	public int add(ChatRoomDto dto) {
		return template.insert("chat-room.add", dto);
	}

	public int checkCode(String code) {
		return template.selectOne("chat-room.checkCode", code);
	}
	
}

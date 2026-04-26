package com.test.jesiyo.chat.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.chat.dto.ChatRoomDto;
import com.test.jesiyo.chat.dto.MemberDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ChatDao {

	private final SqlSessionTemplate template;
	
	public MemberDto findBySeq(String seq) {
		return template.selectOne("chat-member.temp",seq);
	}

	public int addChat(ChatRoomDto dto) {
		return template.insert("chat.addChat", dto);
	}

	

}

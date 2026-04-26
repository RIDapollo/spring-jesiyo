package com.test.jesiyo.chat.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.chat.dto.ChatRoomDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ChatRoomDao {

	private final SqlSessionTemplate template;

	// 채팅방 목록 불러오기
	public List<ChatRoomDto> getChatRoomList(String seq) {
		return template.selectList("chat-room.getChatRoomList", seq);
	}
	
	// 채팅방 생성
	public int add(ChatRoomDto dto) {
		return template.insert("chat-room.add", dto);
	}

	// 채팅방 코드 중복 검사
	public int checkCode(String code) {
		return template.selectOne("chat-room.checkCode", code);
	}

	// 채팅방이 만들어진 후 구성인원으로 추가
	public int addMember(ChatRoomDto dto) {
		return template.insert("chat-member.addMember", dto);
	}

	public ChatRoomDto getChatRoom(int seq) {
		return template.selectOne("chat-room.getChatRoom", seq);
	}

	public int getChatRoomSeq(int seq) {
		return template.selectOne("chat-room.getChatRoomSeq", seq);
	}
	
}

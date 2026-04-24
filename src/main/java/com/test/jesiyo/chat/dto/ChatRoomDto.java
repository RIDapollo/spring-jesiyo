package com.test.jesiyo.chat.dto;

import java.util.List;

import lombok.Data;


@Data
public class ChatRoomDto {

	private String seq;
	private String title;
	private String status;
	private String maxMemberCnt;
	private String currentMemberCnt;
	private String categorySeq;
	private String memberSeq;
	private String code;
	
	private List<ChatMemberDto> chatMemberDtoList;
	private List<ChatLogDto> chatLogDtoList;
	
}

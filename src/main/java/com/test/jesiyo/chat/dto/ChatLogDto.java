package com.test.jesiyo.chat.dto;

import lombok.Data;

@Data
public class ChatLogDto {
	
	private String seq;
	private String content;
	private String regDate;
	private String type;
	private String chatMemberSeq;
	private String chatRoomSeq;
	private String code;
	private String sender;
	private String nickname;

}

package com.test.jesiyo.chat.dto;

import lombok.Data;

@Data
public class ChatMemberDto {

	private String seq;
	private String lastReadMessage;
	private String alarm;
	private String status;
	private String memberSeq;
	private String chatRoomSeq;

}

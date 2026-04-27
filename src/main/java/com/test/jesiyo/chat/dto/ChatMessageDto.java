package com.test.jesiyo.chat.dto;

import lombok.Data;

@Data
public class ChatMessageDto {
	
	private String content;
	private String sender;
	private String type;
	private String regDate;
	
	
}

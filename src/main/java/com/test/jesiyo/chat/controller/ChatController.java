package com.test.jesiyo.chat.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ChatController {

	@GetMapping(value = "/chat.do")
	public String chat(Model model) {

		return "chats/chat";
	}
	
}

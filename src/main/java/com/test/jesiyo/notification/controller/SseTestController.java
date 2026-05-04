package com.test.jesiyo.notification.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SseTestController {

	@GetMapping("/sseTest")
	public String sseTest() {

		return "/notifications/sseTest";
	}
}

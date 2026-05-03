package com.test.jesiyo.notification.api;

import java.io.IOException;

import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.notification.service.NotificationEmitterService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class NotificationApi {

	private final NotificationEmitterService emitterService;
	
	// SSE 연결용 API
	@GetMapping("/notifications/subscribe")
    public SseEmitter subscribe(HttpSession session) {

		MemberDto loginMember = (MemberDto) session.getAttribute("user");
		
		// 비로그인 처리
	    if (loginMember == null) {
	    	throw new RuntimeException("로그인 필요");
	    }

	    // 로그인한 회원 SSE 연결(subscribe)하기
        Long memberSeq = Long.valueOf(loginMember.getSeq());
        SseEmitter emitter = emitterService.subscribe(memberSeq);
        
        // 최초 연결 이벤트 보내서 SSE 연결 바로 끊기는 것 방지
        try {
            emitter.send(SseEmitter.event()
                    .name("connect")
                    .data("connected"));
        } catch (IOException e) {
            emitter.completeWithError(e);
        }

        return emitter;
    }
}

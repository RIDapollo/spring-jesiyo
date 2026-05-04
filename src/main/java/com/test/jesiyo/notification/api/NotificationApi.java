package com.test.jesiyo.notification.api;

import java.io.IOException;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.notification.dto.NotificationDto;
import com.test.jesiyo.notification.service.NotificationEmitterService;
import com.test.jesiyo.notification.service.NotificationService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class NotificationApi {

	private final NotificationEmitterService emitterService;
	private final NotificationService notificationService;
	
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
	
	@PostMapping("/test/notify")
    public String testNotify(HttpSession session) {

        // 로그인 사용자 가져오기
        MemberDto loginMember = (MemberDto) session.getAttribute("user");

        if (loginMember == null) {
            throw new RuntimeException("로그인 필요");
        }

        NotificationDto dto = NotificationDto.builder()
                .memberSeq(Long.valueOf(loginMember.getSeq()))
                .message("테스트 알림입니다")
                .refType("OTHER")
                .refSeq(0L)
                .build();

        notificationService.createNotification(dto);

        return "ok";
    }
	
	@PostMapping("/notifications/{seq}/read")
	public ResponseEntity<String> readNotification(@PathVariable("seq") Long seq) {
		
		int result = notificationService.readNotification(seq);
		
		if (result != 1) {
			return ResponseEntity.badRequest().body("처리 실패");
		}
		
		return ResponseEntity.ok("읽음 처리 완료");
	}
}

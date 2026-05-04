package com.test.jesiyo.notification.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.test.jesiyo.notification.dto.NotificationDto;
import com.test.jesiyo.notification.repository.NotificationDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationDao dao;
    private final NotificationEmitterService emitterService;

    public void createNotification(NotificationDto dto) {

        // 1. DB 저장
        dao.insertNotification(dto);

        // 2. DB에서 저장된 알림 조회
        NotificationDto saved = dao.findBySeq(dto.getSeq());
        
        // 3. 안 읽은 알림 수 조회
        int count = dao.selectUnreadByMemberSeq(dto.getMemberSeq());
        
        // 4. 2+3 같이 보내기
        Map<String, Object> payload = new HashMap<>();
        payload.put("notification", saved);
        payload.put("unreadCount", count);

        emitterService.send(saved.getMemberSeq(), payload);
    }

	public List<NotificationDto> getMyNotifications(Long memberSeq) {
		return dao.findByMemberSeq(memberSeq);
	}

	public boolean readNotification(Long seq) {
		
		// 1. 알림 읽음 처리
		int result = dao.updateReadStatusBySeq(seq);
		
		if (result != 1) return false;
		
		 // 2. 해당 알림의 사용자 찾기
	    Long memberSeq = dao.findMemberSeqBySeq(seq);
	    // 3. 안 읽은 개수 조회
	    int count = dao.selectUnreadByMemberSeq(memberSeq);

	    // 4. payload 구성
	    Map<String, Object> payload = new HashMap<>();
	    payload.put("unreadCount", count);
	    // 5. SSE 전송
	    emitterService.send(memberSeq, payload);
		
		return true;
	}

	public int getUnreadCount(Long memberSeq) {
		return dao.selectUnreadByMemberSeq(memberSeq);
	}
}
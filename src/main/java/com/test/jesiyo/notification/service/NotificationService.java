package com.test.jesiyo.notification.service;

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
        
        // 2. 실시간 전송
        emitterService.send(saved.getMemberSeq(), saved);
    }
}
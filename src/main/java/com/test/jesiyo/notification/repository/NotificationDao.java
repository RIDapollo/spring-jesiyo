package com.test.jesiyo.notification.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.notification.dto.NotificationDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class NotificationDao {

    private final SqlSessionTemplate template;

    public int insertNotification(NotificationDto dto) {
        return template.insert("notification.insertNotification", dto);
    }

	public NotificationDto findBySeq(Long seq) {
		return template.selectOne("notification.findBySeq", seq);
	}
}
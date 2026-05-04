package com.test.jesiyo.notification.dto;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NotificationDto {
    private Long seq;          
    private String message;    // 알림 메시지
    private String isRead;     // 'Y' / 'N'
    @JsonFormat(pattern = "MM/dd HH시 mm분", timezone = "Asia/Seoul")
    private Date createdAt;    
    private String refType;    // DIRECT / CHAT / COMMENT 등
    private Long refSeq;       
    private Long memberSeq;    // 수신자
}
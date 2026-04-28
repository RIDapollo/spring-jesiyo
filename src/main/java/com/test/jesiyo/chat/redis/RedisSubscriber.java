package com.test.jesiyo.chat.redis;

import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import com.google.gson.Gson;
import com.test.jesiyo.chat.dto.ChatLogDto;
import com.test.jesiyo.chat.handler.ChatRoomSessionManager;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class RedisSubscriber {

    // 방별 WebSocket 세션을 관리하는 기존 매니저
    private final ChatRoomSessionManager sessionManager;

    private final Gson gson = new Gson();

    // RedisConfig의 MessageListenerAdapter가 이 메서드를 호출함
    // Redis에서 받은 메시지(payload)는 문자열(JSON)이라고 가정
    public void onMessage(String message) {
        
        // JSON 문자열을 ChatLogDto로 변환
        ChatLogDto dto = gson.fromJson(message, ChatLogDto.class);

        // 어떤 방 메시지인지 식별
        String roomId = dto.getChatRoomSeq();

        // 해당 방에 연결된 WebSocket 세션 목록 조회
        List<WebSocketSession> sessions = sessionManager.getSessions(roomId);

        // 같은 방의 모든 세션에게 메시지 브로드캐스트
        for (WebSocketSession session : sessions) {
            try {
                if (session.isOpen()) {
                    session.sendMessage(new TextMessage(message));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
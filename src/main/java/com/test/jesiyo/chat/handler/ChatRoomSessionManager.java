package com.test.jesiyo.chat.handler;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketSession;

// 방별 세션 관리

@Component
public class ChatRoomSessionManager {

    // roomId → 접속 중인 세션 목록
    // ConcurrentHashMap: 여러 사람이 동시에 접속해도 안전
    private final Map<String, List<WebSocketSession>> rooms = new ConcurrentHashMap<>();

    // 세션 추가 (방 입장)
    public void addSession(String roomId, WebSocketSession session) {
        rooms.computeIfAbsent(roomId, k -> new ArrayList<>()).add(session);
    }

    // 세션 제거 (방 퇴장)
    public void removeSession(String roomId, WebSocketSession session) {
        List<WebSocketSession> sessions = rooms.get(roomId);
        if (sessions != null) {
            sessions.remove(session);
            // 방에 아무도 없으면 방 자체를 제거
            if (sessions.isEmpty()) {
                rooms.remove(roomId);
            }
        }
    }

    // 해당 방의 세션 목록 반환
    public List<WebSocketSession> getSessions(String roomId) {
        return rooms.getOrDefault(roomId, new ArrayList<>());
    }
}
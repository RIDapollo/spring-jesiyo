package com.test.jesiyo.chat.handler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.test.jesiyo.chat.dto.ChatLogDto;
import com.test.jesiyo.chat.service.ChatService;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    @Autowired
    private ChatRoomSessionManager sessionManager;
    @Autowired
    private ChatService chatService;

    // roomId 꺼내는 공통 메서드
    private String getRoomId(WebSocketSession session) {
        String path = session.getUri().getPath();
        return path.substring(path.lastIndexOf('/') + 1);
    }

    // 1: 방 입장 시 세션 등록
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        String roomId = getRoomId(session);
        sessionManager.addSession(roomId, session);
        System.out.println("입장 - roomId: " + roomId + " / sessionId: " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
    	String roomId = getRoomId(session);
        String payload = message.getPayload();
        
        // JSON → Dto
        Gson gson = new Gson();
        JsonObject json = gson.fromJson(payload, JsonObject.class);
        ChatLogDto dto = gson.fromJson(payload, ChatLogDto.class);
        dto.setChatRoomSeq(roomId);
        dto.setType("1");
       
        System.out.println(dto.toString());
        // DB 저장
        chatService.addChat(dto);

        // 같은 방에 있는 모든 세션에게 전송 (보낸 사람 포함)
        for (WebSocketSession s : sessionManager.getSessions(roomId)) {
            if (s.isOpen()) {
                s.sendMessage(new TextMessage(payload));
            }
        }
        
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session,
            org.springframework.web.socket.CloseStatus status) throws Exception {
    	String roomId = getRoomId(session);
        sessionManager.removeSession(roomId, session);
        System.out.println("퇴장 - roomId: " + roomId + " / sessionId: " + session.getId());
    }
}
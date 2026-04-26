package com.test.jesiyo.auction.handler;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
public class BidWebSocketHandler extends TextWebSocketHandler {

	private static List<WebSocketSession> sessions = new ArrayList<>();
	
	@Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session); 
    }
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		
		String payload = message.getPayload();
        
        // 접속해 있는 모든 유저에게 해당 메시지를 브로드캐스트
        for (WebSocketSession s : sessions) {
            if (s.isOpen()) {
                s.sendMessage(new TextMessage(payload));
            }
        }
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		sessions.remove(session);
	}
	
}

package com.test.jesiyo.liveauction.handler;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
public class LiveAuctionHandler extends TextWebSocketHandler {
	
	// 현재 접속 중인 세션들을 모아두는 리스트
    private static List<WebSocketSession> sessionList = new ArrayList<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessionList.add(session); // 접속 시 리스트에 추가
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        // 한 명이 메시지를 보내면 접속한 모두에게 뿌려줌 (브로드캐스팅)
        String payload = message.getPayload();
        for (WebSocketSession sess : sessionList) {
            sess.sendMessage(new TextMessage(payload));
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessionList.remove(session); // 연결 끊기면 리스트에서 제거
    }
}

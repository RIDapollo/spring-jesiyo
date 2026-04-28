package com.test.jesiyo.chat.handler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.test.jesiyo.chat.dto.ChatLogDto;
import com.test.jesiyo.chat.redis.RedisPublisher;
import com.test.jesiyo.chat.service.ChatService;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    @Autowired
    private ChatRoomSessionManager sessionManager;
    @Autowired
    private ChatService chatService;
    @Autowired
    private RedisPublisher redisPublisher;
	 /* RedisPublisher 주입
	  	기존에는 이 핸들러가 직접 WebSocket 세션들에 메시지를 뿌렸지만,
	  	이제는 Redis 채널에 먼저 발행(publish)하고
	 	RedisSubscriber가 다시 해당 방 세션들에게 전달하게 바꿀 예정
	 */

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
        String code = json.get("code").getAsString();
        ChatLogDto dto = gson.fromJson(payload, ChatLogDto.class);
        
        //REFRESH_MEMBERS 신호 → DB 저장 없이 브로드캐스트만
        if ("REFRESH_MEMBERS".equals(code)) {
            // 방 참여자 목록 새로고침 신호는 DB 저장이 필요 없는 이벤트성 메시지
            // 기존에는 같은 서버의 세션에만 직접 보냈지만,
            // 이제는 Redis로 publish해서 멀티 서버 환경에서도 모두 전달되게 함
            redisPublisher.publish(payload);
            return;
        }
        
	    // 현재 WebSocket 경로에서 꺼낸 roomId를 DTO에 넣음
	    // RedisSubscriber는 이 값을 보고 어떤 방 세션에 보낼지 판단하므로
	    // publish 전에 반드시 chatRoomSeq가 세팅되어 있어야 함
        dto.setChatRoomSeq(roomId);
        dto.setType("1");
       
	    // DB에 채팅 메시지를 저장
	    // Redis는 전달용 브로커이고, 채팅 원본 데이터 저장소는 DB로 유지
	    chatService.addChat(dto);
	
	    // 현재 dto 상태(roomId 포함)를 JSON 문자열로 다시 생성
	    // RedisSubscriber가 이 문자열을 받아 각 서버의 해당 방 세션들에게 전달함
	    String publishMessage = gson.toJson(dto);
	
	    // 기존 직접 브로드캐스트 대신 Redis 채널로 발행
	    // 멀티 서버 환경에서도 동일 메시지를 공유할 수 있게 됨
	    redisPublisher.publish(publishMessage);
	
	    // 추천 기능은 "채팅 친 사람 본인 세션에게만" 보내는 개인성 응답이므로
	    // 기존처럼 현재 WebSocket session을 넘겨서 처리
	    chatService.triggerRecommend(dto, session);
	    
		// 클라이언트에서 온 원본 payload를 그대로 publish하지 않고,
		// 서버에서 보정한 dto(roomId, type 등 포함)를 기준으로 다시 JSON 생성
		// 그래야 RedisSubscriber가 안정적으로 roomId를 꺼내 쓸 수 있음
        
    }
    
    @Override
    public void afterConnectionClosed(WebSocketSession session,
            org.springframework.web.socket.CloseStatus status) throws Exception {
    	String roomId = getRoomId(session);
        sessionManager.removeSession(roomId, session);
        System.out.println("퇴장 - roomId: " + roomId + " / sessionId: " + session.getId());
    }
    
    public ChatRoomSessionManager getSessionManager() {
        return sessionManager;
    }
}
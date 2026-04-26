package com.test.jesiyo.chat.service;

import java.security.SecureRandom;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.test.jesiyo.chat.dto.ChatRoomDto;
import com.test.jesiyo.chat.repository.ChatRoomDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatRoomService {
	
	private final ChatRoomDao chatRoomDao;

	@Transactional
	public void add(ChatRoomDto dto) {
		
		// 방코드 추가
		String code = createCode();;
		
		// 중복체크
		while(checkCode(code) > 0) {
			code = createCode();
		}
		
		dto.setCode(code);
		
		int resultRoom = chatRoomDao.add(dto);
        
        if (resultRoom == 0) {
            throw new RuntimeException("채팅방 생성 실패");
        }
        
        // 채팅방 생성에 성공했다면 그 방장의 정보를 채팅방 인원에 포함
        int resultMember = chatRoomDao.addMember(dto);
        
		
	}
	
	public String createCode() {
		
		String code = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	    SecureRandom random = new SecureRandom();
	    StringBuilder sb = new StringBuilder(8);

	    for (int i = 0; i < 8; i++) {
	        // chars 문자열에서 랜덤하게 하나씩 선택
	        int randomIndex = random.nextInt(code.length());
	        sb.append(code.charAt(randomIndex));
	    }
	    
	    return sb.toString();
	}
	
	public int checkCode(String code) {
		
		return chatRoomDao.checkCode(code);
	}
	
	
	public List<ChatRoomDto> getChatRoomList(String seq) {
		
		return chatRoomDao.getChatRoomList(seq);
	}

	public ChatRoomDto getChatRoom(int seq) {
		return chatRoomDao.getChatRoom(seq);
	}
	
}

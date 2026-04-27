package com.test.jesiyo.trade.api;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.trade.dto.TradeDto;
import com.test.jesiyo.trade.service.TradeService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class TradeApi {

    private final TradeService tradeService;

    @PostMapping("/trades")
    public ResponseEntity<String> requestTrade(
            @RequestBody TradeDto dto,
            HttpSession session) {

        MemberDto loginMember = (MemberDto) session.getAttribute("user");
        
        if (loginMember == null) {
        	return ResponseEntity.status(401).body("LOGIN_REQUIRED");
        }
        
        dto.setBuyerSeq(Long.parseLong(loginMember.getSeq()));
        tradeService.add(dto);
        return ResponseEntity.ok("OK");
    }
}
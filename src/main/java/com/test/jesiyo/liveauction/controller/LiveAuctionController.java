package com.test.jesiyo.liveauction.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.test.jesiyo.auction.dto.AuctionDto;
import com.test.jesiyo.auction.dto.BidDto;
import com.test.jesiyo.auction.service.AuctionService;
import com.test.jesiyo.liveauction.service.LiveAuctionService;
import com.test.jesiyo.member.dto.MemberDto;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class LiveAuctionController {
	
	private final LiveAuctionService liveService;
	private final AuctionService service;
	
	//실시간 라이브 경매 메인 화면
	@GetMapping(value = "/auction/live/{seq}")
	public String liveAuctionDetail(@PathVariable("seq") int seq, Model model, HttpSession session) {
		
		MemberDto mdto = (MemberDto) session.getAttribute("user");
		
		// 라이브 경매 상세 정보 조회 (기존 일반 경매 상세 메서드 재사용 또는 라이브 전용 생성)
		AuctionDto dto = service.getDetail(seq);
		
		// 현재 라이브 경매의 최고가 세팅
		AuctionDto dtoHasHighestBid = service.getHighestBid(seq);
		if (dtoHasHighestBid != null) {
			dto.setHighestBid(dtoHasHighestBid.getHighestBid()); 
		}
		
		// 로그인한 사용자의 현재 입찰가 확인
		int myBidPrice = 0;
		if (mdto != null) {
			Map<String, Object> map = new HashMap<>();
			map.put("seq", seq);
			map.put("memberSeq", mdto.getSeq());
			
			BidDto bdto = service.getMyBid(map);
			if (bdto != null) {
				myBidPrice = bdto.getBidPrice();
			}
		}
		
		model.addAttribute("dto", dto);
		model.addAttribute("myBidPrice", myBidPrice);
		
		return "auction/liveAuctionMain";
	}
	
}

package com.test.jesiyo.liveauction.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.test.jesiyo.liveauction.dto.LiveAuctionDto;
import com.test.jesiyo.liveauction.dto.LiveBidDto;
import com.test.jesiyo.liveauction.service.LiveAuctionService;
import com.test.jesiyo.member.dto.MemberDto;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class LiveAuctionController {
	
	private final LiveAuctionService service;
	
	@GetMapping(value = "/auction/live")
	public String liveAuctionMain(Model model, HttpSession session) {
		
		MemberDto mdto = (MemberDto) session.getAttribute("user");
		
		// 진행 중(1)이거나 가장 가까운 대기중(0)인 스케줄 조회
		Map<String, Object> schedule = service.getCurrentSchedule();
		
		// 만약 등록된 스케줄이 아예 없거나 모두 종료(2)되었다면 안내 페이지로 이동
		if (schedule == null) {
			return "auction/noLiveAuction"; // "현재 예정된 라이브 경매가 없습니다" 화면
		}
		
		// 스케줄에서 외래키(live_auction_seq)를 꺼냄
		int seq = Integer.parseInt(schedule.get("LIVE_AUCTION_SEQ").toString());
		
		// 해당 번호로 라이브 경매 물품 상세 정보 조회 
		LiveAuctionDto dto = service.getDetail(seq);
		
		// 현재 라이브 경매의 최고가 세팅
		LiveAuctionDto dtoHasHighestBid = service.getHighestBid(seq);
		if (dtoHasHighestBid != null) {
			dto.setHighestBid(dtoHasHighestBid.getHighestBid()); 
		}
		
		// 로그인한 사용자의 현재 입찰가 확인
		int myBidPrice = 0;
		if (mdto != null) {
			Map<String, Object> map = new HashMap<>();
			map.put("seq", seq);
			map.put("memberSeq", mdto.getSeq());
			
			LiveBidDto bdto = service.getMyBid(map);
			if (bdto != null) {
				myBidPrice = bdto.getBidPrice();
			}
		}
		
		model.addAttribute("dto", dto);
		model.addAttribute("dtoHasHighestBid", dtoHasHighestBid);
		model.addAttribute("myBidPrice", myBidPrice);
		
		// 스케줄 정보(방송일시, 상태 등)도 화면에 넘겨주어 카운트다운 등에 활용
		model.addAttribute("schedule", schedule); 
		
		return "auction/liveAuction-main";
	}
	
}

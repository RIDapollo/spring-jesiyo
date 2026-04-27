package com.test.jesiyo.liveauction.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

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
	
	@PostMapping(value = "/auction/live/bid")
	@ResponseBody
	public Map<String, Object> processBid(@RequestBody Map<String, Object> map, HttpSession session) {
		
		Map<String, Object> result = new HashMap<>();
		MemberDto mdto = (MemberDto) session.getAttribute("user");
		
		if (mdto == null) {
			result.put("success", false);
			result.put("message", "세션이 만료되었습니다. 다시 로그인해주세요.");
			return result;
		}
		
		int seq = Integer.parseInt(map.get("auctionSeq").toString());
		int bidPrice = Integer.parseInt(map.get("bidPrice").toString());
		
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("seq", seq);
		paramMap.put("bidPrice", bidPrice);
		paramMap.put("memberSeq", mdto.getSeq());
		
		// 서비스 단에서 @Transactional을 걸고 입찰 로직과 최신 데이터 조회를 한 번에 수행
		// 결과 Map에는 success, message, dtoHasHighestBid, latestBids 등이 담겨 옵니다.
		return service.placeLiveBid(paramMap); 
	}
	
	@GetMapping(value = "/auction/live/api/latest/{seq}")
	@ResponseBody
	public Map<String, Object> getLatestBids(@PathVariable("seq") int seq) {
	    Map<String, Object> result = new HashMap<>();
	    
	    // 1. 현재 최고가 조회
	    result.put("dtoHasHighestBid", service.getHighestBid(seq));
	    
	    // 2. 최근 5개 입찰 기록 조회
	    result.put("latestBids", service.getLatestLiveBids(seq));
	    
	    return result;
	}
	
	@PostMapping(value = "/auction/live/finish")
	@ResponseBody
	public Map<String, Object> finishLiveAuction(@RequestBody Map<String, Object> map, HttpSession session) {
	    Map<String, Object> result = new HashMap<>();
	    MemberDto mdto = (MemberDto) session.getAttribute("user");

	    if (mdto == null) {
	        result.put("status", "fail");
	        result.put("msg", "세션이 만료되었습니다.");
	        return result;
	    }

	    try {
	        // 모든 비즈니스 로직(낙찰자 확인, 정산, 상태 변경)을 트랜잭션이 걸린 Service로 위임
	        result = service.completeLiveAuction(map);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("status", "fail");
	        result.put("msg", "경매 종료 처리 중 서버 오류가 발생했습니다.");
	    }
	    
	    return result;
	}
	
	@PostMapping(value = "/auction/live/reset")
	@ResponseBody
	public Map<String, Object> resetLiveAuction(@RequestBody Map<String, Object> map, HttpSession session) {
	    Map<String, Object> result = new HashMap<>();
	    MemberDto mdto = (MemberDto) session.getAttribute("user");

	    if (mdto == null) {
	        result.put("status", "fail");
	        result.put("msg", "세션이 만료되었습니다.");
	        return result;
	    }

	    try {
	        result = service.resetLiveAuction(map);
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("status", "fail");
	        result.put("msg", "초기화 중 서버 오류가 발생했습니다.");
	    }
	    
	    return result;
	}
	
}

package com.test.jesiyo.liveauction.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.test.jesiyo.liveauction.dto.LiveAuctionDto;
import com.test.jesiyo.liveauction.dto.LiveBidDto;
import com.test.jesiyo.liveauction.repository.LiveAuctionDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class LiveAuctionService {

	private final LiveAuctionDao dao;
	
	public Map<String, Object> getCurrentSchedule() {
		
		return dao.getCurrentSchedule();
	}

	public LiveAuctionDto getDetail(int seq) {
		
		return dao.getDetail(seq);
	}

	public LiveAuctionDto getHighestBid(int seq) {
		
		return dao.getHighestBid(seq);
	}

	public LiveBidDto getMyBid(Map<String, Object> map) {
		
		return dao.getMyBid(map);
	}

	@Transactional
	public Map<String, Object> placeLiveBid(Map<String, Object> paramMap) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		int seq = Integer.parseInt(String.valueOf(paramMap.get("seq")));
	    int bidPrice = Integer.parseInt(String.valueOf(paramMap.get("bidPrice")));
	    
	    LiveAuctionDto dtoHasHighestBid = dao.getHighestBid(seq);
	    if (dtoHasHighestBid != null && bidPrice <= dtoHasHighestBid.getHighestBid()) {
	        result.put("status", "fail");
	        result.put("msg", "현재 최고가보다 높은 금액만 입찰 가능합니다.");
	        return result;
	    }
			
		dao.cancelPreviousLiveBid(paramMap); //이전 입찰 status 1로 변경
		
		int insertResult = dao.liveBid(paramMap);
		
		if (insertResult <= 0) {
	        result.put("status", "fail");
	        result.put("msg", "입찰 처리에 실패했습니다.");
	        return result;
	    }
				
		result.put("status", "success");
		result.put("latestBids", dao.getLatestLiveBids(seq)); //최근 목록 5개
		result.put("dtoHasHighestBid", dao.getHighestBid(seq)); //최고가를 포함한 LiveAuctionDto객체
			
		return result;
	}
	
	@Transactional
	public Map<String, Object> liveBid(Map<String, Object> map) {
		
		Map<String, Object> result = new HashMap<>();

	    int insertResult = dao.liveBid(map);

	    if (insertResult > 0) {
	    	
	        int seq = (int) map.get("seq");
	        LiveAuctionDto dtohasHighestBid = dao.getHighestBid(seq);

	        result.put("status", "success");
	        result.put("dtoHasHighestBid", dtohasHighestBid);

	    } else {
	        result.put("status", "false");
	    }

	    return result;
	}

	public List<LiveBidDto> getLatestLiveBids(int seq) {
		
		return dao.getLatestLiveBids(seq);
	}
	
	@Transactional(rollbackFor = Exception.class) // 예외 발생 시 무조건 롤백되도록 명시
	public int completeLiveAuction(Map<String, Object> map) {
		
		int result = 0;
		
		int scheduleRow = dao.completeLiveAuctionSchedule(map);
		
		int auctionRow = dao.updateLiveAuctionWinner(map);
		
		if (scheduleRow > 0 && auctionRow > 0) {
			result = 1; 
		} else {
			throw new RuntimeException("경매 종료 처리 중 데이터 불일치 발생 (Rollback)");
		}
		
		return result;
	}

}

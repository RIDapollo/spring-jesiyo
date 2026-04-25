package com.test.jesiyo.auction.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.test.jesiyo.auction.dto.AuctionDto;
import com.test.jesiyo.auction.dto.BidDto;
import com.test.jesiyo.auction.repository.AuctionDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuctionService {

	private final AuctionDao dao;

	public List<AuctionDto> list(HashMap<String, String> map) {
		
		return dao.list(map);
	}

	public int getTotalCount(HashMap<String, String> map) {
		
		return dao.getTotalCount(map);
	}
	
	@Transactional
	public void add(HashMap<String, Object> map) {
		
		//경매마스터 seq먼저 생성
		dao.addMaster(map);
		
		dao.addAuction(map);
	}

	public AuctionDto getDetail(int seq) {
		
		return dao.getDetail(seq);
	}

	public AuctionDto getHighestBid(int seq) {
		
		return dao.getHighestBid(seq);
	}
	
	@Transactional
	public Map<String, Object> bid(Map<String, Object> map) {
		
		Map<String, Object> result = new HashMap<>();

	    int insertResult = dao.bid(map);

	    if (insertResult > 0) {
	    	
	        int seq = (int) map.get("seq");
	        AuctionDto dtohasHighestBid = dao.getHighestBid(seq);

	        result.put("status", "success");
	        result.put("dtoHasHighestBid", dtohasHighestBid);

	    } else {
	        result.put("status", "false");
	    }

	    return result;
	}

	public List<BidDto> getLatestBids(int seq) {
		
		return dao.getLatestBids(seq);
	}
	
	@Transactional
	public Map<String, Object> placeBid(Map<String, Object> paramMap) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			
			dao.cancelPreviousBid(paramMap); //자신의 이전 입찰 status 1로 변경
			
			int insertResult = dao.bid(paramMap);
			
			if(insertResult > 0) {
				result.put("status", "success");
				
				int seq = Integer.parseInt(paramMap.get("seq").toString());
				
				result.put("latestBids", dao.getLatestBids(seq)); //최근 목록 5개
				result.put("dtoHasHighestBid", dao.getHighestBid(seq)); //최고가를 포함한 auctionDto객체
			} else {
				result.put("status", "fail");
			}
			
		} catch (Exception e) {
			// 예외 발생 시 트랙잭션 롤백을 위해 RuntimeException을 던집니다.
			throw new RuntimeException("입찰 처리 중 오류 발생!", e);
		}
		
		return result;
	}
	
	@Transactional
	public int cancelAuctionIfHasNoBids(Map<String, Object> paramMap) {
		
		return dao.cancelAuctionIfHasNoBids(paramMap); //쿼리에서 해당 memberSeq가 해당 auction을 만들었는지도 확인함
	}
	
	
}


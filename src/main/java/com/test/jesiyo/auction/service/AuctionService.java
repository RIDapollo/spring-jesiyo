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
		
		List<BidDto> latestBids = dao.getLatestBids(seq);
		
		for (BidDto bdto : latestBids) {
            String originalId = bdto.getUserId();
            if (originalId != null && originalId.length() > 3) {
            	
                String maskedId = originalId.substring(0, 3) + "*".repeat(originalId.length() - 3);
                
                bdto.setUserId(maskedId);
                
            } else if (originalId != null) {
                // 아이디가 너무 짧은 경우 앞 1글자만 남김
            	bdto.setUserId(originalId.substring(0, 1) + "**");
            }
        }
		
		return latestBids;
	}
	
	@Transactional
	public Map<String, Object> placeBid(Map<String, Object> paramMap) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		int seq = Integer.parseInt(String.valueOf(paramMap.get("seq")));
	    int bidPrice = Integer.parseInt(String.valueOf(paramMap.get("bidPrice")));
	    
	    AuctionDto dtoHasHighestBid = dao.getHighestBid(seq);
	    if (dtoHasHighestBid != null && bidPrice <= dtoHasHighestBid.getHighestBid()) {
	        result.put("status", "fail");
	        result.put("msg", "현재 최고가보다 높은 금액만 입찰 가능합니다.");
	        return result;
	    }
			
		dao.cancelPreviousBid(paramMap); //이전 입찰 status 1로 변경
		
		int insertResult = dao.bid(paramMap);
		
		if (insertResult <= 0) {
	        result.put("status", "fail");
	        result.put("msg", "입찰 처리에 실패했습니다.");
	        return result;
	    }
				
		result.put("status", "success");
		result.put("latestBids", dao.getLatestBids(seq)); //최근 목록 5개
		result.put("dtoHasHighestBid", dao.getHighestBid(seq)); //최고가를 포함한 auctionDto객체
			
		return result;
	}
	
	@Transactional
	public int cancelAuctionIfHasNoBids(Map<String, Object> paramMap) {
		
		return dao.cancelAuctionIfHasNoBids(paramMap); //쿼리에서 해당 memberSeq가 해당 auction을 만들었는지도 확인함
	}

	public BidDto getMyBid(Map<String, Object> map) {
		
		return dao.getMyBid(map);
	}

	public int getMyAuctionTotalCount(HashMap<String, String> map) {
		
		return dao.getMyAuctionTotalCount(map);
	}

	public List<AuctionDto> getMyAuctionList(HashMap<String, String> map) {
		
		return dao.getMyAuctionList(map);
	}

	public int getMyBidTotalCount(HashMap<String, String> map) {
		
		return dao.getMyBidTotalCount(map);
	}

	public List<AuctionDto> getMyBidList(HashMap<String, String> map) {
		
		return dao.getMyBidList(map);
	}
	
	
}


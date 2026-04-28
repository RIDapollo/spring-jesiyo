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
	    
	    if (dtoHasHighestBid != null && dtoHasHighestBid.getStatus() != 0) {
            result.put("status", "fail");
            result.put("msg", "이미 종료된 경매입니다. 입찰할 수 없습니다.");
            return result;
        }
	    
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
	
	@Transactional
	public Map<String, Object> endAuctionEarlyWithPoint(Map<String, Object> paramMap) {
	    Map<String, Object> result = new HashMap<>();
	    
	    try {
	        // 1. 경매 상태 변경 (status: 0 -> 1, winner_seq 지정, 종료시간 갱신)
	        // paramMap에는 seq(경매번호), memberSeq(판매자번호)가 포함되어야 함
	        int updateResult = dao.endAuctionEarly(paramMap);
	        
	        if (updateResult > 0) {
	            // 2. 낙찰 정보 상세 조회 (최종 낙찰가, 낙찰자 번호, 판매자 번호)
	            int auctionSeq = Integer.parseInt(String.valueOf(paramMap.get("seq")));
	            Map<String, Object> winInfo = dao.getAuctionWinnerInfo(auctionSeq);
	            
	            if (winInfo != null) {
	                // 파라미터 재구성 (winnerSeq, sellerSeq, bidPrice 등)
	                winInfo.put("auctionSeq", auctionSeq);
	                
	                // 3. 낙찰자의 포인트 락 상태 변경 (status: 0 -> 2 [정산완료])
	                dao.updatePointLockToUsed(winInfo);
	                
	                // 4. 낙찰자의 실 보유 포인트 차감 (member 테이블)
	                dao.deductWinnerPoint(winInfo);
	                
	                // 5. 판매자의 실 보유 포인트 증가 (대금 지급)
	                dao.addSellerPoint(winInfo);
	                
	                result.put("status", "success");
	            }
	        } else {
	            result.put("status", "fail");
	            result.put("msg", "입찰자가 없거나 낙찰 처리 권한이 없습니다.");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("status", "error");
	        result.put("msg", "정산 처리 중 오류가 발생했습니다.");
	        throw new RuntimeException(e); // 트랜잭션 롤백 트리거
	    }
	    
	    return result;
	}
	
}


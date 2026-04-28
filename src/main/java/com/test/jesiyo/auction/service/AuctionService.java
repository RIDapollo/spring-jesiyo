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
	
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> placeBid(Map<String, Object> paramMap) {
		
		Map<String, Object> result = new HashMap<>();
		
		// 1. 파라미터 파싱
		int seq = Integer.parseInt(String.valueOf(paramMap.get("seq")));
		int bidPrice = Integer.parseInt(String.valueOf(paramMap.get("bidPrice")));
		int memberSeq = Integer.parseInt(String.valueOf(paramMap.get("memberSeq"))); 
		
		AuctionDto dtoHasHighestBid = dao.getHighestBid(seq);
		
		// 2. 경매 존재 여부 및 종료 상태 검증
		if (dtoHasHighestBid == null) {
			result.put("status", "fail");
			result.put("msg", "존재하지 않는 경매입니다.");
			return result;
		}
		if (dtoHasHighestBid.getStatus() != 0) {
			result.put("status", "fail");
			result.put("msg", "이미 종료된 경매입니다. 입찰할 수 없습니다.");
			return result;
		}

		// 3. 입찰 금액 유효성 검증
		Long highestBid = dtoHasHighestBid.getHighestBid();
		Integer highestBidMemberSeq = dtoHasHighestBid.getHighestBidMemberSeq(); // 이전 최고 입찰자 회원번호
		
		if (highestBid == null || highestBid == 0) {
			if (bidPrice < dtoHasHighestBid.getBidOpenPrice()) {
				result.put("status", "fail");
				result.put("msg", "첫 입찰은 시작 기준가(" + dtoHasHighestBid.getBidOpenPrice() + "원) 이상이어야 합니다.");
				return result;
			}
		} else {
			if (bidPrice <= highestBid) {
				result.put("status", "fail");
				result.put("msg", "현재 최고가(" + highestBid + "원)보다 높은 금액만 입찰 가능합니다.");
				return result;
			}
		}

		// 4. 가용 예치금 실시간 검증 (동일인 연속 입찰 보정)
		long availablePoint = dao.getAvailablePoint(memberSeq);
		
		// 내가 최고가 입찰자인 상태에서 금액을 더 올리는 경우, 
		// 기존에 묶인 내 돈(highestBid)은 어차피 풀릴 돈이므로 가용 예치금에 더해줍니다.
		if (highestBidMemberSeq != null && highestBidMemberSeq == memberSeq) {
			availablePoint += highestBid;
		}

		if (availablePoint < bidPrice) {
			result.put("status", "fail");
			result.put("msg", "가용 예치금이 부족합니다. (현재 가용액: " + availablePoint + "원)");
			return result;
		}

		// 5. 이전 최고 입찰자가 존재한다면: "먼저" 락 해제 및 패찰 처리
		if (highestBid != null && highestBid > 0) {
			Map<String, Object> unlockMap = new HashMap<>();
			unlockMap.put("previousMemberSeq", highestBidMemberSeq); 
			unlockMap.put("auctionSeq", seq);
			
			// 이전 입찰자의 point_lock 상태 변경 (status: 0 -> 1)
			dao.unlockPointLock(unlockMap);
		}
			
		// 6. 이전 입찰 내역 무효화 (status 1로 변경)
		dao.cancelPreviousBid(paramMap); 
		
		// 7. [순서 변경] 신규 입찰자의 예치금 락(Lock) "나중에" 생성
		// 먼저 1로 푼 다음에 0으로 Insert 해야, 동일인일 때 새롭게 넣은 락이 풀리는 현상을 막을 수 있습니다.
		paramMap.put("auctionSeq", seq); 
		int lockResult = dao.insertPointLock(paramMap);
		if (lockResult <= 0) {
			throw new RuntimeException("예치금 잠금 처리에 실패했습니다. (Rollback)");
		}
		
		// 8. 새로운 입찰 내역 Insert
		int insertResult = dao.bid(paramMap);
		if (insertResult <= 0) {
			throw new RuntimeException("입찰 기록 저장 중 오류가 발생했습니다. (Rollback)");
		}
				
		// 9. 성공 결과 반환
		result.put("status", "success");
		result.put("latestBids", dao.getLatestBids(seq));
		result.put("dtoHasHighestBid", dao.getHighestBid(seq)); 
			
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


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
		
Map<String, Object> result = new HashMap<>();
        
        // 1. 파라미터 파싱
        int auctionSeq = Integer.parseInt(String.valueOf(paramMap.get("seq"))); // 라이브 경매 식별자
        long bidPrice = Long.parseLong(String.valueOf(paramMap.get("bidPrice")));
        int memberSeq = Integer.parseInt(String.valueOf(paramMap.get("memberSeq")));

        // 2. 가용 예치금 실시간 검증
        // 쿼리: 총 예치금 - (point_lock에서 status=0 인 금액의 총합)
        long availablePoint = dao.getAvailablePoint(memberSeq);
        if (availablePoint < bidPrice) {
            result.put("status", "fail");
            result.put("msg", "가용 예치금이 부족합니다. (현재 가용액: " + availablePoint + "원)");
            return result;
        }

        // 3. 현재 최고가 입찰 내역 확인
        // 쿼리: live_bid_history에서 해당 경매의 status=0 인 단일 내역 조회
        LiveAuctionDto dtohasHighestBid = dao.getHighestBid(auctionSeq);
        if (dtohasHighestBid != null && dtohasHighestBid.getHighestBid() != null && bidPrice <= dtohasHighestBid.getHighestBid()) {
            result.put("status", "fail");
            result.put("msg", "현재 최고가보다 높은 금액만 입찰 가능합니다.");
            return result;
        }

        // 4. 신규 입찰자의 예치금 락(Lock) 생성
        // 파라미터 매핑을 위해 auctionSeq 명시 (Mapper의 #{auctionSeq}와 매칭)
        paramMap.put("auctionSeq", auctionSeq); 
        int lockResult = dao.insertPointLock(paramMap);
        if (lockResult <= 0) {
            result.put("status", "fail");
            result.put("msg", "예치금 잠금 처리에 실패했습니다.");
            return result; // 부분 실패 시 트랜잭션 롤백을 위해 RuntimeException을 던져도 무방합니다.
        }

        // 5. 이전 최고 입찰자가 존재한다면: 락 해제 및 패찰 처리
        if (dtohasHighestBid != null && dtohasHighestBid.getHighestBid() != null) {
            Map<String, Object> unlockMap = new HashMap<>();
            unlockMap.put("previousMemberSeq", dtohasHighestBid.getHighestBidMemberSeq());
            unlockMap.put("auctionSeq", auctionSeq); // 배타적 관계 컬럼 타겟팅용
            
            // 5-1. 이전 입찰자의 point_lock 상태 변경 (status: 0 -> 1)
            dao.unlockPointLock(unlockMap);
            
            // 5-2. 이전 입찰 내역 무효화 (status: 0 -> 1)
            paramMap.put("previousBidSeq", dtohasHighestBid.getSeq());
            dao.cancelPreviousLiveBid(paramMap); 
        }

        // 6. 새로운 입찰 내역 Insert
        int insertResult = dao.liveBid(paramMap);
        if (insertResult <= 0) {
            // DB 기록 실패 시 전체 과정을 강제 롤백시키기 위해 예외 발생
            throw new RuntimeException("입찰 기록 저장 중 오류가 발생했습니다. (Rollback)");
        }

        // 7. 성공 결과 반환 (프론트엔드 UI 갱신용 데이터 세팅)
        result.put("status", "success");
        result.put("latestBids", dao.getLatestLiveBids(auctionSeq)); 
        result.put("dtoHasHighestBid", dao.getHighestBid(auctionSeq)); 

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
	
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> completeLiveAuction(Map<String, Object> map) {
	    Map<String, Object> result = new HashMap<>();
	    
	    int auctionSeq = Integer.parseInt(map.get("auctionSeq").toString());
	    
	    // 1. 트랜잭션 내부에서 가장 정확한 '최종 최고가 입찰자' 정보 조회
	    LiveAuctionDto highestBidInfo = dao.getHighestBid(auctionSeq);
	    
	    String winnerId = "";
	    
	    // 2. 낙찰자가 존재하는 경우 (유찰이 아닌 경우) 정산 진행
	    if (highestBidInfo != null && highestBidInfo.getHighestBid() != null) {
	        winnerId = highestBidInfo.getHighestBidUserId(); // 프론트 전달용
	        
	        // 쿼리에 넘길 파라미터 세팅
	        map.put("winnerSeq", highestBidInfo.getHighestBidMemberSeq());
	        map.put("bidPrice", highestBidInfo.getHighestBid());
	        
	        // 3-1. 포인트 락 상태 변경 (0 -> 2)
	        int lockUpdate = dao.updatePointLockToUsed(map);
	        if (lockUpdate <= 0) {
	            throw new RuntimeException(
	                String.format("포인트 락 업데이트 0건 (Rollback) - 원인: 경매번호(%d)에 회원번호(%s)의 잠긴 예치금(status=0)이 없습니다.", 
	                auctionSeq, map.get("winnerSeq"))
	            );
	        }

	        // 3-2. 실제 회원 예치금 차감
	        int pointUpdate = dao.deductMemberPoint(map);
	        if (pointUpdate <= 0) {
	            throw new RuntimeException(
	                String.format("예치금 차감 0건 (Rollback) - 원인: 회원번호(%s)를 member 테이블에서 찾을 수 없습니다.", 
	                map.get("winnerSeq"))
	            );
	        }
	    
		    // 3. 스케줄 상태 업데이트 (방송 종료: status 2)
		    int scheduleRow = dao.completeLiveAuctionSchedule(map);
		    
		    // 4. 경매 본체 상태 업데이트 (낙찰자 기록 및 status 2)
		    int auctionRow = dao.updateLiveAuctionWinner(map);
		    
		    if (scheduleRow > 0 && auctionRow > 0) {
		        result.put("status", "success");
		        result.put("winnerId", winnerId); // 웹소켓 브로드캐스팅을 위해 컨트롤러로 반환
		    } else {
		        throw new RuntimeException("경매 종료 상태 변경 중 데이터 불일치 발생 (Rollback)");
		    }
		}
	    
	    return result;
	}

	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> resetLiveAuction(Map<String, Object> map) {
	    Map<String, Object> result = new HashMap<>();

	    int auctionSeq = Integer.parseInt(map.get("auctionSeq").toString());
	    int scheduleSeq = Integer.parseInt(map.get("scheduleSeq").toString());

	    // 1. 입찰 내역(live_bid_history) 삭제
	    dao.deleteLiveBidHistoryForReset(auctionSeq);
	    
	    // 2. 포인트 락(point_lock) 삭제 -> 돈이 묶인 회원들의 가용 예치금이 즉시 복구됨
	    dao.deletePointLockForReset(auctionSeq);
	    
	    // 3. 스케줄 상태 복구 (방송 중)
	    dao.updateScheduleToLive(scheduleSeq);
	    
	    // 4. 경매 상태 복구 (진행 중, 낙찰자 초기화)
	    dao.resetLiveAuctionStatus(auctionSeq);

	    result.put("status", "success");
	    return result;
	}
	
}

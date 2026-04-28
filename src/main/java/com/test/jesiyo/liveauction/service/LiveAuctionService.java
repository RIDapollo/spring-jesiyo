package com.test.jesiyo.liveauction.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.test.jesiyo.liveauction.dto.LiveAuctionDto;
import com.test.jesiyo.liveauction.dto.LiveBidDto;
import com.test.jesiyo.liveauction.repository.LiveAuctionDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class LiveAuctionService {

	private final LiveAuctionDao dao;
	
	// Redis & Redisson 의존성 주입
	private final RedissonClient redissonClient;
	private final RedisTemplate<String, Object> redisTemplate;
	
	// JSON 변환용 객체 추가
	private final ObjectMapper objectMapper = new ObjectMapper();
	
	// Redis Cache Keys
	private static final String HIGHEST_BID_KEY_PREFIX = "liveAuction:highestBid:";
	private static final String LATEST_BIDS_KEY_PREFIX = "liveAuction:latestBids:";
	
	public Map<String, Object> getCurrentSchedule() {
		
		return dao.getCurrentSchedule();
	}

	public LiveAuctionDto getDetail(int seq) {
		
		return dao.getDetail(seq);
	}
	
	//redis 적용
	public LiveAuctionDto getHighestBid(int seq) {
		
		// 1) Redis에서 최고가를 먼저 꺼내봅니다.
		Object cachedHighestStr = redisTemplate.opsForValue().get(HIGHEST_BID_KEY_PREFIX + seq);
		
		if (cachedHighestStr != null) {
			// 2) Redis에 값이 있다면, DB에 가지 않고 임시 DTO를 만들어 바로 리턴합니다.
			LiveAuctionDto dto = new LiveAuctionDto();
			dto.setHighestBid(Long.parseLong(cachedHighestStr.toString()));
			return dto;
		}
		
		// 3) Redis에 값이 없을 때(서버 초기화 직후 등)만 오라클 DB를 조회합니다.
		return dao.getHighestBid(seq);
	}	
	
//	public LiveAuctionDto getHighestBid(int seq) {
//		
//		return dao.getHighestBid(seq);
//	}

	public LiveBidDto getMyBid(Map<String, Object> map) {
		
		return dao.getMyBid(map);
	}
	
	//redis 적용버전
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> placeLiveBid(Map<String, Object> paramMap) {
		
		Map<String, Object> result = new HashMap<>();
		
		int auctionSeq = Integer.parseInt(String.valueOf(paramMap.get("seq")));
		long bidPrice = Long.parseLong(String.valueOf(paramMap.get("bidPrice")));
		int memberSeq = Integer.parseInt(String.valueOf(paramMap.get("memberSeq")));

		String highestBidKey = HIGHEST_BID_KEY_PREFIX + auctionSeq;

		// ==========================================
		// [1단계] Fail-Fast: Redis 캐시로 1차 차단 (DB 접근 X)
		// ==========================================
		Object cachedHighestStr = redisTemplate.opsForValue().get(highestBidKey);
		if (cachedHighestStr != null) {
			long cachedHighestBid = Long.parseLong(cachedHighestStr.toString());
			if (bidPrice <= cachedHighestBid) {
				result.put("status", "fail");
				result.put("msg", "현재 최고가보다 높은 금액만 입찰 가능합니다.");
				return result;
			}
		}

		// ==========================================
		// [2단계] Redisson 분산 락 획득 시도 (대기열 생성)
		// ==========================================
		String lockKey = "lock:liveAuction:" + auctionSeq;
		RLock lock = redissonClient.getLock(lockKey);

		try {
			// 최대 3초까지 락 획득 대기, 10초 후 자동 해제(Deadlock 방지)
			boolean isLocked = lock.tryLock(3, 10, TimeUnit.SECONDS);
			if (!isLocked) {
				result.put("status", "fail");
				result.put("msg", "현재 접속자가 많아 입찰이 지연되고 있습니다. 다시 시도해주세요.");
				return result;
			}

			// ==========================================
			// [3단계] Critical Section (DB 이중 검증 및 비즈니스 로직)
			// ==========================================
			
			// 1. DB 기준 최고가 재확인 (Double-Check)
			LiveAuctionDto dtohasHighestBid = dao.getHighestBid(auctionSeq);
			Long highestBid = null;
			Integer highestBidMemberSeq = null;
			
			if (dtohasHighestBid != null && dtohasHighestBid.getHighestBid() != null) {
				highestBid = dtohasHighestBid.getHighestBid();
				highestBidMemberSeq = dtohasHighestBid.getHighestBidMemberSeq();
			}

			if (highestBid != null && bidPrice <= highestBid) {
				result.put("status", "fail");
				result.put("msg", "현재 최고가보다 높은 금액만 입찰 가능합니다.");
				return result;
			}

			// 2. 가용 예치금 실시간 검증 (동일인 연속 입찰 보정 포함)
			long availablePoint = dao.getAvailablePoint(memberSeq);
			if (highestBidMemberSeq != null && highestBidMemberSeq == memberSeq) {
				availablePoint += highestBid;
			}

			if (availablePoint < bidPrice) {
				result.put("status", "fail");
				result.put("msg", "가용 예치금이 부족합니다. (현재 가용액: " + availablePoint + "원)");
				return result;
			}

			// 3. 이전 락 해제
			if (highestBid != null && highestBid > 0) {
				Map<String, Object> unlockMap = new HashMap<>();
				unlockMap.put("previousMemberSeq", highestBidMemberSeq);
				unlockMap.put("auctionSeq", auctionSeq); 
				dao.unlockPointLock(unlockMap);
				dao.cancelPreviousLiveBid(paramMap); 
			}

			// 4. 신규 락 생성
			paramMap.put("auctionSeq", auctionSeq); 
			int lockResult = dao.insertPointLock(paramMap);
			if (lockResult <= 0) throw new RuntimeException("예치금 잠금 처리에 실패했습니다.");

			// 5. 신규 입찰 기록 Insert
			int insertResult = dao.liveBid(paramMap);
			if (insertResult <= 0) throw new RuntimeException("입찰 기록 저장 중 오류가 발생했습니다.");

			// ==========================================
			// [4단계] 트랜잭션 성공 후 Redis 캐시 갱신
			// ==========================================
			redisTemplate.opsForValue().set(highestBidKey, String.valueOf(bidPrice), 2, TimeUnit.HOURS);
			
			List<LiveBidDto> latestBids = dao.getLatestLiveBids(auctionSeq);
			
			try {
			    String latestBidsJson = objectMapper.writeValueAsString(latestBids);
			    redisTemplate.opsForValue().set(LATEST_BIDS_KEY_PREFIX + auctionSeq, latestBidsJson, 2, TimeUnit.HOURS);
			} catch (JsonProcessingException e) {
			    // 변환 실패 시 로그만 찍고, 굳이 롤백시키지는 않습니다 (DB 저장은 성공했으므로)
			    e.printStackTrace(); 
			}

			// 결과 세팅
			result.put("status", "success");
			result.put("latestBids", latestBids); 
			result.put("dtoHasHighestBid", dao.getHighestBid(auctionSeq)); 

			return result;

		} catch (InterruptedException e) {
			Thread.currentThread().interrupt();
			result.put("status", "fail");
			result.put("msg", "서버 처리 중 지연이 발생했습니다.");
			return result;
		} finally {
			// 작업이 끝난 후 본인이 잡은 락 해제
			if (lock != null && lock.isLocked() && lock.isHeldByCurrentThread()) {
				lock.unlock();
			}
		}
	}
	
//	@Transactional(rollbackFor = Exception.class)
//	public Map<String, Object> placeLiveBid(Map<String, Object> paramMap) {
//	    
//	    Map<String, Object> result = new HashMap<>();
//	    
//	    int auctionSeq = Integer.parseInt(String.valueOf(paramMap.get("seq")));
//	    long bidPrice = Long.parseLong(String.valueOf(paramMap.get("bidPrice")));
//	    int memberSeq = Integer.parseInt(String.valueOf(paramMap.get("memberSeq")));
//
//	    // ==========================================
//	    // [순수 DB 로직 시작] 락 없이 바로 DB 조회 및 쓰기
//	    // ==========================================
//	    
//	    // 1. DB 기준 최고가 확인
//	    LiveAuctionDto dtohasHighestBid = dao.getHighestBid(auctionSeq);
//	    Long highestBid = null;
//	    Integer highestBidMemberSeq = null;
//	    
//	    if (dtohasHighestBid != null && dtohasHighestBid.getHighestBid() != null) {
//	        highestBid = dtohasHighestBid.getHighestBid();
//	        highestBidMemberSeq = dtohasHighestBid.getHighestBidMemberSeq();
//	    }
//
//	    if (highestBid != null && bidPrice <= highestBid) {
//	        result.put("status", "fail");
//	        result.put("msg", "현재 최고가보다 높은 금액만 입찰 가능합니다.");
//	        return result;
//	    }
//
//	    // 2. 가용 예치금 실시간 검증 (동일인 연속 입찰 보정 포함)
//	    long availablePoint = dao.getAvailablePoint(memberSeq);
//	    if (highestBidMemberSeq != null && highestBidMemberSeq == memberSeq) {
//	        availablePoint += highestBid;
//	    }
//
//	    if (availablePoint < bidPrice) {
//	        result.put("status", "fail");
//	        result.put("msg", "가용 예치금이 부족합니다. (현재 가용액: " + availablePoint + "원)");
//	        return result;
//	    }
//
//	    // 3. 이전 락 해제
//	    if (highestBid != null && highestBid > 0) {
//	        Map<String, Object> unlockMap = new HashMap<>();
//	        unlockMap.put("previousMemberSeq", highestBidMemberSeq);
//	        unlockMap.put("auctionSeq", auctionSeq); 
//	        dao.unlockPointLock(unlockMap);
//	        dao.cancelPreviousLiveBid(paramMap); 
//	    }
//
//	    // 4. 신규 락 생성
//	    paramMap.put("auctionSeq", auctionSeq); 
//	    int lockResult = dao.insertPointLock(paramMap);
//	    if (lockResult <= 0) throw new RuntimeException("예치금 잠금 처리에 실패했습니다.");
//
//	    // 5. 신규 입찰 기록 Insert
//	    int insertResult = dao.liveBid(paramMap);
//	    if (insertResult <= 0) throw new RuntimeException("입찰 기록 저장 중 오류가 발생했습니다.");
//
//	    // 결과 세팅 (DB에서 직접 최신 내역 조회)
//	    result.put("status", "success");
//	    result.put("latestBids", dao.getLatestLiveBids(auctionSeq)); 
//	    result.put("dtoHasHighestBid", dao.getHighestBid(auctionSeq)); 
//
//	    return result;
//	}
	
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

	//redis 적용버전
	@SuppressWarnings("unchecked")
	public List<LiveBidDto> getLatestLiveBids(int seq) {
		Object cachedBidsStr = redisTemplate.opsForValue().get(LATEST_BIDS_KEY_PREFIX + seq);
	    
	    if (cachedBidsStr != null) {
	        try {
	            // JSON 문자열을 List<LiveBidDto> 타입으로 복원
	            return objectMapper.readValue(
	                cachedBidsStr.toString(), 
	                objectMapper.getTypeFactory().constructCollectionType(List.class, LiveBidDto.class)
	            );
	        } catch (JsonProcessingException e) {
	            e.printStackTrace();
	        }
	    }
	    
	    // 캐시에 없거나 파싱 실패 시 DB에서 직접 조회
	    return dao.getLatestLiveBids(seq);
	}
	
//	public List<LiveBidDto> getLatestLiveBids(int seq) {
//		
//	    return dao.getLatestLiveBids(seq); // 무조건 DB SELECT 실행
//	}
	
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> completeLiveAuction(Map<String, Object> map) {
	    Map<String, Object> result = new HashMap<>();
	    
	    int auctionSeq = Integer.parseInt(map.get("auctionSeq").toString());
        redisTemplate.delete(HIGHEST_BID_KEY_PREFIX + auctionSeq);
        redisTemplate.delete(LATEST_BIDS_KEY_PREFIX + auctionSeq);
	    
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

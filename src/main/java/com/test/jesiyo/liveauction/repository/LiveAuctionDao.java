package com.test.jesiyo.liveauction.repository;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.auction.dto.BidDto;
import com.test.jesiyo.liveauction.dto.LiveAuctionDto;
import com.test.jesiyo.liveauction.dto.LiveBidDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class LiveAuctionDao {

	private final SqlSessionTemplate template;
	
	public Map<String, Object> getCurrentSchedule() {
		
		return template.selectOne("liveAuction.getCurrentSchedule");
	}

	public LiveAuctionDto getDetail(int seq) {
		
		return template.selectOne("liveAuction.getDetail", seq);
	}

	public LiveAuctionDto getHighestBid(int seq) {
		
		return template.selectOne("liveAuction.getHighestBid", seq);
	}

	public LiveBidDto getMyBid(Map<String, Object> map) {
		
		return template.selectOne("liveAuction.getMyBid", map);
	}

	public void cancelPreviousLiveBid(Map<String, Object> paramMap) {
		
		template.update("liveAuction.cancelPreviousLiveBid", paramMap);
	}

	public int liveBid(Map<String, Object> paramMap) {
		
		return template.insert("liveAuction.liveBid", paramMap);
	}

	public List<LiveBidDto> getLatestLiveBids(int seq) {
		
		return template.selectList("liveAuction.getLatestLiveBids", seq);
	}

	public int completeLiveAuctionSchedule(Map<String, Object> map) {
		
		return template.update("liveAuction.completeLiveAuctionSchedule", map);
	}

	public int updateLiveAuctionWinner(Map<String, Object> map) {
		
		return template.update("liveAuction.updateLiveAuctionWinner", map);
	}

	public LiveBidDto getCurrentHighestBidInfo(int auctionSeq) {
		
		return template.selectOne("liveAuction.getCurrentHighestBidInfo", auctionSeq);
	}

	public int updatePointLockToUsed(Map<String, Object> map) {
		
		return template.update("liveAuction.updatePointLockToUsed", map);
	}

	public int deductMemberPoint(Map<String, Object> map) {
		
		return template.update("liveAuction.deductMemberPoint", map);
	}

	public void unlockPointLock(Map<String, Object> unlockMap) {
		
		template.update("liveAuction.unlockPointLock", unlockMap);
	}

	public int insertPointLock(Map<String, Object> paramMap) {
		
		return template.insert("liveAuction.insertPointLock", paramMap);
	}

	public long getAvailablePoint(int memberSeq) {
		
		return template.selectOne("liveAuction.getAvailablePoint", memberSeq);
	}

	public void deleteLiveBidHistoryForReset(int auctionSeq) {
		
		template.delete("liveAuction.deleteLiveBidHistoryForReset", auctionSeq);
	}

	public void deletePointLockForReset(int auctionSeq) {
		
		template.delete("liveAuction.deletePointLockForReset", auctionSeq);
	}

	public void updateScheduleToLive(int scheduleSeq) {
		
		template.delete("liveAuction.updateScheduleToLive", scheduleSeq);
	}

	public void resetLiveAuctionStatus(int auctionSeq) {
		
		template.delete("liveAuction.resetLiveAuctionStatus", auctionSeq);
	}

}

package com.test.jesiyo.auction.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.auction.dto.AuctionDto;
import com.test.jesiyo.auction.dto.BidDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AuctionDao {

	private final SqlSessionTemplate template;

	public List<AuctionDto> list(HashMap<String, String> map) {
		
		return template.selectList("auction.list", map);
	}

	public int getTotalCount(HashMap<String, String> map) {
		
		return template.selectOne("auction.getTotalCount", map);
	}

	public void addAuction(HashMap<String, Object> map) {
		
		template.insert("auction.addAuction", map);
	}

	public void addMaster(HashMap<String, Object> map) {
		
		template.insert("auction.addMaster", map);
	}

	public AuctionDto getDetail(int seq) {
		
		return template.selectOne("auction.getDetail", seq);
	}

	public AuctionDto getHighestBid(int seq) {
		
		return template.selectOne("auction.getHighestBid", seq);
	}

	public int bid(Map<String, Object> map) {
		
		return template.insert("auction.bid", map);
	}

	public List<BidDto> getLatestBids(int seq) {
		
		return template.selectList("auction.getLatestBids", seq);
	}

	public void cancelPreviousBid(Map<String, Object> paramMap) {
		
		template.update("auction.cancelPreviousBid", paramMap);
	}

	public int cancelAuctionIfHasNoBids(Map<String, Object> paramMap) {
		
		return template.update("auction.cancelAuctionIfHasNoBids", paramMap);
	}

	public BidDto getMyBid(Map<String, Object> map) {
		
		return template.selectOne("auction.getMyBid", map);
	}

	public int getMyAuctionTotalCount(HashMap<String, String> map) {
		
		return template.selectOne("auction.getMyAuctionTotalCount", map);
	}

	public List<AuctionDto> getMyAuctionList(HashMap<String, String> map) {
		
		return template.selectList("auction.getMyAuctionList", map);
	}

	public int getMyBidTotalCount(HashMap<String, String> map) {
		
		return template.selectOne("auction.getMyBidTotalCount", map);
	}

	public List<AuctionDto> getMyBidList(HashMap<String, String> map) {
		
		return template.selectList("auction.getMyBidList", map);
	}
	
	public int endAuctionEarly(Map<String, Object> map) {
	    return template.update("auction.endAuctionEarly", map);
	}

	public Map<String, Object> getAuctionWinnerInfo(int seq) {
	    return template.selectOne("auction.getAuctionWinnerInfo", seq);
	}

	public void updatePointLockToUsed(Map<String, Object> map) {
	    template.update("auction.updatePointLockToUsed", map);
	}

	public void deductWinnerPoint(Map<String, Object> map) {
	    template.update("auction.deductWinnerPoint", map);
	}

	public void addSellerPoint(Map<String, Object> map) {
	    template.update("auction.addSellerPoint", map);
	}
	
	// 가용 예치금 실시간 조회 (총 예치금 - 묶인 금액)
	public long getAvailablePoint(int memberSeq) {
	    return template.selectOne("auction.getAvailablePoint", memberSeq);
	}

	// 신규 입찰자의 예치금 잠금(Lock) 등록
	public int insertPointLock(Map<String, Object> map) {
		return template.insert("auction.insertPointLock", map);
	}

	// 이전 최고 입찰자의 예치금 잠금 해제 (패찰 처리)
	public int unlockPointLock(Map<String, Object> map) {
		return template.update("auction.unlockPointLock", map);
	}
	
}

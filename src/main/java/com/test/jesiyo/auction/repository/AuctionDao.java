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
	
}

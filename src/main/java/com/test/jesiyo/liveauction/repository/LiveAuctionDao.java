package com.test.jesiyo.liveauction.repository;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.auction.dto.AuctionDto;
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

}

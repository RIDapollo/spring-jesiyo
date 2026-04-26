package com.test.jesiyo.liveauction.service;

import java.util.Map;

import org.springframework.stereotype.Service;

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

}

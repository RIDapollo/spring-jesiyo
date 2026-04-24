package com.test.jesiyo.auction.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.test.jesiyo.auction.dto.AuctionDto;
import com.test.jesiyo.auction.dto.MemberDto;
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

	public MemberDto getMdto(int i) {
		
		return dao.getMdto(1);
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
	
	
}


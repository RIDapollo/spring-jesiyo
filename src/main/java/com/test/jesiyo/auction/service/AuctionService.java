package com.test.jesiyo.auction.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Service;

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

	public Object add(HashMap<String, Object> map) {
		
		return dao.add(map);
	}
	
	
}


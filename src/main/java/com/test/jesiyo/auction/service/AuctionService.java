package com.test.jesiyo.auction.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.test.jesiyo.auction.dto.AuctionDto;
import com.test.jesiyo.auction.repository.AuctionDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuctionService {

	private final AuctionDao dao;

	public List<AuctionDto> list() {
		
		return dao.list();
	}
	
}


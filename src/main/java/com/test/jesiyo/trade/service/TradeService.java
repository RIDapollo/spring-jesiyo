package com.test.jesiyo.trade.service;

import org.springframework.stereotype.Service;

import com.test.jesiyo.trade.dto.TradeDto;
import com.test.jesiyo.trade.repository.TradeDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TradeService {

	private final TradeDao dao;
	
	public int add(TradeDto dto) {
	
		int result = dao.add(dto);
		
		return result;
	}
}

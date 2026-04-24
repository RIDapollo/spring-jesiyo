package com.test.jesiyo.location.service;

import org.springframework.stereotype.Service;

import com.test.jesiyo.location.dto.TradeLocationDto;
import com.test.jesiyo.location.repository.TradeLocationDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TradeLocationService {

	private final TradeLocationDao dao;
	
	public int add(TradeLocationDto dto) {
		
		return dao.add(dto);
	}
	
	public TradeLocationDto findBySeq(Long seq) {
        return dao.findBySeq(seq);
    }

    public TradeLocationDto findByDong(String dong) {
        return dao.findByDong(dong);
    }
}

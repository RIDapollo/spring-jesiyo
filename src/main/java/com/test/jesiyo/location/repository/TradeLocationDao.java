package com.test.jesiyo.location.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.location.dto.TradeLocationDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class TradeLocationDao {


	private final SqlSessionTemplate template;
	
	public int add(TradeLocationDto dto) {
		
		int result = template.insert("tradeLocation.add", dto);
		return result;
	}
	
	public TradeLocationDto findBySeq(Long seq) {
		
		TradeLocationDto dto = template.selectOne("tradeLocation.findBySeq", seq);
		return dto;
	}
	
	public TradeLocationDto findByDong(String dong) {
		
		TradeLocationDto dto = template.selectOne("tradeLocation.findByDong", dong);
		return dto;
	}
}

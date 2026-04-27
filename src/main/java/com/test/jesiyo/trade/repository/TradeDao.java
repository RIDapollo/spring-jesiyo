package com.test.jesiyo.trade.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.trade.dto.TradeDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class TradeDao {

	private final SqlSessionTemplate template;

	public int add(TradeDto dto) {
		return template.insert("trade.add", dto);
	}
	
}

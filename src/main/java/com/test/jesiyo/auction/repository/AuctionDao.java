package com.test.jesiyo.auction.repository;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.auction.dto.AuctionDto;

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
	
	
	
}

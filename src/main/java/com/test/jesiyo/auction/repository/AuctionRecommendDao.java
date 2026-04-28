package com.test.jesiyo.auction.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.auction.dto.AuctionDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AuctionRecommendDao {
	
	private final SqlSessionTemplate template;

	public List<AuctionDto> findTop2ByCategorySeqOrderByRegDateDesc(Long seq) {
		return template.selectList("auction-recommend.findTop2ByCategorySeqOrderByRegDateDesc", seq);
	}

}

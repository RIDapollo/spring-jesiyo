package com.test.jesiyo.directsale.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.directsale.dto.DirectSaleDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class DirectSaleRecommendDao {
	
	private final SqlSessionTemplate template;

	public List<DirectSaleDto> findTop2ByCategorySeqOrderByRegDateDesc(Long seq) {
		return template.selectList("directsale-recommend.findTop2ByCategorySeqOrderByRegDateDesc", seq);
	}

}

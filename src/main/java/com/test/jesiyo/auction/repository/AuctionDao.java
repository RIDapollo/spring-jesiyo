package com.test.jesiyo.auction.repository;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.auction.dto.AuctionDto;
import com.test.jesiyo.auction.dto.MemberDto;

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

	public MemberDto getMdto(int i) {
		
		return template.selectOne("auction.getMdto", 1);
	}

	public void addAuction(HashMap<String, Object> map) {
		
		template.insert("auction.addAuction", map);
	}

	public void addMaster(HashMap<String, Object> map) {
		
		template.insert("auction.addMaster", map);
	}
	
	
	
}

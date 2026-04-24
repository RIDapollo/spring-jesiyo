package com.test.jesiyo.directsale.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.directsale.dto.DirectSaleDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class DirectSaleDao {

	private final SqlSessionTemplate template;
	
	public List<DirectSaleDto> findAll() {
        return template.selectList("directsale.findAll");
    }

    public DirectSaleDto findBySeq(Long seq) {
        return template.selectOne("directsale.findBySeq", seq);
    }

    public int add(DirectSaleDto dto) {
        return template.insert("directsale.add", dto);
    }

    public int update(DirectSaleDto dto) {
        return template.update("directsale.update", dto);
    }

    public int delete(Long seq) {
        return template.delete("directsale.delete", seq);
    }
}

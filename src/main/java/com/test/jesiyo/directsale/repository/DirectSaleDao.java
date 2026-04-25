package com.test.jesiyo.directsale.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	public List<DirectSaleDto> getListByPage(int offset, int pageSize) {
		
		Map<String, Object> param = new HashMap<>();
	    param.put("offset", offset);
	    param.put("pageSize", pageSize);
		
		return template.selectList("directsale.getListByPage", param);
	}

	public DirectSaleDto getDetail(Long seq) {
		return template.selectOne("directsale.getDetail", seq);
	}
}

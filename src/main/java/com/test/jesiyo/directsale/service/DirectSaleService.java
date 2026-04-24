package com.test.jesiyo.directsale.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.test.jesiyo.directsale.dto.DirectSaleDto;
import com.test.jesiyo.directsale.repository.DirectSaleDao;
import com.test.jesiyo.directsale.util.TimeUtil;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DirectSaleService {

	private final DirectSaleDao dao;
	
    public List<DirectSaleDto> findAll() {
        return dao.findAll();
    }

    public DirectSaleDto findBySeq(Long seq) {
        return dao.findBySeq(seq);
    }

    public DirectSaleDto add(DirectSaleDto dto) {
    	
    	// image-url 널처리
    	if (dto.getImageUrl() == null || dto.getImageUrl().isEmpty()) {
    	    dto.setImageUrl("/upload/default_product.jpg");
    	}

        dao.add(dto);

        return dto;
    }

    public int update(DirectSaleDto dto) {
        return dao.update(dto);
    }
    
    public List<DirectSaleDto> getSaleList() {
        List<DirectSaleDto> list = dao.getSaleList();

        // 중고거래 등록 시간과 현재 시간 차이 구하기
		list.forEach(
			item -> item.setTimeAgo(TimeUtil.timeAgo(item.getCreatedAt()))
		);
        
        return list;
    }
    
    
    
}

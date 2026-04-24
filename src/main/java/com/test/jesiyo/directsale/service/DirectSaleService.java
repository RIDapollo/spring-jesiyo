package com.test.jesiyo.directsale.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.test.jesiyo.directsale.dto.DirectSaleDto;
import com.test.jesiyo.directsale.repository.DirectSaleDao;

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

        dao.add(dto);

        return dto;
    }

    public int update(DirectSaleDto dto) {
        return dao.update(dto);
    }
}

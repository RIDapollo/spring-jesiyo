package com.test.jesiyo.directsale.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.test.jesiyo.category.service.CategoryService;
import com.test.jesiyo.directsale.dto.DirectSaleDto;
import com.test.jesiyo.directsale.repository.DirectSaleDao;
import com.test.jesiyo.directsale.util.TimeUtil;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DirectSaleService {

	private final DirectSaleDao dao;
	private final CategoryService categoryService;
	
	// 페이징 처리 시 한번에 보여줄 도메인 수
    private static final int PAGE_SIZE = 12;

    public List<DirectSaleDto> findAll() {
        return dao.findAll();
    }

    public DirectSaleDto findBySeq(Long seq) {
        return dao.findBySeq(seq);
    }

    public DirectSaleDto add(DirectSaleDto dto) {
    	
    	// image-url 널처리
    	if (dto.getImageUrl() == null || dto.getImageUrl().isEmpty()) {
    	    dto.setImageUrl("/upload/default_image.png");
    	}

        dao.add(dto);

        return dto;
    }

    public int update(DirectSaleDto dto) {
        return dao.update(dto);
    }
    
    public List<DirectSaleDto> getListByPage(int page) {
    	int offset = page * PAGE_SIZE;
        
    	// 페이징처리한 중고거래 목록 가져오기
    	List<DirectSaleDto> list = dao.getListByPage(offset, PAGE_SIZE);

        // 중고거래 등록 시간과 현재 시간 차이 구하기
		list.forEach(
			item -> item.setTimeAgo(TimeUtil.timeAgo(item.getCreatedAt()))
		);
        
        return list;
    }

	public DirectSaleDto getDetail(Long seq) {
		
		DirectSaleDto dto = dao.getDetail(seq);
	
		// 중고거래 시간 표시 변환
		dto.setTimeAgo(TimeUtil.timeAgo(dto.getCreatedAt()));
		
		// 카테고리 경로 얻기
		dto.setCategoryPath(
			categoryService
				.getCategoryPath( dto.getCategorySeq().intValue()
			)
		);
		
		// TODO 나중에 주소 후처리 필요 (member.address 더미 값 보고 해야 함)
		
		return dto;
	}

	public int deleteByStatus(Long seq) {
		return dao.deleteByStatus(seq);
	}
    
    
    
}

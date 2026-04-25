package com.test.jesiyo.directsale.dto;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.type.Alias;

import com.test.jesiyo.category.dto.CategoryDto;

import lombok.Data;

@Alias("DirectSaleDto")
@Data
public class DirectSaleDto {
	private Long seq;
	private String name;
	private String description;
	private String status;
	private String productName;
	private String imageUrl;
	private Long price;
	private Date createdAt;
	private Long sellerSeq;
	private Long categorySeq;
	private Long tradeLocationSeq;
	
	// 목록 조회용 정보
	private String dong;
    private Double lat;
    private Double lng;
    private String timeAgo;			// N분전 / N일전
    
    // 상세 조회용 정보
    private String sellerNickname;	// 판매자 닉네임
    private String sellerAddress;	// 판매자 주소 (service에서 후처리 해야 함)
    // TODO 나중에 평점, 거래횟수 추가해야 함
    private Double sellerRating;	// 판매자 평점
    private int tradeCount;			//	판매 횟수
    private List<CategoryDto> categoryPath = new ArrayList<>();
}

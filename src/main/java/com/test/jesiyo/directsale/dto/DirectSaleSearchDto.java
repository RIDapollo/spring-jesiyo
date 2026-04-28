package com.test.jesiyo.directsale.dto;

import lombok.Data;

@Data
public class DirectSaleSearchDto {
    private Long categorySeq;
    private Integer minPrice;
    private Integer maxPrice;
    private int page;
    private String filterType; // ALL | DONG | DISTANCE
    
    private Long memberSeq;
    private String memberDong;
    private Double memberLat;
    private Double memberLng;
    private Integer distanceKm; // 기본 3km
}
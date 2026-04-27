package com.test.jesiyo.directsale.dto;

import lombok.Data;

@Data
public class DirectSaleSearchDto {
    private Long categorySeq;
    private Integer maxDistance;
    private Integer minPrice;
    private Integer maxPrice;
    private int page;
}
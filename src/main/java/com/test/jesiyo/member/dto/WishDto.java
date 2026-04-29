package com.test.jesiyo.member.dto;

import lombok.Data;

@Data
public class WishDto {
    private String wishSeq;   // 관심 목록 고유 번호
    private String itemName;  // 상품명
    private String cateSeq;
    private int price;        // 가격
    private String itemImg;   // 상품 이미지파일명
    private String itemType;  // 상품 타입 (중고: direct / 경매: auction)
}
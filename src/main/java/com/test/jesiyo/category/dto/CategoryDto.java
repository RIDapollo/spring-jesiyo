package com.test.jesiyo.category.dto;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("cDto")
public class CategoryDto {
	private Long seq;
	private String name;
	private int parentSeq;
	
	// 카테고리별 조회에 필요
	private List<CategoryDto> children = new ArrayList<>();
}

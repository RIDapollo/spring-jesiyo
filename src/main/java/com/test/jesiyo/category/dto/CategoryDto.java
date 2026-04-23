package com.test.jesiyo.category.dto;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("cDto")
public class CategoryDto {
	private Long seq;
	private String name;
	private int parentSeq;
}

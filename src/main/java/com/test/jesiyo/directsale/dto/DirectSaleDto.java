package com.test.jesiyo.directsale.dto;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Alias("DirectSaleDto")
@Data
public class DirectSaleDto {
	private Long seq;
	private String name;
}

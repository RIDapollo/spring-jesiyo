package com.test.jesiyo.location.dto;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Alias("TradeLocationDto")
@Data
public class TradeLocationDto {
	private Long seq;
	private String dong;
    private double lat;
    private double lng;
}

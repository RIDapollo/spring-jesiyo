package com.test.jesiyo.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.test.jesiyo.directsale.util.TimeUtil;
import com.test.jesiyo.trade.dto.TradeDto;
import com.test.jesiyo.trade.repository.TradeDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TradeService {

	private final TradeDao dao;
	
	public int add(TradeDto dto) {
	
		int result = dao.add(dto);
		
		return result;
	}

	public List<TradeDto> getTradeList(Long memberSeq, Long lastSeq) {
		List<TradeDto> list = dao.selectTradeList(memberSeq, lastSeq);
		
		list.forEach(
				trade -> trade.setTimeAgo(TimeUtil.timeAgo(trade.getCreatedAt()))
			);
		
        return list;
    }
}

package com.test.jesiyo.trade.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.trade.dto.TradeDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class TradeDao {

	private final SqlSessionTemplate template;

	public int add(TradeDto dto) {
		return template.insert("trade.add", dto);
	}

	public List<TradeDto> selectTradeList(Long memberSeq, Long lastSeq) {

        Map<String, Object> param = new HashMap<>();
        param.put("memberSeq", memberSeq);
        param.put("lastSeq", lastSeq);

        return template.selectList("trade.selectTradeList", param);
    }

	public int updateTradeToAccepted(Long tradeSeq) {
		return template.update("trade.updateTradeToAccepted", tradeSeq);
	}
	
	public int updateDirectStatus(Long tradeSeq) {
		return template.update("trade.updateDirectStatus", tradeSeq);	
	}
	
}

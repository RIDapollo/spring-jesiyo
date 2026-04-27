package com.test.jesiyo;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.test.jesiyo.trade.dto.TradeDto;
import com.test.jesiyo.trade.service.TradeService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml", "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
public class TradeTest {

	@Autowired
	TradeService service;
	
	@Test
	public void testTradeAdd() {
		// given
//		TradeDto tradeDto = new TradeDto();
//		tradeDto.setDirectSaleSeq(8L);
//		tradeDto.setSellerSeq(1L);
//		tradeDto.setBuyerSeq(2L);
//
//		// when
//		int result = service.add(tradeDto);
//
//		// then
//		System.out.println(result);
	}
	
	@Test
	public void testTradesList() {
		// given
//		List<TradeDto> list = service.getTradeList(5L, null);
//		System.out.println(list);
		// when

		// then

	}
	
	@Test
	public void testUpdateTradeStatus() {
		// when
		int result = service.acceptTrade(2L);
		System.out.println(result);

		// then

	}
}

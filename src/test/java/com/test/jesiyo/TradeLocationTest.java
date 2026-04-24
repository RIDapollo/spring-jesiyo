package com.test.jesiyo;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.test.jesiyo.directsale.dto.DirectSaleDto;
import com.test.jesiyo.directsale.service.DirectSaleService;
import com.test.jesiyo.location.dto.TradeLocationDto;
import com.test.jesiyo.location.service.TradeLocationService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml", "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
public class TradeLocationTest {

	@Autowired
	private TradeLocationService service;
	@Autowired
	private DirectSaleService directSaleService;
	
	@Test
	public void testfindOne() {
		// when
		TradeLocationDto dto = service.findBySeq(1L);

		System.out.println(dto);
	}
	
	@Test
	public void testAddDirectSale() {
		// given
		List<DirectSaleDto> list = directSaleService.findAll();
		
		for (int i =0 ; i < list.size(); i++) {
			System.out.println(list.get(i));
		}

		// when

		// then

	}
}

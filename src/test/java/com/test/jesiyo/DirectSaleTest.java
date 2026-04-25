package com.test.jesiyo;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.test.jesiyo.directsale.dto.DirectSaleDto;
import com.test.jesiyo.directsale.service.DirectSaleService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml", "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
public class DirectSaleTest {

	@Autowired
	private DirectSaleService directSaleService;
	
	@Test
	public void testDetails() {
		// given
		DirectSaleDto result = directSaleService.getDetail(7L);

		System.out.println(result.getTradeLocationDto());
	}
	
	@Test
	public void testfindAll() {
		// given
//		List<DirectSaleDto> list = directSaleService.findAll();
//		for (int i=0; i<list.size();i++) {
//			System.out.println(list.get(i).getSeq() + ":" + list.get(i).getTradeLocationSeq());
//		}
		// 6,7,8
	}
}

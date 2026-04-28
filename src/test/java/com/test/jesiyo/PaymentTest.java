package com.test.jesiyo;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.test.jesiyo.payment.service.PaymentService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml", "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"})
public class PaymentTest {

	@Autowired
	private PaymentService service;
	
	@Test
	public void testPaymentAdd() {
		// given
//		Long result = service.add(1L, 1000L);
//		System.out.println(result);
	}
	
	@Test
	public void updateChargeId() {
		// given
//		int result = service.updateChargeId(7L, "PAY-"+7);
//		System.out.println(result);
	}
}

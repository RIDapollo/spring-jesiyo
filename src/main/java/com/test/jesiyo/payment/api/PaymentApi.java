package com.test.jesiyo.payment.api;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.payment.service.PaymentService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class PaymentApi {

	private final PaymentService paymentService;
	
	@PostMapping("/payments/init")
	public Map<String, Object> initPayment(@RequestParam Long amount,
	                                        HttpSession session) {

	    MemberDto member = (MemberDto) session.getAttribute("user");

	    // 1. payment row 생성 (READY)
	    Long seq = paymentService.add(Long.valueOf(member.getSeq()), amount);

	    // 2. charge_id 생성 (Toss orderId)
	    String chargeId = "PAY-" + seq;

	    int result = paymentService.updateChargeId(seq, chargeId);

	    if (result != 1) {
	        throw new RuntimeException("charge_id 업데이트 실패");
	    }
	    
	    return Map.of("orderId", chargeId);
	}
}

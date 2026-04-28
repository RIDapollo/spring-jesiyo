package com.test.jesiyo.payment.controller;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.payment.service.PaymentService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class PaymentController {

	private final PaymentService service;
	
	// 1. 결제 초기화면 으로 이동
	@GetMapping("/payments/new")
	public String getPaymentPage(HttpSession session, Model model) {
		
		MemberDto loginMember = (MemberDto) session.getAttribute("user");
		if (loginMember != null) {
			model.addAttribute("memberPoint", loginMember.getPoint());
		}
		
		return "payments/add";
	}
	
	
	
	// 2. 토스 결제창에서 결제 성공시 화면 (orderId로)
	@GetMapping("/payments/success")
	public String paymentSuccess(
	        @RequestParam String paymentKey,
	        @RequestParam String orderId,
	        @RequestParam Long amount
	) {
	    // 1. 결제 승인 API 호출
		ResponseEntity<String> result = service.confirm(paymentKey, orderId, amount);
		// 2. 상태 변경
	    service.updateStatus(orderId, "DONE");
	    // 3. 포인트 지급
	    service.addPointByOrderId(orderId);
		
	    return "payments/success";
	}
}

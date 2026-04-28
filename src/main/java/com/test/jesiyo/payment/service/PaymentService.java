package com.test.jesiyo.payment.service;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.test.jesiyo.payment.repository.PaymentDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PaymentService {

	private final PaymentDao dao;
	
	@Transactional
	public ResponseEntity<String> confirm(String paymentKey, String orderId, Long amount) {

	    String url = "https://api.tosspayments.com/v1/payments/confirm";

	    HttpHeaders headers = new HttpHeaders();

	    String secretKey = "test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6"; // 서버 secret key

	    String auth = Base64.getEncoder()
	            .encodeToString((secretKey + ":").getBytes());

	    headers.set("Authorization", "Basic " + auth);
	    headers.setContentType(MediaType.APPLICATION_JSON);

	    Map<String, Object> body = new HashMap<>();
	    body.put("paymentKey", paymentKey);
	    body.put("orderId", orderId);
	    body.put("amount", amount);

	    HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

	    RestTemplate restTemplate = new RestTemplate();
	    ResponseEntity<String> response =
	            restTemplate.postForEntity(url, request, String.class);

//	    System.out.println("결제 승인 결과: " + response.getBody());
	    return response;
	}

	@Transactional
	public Long add(Long memberSeq, Long amount) {
		return dao.add(memberSeq, amount);
	}
	
	@Transactional
	public int updateChargeId(Long seq, String chargeId) {
		
        return dao.updateChargeId(seq, chargeId);
    }

	public void updateStatus(String orderId, String status) {
		dao.updateStatus(orderId, status);
	}
	
	// 포인트 지급
    public void addPointByOrderId(String orderId) {
        int result = dao.addPointByOrderId(orderId);
        if (result != 1) {
            throw new RuntimeException("포인트 지급 실패 or 중복 지급 시도");
        }
    }
}

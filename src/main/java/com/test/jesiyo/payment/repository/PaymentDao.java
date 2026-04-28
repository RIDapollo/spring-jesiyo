package com.test.jesiyo.payment.repository;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class PaymentDao {

	private final SqlSessionTemplate template;

	public Long add(Long memberSeq, Long amount) {

	    Map<String, Object> param = new HashMap<>();
	    param.put("memberSeq", memberSeq);
	    param.put("amount", amount);

	    template.insert("payment.add", param);

	    return ((Number) param.get("seq")).longValue();
	}
	
	public int updateChargeId(Long seq, String chargeId) {

        Map<String, Object> param = new HashMap<>();
        param.put("seq", seq);
        param.put("chargeId", chargeId);

        return template.update("payment.updateChargeId", param);
    }

	public Object updateStatus(String orderId, String status) {
        Map<String, Object> param = new HashMap<>();
        param.put("orderId", orderId);
        param.put("status", status);

        return template.update("payment.updateStatus", param);
	}
	
	public int addPointByOrderId(String orderId) {
        return template.update("payment.addPointByOrderId", orderId);
    }
}

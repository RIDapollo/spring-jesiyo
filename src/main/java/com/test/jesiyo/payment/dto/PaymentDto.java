package com.test.jesiyo.payment.dto;

import lombok.Data;

@Data
public class PaymentDto {
    private String paymentKey;
    private String orderId;
    private Integer amount;
}

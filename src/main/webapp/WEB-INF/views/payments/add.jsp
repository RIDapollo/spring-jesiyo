<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JesiYo</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
    <script src="https://js.tosspayments.com/v2/standard"></script>
</head>
<%@ include file="/WEB-INF/views/inc/header.jsp" %>
<body>


<div class="page-wrap flex justify-center">

    <div class="content-card card-pad w-full max-w-sm">
        <!-- 제목 -->
        <h2 class="section-title text-center mb-4">💰 포인트 충전</h2>
        
        <div class="text-center text-sm text-slate-500 mb-4">
            현재 보유 포인트: 
            <span class="font-bold text-slate-800">
                <fmt:formatNumber value="${memberPoint}" pattern="#,###" />
            </span> P
        </div>
        
        <!-- 금액 입력 -->
        <div class="mb-3">
            <input 
                type="number" 
                id="amount" 
                placeholder="충전 금액 입력 (원)" 
                class="w-full border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-brand-200"
            />
        </div>

        <!-- 빠른 금액 선택 -->
        <div class="flex gap-2 mb-4">
            <button class="btn-cancel text-xs flex-1" onclick="setAmount(1000)">1천</button>
            <button class="btn-cancel text-xs flex-1" onclick="setAmount(5000)">5천</button>
            <button class="btn-cancel text-xs flex-1" onclick="setAmount(10000)">1만</button>
        </div>

        <!-- 결제 버튼 -->
        <button id="payment-button" class="btn-brand w-full text-sm py-2">
            충전하기
        </button>
    </div>
</div>
    <script>
    function setAmount(val) {
        document.getElementById("amount").value = val;
    }

    // ------ SDK 초기화 ------
    
    const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
    const customerKey = "user_${sessionScope.user.seq}";
  
    const tossPayments = TossPayments(clientKey);
    const widgets = tossPayments.widgets({ customerKey });
  
    document.getElementById("payment-button").addEventListener("click", async () => {
  
      const amount = document.getElementById("amount").value;
  
      if (!amount || amount <= 0) {
        alert("금액을 입력해주세요.");
        return;
      }
  
      try {
        // 1️⃣ 서버에서 orderId 생성
        const res = await fetch("/jesiyo/api/payments/init", {
          method: "POST",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: new URLSearchParams({
            amount: amount
          })
        });
  
        const data = await res.json();
  
        // 2️⃣ 결제 금액 설정
        await widgets.setAmount({
          value: Number(amount),
          currency: "KRW"
        });
  
        // 3️⃣ 결제창 렌더링
        const paymentWindow = await widgets.renderPaymentWindow({
          variantKey: {
            paymentMethod: "DEFAULT",
            agreement: "AGREEMENT"
          }
        });
  
        // 4️⃣ 결제 요청 이벤트
        paymentWindow.on("paymentRequest", async () => {
  
          try {
            await widgets.requestPayment({
              orderId: data.orderId,
              orderName: "포인트 충전",
  
              successUrl: window.location.origin + "/jesiyo/payments/success",
              failUrl: window.location.origin + "/jesiyo/payments/fail"
            });
  
          } catch (error) {
            console.error(error);
            alert("결제 요청 실패");
          }
        });
  
      } catch (err) {
        console.error(err);
        alert("결제 초기화 실패");
      }
  
    });
	</script>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>JeSiYo</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
    <script src="https://js.tosspayments.com/v2/standard"></script>
  </head>
  <%@ include file="/WEB-INF/views/inc/header.jsp" %>
  <body class="bg-slate-50">
    <div class="page-wrap max-w-3xl">
    
    
      <!-- 결제하기 버튼 -->
      <button id="payment-button">결제하기</button>
    </div>
    
    
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
  	<script>
      // ------  SDK 초기화 ------
      // @docs https://docs.tosspayments.com/sdk/v2/js#토스페이먼츠-초기화
      const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
      const customerKey = "V0U2yLTEiXX7EPEOw8lgq";
      const tossPayments = TossPayments(clientKey);
      // 회원 결제
      // @docs https://docs.tosspayments.com/sdk/v2/js#tosspaymentswidgets
      const widgets = tossPayments.widgets({ customerKey });
      // 비회원 결제
      // const widgets = tossPayments.widgets({ customerKey: TossPayments.ANONYMOUS });

      document.getElementById("payment-button").addEventListener("click", async () => {
        // ------ 주문의 결제 금액 설정 ------
        // @docs https://docs.tosspayments.com/sdk/v2/js#widgetssetamount
        await widgets.setAmount({
          value: 1_000,
          currency: "KRW",
        });

        // ------ 결제창 렌더링 ------
        // @docs https://docs.tosspayments.com/sdk/v2/js#widgetsrenderpaymentwindow
        const paymentWindow = await widgets.renderPaymentWindow({
          variantKey: {
            paymentMethod: "DEFAULT",
            agreement: "AGREEMENT",
          },
        });

        // ------ 구매자가 결제수단을 선택하면 paymentRequest 이벤트가 발생해요 ------
        // @docs https://docs.tosspayments.com/sdk/v2/js#paymentwindowon
        paymentWindow.on("paymentRequest", async ({ paymentMethod }) => {
          console.log(paymentMethod); // 구매자가 선택한 결제수단 정보
          try {
            await widgets.requestPayment({
              orderId: "Bd7U_FhKE6qeDuYHcQlDu",
              orderName: "테스트 주문",
              successUrl: window.location.origin + "/jesiyo/payments/new/success",
              failUrl: window.location.origin + "/jesiyo/payments/new/fail",
            });
          } catch (error) {
            console.error(error);
          }
        });
      });
    </script>
  </body>
</html>
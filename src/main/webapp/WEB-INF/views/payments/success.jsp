<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제 완료</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<%@ include file="/WEB-INF/views/inc/header.jsp" %>
<body>

<div class="page-wrap flex justify-center items-center min-h-[60vh]">
    <div class="content-card card-pad text-center w-full max-w-md">

        <!-- 아이콘 -->
        <div class="mb-4">
            <div class="w-16 h-16 mx-auto rounded-full bg-point-100 flex items-center justify-center">
                <span class="text-3xl text-point-600">✔</span>
            </div>
        </div>
        <!-- 타이틀 -->
        <h2 class="section-title text-center">결제가 완료되었습니다 🎉</h2>
        <!-- 설명 -->
        <p class="section-desc text-center">
            <span id="countdown">5</span>초 뒤 마이페이지로 이동합니다.
        </p>

    </div>
</div>

  <script>
  let seconds = 5;
  // 카운트다운 표시
  const countdownEl = document.getElementById("countdown");
  const timer = setInterval(() => {
      seconds--;
      countdownEl.innerText = seconds;
  
      if (seconds <= 0) {
          clearInterval(timer);
          moveNow();
      }
  }, 1000);
  // 이동 함수
  function moveNow() {
      location.href = "/jesiyo/mypage"; // 원하는 URL로 변경
  }
  </script>

</body>
</html>
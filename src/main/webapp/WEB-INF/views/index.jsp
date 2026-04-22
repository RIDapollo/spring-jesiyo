<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 메인</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body class="bg-slate-50"> <%@ include file="/WEB-INF/views/inc/header.jsp" %>
    
    <div class="page-wrap">
        <div class="content-card card-pad bg-slate-50 border-brand-100 flex flex-col md:flex-row items-center justify-between mb-10">
            <div>
                <h1 class="text-3xl font-bold text-slate-700 mb-2">믿을 수 있는 우리 동네 중고거래</h1>
                <p class="text-slate-500 font-medium">동네 주민들과 가깝고 따뜻한 거래를 지금 시작해보세요.</p>
            </div>
            <button class="btn-brand mt-4 md:mt-0 shadow-lg shadow-brand-500/20">
                매물 등록하기
            </button>
        </div>

        <div class="mb-6">
            <h2 class="section-title text-slate-900">오늘의 인기 매물</h2>
            <p class="section-desc">우리 동네에서 가장 많이 본 상품들이에요.</p>
        </div>
        
        <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
            <article class="item-card">
                <div class="item-img-wrap">
                    <img src="https://images.unsplash.com/photo-1544244015-0cd4b3ff569d?q=80&w=500" alt="상품이미지" class="item-img">
                </div>
                <div class="item-info">
                    <h3 class="item-title">애플워치 SE2 미개봉 팝니다</h3>
                    <div class="item-price">250,000원</div>
                    <div class="item-meta">
                        <span>역삼동</span> • <span>10분 전</span>
                    </div>
                </div>
            </article>
            </div>
    </div>
    
    <script>
        // 자바스크립트 로직
    </script>
</body>
</html>
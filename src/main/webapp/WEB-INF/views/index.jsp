<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 메인</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
    
    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        body {
            background-color: #f8fafc; /* bg-slate-50 대체 */
            margin: 0;
            padding: 0;
        }
        
        /* 네비게이션 바와 정확히 동일한 너비(1200px)와 중앙 정렬을 보장합니다. */
        .page-wrap {
            width: 100%;
            max-width: 1200px; /* header-inner와 동일한 크기 */
            margin: 0 auto !important; /* 무조건 중앙 정렬 */
            padding: 40px 20px; /* 상하 40px, 좌우 20px 여백 */
        }
    </style>
</head>
<body> 
    <%@ include file="/WEB-INF/views/inc/header.jsp" %>
    
    <div class="page-wrap">
        
        <div class="bg-white border border-slate-200 rounded-2xl p-8 flex flex-col md:flex-row items-center justify-between mb-12 shadow-sm">
            <div>
                <h1 class="text-2xl md:text-3xl font-bold text-slate-800 mb-2">믿을 수 있는 우리 동네 중고거래</h1>
                <p class="text-slate-500 font-medium">동네 주민들과 가깝고 따뜻한 거래를 지금 시작해보세요.</p>
            </div>
            <button class="mt-6 md:mt-0 bg-[#FF8A3D] hover:bg-[#e07530] text-white font-bold py-3 px-6 rounded-lg transition-colors duration-200">
                매물 등록하기
            </button>
        </div>

        <div class="mb-6">
            <h2 class="text-xl font-bold text-slate-900 mb-1">오늘의 인기 매물</h2>
            <p class="text-sm text-slate-500">우리 동네에서 가장 많이 본 상품들이에요.</p>
        </div>
        
        <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
            <article class="cursor-pointer group">
                <div class="relative w-full aspect-square mb-3 overflow-hidden rounded-xl bg-slate-200 border border-slate-100">
                    <img src="https://images.unsplash.com/photo-1544244015-0cd4b3ff569d?q=80&w=500" 
                         alt="상품이미지" 
                         class="object-cover w-full h-full group-hover:scale-105 transition-transform duration-300">
                </div>
                <div class="px-1">
                    <h3 class="text-base text-slate-800 font-medium truncate mb-1">애플워치 SE2 미개봉 팝니다</h3>
                    <div class="text-lg font-bold text-slate-900 mb-1">250,000원</div>
                    <div class="text-xs text-slate-400">
                        <span>역삼동</span> • <span>10분 전</span>
                    </div>
                </div>
            </article>
        </div>
        
    </div>
    
</body>
<script>
    $(document).ready(function() {
        
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');

        if (msg === 'logout') {
            alert('로그아웃되었습니다. 이용해 주셔서 감사합니다!');
            

            history.replaceState({}, null, location.pathname);
        }
    });
</script>
</html>
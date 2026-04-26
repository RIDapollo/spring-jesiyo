<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>경매목록</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body class="bg-slate-50">
    <%@ include file="/WEB-INF/views/inc/header.jsp" %>

    <div class="page-wrap max-w-5xl mx-auto py-10">
    
        <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-6 gap-4">
            <div>
                <h1 class="main-title text-3xl font-bold text-slate-900 mb-2">경매 목록</h1>
                <p class="section-desc mb-0 text-slate-500">현재 진행 중인 경매 물품과 내 입찰 상태를 확인하세요.</p>
            </div>
            <div class="flex gap-2 w-full md:w-auto">
                <button class="btn flex-1 md:flex-none bg-white border border-slate-300 text-slate-700 hover:bg-slate-50 font-semibold px-4 py-2 rounded" onclick="location.href='/jesiyo/auction/myList'">내 경매 목록</button>
                <button class="btn flex-1 md:flex-none bg-white border border-slate-300 text-slate-700 hover:bg-slate-50 font-semibold px-4 py-2 rounded" onclick="location.href='/jesiyo/auction/myBidList'">내 입찰 목록</button>
            </div>
        </div>
        
        <!-- 검색창 -->
        <div class="bg-white border border-slate-200 rounded-xl shadow-sm p-4 mb-8">
            <form action="/jesiyo/auction" method="GET" class="flex gap-2 w-full">
                <input type="text" name="word" value="${word}" placeholder="경매 물품을 검색해 보세요" class="input input-bordered flex-1 focus:border-brand-500 focus:outline-none bg-slate-50 px-4 py-2 rounded" />
                <button type="submit" class="btn bg-brand-500 text-white font-bold w-24 rounded hover:bg-brand-600 transition-colors">검색</button>
            </form>
        </div>
        
        <!-- 목록 -->
        <div class="flex flex-col gap-4 mb-10">
            <c:if test="${empty list}">
                <div class="bg-white border border-slate-200 rounded-xl p-10 text-center text-slate-500">
                    현재 등록된 경매 물품이 없습니다.
                </div>
            </c:if>

            <c:if test="${not empty list}">
                <c:forEach items="${list}" var="dto">
                    <article class="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-sm hover:border-brand-400 hover:shadow-md transition-all cursor-pointer flex flex-col md:flex-row p-4 gap-6 ${dto.status != 0 ? 'opacity-70 grayscale-[30%]' : ''}" onclick="location.href='/jesiyo/auction/${dto.seq}'">
                        
                        <div class="w-full md:w-56 aspect-[4/3] bg-slate-200 rounded-lg overflow-hidden shrink-0 relative">
                            <c:choose>
                                <c:when test="${dto.status == 0}">
                                    <span class="absolute top-2 left-2 text-xs font-bold px-2 py-1 bg-brand-500 text-white rounded shadow-sm z-10">진행중</span>
                                </c:when>
                                <c:when test="${dto.status == 1}">
                                    <span class="absolute top-2 left-2 text-xs font-bold px-2 py-1 bg-slate-800 text-white rounded shadow-sm z-10">낙찰완료</span>
                                </c:when>
                                <c:when test="${dto.status == 2}">
                                    <span class="absolute top-2 left-2 text-xs font-bold px-2 py-1 bg-slate-800 text-white rounded shadow-sm z-10">유찰</span>
                                </c:when>
                                <c:when test="${dto.status == 3}">
                                    <span class="absolute top-2 left-2 text-xs font-bold px-2 py-1 bg-rose-500 text-white rounded shadow-sm z-10">취소됨</span>
                                </c:when>
                            </c:choose>
                            
                            <img src="${pageContext.request.contextPath}/upload/${dto.image}" alt="상품 이미지" class="w-full h-full object-cover transition-transform duration-300 hover:scale-105">
                        </div>

                        <div class="flex-1 flex flex-col justify-between py-1">
                            <div>
                                <div class="flex items-center gap-2 mb-2">
                                    <span class="text-xs font-semibold text-slate-500 bg-slate-100 border border-slate-200 px-2 py-0.5 rounded">${dto.categoryName}</span>
                                </div>
                                <h3 class="text-xl font-bold text-slate-800 mb-1 line-clamp-2">${dto.name}</h3>
                                <p class="text-sm text-slate-500">판매자: ${dto.sellerName}</p>
                            </div>
                            <div class="mt-4 md:mt-0 flex flex-col gap-1">
                                <span class="text-xs font-semibold text-slate-400">현재 최고 입찰가</span>
                                <div class="text-2xl font-black text-slate-900">
                                    <fmt:formatNumber value="${dto.highestBid == 0 ? dto.bidOpenPrice : dto.highestBid}" pattern="#,###"/>
                                    <span class="text-lg font-bold ml-1">원</span>
                                </div>
                            </div>
                        </div>

                        <div class="flex flex-row md:flex-col items-center md:items-end justify-between shrink-0 py-2 border-t md:border-t-0 md:border-l border-slate-100 pt-4 md:pt-2 md:pl-6 mt-2 md:mt-0 min-w-[160px]">
                            <div class="flex flex-col items-start md:items-end">
                                <span class="text-xs font-bold text-rose-500 mb-1">남은 시간</span>
                                <div class="font-mono text-xl font-bold text-slate-800 tracking-tight countdown-timer" data-end-time="${dto.endDate}" data-status="${dto.status}">
                                    ⏳ 계산중...
                                </div>
                            </div>
                            <div class="mt-0 md:mt-4">
                                <c:choose>
								    <%-- 1. 내가 입찰에 참여한 기록이 있는 경우 (myBidPrice가 세팅되어 있고 0보다 클 때) --%>
								    <c:when test="${not empty dto.myBidPrice and dto.myBidPrice > 0}">
								        <c:choose>
								            <c:when test="${dto.myBidPrice >= dto.highestBid}">
								                <span class="inline-flex items-center rounded-full bg-amber-50 border border-amber-200 px-3 py-1 text-sm font-bold text-amber-600">
								                    🏆 최고가 입찰 중
								                </span>
								            </c:when>
								            <c:otherwise>
								                <span class="inline-flex items-center rounded-full bg-slate-100 border border-slate-200 px-3 py-1 text-sm font-bold text-slate-500">
								                    🔵 패찰 (재입찰 필요)
								                </span>
								            </c:otherwise>
								        </c:choose>
								    </c:when>
								    
								    <%-- 2. 내가 입찰에 참여하지 않은 경우 (기존 로직) --%>
								    <c:otherwise>
								        <c:choose>
								            <c:when test="${dto.status == 0}">
								                <span class="inline-flex items-center rounded-full bg-brand-50 border border-brand-200 px-3 py-1 text-sm font-bold text-brand-600">
								                    입찰 가능
								                </span>
								            </c:when>
								            <c:otherwise>
								                <span class="inline-flex items-center rounded-full bg-slate-100 border border-slate-200 px-3 py-1 text-sm font-bold text-slate-500">
								                    종료됨
								                </span>
								            </c:otherwise>
								        </c:choose>
								    </c:otherwise>
								</c:choose>
                            </div>
                        </div>
                    </article>
                </c:forEach>
            </c:if>
        </div>
        
        <!-- 페이징 -->
        <div class="flex flex-col md:flex-row items-center justify-between mt-12 mb-10 relative">
            <div class="hidden md:block flex-1"></div>
            
            <div class="flex items-center border border-slate-200 rounded-lg overflow-hidden bg-white shadow-md">
                <c:set var="query" value="&word=${word}" />
            
                <c:choose>
                    <c:when test="${paging.n == 1}">
                        <span class="px-4 py-2 text-sm font-semibold text-slate-300 bg-slate-50 border-r border-slate-200 cursor-not-allowed">이전</span>
                    </c:when>
                    <c:otherwise>
                        <a href="/jesiyo/auction?page=${paging.n - 1}${query}" class="px-4 py-2 text-sm font-semibold text-slate-600 hover:bg-slate-50 border-r border-slate-200 transition-colors">이전</a>
                    </c:otherwise>
                </c:choose>
            
                <c:forEach var="i" begin="${paging.n}" end="${paging.n + paging.blockSize - 1}">
                    <c:if test="${i <= paging.totalPage}">
                        <c:choose>
                            <c:when test="${i == paging.nowPage}">
                                <span class="px-4 py-2 text-sm font-bold bg-slate-800 text-white border-r border-slate-200 z-10 shadow-inner">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="/jesiyo/auction?page=${i}${query}" class="px-4 py-2 text-sm font-semibold text-slate-600 hover:bg-brand-500 hover:text-white border-r border-slate-200 transition-all">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </c:forEach>
            
                <c:choose>
                    <c:when test="${paging.n + paging.blockSize > paging.totalPage}">
                        <span class="px-4 py-2 text-sm font-semibold text-slate-300 bg-slate-50 cursor-not-allowed">다음</span>
                    </c:when>
                    <c:otherwise>
                        <a href="/jesiyo/auction?page=${paging.n + paging.blockSize}${query}" class="px-4 py-2 text-sm font-semibold text-slate-600 hover:bg-slate-50 transition-colors">다음</a>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- 등록버튼 -->
            <div class="flex-1 flex justify-end mt-6 md:mt-0 w-full md:w-auto">
                <button onclick="location.href='/jesiyo/auction/add'" class="btn bg-brand-500 hover:bg-brand-600 text-white border-0 px-6 py-2.5 rounded-lg shadow-lg flex items-center gap-2 font-bold transition-all transform hover:-translate-y-0.5 active:scale-95">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd" />
                    </svg>
                    경매 등록
                </button>
            </div>
        </div>

    </div>
    
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
    <script>
    	//카운트다운
	    function updateTimers() {
	        $('.countdown-timer').each(function() {
	            const status = $(this).data('status');
	            if (status != 0) {
	                $(this).text("경매 종료").addClass('text-slate-400');
	                return;
	            }
	
	            let endDateStr = $(this).data('end-time');
	            endDateStr = String(endDateStr).replace(/-/g, '/').replace('T', ' '); 
	            const endTime = new Date(endDateStr).getTime();
	            const now = new Date().getTime();
	            const distance = endTime - now;
	
	            if (distance < 0) {
	                $(this).text("마감됨").addClass('text-slate-400');
	                return;
	            }
	
	            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
	            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
	            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
	
	            let displayStr = "⏳ ";
	            
	            // 텍스트 크기를 줄이는 HTML 태그 (Tailwind CSS의 text-sm 사용)
	            const unitDay = '<span class="text-sm font-medium ml-0.5 mr-1">일</span>';
	            const unitHour = '<span class="text-sm font-medium ml-0.5 mr-1">시간</span>';
	            const unitMin = '<span class="text-sm font-medium ml-0.5">분</span>';
	            
	            if (days > 0) {
	                // 24시간 이상 남았을 때
	                displayStr += days + unitDay + hours + unitHour;
	                $(this).removeClass('text-rose-500 text-rose-600 animate-pulse').addClass('text-slate-800');
	                
	            } else if (hours > 0) {
	                // 1시간 ~ 24시간 미만
	                displayStr += hours + unitHour + minutes + unitMin;
	                $(this).removeClass('text-slate-800 text-rose-600 animate-pulse').addClass('text-rose-500'); 
	                
	            } else {
	                // 1시간 미만 - 분 단위까지만 표시
	                displayStr += minutes + unitMin;
	                // 긴박함을 주기 위해 조금 더 진한 빨간색 + 깜빡임 효과 적용
	                $(this).removeClass('text-slate-800 text-rose-500').addClass('text-rose-600 animate-pulse'); 
	            }
	
	            // HTML 태그가 포함되어 있으므로 .html()을 사용
	            $(this).html(displayStr);
	        });
	    }
    	
	    setInterval(updateTimers, 60000);
        // 페이지 로드 즉시 1회 실행
        updateTimers();
    </script>
</body>
</html>
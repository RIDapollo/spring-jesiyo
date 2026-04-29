<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>나의 경매 목록</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body class="bg-slate-50 relative">
    <%@ include file="/WEB-INF/views/inc/header.jsp" %>

    <div class="page-wrap max-w-5xl mx-auto py-10">
        
        <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-8 gap-4">
            <div>
                <h1 class="main-title text-3xl font-bold text-slate-900 mb-2">나의 경매 목록</h1>
                <p class="section-desc text-slate-500 mb-0">내가 등록한 경매의 진행 상태와 입찰 내역을 확인하세요.</p>
            </div>
            <div class="flex gap-2 w-full md:w-auto">
                <button class="btn flex-1 md:flex-none bg-brand-500 text-white font-semibold px-4 py-2 rounded-lg" onclick="location.href='/jesiyo/auction/myList'">내 경매 목록</button>
                <button class="btn flex-1 md:flex-none bg-white border border-slate-300 text-slate-700 hover:bg-slate-50 font-semibold px-4 py-2 rounded-lg" onclick="location.href='/jesiyo/auction/myBidList'">내 입찰 목록</button>
            </div>
        </div>
        
        <div class="flex flex-col gap-4 mb-10">
            <c:if test="${empty list}">
                <div class="bg-white border border-slate-200 rounded-xl p-10 text-center text-slate-500">
                    등록한 경매 내역이 없습니다.
                </div>
            </c:if>

            <c:forEach items="${list}" var="dto">
                <article class="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-sm hover:border-brand-400 transition-all flex flex-col md:flex-row p-4 gap-6 ${dto.status != 0 ? 'opacity-70 grayscale-[30%]' : ''}">
                    
                    <div class="w-full md:w-48 aspect-[4/3] bg-slate-200 rounded-lg overflow-hidden shrink-0 relative cursor-pointer" onclick="location.href='/jesiyo/auction/${dto.seq}'">
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

                    <div class="flex-1 flex flex-col justify-between py-1 cursor-pointer" onclick="location.href='/jesiyo/auction/${dto.seq}'">
                        <div>
                            <div class="flex items-center gap-2 mb-2">
                                <span class="text-xs font-semibold text-slate-500 bg-slate-100 border border-slate-200 px-2 py-0.5 rounded">${dto.categoryName}</span>
                            </div>
                            <h3 class="text-xl font-bold text-slate-800 mb-1 line-clamp-2">${dto.name}</h3>
                            <p class="text-sm text-slate-500">판매자 번호: ${dto.createMemberSeq}</p>
                        </div>
                        <div class="mt-4 flex flex-col gap-1">
                            <span class="text-xs font-semibold text-slate-400">현재 최고 입찰가</span>
                            <div class="text-xl font-black text-slate-900"><fmt:formatNumber value="${dto.highestBid}" pattern="#,###" /><span class="text-base font-bold ml-1">원</span></div>
                        </div>
                    </div>

                    <div class="flex flex-row md:flex-col items-center md:items-end justify-center shrink-0 py-2 border-t md:border-t-0 md:border-l border-slate-100 pt-4 md:pt-2 md:pl-6 mt-2 md:mt-0 min-w-[160px] gap-3">
                        <div class="flex flex-col items-start md:items-end w-full">
                            <span class="text-xs font-bold text-rose-500 mb-1">남은 시간</span>
                            <div class="font-mono text-xl font-bold text-slate-800 tracking-tight countdown-timer" data-end-time="${dto.endDate}" data-status="${dto.status}">
                                ⏳ 계산중...
                            </div> 
                        </div>
                        <div class="w-full mt-auto">
                            <button type="button" onclick="deleteAuction(${dto.seq})" class="w-full btn bg-white border border-rose-200 text-rose-500 hover:bg-rose-50 px-4 py-2 text-sm font-bold rounded-lg transition-colors">
                                경매 취소
                            </button>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </div>

    </div>

    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
    <script>
        // 경매 삭제 로직
        async function deleteAuction(seq) {
            if (!confirm('경매를 삭제하시겠습니까?')) return;
    
            const response = await fetch(`${pageContext.request.contextPath}/auction/\${seq}`, { method: 'DELETE' });
            const result = await response.json();
    
            if (result.status === 'success') {
                alert('삭제되었습니다.');
                location.href = '/jesiyo/auction/myList'; 
            } else {
                alert(result.msg);
            }
        }

        // 실시간 카운트다운 로직
        function updateTimers() {
            $('.countdown-timer').each(function() {
                const status = $(this).data('status');
                if (status != 0) {
                    $(this).text("경매 종료").addClass('text-slate-400');
                    return;
                }
    
                let endDateStr = $(this).data('end-time');
                if (!endDateStr) return; // 데이터가 없을 경우 방어 코드
                
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
                
                const unitDay = '<span class="text-sm font-medium ml-0.5 mr-1">일</span>';
                const unitHour = '<span class="text-sm font-medium ml-0.5 mr-1">시간</span>';
                const unitMin = '<span class="text-sm font-medium ml-0.5">분</span>';
                
                if (days > 0) {
                    displayStr += days + unitDay + hours + unitHour;
                    $(this).removeClass('text-rose-500 text-rose-600 animate-pulse').addClass('text-slate-800');
                    
                } else if (hours > 0) {
                    displayStr += hours + unitHour + minutes + unitMin;
                    $(this).removeClass('text-slate-800 text-rose-600 animate-pulse').addClass('text-rose-500'); 
                    
                } else {
                    displayStr += minutes + unitMin;
                    $(this).removeClass('text-slate-800 text-rose-500').addClass('text-rose-600 animate-pulse'); 
                }
    
                $(this).html(displayStr);
            });
        }
        
        // 타이머 1분마다 갱신
        setInterval(updateTimers, 60000);
        // 페이지 로드 즉시 1회 실행
        updateTimers();
    </script>
</body>
</html>
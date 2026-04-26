<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내 입찰 목록</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body class="bg-slate-50 relative">
    <%@ include file="/WEB-INF/views/inc/header.jsp" %>

    <div class="page-wrap max-w-5xl mx-auto py-10">
        
        <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-8 gap-4">
            <div>
                <h1 class="main-title text-3xl font-bold text-slate-900 mb-2">내 입찰 목록</h1>
                <p class="section-desc text-slate-500 mb-0">현재 참여 중인 경매의 낙찰 성공 여부를 확인하세요.</p>
            </div>
            <div class="flex gap-2 w-full md:w-auto">
                <button class="btn flex-1 md:flex-none bg-white border border-slate-300 text-slate-700 hover:bg-slate-50 font-semibold px-4 py-2 rounded-lg" onclick="location.href='/jesiyo/auction/myList'">내 경매 목록</button>
                <button class="btn flex-1 md:flex-none bg-brand-500 text-white font-semibold px-4 py-2 rounded-lg" onclick="location.href='/jesiyo/auction/myBidList'">내 입찰 목록</button>
            </div>
        </div>
        
        <div class="flex flex-col gap-4 mb-10">
        	<c:if test="${empty list}">
			    <div class="bg-white border border-slate-200 rounded-xl p-10 text-center text-slate-500">
			        입찰 내역이 없습니다.
			    </div>
			</c:if>
            <c:forEach items="${list}" var="dto">
                <article class="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-sm hover:border-brand-400 transition-all flex flex-col md:flex-row p-4 gap-6">
                    
                    <div class="w-full md:w-48 aspect-[4/3] bg-slate-200 rounded-lg overflow-hidden shrink-0 relative cursor-pointer" onclick="location.href='/jesiyo/auction/${dto.auctionSeq}'">
                        <img src="${pageContext.request.contextPath}/upload/${dto.image}" alt="상품 이미지" class="w-full h-full object-cover">
                    </div>

                    <div class="flex-1 flex flex-col justify-between py-1 cursor-pointer" onclick="location.href='/jesiyo/auction/${dto.auctionSeq}'">
                        <div>
                            <div class="flex items-center gap-2 mb-2">
                                <span class="text-xs font-semibold text-slate-500 bg-slate-100 border border-slate-200 px-2 py-0.5 rounded">${dto.categoryName}</span>
                            </div>
                            <h3 class="text-xl font-bold text-slate-800 mb-1">${dto.name}</h3>
                            <p class="text-sm text-slate-500">판매자: ${dto.sellerName}</p>
                        </div>
                        <div class="mt-4 flex flex-col gap-1">
                            <span class="text-xs font-semibold text-brand-600">나의 입찰가</span>
                            <div class="text-xl font-black text-slate-900"><fmt:formatNumber value="${dto.myBidPrice}" pattern="#,###" /><span class="text-base font-bold ml-1">원</span></div>
                            <p class="text-xs text-slate-400 mt-1">현재 최고가: <fmt:formatNumber value="${dto.highestBid}" pattern="#,###" />원</p>
                        </div>
                    </div>

                    <div class="flex flex-row md:flex-col items-center md:items-end justify-center shrink-0 py-2 border-t md:border-t-0 md:border-l border-slate-100 pt-4 md:pt-2 md:pl-6 mt-2 md:mt-0 min-w-[180px] gap-3">
                        <div class="flex flex-col items-start md:items-end w-full">
                            <span class="text-xs font-bold text-rose-500 mb-1">남은 시간</span>
                            <div class="font-mono text-xl font-bold text-slate-800 tracking-tight">⏳ 12:45:10</div>
                        </div>
                        
                        <div class="w-full flex flex-col gap-2 mt-auto">
                            <c:choose>
                                <c:when test="${dto.myBidPrice >= dto.highestBid}">
                                    <div class="text-center w-full py-1.5 bg-amber-50 text-amber-600 border border-amber-200 rounded text-xs font-bold">
                                        🏆 최고가 입찰 중
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center w-full py-1.5 bg-slate-100 text-slate-500 border border-slate-200 rounded text-xs font-bold">
                                        🔵 패찰 (재입찰 필요)
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            
                            <button type="button" onclick="cancelMyBid(${dto.bidSeq})" class="w-full btn bg-white border border-slate-300 text-slate-600 hover:bg-slate-50 px-4 py-1.5 text-xs font-bold rounded">
                                입찰 취소
                            </button>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </div>
        
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 믿을 수 있는 중고거래 & 경매</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
    
    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        body { background-color: #f8fafc; margin: 0; padding: 0; font-family: 'Pretendard', sans-serif; }
        .page-wrap { width: 100%; max-width: 1200px; margin: 0 auto !important; padding: 40px 20px; }
        .item-card { transition: all 0.3s ease; }
        .item-card:hover { transform: translateY(-5px); }
    </style>
</head>
<body> 
    <%@ include file="/WEB-INF/views/inc/header.jsp" %>
    
    <div class="page-wrap">

        <%-- [섹션 1: 최근 거래] --%>
        <section class="mb-20">
            <div class="flex justify-between items-end mb-8 px-2 border-l-4 border-[#FF8A3D] pl-4">
                <div>
                    <h2 class="text-2xl font-black text-slate-900 mb-1">최근 등록된 거래</h2>
                    <p class="text-sm text-slate-500 font-medium">우리 동네에 지금 막 올라온 따끈따끈한 매물이에요.</p>
                </div>
                <a href="${pageContext.request.contextPath}/trades/list" class="text-sm font-bold text-slate-400 hover:text-[#FF8A3D] transition-colors flex items-center gap-1">
                    전체보기 <i class="fas fa-chevron-right text-[10px]"></i>
                </a>
            </div>
            
            <div class="grid grid-cols-2 md:grid-cols-4 gap-x-6 gap-y-10">
                <c:forEach items="${recentTrades}" var="trade">
                    <%-- DTO 필드 반영: trade.seq --%>
                    <article class="item-card cursor-pointer group" onclick="location.href='${pageContext.request.contextPath}/trades/view?seq=${trade.seq}'">
                        <div class="relative w-full aspect-square mb-4 overflow-hidden rounded-[1.5rem] bg-slate-100 border border-slate-100 shadow-sm">
                            <%-- DTO 필드 반영: trade.imageUrl --%>
                            <img src="${not empty trade.imageUrl ? trade.imageUrl : '/resources/img/no-image.png'}" 
                                 alt="상품이미지" 
                                 class="object-cover w-full h-full group-hover:scale-110 transition-transform duration-500">
                        </div>
                        <div class="px-1">
                            <%-- DTO 필드 반영: trade.productName --%>
                            <h3 class="text-base text-slate-800 font-bold truncate mb-1 group-hover:text-[#FF8A3D] transition-colors">${trade.productName}</h3>
                            <div class="text-lg font-black text-slate-900 mb-2">
                                <fmt:formatNumber value="${trade.price}" pattern="#,###" />원
                            </div>
                            <div class="flex items-center text-[11px] text-slate-400 font-bold">
                                <%-- DTO 필드 반영: trade.dong, trade.timeAgo --%>
                                <span>${trade.dong}</span>
                                <span class="mx-1.5 opacity-30 text-[8px]">|</span>
                                <span>${trade.timeAgo}</span>
                            </div>
                        </div>
                    </article>
                </c:forEach>
                
                <c:if test="${empty recentTrades}">
                    <div class="col-span-full py-20 text-center bg-white rounded-[2rem] border border-dashed border-slate-200">
                        <p class="text-slate-400 font-bold">최근 등록된 거래가 없습니다.</p>
                    </div>
                </c:if>
            </div>
        </section>

        <%-- [섹션 2: 최근 경매] --%>
        <section class="mb-20">
            <div class="flex justify-between items-end mb-8 px-2 border-l-4 border-slate-900 pl-4">
                <div>
                    <h2 class="text-2xl font-black text-slate-900 mb-1">최근 등록 경매</h2>
                    <p class="text-sm text-slate-500 font-medium">놓치면 아까운 득템 찬스! 지금 바로 입찰해보세요.</p>
                </div>
                <a href="${pageContext.request.contextPath}/auction/list" class="text-sm font-bold text-slate-400 hover:text-[#FF8A3D] transition-colors flex items-center gap-1">
                    경매 더보기 <i class="fas fa-chevron-right text-[10px]"></i>
                </a>
            </div>
            
            <div class="grid grid-cols-2 md:grid-cols-4 gap-x-6 gap-y-10">
                <c:forEach items="${recentAuctions}" var="auction">
                    <%-- DTO 필드 반영: auction.seq --%>
                    <article class="item-card cursor-pointer group" onclick="location.href='${pageContext.request.contextPath}/auction/view?seq=${auction.seq}'">
                        <div class="relative w-full aspect-square mb-4 overflow-hidden rounded-[1.5rem] bg-slate-900 border border-slate-100 shadow-sm">
                            <%-- DTO 필드 반영: auction.image --%>
                            <img src="${not empty auction.image ? auction.image : '/resources/img/no-image.png'}" 
                                 class="object-cover w-full h-full group-hover:scale-110 opacity-90 group-hover:opacity-100 transition-all duration-500">
                            <div class="absolute top-3 left-3 bg-red-500 text-white text-[10px] font-black px-3 py-1 rounded-full shadow-sm">
                                <i class="fas fa-gavel mr-1"></i> LIVE
                            </div>
                        </div>
                        <div class="px-1">
                            <%-- DTO 필드 반영: auction.name --%>
                            <h3 class="text-base text-slate-800 font-bold truncate mb-1 group-hover:text-[#FF8A3D] transition-colors">${auction.name}</h3>
                            <div class="flex flex-col">
                                <span class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">현재 입찰가</span>
                                <div class="text-lg font-black text-red-500 mb-1">
                                    <%-- DTO 필드 반영: auction.highestBid --%>
                                    <fmt:formatNumber value="${auction.highestBid > 0 ? auction.highestBid : auction.bidOpenPrice}" pattern="#,###" />원
                                </div>
                            </div>
                            <div class="text-[11px] text-slate-400 font-bold flex items-center gap-1">
                                <%-- DTO 필드 반영: auction.endDate --%>
                                <i class="far fa-clock"></i> ${auction.endDate} 마감
                            </div>
                        </div>
                    </article>
                </c:forEach>

                <c:if test="${empty recentAuctions}">
                    <div class="col-span-full py-20 text-center bg-white rounded-[2rem] border border-dashed border-slate-200">
                        <p class="text-slate-400 font-bold">진행 중인 경매가 없습니다.</p>
                    </div>
                </c:if>
            </div>
        </section>
        
    </div>
</body>
</html>
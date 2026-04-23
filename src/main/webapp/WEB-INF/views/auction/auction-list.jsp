<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>경매목록</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body>
    <%@ include file="/WEB-INF/views/inc/header.jsp" %>

    <div class="page-wrap max-w-5xl">
    
    <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-6 gap-4">
        <div>
            <h1 class="main-title text-3xl font-bold text-slate-900 mb-2">경매 목록</h1>
            <p class="section-desc mb-0">현재 진행 중인 경매 물품과 내 입찰 상태를 확인하세요.</p>
        </div>
        <div class="flex gap-2 w-full md:w-auto">
            <button class="btn flex-1 md:flex-none bg-white border border-slate-300 text-slate-700 hover:bg-slate-50 font-semibold" onclick="location.href='/jesiyo/auction/myList.do'">내 경매 목록</button>
            <button class="btn flex-1 md:flex-none bg-white border border-slate-300 text-slate-700 hover:bg-slate-50 font-semibold" onclick="location.href='/jesiyo/auction/myBidList.do'">내 입찰 목록</button>
        </div>
    </div>
    
    <!-- 검색창 -->
    <div class="bg-white border border-slate-200 rounded-xl shadow-sm p-4 mb-8">
        <form action="/jesiyo/auction/list.do" method="GET" class="flex gap-2 w-full">
            <input type="text" name="keyword" placeholder="경매 물품이나 카테고리를 검색해보세요" class="input input-bordered flex-1 focus:border-brand-500 focus:outline-none bg-slate-50" />
            <button type="submit" class="btn-brand w-24">검색</button>
        </form>
    </div>
    
    <!-- 경매목록 -->
    <c:forEach items="${list }" var="dto">
    <div class="flex flex-col gap-4 mb-10">
        
        <article class="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-sm hover:border-brand-400 hover:shadow-md transition-all cursor-pointer flex flex-col md:flex-row p-4 gap-6" onclick="location.href='/jesiyo/auction/detail.do?id=101'">
            
            <div class="w-full md:w-56 aspect-[4/3] bg-slate-200 rounded-lg overflow-hidden shrink-0 relative">
                <span class="absolute top-2 left-2 status-badge badge-auction shadow-sm z-10">진행중(구현예정)</span>
                <img src="${dto.image }" alt="상품 이미지" class="w-full h-full object-cover transition-transform duration-300 hover:scale-105">
            </div>

            <div class="flex-1 flex flex-col justify-between py-1">
                <div>
                    <div class="flex items-center gap-2 mb-2">
                        <span class="text-xs font-semibold text-slate-500 bg-slate-100 border border-slate-200 px-2 py-0.5 rounded">카테고리이름으로 변경예정: ${dto.categorySeq}</span>
                    </div>
                    <h3 class="text-xl font-bold text-slate-800 mb-1 line-clamp-2">${dto.name }</h3>
                    <p class="text-sm text-slate-500">판매자번호(판매자이름으로 변경예정): ${dto.createMemberSeq }</p>
                </div>
                <div class="mt-4 md:mt-0 flex flex-col gap-1">
                    <span class="text-xs font-semibold text-slate-400">현재 최고 입찰가</span>
                    <div class="text-2xl font-black text-slate-900">250,000(구현예정)<span class="text-lg font-bold ml-1">원</span></div>
                </div>
            </div>

            <div class="flex flex-row md:flex-col items-center md:items-end justify-between shrink-0 py-2 border-t md:border-t-0 md:border-l border-slate-100 pt-4 md:pt-2 md:pl-6 mt-2 md:mt-0 min-w-[160px]">
                <div class="flex flex-col items-start md:items-end">
                    <span class="text-xs font-bold text-rose-500 mb-1">남은 시간</span>
                    <div class="font-mono text-2xl font-bold text-slate-800 tracking-tight">
                        ⏳ 04:20:55(구현예정)
                    </div>
                </div>
                <div class="mt-0 md:mt-4">
                    <span class="inline-flex items-center rounded-full bg-brand-50 border border-brand-200 px-3 py-1 text-sm font-bold text-brand-600">
                        상태코드: ${dto.status} / 변경예정
                    </span>
                </div>
            </div>
        </article>
        </c:forEach>
    
        <!-- 참고자료 -->
        <!-- <article class="bg-slate-50 border border-slate-200 rounded-xl overflow-hidden cursor-pointer flex flex-col md:flex-row p-4 gap-6 opacity-70" onclick="location.href='/jesiyo/auction/detail.do?id=103'">
            <div class="w-full md:w-56 aspect-[4/3] bg-slate-200 rounded-lg overflow-hidden shrink-0 relative">
                <div class="absolute inset-0 bg-black/40 z-10 flex items-center justify-center">
                    <span class="text-white font-bold text-lg border-2 border-white px-4 py-1 rounded-md rotate-[-10deg]">낙찰 완료</span>
                </div>
                <img src="https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=400" alt="모니터" class="w-full h-full object-cover grayscale">
            </div>

            <div class="flex-1 flex flex-col justify-between py-1">
                <div>
                    <div class="flex items-center gap-2 mb-2">
                        <span class="text-xs font-semibold text-slate-500 bg-slate-100 border border-slate-200 px-2 py-0.5 rounded">가전/모니터</span>
                    </div>
                    <h3 class="text-xl font-bold text-slate-600 mb-1 line-clamp-2">27인치 듀얼 모니터 세트</h3>
                    <p class="text-sm text-slate-400">판매자: 재택근무러</p>
                </div>
                <div class="mt-4 md:mt-0 flex flex-col gap-1">
                    <span class="text-xs font-semibold text-slate-400">최종 낙찰가</span>
                    <div class="text-2xl font-black text-slate-500">180,000<span class="text-lg font-bold ml-1">원</span></div>
                </div>
            </div>

            <div class="flex flex-row md:flex-col items-center md:items-end justify-between shrink-0 py-2 border-t md:border-t-0 md:border-l border-slate-200 pt-4 md:pt-2 md:pl-6 mt-2 md:mt-0 min-w-[160px]">
                <div class="flex flex-col items-start md:items-end">
                    <span class="text-sm font-bold text-slate-500 mb-1">경매 종료</span>
                    <div class="text-sm font-medium text-slate-400">
                        2026.04.22 종료됨
                    </div>
                </div>
                <div class="mt-0 md:mt-4">
                    <span class="inline-flex items-center rounded-full bg-slate-200 px-3 py-1 text-sm font-bold text-slate-500">
                        종료됨
                    </span>
                </div>
            </div>
        </article> -->

    </div>
    
    
    <div class="flex flex-col md:flex-row items-center justify-between mt-12 mb-10 relative">
        
        <!-- 페이징 -->
        <div class="hidden md:block flex-1"></div>
        
        <div class="flex items-center border border-slate-200 rounded-lg overflow-hidden bg-white shadow-md">
            <c:set var="query" value="&word=${word}&status=${status}" />
        
            <c:choose>
                <c:when test="${paging.n == 1}">
                    <span class="px-4 py-2 text-sm font-semibold text-slate-300 bg-slate-50 border-r border-slate-200 cursor-not-allowed">이전</span>
                </c:when>
                <c:otherwise>
                    <a href="/jesiyo/auction.do?page=${paging.n - 1}${query}" 
                       class="px-4 py-2 text-sm font-semibold text-slate-600 hover:bg-slate-50 border-r border-slate-200 transition-colors">이전</a>
                </c:otherwise>
            </c:choose>
        
            <c:forEach var="i" begin="${paging.n}" end="${paging.n + paging.blockSize - 1}">
                <c:if test="${i <= paging.totalPage}">
                    <c:choose>
                        <c:when test="${i == paging.nowPage}">
                            <span class="px-4 py-2 text-sm font-bold bg-slate-800 text-white border-r border-slate-200 z-10 shadow-inner">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="/jesiyo/auction.do?page=${i}${query}" 
                               class="px-4 py-2 text-sm font-semibold text-slate-600 hover:bg-brand-500 hover:text-white border-r border-slate-200 transition-all">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </c:forEach>
        
            <c:choose>
                <c:when test="${paging.n + paging.blockSize > paging.totalPage}">
                    <span class="px-4 py-2 text-sm font-semibold text-slate-300 bg-slate-50 cursor-not-allowed">다음</span>
                </c:when>
                <c:otherwise>
                    <a href="/jesiyo/auction.do?page=${paging.n + paging.blockSize}${query}" 
                       class="px-4 py-2 text-sm font-semibold text-slate-600 hover:bg-slate-50 transition-colors">다음</a>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- 경매등록 -->
        <div class="flex-1 flex justify-end mt-6 md:mt-0 w-full md:w-auto">
            <button onclick="location.href='/jesiyo/auction/add'" 
                    class="btn bg-brand-500 hover:bg-brand-600 text-white border-0 px-6 py-2.5 rounded-lg shadow-lg flex items-center gap-2 font-bold transition-all transform hover:-translate-y-0.5 active:scale-95">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd" />
                </svg>
                경매 등록
            </button>
        </div>
    </div>
 
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
    <script>
    
    </script>
</body>
</html>







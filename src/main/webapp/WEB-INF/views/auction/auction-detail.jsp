<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>경매 상세 - ${dto.name}</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body class="bg-slate-50">
    <%@ include file="/WEB-INF/views/inc/header.jsp" %>

    <div class="page-wrap max-w-5xl mx-auto py-10">
        
        <div class="mb-8">
            <button onclick="history.back()" class="text-sm font-semibold text-slate-500 hover:text-slate-800 flex items-center gap-1 mb-4 transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" /></svg>
                목록으로 돌아가기
            </button>
            <div class="flex items-center gap-2 mb-3">
                <span class="text-xs font-bold text-brand-600 bg-brand-50 border border-brand-200 px-3 py-1 rounded-full">카테고리: ${dto.categorySeq}</span>
                <span class="text-xs font-bold text-slate-500 bg-slate-100 border border-slate-200 px-3 py-1 rounded-full">경매번호 #${dto.seq}</span>
            </div>
            <h1 class="text-3xl md:text-4xl font-bold text-slate-900 leading-tight">${dto.name}</h1>
        </div>

        <div class="flex flex-col lg:flex-row gap-8 mb-8">
            
            <div class="w-full lg:w-1/2 shrink-0">
                <div class="aspect-square bg-white border border-slate-200 rounded-2xl overflow-hidden shadow-sm relative">
                    <img src="${pageContext.request.contextPath}/upload/${dto.image}" alt="${dto.name}" class="w-full h-full object-cover">
                </div>
            </div>

            <div class="w-full lg:w-1/2 flex flex-col gap-4">
                
                <div class="grid grid-cols-2 gap-4">
                    <div class="bg-white border border-brand-200 rounded-xl p-5 shadow-sm flex flex-col justify-center">
                        <span class="block text-sm font-bold text-slate-500 mb-1">현재 최고 입찰가</span>
                        <div class="text-3xl font-black text-brand-600 tracking-tight">${dtoHasHighestBid.highestBid }<span class="text-lg font-bold text-slate-500 ml-1">원</span></div>
                        <p class="text-xs text-slate-400 mt-2 font-medium">시작 기준가: ${dto.bidOpenPrice}원</p>
                    </div>

                    <div class="bg-white border border-slate-200 rounded-xl p-5 shadow-sm flex flex-col items-center justify-center text-center">
                        <span class="block text-sm font-bold text-slate-500 mb-1">남은 시간</span>
                        <div class="text-2xl font-mono font-black text-rose-500 tracking-tighter">⏳ 04:20:55</div>
                        <span class="inline-block mt-2 text-xs font-bold px-2.5 py-1 bg-slate-100 text-slate-600 rounded">상태: 진행중</span>
                    </div>
                </div>

                <div class="bg-white border border-slate-200 rounded-xl p-5 shadow-sm flex-1 flex flex-col">
                    <div class="flex justify-between items-end mb-4 border-b border-slate-100 pb-2">
                        <span class="block text-sm font-bold text-slate-700">최근 입찰 기록 (TOP 5)</span>
                        <span class="text-xs font-semibold text-slate-400 animate-pulse">● 실시간 반영중</span>
                    </div>
                    
                    <ul class="flex flex-col gap-1 text-sm flex-1">
                        <li class="flex justify-between items-center py-2 px-1 hover:bg-slate-50 rounded">
                            <span class="text-slate-500 font-medium">user12***</span>
                            <span class="font-bold text-slate-800">250,000원</span>
                        </li>
                        <li class="flex justify-between items-center py-2 px-1 hover:bg-slate-50 rounded">
                            <span class="text-slate-500 font-medium">test99***</span>
                            <span class="font-bold text-slate-800">245,000원</span>
                        </li>
                        <li class="flex justify-between items-center py-2 px-1 hover:bg-slate-50 rounded">
                            <span class="text-slate-500 font-medium">hell***</span>
                            <span class="font-bold text-slate-800">230,000원</span>
                        </li>
                        </ul>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div class="bg-white border border-slate-200 rounded-xl p-4 shadow-sm flex flex-col justify-center">
                        <span class="block text-xs font-bold text-slate-500 mb-2">내 입찰 상태</span>
                        <div>
                            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 bg-blue-50 text-blue-600 rounded text-xs font-bold border border-blue-200">
                                자동 입찰 중
                            </span>
                            <div class="mt-1.5 text-sm font-bold text-slate-800">200,000원</div>
                            
                            </div>
                    </div>
                    
                    <div class="bg-white border border-slate-200 rounded-xl p-4 shadow-sm flex items-center gap-3">
                        <div class="w-10 h-10 bg-slate-200 rounded-full flex items-center justify-center text-slate-500 font-black text-lg">
                            👤
                        </div>
                        <div class="flex flex-col">
                            <span class="text-xs font-bold text-slate-500 mb-0.5">판매자</span>
                            <span class="text-sm font-bold text-slate-800">회원번호: ${dto.createMemberSeq}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-white border border-slate-200 rounded-xl shadow-sm overflow-hidden mb-10">
            <div class="bg-slate-50 px-6 py-4 border-b border-slate-200">
                <h3 class="text-lg font-bold text-slate-800">상품 상세 설명</h3>
            </div>
            <div class="p-6 md:p-8 text-slate-600 text-base leading-relaxed whitespace-pre-wrap min-h-[250px]">
                ${dto.description}
            </div>
        </div>

        <div class="flex flex-col md:flex-row justify-between items-center gap-4 bg-white border border-slate-200 rounded-xl p-4 shadow-sm sticky bottom-4 z-20">
            
            <div>
                <button type="button" class="btn bg-white border border-rose-200 text-rose-500 hover:bg-rose-50 px-6 font-bold">
                    🗑️ 경매 삭제
                </button>
            </div>
            
            <div class="flex flex-col md:flex-row gap-2 w-full md:w-auto">
                <button type="button" onclick="openAutoBidModal()" class="btn bg-slate-800 hover:bg-slate-900 text-white border-0 px-8 font-bold flex-1 md:flex-none shadow-md">
                    자동 입찰 등록
                </button>
                
                <button type="button" onclick="openBidModal()" class="btn bg-brand-500 hover:bg-brand-600 text-white border-0 px-8 font-bold flex-1 md:flex-none shadow-md text-lg">
                    ⚡ 일반 입찰 참여
                </button>
            </div>
        </div>
        
    </div>

    <script>
        function openBidModal() {
            alert('입찰 등록 모달창이 열립니다. (구현 예정)');
        }
        function openAutoBidModal() {
            alert('자동 입찰 모달창이 열립니다. (구현 예정)');
        }
    </script>
</body>
</html>
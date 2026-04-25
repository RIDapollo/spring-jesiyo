<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>LIVE AUCTION</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp"%>
    <style>
        /* 실시간 채팅 영역 스크롤바 커스텀 */
        .chat-scroll::-webkit-scrollbar { width: 6px; }
        .chat-scroll::-webkit-scrollbar-thumb { background-color: #cbd5e1; border-radius: 4px; }
    </style>
</head>
<body class="bg-slate-50 relative">
    <%@ include file="/WEB-INF/views/inc/header.jsp"%>

    <div class="page-wrap max-w-6xl mx-auto py-8">

        <div class="flex justify-between items-center mb-6 border-b border-slate-200 pb-4">
            <h1 class="text-3xl font-black text-rose-600 tracking-tight flex items-center gap-2">
                <span class="animate-pulse h-3 w-3 bg-rose-600 rounded-full inline-block"></span>
                LIVE AUCTION
            </h1>
            <div class="flex gap-2">
                <button class="btn bg-white border border-slate-300 text-slate-700 px-4 py-2 rounded-lg text-sm font-bold" onclick="location.href='/jesiyo/auction/live/myList'">나의 라이브 경매 목록</button>
                <button class="btn bg-slate-800 text-white px-4 py-2 rounded-lg text-sm font-bold" onclick="location.href='/jesiyo/auction/live/add'">라이브 경매 등록</button>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
            
            <div class="lg:col-span-8 flex flex-col gap-6">
                <div class="bg-black rounded-2xl overflow-hidden aspect-video relative shadow-lg flex items-center justify-center">
                    <span class="absolute top-4 left-4 bg-rose-600 text-white text-xs font-bold px-3 py-1 rounded-full z-10">LIVE 방송중</span>
                    <img src="${pageContext.request.contextPath}/upload/${dto.image}" alt="상품 이미지" class="w-full h-full object-contain opacity-90">
                </div>
                
                <div class="bg-white border border-slate-200 rounded-xl p-6 shadow-sm">
                    <div class="flex gap-2 mb-3">
                        <span class="text-xs font-bold text-slate-500 bg-slate-100 px-2 py-1 rounded">${dto.categoryName}</span>
                        <span class="text-xs font-bold text-slate-500 bg-slate-100 px-2 py-1 rounded">판매자: ${dto.sellerId}</span>
                    </div>
                    <h2 class="text-2xl font-bold text-slate-800 mb-4">${dto.name}</h2>
                    <p class="text-slate-600 text-sm whitespace-pre-wrap">${dto.description}</p>
                </div>
            </div>

            <div class="lg:col-span-4 flex flex-col gap-4 h-full">
                
                <div class="bg-white border border-slate-200 rounded-xl p-5 shadow-sm">
                    
                    <div class="mb-5 pb-5 border-b border-slate-100 text-center">
                        <span class="block text-sm font-bold text-slate-500 mb-1">실시간 최고 입찰가</span>
                        <div class="text-4xl font-black text-brand-600 tracking-tighter" id="liveHighestBid">
                            <fmt:formatNumber value="${dto.highestBid}" pattern="#,###" />원
                        </div>
                    </div>

                    <div class="flex justify-between items-center mb-4 bg-slate-50 p-3 rounded-lg border border-slate-100">
                        <div class="flex flex-col">
                            <span class="text-xs text-slate-500 font-bold">나의 입찰가</span>
                            <span class="text-lg font-bold text-slate-800"><fmt:formatNumber value="${myBidPrice}" pattern="#,###" />원</span>
                        </div>
                        <div>
                            <span id="liveMyBidStatus" class="inline-block text-xs font-bold px-2 py-1 bg-amber-100 text-amber-700 rounded">참여중</span>
                        </div>
                    </div>

                    <div class="flex flex-col gap-2">
                        <div class="flex gap-2">
                            <button class="flex-1 py-3 bg-white border border-brand-500 text-brand-600 font-bold rounded-lg hover:bg-brand-50 transition-colors" onclick="openModal('bidModal')">
                                직접 입력
                            </button>
                            <button class="flex-[2] py-3 bg-brand-500 text-white font-bold rounded-lg shadow-md hover:bg-brand-600 transition-colors flex justify-center items-center gap-1" onclick="quickBid()">
                                ⚡ 빠른 입찰 (+1만원)
                            </button>
                        </div>
                        <button class="w-full py-2 text-sm text-slate-500 font-bold underline mt-2" onclick="cancelLiveBid()">입찰 취소</button>
                    </div>
                </div>

                <div class="bg-rose-50 border border-rose-200 rounded-xl p-4 shadow-sm flex flex-col items-center justify-center">
                    <span class="text-xs font-bold text-rose-600 mb-1">낙찰 카운트다운</span>
                    <div class="text-3xl font-mono font-black text-rose-600 tracking-tight" id="liveTimer">
                        00:05:30
                    </div>
                </div>

                <div class="bg-white border border-slate-200 rounded-xl shadow-sm flex-1 flex flex-col min-h-[300px] overflow-hidden">
                    <div class="bg-slate-800 text-white px-4 py-2 text-sm font-bold flex justify-between items-center">
                        라이브 채팅
                        <span class="flex items-center gap-1 text-xs font-normal"><span class="h-2 w-2 bg-emerald-400 rounded-full inline-block"></span> 124명 시청중</span>
                    </div>
                    
                    <ul id="liveChatList" class="flex-1 overflow-y-auto p-4 flex flex-col gap-2 chat-scroll text-sm">
                        <li class="text-center my-2"><span class="bg-slate-100 text-slate-500 px-3 py-1 rounded-full text-xs">경매가 시작되었습니다.</span></li>
                        <li class="flex items-start gap-2">
                            <span class="font-bold text-slate-700 shrink-0">user123:</span>
                            <span class="text-slate-600">상태 깨끗한가요?</span>
                        </li>
                        <li class="flex items-start gap-2">
                            <span class="font-bold text-rose-500 shrink-0">입찰알림:</span>
                            <span class="text-slate-800 font-bold">tester님이 260,000원에 입찰했습니다!</span>
                        </li>
                    </ul>
                    
                    <div class="border-t border-slate-200 p-2 bg-slate-50 flex gap-2">
                        <input type="text" id="chatInput" class="flex-1 px-3 py-2 border border-slate-300 rounded text-sm focus:outline-none focus:border-brand-500" placeholder="메시지를 입력하세요...">
                        <button class="bg-slate-700 text-white px-4 py-2 rounded text-sm font-bold hover:bg-slate-800" onclick="sendChat()">전송</button>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script>
        function quickBid() {
            // 현재 최고가 + 단위금액(ex: 10000원)을 계산하여 즉시 입찰 요청하는 함수
            alert('빠른 입찰(현재가 + 1만원)을 요청합니다. (서버 연동 필요)');
        }
        function sendChat() {
            const input = document.getElementById('chatInput');
            if(input.value.trim() === '') return;
            // 웹소켓 채팅 전송 로직
            input.value = '';
        }
    </script>
</body>
</html>
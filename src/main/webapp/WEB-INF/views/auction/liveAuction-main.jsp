<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>LIVE AUCTION - ${dto.name}</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp"%>
    <style>
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
            <button class="btn bg-white border border-slate-300 text-slate-700 px-4 py-2 rounded-lg text-sm font-bold" onclick="location.href='/jesiyo/auction/myList'">나의 경매 목록</button>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
            
            <div class="lg:col-span-8 flex flex-col gap-6">
                
                <div class="bg-black rounded-2xl overflow-hidden aspect-video relative shadow-lg flex items-center justify-center">
                    <c:choose>
                        <c:when test="${schedule.BROADCAST_STATUS == 0}">
                            <span class="absolute top-4 left-4 bg-slate-700 text-white text-xs font-bold px-3 py-1 rounded-full z-10">방송 대기중</span>
                        </c:when>
                        <c:when test="${schedule.BROADCAST_STATUS == 1}">
                            <span class="absolute top-4 left-4 bg-rose-600 text-white text-xs font-bold px-3 py-1 rounded-full z-10 animate-pulse">LIVE 방송중</span>
                        </c:when>
                        <c:otherwise>
                            <span class="absolute top-4 left-4 bg-slate-800 text-white text-xs font-bold px-3 py-1 rounded-full z-10">종료된 방송</span>
                        </c:otherwise>
                    </c:choose>
                    <img src="${pageContext.request.contextPath}/upload/${dto.image}" alt="상품 이미지" class="w-full h-full object-contain opacity-90">
                    <c:if test="${schedule.BROADCAST_STATUS == 0}">
                        <div class="absolute inset-0 bg-black/60 flex flex-col items-center justify-center text-white z-20">
                            <i class="fas fa-video text-4xl mb-3 text-slate-400"></i>
                            <h3 class="text-xl font-bold mb-1">잠시 후 라이브 경매가 시작됩니다</h3>
                        </div>
                    </c:if>
                </div>
                
                <div class="bg-white border border-slate-200 rounded-xl p-6 shadow-sm">
                    <div class="flex gap-2 mb-3">
                        <span class="text-xs font-bold text-slate-500 bg-slate-100 px-2 py-1 rounded">${dto.categoryName}</span>
                        <span class="text-xs font-bold text-slate-500 bg-slate-100 px-2 py-1 rounded">판매자: ${dto.sellerId}</span>
                    </div>
                    <h2 class="text-2xl font-bold text-slate-800 mb-4">${dto.name}</h2>
                    <p class="text-slate-600 text-sm whitespace-pre-wrap">${dto.description}</p>
                </div>

                <div class="bg-white border border-slate-200 rounded-xl shadow-sm flex flex-col h-[400px] overflow-hidden">
                    <div class="bg-slate-800 text-white px-4 py-3 text-sm font-bold flex justify-between items-center">
                        라이브 채팅 참여하기
                        <span class="flex items-center gap-1 text-xs font-normal"><span class="h-2 w-2 bg-emerald-400 rounded-full inline-block animate-pulse"></span> 접속중</span>
                    </div>
                    <ul id="liveAuctionList" class="flex-1 overflow-y-auto p-4 flex flex-col gap-3 chat-scroll text-sm bg-slate-50">
                        <li class="text-center my-2 text-xs text-slate-400">바르고 고운 말을 사용해 주세요.</li>
                    </ul>
                    <div class="border-t border-slate-200 p-3 bg-white flex gap-2">
                        <input type="text" id="chatInput" class="flex-1 px-4 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:border-brand-500" placeholder="메시지를 입력하세요..." ${schedule.BROADCAST_STATUS != 1 ? 'disabled' : ''} onkeyup="if(event.keyCode==13) sendChat()">
                        <button class="bg-slate-800 text-white px-6 py-2 rounded-lg text-sm font-bold hover:bg-slate-900" onclick="sendChat()" ${schedule.BROADCAST_STATUS != 1 ? 'disabled' : ''}>전송</button>
                    </div>
                </div>

            </div>

            <div class="lg:col-span-4 flex flex-col gap-4 h-full">
                
                <div class="bg-white border border-slate-200 rounded-xl p-5 shadow-sm relative overflow-hidden">
                    <c:if test="${schedule.BROADCAST_STATUS != 1}">
                        <div class="absolute inset-0 bg-white/80 backdrop-blur-sm z-10 flex items-center justify-center">
                            <span class="bg-slate-800 text-white px-4 py-2 rounded-full font-bold shadow-lg">입찰 대기중</span>
                        </div>
                    </c:if>

                    <div class="mb-5 pb-5 border-b border-slate-100 text-center">
                        <span class="block text-sm font-bold text-slate-500 mb-1">실시간 최고 입찰가</span>
                        <div class="text-4xl font-black text-brand-600 tracking-tighter" id="liveHighestBid">
                            <fmt:formatNumber value="${dtoHasHighestBid.highestBid != null ? dtoHasHighestBid.highestBid : dto.bidOpenPrice}" pattern="#,###"/>원
                        </div>
                    </div>

                    <div class="flex justify-between items-center mb-4 bg-slate-50 p-3 rounded-lg border border-slate-100">
                        <div class="flex flex-col">
                            <span class="text-xs text-slate-500 font-bold">나의 입찰가</span>
                            <span class="text-lg font-bold text-slate-800" id="liveMyBidPrice"><fmt:formatNumber value="${myBidPrice}" pattern="#,###"/>원</span>
                        </div>
                    </div>

                    <div class="flex flex-col gap-2">
                        <div class="flex gap-2">
                            <button class="flex-1 py-3 bg-white border border-brand-500 text-brand-600 font-bold rounded-lg hover:bg-brand-50 transition-colors" onclick="directBid()">
                                직접 입력
                            </button>
                            <button class="flex-[2] py-3 bg-brand-500 text-white font-bold rounded-lg shadow-md hover:bg-brand-600 transition-colors flex justify-center items-center gap-1" onclick="quickBid()">
                                ⚡ 빠른 입찰 (+1만원)
                            </button>
                        </div>
                    </div>
                </div>

                <div class="${schedule.BROADCAST_STATUS == 0 ? 'bg-slate-800' : 'bg-rose-50 border border-rose-200'} rounded-xl p-4 shadow-sm flex flex-col items-center justify-center">
                    <span class="text-xs font-bold ${schedule.BROADCAST_STATUS == 0 ? 'text-slate-300' : 'text-rose-600'} mb-1">
                        ${schedule.BROADCAST_STATUS == 0 ? '방송 시작까지' : '방송 진행 시간'}
                    </span>
                    <div class="text-3xl font-mono font-black ${schedule.BROADCAST_STATUS == 0 ? 'text-white' : 'text-rose-600'} tracking-tight" id="liveTimer">
                        00:00:00
                    </div>
                </div>

                <div class="bg-white border border-slate-200 rounded-xl shadow-sm flex-1 flex flex-col min-h-[250px] overflow-hidden">
                    <div class="bg-slate-100 text-slate-600 px-4 py-2 text-sm font-bold border-b border-slate-200">
                        입찰 현황
                    </div>
                    <ul id="liveBidLogList" class="flex-1 overflow-y-auto p-4 flex flex-col gap-2 chat-scroll text-sm">
                        <li class="text-center text-xs text-slate-400">최근 입찰 내역이 여기에 표시됩니다.</li>
                    </ul>
                </div>

            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
    <script>
        // 기본 정보 세팅
        const auctionSeq = ${dto.seq};
        const loginUserId = "${not empty user ? user.id : '비회원'}";
        let currentHighestBid = ${dtoHasHighestBid.highestBid != null ? dtoHasHighestBid.highestBid : dto.bidOpenPrice};
        const liveStatus = ${schedule.BROADCAST_STATUS};

        // 타이머용 날짜 파싱
        let broadcastDateStr = "${schedule.BROADCAST_DATE}".replace(/-/g, '/').replace('T', ' ');
        const targetTime = new Date(broadcastDateStr).getTime();

        // 포맷팅 헬퍼
        function formatNumber(num) { return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); }

        // ==========================================
        // 1. 입찰 기능 로직 (AJAX)
        // ==========================================
        function processBid(bidAmount) {
            if (bidAmount <= currentHighestBid) {
                alert("현재 최고가보다 높은 금액을 입력해야 합니다.");
                return;
            }
            if (!confirm(formatNumber(bidAmount) + "원에 입찰하시겠습니까?")) return;

            // 백엔드 API로 입찰 요청 (POST: /auction/live/bid)
            fetch('/jesiyo/auction/live/bid', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    auctionSeq: auctionSeq,
                    bidPrice: bidAmount
                })
            })
            .then(res => res.json())
            .then(data => {
                if(data.success) {
                    alert("입찰 성공!");
                    currentHighestBid = bidAmount; // 프론트엔드 최고가 즉시 갱신
                    // 나의 입찰가 UI 갱신
                    document.getElementById('liveMyBidPrice').innerText = formatNumber(bidAmount) + "원";
                    fetchLiveBids(); // 전체 입찰 로그 및 최고가 갱신 트리거
                } else {
                    alert("입찰 실패: " + data.message);
                }
            })
            .catch(err => console.error("입찰 통신 에러", err));
        }

        // 빠른 입찰 (현재가 + 1만원)
        function quickBid() {
            const nextPrice = parseInt(currentHighestBid) + 10000;
            processBid(nextPrice);
        }

        // 직접 입력 입찰 (Prompt 사용, 추후 모달로 변경 가능)
        function directBid() {
            const input = prompt("입찰하실 금액을 숫자로만 입력해주세요.\n(현재 최고가: " + formatNumber(currentHighestBid) + "원)");
            if(input) {
                const amount = parseInt(input.replace(/,/g, ''));
                if(!isNaN(amount)) {
                    processBid(amount);
                } else {
                    alert("정확한 숫자를 입력해주세요.");
                }
            }
        }

        // 주기적 입찰 로그 갱신 (기존 코드 유지하되 타겟 ID 변경)
        async function fetchLiveBids() {
            if (liveStatus !== 1) return; 
            try {
                const response = await fetch('/jesiyo/auction/api/latest/' + auctionSeq);
                const data = await response.json();
                
                currentHighestBid = data.dtoHasHighestBid ? data.dtoHasHighestBid.highestBid : currentHighestBid;
                document.getElementById('liveHighestBid').innerText = formatNumber(currentHighestBid) + '원';

                const logList = document.getElementById('liveBidLogList');
                logList.innerHTML = '';
                
                data.latestBids.forEach(bid => {
                    const li = document.createElement('li');
                    li.className = "flex items-start justify-between border-b border-slate-100 pb-1";
                    li.innerHTML = `
                        <span class="font-bold text-slate-700">\${bid.userId}님</span>
                        <span class="text-rose-600 font-bold">\${formatNumber(bid.bidPrice)}원</span>
                    `;
                    logList.appendChild(li);
                });
            } catch (error) { console.error(error); }
        }

        // ==========================================
        // 2. 웹소켓 채팅 로직
        // ==========================================
        let socket;
        
        function connectWebSocket() {
            // 현재 호스트 동적 획득 (http -> ws)
            const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            const host = window.location.host;
            socket = new WebSocket(protocol + "//" + host + "/jesiyo/liveAuction");

            socket.onmessage = function(event) {
                const data = JSON.parse(event.data);
                const chatList = document.getElementById('liveAuctionList');
                
                // 내가 보낸 메시지인지 확인하여 스타일 분기
                const isMine = (data.userId === loginUserId);
                const alignClass = isMine ? "justify-end" : "justify-start";
                const bgClass = isMine ? "bg-brand-50 border-brand-100" : "bg-white border-slate-200";

                const li = document.createElement('li');
                li.className = "flex " + alignClass;
                li.innerHTML = `
                    <div class="max-w-[80%] flex flex-col \${isMine ? 'items-end' : 'items-start'}">
                        \${!isMine ? '<span class="text-xs font-bold text-slate-500 mb-1 ml-1">' + data.userId + '</span>' : ''}
                        <div class="border rounded-xl px-4 py-2 \${bgClass} text-slate-700 shadow-sm">
                            \${data.msg}
                        </div>
                    </div>
                `;
                chatList.appendChild(li);
                chatList.scrollTop = chatList.scrollHeight; // 스크롤 맨 아래로
            };
        }

        function sendChat() {
            const input = document.getElementById('chatInput');
            const message = input.value.trim();
            if(message === '') return;
            
            // JSON 형태로 아이디와 메시지 전송
            const payload = { userId: loginUserId, msg: message };
            socket.send(JSON.stringify(payload));
            
            input.value = '';
            input.focus();
        }

        // 타이머 함수 (기존과 동일)
        function updateLiveTimer() {
            const now = new Date().getTime();
            let distance;
            if (liveStatus === 0) {
                distance = targetTime - now;
                if (distance < 0) { document.getElementById('liveTimer').innerText = "곧 시작!"; return; }
            } else if (liveStatus === 1) {
                distance = now - targetTime; 
            } else {
                document.getElementById('liveTimer').innerText = "종료됨"; return;
            }
            const h = Math.floor((Math.abs(distance) % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const m = Math.floor((Math.abs(distance) % (1000 * 60 * 60)) / (1000 * 60));
            const s = Math.floor((Math.abs(distance) % (1000 * 60)) / 1000);
            document.getElementById('liveTimer').innerText = 
                String(h).padStart(2, '0') + ":" + String(m).padStart(2, '0') + ":" + String(s).padStart(2, '0');
        }

        // 초기화
        document.addEventListener('DOMContentLoaded', () => {
            updateLiveTimer();
            setInterval(updateLiveTimer, 1000);

            if (liveStatus === 1) {
                fetchLiveBids();
                setInterval(fetchLiveBids, 1000);
                connectWebSocket(); // 방송 중일 때만 웹소켓 연결
            }
        });
    </script>
</body>
</html>
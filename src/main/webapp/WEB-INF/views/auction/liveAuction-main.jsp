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

	<c:if test="${empty param.embed}">
    	<%@ include file="/WEB-INF/views/inc/header.jsp"%>
    </c:if>

    <div class="page-wrap max-w-6xl mx-auto py-8">

        <div class="flex justify-between items-center mb-6 border-b border-slate-200 pb-4 min-h-[4rem]">
            <div>
                <h1 class="text-3xl font-black text-rose-600 tracking-tight flex items-center gap-2">
                    <span class="animate-pulse h-3 w-3 bg-rose-600 rounded-full inline-block"></span>
                    LIVE AUCTION
                </h1>
            </div>
            
            <div class="flex gap-2 items-center">
                <c:if test="${user.seq == dto.createMemberSeq && schedule.BROADCAST_STATUS == 1}">
                <span>
                    <button class="px-5 py-2.5 bg-slate-900 text-white text-sm font-bold rounded-lg shadow-md hover:bg-black transition-all flex items-center gap-2" 
                            onclick="returnAuction()">
                        <i class="fas fa-gavel">초기화</i>
                    </button>
                </span>
                <span>
                    <button class="px-5 py-2.5 bg-slate-900 text-white text-sm font-bold rounded-lg shadow-md hover:bg-black transition-all flex items-center gap-2" 
                            onclick="finishAuction()">
                        <i class="fas fa-gavel">경매 낙찰 및 종료</i>
                    </button>
                </span>
                </c:if>
            </div>
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
                        <input type="text" id="chatInput" class="flex-1 px-4 py-2 border border-slate-300 rounded-lg text-sm focus:outline-none focus:border-brand-500" 
                            placeholder="${empty user ? '로그인 후 채팅에 참여할 수 있습니다.' : '메시지를 입력하세요...'}" 
                            ${(schedule.BROADCAST_STATUS != 1 || empty user) ? 'disabled' : ''} 
                            onkeyup="if(event.keyCode==13) sendChat()">
                        <button class="bg-slate-800 text-white px-6 py-2 rounded-lg text-sm font-bold hover:bg-slate-900 disabled:opacity-50" 
                            onclick="${empty user ? 'requireLogin()' : 'sendChat()'}" 
                            ${schedule.BROADCAST_STATUS != 1 ? 'disabled' : ''}>전송</button>
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
                            <fmt:formatNumber value="${(dtoHasHighestBid != null && dtoHasHighestBid.highestBid != null) ? dtoHasHighestBid.highestBid : dto.bidOpenPrice}" pattern="#,###"/>원
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
                            <button class="flex-1 py-3 bg-white border border-brand-500 text-brand-600 font-bold rounded-lg hover:bg-brand-50 transition-colors" onclick="openBidModal()">
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

    <div id="bidModal" class="hidden fixed inset-0 bg-black/60 z-50 flex items-center justify-center backdrop-blur-sm">
        <div class="bg-white rounded-2xl shadow-xl p-6 w-full max-w-sm">
            <h3 class="text-2xl font-black text-slate-800 mb-2">직접 입찰하기</h3>
            <p class="text-sm text-slate-500 mb-4 border-b border-slate-100 pb-4">
                현재 최고가: <span id="modalHighestBid" class="font-bold text-rose-600"><fmt:formatNumber value="${dtoHasHighestBid.highestBid != null ? dtoHasHighestBid.highestBid : dto.bidOpenPrice}" pattern="#,###"/></span>원
            </p>
            
            <div class="mb-5">
                <label class="block text-xs font-bold text-slate-500 mb-2">희망 입찰가 (원)</label>
                <input type="number" id="modalBidInput" class="w-full px-4 py-3 border border-slate-300 rounded-lg text-lg font-bold focus:outline-none focus:border-brand-500 focus:ring-2 focus:ring-brand-200 transition-all" placeholder="금액을 입력하세요" onkeyup="if(event.keyCode==13) submitModalBid()">
            </div>
            
            <div class="flex gap-2">
                <button class="flex-1 py-3 bg-slate-100 text-slate-600 font-bold rounded-lg hover:bg-slate-200 transition-colors" onclick="closeBidModal()">취소</button>
                <button class="flex-1 py-3 bg-brand-500 text-white font-bold rounded-lg shadow-md hover:bg-brand-600 transition-colors" onclick="submitModalBid()">입찰하기</button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
    <script>
	 	//  부모 채팅에서 온 명령어 수신
	    window.addEventListener('message', function(event) {
	        // 같은 origin 검증 (localhost:8080)
	        if (event.origin !== window.location.origin) return;
	        
	        const data = event.data;
	        if (data.type === 'AUCTION_COMMAND') {
	            console.log('부모 명령 수신:', data.action);
	            
	            if (data.action === 'quickBid') {
	                quickBid(); // 기존 빠른 입찰 함수 직접 호출
	            }
	        }
	    }, false);
    
        // 1. 기본 정보 세팅
        const auctionSeq = ${dto.seq};
        const isLoggedIn = ${not empty user}; 
        const loginUserId = "${not empty user ? user.userId : '비회원'}";
        let currentHighestBid = ${(dtoHasHighestBid != null && dtoHasHighestBid.highestBid != null) ? dtoHasHighestBid.highestBid : dto.bidOpenPrice};
        const liveStatus = ${schedule.BROADCAST_STATUS};

        // 타이머용 날짜 파싱
        let broadcastDateStr = "${schedule.BROADCAST_DATE}".replace(/-/g, '/').replace('T', ' ');
        const targetTime = new Date(broadcastDateStr).getTime();

        // 포맷팅 헬퍼
        function formatNumber(num) { return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); }

        // 로그인 체크 헬퍼
        function requireLogin() {
            if (confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
                location.href = '/jesiyo/member/login';
            }
        }

        // ==========================================
        // 2. 모달 제어 로직
        // ==========================================
        function openBidModal() {
            if (!isLoggedIn) { requireLogin(); return; }
            
            document.getElementById('bidModal').classList.remove('hidden');
            const input = document.getElementById('modalBidInput');
            input.value = parseInt(currentHighestBid) + 10000;
            input.focus();
        }

        function closeBidModal() {
            document.getElementById('bidModal').classList.add('hidden');
            document.getElementById('modalBidInput').value = '';
        }

        function submitModalBid() {
            const amountStr = document.getElementById('modalBidInput').value;
            if (!amountStr) {
                alert("입찰 금액을 입력해주세요.");
                return;
            }
            
            const amount = parseInt(amountStr.replace(/,/g, ''));
            if (isNaN(amount)) {
                alert("정확한 숫자를 입력해주세요.");
                return;
            }

            processBid(amount);
        }

        // ==========================================
        // 3. 입찰 기능 로직 (AJAX)
        // ==========================================
        function processBid(bidAmount) {
            if (bidAmount <= currentHighestBid) {
                alert("현재 최고가(" + formatNumber(currentHighestBid) + "원)보다 높은 금액을 입력해야 합니다.");
                return;
            }
            if (!confirm(formatNumber(bidAmount) + "원에 입찰하시겠습니까?")) return;
        
            fetch('/jesiyo/auction/live/bid', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    auctionSeq: auctionSeq,
                    bidPrice: bidAmount
                })
            })
            .then(res => {
                // 서버에서 JSON이 아닌 HTML 에러 페이지를 뱉을 경우를 대비한 방어 코드
                if (!res.ok) throw new Error("서버 응답 상태가 정상(200)이 아닙니다.");
                return res.json();
            })
            .then(data => {
                // [핵심] 여기서 isSuccess와 errorMsg 변수를 선언해주어야 아래에서 쓸 수 있습니다!
                const isSuccess = data.success === true || data.status === 'success';
                const errorMsg = data.message || data.msg || '서버에서 에러 사유를 보내지 않았습니다.';
        
                if(isSuccess) {
                    alert("입찰 성공!");
                    closeBidModal();
                    
                    // 화면 나의 입찰가 즉시 갱신
                    document.getElementById('liveMyBidPrice').innerText = formatNumber(bidAmount) + "원";
                    
                    // 웹소켓 브로드캐스팅 (다른 사람 화면도 갱신되도록)
                    if (socket && socket.readyState === WebSocket.OPEN) {
                        socket.send(JSON.stringify({ type: 'BID', msg: 'UPDATE_BIDS' }));
                    } else {
                        fetchLiveBids(); 
                    }
                } else {
                    // 위에서 선언한 errorMsg를 여기서 사용합니다.
                    alert("입찰 실패: " + errorMsg); 
                }
            })
            .catch(err => {
                console.error("입찰 통신 에러 상세 원인:", err);
                alert("입찰 처리 중 오류가 발생했습니다. 개발자 도구(F12) 콘솔을 확인해주세요.");
            });
        }

        // 빠른 입찰 (현재가 + 1만원)
        function quickBid() {
            if (!isLoggedIn) { requireLogin(); return; }
            const nextPrice = parseInt(currentHighestBid) + 10000;
            processBid(nextPrice);
        }

        // ==========================================
        // 4. 비동기 입찰 현황 갱신 로직
        // ==========================================
        async function fetchLiveBids() {
        	// 1. 방송 중일 때만 갱신
            if (liveStatus !== 1) return; 
            
            try {
                const response = await fetch('/jesiyo/auction/live/api/latest/' + auctionSeq);
                const data = await response.json();
                
                // 2. 최고가 갱신
                if (data.dtoHasHighestBid && data.dtoHasHighestBid.highestBid != null) {
                    currentHighestBid = data.dtoHasHighestBid.highestBid;
                } else {
                    currentHighestBid = ${dto.bidOpenPrice}; // JSP 변수: 입찰이 없으면 시작가 유지
                }
                
                const formattedHighest = formatNumber(currentHighestBid);
                document.getElementById('liveHighestBid').innerText = formattedHighest + '원';
                
                // 모달창이 열려있을 경우를 위한 업데이트
                const modalHighest = document.getElementById('modalHighestBidDisplay');
                if (modalHighest) modalHighest.innerText = formattedHighest;

                // 3. 입찰 로그(현황) 갱신
                const logList = document.getElementById('liveBidLogList');
                logList.innerHTML = ''; // 기존 목록 초기화
                
                // 데이터가 존재할 경우에만 forEach 실행
                if (data.latestBids && data.latestBids.length > 0) {
                    data.latestBids.forEach((bid, index) => {
                        // 가장 최근(0번째) 입찰에만 깜빡임 효과 부여
                        const isNew = (index === 0); 
                        const highlightClass = isNew ? 'bg-rose-50 animate-pulse' : 'hover:bg-slate-50';
                        
                        const li = document.createElement('li');
                        li.className = `flex items-start justify-between border-b border-slate-100 pb-2 pt-2 px-2 rounded transition-colors ${highlightClass}`;
                        
                        // [주의] 백틱 안에서 JS 변수를 쓸 때는 반드시 역슬래시(\)를 붙여야 합니다.
                        li.innerHTML = `
                            <span class="font-bold text-slate-700">\${bid.userId}님</span>
                            <span class="text-rose-600 font-bold">\${formatNumber(bid.bidPrice)}원</span>
                        `;
                        logList.appendChild(li);
                    });
                } else {
                    logList.innerHTML = '<li class="text-center text-xs text-slate-400 py-2">최근 입찰 내역이 없습니다.</li>';
                }
                
            } catch (error) { 
                console.error("입찰 현황 갱신 중 에러 발생:", error); 
            }
        }

        // ==========================================
        // 5. 웹소켓 채팅 및 입찰 알림 로직 (이벤트 드리븐)
        // ==========================================
        let socket;
        
        function connectWebSocket() {
            const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            const host = window.location.host;
            socket = new WebSocket(protocol + "//" + host + "/jesiyo/liveAuction");

            socket.onmessage = function(event) {
                const data = JSON.parse(event.data);

                // [핵심] 1. 경매 종료(낙찰) 신호 수신 시
                if (data.type === 'FINISH') {
                    const winnerId = data.winnerId;
                    
                    if (!winnerId || winnerId === '') {
                        alert("입찰자가 없어 유찰된 상태로 경매가 종료되었습니다.");
                    } else if (loginUserId === winnerId) {
                        alert("🎉 축하합니다! 최고가로 낙찰되셨습니다.");
                    } else {
                        alert("경매가 종료되었습니다. (낙찰자: " + winnerId + "님)");
                    }
                    
                    // 알림창 확인 버튼을 누르면 모두 목록 페이지로 강제 추방
                    location.href = '/jesiyo/auction/live'; // 실제 목록 URL로 변경해주세요
                    return;
                }

                // 2. 누군가 입찰 시 현황 갱신
                if (data.type === 'BID') {
                    fetchLiveBids();
                    return;
                }
                
                // 3. 일반 채팅 메시지 처리
                const chatList = document.getElementById('liveAuctionList');
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
                chatList.scrollTop = chatList.scrollHeight;
            };
        }

        function sendChat() {
            if (!isLoggedIn) { requireLogin(); return; }

            const input = document.getElementById('chatInput');
            const message = input.value.trim();
            if(message === '') return;
            
            // type: 'CHAT'을 추가하여 전송
            const payload = { type: 'CHAT', userId: loginUserId, msg: message };
            socket.send(JSON.stringify(payload));
            
            input.value = '';
            input.focus();
        }

        // ==========================================
        // 6. 타이머 함수
        // ==========================================
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

        // ==========================================
        // 7. 초기화
        // ==========================================
        document.addEventListener('DOMContentLoaded', () => {
            updateLiveTimer();
            setInterval(updateLiveTimer, 1000);

            if (liveStatus === 1) {
                fetchLiveBids();       // 최초 화면 로딩 시 1회 호출
                connectWebSocket();    // 방송 중일 때 웹소켓 연결
                // setInterval(fetchLiveBids, 1000); <-- (삭제됨) 더 이상 1초마다 무작정 갱신하지 않음
            }
        });
        
        // ==========================================
        // 8. 낙찰 및 경매 종료 (개설자 전용)
        // ==========================================
        function finishAuction() {
            if (!confirm("현재 최고가로 낙찰하고 경매를 종료하시겠습니까?")) return;

            fetch('/jesiyo/auction/live/finish', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    auctionSeq: auctionSeq,
                    scheduleSeq: ${schedule.SEQ} 
                })
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'success') {
                    // 서버 연산 성공 시, 다른 모든 접속자에게 'FINISH' 신호 브로드캐스팅
                    if (socket && socket.readyState === WebSocket.OPEN) {
                        socket.send(JSON.stringify({ 
                            type: 'FINISH', 
                            winnerId: data.winnerId 
                        }));
                    }
                    alert("경매가 성공적으로 종료되었습니다.");
                    location.href = '/jesiyo/auction/live'; // 개설자 본인도 목록으로 이동
                } else {
                    alert("종료 처리 실패: " + data.msg);
                }
            })
            .catch(err => console.error("통신 에러:", err));
        }
        
        //개발 테스트용 초기화
        function returnAuction() {
            if (!confirm("경매를 초기화하시겠습니까?\n(입찰 내역/포인트락 삭제 및 방송중 상태로 변경됩니다.)")) return;
            
            fetch('/jesiyo/auction/live/reset', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ 
                    auctionSeq: auctionSeq,
                    scheduleSeq: ${schedule.SEQ}  // 스케줄 상태 변경을 위해 함께 전송
                })
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'success') {
                    // 다른 접속자들에게 'RESET' 신호 전송
                    if (socket && socket.readyState === WebSocket.OPEN) {
                        socket.send(JSON.stringify({ type: 'RESET', msg: '경매가 초기화되었습니다.' }));
                    }
                    alert("경매가 성공적으로 초기화되었습니다.");
                    location.reload(); // 방장 본인 화면 새로고침
                } else {
                    alert("초기화 실패: " + data.msg);
                }
            })
            .catch(err => console.error("초기화 통신 에러:", err));
        }
    </script>
</body>
</html>
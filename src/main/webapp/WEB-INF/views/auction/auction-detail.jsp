<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>경매 상세 - ${dto.name}</title>
<%@ include file="/WEB-INF/views/inc/asset.jsp"%>
</head>
<body class="bg-slate-50 relative">
	<%@ include file="/WEB-INF/views/inc/header.jsp"%>

	<div class="page-wrap max-w-5xl mx-auto py-10">

		<div class="mb-8">
			<button onclick="history.back()"
				class="text-sm font-semibold text-slate-500 hover:text-slate-800 flex items-center gap-1 mb-4 transition-colors">
				<svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none"
					viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round"
						stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" /></svg>
				목록으로 돌아가기
			</button>
			<div class="flex items-center gap-2 mb-3">
				<span
					class="text-xs font-bold text-brand-600 bg-brand-50 border border-brand-200 px-3 py-1 rounded-full">카테고리:
					${dto.categorySeq}</span> <span
					class="text-xs font-bold text-slate-500 bg-slate-100 border border-slate-200 px-3 py-1 rounded-full">경매번호
					#${dto.seq}</span>
			</div>
			<h1
				class="text-3xl md:text-4xl font-bold text-slate-900 leading-tight">${dto.name}</h1>
		</div>

		<div class="flex flex-col lg:flex-row gap-8 mb-8">

			<div class="w-full lg:w-1/2 shrink-0">
				<div
					class="aspect-square bg-white border border-slate-200 rounded-2xl overflow-hidden shadow-sm relative">
					<img src="${pageContext.request.contextPath}/upload/${dto.image}"
						alt="${dto.name}" class="w-full h-full object-cover">
				</div>
			</div>

			<div class="w-full lg:w-1/2 flex flex-col gap-4">

				<div class="grid grid-cols-2 gap-4">
					<div
						class="bg-white border border-brand-200 rounded-xl p-5 shadow-sm flex flex-col justify-center">
						<span class="block text-sm font-bold text-slate-500 mb-1">현재
							최고 입찰가</span>
						<div class="text-3xl font-black text-brand-600 tracking-tight">
							<span id="displayHighestBid"><fmt:formatNumber
									value="${dtoHasHighestBid.highestBid}" pattern="#,###" /></span><span
								class="text-lg font-bold text-slate-500 ml-1">원</span>
						</div>
						<p class="text-xs text-slate-400 mt-2 font-medium">시작 기준가:
							${dto.bidOpenPrice}원</p>
					</div>

					<div
						class="bg-white border border-slate-200 rounded-xl p-5 shadow-sm flex flex-col items-center justify-center text-center">
						<span class="block text-sm font-bold text-slate-500 mb-1">남은
							시간</span>
						<div
							class="text-2xl font-mono font-black text-rose-500 tracking-tighter">⏳
							04:20:55</div>
						<span
							class="inline-block mt-2 text-xs font-bold px-2.5 py-1 bg-slate-100 text-slate-600 rounded">상태:
							진행중</span>
					</div>
				</div>

				<div
					class="bg-white border border-slate-200 rounded-xl p-5 shadow-sm flex-1 flex flex-col">
					<div
						class="flex justify-between items-end mb-4 border-b border-slate-100 pb-2">
						<span class="block text-sm font-bold text-slate-700">최근 입찰
							기록 (TOP 5)</span> <span
							class="text-xs font-semibold text-slate-400 animate-pulse flex items-center gap-1">
							<span class="relative flex h-2 w-2"><span
								class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span><span
								class="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span></span>
							실시간 반영중
						</span>
					</div>

					<ul id="bidHistoryList" class="flex flex-col gap-1 text-sm flex-1">
						<c:forEach items="${latestBids}" var="bidDto">
							<li
								class="flex justify-between items-center py-2 px-1 hover:bg-slate-50 rounded">
								<span class="text-slate-500 font-medium">${bidDto.userId}님</span>
								<span class="font-bold text-slate-800">${bidDto.bidPrice}원</span>
							</li>
						</c:forEach>
					</ul>
				</div>

				<div class="grid grid-cols-2 gap-4">
					<div id="myBidStatusContainer"
						class="bg-white border border-slate-200 rounded-xl p-4 shadow-sm flex flex-col justify-center">
						<span class="block text-xs font-bold text-slate-500 mb-2">내
							입찰 상태</span>
						<c:choose>
							<%-- 1. 입찰 정보(bdto)가 존재하는 경우 --%>
							<c:when test="${not empty bdto}">

								<c:choose>
									<%-- A. 내가 최고가 입찰자인 경우 (내 금액 >= 최고가) --%>
									<c:when test="${bdto.bidPrice >= dtoHasHighestBid.highestBid}">
										<div class="flex flex-col gap-1">
											<span
												class="inline-flex items-center gap-1.5 px-2.5 py-1 bg-amber-50 text-amber-600 rounded text-xs font-bold border border-amber-200 w-fit">
												🏆 최고가 입찰 중 </span>
											<div class="mt-1.5 text-sm font-bold text-slate-800">
												<fmt:formatNumber value="${bdto.bidPrice}" type="number" />
												원
											</div>
											<span class="text-[11px] text-slate-400 mt-1">※ 최고가
												입찰은 취소할 수 없습니다.</span>
										</div>
									</c:when>

									<%-- B. 누군가 나를 추월한 경우 --%>
									<c:otherwise>
										<div>
											<div class="flex items-center gap-2">
												<span
													class="inline-flex items-center gap-1.5 px-2.5 py-1 bg-blue-50 text-blue-600 rounded text-xs font-bold border border-blue-200">
													🔵 패찰 </span>
											</div>
											<div class="mt-1.5 text-sm font-bold text-slate-800">
												<fmt:formatNumber value="${bdto.bidPrice}" type="number" />
												원
											</div>
										</div>
									</c:otherwise>
								</c:choose>

							</c:when>

							<%-- 2. 입찰 정보가 없는 경우 --%>
							<c:otherwise>
								<div>
									<span
										class="inline-flex items-center gap-1.5 px-2.5 py-1 bg-slate-50 text-slate-400 rounded text-xs font-bold border border-slate-200 w-fit">
										⚪ 입찰 가능 </span>
									<div class="mt-1.5 text-sm font-bold text-slate-400">참여
										내역 없음</div>
								</div>
							</c:otherwise>
						</c:choose>
					</div>

					<div
						class="bg-white border border-slate-200 rounded-xl p-4 shadow-sm flex items-center gap-3">
						<div
							class="w-10 h-10 bg-slate-200 rounded-full flex items-center justify-center text-slate-500 font-black text-lg">
							👤</div>
						<div class="flex flex-col">
							<span class="text-xs font-bold text-slate-500 mb-0.5">판매자</span>
							<span class="text-sm font-bold text-slate-800">회원번호:
								${dto.createMemberSeq}</span>
						</div>
					</div>
				</div>

			</div>

		</div>

		<div
			class="bg-white border border-slate-200 rounded-xl shadow-sm overflow-hidden mb-10">
			<div class="bg-slate-50 px-6 py-4 border-b border-slate-200">
				<h3 class="text-lg font-bold text-slate-800">상품 상세 설명</h3>
			</div>
			<div
				class="p-6 md:p-8 text-slate-600 text-base leading-relaxed whitespace-pre-wrap min-h-[250px]">
				${dto.description}</div>
		</div>

		<div
			class="flex flex-col md:flex-row justify-end items-center gap-4 bg-white border border-slate-200 rounded-xl p-4 shadow-sm sticky bottom-4 z-20">

			<%-- <sec:authorize access="isAuthenticated()"> --%>
			<c:if test="${sessionScope.user.seq == dto.createMemberSeq}">
				<div class="mr-auto w-full md:w-auto">
					<button type="button" onclick="deleteAuction()"
						class="btn bg-white border border-rose-200 text-rose-500 hover:bg-rose-50 px-6 font-bold py-3 rounded-lg">
						🗑️ 경매 삭제
				</div>
			</c:if>
			<%-- </sec:authorize> --%>

			<div class="flex flex-col md:flex-row gap-2 w-full md:w-auto">
				<button type="button" onclick="openModal('autoBidModal')"
					class="btn bg-slate-800 hover:bg-slate-900 text-white border-0 px-8 font-bold flex-1 md:flex-none shadow-md py-3 rounded-lg">
					자동 입찰 등록</button>

				<button type="button" onclick="openModal('bidModal')"
					class="btn bg-brand-500 hover:bg-brand-600 text-white border-0 px-8 font-bold flex-1 md:flex-none shadow-md text-lg py-3 rounded-lg">
					⚡ 일반 입찰 참여</button>
			</div>
		</div>

	</div>

	<div id="bidModal"
		class="fixed inset-0 bg-black/50 z-50 hidden flex items-center justify-center transition-opacity">
		<div
			class="bg-white rounded-2xl w-full max-w-md mx-4 p-6 shadow-xl transform transition-transform scale-100">
			<div class="flex justify-between items-center mb-5">
				<h3 class="text-xl font-bold text-slate-800">일반 입찰 참여</h3>
				<button onclick="closeModal('bidModal')"
					class="text-slate-400 hover:text-slate-600">
					<svg class="w-6 h-6" fill="none" stroke="currentColor"
						viewBox="0 0 24 24">
						<path stroke-linecap="round" stroke-linejoin="round"
							stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
				</button>
			</div>

			<div
				class="bg-brand-50 border border-brand-100 rounded-xl p-4 text-center mb-6">
				<span class="block text-sm font-semibold text-brand-600 mb-1">현재
					최고가</span>
				<div class="text-2xl font-black text-brand-700">
					<span id="modalHighestBidDisplay"><fmt:formatNumber
							value="${dtoHasHighestBid.highestBid}" pattern="#,###" /></span>원
				</div>
			</div>

			<div class="mb-6">
				<label for="bidPrice"
					class="block text-sm font-semibold text-slate-600 mb-2">입찰
					금액 </label>
				<div class="relative">
					<input type="number" id="bidPrice" placeholder="입찰가를 입력하세요"
						class="w-full pl-4 pr-10 py-3 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent text-right font-bold text-lg transition-colors">
					<span
						class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 font-bold">원</span>
				</div>
				<p id="bidErrorMsg"
					class="text-sm font-bold text-rose-500 mt-2 hidden">
					<svg class="inline w-4 h-4 mr-1" fill="none" stroke="currentColor"
						viewBox="0 0 24 24">
						<path stroke-linecap="round" stroke-linejoin="round"
							stroke-width="2"
							d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
					<span>현재 최고가보다 높은 금액을 입력해야 합니다.</span>
				</p>
			</div>

			<div class="flex gap-2">
				<button onclick="closeModal('bidModal')"
					class="flex-1 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-lg transition-colors">취소</button>
				<button onclick="submitBid()" id="submitBtn"
					class="flex-1 py-3 bg-brand-500 hover:bg-brand-600 text-white font-bold rounded-lg transition-colors shadow-md">입찰하기</button>
			</div>
		</div>
	</div>

	<div id="autoBidModal"
		class="fixed inset-0 bg-black/50 z-50 hidden flex items-center justify-center transition-opacity">
		<div class="bg-white rounded-2xl w-full max-w-md mx-4 p-6 shadow-xl">
			<div class="flex justify-between items-center mb-5">
				<h3 class="text-xl font-bold text-slate-800">자동 입찰 등록</h3>
				<button onclick="closeModal('autoBidModal')"
					class="text-slate-400 hover:text-slate-600">
					<svg class="w-6 h-6" fill="none" stroke="currentColor"
						viewBox="0 0 24 24">
						<path stroke-linecap="round" stroke-linejoin="round"
							stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
				</button>
			</div>
			<div class="mb-6">
				<label for="autoBidLimit"
					class="block text-sm font-semibold text-slate-600 mb-2">최대
					허용 금액 (한도)</label>
				<div class="relative">
					<input type="number" id="autoBidLimit" placeholder="최대 한도를 입력하세요"
						class="w-full pl-4 pr-10 py-3 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-800 focus:border-transparent text-right font-bold text-lg">
					<span
						class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 font-bold">원</span>
				</div>
				<p class="text-xs text-slate-500 mt-2">지정한 금액까지 자동으로 입찰 경쟁을
					수행합니다.</p>
			</div>
			<div class="flex gap-2">
				<button onclick="closeModal('autoBidModal')"
					class="flex-1 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-lg transition-colors">취소</button>
				<button onclick="alert('자동 입찰 로직 추가 필요');"
					class="flex-1 py-3 bg-slate-800 hover:bg-slate-900 text-white font-bold rounded-lg transition-colors shadow-md">등록하기</button>
			</div>
		</div>
	</div>

	<script>
    
	 	//웹소켓 연결
	    const wsUri = "ws://" + location.host + "${pageContext.request.contextPath}/bid-ws";
	    const socket = new WebSocket(wsUri);
	
	    socket.onopen = function() {
	        console.log("실시간 입찰 서버에 연결되었습니다.");
	    };
	
	    //서버로부터 누군가 입찰했다는 방송(Broadcast)을 수신했을 때
	    socket.onmessage = function(event) {
	        // event.data 예시: {"auctionSeq": "5"}
	        const msg = JSON.parse(event.data);
	        
	        // 수신된 메시지의 경매 번호가 지금 내가 보고 있는 페이지의 경매 번호와 같다면?
	        if (msg.auctionSeq == auctionSeq) {
	            console.log("새로운 입찰 감지! 데이터를 갱신합니다.");
	            // AJAX 함수 호출 (DB 부하를 최소화하면서 화면만 갱신)
	            fetchLatestAuctionData(); 
	        }
	    };
	
	    socket.onclose = function() {
	        console.log("실시간 입찰 서버와 연결이 끊어졌습니다.");
	    };
    
	    const auctionSeq = parseInt("${dto.seq}", 10);
	    // JS에서 비교 및 갱신을 위해 현재 최고가 상태를 변수로 저장
	    let currentHighestBid = parseInt("${dtoHasHighestBid.highestBid}", 10) || 0;
	    
	    let myBidPrice = parseInt("${bdto != null ? bdto.bidPrice : 0}", 10);
	
	    // 천 단위 콤마 포맷 함수
	    function formatNumber(num) {
	        return num.toLocaleString('ko-KR');
	    }
	
	    // 모달 열기 (열 때마다 입력창 및 에러상태 초기화)
	    function openModal(modalId) {
	        if(modalId === 'bidModal') {
	            document.getElementById('bidPrice').value = '';
	            document.getElementById('bidErrorMsg').classList.add('hidden');
	            document.getElementById('bidPrice').classList.remove('border-rose-500', 'bg-rose-50');
	        }
	        document.getElementById(modalId).classList.remove('hidden');
	    }
	
	    function closeModal(modalId) {
	        document.getElementById(modalId).classList.add('hidden');
	    }
	
	    // 입력 에러 표시 함수
	    function showError(msg) {
	        const inputEl = document.getElementById('bidPrice');
	        const errorMsgEl = document.getElementById('bidErrorMsg');
	        errorMsgEl.querySelector('span').innerText = msg;
	        errorMsgEl.classList.remove('hidden');
	        
	        // 붉은색 테두리 및 배경 강조
	        inputEl.classList.add('border-rose-500', 'bg-rose-50');
	        inputEl.focus();
	    }
	
	    // 입찰하기 전송
	    async function submitBid() {
	        const inputEl = document.getElementById('bidPrice');
	        const bidPriceInput = parseInt(inputEl.value, 10);
	        
	        // 1. 유효성 검사
	        if (!bidPriceInput || isNaN(bidPriceInput)) {
	            showError('올바른 입찰 금액을 입력해주세요.');
	            return;
	        }
	
	        if (bidPriceInput <= currentHighestBid) {
	            showError('현재 최고가(' + formatNumber(currentHighestBid) + '원)보다 높은 금액이어야 합니다.');
	            return;
	        }
	
	        // 에러 상태 해제
	        document.getElementById('bidErrorMsg').classList.add('hidden');
	        inputEl.classList.remove('border-rose-500', 'bg-rose-50');
	
	        try {
	            // 버튼 비활성화 (중복 방지)
	            const submitBtn = document.getElementById('submitBtn');
	            submitBtn.disabled = true;
	            submitBtn.innerText = '처리중...';
	
	            const response = await fetch('${pageContext.request.contextPath}/auction/bid', {
	                method: 'POST',
	                headers: {
	                    'Content-Type': 'application/json',
	                },
	                body: JSON.stringify({
	                    seq: auctionSeq,
	                    bidPrice: bidPriceInput
	                })
	            });
	
	            if (!response.ok) throw new Error('Network response was not ok.');
	            
	            // 서버에서 응답받은 전체 JSON 데이터
	            const resultData = await response.json();
	            
	            // 컨트롤러에서 세팅한 status 값이 "success"인지 확인
	            if (resultData.status === "success") {
	                alert('입찰이 성공적으로 완료되었습니다.');
	                closeModal('bidModal');
	                
	                //내 입찰가 갱신
	                myBidPrice = bidPriceInput;
	                
	                // 서버에서 넘겨준 latestBids 배열을 가공합니다.
	                // 0번째 인덱스(가장 최근 데이터)에만 isNew=true를 줘서 깜빡임 효과를 부여합니다.
	                const updatedBids = resultData.latestBids.map((bid, index) => {
	                    return {
	                        ...bid,
	                        isNew: index === 0 
	                    };
	                });
	
	                // DOM 즉시 갱신 (서버가 보내준 진짜 데이터 사용)
	                updateAuctionDataUI(resultData.dtoHasHighestBid.highestBid, updatedBids);
	                
	             	// 입찰 성공, 서버(웹소켓)에 방송해달라고 신호 보내기
	                const msgData = { auctionSeq: auctionSeq };
	                socket.send(JSON.stringify(msgData));
	                
	            } else {
	                alert('입찰 처리 중 문제가 발생했습니다.');
	            }
	
	        } catch (error) {
	            console.error('입찰 중 오류 발생:', error);
	            alert('입찰 처리 중 서버 오류가 발생했습니다.');
	        } finally {
	            document.getElementById('submitBtn').disabled = false;
	            document.getElementById('submitBtn').innerText = '입찰하기';
	        }
	    }
	
	    // 화면(UI) 데이터 업데이트 함수
	    function updateAuctionDataUI(newHighestBid, bidList) {
	        currentHighestBid = newHighestBid;
	        
	        // 본문 및 모달 내 최고가 텍스트 갱신
	        document.getElementById('displayHighestBid').innerText = formatNumber(newHighestBid);
	        document.getElementById('modalHighestBidDisplay').innerText = formatNumber(newHighestBid);
	
	        // 입찰 목록 갱신 (서버에서 받은 최근 5개 목록)
	        if (bidList && bidList.length > 0) {
	            const historyList = document.getElementById('bidHistoryList');
	            
	            // 기존 리스트 삭제
	            historyList.innerHTML = ''; 
	            
	            bidList.forEach(bid => {
	                const highlightClass = bid.isNew ? 'bg-brand-50 animate-pulse' : 'hover:bg-slate-50';
	                
	                const li = `
	                    <li class="flex justify-between items-center py-2 px-2 \${highlightClass} rounded transition-colors border-b border-slate-50 last:border-0">
	                        <span class="text-slate-500 font-medium">\${bid.userId}</span>
	                        <span class="font-bold text-slate-800">\${formatNumber(bid.bidPrice)}원</span>
	                    </li>
	                `;
	                
	                // 기존 내용을 지웠으므로 afterbegin 대신 beforeend를 써서 위에서부터 순서대로 차곡차곡 쌓습니다.
	                historyList.insertAdjacentHTML('beforeend', li);
	            });
	        }
	        
	        if (myBidPrice > 0) {
	            const statusContainer = document.getElementById('myBidStatusContainer');
	            let statusHtml = '<span class="block text-xs font-bold text-slate-500 mb-2">내 입찰 상태</span>';
	            
	            if (myBidPrice >= newHighestBid) {
	                // 방금 입찰 후 나의 입찰가가 최고가가 되었을때
	                statusHtml += `
	                    <div class="flex flex-col gap-1">
	                        <span class="inline-flex items-center gap-1.5 px-2.5 py-1 bg-amber-50 text-amber-600 rounded text-xs font-bold border border-amber-200 w-fit">
	                            🏆 최고가 입찰 중
	                        </span>
	                        <div class="mt-1.5 text-sm font-bold text-slate-800">
	                            \${formatNumber(myBidPrice)}원
	                        </div>
	                        <span class="text-[11px] text-slate-400 mt-1">※ 최고가 입찰은 취소할 수 없습니다.</span>
	                    </div>
	                `;
	            } else {
	                // 다른 사람이 나보다 높은 금액을 불렀을 때 (패찰)
	                statusHtml += `
	                    <div>
	                        <div class="flex items-center gap-2">
	                            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 bg-blue-50 text-blue-600 rounded text-xs font-bold border border-blue-200">
	                                🔵 패찰
	                            </span>
	                        </div>
	                        <div class="mt-1.5 text-sm font-bold text-slate-800">
	                            \${formatNumber(myBidPrice)}원
	                        </div>
	                    </div>
	                `;
	            }
	            // 기존 HTML을 방금 만든 HTML로 덮어씌웁니다.
	            statusContainer.innerHTML = statusHtml;
	    	}
	    }
	    
	    // 경매 삭제
	    async function deleteAuction() {
	        if (!confirm('경매를 삭제하시겠습니까?')) return;

	        const response = await fetch('${pageContext.request.contextPath}/auction/${dto.seq}', { method: 'DELETE' });
	        const result = await response.json();

	        if (result.status === 'success') {
	            alert('삭제되었습니다.');
	            // 서버에서 success를 받으면 브라우저가 직접 페이지를 이동시킵니다 (클라이언트 사이드 리다이렉트)
	            location.href = '/auction'; 
	        } else {
	            alert(result.msg); // 컨트롤러가 보내준 실패 메시지 출력
	        }
	    }
	    
	 	// 웹소켓에서 입찰 감지 신호를 받으면 실행되는 함수
	    async function fetchLatestAuctionData() {
	        try {
	        	
	            const response = await fetch(`${pageContext.request.contextPath}/auction/api/latest/\${auctionSeq}`);
	            
	            if (response.ok) {
	                const data = await response.json();
	                
	                // 0번째 인덱스에 isNew: true 를 주어 새 입찰에 깜빡임 효과(animate-pulse) 적용
	                const updatedBids = data.latestBids.map((bid, index) => {
	                    return {
	                        ...bid,
	                        isNew: index === 0 
	                    };
	                });
	                
	                // 화면 갱신 함수 호출
	                updateAuctionDataUI(data.dtoHasHighestBid.highestBid, updatedBids);
	            }
	        } catch (error) {
	            console.error("실시간 데이터 갱신 실패:", error);
	        }
	    }
	    

</script>
</body>
</html>
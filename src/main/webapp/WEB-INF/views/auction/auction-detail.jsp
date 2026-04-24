<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>경매 상세 - ${dto.name}</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body class="bg-slate-50 relative">
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
                        <div class="text-3xl font-black text-brand-600 tracking-tight">
                            <span id="displayHighestBid"><fmt:formatNumber value="${dtoHasHighestBid.highestBid}" pattern="#,###" /></span><span class="text-lg font-bold text-slate-500 ml-1">원</span>
                        </div>
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
                        <span class="text-xs font-semibold text-slate-400 animate-pulse flex items-center gap-1">
                            <span class="relative flex h-2 w-2"><span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span><span class="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span></span>
                            실시간 반영중
                        </span>
                    </div>
                    
                    <ul id="bidHistoryList" class="flex flex-col gap-1 text-sm flex-1">
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
                <button type="button" class="btn bg-white border border-rose-200 text-rose-500 hover:bg-rose-50 px-6 font-bold py-3 rounded-lg">
                    🗑️ 경매 삭제
                </button>
            </div>
            
            <div class="flex flex-col md:flex-row gap-2 w-full md:w-auto">
                <button type="button" onclick="openModal('autoBidModal')" class="btn bg-slate-800 hover:bg-slate-900 text-white border-0 px-8 font-bold flex-1 md:flex-none shadow-md py-3 rounded-lg">
                    자동 입찰 등록
                </button>
                
                <button type="button" onclick="openModal('bidModal')" class="btn bg-brand-500 hover:bg-brand-600 text-white border-0 px-8 font-bold flex-1 md:flex-none shadow-md text-lg py-3 rounded-lg">
                    ⚡ 일반 입찰 참여
                </button>
            </div>
        </div>
        
    </div>
    
    <div id="bidModal" class="fixed inset-0 bg-black/50 z-50 hidden flex items-center justify-center transition-opacity">
        <div class="bg-white rounded-2xl w-full max-w-md mx-4 p-6 shadow-xl transform transition-transform scale-100">
            <div class="flex justify-between items-center mb-5">
                <h3 class="text-xl font-bold text-slate-800">일반 입찰 참여</h3>
                <button onclick="closeModal('bidModal')" class="text-slate-400 hover:text-slate-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            
            <div class="bg-brand-50 border border-brand-100 rounded-xl p-4 text-center mb-6">
                <span class="block text-sm font-semibold text-brand-600 mb-1">현재 최고가</span>
                <div class="text-2xl font-black text-brand-700">
                    <span id="modalHighestBidDisplay"><fmt:formatNumber value="${dtoHasHighestBid.highestBid}" pattern="#,###" /></span>원
                </div>
            </div>
            
            <div class="mb-6">
                <label for="bidPrice" class="block text-sm font-semibold text-slate-600 mb-2">입찰 금액</label>
                <div class="relative">
                    <input type="number" id="bidPrice" placeholder="입찰가를 입력하세요" 
                           class="w-full pl-4 pr-10 py-3 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-transparent text-right font-bold text-lg transition-colors">
                    <span class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 font-bold">원</span>
                </div>
                <p id="bidErrorMsg" class="text-sm font-bold text-rose-500 mt-2 hidden">
                    <svg class="inline w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    <span>현재 최고가보다 높은 금액을 입력해야 합니다.</span>
                </p>
            </div>

            <div class="flex gap-2">
                <button onclick="closeModal('bidModal')" class="flex-1 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-lg transition-colors">취소</button>
                <button onclick="submitBid()" id="submitBtn" class="flex-1 py-3 bg-brand-500 hover:bg-brand-600 text-white font-bold rounded-lg transition-colors shadow-md">입찰하기</button>
            </div>
        </div>
    </div>

    <div id="autoBidModal" class="fixed inset-0 bg-black/50 z-50 hidden flex items-center justify-center transition-opacity">
        <div class="bg-white rounded-2xl w-full max-w-md mx-4 p-6 shadow-xl">
            <div class="flex justify-between items-center mb-5">
                <h3 class="text-xl font-bold text-slate-800">자동 입찰 등록</h3>
                <button onclick="closeModal('autoBidModal')" class="text-slate-400 hover:text-slate-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <div class="mb-6">
                <label for="autoBidLimit" class="block text-sm font-semibold text-slate-600 mb-2">최대 허용 금액 (한도)</label>
                <div class="relative">
                    <input type="number" id="autoBidLimit" placeholder="최대 한도를 입력하세요" 
                           class="w-full pl-4 pr-10 py-3 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-800 focus:border-transparent text-right font-bold text-lg">
                    <span class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 font-bold">원</span>
                </div>
                <p class="text-xs text-slate-500 mt-2">지정한 금액까지 자동으로 입찰 경쟁을 수행합니다.</p>
            </div>
            <div class="flex gap-2">
                <button onclick="closeModal('autoBidModal')" class="flex-1 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-lg transition-colors">취소</button>
                <button onclick="alert('자동 입찰 로직 추가 필요');" class="flex-1 py-3 bg-slate-800 hover:bg-slate-900 text-white font-bold rounded-lg transition-colors shadow-md">등록하기</button>
            </div>
        </div>
    </div>

    <script>
        const auctionSeq = parseInt("${dto.seq}", 10);
        // JS에서 비교 및 갱신을 위해 현재 최고가 상태를 변수로 저장
        let currentHighestBid = parseInt("${dtoHasHighestBid.highestBid}", 10) || 0;

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

                const response = await fetch('/auction/bid', {
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
                const resultData = await response.json();
                
                alert('입찰이 성공적으로 완료되었습니다.');
                closeModal('bidModal');
                
                // 2. DOM 즉시 갱신 (내 입찰 기록)
                updateAuctionDataUI(bidPriceInput, [{
                    memberId: '나 (방금)', 
                    bidPrice: bidPriceInput,
                    isNew: true
                }]);

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

            // 입찰 목록 갱신 (서버에서 최근 목록을 받았다고 가정)
            if (bidList && bidList.length > 0) {
                const historyList = document.getElementById('bidHistoryList');
                // 기존 내용을 지우고 새로 그리기 (혹은 insertAdjacentHTML로 추가)
                // historyList.innerHTML = ''; 
                
                bidList.forEach(bid => {
                    const highlightClass = bid.isNew ? 'bg-brand-50 animate-pulse' : 'hover:bg-slate-50';
                    const li = `
                        <li class="flex justify-between items-center py-2 px-2 ${highlightClass} rounded transition-colors">
                            <span class="text-slate-500 font-medium">\${bid.memberId}</span>
                            <span class="font-bold text-slate-800">\${formatNumber(bid.bidPrice)}원</span>
                        </li>
                    `;
                    // 맨 위에 새 기록 추가
                    historyList.insertAdjacentHTML('afterbegin', li);
                });
            }
        }

        // 3. 폴링(Polling): 3초마다 다른 사용자의 입찰 확인
        async function fetchLatestAuctionData() {
            try {
                // 이 API는 Spring Controller에 @GetMapping("/auction/latestData") 로 구현되어 있어야 합니다.
                const response = await fetch(`/auction/latestData?seq=\${auctionSeq}`);
                if (response.ok) {
                    const data = await response.json();
                    
                    // 누군가 나보다 높은 입찰을 했다면 갱신!
                    if (data.highestBid > currentHighestBid) {
                        updateAuctionDataUI(data.highestBid, data.recentBids);
                    }
                }
            } catch (error) {
                // 백그라운드 갱신 실패시 조용히 무시
                console.error('실시간 데이터 갱신 실패:', error);
            }
        }

        // 페이지 로딩 완료 시 3초마다 실시간 체크 시작
        document.addEventListener('DOMContentLoaded', () => {
            // 폴링 기능 테스트 전까지는 주석 처리해두셔도 좋습니다. (서버 컨트롤러 구현 필수)
            // setInterval(fetchLatestAuctionData, 3000); 
        });

    </script>
    </body>
</html>
<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>채팅 - Jesiyo</title>

<%-- 에셋 include --%>
<%@include file="/WEB-INF/views/inc/asset.jsp"%>

<style>
<%@include file="/WEB-INF/views/inc/chat.css"%>
</style>
</head>
<body>

    <%-- 헤더 --%>
    <%@include file="/WEB-INF/views/inc/header.jsp"%>

    <%-- 채팅 루트 --%>
    <div class="chat-root">

        <%-- ① 왼쪽: 채팅방 목록 패널 --%>
        <aside class="room-panel">
            <!-- 개인 채팅 -->
            <button class="btn-dm-room">
                <span>개인 채팅</span>
            </button>

            <div class="room-panel-header">
                <span>채팅방 목록</span>
            </div>

            <%-- ① 내가 참여한 채팅방 목록 --%>
            <div class="room-list" id="roomList">
            </div>

            <%-- ④ 채팅방 생성/입장 버튼 --%>
            <!-- ✅ FIX 3: roomModal() → openRoomModal() 으로 변경 (ID 충돌 방지) -->
            <button class="btn-add-room" onclick="openRoomModal()">
                <span style="font-size: 1.1rem; line-height: 1;">+</span>
                <span>채팅방 만들기 / 입장</span>
            </button>

        </aside>

        <%-- ② ③ 오른쪽: 채팅 메인 영역 --%>
        <main class="chat-main">

            <%-- 채팅 헤더 (채팅방 선택 후 노출) --%>
            <div class="chat-header" id="chatHeader" style="display: none;">
            </div>

            <%-- ② 채팅방 미참여 상태 (환영 메시지) --%>
            <div class="empty-state" id="emptyState">
                <div class="empty-icon">💬</div>
                <h3>Jesiyo 채팅에 오신 걸 환영해요!</h3>
                <p>채팅방을 만들거나, 초대 코드로 기존 채팅방에 입장하세요. 상대방과 실시간으로 대화할 수
                    있어요.</p>
                <div class="empty-actions">
                    <button class="btn-primary-discord">채팅방 만들기</button>
                    <button class="btn-secondary-discord">코드로
                        입장</button>
                </div>
            </div>

            <%-- ③ 채팅방 내부 영역 (채팅방 선택 후 노출) --%>
            <div class="chat-body" id="chatBody" style="display: none;">
            </div>
        </main>
    </div>

    <%-- 채팅방 생성/입장 모달 --%>
    <dialog id="roomModal">
    <h2>채팅방</h2>
    <p>새 채팅방을 만들거나 코드로 기존 방에 입장하세요.</p>

    <div class="room-modal-tabs">
        <div class="room-modal-tab active" id="tab-create">채팅방 만들기</div>
        <div class="room-modal-tab" id="tab-join">코드로 입장</div>
    </div>

    <div id="form-create">
        <label class="room-modal-label">채팅방 이름</label>
        <input type="text" class="room-modal-input" id="newRoomName" placeholder="예: 아이폰 거래 채팅" maxlength="30" required/>
        
        <label class="room-modal-label">카테고리(대분류)</label>
            <select class="room-modal-select" id="roomCategoryL1">
            	<option value="null">선택 없음</option>
            </select>
       <label class="room-modal-label">카테고리(중분류)</label>
            <select class="room-modal-select" id="roomCategoryL2">
            	<option value="null">선택 없음</option>
            </select>
       <label class="room-modal-label">카테고리(소분류)</label>
            <select class="room-modal-select" id="roomCategoryL3">
            	<option value="null">선택 없음</option>
            </select>
            
        
        <label class="room-modal-label">최대 인원</label>
        <input type="number" class="room-modal-input" id="newRoomDescNum" placeholder="채팅방 최대인원을 입력하세요" min="20" max="50" required/>
        
    </div>
    
    <div id="form-join" style="display: none;">
        <label class="room-modal-label">초대 코드</label>
        <input type="text" class="room-modal-input" id="joinCode" placeholder="초대 코드 8자리 입력" maxlength="8" />
    </div>

    <div class="room-modal-footer">
        <button class="room-modal-cancel" onclick="closeModal()">취소</button>
        <button class="room-modal-confirm" id="btnModalConfirm">생성</button>
    </div>
    </dialog>

    <script>
    	// 채팅방 목록 버튼	
     	document.addEventListener('DOMContentLoaded', loadRoomList);
     	
    	function loadRoomList() {
     	    const roomListContainer = document.getElementById('roomList');

     	    fetch('http://localhost:8080/jesiyo/chat/rooms') // 실제 API 주소로 수정
     	        .then(res => res.json())
     	        .then(list => {
     	            roomListContainer.innerHTML = ''; // 기존 내용을 초기화

     	            if (list && list.length > 0) {
     	                // 데이터가 있을 경우
     	                list.forEach(room => {
     	                    const roomHtml = `
     	                        <div class="room-item" data-room-id="\${room.seq}">
     	                            <span class="room-hash">#</span> 
     	                            <span class="room-name">\${room.title}</span>
     	                        </div>
     	                    `;
     	                    roomListContainer.insertAdjacentHTML('beforeend', roomHtml);
     	                });
     	            } else {
     	                // 데이터가 없을 경우 (기존 c:otherwise 부분)
     	                const emptyHtml = `
     	                    <div class="px-3 py-4 text-center">
     	                        <p class="text-xs leading-relaxed" style="color: #72767d;">
     	                            아직 참여한 채팅방이 없어요.<br> 
     	                            아래 <span style="color: #ff8a3d;">+</span> 버튼으로 만들거나<br> 
     	                            코드로 입장해보세요!
     	                        </p>
     	                    </div>
     	                `;
     	                roomListContainer.innerHTML = emptyHtml;
     	            }
     	        })
     	        .catch(err => {
     	            console.error('채팅방 목록 로드 실패:', err);
     	            roomListContainer.innerHTML = '<p style="color:red; text-align:center;">목록을 불러오지 못했습니다.</p>';
     	        });
     	}  
    
    	// 채팅방 생성/입장 버튼
    	const btnModalConfirm = document.getElementById('btnModalConfirm');
    
        // 채팅방 생성/입장 모달창
        function openRoomModal() {
            document.getElementById('roomModal').showModal();
        }
        function closeModal() {
            document.getElementById('roomModal').close();
        }
        document.getElementById('roomModal').addEventListener('click', function(e) {
            if (e.target === this) closeModal();
        });
        // 탭 전환
        document.getElementById('tab-create').addEventListener('click', function() {
            document.getElementById('tab-create').classList.add('active');
            document.getElementById('tab-join').classList.remove('active');
            document.getElementById('form-create').style.display = 'block';
            document.getElementById('form-join').style.display = 'none';
            btnModalConfirm.textContent = '생성';
        });
        document.getElementById('tab-join').addEventListener('click', function() {
            document.getElementById('tab-join').classList.add('active');
            document.getElementById('tab-create').classList.remove('active');
            document.getElementById('form-join').style.display = 'block';
            document.getElementById('form-create').style.display = 'none';
            btnModalConfirm.textContent = '입장';
        });
        // number 
        document.getElementById('newRoomDescNum').addEventListener('blur', function() {
            if (this.value < 20) this.value = 20;
            if (this.value > 50) this.value = 50;
        });
        
        // 모달 카테고리 불러오기
        // 페이지 로드 시 실행
		document.addEventListener('DOMContentLoaded', function() {
		    loadCategoryL1();
		});
		
		function loadCategoryL1() {
		    fetch('http://localhost:8080/jesiyo/api/roots')
		        .then(res => res.json())
		        .then(data => {
		            const select = document.getElementById('roomCategoryL1');

		            data.forEach(item => {
		                const option = document.createElement('option');
		                option.value = item.seq;    // JSON 필드명 확인 필요
		                option.textContent = item.name; // JSON 필드명 확인 필요
		                select.appendChild(option);
		            });
		        });
		}
		
		// 대분류 변경 시 중분류 코드
		document.getElementById('roomCategoryL1').addEventListener('change', function() {
		    const l1Seq = this.value;

		    resetSelect('roomCategoryL2');
		    resetSelect('roomCategoryL3');

		    if (!l1Seq || l1Seq === "" || l1Seq === "null") return;

		    fetch('http://localhost:8080/jesiyo/api/categories/' + l1Seq +'/children')
		        .then(res => res.json())
		        .then(data => {
		            const select = document.getElementById('roomCategoryL2');

		            data.forEach(item => {
		                const option = document.createElement('option');
		                option.value = item.seq;
		                option.textContent = item.name;
		                select.appendChild(option);
		            });
		        });
		});
		
		// 중분류 변경 시 소분류 로드
		document.getElementById('roomCategoryL2').addEventListener('change', function() {
		    const l2Seq = this.value;

		    resetSelect('roomCategoryL3');

		    if (!l2Seq || l2Seq === "" || l2Seq === "null") return;

		    fetch('http://localhost:8080/jesiyo/api/categories/' + l2Seq +'/children')
		        .then(res => res.json())
		        .then(data => {
		            const select = document.getElementById('roomCategoryL3');

		            data.forEach(item => {
		                const option = document.createElement('option');
		                option.value = item.seq;
		                option.textContent = item.name;
		                select.appendChild(option);
		            });
		        });
		});
		
		// 공통 초기화
		function resetSelect(selectId) {
		    const select = document.getElementById(selectId);
		    select.innerHTML = '<option value="null">선택 없음</option>';
		}
		
		
		// 저장
		function getRoomCategorySeq() {
		    const l3 = document.getElementById('roomCategoryL3').value;
		    const l2 = document.getElementById('roomCategoryL2').value;
		    const l1 = document.getElementById('roomCategoryL1').value;
		    
		    if (l1 == 'null') {
		   		alert('카테고리를 선택해주세요.'); // 사용자 알림
		        document.getElementById('roomCategoryL1').focus(); // 해당 셀렉박스로 포커스 이동
		        return null; // 또는 false (호출한 곳에서 체크 가능하도록)
		    }

		    if (l3 !== 'null') return l3;
		    if (l2 !== 'null') return l2;
		   	
		    return l1;
		}
		
		// btnModalConfirm 클릭시 생성/입장
		btnModalConfirm.addEventListener('click', function() {
			const action = this.textContent.trim();
			
			if(action === '생성'){
				createRoom();
			} else if(action === '입장'){
				joinRoom();
			}
			
		});
		
		// 방 생성
		function createRoom(){
			// 카테고리 선택 검사
			const categorySeq = getRoomCategorySeq();
			
			if(!categorySeq){
				return;
			}
			
			const dto = {
			        title: document.getElementById('newRoomName').value,
			        maxMemberCnt: document.getElementById('newRoomDescNum').value,
			        categorySeq: categorySeq, // 카테고리를 정하는 함수
			        memberSeq: ${sessionScope.auth.seq}, // 로그인한 유저 seq (세션에서 가져와야 함)
			};
			fetch('http://localhost:8080/jesiyo/chat/rooms', {
		        method: 'POST',
		        headers: { 'Content-Type': 'application/json' },
		        body: JSON.stringify(dto)
		    })
		    .then(res => {
		        if (res.ok) {
		            alert('채팅방이 생성되었습니다!');
		            closeModal();       // 모달 닫기
		            loadRoomList();     // 방 목록 새로고침
		        } else {
		            alert('채팅방 생성에 실패했습니다.');
		        }
		    });
			
		};
		
		// 채팅방 선택 처리
		document.getElementById('roomList').addEventListener('click', function(e) {
		    // 클릭된 요소 또는 가장 가까운 .room-item 찾기
		    const roomItem = e.target.closest('.room-item');
		    
		    if (!roomItem) return; // room-item이 아닌 곳 클릭 시 무시
		
		    const roomId = roomItem.dataset.roomId; // data-room-id 값 읽기 dataset.roomId로 접근 (data-room-id -> roomId로 자동 변환됨)
		    enterRoom(roomId);
		});
			
		function enterRoom(roomId){
			document.getElementById('emptyState').style.display = 'none'; // 기본화면 감추기
			const roomSeq = roomId;
			
			// 헤더 구현
			const chatHeader = document.getElementById('chatHeader');
			const chatBody = document.getElementById('chatBody');
			chatHeader.style.display = 'flex';
			chatBody.style.display = 'flex';
			
			chatHeader.innerHTML=''; //초기화
			const headerHtml = `
				<span class="hash-icon">#</span> <span
	            id="currentRoomName">채팅방</span> <span
	            style="color: #72767d; font-size: 0.75rem; font-weight: 400; margin-left: 0.5rem;"
	            id="currentRoomDesc"></span>
	            
		        <div class="header-actions">
		            <button class="header-tab-btn">🏬경매</button>
		        </div>
			`;
			chatHeader.insertAdjacentHTML('beforeend', headerHtml);
			
			
			chatBody.innerHTML=''; //초기화
			
			const bodyHtml = `
				<div class="chat-content-row">
	
	            <%-- 메시지 목록 --%>
	            <div class="messages-area" id="messagesArea">
	                
	            </div>
	
	            <%-- 우측 유저 리스트 패널 --%>
	            <aside class="user-panel">
	                <div class="user-panel-section-label">
	                    참여자 — <span id="userCount">1</span>명
	                </div>
	                <div class="user-list">
	                   
	                </div>
	            </aside>
	
	        </div>
	
	        <%-- 채팅 입력창 --%>
	        <div class="chat-input-wrap" id="chatInputWrap">
	            <div class="chat-input-box">
	                <button class="chat-input-btn" title="파일 첨부">
	                    <svg width="20" height="20" fill="none"
	                        stroke="currentColor" stroke-width="2"
	                        viewBox="0 0 24 24">
	                <path
	                            d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48" />
	            </svg>
	                </button>
	
	                <input type="text" class="chat-input"
	                    id="messageInput"
	                    placeholder=" 메시지를 입력하세요..." maxlength="500"
	                    autocomplete="off" />
	
	                <button class="chat-input-btn" title="이모지">
	                    <svg width="20" height="20" fill="none"
	                        stroke="currentColor" stroke-width="2"
	                        viewBox="0 0 24 24">
	                <circle cx="12" cy="12" r="10" />
	                <path
	                            d="M8 13s1.5 2 4 2 4-2 4-2M9 9h.01M15 9h.01" />
	            </svg>
	                </button>
	
	                <button class="btn-send">전송</button>
	            </div>
	        </div>
	        `;
	        
			chatBody.insertAdjacentHTML('beforeend', bodyHtml);
			
		}
				
				
		    
    </script>

</body>
</html>

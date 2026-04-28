<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>채팅 - Jesiyo</title>
<%@include file="/WEB-INF/views/inc/asset.jsp"%>
<style>
<%@include file="/WEB-INF/views/inc/chat.css"%>
</style>
</head>
<body>

    <%@include file="/WEB-INF/views/inc/header.jsp"%>

    <div class="chat-root">

        <aside class="room-panel">
            <button class="btn-dm-room"><span>개인 채팅</span></button>
            <div class="room-panel-header"><span>채팅방 목록</span></div>
            <div class="room-list" id="roomList"></div>
            <button class="btn-add-room" onclick="openRoomModal()">
                <span style="font-size: 1.1rem; line-height: 1;">+</span>
                <span>채팅방 만들기 / 입장</span>
            </button>
        </aside>

        <main class="chat-main">

            <div class="chat-header" id="chatHeader" style="display: none;">
                <span class="hash-icon">#</span>
                <span id="currentRoomName"></span>
                <span id="currentRoomDesc"
                      style="color: #72767d; font-size: 0.75rem; font-weight: 400; margin-left: 0.5rem;"></span>
                <div class="header-actions">
                    <button class="header-tab-btn">🏬경매</button>
                </div>
            </div>

            <div class="empty-state" id="emptyState">
                <div class="empty-icon">💬</div>
                <h3>Jesiyo 채팅에 오신 걸 환영해요!</h3>
                <p>채팅방을 만들거나, 초대 코드로 기존 채팅방에 입장하세요.</p>
                <div class="empty-actions">
                    <button class="btn-primary-discord">채팅방 만들기</button>
                    <button class="btn-secondary-discord">코드로 입장</button>
                </div>
            </div>

            <div class="chat-body" id="chatBody" style="display: none;">
                <div class="chat-content-row">
                    <div class="messages-area" id="messagesArea"></div>
                    <aside class="user-panel">
                        <div class="user-panel-section-label">
                            참여자 — <span id="userCount">1</span>명
                        </div>
                        <div class="user-list" id="userList"></div>
                    </aside>
                </div>
				
				<!-- 추천 배너 (채팅 입력창 위) -->
				<div id="recommend-banner" style="display:none;">
				    <span>🛍️ 추천 제품이 있습니다! </span>
				    <span id="recommend-links"></span>
				</div>
				
				<div class="chat-input-wrap" id="chatInputWrap">
				    ...
				</div>
				
                <div class="chat-input-wrap" id="chatInputWrap">
                    <div class="chat-input-box">
                        <button class="chat-input-btn" title="파일 첨부">
                            <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <path d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48"/>
                            </svg>
                        </button>
                        <input type="text" class="chat-input" id="messageInput"
                               placeholder=" 메시지를 입력하세요..." maxlength="500" autocomplete="off"/>
                        <button class="chat-input-btn" title="이모지">
                            <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <circle cx="12" cy="12" r="10"/>
                                <path d="M8 13s1.5 2 4 2 4-2 4-2M9 9h.01M15 9h.01"/>
                            </svg>
                        </button>
                        <button class="btn-send" id="btn-send">전송</button>
                    </div>
                </div>
            </div>

        </main>
    </div>

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
            <select class="room-modal-select" id="roomCategoryL1"><option value="null">선택 없음</option></select>
            <label class="room-modal-label">카테고리(중분류)</label>
            <select class="room-modal-select" id="roomCategoryL2"><option value="null">선택 없음</option></select>
            <label class="room-modal-label">카테고리(소분류)</label>
            <select class="room-modal-select" id="roomCategoryL3"><option value="null">선택 없음</option></select>
            <label class="room-modal-label">최대 인원</label>
            <input type="number" class="room-modal-input" id="newRoomDescNum" placeholder="최대인원 입력" min="20" max="50" required/>
        </div>
        <div id="form-join" style="display: none;">
            <label class="room-modal-label">초대 코드</label>
            <input type="text" class="room-modal-input" id="joinCode" placeholder="초대 코드 8자리 입력" maxlength="8"/>
        </div>
        <div class="room-modal-footer">
            <button class="room-modal-cancel" onclick="closeModal()">취소</button>
            <button class="room-modal-confirm" id="btnModalConfirm">생성</button>
        </div>
    </dialog>

    <script>
    const loginUserSeq = ${sessionScope.user.seq};
    let ws = null;
    let mySeq = null;
    const nickname = '${sessionScope.user.nickname}';

    // ✅ DOMContentLoaded 하나로 통합
    document.addEventListener('DOMContentLoaded', function() {
        loadRoomList();
        loadCategoryL1();

        document.getElementById('btn-send').addEventListener('click', sendMessage);
        document.getElementById('messageInput').addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.isComposing) sendMessage();
        });
    });

    // 채팅방 목록 불러오기
    function loadRoomList() {
        const roomListContainer = document.getElementById('roomList');
        fetch('http://localhost:8080/jesiyo/chat/rooms')
            .then(res => res.json())
            .then(list => {
                roomListContainer.innerHTML = '';
                if (list && list.length > 0) {
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
                    roomListContainer.innerHTML = `
                        <div class="px-3 py-4 text-center">
                            <p class="text-xs leading-relaxed" style="color: #72767d;">
                                아직 참여한 채팅방이 없어요.<br>
                                아래 <span style="color: #ff8a3d;">+</span> 버튼으로 만들거나<br>
                                코드로 입장해보세요!
                            </p>
                        </div>
                    `;
                }
            })
            .catch(err => {
                console.error('채팅방 목록 로드 실패:', err);
                roomListContainer.innerHTML = '<p style="color:red; text-align:center;">목록을 불러오지 못했습니다.</p>';
            });
    }

    // 모달
    function openRoomModal() { document.getElementById('roomModal').showModal(); }
    function closeModal() { document.getElementById('roomModal').close(); }
    document.getElementById('roomModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    // 확인 버튼
    const btnModalConfirm = document.getElementById('btnModalConfirm');
    btnModalConfirm.addEventListener('click', function() {
        const action = this.textContent.trim();
        if (action === '생성') createRoom();
        else if (action === '입장') joinRoom();
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

    // 최대 인원 범위 보정
    document.getElementById('newRoomDescNum').addEventListener('blur', function() {
        if (this.value < 20) this.value = 20;
        if (this.value > 50) this.value = 50;
    });

    // 카테고리 대분류
    function loadCategoryL1() {
        fetch('http://localhost:8080/jesiyo/api/roots')
            .then(res => res.json())
            .then(data => {
                const select = document.getElementById('roomCategoryL1');
                data.forEach(item => {
                    const option = document.createElement('option');
                    option.value = item.seq;
                    option.textContent = item.name;
                    select.appendChild(option);
                });
            });
    }

    // 대분류 → 중분류
    document.getElementById('roomCategoryL1').addEventListener('change', function() {
        const l1Seq = this.value;
        resetSelect('roomCategoryL2');
        resetSelect('roomCategoryL3');
        if (!l1Seq || l1Seq === 'null') return;
        fetch('http://localhost:8080/jesiyo/api/categories/' + l1Seq + '/children')
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

    // 중분류 → 소분류
    document.getElementById('roomCategoryL2').addEventListener('change', function() {
        const l2Seq = this.value;
        resetSelect('roomCategoryL3');
        if (!l2Seq || l2Seq === 'null') return;
        fetch('http://localhost:8080/jesiyo/api/categories/' + l2Seq + '/children')
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

    function resetSelect(selectId) {
        document.getElementById(selectId).innerHTML = '<option value="null">선택 없음</option>';
    }

    function getRoomCategorySeq() {
        const l3 = document.getElementById('roomCategoryL3').value;
        const l2 = document.getElementById('roomCategoryL2').value;
        const l1 = document.getElementById('roomCategoryL1').value;
        if (l1 == 'null') {
            alert('카테고리를 선택해주세요.');
            document.getElementById('roomCategoryL1').focus();
            return null;
        }
        if (l3 !== 'null') return l3;
        if (l2 !== 'null') return l2;
        return l1;
    }

    // 방 생성
    function createRoom() {
        const categorySeq = getRoomCategorySeq();
        if (!categorySeq) return;
        const dto = {
            title:        document.getElementById('newRoomName').value,
            maxMemberCnt: document.getElementById('newRoomDescNum').value,
            categorySeq:  categorySeq,
            memberSeq:    loginUserSeq
        };
        fetch('http://localhost:8080/jesiyo/chat/rooms', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(dto)
        }).then(res => {
            if (res.ok) {
                alert('채팅방이 생성되었습니다!');
                closeModal();
                loadRoomList();
            } else {
                alert('채팅방 생성에 실패했습니다.');
            }
        });
    }
    
    // 방 입장
    function joinRoom() {
    	
    	let roomCode = document.getElementById('joinCode').value;
    	
    	fetch('http://localhost:8080/jesiyo/chat/enter', {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
            	memberSeq: loginUserSeq,
                roomCode: roomCode
            })
        })
        .then(res => res.json())
        .then(data => {
            console.log("입장 성공:", data);
            // 예: window.location.href = "/chat/room/" + roomCode;
         	// 방에 있는 모든 사람에게 멤버 목록 갱신 신호 전송
            /* if (ws !== null && ws.readyState === WebSocket.OPEN) {
                ws.send(JSON.stringify({ code: 'REFRESH_MEMBERS' }));
            } */
            
            closeModal();
            loadRoomList();
            loadRoomMembers(data);
        })
        .catch(err => {
            console.error("입장 실패:", err);
            alert("입장 실패!");
        });
    	
    }

    // 채팅방 클릭 → 입장
    document.getElementById('roomList').addEventListener('click', function(e) {
        const roomItem = e.target.closest('.room-item');
        if (!roomItem) return;
        enterRoom(roomItem.dataset.roomId);
    });

    function enterRoom(roomId) {
        document.getElementById('emptyState').style.display = 'none';
        document.getElementById('chatHeader').style.display = 'flex';
        document.getElementById('chatBody').style.display = 'flex';

        if (ws !== null && ws.readyState === WebSocket.OPEN) ws.close();

        // 방 정보
        fetch('http://localhost:8080/jesiyo/chat/rooms/' + roomId)
            .then(res => res.json())
            .then(room => {
                document.getElementById('currentRoomName').innerHTML = 
                    `\${room.title} <small>\${room.code}</small>`;
            });
        
        // 참여자 목록보기
       	loadRoomMembers(roomId);

        // 내 멤버 seq
        fetch('http://localhost:8080/jesiyo/chat/rooms/' + roomId + '/member/' + loginUserSeq)
            .then(res => res.json())
            .then(data => {
                mySeq = data;
            });
        

        // 채팅 로그
        fetch('http://localhost:8080/jesiyo/chat/rooms/logs/' + roomId)
            .then(res => res.json())
            .then(logs => {
                const area = document.getElementById('messagesArea');
                area.innerHTML = '';
                logs.forEach(log => {
                    const div = document.createElement('div');
                    div.classList.add('message');
                    div.innerHTML = `
                        <div class="avatar">\${String(log.nickname).charAt(0)}</div>
                        <div class="message-body">
                            <div class="message-header">
                                <span class="sender">\${log.nickname}</span>
                                <span class="time">\${log.regDate}</span>
                            </div>
                            <div class="content">\${log.content}</div>
                        </div>
                    `;
                    area.appendChild(div);
                });
                area.scrollTop = area.scrollHeight;
            });

        // 소켓 연결
        ws = new WebSocket('ws://localhost:8080/jesiyo/chat/ws/' + roomId);

        ws.onopen = function() {
            console.log('소켓 연결됨 - roomId: ' + roomId);
        };

        ws.onmessage = function(evt) {
            const message = JSON.parse(evt.data);
            
         	// ✅ 멤버 갱신 신호 처리
            if (message.code === 'REFRESH_MEMBERS') {
                loadRoomMembers(roomId);
                return; // 채팅 렌더링 없이 여기서 끝
            }
            
            const area = document.getElementById('messagesArea');
            const div = document.createElement('div');
            div.classList.add('message');
            div.innerHTML = `
                <div class="avatar">\${String(message.sender).charAt(0)}</div>
                <div class="message-body">
                    <div class="message-header">
                        <span class="sender">\${message.sender}</span>
                        <span class="time">\${message.regDate}</span>
                    </div>
                    <div class="content">\${message.content}</div>
                </div>
            `;
            area.appendChild(div);
            area.scrollTop = area.scrollHeight;
        };

        ws.onclose = function() { console.log('소켓 연결 종료'); };
        ws.onerror = function(err) { console.error('소켓 오류:', err); };
    }

    // 메시지 전송
    function sendMessage() {
        const input = document.getElementById('messageInput');
        const content = input.value.trim();
        if (content === '' || ws === null || ws.readyState !== WebSocket.OPEN) return;
        const message = {
            code: '3',
            sender: nickname,
            chatMemberSeq: mySeq,
            content: content,
            regDate: new Date().toLocaleString()
        };
        ws.send(JSON.stringify(message));
        input.value = '';
    }
    
    
    // 참여자 리스트
    function loadRoomMembers(roomId) {
    fetch('http://localhost:8080/jesiyo/chat/room/' + roomId + '/members')
        .then(res => res.json())
        .then(members => {
            const userList = document.getElementById('userList');
            const userCount = document.getElementById('userCount');

            userCount.textContent = members.length;
            userList.innerHTML = '';

            members.forEach(member => {
                const div = document.createElement('div');
                div.classList.add('user-item');
                div.innerHTML = `
                    <div class="avatar">\${String(member.nickname).charAt(0)}</div>
                    <span class="user-name">\${member.nickname}</span>
                `;
                userList.appendChild(div);
            });
        })
        .catch(err => console.error("참여자 목록 조회 실패:", err));
}


    </script>

</body>
</html>
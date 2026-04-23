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

    <style type="text/tailwindcss">
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
            <button class="btn-add-room">
                <span style="font-size: 1.1rem; line-height: 1;">+</span>
                <span>개인 채팅</span>
            </button>
        
            <div class="room-panel-header">
                <span>채팅방 목록</span>
            </div>

            <%-- ① 내가 참여한 채팅방 목록 --%>
            <div class="room-list" id="roomList">
                <c:choose>
                    <c:when test="${not empty chatRooms}">
                        <c:forEach var="room" items="${chatRooms}">
                            <div
                                class="room-item ${room.roomId == currentRoomId ? 'active' : ''}">
                                <span class="room-hash">#</span> <span
                                    class="truncate">${room.roomName}</span>
                                <c:if test="${room.unreadCount > 0}">
                                    <span class="unread-badge">${room.unreadCount}</span>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="px-3 py-4 text-center">
                            <p class="text-xs leading-relaxed"
                                style="color: #72767d;">
                                아직 참여한 채팅방이 없어요.<br> 아래 <span
                                    style="color: #ff8a3d;">+</span>
                                버튼으로 만들거나<br> 코드로 입장해보세요!
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            

            <%-- 4 채팅방 생성/입장 버튼 --%>
            <button class="btn-add-room">
                <span style="font-size: 1.1rem; line-height: 1;">+</span>
                <span>채팅방 만들기 / 입장</span>
            </button>
            
        </aside>

        <%-- 2 3 오른쪽: 채팅 메인 영역 --%>
        <main class="chat-main">

            <%-- 채팅 헤더 (채팅방 선택 후 노출) --%>
            <div class="chat-header" id="chatHeader"
                style="display: none;">
                <span class="hash-icon">#</span> <span
                    id="currentRoomName">채팅방</span> <span
                    style="color: #72767d; font-size: 0.75rem; font-weight: 400; margin-left: 0.5rem;"
                    id="currentRoomDesc"></span>
            </div>

            <%-- ② 채팅방 미참여 상태 (환영 메시지) --%>
            <div class="empty-state" id="emptyState">
                <div class="empty-icon">💬</div>
                <h3>Jesiyo 채팅에 오신 걸 환영해요!</h3>
                <p>채팅방을 만들거나, 초대 코드로 기존 채팅방에 입장해보세요. 거래 상대방과 실시간으로
                    대화할 수 있어요.</p>
                <div class="empty-actions">
                    <button class="btn-primary-discord">채팅방 만들기</button>
                    <button class="btn-secondary-discord">코드로
                        입장</button>
                </div>
            </div>

            <%-- ③ 메시지 목록 영역 (채팅방 선택 후 노출) --%>
            <div class="messages-area" id="messagesArea"
                style="display: none;">
                <div class="msg-date-divider">
                    <span id="chatDateLabel">오늘</span>
                </div>

                <c:forEach var="msg" items="${messages}">
                    <div class="msg-group">
                        <div class="msg-avatar"
                            style="background: ${msg.avatarColor};">
                            ${msg.authorInitial}</div>
                        <div class="msg-content">
                            <div class="msg-meta">
                                <span
                                    class="msg-author ${msg.isMe ? 'me' : ''}">${msg.authorName}</span>
                                <span class="msg-time">${msg.sentTime}</span>
                            </div>
                            <p class="msg-text">${msg.content}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <%-- 채팅 입력창 (채팅방 선택 후 노출) --%>
            <div class="chat-input-wrap" id="chatInputWrap"
                style="display: none;">
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
                        id="messageInput" placeholder="메시지를 입력하세요..."
                        maxlength="500" autocomplete="off" />

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

        </main>
    </div>

    <%-- 채팅방 생성/입장 모달 --%>
    <div class="modal-overlay" id="roomModal">
        <div class="modal-box">
            <h2>채팅방</h2>
            <p>새 채팅방을 만들거나 코드로 기존 방에 입장하세요.</p>

            <div class="modal-tabs">
                <div class="modal-tab active" id="tab-create">채팅방
                    만들기</div>
                <div class="modal-tab" id="tab-join">코드로 입장</div>
            </div>

            <%-- 만들기 폼 --%>
            <div id="form-create">
                <label
                    style="display: block; font-size: 0.75rem; font-weight: 700; color: #b5bac1; margin-bottom: 0.4rem; letter-spacing: 0.05em;">
                    채팅방 이름 </label> <input type="text" class="modal-input"
                    id="newRoomName" placeholder="예: 아이폰 거래 채팅"
                    maxlength="30" /> <label
                    style="display: block; font-size: 0.75rem; font-weight: 700; color: #b5bac1; margin-bottom: 0.4rem; letter-spacing: 0.05em;">
                    설명 (선택) </label> <input type="text" class="modal-input"
                    id="newRoomDesc" placeholder="채팅방 설명을 입력하세요"
                    maxlength="60" />
            </div>

            <%-- 입장 폼 --%>
            <div id="form-join" style="display: none;">
                <label
                    style="display: block; font-size: 0.75rem; font-weight: 700; color: #b5bac1; margin-bottom: 0.4rem; letter-spacing: 0.05em;">
                    초대 코드 </label> <input type="text" class="modal-input"
                    id="joinCode" placeholder="초대 코드 8자리 입력"
                    maxlength="8" />
            </div>

            <div class="modal-footer">
                <button class="modal-cancel" id="btnModalCancel">취소</button>
                <button class="modal-confirm" id="btnModalConfirm">확인</button>
            </div>
        </div>
    </div>

    <!-- <script>
   
    </script> -->

</body>
</html>

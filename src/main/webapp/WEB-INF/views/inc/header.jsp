<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    /* 헤더 전체 컨테이너 */
    .main-header {
        width: 100%;
        height: 64px;
        background-color: #ffffff;
        border-bottom: 1px solid #eeeeee;
        display: flex;
        justify-content: center;
        align-items: center;
        position: sticky;
        top: 0;
        z-index: 1000;
        font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
    }

    .header-inner {
        width: 100%;
        max-width: 1200px;
        padding: 0 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    /* 왼쪽 섹션 (로고 + 메뉴) */
    .header-left {
        display: flex;
        align-items: center;
        gap: 40px;
    }

    .logo {
        font-size: 24px;
        font-weight: 800;
        color: #FF8A3D; /* Jesiyo 시그니처 오렌지 */
        text-decoration: none;
    }

    .main-nav {
        display: flex;
        gap: 24px;
    }

    .main-nav a {
        text-decoration: none;
        color: #333333;
        font-size: 16px;
        font-weight: 600;
        transition: color 0.2s;
    }

    .main-nav a:hover {
        color: #FF8A3D;
    }

    /* 오른쪽 섹션 (인증/사용자 메뉴) */
    .header-right {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .auth-link {
        text-decoration: none;
        color: #666666;
        font-size: 14px;
        font-weight: 500;
        transition: color 0.2s;
    }

    .auth-link:hover {
        color: #333333;
    }

    /* 로그아웃 버튼 스타일 */
    .logout-btn {
        color: #999999;
        font-size: 14px;
        font-weight: 500;
        text-decoration: none;
        transition: color 0.2s;
    }

    .logout-btn:hover {
        color: #FF8A3D;
    }

    /* 반응형 처리 */
    @media (max-width: 768px) {
        .main-nav {
            display: none; 
        }
    }
</style>

<header class="main-header">
    <div class="header-inner">
        <div class="header-left">
            <a href="${pageContext.request.contextPath}/index" class="logo">Jesiyo</a>
            <nav class="main-nav">
                <a href="${pageContext.request.contextPath}/chat">채팅방</a>
                <a href="${pageContext.request.contextPath}/direct-sales">중고 거래</a>
                <a href="${pageContext.request.contextPath}/auction">경매</a>
                <a href="${pageContext.request.contextPath}/auction/live">Live Auction</a>
            </nav>
        </div>

		<div class="header-right">
		    <%-- 로그아웃 상태 (익명 사용자) --%>
		    <sec:authorize access="isAnonymous()">
		        <a href="${pageContext.request.contextPath}/member/regist" class="auth-link">회원가입</a>
		        <a href="${pageContext.request.contextPath}/member/login" class="auth-link">로그인</a>
		    </sec:authorize>
		
		    <%-- 로그인 성공 상태 --%>
		    <sec:authorize access="isAuthenticated()">
		        <span class="auth-link" style="color: #333; font-weight: 700;">
		            <%-- 우리가 만든 CustomUser 안의 memberDto에서 이름을 가져옵니다 --%>
		            <sec:authentication property="principal.memberDto.name" />님
		        </span>
<!-- 		        <a href="#" class="auth-link">알림</a> -->
                <div class="relative cursor-pointer" onclick="location.href='/jesiyo/notifications'">
                  🔔
                  <span id="notification-badge"
                    class="hidden absolute -top-1 -right-2 bg-red-500 text-white text-xs rounded-full px-1">
                  </span>
                </div>
            
		        <a href="${pageContext.request.contextPath}/member/mypage" class="auth-link">마이페이지</a>
		        <a href="${pageContext.request.contextPath}/member/logout" class="logout-btn">로그아웃</a>
		    </sec:authorize>
		</div>
    </div>
</header>
<sec:authorize access="isAuthenticated()">
  <script>
      const eventSource = new EventSource("/jesiyo/api/notifications/subscribe");
      eventSource.addEventListener("notification", function (event) {
          const data = JSON.parse(event.data);
          const count = data.unreadCount;
          if (count > 0) {
              $("#notification-badge").text(count).show();
          } else {
              $("#notification-badge").hide();
          }
      });
  </script>
</sec:authorize>
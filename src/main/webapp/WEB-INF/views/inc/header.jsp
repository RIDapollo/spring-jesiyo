<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                <a href="#">채팅방</a>
                <a href="${pageContext.request.contextPath}/direct-sales">중고 거래</a>
                <a href="${pageContext.request.contextPath}/auction">경매</a>
                <a href="${pageContext.request.contextPath}/auction/live">Live Auction</a>
            </nav>
        </div>

        <div class="header-right">
            <c:choose>
                <%-- 로그아웃 상태: 세션의 user가 비어있을 때 --%>
                <c:when test="${empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/member/regist" class="auth-link">회원가입</a>
                    <a href="${pageContext.request.contextPath}/member/login" class="auth-link">로그인</a>
                </c:when>
                
                <%-- 로그인 상태: 세션에 user 정보가 있을 때 --%>
                <c:otherwise>
                    <span class="auth-link" style="color: #333; font-weight: 700;">${sessionScope.user.name}님</span>
                    <a href="#" class="auth-link">알림</a>
                    <a href="#" class="auth-link">예치금</a>
                    <a href="#" class="auth-link">마이페이지</a>
                    <a href="${pageContext.request.contextPath}/member/logout" class="logout-btn">로그아웃</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
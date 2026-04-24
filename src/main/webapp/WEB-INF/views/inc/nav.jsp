<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/navbar.css">
</head>
<body>
    <header class="main-header">
        <div class="header-inner">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/" class="logo">Jesiyo</a>
                <nav class="main-nav">
                    <a href="#">채팅방</a>
                    <a href="#">중고 거래</a>
                    <a href="#">경매</a>
                </nav>
            </div>

            <div class="header-right">
                <c:choose>
                    <%-- 로그아웃 상태 --%>
                    <c:when test="${empty sessionScope.user}">
                        <a href="#" class="auth-link">회원가입</a>
                        <a href="#" class="auth-link">로그인</a>
                    </c:when>
                    
                    <%-- 로그인 상태 --%>
                    <c:otherwise>
                        <a href="#" class="auth-link">알림</a>
                        <a href="#" class="auth-link">예치금</a>
                        <a href="#" class="auth-link">마이페이지</a>
                        <a href="#" class="auth-link logout">로그아웃</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>
</body>
</html>
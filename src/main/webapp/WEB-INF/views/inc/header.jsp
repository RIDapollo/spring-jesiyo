<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- header.jsp -->
<header>

    <sec:authorize access="isAnonymous()">
    <h1>Spring Security <small>Anonymous</small></h1>
    </sec:authorize>
    
    <sec:authorize access="isAuthenticated()">
    <h1>Spring Security <small><sec:authentication property="principal.username" /></small></h1>    
    </sec:authorize>
    
    
    <ul>
        <li><a href="/jesiyo/index.do">Index</a></li>
        
        <sec:authorize access="hasRole('ROLE_MEMBER')">
        <li><a href="/jesiyo/member.do">Member</a></li>
        </sec:authorize>
        
        <sec:authorize access="hasRole('ROLE_ADMIN')">
        <li><a href="/jesiyo/admin.do">Admin</a></li>
        </sec:authorize>
        
        <li class="divider"></li>
        
        <li><a href="/jesiyo/trade.do">Trade</a>
        <li><a href="/jesiyo/auction.do">Auction</a>
        <li><a href="/jesiyo/chat.do">Chat</a>
        
        <sec:authorize access="isAnonymous()">
        <li><a href="/jesiyo/customlogin.do">Login</a>
        </sec:authorize>
        
        <sec:authorize access="isAuthenticated()">
        <li><a href="/jesiyo/customlogout.do">Logout</a>
        </sec:authorize>

        <li class="divider"></li>
        
        <sec:authorize access="isAnonymous()">
        <li><a href="/jesiyo/register.do">Register</a>
        </sec:authorize>
        
    </ul>
</header>






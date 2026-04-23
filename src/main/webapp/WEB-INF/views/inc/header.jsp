<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<header class="bg-white border-b border-slate-200 sticky top-0 z-50 shadow-sm">
    <div class="max-w-6xl w-full mx-auto px-4 h-16 flex items-center justify-between">
        
        <div class="flex items-center gap-8">
            <a href="/jesiyo/index" class="text-2xl font-black text-brand-500 tracking-tight">
                Jesiyo
            </a>
            
            <nav>
                <ul class="flex items-center gap-6 text-base font-bold text-slate-700">
                    <li><a href="/jesiyo/trade" class="hover:text-brand-500 transition-colors">중고거래</a></li>
                    <li><a href="/jesiyo/auction" class="hover:text-brand-500 transition-colors">경매</a></li>
                    <li><a href="/jesiyo/chat" class="hover:text-brand-500 transition-colors">채팅</a></li>
                </ul>
            </nav>
        </div>

        <div class="flex items-center gap-4 text-sm font-semibold text-slate-600">
            
            <sec:authorize access="isAuthenticated()">
                <div class="flex items-center gap-4">
                    <span class="text-slate-800">
                        <b class="text-brand-500 text-base"><sec:authentication property="principal.username" /></b>님
                    </span>
                    
                    <sec:authorize access="hasRole('ROLE_MEMBER')">
                        <a href="/jesiyo/member class="hover:text-brand-500 transition-colors">마이페이지</a>
                    </sec:authorize>
                    
                    <sec:authorize access="hasRole('ROLE_ADMIN')">
                        <a href="/jesiyo/admin" class="text-rose-500 hover:text-rose-600 transition-colors">관리자</a>
                    </sec:authorize>
                    
                    <a href="/jesiyo/customlogout" class="btn-soft-brand px-3 py-1.5 text-xs rounded-md ml-2">
                        로그아웃
                    </a>
                </div>
            </sec:authorize>

            <sec:authorize access="isAnonymous()">
                <a href="/jesiyo/customlogin" class="hover:text-brand-500 transition-colors">로그인</a>
                <span class="w-px h-3 bg-slate-300 mx-1"></span>
                <a href="/jesiyo/register" class="hover:text-brand-500 transition-colors">회원가입</a>
            </sec:authorize>
            
        </div>
    </div>
</header>
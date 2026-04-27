<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 아이디 찾기</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body class="bg-[#F8FAFC] text-slate-900 m-0 p-0">

    <%@ include file="/WEB-INF/views/inc/header.jsp" %>

    <div class="w-full min-h-[calc(100vh-80px)] flex justify-center items-center px-4 py-12">
        
        <div class="w-full max-w-[500px] bg-white border border-slate-200 rounded-[2.5rem] shadow-xl shadow-slate-200/40"
             style="padding: 3.5rem !important;">
            
            <div class="text-center" style="margin-bottom: 3rem !important;">
                <h1 class="text-5xl font-black text-[#FF8A3D] mb-4 tracking-tighter">Jesiyo</h1>
                <h2 class="text-xl font-bold text-slate-600 mb-2">아이디 찾기</h2>
                <p class="text-slate-400 font-medium text-sm">가입 시 등록한 이메일을 입력해주세요.</p>
            </div>

            <c:choose>
                <%-- 1. 아이디 찾기 결과가 있는 경우 --%>
                <c:when test="${not empty foundId}">
                    <div class="text-center">
                        <div class="mb-8 p-6 bg-orange-50 border border-orange-100 rounded-2xl">
                            <p class="text-slate-600 mb-2">고객님의 아이디는 아래와 같습니다.</p>
                            <span class="text-2xl font-black text-[#FF8A3D] tracking-wider">${foundId}****</span>
                        </div>
                        
                        <a href="${pageContext.request.contextPath}/member/login" 
                           class="block w-full bg-[#FF8A3D] hover:bg-[#e07530] text-white font-bold py-5 px-4 rounded-2xl transition-all shadow-lg shadow-[#FF8A3D]/20 text-xl text-center">
                            로그인하러 가기
                        </a>
                    </div>
                </c:when>

                <%-- 2. 기본 입력 폼 (결과가 없거나 초기 상태) --%>
                <c:otherwise>
                    <c:if test="${param.error == 'true'}">
                        <div class="mb-8 p-4 bg-red-50 border border-red-100 text-red-500 rounded-2xl text-center text-sm font-medium">
                            일치하는 회원 정보가 없습니다.
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/member/findId" method="POST">
                        <%-- Spring Security CSRF 토큰 (설정에 따라 필요 시 사용) --%>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        
                        <div style="margin-bottom: 2.5rem !important;">
                            <label for="email" class="block text-xs font-bold text-slate-400 mb-2 ml-2 tracking-widest uppercase">EMAIL</label>
                            <div class="border-2 border-slate-100 rounded-2xl bg-slate-50 p-1 transition-all focus-within:border-[#FF8A3D] focus-within:bg-white focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
                                <input type="email" id="email" name="email" placeholder="example@email.com" required autofocus
                                       class="w-full px-5 py-4 bg-transparent border-none focus:ring-0 text-lg text-slate-700 placeholder:text-slate-300">
                            </div>
                        </div>

                        <button type="submit" 
                                class="w-full bg-[#FF8A3D] hover:bg-[#e07530] text-white font-bold py-5 px-4 rounded-2xl transition-all shadow-lg shadow-[#FF8A3D]/20 text-xl active:scale-95">
                            아이디 확인
                        </button>
                    </form>
                </c:otherwise>
            </c:choose>

            <div class="border-t border-slate-100 flex flex-col items-center text-sm font-medium text-slate-400"
                 style="margin-top: 3rem !important;">
                
                <div style="margin-top: 2rem !important;">
                    <a href="${pageContext.request.contextPath}/member/login" class="hover:text-slate-800">로그인 화면으로 돌아가기</a>
                </div>
            </div>

        </div>
    </div>

</body>
</html>
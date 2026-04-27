<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 로그인</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body class="bg-[#F8FAFC] text-slate-900 m-0 p-0">

    <%@ include file="/WEB-INF/views/inc/header.jsp" %>

    <div class="w-full min-h-[calc(100vh-80px)] flex justify-center items-center px-4 py-12">
        
        <div class="w-full max-w-[500px] bg-white border border-slate-200 rounded-[2.5rem] shadow-xl shadow-slate-200/40"
             style="padding: 3.5rem !important;">
            
            <div class="text-center" style="margin-bottom: 3rem !important;">
                <h1 class="text-5xl font-black text-[#FF8A3D] mb-4 tracking-tighter">Jesiyo</h1>
                <h2 class="text-xl font-bold text-slate-600 mb-2">로그인</h2>
                <p class="text-slate-400 font-medium text-sm">우리 동네 따뜻한 거래, 지금 시작하세요.</p>
            </div>

            <c:if test="${param.error == 'true'}">
                <div class="mb-8 p-4 bg-red-50 border border-red-100 text-red-500 rounded-2xl text-center text-sm font-medium">
                    아이디 또는 비밀번호가 일치하지 않습니다.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/member/login" method="POST">
                
                <div style="margin-bottom: 1.5rem !important;">
                    <label for="userId" class="block text-xs font-bold text-slate-400 mb-2 ml-2 tracking-widest uppercase">ID</label>
                    <div class="border-2 border-slate-100 rounded-2xl bg-slate-50 p-1 transition-all focus-within:border-[#FF8A3D] focus-within:bg-white focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
                        <input type="text" id="userId" name="userId" placeholder="아이디를 입력해주세요" required autofocus
                               class="w-full px-5 py-4 bg-transparent border-none focus:ring-0 text-lg text-slate-700 placeholder:text-slate-300">
                    </div>
                </div>

                <div style="margin-bottom: 2.5rem !important;">
                    <label for="userPw" class="block text-xs font-bold text-slate-400 mb-2 ml-2 tracking-widest uppercase">PW</label>
                    <div class="border-2 border-slate-100 rounded-2xl bg-slate-50 p-1 transition-all focus-within:border-[#FF8A3D] focus-within:bg-white focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
                        <input type="password" id="userPw" name="userPw" placeholder="비밀번호를 입력해주세요" required
                               class="w-full px-5 py-4 bg-transparent border-none focus:ring-0 text-lg text-slate-700 placeholder:text-slate-300">
                    </div>
                </div>

                <button type="submit" 
                        class="w-full bg-[#FF8A3D] hover:bg-[#e07530] text-white font-bold py-5 px-4 rounded-2xl transition-all shadow-lg shadow-[#FF8A3D]/20 text-xl active:scale-95">
                    로그인
                </button>
            </form>

            <div class="border-t border-slate-100 flex flex-col items-center text-sm font-medium text-slate-400"
                 style="margin-top: 3rem !important;">
                
                <div style="margin-top: 2rem !important; margin-bottom: 1rem !important;">
                    회원이 아니신가요? 
                    <a href="${pageContext.request.contextPath}/join" class="text-[#FF8A3D] font-bold hover:underline ml-2">회원가입</a>
                </div>
                
                <div class="flex items-center space-x-6 opacity-80">
                    <a href="${pageContext.request.contextPath}/member/findId" class="hover:text-slate-800">ID 찾기</a>
                    <span class="w-1 h-1 bg-slate-300 rounded-full"></span>
                    <a href="${pageContext.request.contextPath}/member/findPw" class="hover:text-slate-800">PW 재설정</a>
                </div>
            </div>

        </div>
    </div>

</body>
</html>
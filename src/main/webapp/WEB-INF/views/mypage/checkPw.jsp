<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 비밀번호 확인</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@5" rel="stylesheet" type="text/css" />

    <style>
        body { font-family: "Pretendard", sans-serif; background-color: #f8fafc; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/header.jsp" />

    <main class="flex flex-col items-center justify-center min-h-[calc(100vh-200px)] px-4">
        <div class="max-w-md w-full bg-white border border-slate-200 rounded-[2.5rem] p-10 shadow-sm">
            <header class="text-center mb-8">
                <div class="inline-flex items-center justify-center w-16 h-16 bg-orange-50 rounded-full mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#ff8a3d" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                </div>
                <h2 class="text-2xl font-black text-slate-900 mb-2">비밀번호 재확인</h2>
                <p class="text-slate-500 font-medium text-sm leading-relaxed">
                    회원님의 소중한 정보를 보호하기 위해<br>비밀번호를 다시 한번 입력해 주세요.
                </p>
            </header>

            <form action="${pageContext.request.contextPath}/member/checkPw" method="POST" class="space-y-6">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <div>
                    <label class="block text-sm font-bold text-slate-700 mb-2 ml-1">비밀번호</label>
                    <input type="password" name="userPw" required autofocus
                           placeholder="비밀번호를 입력하세요"
                           class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-2 focus:ring-orange-500 focus:bg-white outline-none transition-all">
                    
                    <c:if test="${not empty error}">
                        <p class="text-rose-500 text-xs font-bold mt-2 ml-1 flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            ${error}
                        </p>
                    </c:if>
                </div>

                <div class="flex flex-col gap-3 pt-2">
                    <button type="submit" 
                            class="w-full py-5 bg-[#ff8a3d] text-white font-black rounded-3xl shadow-lg shadow-orange-100 hover:bg-[#e67026] active:scale-95 transition-all text-lg">
                        확인 후 진행하기
                    </button>
                    <button type="button" onclick="history.back()"
                            class="w-full py-4 text-slate-400 font-bold text-sm hover:text-slate-600 transition-colors">
                        취소
                    </button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>
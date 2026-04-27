<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 비밀번호 재설정</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body class="bg-[#F8FAFC] text-slate-900 m-0 p-0">

    <%@ include file="/WEB-INF/views/inc/header.jsp" %>

    <div class="w-full min-h-[calc(100vh-80px)] flex justify-center items-center px-4 py-12">
        
        <div class="w-full max-w-[500px] bg-white border border-slate-200 rounded-[2.5rem] shadow-xl shadow-slate-200/40"
             style="padding: 3.5rem !important;">
            
            <div class="text-center" style="margin-bottom: 3rem !important;">
                <h1 class="text-5xl font-black text-[#FF8A3D] mb-4 tracking-tighter">Jesiyo</h1>
                <h2 class="text-xl font-bold text-slate-600 mb-2">비밀번호 재설정</h2>
                <p class="text-slate-400 font-medium text-sm">새로운 비밀번호를 입력해 주세요.</p>
            </div>

            <form action="${pageContext.request.contextPath}/member/resetPw" method="POST" id="resetForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <%-- 컨트롤러에서 전달받은 토큰 --%>
                <input type="hidden" name="token" value="${token}"/>
                
                <%-- 새 비밀번호 --%>
                <div style="margin-bottom: 1.5rem !important;">
                    <label class="block text-xs font-bold text-slate-400 mb-2 ml-2 tracking-widest uppercase">NEW PASSWORD</label>
                    <div class="border-2 border-slate-100 rounded-2xl bg-slate-50 p-1 transition-all focus-within:border-[#FF8A3D] focus-within:bg-white focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
                        <input type="password" id="userPw" name="userPw" placeholder="새 비밀번호" required
                               class="w-full px-5 py-4 bg-transparent border-none focus:ring-0 text-lg text-slate-700 placeholder:text-slate-300">
                    </div>
                </div>

                <%-- 비밀번호 확인 --%>
                <div style="margin-bottom: 2.5rem !important;">
                    <label class="block text-xs font-bold text-slate-400 mb-2 ml-2 tracking-widest uppercase">CONFIRM PASSWORD</label>
                    <div class="border-2 border-slate-100 rounded-2xl bg-slate-50 p-1 transition-all focus-within:border-[#FF8A3D] focus-within:bg-white focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
                        <input type="password" id="userPwCheck" placeholder="비밀번호 확인" required
                               class="w-full px-5 py-4 bg-transparent border-none focus:ring-0 text-lg text-slate-700 placeholder:text-slate-300">
                    </div>
                </div>

                <button type="submit" 
                        class="w-full bg-[#FF8A3D] hover:bg-[#e07530] text-white font-bold py-5 px-4 rounded-2xl transition-all shadow-lg shadow-[#FF8A3D]/20 text-xl active:scale-95">
                    비밀번호 변경 완료
                </button>
            </form>

        </div>
    </div>

    <script>
        // 비밀번호 일치 확인 스크립트
        $('#resetForm').submit(function() {
            if($('#userPw').val() !== $('#userPwCheck').val()) {
                alert('비밀번호가 일치하지 않습니다.');
                return false;
            }
            return true;
        });
    </script>
</body>
</html>
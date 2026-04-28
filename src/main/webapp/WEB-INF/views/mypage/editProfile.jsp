<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jesiyo - 프로필 수정</title>
    
    <%-- 1. 라이브러리 로드 (순서 중요) --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <%-- Tailwind 4 브라우저 컴파일러 --%>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <%-- DaisyUI 5 --%>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@5" rel="stylesheet" type="text/css" />

    <style>
        body { font-family: "Pretendard", sans-serif; background-color: #f8fafc; }
        /* 이미지 미리보기 둥글게 */
        #profilePreview { border-radius: 9999px; }
    </style>

    <%-- 2. Tailwind 설정 (JSP 충돌 방지를 위해 최소화) --%>
    <style type="text/tailwindcss">
        @theme {
            --color-brand-500: #ff8a3d;
            --color-brand-600: #e67026;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/header.jsp" />

    <%-- 3. 메인 컨테이너 --%>
    <main class="max-w-2xl mx-auto px-4 py-12">
        <div class="bg-white border border-slate-200 rounded-[2.5rem] p-8 md:p-12 shadow-sm">
            
            <header class="mb-10">
                <h2 class="text-3xl font-black text-slate-900 tracking-tight">프로필 수정</h2>
                <p class="text-slate-500 font-medium mt-1">회원님의 정보를 안전하게 수정하세요.</p>
            </header>

            <form action="${pageContext.request.contextPath}/member/editProfile" method="POST" enctype="multipart/form-data" class="space-y-10">
                <%-- Security CSRF --%>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <%-- [1] 프로필 이미지 업로드 섹션 --%>
                <div class="flex flex-col sm:flex-row items-center gap-8 pb-8 border-b border-slate-100">
                    <div class="relative">
                        <img id="profilePreview" 
                             src="${not empty member.profileImg ? '/profile/'.concat(member.profileImg) : '/resources/img/default-profile.png'}" 
                             class="w-32 h-32 rounded-full object-cover border-4 border-white shadow-md">
                    </div>
                    <div class="flex flex-col gap-3 items-center sm:items-start">
                        <label for="profileImg" class="px-8 py-3 bg-slate-900 text-white font-bold rounded-2xl cursor-pointer hover:bg-slate-700 transition-all text-sm">
                            이미지 변경하기
                        </label>
                        <input type="file" id="profileImg" name="profileImgFile" class="hidden" accept="image/*" onchange="previewImage(this)">
                        <p class="text-xs text-slate-400 font-medium">최적 사이즈: 300x300 (JPG, PNG)</p>
                    </div>
                </div>

                <div class="space-y-8">
                    <%-- [2, 3] 비밀번호 섹션 --%>
                    <div class="space-y-3">
                        <label class="block text-sm font-bold text-slate-700 ml-1">비밀번호 변경</label>
                        <input type="password" name="userPw" id="userPw" placeholder="새 비밀번호 (변경 시에만 입력)" 
                               class="w-full px-6 py-4 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-2 focus:ring-brand-500 focus:bg-white outline-none transition-all">
                        <input type="password" id="userPwCheck" placeholder="새 비밀번호 확인" 
                               class="w-full px-6 py-4 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-2 focus:ring-brand-500 focus:bg-white outline-none transition-all">
                        <p id="pwMsg" class="text-[11px] font-bold ml-2"></p>
                    </div>

                    <%-- [4] 주소 섹션 --%>
                    <div class="space-y-3">
                        <label class="block text-sm font-bold text-slate-700 ml-1">주소 정보</label>
                        <div class="flex gap-2">
                            <input type="text" name="zipcode" id="zipcode" value="${member.zipcode}" readonly 
                                   class="flex-1 px-6 py-4 bg-slate-100 border border-slate-200 rounded-2xl text-slate-500 outline-none">
                            <button type="button" onclick="searchAddr()" 
                                    class="px-6 bg-slate-200 text-slate-800 font-bold rounded-2xl text-sm hover:bg-slate-300 transition-colors">주소 검색</button>
                        </div>
                        <input type="text" name="address" id="address" value="${member.address}" readonly 
                               class="w-full px-6 py-4 bg-slate-100 border border-slate-200 rounded-2xl text-slate-500 outline-none">
                        <input type="text" name="detailAddress" id="detailAddress" value="${member.detailAddress}" placeholder="상세 주소를 입력하세요" 
                               class="w-full px-6 py-4 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-2 focus:ring-brand-500 outline-none transition-all">
                    </div>

                    <%-- [5] 닉네임 섹션 --%>
                    <div class="space-y-3">
                        <label class="block text-sm font-bold text-slate-700 ml-1">닉네임</label>
                        <input type="text" name="nickname" value="${member.nickname}" required 
                               class="w-full px-6 py-4 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-2 focus:ring-brand-500 outline-none transition-all">
                    </div>
                </div>

                <%-- [6] 수정 버튼 --%>
                <div class="pt-8">
                    <button type="submit" 
                            class="w-full py-5 bg-brand-500 text-white font-black rounded-[1.5rem] shadow-xl shadow-orange-100 hover:bg-brand-600 active:scale-[0.98] transition-all text-xl">
                        내 정보 수정하기
                    </button>
                    <p class="text-center mt-6">
                        <a href="javascript:history.back()" class="text-slate-400 font-bold text-sm hover:text-slate-600 transition-colors">수정 취소</a>
                    </p>
                </div>
            </form>
        </div>
    </main>

    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
        function previewImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = e => $('#profilePreview').attr('src', e.target.result);
                reader.readAsDataURL(input.files[0]);
            }
        }

        $('#userPw, #userPwCheck').on('keyup', function() {
            const pw = $('#userPw').val();
            const pw2 = $('#userPwCheck').val();
            const msg = $('#pwMsg');
            if(!pw && !pw2) return msg.text('');
            if(pw === pw2) msg.text('비밀번호가 일치합니다.').css('color', '#10B981');
            else msg.text('비밀번호가 일치하지 않습니다.').css('color', '#EF4444');
        });

        function searchAddr() {
            new daum.Postcode({
                oncomplete: data => {
                    $('#zipcode').val(data.zonecode);
                    $('#address').val(data.address);
                    $('#detailAddress').focus();
                }
            }).open();
        }
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 회원가입</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        /* [75% 압축 적용] */
        .custom-input input {
            padding-top: 13px !important;    /* 17px * 0.75 ≒ 13px */
            padding-bottom: 13px !important; 
            padding-left: 35px !important;   /* 좌측 여백은 유지 */
            font-size: 15px !important;      /* 폰트 사이즈 유지 */
        }
        /* 버튼 높이 및 너비 조정 */
        .btn-expand {
            padding-top: 13px !important;
            padding-bottom: 13px !important;
            padding-left: 27px !important;
            padding-right: 27px !important;
            font-size: 12px !important;
        }
        /* 섹션 간 간격 압축 */
        .form-group {
            margin-bottom: 1.3rem !important; /* 1.8rem * 0.75 ≒ 1.3rem */
        }
    </style>
</head>
<body class="bg-[#F8FAFC] text-slate-900 m-0 p-0">

    <%@ include file="/WEB-INF/views/inc/nav.jsp" %>

    <div class="w-full min-h-[calc(100vh-80px)] flex justify-center items-center px-4 py-12">
        
        <div class="w-full max-w-[550px] bg-white border border-slate-200 rounded-[2.5rem] shadow-xl shadow-slate-200/40"
             style="padding: 3rem !important;">
            
            <div class="text-center" style="margin-bottom: 2.6rem !important;">
                <h1 class="text-5xl font-black text-[#FF8A3D] mb-3 tracking-tighter">Jesiyo</h1>
                <h2 class="text-xl font-bold text-slate-600 mb-1">회원가입</h2>
                <p class="text-slate-400 font-medium text-xs">우리 동네 따뜻한 거래, 지금 시작하세요.</p>
            </div>

            <form action="${pageContext.request.contextPath}/member/regist" method="POST" id="registForm" class="custom-input">
                
                <div class="form-group">
                    <label class="block text-[10px] font-bold text-slate-400 mb-1.5 ml-2 tracking-widest uppercase">ID</label>
                    <div class="flex gap-3">
                        <div class="flex-1 border-2 border-slate-100 rounded-2xl bg-slate-50 p-0.5 transition-all focus-within:border-[#FF8A3D] focus-within:bg-white focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
                            <input type="text" name="userId" id="userId" placeholder="아이디를 입력해주세요" required
                                   class="w-full bg-transparent border-none focus:ring-0 text-slate-700 placeholder:text-slate-300">
                        </div>
                        <button type="button" onclick="checkId()" 
                                class="btn-expand bg-slate-800 text-white font-bold rounded-2xl hover:bg-black transition-all active:scale-95">중복확인</button>
                    </div>
                    <p id="idMsg" class="text-[10px] mt-1.5 ml-3 font-medium"></p>
                </div>

                <div class="form-group">
                    <label class="block text-[10px] font-bold text-slate-400 mb-1.5 ml-2 tracking-widest uppercase">PW</label>
                    <div class="border-2 border-slate-100 rounded-2xl bg-slate-50 p-0.5 transition-all focus-within:border-[#FF8A3D] focus-within:bg-white focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
                        <input type="password" name="userPw" id="userPw" placeholder="비밀번호를 입력해주세요" required
                               class="w-full bg-transparent border-none focus:ring-0 text-slate-700 placeholder:text-slate-300">
                    </div>
                </div>

                <div class="form-group">
                    <label class="block text-[10px] font-bold text-slate-400 mb-1.5 ml-2 tracking-widest uppercase">PW 확인</label>
                    <div class="border-2 border-slate-100 rounded-2xl bg-slate-50 p-0.5 transition-all focus-within:border-[#FF8A3D] focus-within:bg-white focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
                        <input type="password" id="userPwCheck" placeholder="비밀번호를 다시 입력해주세요" required
                               class="w-full bg-transparent border-none focus:ring-0 text-slate-700 placeholder:text-slate-300">
                    </div>
                </div>
                <div class="form-group">
				    <label class="block text-[10px] font-bold text-slate-400 mb-1.5 ml-2 tracking-widest uppercase">Email</label>
				    <div class="border-2 border-slate-100 rounded-2xl bg-slate-50 p-0.5 transition-all focus-within:border-[#FF8A3D] focus-within:bg-white focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
				        <input type="email" name="email" placeholder="이메일을 입력해주세요" required
				               class="w-full bg-transparent border-none focus:ring-0 text-slate-700 placeholder:text-slate-300"
				               style="padding-top: 13px !important; padding-bottom: 13px !important; padding-left: 35px !important; font-size: 15px !important;">
				    </div>
				</div>
                <div class="form-group">
                    <label class="block text-[10px] font-bold text-slate-400 mb-1.5 ml-2 tracking-widest">이름</label>
                    <div class="border-2 border-slate-100 rounded-2xl bg-slate-50 p-0.5 transition-all focus-within:border-[#FF8A3D] focus-within:bg-white focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
                        <input type="text" name="name" placeholder="실명을 입력해주세요" required
                               class="w-full bg-transparent border-none focus:ring-0 text-slate-700 placeholder:text-slate-300">
                    </div>
                </div>

                <div class="form-group">
                    <label class="block text-[10px] font-bold text-slate-400 mb-1.5 ml-2 tracking-widest">생년월일</label>
                    <div class="border-2 border-slate-100 rounded-2xl bg-slate-50 p-0.5 transition-all focus-within:border-[#FF8A3D] focus-within:bg-white focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
                        <input type="date" name="birth" required
                               class="w-full bg-transparent border-none focus:ring-0 text-slate-500">
                    </div>
                </div>

                <div class="form-group">
                    <label class="block text-[10px] font-bold text-slate-400 mb-1.5 ml-2 tracking-widest">닉네임</label>
                    <div class="border-2 border-slate-100 rounded-2xl bg-slate-50 p-0.5 transition-all focus-within:border-[#FF8A3D] focus-within:bg-white focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
                        <input type="text" name="nickname" placeholder="사용하실 닉네임을 입력해주세요" required
                               class="w-full bg-transparent border-none focus:ring-0 text-slate-700 placeholder:text-slate-300">
                    </div>
                </div>

                <div style="margin-bottom: 2.2rem !important;">
                    <label class="block text-[10px] font-bold text-slate-400 mb-1.5 ml-2 tracking-widest uppercase">Address</label>
                    
                    <div class="flex gap-3" style="margin-bottom: 0.6rem !important;">
                        <div class="w-32 border-2 border-slate-100 rounded-2xl bg-slate-50 p-0.5">
                            <input type="text" name="zipcode" id="zipcode" placeholder="우편번호" readonly
                                   class="w-full bg-transparent border-none focus:ring-0 text-center text-slate-700" style="padding: 13px 0 !important; font-size: 15px !important;">
                        </div>
                        <button type="button" onclick="execDaumPostcode()" 
                                class="btn-expand bg-slate-100 text-slate-600 font-bold rounded-2xl hover:bg-slate-200 transition-all">주소 검색</button>
                    </div>

                    <div class="border-2 border-slate-100 rounded-2xl bg-slate-50 p-0.5" style="margin-bottom: 0.6rem !important;">
                        <input type="text" name="address" id="address" placeholder="기본 주소" readonly
                               class="w-full bg-transparent border-none focus:ring-0 text-slate-700">
                    </div>

                    <div class="border-2 border-slate-100 rounded-2xl bg-white p-0.5 transition-all focus-within:border-[#FF8A3D] focus-within:ring-4 focus-within:ring-[#FF8A3D]/5">
                        <input type="text" name="detailAddress" id="detailAddress" placeholder="상세 주소를 입력해주세요"
                               class="w-full bg-transparent border-none focus:ring-0 text-slate-700 placeholder:text-slate-300">
                    </div>
                </div>

                <button type="submit" 
                        class="w-full bg-[#FF8A3D] hover:bg-[#e07530] text-white font-bold py-4 px-4 rounded-2xl transition-all shadow-lg shadow-[#FF8A3D]/20 text-lg active:scale-95">
                    회원가입 완료
                </button>
            </form>

            <div class="border-t border-slate-100 flex flex-col items-center text-xs font-medium text-slate-400"
                 style="margin-top: 2.2rem !important;">
                <div style="margin-top: 1.5rem !important;">
                    이미 회원이신가요? 
                    <a href="${pageContext.request.contextPath}/login" class="text-[#FF8A3D] font-bold hover:underline ml-2">로그인</a>
                </div>
            </div>

        </div>
    </div>

    <script>
        function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    var addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                    document.getElementById('zipcode').value = data.zonecode;
                    document.getElementById('address').value = addr;
                    document.getElementById('detailAddress').focus();
                }
            }).open();
        }

        function checkId() {
            const id = $('#userId').val();
            if(!id) return alert('아이디를 입력해주세요.');
            $.ajax({
                url: '${pageContext.request.contextPath}/member/checkId',
                type: 'GET',
                data: { id: id },
                success: function(res) {
                    if(res == '0') {
                        $('#idMsg').text('사용 가능한 아이디입니다.').css('color', '#10B981');
                    } else {
                        $('#idMsg').text('이미 사용 중인 아이디입니다.').css('color', '#EF4444');
                    }
                }
            });
        }

        $('#registForm').submit(function() {
            if($('#userPw').val() !== $('#userPwCheck').val()) {
                alert('비밀번호가 일치하지 않습니다.');
                return false;
            }
            return true;
        });
    </script>
</body>
</html>
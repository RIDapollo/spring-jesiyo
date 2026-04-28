<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 마이페이지</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
    <style>
        /* 매너 온도 바 스타일 */
        .temp-bar-bg { background-color: #E2E8F0; height: 10px; border-radius: 999px; overflow: hidden; }
        .temp-bar-fill { 
            background: linear-gradient(90deg, #FFD1A9 0%, #FF8A3D 100%); 
            height: 100%; 
            border-radius: 999px;
            transition: width 1s ease-in-out;
        }
        
        /* 버튼 인터랙션 효과 */
        .btn-action { transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-action:active { transform: scale(0.96); }
        
        /* 카드 메뉴 호버 효과 */
        .menu-card { transition: all 0.3s ease; }
        .menu-card:hover { transform: translateY(-5px); border-color: #FF8A3D; }
    </style>
</head>
<body class="bg-[#F8FAFC] text-slate-900 m-0 p-0">

    <%@ include file="/WEB-INF/views/inc/header.jsp" %>

    <div class="w-full min-h-[calc(100vh-80px)] flex justify-center items-start px-4 py-12">
        
        <div class="w-full max-w-[850px] space-y-8">
            
            <%-- [섹션 1] 상단 프로필 및 포인트 카드 --%>
            <div class="bg-white border border-slate-200 rounded-[3rem] shadow-xl shadow-slate-200/40 p-10">
                <div class="flex flex-col md:flex-row items-center gap-10">
                    
                    <%-- 프로필 이미지 영역 --%>
                    <div class="relative">
                        <div class="w-40 h-40 rounded-full bg-slate-50 border-4 border-white shadow-inner overflow-hidden flex items-center justify-center">
                            <c:choose>
                                <%-- DTO의 profileImg 필드 사용 --%>
                                <c:when test="${not empty member.profileImg}">
                                    <img src="${pageContext.request.contextPath}/profile/${member.profileImg}" class="w-full h-full object-cover">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/resources/img/default.png" class="w-full h-full object-cover">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="absolute -bottom-1 -right-1 w-12 h-12 bg-[#FF8A3D] rounded-full flex items-center justify-center text-white border-4 border-white shadow-lg">
                            <i class="fas fa-crown"></i>
                        </div>
                    </div>

                    <%-- 유저 정보 및 메인 액션 --%>
                    <div class="flex-1 w-full">
                        <div class="flex items-end justify-center md:justify-start gap-3 mb-2">
                            <h2 class="text-3xl font-black text-slate-800">${member.nickname}</h2>
                            <span class="text-slate-400 text-sm mb-1 font-bold">#${member.userId}</span>
                        </div>
                        <p class="text-slate-500 font-medium mb-6 text-center md:text-left">${member.address}</p>
                        
                        <div class="flex flex-col md:flex-row gap-4 mb-8">
                            <%-- [보유 포인트 출력] --%>
                            <div class="flex items-center justify-center gap-2 bg-orange-50 px-5 py-3 rounded-2xl border border-orange-100">
                                <i class="fas fa-coins text-[#FF8A3D]"></i>
                                <span class="text-sm font-bold text-slate-500">보유 포인트</span>
                                <span class="text-xl font-black text-[#FF8A3D]">
								    <c:choose>
								        <c:when test="${not empty member.point}">
								            <fmt:formatNumber value="${member.point}" pattern="#,###" />
								        </c:when>
								        <c:otherwise>0</c:otherwise>
								    </c:choose>
								</span>
                                <span class="text-xs font-bold text-[#FF8A3D]">P</span>
                            </div>
                            
                            <%-- 매너 온도 바 --%>
                            <div class="flex-1 max-w-[250px] mx-auto md:mx-0">
                                <div class="flex justify-between items-end mb-1 px-1">
                                    <span class="text-[10px] font-black text-slate-400 tracking-tighter">매너 온도</span>
                                    <span class="text-sm font-black text-[#FF8A3D]">36.5°C</span>
                                </div>
                                <div class="temp-bar-bg">
                                    <div class="temp-bar-fill" style="width: 36.5%;"></div>
                                </div>
                            </div>
                        </div>

                        <%-- 버튼 그룹 --%>
                        <div class="flex flex-col gap-3">
                            <%-- 프로필 수정 버튼 --%>
                            <a href="${pageContext.request.contextPath}/member/checkPw" 
                               class="btn-action w-full py-4 bg-slate-100 text-slate-600 font-bold rounded-2xl text-center hover:bg-slate-200">
                                프로필 수정
                            </a>
                            <%-- [추가] 포인트 충전 및 환전 버튼 --%>
                            <div class="flex gap-3">
                                <a href="${pageContext.request.contextPath}/payments/new" 
                                   class="btn-action flex-1 py-4 bg-[#FF8A3D] text-white font-bold rounded-2xl text-center shadow-lg shadow-orange-200 hover:bg-[#e07530]">
                                    <i class="fas fa-plus-circle mr-2"></i>포인트 충전
                                </a>
                                <a href="${pageContext.request.contextPath}/point/exchange" 
                                   class="btn-action flex-1 py-4 bg-white text-slate-500 border-2 border-slate-100 font-bold rounded-2xl text-center hover:bg-slate-50">
                                    <i class="fas fa-exchange-alt mr-2"></i>포인트 환전
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- [섹션 2] 활동 요약 그리드 --%>
			<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
			    
			    <%-- 1. 중고거래 내역 (구 판매 내역) --%>
			    <div onclick="location.href='${pageContext.request.contextPath}/member/usedHistory'" 
			         class="menu-card bg-white border border-slate-200 rounded-[2.5rem] shadow-lg shadow-slate-200/30 p-8 text-center cursor-pointer">
			        <div class="w-16 h-16 bg-orange-50 text-[#FF8A3D] rounded-2xl flex items-center justify-center text-2xl mx-auto mb-4">
			            <i class="fas fa-handshake"></i> <%-- 중고거래 느낌의 아이콘으로 변경 --%>
			        </div>
			        <h4 class="font-bold text-slate-700">중고거래 내역</h4>
			        <p class="text-2xl font-black text-slate-800 mt-2">${member.usedCount}</p>
			    </div>
			
			    <%-- 2. 경매 내역 (구 구매 내역) --%>
			    <div onclick="location.href='${pageContext.request.contextPath}/member/auctionHistory'" 
			         class="menu-card bg-white border border-slate-200 rounded-[2.5rem] shadow-lg shadow-slate-200/30 p-8 text-center cursor-pointer">
			        <div class="w-16 h-16 bg-blue-50 text-blue-400 rounded-2xl flex items-center justify-center text-2xl mx-auto mb-4">
			            <i class="fas fa-gavel"></i> <%-- 경매용 망치 아이콘으로 변경 --%>
			        </div>
			        <h4 class="font-bold text-slate-700">경매 내역</h4>
			        <p class="text-2xl font-black text-slate-800 mt-2">${member.auctionCount}</p>
			    </div>
			
			    <%-- 3. 관심 목록 (유지) --%>
			    <div onclick="location.href='${pageContext.request.contextPath}/member/wishlist'" 
			         class="menu-card bg-white border border-slate-200 rounded-[2.5rem] shadow-lg shadow-slate-200/30 p-8 text-center cursor-pointer">
			        <div class="w-16 h-16 bg-red-50 text-red-400 rounded-2xl flex items-center justify-center text-2xl mx-auto mb-4">
			            <i class="fas fa-heart"></i>
			        </div>
			        <h4 class="font-bold text-slate-700">관심 목록</h4>
			        <p class="text-2xl font-black text-slate-800 mt-2">${member.wishCount}</p>
			    </div>
			</div>

            <%-- [섹션 3] 하단 상세 메뉴 리스트 --%>
            <div class="bg-white border border-slate-200 rounded-[3rem] shadow-xl shadow-slate-200/40 p-6">
                <div class="space-y-2">
                    <a href="/jesiyo/locations/new" class="flex items-center justify-between p-6 rounded-3xl hover:bg-slate-50 transition-all group">
                        <div class="flex items-center gap-5">
                            <div class="w-12 h-12 bg-slate-100 rounded-2xl flex items-center justify-center text-slate-400 group-hover:bg-[#FF8A3D] group-hover:text-white transition-all">
                                <i class="fas fa-store"></i>
                            </div>
                            <span class="text-lg font-bold text-slate-700">내 동네 설정</span>
                        </div>
                        <i class="fas fa-chevron-right text-slate-300"></i>
                    </a>
                    <a href="#" class="flex items-center justify-between p-6 rounded-3xl hover:bg-slate-50 transition-all group">
                        <div class="flex items-center gap-5">
                            <div class="w-12 h-12 bg-slate-100 rounded-2xl flex items-center justify-center text-slate-400 group-hover:bg-[#FF8A3D] group-hover:text-white transition-all">
                                <i class="fas fa-bullhorn"></i>
                            </div>
                            <span class="text-lg font-bold text-slate-700">키워드 알림</span>
                        </div>
                        <i class="fas fa-chevron-right text-slate-300"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="flex items-center justify-between p-6 rounded-3xl hover:bg-red-50 transition-all group">
                        <div class="flex items-center gap-5">
                            <div class="w-12 h-12 bg-slate-100 rounded-2xl flex items-center justify-center text-slate-400 group-hover:bg-red-500 group-hover:text-white transition-all">
                                <i class="fas fa-sign-out-alt"></i>
                            </div>
                            <span class="text-lg font-bold text-slate-400 group-hover:text-red-500">로그아웃</span>
                        </div>
                    </a>
                </div>
            </div>

        </div>
    </div>

</body>
</html>
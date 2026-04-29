<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 관심 카테고리 관리</title>
    
    <%-- [스타일시트 섹션] 사용자 제공 라이브러리 및 커스텀 테마 --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@5" rel="stylesheet" type="text/css" />
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

    <style>
        body { font-family: "Pretendard", sans-serif; }
    </style>

    <style type="text/tailwindcss">
        @theme {
            /* 당근마켓 메인 오렌지 컬러 */
            --color-brand-50: #fff8f3;
            --color-brand-100: #ffeadd;
            --color-brand-200: #ffccaa;
            --color-brand-500: #ff8a3d; 
            --color-brand-600: #e67026;
            --color-brand-700: #cc5a1b;

            /* 에메랄드 그린 컬러 */
            --color-point-50: #ecfdf5;
            --color-point-100: #d1fae5;
            --color-point-200: #a7f3d0;
            --color-point-500: #10b981;
            --color-point-600: #059669;

            /* 로즈 컬러 (삭제/위험 버튼용) */
            --color-rose-50: #fff1f2;
            --color-rose-100: #ffe4e6;
            --color-rose-200: #fecdd3;
            --color-rose-500: #f43f5e;
            --color-rose-600: #e11d48;
        }

        @layer base {
            body { @apply bg-slate-50 text-slate-800; }
        }

        @layer components {
            .page-wrap { @apply max-w-2xl w-full mx-auto px-4 py-12; }
            .section-title { @apply text-3xl font-black mb-2 text-slate-900; }
            .section-desc { @apply text-base text-slate-500 mb-10; }
            .content-card { @apply bg-white border border-slate-200 rounded-3xl shadow-sm hover:shadow-md transition-all; }
            .card-pad { @apply p-6; }
            
            .btn-brand { @apply text-white bg-brand-500 hover:bg-brand-600 border-0 font-bold transition-colors rounded-2xl px-6 py-4 cursor-pointer flex items-center justify-center gap-2; }
            .btn-danger { @apply text-white bg-rose-500 hover:bg-rose-600 border-0 font-bold transition-colors rounded-xl p-2.5 cursor-pointer flex items-center justify-center; }
        }
    </style>
</head>
<body>

    <%-- 상단 헤더 (프로젝트 공통 헤더가 있다면 include 하세요) --%>
    <jsp:include page="/WEB-INF/views/inc/header.jsp" />

    <main class="page-wrap">
        
        <%-- [상단 타이틀 섹션] --%>
        <header class="text-left mb-10">
            <h2 class="section-title">관심 카테고리</h2>
            <p class="section-desc">관심 있는 분류를 등록하고 맞춤형 소식을 받아보세요.</p>
        </header>

        <%-- [관심 목록 리스트] --%>
        <div class="space-y-4">
            <c:choose>
                <c:when test="${not empty wishList}">
                    <c:forEach items="${wishList}" var="item">
                        <div class="content-card card-pad flex justify-between items-center group">
                            
                            <%-- 왼쪽: 카테고리 정보 (소분류 이름만 출력) --%>
                            <div class="flex items-center gap-4">
                                <div class="w-1.5 h-6 bg-brand-500 rounded-full group-hover:scale-y-125 transition-transform"></div>
                                <a href="/jesiyo/direct-sales?categorySeq=${item.cateSeq}">
                                	<span class="text-lg font-bold text-slate-700">${item.itemName}</span>
                                </a>
                            </div>

                            <%-- 오른쪽: 삭제 버튼 (쓰레기통 SVG 적용) --%>
                            <button type="button" onclick="deleteInterest('${item.wishSeq}')" class="btn-danger group/btn shadow-sm shadow-rose-100">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="group-hover/btn:scale-110 transition-transform">
                                    <path d="M3 6h18"></path>
                                    <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path>
                                    <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path>
                                    <line x1="10" y1="11" x2="10" y2="17"></line>
                                    <line x1="14" y1="11" x2="14" y2="17"></line>
                                </svg>
                            </button>
                            
                        </div>
                    </c:forEach>
                </c:when>
                
                <%-- 데이터가 없을 때의 화면 --%>
                <c:otherwise>
                    <div class="content-card card-pad py-24 text-center border-dashed border-2 border-slate-200 bg-slate-50/50">
                        <div class="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#cbd5e1" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
                        </div>
                        <p class="text-slate-400 font-bold text-lg">등록된 관심 카테고리가 없습니다.</p>
                        <p class="text-slate-300 text-sm mt-1">새로운 관심 분야를 추가해 보세요!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- [하단 추가 버튼 섹션] --%>
        <div class="mt-12">
            <button onclick="location.href='${pageContext.request.contextPath}/member/addWish'" class="btn-brand w-full shadow-lg shadow-brand-100">
                <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                관심 카테고리 추가하기
            </button>
            
            <p class="text-center mt-6">
                <a href="${pageContext.request.contextPath}/member/mypage" class="text-sm font-bold text-slate-400 hover:text-slate-600 transition-colors underline underline-offset-4">
                    마이페이지로 돌아가기
                </a>
            </p>
        </div>

    </main>

    <script>
        /**
         * 관심 카테고리 삭제 처리
         * @param seq member_interest 테이블의 고유 번호
         */
        function deleteInterest(seq) {
            if (confirm('선택하신 카테고리를 관심 목록에서 삭제하시겠습니까?')) {
                // 삭제를 처리할 컨트롤러 경로로 이동
                location.href = '${pageContext.request.contextPath}/member/deleteWish?seq=' + seq;
            }
        }
    </script>

</body>
</html>
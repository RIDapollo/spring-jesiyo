<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 관심 카테고리 추가</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
    <style>
        .category-chip { transition: all 0.2s ease; cursor: pointer; }
        .category-chip:hover { border-color: #FF8A3D; color: #FF8A3D; background-color: #FFF7ED; }
        .category-chip.selected { background-color: #FF8A3D; color: white; border-color: #FF8A3D; }
        .category-chip.disabled { opacity: 0.4; cursor: not-allowed; background-color: #F1F5F9; }
    </style>
</head>
<body class="bg-[#F8FAFC] text-slate-900">

    <%@ include file="/WEB-INF/views/inc/header.jsp" %>

    <div class="w-full min-h-[calc(100vh-80px)] flex justify-center items-start px-4 py-12">
        <div class="w-full max-w-[600px] bg-white border border-slate-200 rounded-[3rem] shadow-xl p-10">
            
            <div class="text-center mb-10">
                <h2 class="text-3xl font-black text-slate-800">관심 카테고리 추가</h2>
                <p class="text-slate-400 font-medium mt-2">알림을 받고 싶은 분야를 선택해 주세요.</p>
            </div>

            <form action="${pageContext.request.contextPath}/member/addWish" method="POST" id="wishForm">
                <input type="hidden" name="cateSeq" id="selectedCateSeq">
                
                <div class="flex flex-wrap gap-3 justify-center mb-10">
                    <c:forEach items="${allCategories}" var="cat">
                        <c:set var="isAdded" value="false" />
                        <c:forEach items="${currentInterests}" var="my">
                            <c:if test="${my.itemName eq cat.name}">
                                <c:set var="isAdded" value="true" />
                            </c:if>
                        </c:forEach>

                        <div class="category-chip px-6 py-3 rounded-full border-2 border-slate-100 font-bold text-slate-500 ${isAdded ? 'disabled' : ''}"
                             onclick="${isAdded ? '' : 'selectCategory(this, ' + cat.seq + ')'}">
                            ${cat.name}
                            <c:if test="${isAdded}"><i class="fas fa-check ml-1 text-xs"></i></c:if>
                        </div>
                    </c:forEach>
                </div>

                <div class="flex gap-4">
                    <button type="button" onclick="history.back();" 
                            class="flex-1 py-4 bg-slate-100 text-slate-500 font-bold rounded-2xl hover:bg-slate-200 transition-all">
                        취소
                    </button>
                    <button type="submit" id="submitBtn" disabled
                            class="flex-1 py-4 bg-[#FF8A3D] text-white font-bold rounded-2xl shadow-lg shadow-orange-200 opacity-50 cursor-not-allowed transition-all">
                        등록하기
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function selectCategory(el, seq) {
            // 모든 칩에서 selected 클래스 제거
            document.querySelectorAll('.category-chip').forEach(chip => chip.classList.remove('selected'));
            
            // 클릭한 칩에 selected 추가
            el.classList.add('selected');
            
            // hidden input에 값 설정
            document.getElementById('selectedCateSeq').value = seq;
            
            // 버튼 활성화
            const btn = document.getElementById('submitBtn');
            btn.disabled = false;
            btn.classList.remove('opacity-50', 'cursor-not-allowed');
        }
    </script>
</body>
</html>
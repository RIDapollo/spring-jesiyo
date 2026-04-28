<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 관심 목록 관리</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
    <style>
        .wish-item { transition: all 0.3s ease; }
        .wish-item:hover { transform: scale(1.01); border-color: #FF8A3D; }
    </style>
</head>
<body class="bg-[#F8FAFC] text-slate-900">

    <%@ include file="/WEB-INF/views/inc/header.jsp" %>

    <div class="w-full min-h-[calc(100vh-80px)] flex justify-center items-start px-4 py-12">
        <div class="w-full max-w-[800px] space-y-6">
            
            <%-- 헤더 영역 --%>
            <div class="flex justify-between items-end mb-8 px-4">
                <div>
                    <h2 class="text-3xl font-black text-slate-800">관심 목록</h2>
                    <p class="text-slate-400 font-medium mt-1">찜한 상품들을 한눈에 확인하세요.</p>
                </div>
                <span class="bg-orange-50 text-[#FF8A3D] px-4 py-2 rounded-full font-bold text-sm border border-orange-100">
                    전체 ${wishList.size()}개
                </span>
            </div>

            <%-- 관심 목록 리스트 --%>
            <div class="space-y-4">
                <c:choose>
                    <c:when test="${not empty wishList}">
                        <c:forEach items="${wishList}" var="item">
                            <div class="wish-item bg-white border border-slate-200 rounded-[2rem] p-6 shadow-sm flex items-center gap-6">
                                <%-- 상품 썸네일 --%>
                                <div class="w-24 h-24 bg-slate-100 rounded-2xl overflow-hidden flex-shrink-0">
                                    <img src="${pageContext.request.contextPath}/resources/img/item/${item.itemImg}" 
                                         onerror="this.src='${pageContext.request.contextPath}/resources/img/default-item.png'"
                                         class="w-full h-full object-cover">
                                </div>
                                
                                <%-- 상품 정보 --%>
                                <div class="flex-1">
                                    <span class="text-[10px] font-bold px-2 py-1 bg-slate-100 text-slate-500 rounded-md uppercase mb-2 inline-block">
                                        ${item.itemType == 'direct' ? '중고거래' : '경매'}
                                    </span>
                                    <h3 class="text-lg font-bold text-slate-800 line-clamp-1">${item.itemName}</h3>
                                    <p class="text-[#FF8A3D] font-black text-xl mt-1">
                                        <fmt:formatNumber value="${item.price}" pattern="#,###" />원
                                    </p>
                                </div>

                                <%-- 삭제 버튼 --%>
                                <button onclick="deleteWish('${item.wishSeq}')" 
                                        class="p-4 text-slate-300 hover:text-red-500 hover:bg-red-50 rounded-2xl transition-all">
                                    <i class="fas fa-trash-alt text-xl"></i>
                                </button>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <%-- 목록이 비었을 때 --%>
                        <div class="bg-white border border-slate-200 rounded-[3rem] p-20 text-center shadow-sm">
                            <div class="text-6xl mb-6">🏜️</div>
                            <p class="text-slate-400 font-bold text-lg">아직 관심 목록에 담은 상품이 없어요.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- 하단 추가 버튼 --%>
            <div class="pt-10">
                <a href="${pageContext.request.contextPath}/member/addWish" 
                   class="block w-full py-6 bg-white border-2 border-dashed border-slate-200 text-slate-400 font-bold rounded-[2.5rem] text-center hover:border-[#FF8A3D] hover:text-[#FF8A3D] transition-all group">
                    <i class="fas fa-plus-circle mr-2 group-hover:scale-110 transition-transform"></i>
                    새로운 관심 목록 등록하기
                </a>
            </div>
            
        </div>
    </div>

    <script>
        function deleteWish(seq) {
            if(confirm('정말 관심 목록에서 삭제하시겠습니까?')) {
                // CSRF 토큰 처리가 필요할 수 있습니다.
                location.href = '${pageContext.request.contextPath}/member/deleteWish?seq=' + seq;
            }
        }
    </script>
</body>
</html>
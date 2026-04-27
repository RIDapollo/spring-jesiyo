<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>JeSiYo</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
  </head>
  <%@ include file="/WEB-INF/views/inc/header.jsp" %>
  <body class="bg-slate-50">
    <div class="page-wrap">

    <div class="section-title">거래 목록</div>
    <div class="section-desc">내 거래 내역을 확인할 수 있습니다.</div>

    <div class="content-card overflow-hidden">

       <!-- 헤더 -->
        <div class="grid grid-cols-7 bg-slate-100 text-slate-600 text-sm font-semibold border-b border-slate-200">

            <div class="p-3">상품명</div>
            <div class="p-3">제목</div>
            <div class="p-3">판매자</div>
            <div class="p-3">구매자</div>
            <div class="p-3 text-center">상태</div>
            <div class="p-3 text-center">날짜</div>
            <div class="p-3 text-center">비고</div>
        </div>
        
        <!-- 리스트 -->
        <c:forEach var="trade" items="${tradeList}">

            <div class="grid grid-cols-7 text-sm border-b border-slate-100 hover:bg-slate-50">

                <!-- 상품명 -->
                <div class="p-3 text-slate-800 font-medium">
                    ${trade.productName}
                </div>
                
                <!-- 제목 -->
                <div class="p-3 text-slate-800">
                    ${trade.name}
                </div>

                <!-- 판매자 -->
                <div class="p-3 text-slate-600">
                    ${trade.sellerNickname}
                </div>

                <!-- 구매자 -->
                <div class="p-3 text-slate-600">
                    ${trade.buyerNickname}
                </div>

                <!-- 상태 -->
                <div class="p-3 flex justify-center">
                    
                    <c:choose>
                        <c:when test="${trade.status == '판매중'}">
                            <span class="status-badge badge-selling">판매중</span>
                        </c:when>

                        <c:when test="${trade.status == '예약중'}">
                            <span class="status-badge badge-reserved">예약중</span>
                        </c:when>

                        <c:when test="${trade.status == '거래완료'}">
                            <span class="status-badge badge-sold">완료</span>
                        </c:when>

                        <c:otherwise>
                            <span class="status-badge badge-auction">${trade.status}</span>
                        </c:otherwise>
                    </c:choose>

                </div>

                <!-- 날짜 -->
                <div class="p-3 text-center text-slate-400 text-xs">
                    ${trade.timeAgo}
                </div>
                
                <!-- 비고 -->
                <div class="p-3 flex justify-center">
                    <c:if test="${sessionScope.user.seq == trade.sellerSeq}">
                        <button 
                            class="btn-sub text-xs px-3 py-1"
                            onclick="acceptTrade(${trade.seq})">
                            요청수락
                        </button>
                    </c:if>
                </div>

            </div>

        </c:forEach>
        
        <input type="hidden" id="lastSeq" value="${lastSeq}"/>
        <c:if test="${hasMore}">
        <div class="flex justify-center py-4" id="moreWrap">
            <button 
                id="moreBtn"
                class="btn-brand"
                onclick="loadMoreTrade()">
                더보기
            </button>
        </div>
</c:if>
        
    </div>
</div>
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
  	<script>
    	function acceptTrade(tradeSeq) {
  
    	    $.ajax({
    	        url: "/api/trades/accept",
    	        type: "POST",
    	        contentType: "application/json",
    	        data: JSON.stringify({
    	            seq: tradeSeq
    	        }),
    	        success: function(res) {
    	            alert("거래 요청이 수락되었습니다.");
    	            location.reload();
    	        },
    	        error: function() {
    	            alert("처리 실패");
    	        }
    	    });
    	}
    	
    	function loadMoreTrade() {

    	    let lastSeq = $("#lastSeq").val();

    	    $.ajax({
    	        url: "/jesiyo/api/trades/more",
    	        type: "GET",
    	        data: {
    	            lastSeq: lastSeq
    	        },
    	        success: function(list) {
    	            if (list.length === 0) {
    	                $("#moreBtn").hide();
    	                return;
    	            }

    	            let html = "";

    	            list.forEach(function(trade) {
    	                html += `
    	                    <div class="grid grid-cols-7 text-sm border-b border-slate-100 hover:bg-slate-50">

    	                        <div class="p-3 text-slate-800 font-medium">
    	                            ${trade.productName}
    	                        </div>

    	                        <div class="p-3 text-slate-800">
    	                            ${trade.name}
    	                        </div>

    	                        <div class="p-3 text-slate-600">
    	                            ${trade.sellerNickname}
    	                        </div>

    	                        <div class="p-3 text-slate-600">
    	                            ${trade.buyerNickname}
    	                        </div>

    	                        <div class="p-3 flex justify-center">
    	                            ${trade.status}
    	                        </div>

    	                        <div class="p-3 text-center text-slate-400 text-xs">
    	                        	${trade.timeAgo}
    	                        </div>

    	                        <div class="p-3"></div>

    	                    </div>
    	                `;
    	            });
    	            // 리스트 append
    	            $(".content-card").append(html);
    	            // 마지막 seq 업데이트
    	            $("#lastSeq").val(list[list.length - 1].seq);
    	        },
    	        error: function() {
    	            alert("더보기 실패");
    	        }
    	    });
    	}
  	
  	
  	</script>   
  </body>
</html>
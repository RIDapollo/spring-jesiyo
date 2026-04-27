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
  <style>
.star {
    position: relative;
    display: inline-block;
    font-size: 32px;
    color: #d1d5db; /* 회색 */
}

.star::before {
    content: "★";
}

.star-fill {
    position: absolute;
    top: 0;
    left: 0;
    width: 0%;
    overflow: hidden;
    color: #22c55e; /* 초록 */
}

.star-fill::before {
    content: "★";
}
</style>
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
                <div class="p-3 text-slate-800 font-medium truncate whitespace-nowrap overflow-hidden">
                    ${trade.productName}
                </div>
                
                <!-- 제목 -->
                <div class="p-3 text-slate-800 truncate whitespace-nowrap overflow-hidden">
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

                        <c:when test="${trade.status == '완료'}">
                            <span class="status-badge badge-sold">거래완료</span>
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
                    <!-- 판매자: 요청 수락 -->
                    <c:if test="${sessionScope.user.seq == trade.sellerSeq and trade.status != '완료'}">
                        <button 
                            class="btn-sub text-xs px-3 py-1"
                            onclick="acceptTrade(${trade.seq})">
                            요청수락
                        </button>
                    </c:if>
                    <!-- 구매자: 후기 작성 -->
                    <c:if test="${sessionScope.user.seq == trade.buyerSeq 
                        and trade.status == '완료'
                        and not trade.hasWritten}">
                        <button 
                            class="btn-sub text-xs px-3 py-1"
                            onclick="openReviewModal(${trade.seq}, ${trade.sellerSeq}, ${trade.buyerSeq})">
                            후기작성
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
<!-- 후기 작성 모달 -->
<div id="reviewModal" class="fixed inset-0 bg-black/40 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-xl shadow-lg p-6 w-80">
        <div class="text-lg font-bold mb-4 text-center">
            후기 작성
        </div>
        <!-- 별점 영역 -->
        <div id="starWrap" class="flex justify-center gap-1 mb-4">
          <span class="star" data-index="0">
              <span class="star-fill"></span>
          </span>
          <span class="star" data-index="1">
              <span class="star-fill"></span>
          </span>
          <span class="star" data-index="2">
              <span class="star-fill"></span>
          </span>
          <span class="star" data-index="3">
              <span class="star-fill"></span>
          </span>
          <span class="star" data-index="4">
              <span class="star-fill"></span>
          </span>
        </div>
        <div id="scoreText" class="text-center text-sm text-slate-500 mb-4">
            0점
        </div>
        <div class="flex justify-between">
            <button class="px-3 py-1 bg-slate-200 rounded cursor-pointer" onclick="closeReviewModal()">취소</button>
            <button class="px-3 py-1 bg-green-500 text-white rounded cursor-pointer" onclick="submitReview()">등록</button>
        </div>
    </div>
</div>
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
  	<script>
    	function acceptTrade(tradeSeq) {
  
    	    $.ajax({
    	        url: "/jesiyo/api/trades/accept",
    	        type: "POST",
    	        contentType: "application/json",
    	        data: JSON.stringify(tradeSeq),
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
  	
    	let reviewData = {
    		    tradeSeq: null,
    		    sellerSeq: null,
    		    buyerSeq: null,
    		    score: 0
    		};

    		// 모달 열기
    		function openReviewModal(tradeSeq, sellerSeq, buyerSeq) {
    		    reviewData.tradeSeq = tradeSeq;
    		    reviewData.sellerSeq = sellerSeq;
    		    reviewData.buyerSeq = buyerSeq;

    		    $("#reviewModal").removeClass("hidden");
    		}

    		// 모달 닫기
    		function closeReviewModal() {
    		    $("#reviewModal").addClass("hidden");
    		    reviewData.score = 0;
    		}

    		// 후기 등록 AJAX
    		function submitReview() {

    		    if (reviewData.score === 0) {
    		        alert("점수를 선택하세요.");
    		        return;
    		    }

    		    $.ajax({
    		        url: "/jesiyo/api/trade-reviews/add",
    		        type: "POST",
    		        contentType: "application/json",
    		        data: JSON.stringify({
    		            tradeSeq: reviewData.tradeSeq,
    		            sellerSeq: reviewData.sellerSeq,
    		            buyerSeq: reviewData.buyerSeq,
    		            score: reviewData.score
    		        }),
    		        success: function() {
    		            alert("후기 등록 완료");
    		            location.reload();
    		        },
    		        error: function() {
    		            alert("후기 등록 실패");
    		        }
    		    });
    		}
    		let currentHoverScore = 0;

    		// 별 hover (마우스 움직임)
    		$(".star").on("mousemove", function(e) {
    		    const index = $(this).data("index");
    		    const width = $(this).width();
    		    const offsetX = e.offsetX;
    		    let score = index + (offsetX < width / 2 ? 0.5 : 1);
    		    currentHoverScore = score;
    		    renderStars(score);
    		});

    		// 마우스 빠지면 선택값 유지
    		$(".star").on("mouseleave", function() {
    		    renderStars(reviewData.score);
    		});
    		// 클릭하면 점수 확정
    		$(".star").on("click", function() {
    		    reviewData.score = currentHoverScore;
    		    $("#scoreText").text(reviewData.score + "점");
    		});
    		
    		function renderStars(score) {
    		    $(".star").each(function(i) {
    		        let fill = 0;
    		        if (score >= i + 1) {
    		            fill = 100;
    		        } else if (score > i) {
    		            fill = (score - i) * 100; // 0~100%
    		        }
    		        $(this).find(".star-fill").css("width", fill + "%");
    		    });
    		}
  	</script>
        
  </body>
</html>
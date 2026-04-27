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
    <div class="page-wrap max-w-3xl">
      <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
      <c:forEach var="item" items="${list}">
        <article class="item-card"
            onclick="location.href='/jesiyo/direct-sales/${item.seq}'">
            <div class="item-img-wrap relative">
              <!-- 상태 배지 (좌측 상단 고정) -->
              <c:if test="${item.status == '완료'}">
                  <span class="absolute top-2 left-2 z-10 status-badge badge-sold">
                      판매완료
                  </span>
              </c:if>
              <!-- 이미지 -->
              <img src="/jesiyo${item.imageUrl}" alt="상품" class="item-img">
            </div>
            <!-- 정보 -->
            <div class="item-info">
              <!-- 제목 -->
              <h3 class="item-title">
                  ${item.name}
              </h3>
              <!-- 가격 -->
              <div class="item-price">
                  ${item.price}원
              </div>
              <!-- 동네 + 추가정보 -->
              <div class="item-meta">
                  ${not empty item.dong ? item.dong.concat(' · ') : ''}
<%--                   <fmt:formatDate value="${item.createdAt}" pattern="M월 d일" /> --%>
                  ${item.timeAgo}
              </div>
            </div>
          </article>
        </c:forEach>
      </div>
    
    </div>
    <!-- 중고거래 등록 버튼 (우하단 고정) -->
    <div class="fixed bottom-6 right-10 z-50">
        <a href="/jesiyo/direct-sales/new"
           class="btn-brand shadow-lg px-5 py-3 rounded-full flex items-center gap-2">
            <span class="text-lg">+</span>
            <span class="text-sm font-bold">등록하기</span>
        </a>
    </div>
    
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
  	<script>
  	let page = 1;
  	let isLoading = false;
  	let isLast = false;
  	
  	function loadMore() {
  	    if (isLoading || isLast) return;
  	    isLoading = true;

  	  	fetch('/jesiyo/api/direct-sales?page=' + page)
  	        .then(res => res.json())
  	        .then(data => {

  	            if (data.length === 0) {
  	                isLast = true;
  	                return;
  	            }

  	            const grid = document.querySelector(".grid");
  	            data.forEach(item => {
  	                grid.insertAdjacentHTML(
  	                    "beforeend",
  	                    createItemHtml(item)
  	                );
  	            });

  	            page++;
  	            isLoading = false;
  	        }
        );
  	}
  	
  	// 스크롤 이벤트
  	window.addEventListener("scroll", () => {

  	    const scrollTop = window.scrollY;
  	    const windowHeight = window.innerHeight;
  	    const documentHeight = document.body.offsetHeight;

  	    if (scrollTop + windowHeight >= documentHeight - 100) {
  	        loadMore();
  	    }
  	});
  	
  	// HTML 동적 추가하는 함수
  	function createItemHtml(item) {
  	    return `
  	    <article class="item-card"
  	        onclick="location.href='/jesiyo/direct-sales/\${item.seq}'">

  	        <div class="item-img-wrap relative">

  	            \${item.status === '완료' ? `
  	                <span class="absolute top-2 left-2 z-10 status-badge badge-sold">
  	                    판매완료
  	                </span>
  	            ` : ''}

  	            <img src="/jesiyo\${item.imageUrl}" class="item-img">
  	        </div>

  	        <div class="item-info">

  	            <h3 class="item-title">
  	                \${item.name}
  	            </h3>

  	            <div class="item-price">
  	                \${item.price}원
  	            </div>

  	            <div class="item-meta">
  	                \${item.dong ? item.dong + ' · ' : ''}
  	                \${item.timeAgo}
  	            </div>

  	        </div>
  	    </article>
  	    `;
  	}
  	</script>   
  </body>
</html>
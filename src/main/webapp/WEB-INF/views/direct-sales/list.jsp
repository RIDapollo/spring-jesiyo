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
    <style type="text/tailwindcss">
    .active-filter {
      @apply bg-brand-500 text-white;
    }
    </style>
    <style>
        .filter-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            background: #ff8a3d;
            color: white;
            cursor: pointer;
        }
        
        .filter-chip:hover {
            background: #e67026;
        }
    </style>
  </head>
  <%@ include file="/WEB-INF/views/inc/header.jsp" %>
  <body class="bg-slate-50">
  <div class="flex max-w-6xl mx-auto">

  <!-- 왼쪽 카테고리 -->
  <aside class="w-64 pr-6 sticky top-24 h-fit">
  <c:if test="${not empty sessionScope.user and hasLocationFilter}">
    <div class="flex justify-between items-center mb-4">
    <!-- 왼쪽: 필터 버튼 -->
    <div class="flex gap-2 w-full">
      <button class="filter-btn flex-1 px-3 py-1 rounded text-sm
                     bg-slate-200 text-slate-700 hover:bg-slate-300 transition
                     active-filter"
              data-type="ALL">
        전체
      </button>
      <button class="filter-btn flex-1 px-3 py-1 rounded text-sm
                     bg-slate-200 text-slate-700 hover:bg-slate-300 transition"
              data-type="DONG">
        내 동네
      </button>
      <button class="filter-btn flex-1 px-3 py-1 rounded text-xs
                     bg-slate-200 text-slate-700 hover:bg-slate-300 transition"
              data-type="DISTANCE">
        3km 이내
      </button>
    </div>
  </div>
  </c:if>
  <div class="flex items-center justify-between mt-2 text-xs text-slate-500">
  <div id="filter-status" class="text-xs text-slate-500">
      전체
  </div>
    <!-- 초기화 버튼 -->
    <button id="filter-reset"
            class="text-brand-600 hover:underline">
        초기화
    </button>
  </div>
  <ul class="menu bg-slate-100 w-full text-sm">
  <!-- 대분류 -->
  <c:forEach var="c1" items="${categoryTree}">
    <li>
      <details>
        <summary class="">${c1.name}</summary>
        <ul>
          <%-- 중분류 --%>
          <c:forEach var="c2" items="${c1.children}">
            <li>
              <details>
                <summary>${c2.name}</summary>
                <ul>
                  <%-- 소분류 --%>
                  <c:forEach var="c3" items="${c2.children}">
                    <li>
                      <a href="#"
                       class="category-link"
                       data-seq="${c3.seq}">
                       ${c3.name}
                      </a>
                    </li>
                  </c:forEach>
                </ul>
              </details>
            </li>
          </c:forEach>
        </ul>
      </details>
    </li>
  </c:forEach>
  </ul>
  </aside>
  <!-- 오른쪽 상품 리스트 -->
  <div class="flex-1 pl-6">
  
    <div class="mt-3 flex flex-wrap gap-2" id="filter-chips"></div>
  
    <div class="page-wrap max-w-3xl !pt-2">
      <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
      
      </div>
    
    </div>
    
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
  	let page = 0;
  	let isLoading = false;
  	let isLast = false;
  	
  	const filterState = {
	    categorySeq: null,
	    filterType: "ALL"
	};
  	
  	loadMore();
  	
  	function loadMore() {
  	    if (isLoading || isLast) return;
  	    isLoading = true;

  	    fetch('/jesiyo/api/direct-sales', {
  	        method: 'POST',
  	        headers: {
  	            'Content-Type': 'application/json'
  	        },
  	        body: JSON.stringify({
  	            categorySeq: filterState.categorySeq,
  	          	filterType: filterState.filterType,
  	            page: page
  	        })
  	    })
  	    .then(res => res.json())
  	    .then(data => {
  	        if (data.length === 0) {
  	            isLast = true;
  	            isLoading = false;
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
  	    });
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
  	
  	document.addEventListener("DOMContentLoaded", () => {
  	    document.querySelectorAll('.category-link').forEach(a => {
  	        a.addEventListener('click', function (e) {
  	            e.preventDefault();
  	            const seq = this.dataset.seq;
  	            filterCategory(seq, this);
  	        });
  	    });

  	});
  	
  	function filterCategory(seq, el) {

  	    // 1. 상태 저장
  	    filterState.categorySeq = seq;
  	    // 2. UI 처리
  	    document.querySelectorAll('.category-link').forEach(a => {
  	        a.classList.remove('text-brand-600', 'font-bold');
  	    });
  	    el.classList.add('text-brand-600', 'font-bold');
  	    // 3. 리스트 초기화
  	    page = 0;
  	    isLast = false;
  	    document.querySelector(".grid").innerHTML = "";
  	    
  	  	renderChips();
  	  	updateFilterStatus();
  	    // 4. 다시 조회
  	    loadMore();
  	}
  	
  	document.addEventListener("DOMContentLoaded", () => {

  	    document.querySelectorAll('.filter-btn').forEach(btn => {
  	        btn.addEventListener('click', function () {

  	            const type = this.dataset.type;

  	            filterState.filterType = type;

  	            // UI active 처리
  	            document.querySelectorAll('.filter-btn').forEach(b => {
                    b.classList.remove('active-filter');
                });
                this.classList.add('active-filter');

  	            // 리스트 초기화
  	            page = 0;
  	            isLast = false;
  	            document.querySelector(".grid").innerHTML = "";

  	          	renderChips();
  	          	
  	            loadMore();
  	        });
  	    });
  	});
  	
  	function updateFilterStatus() {
  	    let text = "";
  	    // 필터 타입
  	    switch (filterState.filterType) {
  	        case "DONG":
  	            text = "내 동네";
  	            break;
  	        case "DISTANCE":
  	            text = "3km 이내";
  	            break;
  	        default:
  	            text = "전체";
  	    }
  	    // 카테고리
  	    if (filterState.categorySeq) {
  	        text += " · 카테고리 선택됨";
  	    }
  	    document.getElementById("filter-status").innerText = text;
  	}
  	
  	document.getElementById("filter-reset").addEventListener("click", () => {

  	    // 상태 초기화
  	    filterState.filterType = "ALL";
  	    filterState.categorySeq = null;

  	    // UI 초기화
  	    document.querySelectorAll('.filter-btn').forEach(b => {
  	        b.classList.remove('active-filter');
  	    });

  	    document.querySelectorAll('.category-link').forEach(a => {
  	        a.classList.remove('text-brand-600', 'font-bold');
  	    });

  	    // ALL 버튼 다시 활성화
  	    document.querySelector('[data-type="ALL"]')
  	        .classList.add('active-filter');

  	    // 리스트 초기화
  	    page = 0;
  	    isLast = false;
  	    document.querySelector(".grid").innerHTML = "";

  	  	renderChips();
  	    loadMore();
  	});
  	
  	function renderChips() {

  	    const wrap = document.getElementById("filter-chips");
  	    wrap.innerHTML = "";

  	    // 필터 타입 칩
  	    if (filterState.filterType && filterState.filterType !== "ALL") {
  	    	
  	        let label = "";
  	        if (filterState.filterType == 'DONG') label = "내 동네";
  	        if (filterState.filterType == 'DISTANCE') label = "3km 이내";

  	        wrap.innerHTML += `
  	            <div class="filter-chip" data-type="filter">
  	                \${label} ✕
  	            </div>
  	        `;
  	    }

  	    // 카테고리 칩
  	    if (filterState.categorySeq) {
  	        wrap.innerHTML += `
  	            <div class="filter-chip" data-type="category">
  	                카테고리 ✕
  	            </div>
  	        `;
  	    }
  		wrap.style.display = wrap.innerHTML.trim() === "" ? "none" : "flex";
  	}
  	
  	document.addEventListener("click", function (e) {

  	    const chip = e.target.closest(".filter-chip");
  	    if (!chip) return;

  	    const type = chip.dataset.type;

  	    if (type === "filter") {
  	        filterState.filterType = "ALL";

  	        document.querySelectorAll('.filter-btn').forEach(b => {
  	            b.classList.remove('active-filter');
  	        });

  	        document.querySelector('[data-type="ALL"]')
  	            .classList.add('active-filter');
  	    }

  	    if (type === "category") {
  	        filterState.categorySeq = null;

  	        document.querySelectorAll('.category-link').forEach(a => {
  	            a.classList.remove('text-brand-600', 'font-bold');
  	        });
  	    }

  	    page = 0;
  	    isLast = false;
  	    document.querySelector(".grid").innerHTML = "";

  	    renderChips();
  	  	updateFilterStatus();
  	    loadMore();
  	});
  	</script>   
  </body>
</html>
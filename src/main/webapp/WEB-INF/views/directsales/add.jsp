<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>JeSiYo</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
    <style>
    
    </style>
  </head>
  <body class="bg-slate-50">
  <%@ include file="/WEB-INF/views/inc/header.jsp" %>
    <div class="page-wrap max-w-3xl">
      <h1 class="section-title">내 물건 팔기</h1>
      <p class="section-desc">동네 이웃과 나눌 물건의 정보를 입력해주세요.</p>
    
        <form action="/direct-sale/add" method="POST" class="content-card card-pad flex flex-col gap-6">
            <!-- 상품명 -->
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">상품명</label>
                <input type="text" name="productName"
                   class="input input-bordered w-full focus:border-brand-500 focus:outline-none"
                   placeholder="상품명을 입력하세요" required />
            </div>
            <!-- 제목 -->
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">제목</label>
                <input type="text" name="name"
                   class="input input-bordered w-full focus:border-brand-500 focus:outline-none"
                   placeholder="글 제목을 입력하세요" required />
            </div>
    
            <!-- 가격 -->
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">가격 (원)</label>
                <input type="number" name="price"
                   class="input input-bordered w-full focus:border-brand-500 focus:outline-none"
                   placeholder="가격을 입력하세요" />
            </div>
    
            <!-- 카테고리 (핵심) -->
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">카테고리</label>
    
                <div class="grid grid-cols-3 gap-3">
                    <select id="category1"
                      class="select select-bordered w-full focus:border-brand-500 focus:outline-none">
                      <option value="">대분류</option>
                      <c:forEach var="c" items="${roots}">
                      <option value="${c.seq}">${c.name}</option>
                      </c:forEach>
                    </select>
    
                    <select id="category2"
                      class="select select-bordered w-full focus:border-brand-500 focus:outline-none">
                      <option value="">중분류</option>
                    </select>
    
                    <select id="category3"
                      class="select select-bordered w-full focus:border-brand-500 focus:outline-none">
                      <option value="">소분류</option>
                    </select>
                </div>
    
                <!-- 최종 값 -->
                <input type="hidden" name="categorySeq" id="finalCategory">
            </div>
    
            <!-- 이미지 URL -->
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">상품 사진</label>
                <input type="file" name="imageFile"
                   accept="image/*"
                   class="file-input file-input-bordered w-full focus:border-brand-500" />
            </div>
    
            <!-- 거래 위치 -->
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">거래 위치</label>
                <input type="text" name="tradeLocationSeq"
                   class="input input-bordered w-full focus:border-brand-500 focus:outline-none"
                   placeholder="위치 선택 후 자동 입력" />
            </div>
    
            <!-- 설명 -->
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">상세 설명</label>
                <textarea name="description" rows="6"
                  class="textarea textarea-bordered w-full focus:border-brand-500 focus:outline-none"
                  placeholder="상품 설명을 입력하세요"></textarea>
            </div>
    
            <!-- 버튼 -->
            <div class="flex justify-end gap-2 mt-4">
                <button type="button"
                  class="btn bg-slate-200 text-slate-700 hover:bg-slate-300 border-0 rounded-lg px-6"
                  onclick="history.back();">취소</button>
    
                <button type="submit" class="btn-brand px-8">
                  등록하기
                </button>
            </div>
    
        </form>
    </div>
   
  	
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
  	<script>
        const category1 = document.getElementById("category1");
        const category2 = document.getElementById("category2");
        const category3 = document.getElementById("category3");
        const finalCategory = document.getElementById("finalCategory");
        
        // 공통: select 옵션 채우기
        function fillSelect(select, list) {
            select.innerHTML = '<option value="">선택</option>';
            list.forEach(item => {
                const option = document.createElement("option");
                option.value = item.seq;
                option.textContent = item.name;
                select.appendChild(option);
            });
        }
        
        // 대분류 → 중분류
        category1.addEventListener("change", function() {
            const seq = this.value;
        	
            // 초기화
            category2.innerHTML = '<option value="">중분류 선택</option>';
            category3.innerHTML = '<option value="">소분류 선택</option>';
            finalCategory.value = "";
        
            if (!seq) return;
            fetch('/jesiyo/api/categories/' + seq + '/children')
                .then(res => res.json())
                .then(data => fillSelect(category2, data));
        	});
        
        // 중분류 → 소분류
        category2.addEventListener("change", function() {
            const seq = this.value;
        
            category3.innerHTML = '<option value="">소분류 선택</option>';
            finalCategory.value = "";
        
            if (!seq) return;
        
            fetch('/jesiyo/api/categories/' + seq + '/children')
                .then(res => res.json())
                .then(data => fillSelect(category3, data));
        	});
        
        // 최종 선택
        category3.addEventListener("change", function() {
            finalCategory.value = this.value;
        });
        </script>   
  </body>
</html>
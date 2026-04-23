<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>JeSiYo</title>
    <style>
    
    </style>
  </head>
  <body>
  	<h1>Title</h1>
    
    <select id="category1">
        <option value="">대분류 선택</option>
        <c:forEach var="c" items="${roots}">
            <option value="${c.seq}">${c.name}</option>
        </c:forEach>
    </select>
    
    <select id="category2">
        <option value="">중분류 선택</option>
    </select>
    
    <select id="category3">
        <option value="">소분류 선택</option>
    </select>
    <!-- 최종 선택값 (폼 제출용) -->
    <input type="hidden" name="categorySeq" id="finalCategory">
  	
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
        
            fetch(`/api/categories/${seq}/children`)
                .then(res => res.json())
                .then(data => fillSelect(category2, data));
        });
        
        // 중분류 → 소분류
        category2.addEventListener("change", function() {
            const seq = this.value;
        
            category3.innerHTML = '<option value="">소분류 선택</option>';
            finalCategory.value = "";
        
            if (!seq) return;
        
            fetch(`/api/categories/${seq}/children`)
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
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
    
    <div class="page-wrap">

    <!-- 제목 -->
    <h2 class="section-title">내 알림</h2>
    <p class="section-desc">최근에 받은 알림 목록입니다</p>

    <!-- 카드 -->
    <div class="content-card">
        <div class="card-pad overflow-x-auto">

            <table class="table w-full table-fixed">
                <!-- 헤더 -->
                <thead class="hidden">
                    <tr class="text-slate-500 text-sm">
                        <th class="w-[15%]">종류</th>
                        <th class="w-[50%]">내용</th>
                        <th class="w-[20%]">날짜</th>
                        <th class="w-[10%] text-center">읽음</th>
                    </tr>
                </thead>

                <!-- 바디 -->
                <tbody>
                    <c:forEach var="dto" items="${list}">
                        <tr class="hover:bg-slate-50 transition">
                            <!-- 종류 -->
                            <td class="w-[10%] text-center">
                                <span class="status-badge badge-selling">
                                    <c:choose>
                                        <c:when test="${dto.refType == 'DIRECT'}">
                                            중고거래
                                        </c:when>
                                        <c:when test="${dto.refType == 'OTHER'}">
                                            기타
                                        </c:when>
                                        <c:otherwise>
                                            ${dto.refType}
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <!-- 메시지 -->
                            <td class="w-[65%] py-3">
                                <div class="text-slate-800 leading-relaxed break-words whitespace-normal">
                                    ${dto.message}
                                </div>
                            </td>
                            <!-- 생성일 -->
                            <td class="w-[15%] text-sm text-slate-500">
                                <fmt:formatDate value="${dto.createdAt}" pattern="MM.dd HH:mm"/>
                            </td>
                            <!-- 읽음 여부 -->
                            <td class="w-[10%] text-start">
                                <c:choose>
                                    <c:when test="${dto.isRead == 'Y'}">
                                        <span class="status-badge badge-sold">읽음</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge badge-auction cursor-pointer mark-read"
                                          data-seq="${dto.seq}">
                                          안읽음
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

        </div>
    </div>

</div>

    
    
    </div>
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
  	<script>
    	$(document).on("click", ".mark-read", function () {
    	    if (!confirm("해당 알림을 읽음 처리 하시겠습니까?")) {
    	        return;
    	    }
    	    const seq = $(this).data("seq");
    	    const $badge = $(this);
    	    $.ajax({
    	        url: "/jesiyo/api/notifications/" + seq + "/read",
    	        type: "POST",
    	        success: function () {
    	            // UI 변경
    	            $badge
    	                .removeClass("badge-auction")
    	                .addClass("badge-sold")
    	                .text("읽음")
    	                .removeClass("mark-read")
    	                .css("cursor", "default");
    	        },
    	        error: function () {
    	            alert("처리 실패");
    	        }
    	    });
    	});
  	
  	
    </script>   
  </body>
</html>
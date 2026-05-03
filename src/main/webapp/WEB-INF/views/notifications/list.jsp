<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    
    <h2>내 알림 목록화면</h2>

    <c:forEach var="dto" items="${list}">
      <div>
          <p>${dto.message}</p>
          <p>${dto.createdAt}</p>
          <p>${dto.isRead}</p>
      </div>
    </c:forEach>
    
    
    </div>
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
  	<script>
  	
    </script>   
  </body>
</html>
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
    
    <h2>브라우저 콘솔을 확인하세요!</h2>
    
    </div>
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
  	<script>
        const es = new EventSource("/jesiyo/api/notifications/subscribe");
    
        es.onopen = () => console.log("연결됨");
    
        es.addEventListener("connect", (e) => {
            console.log("connect:", e.data);
        });
    
        es.addEventListener("notification", (e) => {
            console.log("알림:", e.data);
        });
    
        es.onerror = (e) => console.log("에러", e);
    </script>   
  </body>
</html>
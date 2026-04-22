<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Kakao 지도 시작하기</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
    <link rel="stylesheet" href="https://bit.ly/3WJ5ilK">
    <style>
    
    </style>
  </head>
  <body>
  	<div class="flex justify-center align-items-center h-screen">
      <div id="map" style="width:500px;height:400px;" class=""></div>
    </div>

      
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=43be306c3c777621437a473e15f4d3c5"></script>
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
    <script src="https://bit.ly/4cMuheh"></script>
    <script>
        var container = document.getElementById('map');
        var options = {
          center: new kakao.maps.LatLng(33.450701, 126.570667),
          level: 3
        };
  
  	    var map = new kakao.maps.Map(container, options);
    </script>   
  </body>
</html>
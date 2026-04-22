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
        var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
        mapOption = {
            center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
            level: 4 // 지도의 확대 레벨 
        };
        var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
        
        // HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
        if (navigator.geolocation) {
            // GeoLocation을 이용해서 접속 위치를 얻어옵니다
            navigator.geolocation.getCurrentPosition(function(position) {
                var lat = position.coords.latitude, // 위도
                    lon = position.coords.longitude; // 경도
               	// 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
              	var locPosition = new kakao.maps.LatLng(lat, lon); 
                // 마커를 표시합니다
                displayMarker(locPosition);
              });
            
            } else { // HTML5의 GeoLocation을 사용할 수 없을때
                var locPosition = new kakao.maps.LatLng(33.450701, 126.570667);
                displayMarker(locPosition);
            }
            
            // 지도에 마커를 표시하는 함수입니다
            function displayMarker(locPosition) {
                // 마커를 생성합니다
                var marker = new kakao.maps.Marker({  
                    map: map, 
                    position: locPosition
                }); 
                
                // 지도 중심좌표를 접속위치로 변경합니다
                map.setCenter(locPosition);
            }    
    
    </script>   
  </body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>For Class</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
    <style>
      .map_wrap {position:relative;width:100%;height:350px;}
      .title {font-weight:bold;display:block;}
      .hAddr {position:absolute;left:10px;top:10px;border-radius: 2px;background:#fff;background:rgba(255,255,255,0.8);z-index:1;padding:5px;}
      #centerAddr {display:block;margin-top:2px;font-weight: normal;}
      .bAddr {padding:5px;text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
      .map-btn {
          position: absolute;
          right: 15px;
          bottom: 15px;
          z-index: 10;
      }
    </style>
  </head>
  <body class="bg-slate-50">
  <%@ include file="/WEB-INF/views/inc/header.jsp" %>
  
  	<main class="page-wrap">
      <div class="map_wrap">
        <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
        <div class="hAddr">
            <span class="title text-brand-500">여기가 맞나요?</span>
            <span id="centerAddr"></span>
        </div>
        
        <div>
          <button onclick="sendLocation();" class="btn-brand map-btn">
            여기로 동네 정하기
          </button>
        </div>
      </div>
    </main>
  
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=43be306c3c777621437a473e15f4d3c5&libraries=services"></script>
  	<script>
    	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
        mapOption = {
            center: new kakao.maps.LatLng(37.5045, 127.0490), // 지도의 중심좌표
            level: 5
        };  
        
        // 지도를 생성합니다    
        var map = new kakao.maps.Map(mapContainer, mapOption); 
        // 주소-좌표 변환 객체를 생성합니다
        var geocoder = new kakao.maps.services.Geocoder();
        // 현재 지도 중심좌표로 주소를 검색해서 지도 좌측 상단에 표시합니다
        searchAddrFromCoords(map.getCenter(), displayCenterInfo);
        
        // 지도 처음 중심이 자동으로 내 위치로 이동
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {

                var lat = position.coords.latitude;
                var lng = position.coords.longitude;

                var moveLatLng = new kakao.maps.LatLng(lat, lng);

                map.setCenter(moveLatLng); // 지도 중심 이동

            });
        }
        
        // 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
        kakao.maps.event.addListener(map, 'idle', function() {
            searchAddrFromCoords(map.getCenter(), displayCenterInfo);
        });
        
        function searchAddrFromCoords(coords, callback) {
            // 좌표로 행정동 주소 정보를 요청합니다
            geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);         
        }
        
        // 지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
        function displayCenterInfo(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var infoDiv = document.getElementById('centerAddr');
        
                for(var i = 0; i < result.length; i++) {
                    // 행정동의 region_type 값은 'H' 이므로
                    if (result[i].region_type === 'H') {
                    	
                    	 const center = map.getCenter(); // 추가
                         currentRegion = { // 추가
                             sido: result[i].region_1depth_name,
                             sigungu: result[i].region_2depth_name,
                             dong: result[i].region_3depth_name,
                             lat: center.getLat(),
                             lng: center.getLng()
                         };
                    	
                        infoDiv.innerHTML = result[i].address_name;
                        break;
                    }
                }
            }    
        }
        
        function sendLocation() {
            console.log(currentRegion);

            $.ajax({
                url: '/jesiyo/api/location/member',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(currentRegion),
                success: function(res) {
                    alert("동네 설정 완료!");
                }
            });
        }
  	
  	</script>   
  </body>
</html>
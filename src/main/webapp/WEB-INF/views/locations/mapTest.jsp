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
  	<div class="flex flex-col justify-center align-items-center h-screen">
      <div id="map" style="width:500px;height:400px;" class=""></div>
      <div id="addr">동네 표시</div>
      <button onclick="sendLocation()">이 위치로 설정</button>
    </div>

      
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=43be306c3c777621437a473e15f4d3c5&libraries=services"></script>
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
    <script src="https://bit.ly/4cMuheh"></script>
    <script>
    console.log(document.getElementById('addr'));
        var mapContainer = document.getElementById('map');
    
        let currentRegion = null;
        let currentCoords = null;
        let timer = null;
    
        var geocoder = new kakao.maps.services.Geocoder();
    
        var mapOption = {
            center: new kakao.maps.LatLng(33.450701, 126.570667),
            level: 4
        };
    
        var map = new kakao.maps.Map(mapContainer, mapOption);
    
        // 위치 정보 업데이트 함수
        function updateRegionInfo(latlng) {
            geocoder.coord2RegionCode(latlng.getLng(), latlng.getLat(), function(result, status) {
            	
            	console.log(result);
            	console.log(status);
            	
                if (status === kakao.maps.services.Status.OK) {
    
                    const region = result.find(r => r.region_type === 'H');
    
                    if (region) {
                        currentRegion = {
                            sido: region.region_1depth_name,
                            sigungu: region.region_2depth_name,
                            dong: region.region_3depth_name,
                            lat: latlng.getLat(),
                            lng: latlng.getLng()
                        };
                        document.getElementById('addr').innerText =
                            `${region.region_1depth_name} ${region.region_2depth_name} ${region.region_3depth_name}`;
                        console.log(document.getElementById('addr'));
                    }
                }
            });
        }
    
        // 마커 표시 + 초기 주소 표시
        function displayMarker(locPosition) {
            var marker = new kakao.maps.Marker({
                map: map,
                position: locPosition
            });
    
            map.setCenter(locPosition);
    
            // ⭐ 초기 주소 표시
            updateRegionInfo(locPosition);
        }
    
        // 현재 위치 가져오기
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
    
                var lat = position.coords.latitude;
                var lon = position.coords.longitude;
    
                var locPosition = new kakao.maps.LatLng(lat, lon);
    
                displayMarker(locPosition);
    
            });
        } else {
            var locPosition = new kakao.maps.LatLng(33.450701, 126.570667);
            displayMarker(locPosition);
        }
    
        // 지도 이동 시 (디바운스 적용)
        kakao.maps.event.addListener(map, 'center_changed', function() {
    
            if (timer) clearTimeout(timer);
    
            timer = setTimeout(() => {
                const center = map.getCenter();
                currentCoords = center;
    
                updateRegionInfo(center);
    
            }, 300);
        });
    
        // 서버 전송 함수
        function sendLocation() {
            if (!currentRegion) {
                alert("위치를 먼저 선택하세요");
                return;
            }
    
            console.log(currentRegion);
    
            // AJAX 예시
            /*
            $.ajax({
                url: '/location/save',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(currentRegion),
                success: function(res) {
                    alert("저장 완료");
                }
            });
            */
        }
    </script>   
  </body>
</html>
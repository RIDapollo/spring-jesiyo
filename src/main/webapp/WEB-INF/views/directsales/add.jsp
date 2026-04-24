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
    .map_wrap {position:relative;width:100%;height:320px;}
    
    .hAddr {
        position:absolute;
        left:10px;
        top:10px;
        background:rgba(255,255,255,0.9);
        padding:8px 10px;
        border-radius:6px;
        z-index:10;
    }
    
    .map-btn {
        position:absolute;
        right:15px;
        bottom:15px;
        z-index:10;
    }
    </style>
  </head>
  <body class="bg-slate-50">
  <%@ include file="/WEB-INF/views/inc/header.jsp" %>
    <div class="page-wrap max-w-3xl">
      <h1 class="section-title">내 물건 팔기</h1>
      <p class="section-desc">동네 이웃과 나눌 물건의 정보를 입력해주세요.</p>
    
        <form action="/directsales" method="POST" enctype="multipart/form-data" class="content-card card-pad flex flex-col gap-6">
            <!-- 상품명 -->
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">상품명 <span class="text-rose-500">*</span></label>
                <input type="text" name="productName"
                   class="input input-bordered w-full focus:border-brand-500 focus:outline-none"
                   placeholder="상품명을 입력하세요" required />
            </div>
            <!-- 제목 -->
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">제목 <span class="text-rose-500">*</span></label>
                <input type="text" name="name"
                   class="input input-bordered w-full focus:border-brand-500 focus:outline-none"
                   placeholder="글 제목을 입력하세요" required />
            </div>
    
            <!-- 가격 -->
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">가격 (원) <span class="text-rose-500">*</span></label>
                <input type="number" name="price"
                   class="input input-bordered w-full focus:border-brand-500 focus:outline-none"
                   placeholder="가격을 입력하세요" />
            </div>
    
            <!-- 카테고리 (핵심) -->
            <div>
                <label class="block text-sm font-semibold text-slate-700 mb-2">카테고리 <span class="text-rose-500">*</span></label>
    
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
                <label class="block text-sm font-semibold text-slate-700 mb-2">
                    상품 사진 <span class="text-slate-400 text-xs">(선택)</span>
                </label>
            
                <!-- 기본 이미지 / 미리보기 -->
                <img id="preview"
                     src="/jesiyo/resources/image/default_image.png"
                     class="w-40 h-40 object-cover rounded-lg mb-3 border border-slate-200" />
            
                <!-- 파일 선택 -->
                <input type="file" name="imageFile"
                       accept="image/*"
                       onchange="previewImage(this)"
                       class="file-input file-input-bordered w-full focus:border-brand-500" />
            </div>
    
            <!-- 거래 위치 -->
            <div>
                <div class="flex items-center justify-start mb-2 gap-3">
                  <label class="block text-sm font-semibold text-slate-700 mb-2">거래 위치</label>
                   <!-- 위치 선택 -->
                  <button type="button" onclick="openMap()" class="btn-brand !bg-point-500 !px-3 !py-1.5 text-sm">
                      위치 선택하기
                  </button>
                </div>
                <!-- 지도 영역 -->
                <div id="mapWrap" class="map_wrap mt-4 hidden">
                    <div id="map" class="w-full h-80 rounded-lg overflow-hidden"></div>
                
                    <div class="hAddr">
                        <span class="title text-brand-500">여기가 맞나요?</span>
                        <span id="centerAddr"></span>
                    </div>
                
                    <button type="button"
                            onclick="selectLocation()"
                            class="btn-brand map-btn !bg-point-500">
                        거래 위치 설정 완료
                    </button>
                </div>
                
                <!-- 최종 seq 저장 -->
                <input type="hidden" name="tradeLocationSeq" id="tradeLocationSeq">
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
   
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=43be306c3c777621437a473e15f4d3c5&libraries=services"></script>
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
        
        // 이미지 미리보기
        function previewImage(input) {
            const file = input.files[0];
        
            const reader = new FileReader();
            reader.onload = e => {
                document.getElementById('preview').src = e.target.result;
            };
        
            reader.readAsDataURL(file);
        }
        
        // 지도그리기 관련
        let map;
        let geocoder;
        let currentRegion = null;

        // 1. 버튼 클릭 → 지도 열기
        function openMap() {

            document.getElementById('mapWrap').classList.remove('hidden');

            // 최초 1회만 생성
            if (!map) {

                const container = document.getElementById('map');

                map = new kakao.maps.Map(container, {
                    center: new kakao.maps.LatLng(37.5665, 126.9780),
                    level: 4
                });

                geocoder = new kakao.maps.services.Geocoder();

                // 지도 이동 시 주소 갱신
                kakao.maps.event.addListener(map, 'idle', function () {
                    searchAddrFromCoords(map.getCenter(), displayCenterInfo);
                });

                // 내 위치로 이동
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(function (position) {

                        const lat = position.coords.latitude;
                        const lng = position.coords.longitude;

                        map.setCenter(new kakao.maps.LatLng(lat, lng));
                    });
                }
            }
        }

        // 2. 좌표 → 동 변환
        function searchAddrFromCoords(coords, callback) {
            geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
        }

        // 3. 현재 위치 저장
        function displayCenterInfo(result, status) {

            if (status === kakao.maps.services.Status.OK) {

                const infoDiv = document.getElementById('centerAddr');

                for (let i = 0; i < result.length; i++) {

                    if (result[i].region_type === 'H') {

                        const center = map.getCenter();

                        currentRegion = {
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

        // 4. 선택 완료 → API 호출 → seq 저장
        function selectLocation() {

            if (!currentRegion) {
                alert("위치를 선택해주세요.");
                return;
            }

            fetch('/jesiyo/api/trade-locations', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(currentRegion)
            })
            .then(res => res.json())
            .then(data => {

                document.getElementById('tradeLocationSeq').value = data.seq;
                alert("거래 위치 설정 완료!");
            });
        }
        
        </script>   
  </body>
</html>
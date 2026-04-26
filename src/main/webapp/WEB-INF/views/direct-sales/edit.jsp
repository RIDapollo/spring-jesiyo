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
      <h1 class="section-title">내 물건 수정</h1>
      <p class="section-desc">거래정보를 수정하세요</p>
      <form action="/jesiyo/direct-sales/${dto.seq}"
      method="POST"
      enctype="multipart/form-data"
      class="content-card card-pad flex flex-col gap-6">
    
    <input type="hidden" name="seq" value="${dto.seq}">

    <!-- 상품명 -->
    <div>
        <label class="block text-sm font-semibold text-slate-700 mb-2">
            상품명 <span class="text-rose-500">*</span>
        </label>
        <input type="text" name="productName"
               value="${dto.productName}"
               class="input input-bordered w-full focus:border-brand-500 focus:outline-none"
               required />
    </div>

    <!-- 제목 -->
    <div>
        <label class="block text-sm font-semibold text-slate-700 mb-2">
            제목 <span class="text-rose-500">*</span>
        </label>
        <input type="text" name="name"
               value="${dto.name}"
               class="input input-bordered w-full focus:border-brand-500 focus:outline-none"
               required />
    </div>

    <!-- 가격 -->
    <div>
        <label class="block text-sm font-semibold text-slate-700 mb-2">
            가격 (원)
        </label>
        <input type="number" name="price"
               value="${dto.price}"
               class="input input-bordered w-full focus:border-brand-500 focus:outline-none"
               min="0" step="1000" />
    </div>

    <!-- 카테고리 -->
    <div>
        <label class="block text-sm font-semibold text-slate-700 mb-2">
            카테고리 <span class="text-rose-500">*</span>
        </label>

        <div class="grid grid-cols-3 gap-3">
            <select id="category1"
                    class="select select-bordered w-full"
                    required>
                <option value="">대분류</option>
                <c:forEach var="c" items="${roots}">
                    <option value="${c.seq}">${c.name}</option>
                </c:forEach>
            </select>

            <select id="category2" class="select select-bordered w-full">
                <option value="">중분류</option>
            </select>

            <select id="category3" class="select select-bordered w-full">
                <option value="">소분류</option>
            </select>
        </div>

        <input type="hidden" name="categorySeq" id="finalCategory"
               value="${dto.categorySeq}">
    </div>

    <!-- 이미지 -->
    <div>
        <label class="block text-sm font-semibold text-slate-700 mb-2">
            상품 사진
        </label>

        <img id="preview"
             src="${dto.imageUrl != null ? '/jesiyo' += dto.imageUrl : '/jesiyo/resources/image/default_image.png'}"
             class="w-40 h-40 object-cover rounded-lg mb-3 border" />

        <input type="file" name="imageFile"
               onchange="previewImage(this)"
               class="file-input file-input-bordered w-full" />
         <input type="hidden" name="imageUrl" value="${dto.imageUrl}" />
    </div>

    <!-- 거래 위치 -->
    <div>
        <div class="flex items-center gap-3 mb-2">
            <label class="text-sm font-semibold text-slate-700">
                거래 위치
            </label>

            <button type="button"
                    onclick="openMap()"
                    class="btn-sub !px-3 !py-1.5 text-sm">
                위치 선택
            </button>
        </div>

        <!-- 🔥 edit에서는 기본적으로 보이게 -->
        <div id="mapWrap" class="map_wrap mt-4 ${dto.tradeLocationSeq != null ? '' : 'hidden'}">

            <div id="map" class="w-full h-80 rounded-lg overflow-hidden"></div>

            <div class="hAddr">
                <span class="title text-brand-500">여기가 맞나요?</span>
                <span id="centerAddr"></span>
            </div>

            <button type="button"
                    onclick="selectLocation()"
                    class="btn-sub map-btn">
                여기로 위치 설정
            </button>
        </div>

        <input type="hidden" name="tradeLocationSeq" id="tradeLocationSeq"
               value="${dto.tradeLocationSeq}">
    </div>

    <!-- 설명 -->
    <div>
        <label class="block text-sm font-semibold text-slate-700 mb-2">
            상세 설명
        </label>
        <textarea name="description" rows="6"
                  class="textarea textarea-bordered w-full">${dto.description}</textarea>
    </div>

    <!-- 버튼 -->
    <div class="flex justify-end gap-2 mt-4">
        <button type="button"
                class="btn-cancel px-6"
                onclick="history.back();">
            취소
        </button>

        <button type="submit" class="btn-brand px-8">
            수정하기
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
        
        // ?서버 값 받기 (JSP)
        const categoryPath = [];
        <c:forEach var="c" items="${dto.categoryPath}">
            categoryPath.push({
                seq: ${c.seq},
                name: "${c.name}",
                parentSeq: ${c.parentSeq}
            });
        </c:forEach>
        
        const initLat = ${dto.tradeLocationDto != null ? dto.tradeLocationDto.lat : 'null'};
        const initLng = ${dto.tradeLocationDto != null ? dto.tradeLocationDto.lng : 'null'};
        
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
        
        //  초기 카테고리 세팅
        window.onload = function() {
        
            if (!categoryPath && categoryPath.length ===0 ) return;
        
                const c1 = categoryPath[0]?.seq;
                const c2 = categoryPath[1]?.seq;
                const c3 = categoryPath[2]?.seq;
                
                console.log(c1);
                console.log(c2);
                console.log(c3);
                
                category1.value = c1;
                
                fetch('/jesiyo/api/categories/' + c1 + '/children')
                .then(res => res.json())
                .then(data => {

                    fillSelect(category2, data);
                    category2.value = c2;

                    // 3️⃣ 소분류 로딩
                    return fetch('/jesiyo/api/categories/' + c2 + '/children');
                })
                .then(res => res.json())
                .then(data2 => {

                    fillSelect(category3, data2);
                    category3.value = c3;

                    finalCategory.value = c3;
                });
                
            // 지도 초기 표시
            if (initLat && initLng) {
                openMap();
            }
        };
        
        // 대분류 → 중분류
        category1.addEventListener("change", function() {
            const seq = this.value;
        
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
        
        // 지도
        let map;
        let geocoder;
        let currentRegion = null;
        
        function openMap() {
        
            document.getElementById('mapWrap').classList.remove('hidden');
        
            if (!map) {
        
                const container = document.getElementById('map');
                let center = new kakao.maps.LatLng(37.5665, 126.9780);
                if (initLat && initLng) {
                    center = new kakao.maps.LatLng(initLat, initLng);
                }
        
                map = new kakao.maps.Map(container, {
                    center: center,
                    level: 4
                });
                
             // 기존 위치 없을 때 → 사용자 위치 요청
                if (!initLat || !initLng) {

                    if (navigator.geolocation) {

                        navigator.geolocation.getCurrentPosition(function(position) {

                            const lat = position.coords.latitude;
                            const lng = position.coords.longitude;

                            const userLoc = new kakao.maps.LatLng(lat, lng);

                            map.setCenter(userLoc);

                        }, function(error) {
                            console.log("위치 권한 거부 또는 실패", error);
                        });

                    }
                }
        
                geocoder = new kakao.maps.services.Geocoder();
        
                kakao.maps.event.addListener(map, 'idle', function () {
                    searchAddrFromCoords(map.getCenter(), displayCenterInfo);
                });
        
                // 기존 위치 세팅
                if (initLat && initLng) {
                    currentRegion = {
                        lat: initLat,
                        lng: initLng
                    };
                }
            }
        }
        
        // 좌표 → 주소
        function searchAddrFromCoords(coords, callback) {
            geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
        }
        
        // 현재 위치 표시
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
        
        // 위치 선택
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
                alert("거래 위치가 설정되었습니다!");
            });
        }
        </script>
  </body>
</html>
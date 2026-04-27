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
    <style>
        #mapDongLabel {
          position: absolute;
          left: 10px;
          top: 10px;
          z-index: 10;
          background: rgba(255,255,255,0.9);
          padding: 6px 10px;
          border-radius: 6px;
          font-size: 12px;
          font-weight: 600;
        }
    </style>
  </head>
  <%@ include file="/WEB-INF/views/inc/header.jsp" %>
  <body class="bg-slate-50">
    <div class="page-wrap max-w-3xl">
    
      <div class="flex items-center justify-between mb-4">
        <button class="btn-cancel" onclick="history.back()">
          돌아가기
        </button>
        <!-- 오른쪽: 수정 / 삭제 (작성자만) -->
        <c:if test="${not empty sessionScope.user 
          and sessionScope.user.seq == dto.sellerSeq}">
          <div class="flex gap-2">
          
          <!-- 수정 -->
          <a href="/jesiyo/direct-sales/${dto.seq}/edit" class="btn-sub">
            수정
          </a>
          <!-- 삭제 -->
          <button type="button" class="btn-danger" data-seq="${dto.seq}">
            삭제
          </button>
          </div>
        </c:if>
      </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
        <!-- 왼쪽 영역 -->
        <div class="flex flex-col gap-4">
            <!-- 상품 이미지 (카드 제거) -->
            <div class="item-img-wrap">
                <c:if test="${dto.status eq '완료'}">
                    <span class="absolute top-3 left-3 status-badge badge-sold z-10">
                        판매완료
                    </span>
                </c:if>
                <img src="/jesiyo${dto.imageUrl}" class="item-img">
            </div>

            <!-- 판매자 정보 (이미지 아래, 같은 너비) -->
            <div class="content-card card-pad flex items-center justify-between">

                <div>
                    <div class="font-bold text-lg">
                        ${dto.sellerNickname}
                    </div>
                    <div class="text-sm text-slate-400">
                        ${dto.sellerAddress} • ${dto.tradeCount == 0 ? '첫 판매' : '판매 '.concat(dto.tradeCount)}
                    </div>
                </div>

                <!-- 판매자 평점 -->
                <div class="text-right">
                    <div class="text-xs text-slate-400">
                        판매자 평점
                    </div>
                    <div class="text-lg font-bold text-slate-900">
                        <fmt:formatNumber value="${dto.sellerRating}" minFractionDigits="1" maxFractionDigits="1"/>
                    </div>
                </div>
            </div>

        </div>

        <!--  오른쪽 영역 (상품 정보) -->
        <div class="flex flex-col gap-3">
            <!-- 제목 -->
            <h1 class="text-2xl font-bold">
                ${dto.name}
            </h1>
            <!-- 카테고리 -->
            <div class="text-sm text-slate-400">
                홈 >
                <c:forEach var="cat" items="${dto.categoryPath}" varStatus="status">
                    ${cat.name}
                    <c:if test="${!status.last}"> ></c:if>
                </c:forEach>
            </div>
            <!-- 시간 -->
            <div class="text-sm text-slate-400">
                <span class="!text-slate-800">${dto.productName}</span> • ${dto.timeAgo}
            </div>
            <!-- 가격 -->
            <div class="text-2xl font-bold text-slate-900">
                <fmt:formatNumber value="${dto.price}" type="number"/>원
            </div>
            <!-- 설명 -->
            <div class="text-slate-700 leading-relaxed">
                ${dto.description}
            </div>
            <!-- 위치 -->
            <c:if test="${not empty dto.tradeLocationDto}">
            <div id="map" class="w-full h-56 rounded-md"></div>
            </c:if>
            <!-- 버튼 -->
            <button class="btn-brand py-3 text-base"
              onclick="requestTrade(${dto.seq}, ${dto.sellerSeq})">
                판매자에게 구매 요청 하기
            </button>
        </div>

    </div>   
    </div>
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
    <c:if test="${not empty dto.tradeLocationDto}">
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=43be306c3c777621437a473e15f4d3c5"></script>
    <script>
    $(function () {
    
        const lat = ${dto.tradeLocationDto.lat};
        const lng = ${dto.tradeLocationDto.lng};
    
        const container = document.getElementById('map');
    
        const options = {
            center: new kakao.maps.LatLng(lat, lng),
            level: 3
        };
    
        const map = new kakao.maps.Map(container, options);
    
        // 마커 생성
        const markerPosition = new kakao.maps.LatLng(lat, lng);
    
        const marker = new kakao.maps.Marker({
            position: markerPosition
        });
    
        marker.setMap(map);
    
        const overlay = document.createElement('div');
        overlay.id = 'mapDongLabel';
        overlay.innerText = '${dto.tradeLocationDto.dong}';

        document.getElementById('map').appendChild(overlay);
    });
    
    document.querySelector(".btn-danger").addEventListener("click", function () {

        const seq = this.dataset.seq;

        if (!confirm("정말 삭제하시겠습니까?")) {
            return;
        }

        fetch(`/jesiyo/api/direct-sales/\${seq}`, {
            method: "DELETE"
        })
        .then(res => {
            if (res.ok) {
                alert("삭제되었습니다.");
                window.location.href = "/jesiyo/direct-sales"; // 성공시 목록으로 이동
            } else if (res.status === 404) {
                alert("이미 삭제되었거나 존재하지 않는 데이터입니다.");
            } else {
                alert("삭제 실패");
            }
        })
        .catch(err => {
            console.error(err);
            alert("서버 오류");
        });

    });
    
    </script>
    </c:if>
    
    <script>
    function requestTrade(directSaleSeq, sellerSeq) {

        fetch("/jesiyo/api/trades", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                directSaleSeq: directSaleSeq,
                sellerSeq: sellerSeq
            })
        })
        .then(res => {
            if (res.status === 401) {
                alert("로그인이 필요합니다.");
                window.location.href = "/jesiyo/member/login";
                return;
            }
            return res.text();
        })
        .then(data => {
            if (data === "OK") {
                alert("거래요청 완료!");
                window.location.href = "/jesiyo/direct-sales"; // 또는 상세페이지 유지
            }
        })
        .catch(err => {
            console.error(err);
        });
    }</script>
  </body>
</html>
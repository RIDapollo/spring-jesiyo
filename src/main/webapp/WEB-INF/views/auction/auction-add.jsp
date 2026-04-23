<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>경매목록</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp" %>
</head>
<body>
    <%@ include file="/WEB-INF/views/inc/header.jsp" %>

    <div class="page-wrap max-w-3xl">
    <h1 class="main-title text-2xl font-bold mb-2 text-slate-900">경매 등록</h1>
    <p class="section-desc text-sm text-slate-500 mb-6">새로운 경매 상품의 정보를 입력해주세요.</p>
    
    <form action="/auction/register" method="POST" enctype="multipart/form-data" class="content-card card-pad flex flex-col gap-6 bg-white border border-slate-200 rounded-2xl shadow-sm p-5 md:p-6">
        
        <div>
            <label class="block text-sm font-semibold text-slate-700 mb-2">카테고리 <span class="text-rose-500">*</span></label>
            <select name="category" class="select select-bordered w-full focus:border-brand-500 focus:outline-none" required>
                <option disabled selected value="">카테고리를 선택하세요</option>
                
                <optgroup label="전자기기">
                    <option value="컴퓨터램">컴퓨터램</option>
                    <option value="cpu">cpu</option>
                    <option value="그래픽카드">그래픽카드</option>
                    <option value="핸드폰케이스">핸드폰케이스</option>
                    <option value="액정필름">액정필름</option>
                    <option value="카드케이스">카드케이스</option>
                    <option value="TV벽걸이TV">TV벽걸이TV</option>
                    <option value="스탠드TV">스탠드TV</option>
                    <option value="에어컨벽걸이에어컨">에어컨벽걸이에어컨</option>
                    <option value="스탠드에어컨">스탠드에어컨</option>
                </optgroup>
                
                <optgroup label="생활용품">
                    <option value="주방용품세제">주방용품세제</option>
                    <option value="도마">도마</option>
                    <option value="칼">칼</option>
                    <option value="주방가위">주방가위</option>
                    <option value="청소용품청소기">청소용품청소기</option>
                    <option value="로봇청소기">로봇청소기</option>
                    <option value="세탁기">세탁기</option>
                    <option value="건조기">건조기</option>
                    <option value="스타일러">스타일러</option>
                </optgroup>
                
                <optgroup label="의류/신발">
                    <option value="상의반팔">상의반팔</option>
                    <option value="니트">니트</option>
                    <option value="긴팔">긴팔</option>
                    <option value="맨투맨">맨투맨</option>
                    <option value="셔츠">셔츠</option>
                    <option value="하의청바지">하의청바지</option>
                    <option value="면바지">면바지</option>
                    <option value="반바지">반바지</option>
                    <option value="아우터패딩">아우터패딩</option>
                    <option value="코트">코트</option>
                    <option value="후리스">후리스</option>
                    <option value="후드">후드</option>
                    <option value="신발슬리퍼">신발슬리퍼</option>
                    <option value="운동화">운동화</option>
                    <option value="구두">구두</option>
                </optgroup>
            </select>
        </div>

        <div>
            <label class="block text-sm font-semibold text-slate-700 mb-2">경매 상품 이름 <span class="text-rose-500">*</span></label>
            <input type="text" name="itemName" placeholder="경매에 올릴 상품의 이름을 입력해주세요" class="input input-bordered w-full focus:border-brand-500 focus:outline-none" required />
        </div>

        <div>
            <label class="block text-sm font-semibold text-slate-700 mb-2">경매 시작가 설정 (원) <span class="text-rose-500">*</span></label>
            <input type="number" name="startPrice" placeholder="시작 가격을 입력해주세요" min="0" class="input input-bordered w-full focus:border-brand-500 focus:outline-none" required />
        </div>

        <div>
            <label class="block text-sm font-semibold text-slate-700 mb-2">상품 이미지 선택</label>
            <input type="file" name="itemImages" multiple accept="image/*" class="file-input file-input-bordered file-input-md w-full focus:border-brand-500" />
            <p class="text-xs text-slate-400 mt-1">* 상품의 상태를 잘 보여주는 사진을 등록해주세요.</p>
        </div>

        <div>
            <label class="block text-sm font-semibold text-slate-700 mb-2">경매 종료 시간 선택 <span class="text-rose-500">*</span></label>
            <input type="datetime-local" name="endTime" class="input input-bordered w-full focus:border-brand-500 focus:outline-none" required />
            <p class="text-xs text-slate-400 mt-1">* 설정된 시간이 되면 판매자에 의해 경매가 종료되거나 낙찰 처리됩니다.</p>
        </div>

        <div>
            <label class="block text-sm font-semibold text-slate-700 mb-2">경매 상품 설명 <span class="text-rose-500">*</span></label>
            <textarea name="description" rows="6" placeholder="상품의 상태, 구매 시기, 하자가 있는 부분 등 상세한 설명을 작성해주세요." class="textarea textarea-bordered w-full text-base focus:border-brand-500 focus:outline-none" required></textarea>
        </div>

        <div class="flex justify-end gap-2 mt-4 pt-4 border-t border-slate-100">
            <button type="button" class="btn bg-slate-200 text-slate-700 hover:bg-slate-300 border-0 rounded-lg px-6 cursor-pointer" onclick="history.back();">취소</button>
            <button type="submit" class="btn-brand px-8">등록</button>
        </div>
        
    </form>
</div>
 
    <script src="https://code.jquery.com/jquery-4.0.0.js"></script>
    <script>
    
    </script>
</body>
</html>







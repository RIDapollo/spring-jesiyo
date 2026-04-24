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
    
    <form action="/jesiyo/auction" method="POST" enctype="multipart/form-data" class="content-card card-pad flex flex-col gap-10 bg-white border border-slate-200 rounded-2xl shadow-sm p-5 md:p-6">
        
        <div>
            <label class="block text-sm font-semibold text-slate-700 mb-2">카테고리 <span class="text-rose-500">*</span></label>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">대분류 <span class="text-rose-500">*</span></label>
                    <select id="mainCategory" class="select select-bordered w-full focus:border-brand-500 focus:outline-none" required>
                        <option disabled selected value="">대분류 선택</option>
                    </select>
                </div>
            
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">소분류 <span class="text-rose-500">*</span></label>
                    <select id="subCategory" name="categorySeq" class="select select-bordered w-full focus:border-brand-500 focus:outline-none disabled:bg-slate-100" required disabled>
                        <option disabled selected value="">대분류를 먼저 선택하세요</option>
                    </select>
                </div>
            </div>

        <div class="form-group pt-6 border-t border-slate-50">
            <label class="block text-sm font-semibold text-slate-700 mb-2">경매 상품 이름 <span class="text-rose-500">*</span></label>
            <input type="text" name="name" placeholder="경매에 올릴 상품의 이름을 입력해주세요" class="input input-bordered w-full focus:border-brand-500 focus:outline-none" required />
        </div>

        <div class="form-group pt-6 border-t border-slate-50">
            <label class="block text-sm font-semibold text-slate-700 mb-2">경매 시작가 설정 (원) <span class="text-rose-500">*</span></label>
            <input type="number" name="bidOpenPrice" placeholder="시작 가격을 입력해주세요" min="0" class="input input-bordered w-full focus:border-brand-500 focus:outline-none" required />
        </div>

        <div class="form-group pt-6 border-t border-slate-50">
            <label class="block text-sm font-semibold text-slate-700 mb-2">상품 이미지 <span class="text-rose-500">*</span></label>
            <input type="file" name="imageFile" id="itemImageInput" accept="image/*" class="file-input file-input-bordered file-input-md w-full focus:border-brand-500" required />
            <p class="text-xs text-slate-400 mt-1">* 상품의 상태를 잘 보여주는 사진 1장을 등록해주세요.</p>

            <div id="previewContainer" class="mt-4 hidden">
                <p class="text-sm font-semibold text-slate-700 mb-2">미리보기</p>
                <div class="relative w-48 h-48 border border-slate-200 rounded-lg overflow-hidden bg-slate-50 flex items-center justify-center">
                    <img id="imagePreview" src="" alt="상품 이미지 미리보기" class="w-full h-full object-cover hidden">
                    <span id="previewPlaceholder" class="text-sm text-slate-400">이미지 로딩 중...</span>
                </div>
            </div>
        </div>

        <div class="form-group pt-6 border-t border-slate-50">
            <label class="block text-sm font-semibold text-slate-700 mb-2">경매 종료 시간 선택 <span class="text-rose-500">*</span></label>
            <input type="datetime-local" name="endDate" class="input input-bordered w-full focus:border-brand-500 focus:outline-none" required />
            <p class="text-xs text-slate-400 mt-1">* 설정된 시간이 되면 판매자에 의해 경매가 종료되거나 낙찰 처리됩니다.</p>
        </div>

        <div class="form-group pt-6 border-t border-slate-50">
            <label class="block text-sm font-semibold text-slate-700 mb-2">경매 상품 설명 <span class="text-rose-500">*</span></label>
            <textarea name="description" rows="6" placeholder="상품의 상세한 설명을 작성해주세요." class="textarea textarea-bordered w-full text-base focus:border-brand-500 focus:outline-none" required></textarea>
        </div>

        <div class="flex justify-end gap-2 mt-4 pt-4 border-t border-slate-100">
            <button type="button" class="btn bg-slate-200 text-slate-700 hover:bg-slate-300 border-0 rounded-lg px-6 cursor-pointer" onclick="history.back();">취소</button>
            <button type="submit" class="btn-brand px-8">등록</button>
        </div>
        
    </form>
</div>

<script src="https://code.jquery.com/jquery-4.0.0.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const imageInput = document.getElementById('itemImageInput');
        const previewContainer = document.getElementById('previewContainer');
        const imagePreview = document.getElementById('imagePreview');
        const previewPlaceholder = document.getElementById('previewPlaceholder');

        imageInput.addEventListener('change', function(event) {
            // 선택된 파일 가져오기 (단일 파일)
            const file = event.target.files[0];

            if (file) {
                // 파일이 이미지인지 확인
                if (!file.type.startsWith('image/')) {
                    alert('이미지 파일만 등록 가능합니다.');
                    imageInput.value = ''; // 입력 초기화
                    return;
                }

                // FileReader를 사용하여 브라우저 메모리에 이미지 올리기
                const reader = new FileReader();

                reader.onload = function(e) {
                    // 읽어온 데이터 URL을 img 태그의 src로 설정
                    imagePreview.src = e.target.result;
                    
                    // UI 업데이트 (미리보기 컨테이너 보이기, 플레이스홀더 숨기기)
                    imagePreview.classList.remove('hidden');
                    previewPlaceholder.classList.add('hidden');
                    previewContainer.classList.remove('hidden');
                };

                // 파일 읽기 실행
                reader.readAsDataURL(file);
            } else {
                // 사용자가 파일 선택 창을 열었다가 취소한 경우 (파일 없음)
                imagePreview.src = '';
                imagePreview.classList.add('hidden');
                previewPlaceholder.classList.remove('hidden');
                previewContainer.classList.add('hidden');
            }
        });
    });
    
    document.addEventListener('DOMContentLoaded', function() {
        
        // ----- [카테고리 동적 연동 로직 시작] -----
        const mainCategory = document.getElementById('mainCategory');
        const subCategory = document.getElementById('subCategory');

        const contextPath = '/jesiyo'; 

        // 1. 페이지 로드 시 대분류(Roots) 가져오기
        fetch(contextPath + '/api/roots')
            .then(response => {
                if (!response.ok) throw new Error('네트워크 응답이 정상이 아닙니다.');
                return response.json();
            })
            .then(data => {
                data.forEach(category => {
                    const option = document.createElement('option');
                    option.value = category.seq;     // CategoryDto의 seq
                    option.text = category.name;     // CategoryDto의 name
                    mainCategory.appendChild(option);
                });
            })
            .catch(error => console.error('대분류 로드 실패:', error));


        // 2. 대분류 선택 시 소분류(Children) 가져오기
        mainCategory.addEventListener('change', function() {
            const parentSeq = this.value;

            // 소분류 초기화
            subCategory.innerHTML = '<option disabled selected value="">소분류 선택</option>';
            subCategory.disabled = true;

            if (parentSeq) {
            	const url = contextPath + "/api/categories/" + parentSeq + "/children";
                //console.log("요청 URL:", url); // 2. URL이 올바른지 확인

                fetch(url)
                    .then(response => {
                        if (!response.ok) {
                            console.error("서버 응답 에러 코드:", response.status); 
                            throw new Error('네트워크 응답이 정상이 아닙니다.');
                        }
                        return response.json();
                    })
                    .then(data => {
                        // 하위 카테고리가 있을 경우 옵션 추가 및 활성화
                        if(data.length > 0) {
                            data.forEach(category => {
                                const option = document.createElement('option');
                                option.value = category.seq;
                                option.text = category.name;
                                subCategory.appendChild(option);
                            });
                            subCategory.disabled = false; // 소분류 셀렉트박스 활성화
                        } else {
                            subCategory.innerHTML = '<option disabled selected value="">하위 카테고리 없음</option>';
                        }
                    })
                    .catch(error => console.error('소분류 로드 실패:', error));
            }
        });
        // ----- [카테고리 동적 연동 로직 끝] -----
    });
</script>
</body>
</html>







<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Jesiyo - 관심 카테고리 추가</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@5" rel="stylesheet" type="text/css" />

    <style>
        body { font-family: "Pretendard", sans-serif; background-color: #f8fafc; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .cat-btn.active { background-color: #ff8a3d !important; color: white !important; box-shadow: 0 4px 6px -1px rgb(255 138 61 / 0.2); }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/inc/header.jsp" />

    <main class="max-w-6xl mx-auto px-4 py-12">
        <header class="mb-12 text-center">
            <h2 class="text-4xl font-black text-slate-900 mb-3">관심 카테고리 추가</h2>
            <p class="text-slate-500 font-medium">원하시는 분류를 단계별로 선택해 주세요.</p>
        </header>

        <form id="wishForm" action="${pageContext.request.contextPath}/member/addWish" method="POST">
            <input type="hidden" name="cateSeq" id="finalCateSeq">

            <%-- 3단 그리드 레이아웃 --%>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
                
                <%-- STEP 1: 대분류 --%>
                <div class="flex flex-col h-[500px] bg-white border border-slate-200 rounded-[2.5rem] overflow-hidden shadow-sm">
                    <div class="p-5 bg-slate-50 border-b border-slate-100 text-center font-bold text-slate-600">STEP 01. 대분류</div>
                    <div class="flex-1 overflow-y-auto p-3 no-scrollbar" id="majorList">
                        <c:forEach items="${categoryList}" var="major">
                            <button type="button" onclick="selectMajor(this, ${major.seq})" 
                                    class="cat-btn w-full flex justify-between items-center px-5 py-4 mb-2 rounded-2xl text-left text-slate-700 font-bold hover:bg-orange-50 hover:text-orange-600 transition-all group">
                                <span>${major.name}</span>
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" class="opacity-0 group-hover:opacity-100 transition-opacity"><path d="m9 18 6-6-6-6"/></svg>
                            </button>
                        </c:forEach>
                    </div>
                </div>

                <%-- STEP 2: 중분류 --%>
                <div class="flex flex-col h-[500px] bg-white border border-slate-200 rounded-[2.5rem] overflow-hidden shadow-sm">
                    <div class="p-5 bg-slate-50 border-b border-slate-100 text-center font-bold text-slate-600">STEP 02. 중분류</div>
                    <div class="flex-1 overflow-y-auto p-3 no-scrollbar text-center" id="middleList">
                        <div class="h-full flex items-center justify-center text-slate-300 font-medium">대분류를 먼저<br>선택해주세요.</div>
                    </div>
                </div>

                <%-- STEP 3: 소분류 --%>
                <div class="flex flex-col h-[500px] bg-white border border-slate-200 rounded-[2.5rem] overflow-hidden shadow-sm">
                    <div class="p-5 bg-slate-50 border-b border-slate-100 text-center font-bold text-slate-600">STEP 03. 소분류</div>
                    <div class="flex-1 overflow-y-auto p-3 no-scrollbar text-center" id="smallList">
                        <div class="h-full flex items-center justify-center text-slate-300 font-medium">중분류를 먼저<br>선택해주세요.</div>
                    </div>
                </div>

            </div>

            <%-- 등록 버튼 --%>
            <div class="max-w-md mx-auto space-y-4">
                <button type="submit" id="submitBtn" disabled 
                        class="w-full py-5 bg-orange-500 text-white font-black rounded-3xl shadow-xl shadow-orange-100 opacity-50 cursor-not-allowed transition-all text-xl">
                    관심 카테고리로 등록하기
                </button>
                <div class="text-center">
                    <a href="javascript:history.back()" class="text-slate-400 font-bold hover:text-slate-600">취소하고 돌아가기</a>
                </div>
            </div>
        </form>
    </main>

    <script>
        const categories = ${categoryJson != null ? categoryJson : '[]'};

        function selectMajor(el, seq) {
            updateActiveState('majorList', el);
            clearList('middleList', '중분류를 선택해주세요.');
            clearList('smallList', '중분류를 선택해주세요.');
            
            const major = categories.find(c => c.seq == seq);
            if (major && major.children.length > 0) {
                renderItems('middleList', major.children, 'selectMiddle');
            } else {
                clearList('middleList', '하위 분류가 없습니다.');
            }
            toggleSubmit(false);
        }

        function selectMiddle(el, seq, parentSeq) {
            updateActiveState('middleList', el);
            clearList('smallList', '소분류를 선택해주세요.');

            const major = categories.find(c => c.seq == parentSeq);
            const middle = major.children.find(c => c.seq == seq);

            if (middle && middle.children.length > 0) {
                renderItems('smallList', middle.children, 'selectSmall');
            } else {
                clearList('smallList', '하위 분류가 없습니다.');
            }
            toggleSubmit(false);
        }

        function selectSmall(el, seq) {
            updateActiveState('smallList', el);
            document.getElementById('finalCateSeq').value = seq;
            toggleSubmit(true);
        }

        function renderItems(targetId, data, clickFn) {
            const container = document.getElementById(targetId);
            container.innerHTML = '';
            data.forEach(item => {
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'cat-btn w-full flex justify-between items-center px-5 py-4 mb-2 rounded-2xl text-left text-slate-700 font-bold hover:bg-orange-50 hover:text-orange-600 transition-all group';
                
                const clickAction = clickFn === 'selectMiddle' 
                    ? `\${clickFn}(this, \${item.seq}, \${item.parentSeq})`
                    : `\${clickFn}(this, \${item.seq})`;
                
                btn.setAttribute('onclick', clickAction);
                btn.innerHTML = `<span>\${item.name}</span><svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" class="opacity-0 group-hover:opacity-100 transition-opacity"><path d="m9 18 6-6-6-6"/></svg>`;
                container.appendChild(btn);
            });
        }

        function updateActiveState(listId, el) {
            document.querySelectorAll(`#\${listId} .cat-btn`).forEach(b => b.classList.remove('active'));
            el.classList.add('active');
        }

        function clearList(id, msg) {
            document.getElementById(id).innerHTML = `<div class="h-full flex items-center justify-center text-slate-300 font-medium">\${msg}</div>`;
        }

        function toggleSubmit(active) {
            const btn = document.getElementById('submitBtn');
            btn.disabled = !active;
            if(active) {
                btn.classList.remove('opacity-50', 'cursor-not-allowed');
                btn.classList.add('hover:bg-orange-600', 'active:scale-95');
            } else {
                btn.classList.add('opacity-50', 'cursor-not-allowed');
                btn.classList.remove('hover:bg-orange-600', 'active:scale-95');
            }
        }
    </script>
</body>
</html>
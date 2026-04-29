<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">

<script src="https://code.jquery.com/jquery-4.0.0.js"></script>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/upload/favicon.png">
<link href="https://cdn.jsdelivr.net/npm/daisyui@5" rel="stylesheet" type="text/css" />
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>

<style>
    body { font-family: "Pretendard", sans-serif; }
</style>

<style type="text/tailwindcss">
    @theme {
        /* 당근마켓 메인 오렌지 컬러 */
        --color-brand-50: #fff8f3;
        --color-brand-100: #ffeadd;
        --color-brand-200: #ffccaa; /* 에러 방지용 필수 변수 */
        --color-brand-500: #ff8a3d; 
        --color-brand-600: #e67026;
        --color-brand-700: #cc5a1b;

        /* 에메랄드 그린 컬러 (안전, 예약중 뱃지용) */
        --color-point-50: #ecfdf5;
        --color-point-100: #d1fae5;
        --color-point-200: #a7f3d0; /* 에러 방지용 필수 변수 */
        --color-point-500: #10b981;
        --color-point-600: #059669;

        /* 로즈 컬러 (경매중 뱃지용) */
        --color-rose-50: #fff1f2;
        --color-rose-100: #ffe4e6;
        --color-rose-200: #fecdd3;
		--color-rose-500: #f43f5e;
        --color-rose-600: #e11d48;
    }

    @layer base {
        body { @apply bg-slate-50 text-slate-800; }
    }

    @layer components {
        /* 공통 레이아웃 */
        .page-wrap { @apply max-w-6xl w-full mx-auto px-4 py-8; }
        .section-title { @apply text-2xl font-bold mb-2 text-slate-900; }
        .section-desc { @apply text-sm text-slate-500 mb-6; }
        .content-card { @apply bg-white border border-slate-200 rounded-2xl shadow-sm; }
        .card-pad { @apply p-5 md:p-6; }
        
        /* 버튼 */
        .btn-brand { @apply text-white bg-brand-500 hover:bg-brand-600 border-0 font-bold transition-colors rounded-lg px-4 py-2 cursor-pointer; }
        /* 서브 버튼 (초록) */
		.btn-sub { @apply text-white bg-point-500 hover:bg-point-600 border-0 font-bold transition-colors rounded-lg px-4 py-2 cursor-pointer; }
		/* 취소 버튼 (회색) */
		.btn-cancel { @apply text-slate-800 bg-slate-200 hover:bg-slate-300 border-0 font-medium transition-colors rounded-lg px-4 py-2 cursor-pointer; }
		/* 삭제 버튼 */
		.btn-danger { @apply text-white bg-rose-500 hover:bg-rose-600 border-0 font-bold transition-colors rounded-lg px-4 py-2 cursor-pointer; }

        /* 상품 카드 */
        .item-card { @apply bg-white border border-slate-100 rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-shadow cursor-pointer flex flex-col; }
        .item-img-wrap { @apply aspect-[4/3] bg-slate-200 overflow-hidden relative; }
        .item-img { @apply w-full h-full object-cover transition-transform duration-300 hover:scale-105; }
        .item-info { @apply p-4 flex flex-col gap-1; }
        .item-title { @apply text-base text-slate-800 line-clamp-2; }
        .item-price { @apply text-lg font-bold text-slate-900; }
        .item-meta { @apply text-xs text-slate-400 mt-1; }

        /* 상태 뱃지 (이제 에러 발생 안 함) */
        .status-badge { @apply inline-flex items-center rounded-md px-2 py-0.5 text-xs font-bold border; }
        .badge-selling { @apply bg-brand-50 text-brand-600 border-brand-200; }
        .badge-reserved { @apply bg-point-50 text-point-600 border-point-200; }
        .badge-sold { @apply bg-slate-100 text-slate-500 border-slate-200; }
        .badge-auction { @apply bg-rose-50 text-rose-600 border-rose-200; }
    }
</style>
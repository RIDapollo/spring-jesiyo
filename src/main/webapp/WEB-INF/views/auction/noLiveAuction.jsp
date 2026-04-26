<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>LIVE AUCTION - 준비 중</title>
    <%@ include file="/WEB-INF/views/inc/asset.jsp"%>
</head>
<body class="bg-slate-50">
    <%@ include file="/WEB-INF/views/inc/header.jsp"%>

    <div class="page-wrap max-w-4xl mx-auto py-20 px-4 md:px-0">
        
        <div class="bg-white border border-slate-200 rounded-2xl shadow-sm p-12 flex flex-col items-center justify-center text-center min-h-[500px]">
            
            <div class="w-24 h-24 bg-slate-100 rounded-full flex items-center justify-center mb-6">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" />
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 3l18 18" />
                </svg>
            </div>

            <h1 class="text-2xl font-bold text-slate-800 mb-3">현재 예정된 라이브 경매가 없습니다</h1>
            
            <p class="text-slate-500 mb-10 max-w-md leading-relaxed">
                다음 라이브 방송 스케줄이 편성될 때까지 잠시만 기다려 주세요.<br>
                일반 경매 목록에서 다양한 물품을 입찰하실 수 있습니다.
            </p>

            <div class="flex flex-col sm:flex-row gap-3 w-full sm:w-auto">
                <button class="btn w-full sm:w-auto bg-white border border-slate-300 text-slate-700 px-8 py-3 rounded-lg font-bold hover:bg-slate-50 transition-colors" onclick="location.href='/jesiyo/index'">
                    메인으로 가기
                </button>
                <button class="btn w-full sm:w-auto bg-brand-500 text-white px-8 py-3 rounded-lg font-bold shadow-md hover:bg-brand-600 transition-colors" onclick="location.href='/jesiyo/auction'">
                    일반 경매 둘러보기
                </button>
            </div>
            
        </div>
        
    </div>

</body>
</html>
package com.test.jesiyo.pagination;

import lombok.Getter;

@Getter
public class PageDto {
    private int nowPage;        // 현재 페이지
    private int totalCount;     // 총 게시물 수
    private int pageSize;       // 한 페이지당 게시물 수
    private int totalPage;      // 총 페이지 수
    private int begin;          // DB용 시작 번호
    private int end;            // DB용 끝 번호
    private int n;              // 페이지바 시작 번호
    private int blockSize;      // 페이지바 개수
    
    public PageDto(int nowPage, int totalCount, int pageSize, int blockSize) {
        this.nowPage = nowPage;
        this.totalCount = totalCount;
        this.pageSize = pageSize;
        this.blockSize = blockSize;

        // 1. 총 페이지 수 계산
        this.totalPage = (int) Math.ceil((double) totalCount / pageSize);

        // 2. DB 구간 계산
        this.begin = ((nowPage - 1) * pageSize) + 1;
        this.end = begin + pageSize - 1;

        // 3. 페이지바 시작 번호 계산
        this.n = ((nowPage - 1) / blockSize) * blockSize + 1;
    }
}
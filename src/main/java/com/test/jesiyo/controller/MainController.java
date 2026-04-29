package com.test.jesiyo.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

// 각 도메인에 맞는 DTO와 DAO를 import 하세요. 
// (패키지 경로는 실제 프로젝트 구조에 맞게 수정이 필요할 수 있습니다.)
import com.test.jesiyo.directsale.repository.DirectSaleDao; 
import com.test.jesiyo.directsale.dto.DirectSaleDto;
import com.test.jesiyo.auction.repository.AuctionDao;
import com.test.jesiyo.auction.dto.AuctionDto;

@Controller
public class MainController {

    @Autowired
    private DirectSaleDao DirectSaleDao; // 중고거래 관련 데이터 접근 객체

    @Autowired
    private AuctionDao auctionDao; // 경매 관련 데이터 접근 객체

    @GetMapping(value = "/index")
    public String index(Model model) {
        
        try {
            // 1. 최근 등록된 중고거래 리스트 조회 (예: 최신순 4개)
            List<DirectSaleDto> recentTrades = DirectSaleDao.getRecentTrades(4);
            
            // 2. 진행 중인 인기 경매 리스트 조회 (예: 마감임박순 4개)
            List<AuctionDto> recentAuctions = auctionDao.getRecentAuctions(4);
            
            // 3. JSP로 데이터 전달
            model.addAttribute("recentTrades", recentTrades);
            model.addAttribute("recentAuctions", recentAuctions);
            
        } catch (Exception e) {
            e.printStackTrace();
            // 에러 발생 시 빈 리스트를 내려주어 페이지 깨짐 방지
            model.addAttribute("recentTrades", null);
            model.addAttribute("recentAuctions", null);
        }
        
        return "index";
    }
}
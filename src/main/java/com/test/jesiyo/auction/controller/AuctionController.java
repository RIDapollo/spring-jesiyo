package com.test.jesiyo.auction.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.test.jesiyo.auction.dto.AuctionDto;
import com.test.jesiyo.auction.service.AuctionService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AuctionController {
	
	private final AuctionService service;
	
	@GetMapping(value = "/auction.do")
	public String action(Model model, 
			@RequestParam(required = false, defaultValue = "") String word, 
			@RequestParam(required = false, defaultValue = "") String status, 
			@RequestParam(required = false, defaultValue = "1") int nowPage) {
		
		//검색기능
		String search = "n"; //목록보기(n), 검색하기(y)
		
		// 검색어나 상태값 중 하나라도 있다면 검색 모드(y)로 전환
		if (!word.trim().isEmpty() || !status.trim().isEmpty()) {
		    search = "y";
		}
		
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("word", word);
		map.put("status", status);
		map.put("search", search);
		
		int totalCount = 0; 	//총 스터디 수
		int pageSize = 8; 		//한페이지에서 보여줄 경매 수
		int totalPage = 0;      //총 페이지 수
		int begin = 0;			//페이징 시작 위치
		int end = 0;			//페이징 끝 위치
		int n = 0; 				//페이지 바의 페이지 번호
		int loop = 0 ;			//페이지 바의 루프변수
		int blockSize = 10; 	//페이지 바의 페이지 개수
		
		begin = ((nowPage - 1) * pageSize) + 1;
		end = begin + pageSize - 1;
		
		
		map.put("begin", begin + "");
		map.put("end", end + "");
		map.put("nowPage", nowPage + "");
		
		//목록 가져오기
		List<AuctionDto> list = service.list(map);
		
		totalCount = service.getTotalCount(map);
		
		totalPage = (int)Math.ceil((double)totalCount / pageSize); 
		
		map.put("totalCount", totalCount + "");
		map.put("totalPage", totalPage + "");
		
		String pagebar = "";
		
		loop = 1; //루프 변수
		n = ((nowPage - 1) / blockSize) * blockSize + 1; //시작 페이지 번호
		
		String query = String.format("&word=%s&status=%s", map.get("word"), map.get("status"));
		
		//이전 10페이지
		if(n == 1) {
			pagebar += String.format("<a href='#!'>[이전 %d페이지]</a>", blockSize);
		} else {
			pagebar += String.format("<a href='/jesiyo/auction.do?page=%d%s'>[이전 %d페이지]</a>", n-1, query, blockSize);
		}
		
		while(!(loop > blockSize || n > totalPage)) {
			
			if(n ==  nowPage) {
				pagebar += String.format("<a href='#!' style='color: tomato;'>%d</a>", n);
			} else {
				pagebar += String.format("<a href='/jesiyo/auction.do?page=%d%s'>%d</a>", n, query, n);
			}
			
			loop++;
			n++;
		}
		
		//다음 10페이지
		if(n >= totalPage) {
			pagebar += String.format("<a href='#!'>[다음 %d페이지]</a>", blockSize);
		} else {
			pagebar += String.format("<a href='/jesiyo/auction.do?page=%d%s'>[다음 %d페이지]</a>", n, query, blockSize);
		}	
		
		model.addAttribute("list", list);
		model.addAttribute("pagebar", pagebar);
		model.addAttribute("map", map);
		
		return "auction/auction-list";
	}
	
}

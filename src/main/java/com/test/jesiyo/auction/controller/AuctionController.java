package com.test.jesiyo.auction.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.test.jesiyo.auction.dto.AuctionDto;
import com.test.jesiyo.auction.service.AuctionService;
import com.test.jesiyo.pagination.PageDto;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AuctionController {
	
	private final AuctionService service;
	
	@GetMapping(value = "/auction.do")
	public String action(Model model, 
			@RequestParam(required = false, defaultValue = "") String word, 
			@RequestParam(required = false, defaultValue = "") String status, 
			@RequestParam(required = false, defaultValue = "1") int page) {
		
		HashMap<String, String> map = new HashMap<>();
		
		//검색정보
	    map.put("word", word);
	    map.put("status", status);
		
	    int totalCount = service.getTotalCount(map);
	    
	    PageDto paging = new PageDto(page, totalCount, 8, 10);
	    
	    //페이징정보
	    map.put("begin", paging.getBegin() + "");
	    map.put("end", paging.getEnd() + "");
	    
	    //목록조회
	    List<AuctionDto> list = service.list(map);

	    model.addAttribute("list", list);
	    model.addAttribute("paging", paging);
	    model.addAttribute("word", word);
	    model.addAttribute("status", status);
	    
	    return "auction/auction-list";
	}
	
}

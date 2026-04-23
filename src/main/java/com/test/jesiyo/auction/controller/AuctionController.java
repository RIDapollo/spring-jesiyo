package com.test.jesiyo.auction.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.test.jesiyo.auction.dto.AuctionDto;
import com.test.jesiyo.auction.service.AuctionService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AuctionController {
	
	private final AuctionService service;
	
	@GetMapping(value = "/auction.do")
	public String action(Model model) {
		
		List<AuctionDto> list = service.list();
		
		model.addAttribute("list", list);
		
		return "auction/auction-list";
	}
	
}

package com.test.jesiyo.auction.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.test.jesiyo.auction.dto.AuctionDto;
import com.test.jesiyo.auction.dto.MemberDto;
import com.test.jesiyo.auction.service.AuctionService;
import com.test.jesiyo.pagination.PageDto;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AuctionController {
	
	private final AuctionService service;
	
	@GetMapping(value = "/auction")
	public String auction(Model model, 
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
	
	@GetMapping(value = "/auction/add")
	public String add() {
		
		return "auction/auction-add";		
	}
		
	@PostMapping(value = "/auction")
	public String add(AuctionDto dto, MultipartFile imageFile, HttpServletRequest req) {
	    
	    String path = req.getServletContext().getRealPath("/resources/image");
	    
	    try {
	        if (imageFile != null && !imageFile.isEmpty()) {
	            String fileName = imageFile.getOriginalFilename();
	            String saveName = UUID.randomUUID().toString() + "_" + fileName;
	            
	            File saveFile = new File(path + "/" + saveName);
	            imageFile.transferTo(saveFile);
	            
	            dto.setImage(saveName); 
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    //임시멤버dto
	    MemberDto mdto = service.getMdto(1);
	    
	    HashMap<String, Object> map = new HashMap<String, Object>();
	    map.put("dto", dto);
	    map.put("mdto", mdto);
	    
	    service.add(map);
	    
	    return "redirect:/auction";
	}
	
}

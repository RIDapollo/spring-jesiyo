package com.test.jesiyo.auction.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.test.jesiyo.auction.dto.AuctionDto;
import com.test.jesiyo.auction.dto.BidDto;
import com.test.jesiyo.auction.service.AuctionService;
import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.pagination.PageDto;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AuctionController {
	
	private final AuctionService service;
	
	//목록조회+검색목록조회
	@GetMapping(value = "/auction")
	public String auction(Model model, 
			@RequestParam(required = false, defaultValue = "") String word,
			@RequestParam(required = false, defaultValue = "1") int page) {
		
		HashMap<String, String> map = new HashMap<>();
		
		//검색정보
		if(!word.trim().isEmpty()) {
			map.put("word", word);
		}
		
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
	    
	    return "auction/auction-list";
	}
	
	
	//등록화면
	@GetMapping(value = "/auction/add")
	public String add() {
		
		return "auction/auction-add";		
	}
	
	//상세화면
	@GetMapping(value = "/auction/{seq}")
	public String detail(@PathVariable("seq") int seq, Model model, HttpSession session) {
		
		MemberDto mdto = (MemberDto) session.getAttribute("loginUser");
	    
		AuctionDto dto = service.getDetail(seq);
		
		AuctionDto dtoHasHighestBid = service.getHighestBid(seq);
		
		//최근입찰조회
	    List<BidDto> latestBids = service.getLatestBids(seq);
		
		model.addAttribute("dto", dto);
		model.addAttribute("dtoHasHighestBid", dtoHasHighestBid);
		model.addAttribute("latestBids", latestBids);
		
	    return "auction/auction-detail";
	}
	
	//등록
	@PostMapping(value = "/auction")
	public String add(AuctionDto dto, MultipartFile imageFile, HttpServletRequest req, HttpSession session) {
	    
		MemberDto mdto = (MemberDto) session.getAttribute("loginUser");
		
		String path = "C:/dev/upload";
	    
	    try {
	        if (imageFile != null && !imageFile.isEmpty()) {
	        	
	        	File folder = new File(path);
	        	if (!folder.exists()) {
	                folder.mkdirs();
	            }
	        	
	            String fileName = imageFile.getOriginalFilename();
	            String saveName = UUID.randomUUID().toString();
	            
	            File saveFile = new File(path + "/" + saveName);
	            imageFile.transferTo(saveFile);
	            
	            dto.setImage(saveName);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    HashMap<String, Object> map = new HashMap<String, Object>();
	    map.put("dto", dto);
	    map.put("mdto", mdto);
	    
	    service.add(map);
	    
	    return "redirect:/auction";
	}
	
	//입찰
	@PostMapping(value = "/auction/bid")
	@ResponseBody
	public Map<String, Object> bid(@RequestBody Map<String, Object> map, HttpSession session) {
		
		Map<String, Object> result = new HashMap<>();
		
		MemberDto mdto = (MemberDto) session.getAttribute("loginUser");
		
		int seq = Integer.parseInt(map.get("seq").toString());
	    int bidPrice = Integer.parseInt(map.get("bidPrice").toString());
	    
	    Map<String, Object> paramMap = new HashMap<>();
	    
	    paramMap.put("seq", seq);
	    paramMap.put("bidPrice", bidPrice);
	    paramMap.put("memberSeq", 1); //임시 membderDto에 seq 추가되면 변경예정
	    
	    return service.placeBid(paramMap); //최근목록5개, 최고가 포함 auctionDto객체 보유
	}
	
}

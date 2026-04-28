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
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

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
			@RequestParam(required = false, defaultValue = "1") int page,
			HttpSession session) {
		
		HashMap<String, String> map = new HashMap<>();
		
		MemberDto mdto = (MemberDto) session.getAttribute("user");
	    if (mdto != null) {
	        map.put("memberSeq", String.valueOf(mdto.getSeq()));
	    } else {
	    	//로그인 아닌경우 에러방지
	        map.put("memberSeq", "0"); 
	    }
		
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
		
		MemberDto mdto = (MemberDto) session.getAttribute("user");
	    
		AuctionDto dto = service.getDetail(seq);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("seq", seq);
		
		BidDto bdto = null;
		
		if(mdto != null) {
			map.put("memberSeq", mdto.getSeq());
			bdto = service.getMyBid(map);
		}
		
		AuctionDto dtoHasHighestBid = service.getHighestBid(seq);
		
		//최근입찰조회
	    List<BidDto> latestBids = service.getLatestBids(seq);
		
		model.addAttribute("dto", dto);
		model.addAttribute("dtoHasHighestBid", dtoHasHighestBid);
		model.addAttribute("latestBids", latestBids);
		model.addAttribute("bdto", bdto);
		
	    return "auction/auction-detail";
	}
	
	//경매 등록
	@PostMapping(value = "/auction")
	public String add(AuctionDto dto, MultipartFile imageFile, HttpServletRequest req, HttpSession session) {
	    
		MemberDto mdto = (MemberDto) session.getAttribute("user");
		
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
		
		MemberDto mdto = (MemberDto) session.getAttribute("user");
		
		int seq = Integer.parseInt(map.get("seq").toString());
	    int bidPrice = Integer.parseInt(map.get("bidPrice").toString());
	    
	    Map<String, Object> paramMap = new HashMap<>();
	    
	    paramMap.put("seq", seq);
	    paramMap.put("bidPrice", bidPrice);
	    paramMap.put("memberSeq", mdto.getSeq());
	    
	    return service.placeBid(paramMap); //최근목록5개, 최고가 포함 auctionDto객체 보유
	}
	
	//경매 삭제
	@DeleteMapping(value = "auction/{seq}")
	@ResponseBody
	public Map<String, Object> delete(@PathVariable("seq") int seq, HttpSession session) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		MemberDto mdto = (MemberDto) session.getAttribute("user");
		
		if (mdto == null) {
	        result.put("status", "fail");
	        result.put("msg", "세션이 만료되었습니다. 다시 로그인해주세요.");
	        return result;
	    }
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("seq", seq);
		paramMap.put("memberSeq", mdto.getSeq());
		
		int delResult = service.cancelAuctionIfHasNoBids(paramMap);
		
		if(delResult > 0) {
			result.put("status", "success");
		} else {
			result.put("status", "fail");
			result.put("msg", "현재 입찰이 진행 중인 경매는 취소할 수 없습니다.");
		}
		
		return result;
	}
	
	// 실시간 데이터 갱신용 API (화면 렌더링 없이 JSON 데이터만 반환)
	@GetMapping(value = "/auction/api/latest/{seq}")
	@ResponseBody
	public Map<String, Object> getLatestAuctionData(@PathVariable("seq") int seq) {
		
	    Map<String, Object> result = new HashMap<>();
	    
	    // 최고가 조회
	    result.put("dtoHasHighestBid", service.getHighestBid(seq));
	    // 최근 입찰 기록
	    result.put("latestBids", service.getLatestBids(seq));
	    
	    return result;
	}
	
	//내 일반 경매 목록 화면
	@GetMapping(value = "/auction/myList")
	public String myAuctionList(Model model, HttpSession session,
			@RequestParam(required = false, defaultValue = "1") int page) {
		
		MemberDto mdto = (MemberDto) session.getAttribute("user");
		
		// 세션 만료 시 로그인 페이지로 리다이렉트
		if (mdto == null) {
			return "redirect:/member/login"; 
		}
		
		HashMap<String, String> map = new HashMap<>();
		map.put("memberSeq", String.valueOf(mdto.getSeq()));
		
		// 내가 등록한 경매 총 개수
		int totalCount = service.getMyAuctionTotalCount(map); 
		PageDto paging = new PageDto(page, totalCount, 8, 10);
		
		map.put("begin", paging.getBegin() + "");
		map.put("end", paging.getEnd() + "");
		
		// 내가 등록한 경매 목록 조회 (서비스/매퍼에 메서드 추가 필요)
		List<AuctionDto> list = service.getMyAuctionList(map); 

		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		
		return "auction/auction-myList";
	}

	// 2. 내 입찰 목록 화면
	@GetMapping(value = "/auction/myBidList")
	public String myBidList(Model model, HttpSession session,
			@RequestParam(required = false, defaultValue = "1") int page) {
		
		MemberDto mdto = (MemberDto) session.getAttribute("user");
		
		if (mdto == null) {
			return "redirect:/member/login";
		}
		
		HashMap<String, String> map = new HashMap<>();
		map.put("memberSeq", String.valueOf(mdto.getSeq()));
		
		// 내가 입찰한 경매 총 개수
		int totalCount = service.getMyBidTotalCount(map); 
		PageDto paging = new PageDto(page, totalCount, 8, 10);
		
		map.put("begin", paging.getBegin() + "");
		map.put("end", paging.getEnd() + "");
		
		// 내가 입찰한 목록 조회 (AuctionDto 안에 myBidPrice, highestBid 등 매핑 필요)
		List<AuctionDto> list = service.getMyBidList(map); 
		
		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		
		return "auction/auction-myBidList";
	}
	
	// 일반 경매 즉시 낙찰 (조기 종료 및 포인트 정산)
	@PostMapping(value = "/auction/{seq}/end")
	@ResponseBody
	public Map<String, Object> endAuctionEarly(@PathVariable("seq") int seq, HttpSession session) {
		
		Map<String, Object> result = new HashMap<>();
		
		// 1. 로그인 세션 확인
		MemberDto mdto = (MemberDto) session.getAttribute("user");
		if (mdto == null) {
			result.put("status", "fail");
			result.put("msg", "세션이 만료되었습니다. 다시 로그인해주세요.");
			return result;
		}
		
		// 2. 서비스 계층으로 넘길 파라미터 세팅
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("seq", seq);
		paramMap.put("memberSeq", mdto.getSeq()); // 쿼리에서 판매자 본인인지 검증하기 위해 필요
		
		try {
			// 3. 트랜잭션이 적용된 비즈니스 로직 호출
			// 서비스 단에서 성공/실패 여부에 따라 status와 msg를 담아 반환하도록 설계됨
			result = service.endAuctionEarlyWithPoint(paramMap);
			
		} catch (Exception e) {
			// 서비스 단에서 트랜잭션 롤백을 위해 발생시킨 예외를 캐치
			e.printStackTrace();
			result.put("status", "error");
			result.put("msg", "포인트 정산 중 서버 오류가 발생했습니다. 관리자에게 문의하세요.");
		}
		
		return result;
	}
	
}

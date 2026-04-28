package com.test.jesiyo.directsale.api;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.test.jesiyo.directsale.dto.DirectSaleDto;
import com.test.jesiyo.directsale.dto.DirectSaleSearchDto;
import com.test.jesiyo.directsale.service.DirectSaleService;
import com.test.jesiyo.member.dto.MemberDto;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class DirectSaleApi {

	private final DirectSaleService service;
	
	@PostMapping("/direct-sales")
	public List<DirectSaleDto> getList(@RequestBody DirectSaleSearchDto dto, HttpSession session) {
		
		if (dto.getPage() == 0 || dto.getPage() < 0) {
	        dto.setPage(0);
	    }
		
		MemberDto loginMember = (MemberDto) session.getAttribute("user");

	    if (loginMember != null) {
	        dto.setMemberSeq(Long.parseLong(loginMember.getSeq()));
	    }
		
	    List<DirectSaleDto> list = service.search(dto);
	    
	    return list;
	}
	
    // 삭제 (실제 DELETE가 아니라 status 변경)
	@DeleteMapping("/direct-sales/{seq}")
	public ResponseEntity<Void> deleteDirectSale(@PathVariable("seq") Long seq) {

		int result = service.deleteByStatus(seq);

		if (result == 1) {
	        return ResponseEntity.ok().build(); // 성공
	    } else {
	        return ResponseEntity.notFound().build(); // 데이터 없음 or 실패
	    }
    }
}

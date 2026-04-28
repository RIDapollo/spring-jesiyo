package com.test.jesiyo.location.api;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.test.jesiyo.location.dto.LocationDto;
import com.test.jesiyo.location.dto.TradeLocationDto;
import com.test.jesiyo.location.service.LocationService;
import com.test.jesiyo.location.service.TradeLocationService;
import com.test.jesiyo.member.dto.MemberDto;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class LocationApi {

	private final LocationService locationService;
	private final TradeLocationService tradeLocationService;
	
	// 새로운 동네면 동네 DB저장, 있는 곳이면 조회만
	// 조회 후 회원정보에 동네정보 저장
	@PostMapping("/member/location")
	public ResponseEntity<LocationDto> setMemberLocation(@RequestBody LocationDto dto, HttpSession session) {

		MemberDto loginMember = (MemberDto) session.getAttribute("user");
		
		LocationDto location = locationService.addOrGet(dto);
		// 기존 동네 정보 있으면 삭제후 선택한 것 insert
		locationService.updateMemberLocation(loginMember.getSeq(), location.getSeq());
		
		return ResponseEntity.ok(location);
	}
	
	@PostMapping("/trade-locations")
	public ResponseEntity<TradeLocationDto> getTradeLocationSeq(@RequestBody TradeLocationDto dto) {
		
		tradeLocationService.add(dto);
		
		// TODO 나중에 add 오류시 분기 필요
		TradeLocationDto findDto = tradeLocationService.findBySeq(dto.getSeq());
//		TradeLocationDto findDto = tradeLocationService.findByDong(dto.getDong());
		
		
		
		return ResponseEntity.ok(findDto);
	}
}

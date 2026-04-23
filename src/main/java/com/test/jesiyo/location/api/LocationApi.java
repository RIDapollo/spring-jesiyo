package com.test.jesiyo.location.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.test.jesiyo.location.dto.LocationDto;
import com.test.jesiyo.location.service.LocationService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class LocationApi {

	private final LocationService locationService;
	
	// 새로운 동네면 동네 DB저장, 있는 곳이면 조회만
	// 조회 후 회원정보에 동네정보 저장
	@PostMapping("/location/member")
	public ResponseEntity<LocationDto> setMemberLocation(@RequestBody LocationDto dto) {

		LocationDto result = locationService.addOrGet(dto);
		// 나중에 memberSeq 를 PathVariable로 받아서 처리해야 함!
//		memberService.updateLocation(memberSeq, dto.getSeq());
		
		return ResponseEntity.ok(result);
	}
}

package com.test.jesiyo.location.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.test.jesiyo.location.dto.LocationDto;
import com.test.jesiyo.location.repository.LocationDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class LocationService {

	private final LocationDao dao;
	
	public LocationDto addOrGet(LocationDto dto) {

		LocationDto findDto = dao.findByDong(dto.getDong());

		// 동이름이 이미 있으면 해당 정보 반환
	    if (findDto != null) {
	        return findDto;
	    }

	    // 동이름이 없으면 DB저장 후 정보 반환
	    dao.add(dto);
	    return dao.findByDong(dto.getDong());
	}

	@Transactional
	public void updateMemberLocation(String memberSeq, String locationSeq) {
		dao.deleteMemberLocation(memberSeq);
	    dao.insertMemberLocation(memberSeq, locationSeq);
	}
}

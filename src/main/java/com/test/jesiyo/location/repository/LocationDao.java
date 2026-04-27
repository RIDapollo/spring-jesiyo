package com.test.jesiyo.location.repository;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.location.dto.LocationDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class LocationDao {

	private final SqlSessionTemplate template;
	
	public int add(LocationDto dto) {
		
		int result = template.insert("location.add", dto);
		return result;
	}
	
	public LocationDto findBySeq(String seq) {
		
		LocationDto dto = template.selectOne("location.findBySeq", seq);
		return dto;
	}
	
	public LocationDto findByDong(String dong) {
		
		LocationDto dto = template.selectOne("location.findByDong", dong);
		return dto;
	}

	public int deleteMemberLocation(String memberSeq) {
        return template.delete("location.deleteMemberLocation", memberSeq);
    }

    public int insertMemberLocation(String memberSeq, String locationSeq) {
        Map<String, String> param = new HashMap<>();
        param.put("memberSeq", memberSeq);
        param.put("locationSeq", locationSeq);

        return template.insert("location.insertMemberLocation", param);
    }
}

package com.test.jesiyo.category.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.test.jesiyo.category.dto.CategoryDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CategoryDao {

	private final SqlSessionTemplate template;

	public CategoryDto findBySeq(int seq) {
		return template.selectOne("category.findBySeq", seq);
	}
	
	public CategoryDto findByName(String name) {
		CategoryDto dto = template.selectOne("category.findByName", name);
		 return dto;
	}

	public int add(CategoryDto dto) {
		return template.insert("category.add", dto);
	}
	
	public int del(int seq) {
		return template.delete("category.del", seq);
	}

	public List<CategoryDto> findChildren(int parentSeq) {
		return template.selectList("category.findChildren", parentSeq);
	}
	
	public List<CategoryDto> findRoots() {
	    return template.selectList("category.findRoots");
	}
}

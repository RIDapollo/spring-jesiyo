package com.test.jesiyo.category.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Service;

import com.test.jesiyo.category.dto.CategoryDto;
import com.test.jesiyo.category.repository.CategoryDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CategoryService {

	private final CategoryDao dao;
	
	public CategoryDto findBySeq(int seq) {
		return dao.findBySeq(seq);
	}
	
	public List<CategoryDto> getCategoryPath(int seq) {
		
		List<CategoryDto> path = new ArrayList<>();
		CategoryDto current = dao.findBySeq(seq);
		if (current == null) {
		    return path;
		}
		while (current != null) {

		    path.add(current);
		    if (current.getParentSeq() == 0) {
		        break;
		    }
		    current = dao.findBySeq(current.getParentSeq());
		}
		
		Collections.reverse(path);
		return path;
	}
	
	public CategoryDto findByName(String name) {
		return dao.findByName(name);
	}
	
	public int add(CategoryDto dto) {
		return dao.add(dto);
	}
	
	public int del(int seq) {
		return dao.del(seq);
	}
	
	public List<CategoryDto> findChildren(int parentSeq) {
		return dao.findChildren(parentSeq);
	}
	
	public List<CategoryDto> findRoots() {
	    return dao.findRoots();
	}
	
	public List<CategoryDto> findAll() {
	    return dao.findAll();
	}
}

package com.test.jesiyo.category.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	// 카테고리 조회용 트리구조 구하기
	public List<CategoryDto> getCategoryTree() {

	    List<CategoryDto> all = dao.findAll();

	    Map<Long, CategoryDto> map = new HashMap<>();
	    List<CategoryDto> roots = new ArrayList<>();

	    for (CategoryDto c : all) {
	        map.put(c.getSeq(), c);
	    }

	    for (CategoryDto c : all) {
	        if (c.getParentSeq() == 0) {
	            roots.add(c); // 대분류
	        } else {
	            CategoryDto parent = map.get((long) c.getParentSeq());
	            if (parent != null) {
	                parent.getChildren().add(c);
	            }
	        }
	    }
	    return roots;
	}

}

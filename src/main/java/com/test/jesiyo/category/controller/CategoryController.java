package com.test.jesiyo.category.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.test.jesiyo.category.dto.CategoryDto;
import com.test.jesiyo.category.service.CategoryService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CategoryController {

	private final CategoryService service;
	
	// 1. 단건 조회 (seq)
    @GetMapping("/categories/{seq}")
    @ResponseBody
    public CategoryDto getBySeq(@PathVariable int seq) {
        return service.findBySeq(seq);
    }

    // 2. 이름 조회
    @GetMapping("/categories-name/{name}")
    @ResponseBody
    public CategoryDto getByName(@PathVariable(value = "name") String name) {
        return service.findByName(name);
    }

    // 3. 카테고리 경로 조회 (breadcrumb)
    @GetMapping("/categories/{seq}/path")
    @ResponseBody
    public List<CategoryDto> getPath(@PathVariable int seq) {
        return service.getCategoryPath(seq);
    }

    // 4. 등록 테스트
    @PostMapping("/categories")
    @ResponseBody
    public int add(@RequestBody CategoryDto dto) {
        return service.add(dto);
    }

    // 5. 삭제 테스트
    @DeleteMapping("/categories/{seq}")
    @ResponseBody
    public int delete(@PathVariable int seq) {
        return service.del(seq);
    }
    
    @GetMapping("/categories/roots")
    @ResponseBody
    public List<CategoryDto> getRoots() {
        return service.findRoots();
    }
    
    @GetMapping("/categories/{seq}/children")
    @ResponseBody
    public List<CategoryDto> getChildren(@PathVariable int seq) {
    	return service.findChildren(1);
    }
}

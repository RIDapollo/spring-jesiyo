package com.test.jesiyo.category.api;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.test.jesiyo.category.dto.CategoryDto;
import com.test.jesiyo.category.service.CategoryService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class CategoryApi {

	private final CategoryService service;
	
	// ROOT 카테고리
    @GetMapping("/roots")
    public List<CategoryDto> getRoots() {
        return service.findRoots();
    }

    // 하위 카테고리
    @GetMapping("/categories/{parentSeq}/children")
    public List<CategoryDto> getChildren(@PathVariable int parentSeq) {
        return service.findChildren(parentSeq);
    }
}

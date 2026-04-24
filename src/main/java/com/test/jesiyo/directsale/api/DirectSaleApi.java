package com.test.jesiyo.directsale.api;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.test.jesiyo.directsale.dto.DirectSaleDto;
import com.test.jesiyo.directsale.service.DirectSaleService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class DirectSaleApi {

	private final DirectSaleService service;
	
	@GetMapping("/direct-sales")
    public List<DirectSaleDto> getList(
            @RequestParam(defaultValue = "0") int page) {
        return service.getListByPage(page);
    }
}

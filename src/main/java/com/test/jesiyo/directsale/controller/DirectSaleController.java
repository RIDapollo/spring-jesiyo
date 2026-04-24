package com.test.jesiyo.directsale.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.test.jesiyo.category.dto.CategoryDto;
import com.test.jesiyo.category.service.CategoryService;
import com.test.jesiyo.directsale.dto.DirectSaleDto;
import com.test.jesiyo.directsale.service.DirectSaleService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class DirectSaleController {

	private final DirectSaleService directSaleService;
	private final CategoryService categoryService;
	
	@GetMapping("/directsales")
    public String list(Model model) {

        List<DirectSaleDto> list = directSaleService.findAll();
        model.addAttribute("list", list);

        return "/directsales/list";
    }
	
	@GetMapping("/directsales/{seq}")
    public String detail(@PathVariable Long seq, Model model) {

        DirectSaleDto dto = directSaleService.findBySeq(seq);
        model.addAttribute("dto", dto);

        return "/directsales/detail";
    }
	
	@GetMapping("/directsales/new")
	public String getAddPage(Model model, HttpSession session) {

		// TODO 로그인 구현 후 주석 풀어야 함
//		Long memberSeq = (Long) session.getAttribute("memberSeq");
//		model.addAttribute("memberSeq", memberSeq);
		
		List<CategoryDto> roots = categoryService.findRoots();
		model.addAttribute("roots", roots);
		
		return "/directsales/add";
	}
	
	@PostMapping("/directsales")
	public String getAddPage(@ModelAttribute DirectSaleDto dto,
							 @RequestParam("imageFile") MultipartFile imageFile) {

//	    String imageUrl = fileService.upload(imageFile);
		String imageUrl = "test";
		dto.setImageUrl(imageUrl);
		
		DirectSaleDto result = directSaleService.add(dto);
		
		return "redirect:/directsales/";
	}
	
	@GetMapping("/directsales/{seq}/edit")
    public String editPage(@PathVariable Long seq, Model model) {

        DirectSaleDto dto = directSaleService.findBySeq(seq);
        model.addAttribute("dto", dto);

        return "/directsales/edit";
    }
	
	@PutMapping("/directsales/{seq}/edit")
    public String edit(@PathVariable Long seq, DirectSaleDto dto) {

        dto.setSeq(seq);
        directSaleService.update(dto);

        return "redirect:/directsales/" + seq;
    }
}

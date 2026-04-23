package com.test.jesiyo.directsale.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.test.jesiyo.directsale.dto.DirectSaleDto;
import com.test.jesiyo.directsale.service.DirectSaleService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class DirectSaleController {

	private final DirectSaleService directSaleService;
	
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

		Long memberSeq = (Long) session.getAttribute("memberSeq");
		model.addAttribute("memberSeq", memberSeq);
		
		return "/directsales/add";
	}
	
	@PostMapping("/directsales")
	public String getAddPage(@RequestBody DirectSaleDto dto) {

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

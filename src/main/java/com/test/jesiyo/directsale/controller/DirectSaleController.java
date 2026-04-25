package com.test.jesiyo.directsale.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

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
	
	@GetMapping("/direct-sales")
    public String list(Model model) {

		int page = 0;
	    int pageSize = 12;
		
        List<DirectSaleDto> list = directSaleService.getListByPage(page);
        model.addAttribute("list", list);
        
        return "/direct-sales/list";
    }
	
	@GetMapping("/direct-sales/{seq}")
    public String detail(@PathVariable("seq") Long seq, Model model) {

        DirectSaleDto dto = directSaleService.getDetail(seq);
        model.addAttribute("dto", dto);

        return "/direct-sales/detail";
    }
	
	@GetMapping("/direct-sales/new")
	public String getAddPage(Model model, HttpSession session) {

		// TODO 로그인 구현 후 주석 풀어야 함
//		Long memberSeq = (Long) session.getAttribute("memberSeq");
//		model.addAttribute("memberSeq", memberSeq);
		model.addAttribute("sellerSeq", "1");
		
		List<CategoryDto> roots = categoryService.findRoots();
		model.addAttribute("roots", roots);
		
		
		return "/direct-sales/add";
	}
	
	@PostMapping("/direct-sales")
	public String getAddPage(@ModelAttribute DirectSaleDto dto,
							 @RequestParam("imageFile") MultipartFile imageFile) {

		String uploadPath = "C:/dev/upload";

		// 사진파일 경로로 바꾸기
		try {
		    if (imageFile != null && !imageFile.isEmpty()) {

		        // 1. 폴더 없으면 생성
		        File folder = new File(uploadPath);
		        if (!folder.exists()) {
		            folder.mkdirs();
		        }

		        // 2. 원본 파일명 + 확장자 추출
		        String originalName = imageFile.getOriginalFilename();
		        String ext = "";

		        if (originalName != null && originalName.contains(".")) {
		            ext = originalName.substring(originalName.lastIndexOf("."));
		        }

		        // 3. UUID 파일명 생성
		        String saveName = UUID.randomUUID().toString() + ext;

		        // 4. 실제 파일 저장
		        File saveFile = new File(uploadPath, saveName);
		        imageFile.transferTo(saveFile);

		        // 5. DB에는 URL 저장 (핵심)
		        String imageUrl = "/upload/" + saveName;
		        dto.setImageUrl(imageUrl);
		    }
		} catch (Exception e) {
		    e.printStackTrace();
		}
		directSaleService.add(dto);
		
		return "redirect:/direct-sales";
	}
	
	@GetMapping("/direct-sales/{seq}/edit")
    public String editPage(@PathVariable Long seq, Model model) {

        DirectSaleDto dto = directSaleService.findBySeq(seq);
        model.addAttribute("dto", dto);

        return "/direct-sales/edit";
    }
	
	@PutMapping("/direct-sales/{seq}/edit")
    public String edit(@PathVariable Long seq, DirectSaleDto dto) {

        dto.setSeq(seq);
        directSaleService.update(dto);

        return "redirect:/direct-sales/" + seq;
    }
}

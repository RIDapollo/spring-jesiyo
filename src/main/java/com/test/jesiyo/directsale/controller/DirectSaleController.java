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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.test.jesiyo.category.dto.CategoryDto;
import com.test.jesiyo.category.service.CategoryService;
import com.test.jesiyo.directsale.dto.DirectSaleDto;
import com.test.jesiyo.directsale.dto.DirectSaleSearchDto;
import com.test.jesiyo.directsale.service.DirectSaleService;
import com.test.jesiyo.location.dto.LocationDto;
import com.test.jesiyo.location.service.LocationService;
import com.test.jesiyo.member.dto.MemberDto;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class DirectSaleController {

	private final DirectSaleService directSaleService;
	private final CategoryService categoryService;
	private final LocationService locationService;
	
	@GetMapping("/direct-sales")
	public String list(DirectSaleSearchDto dto, Model model,
						HttpSession session) {

	    int page = 0;

	    // 카테고리 트리는 항상 필요
	    List<CategoryDto> categoryTree = categoryService.getCategoryTree();
	    
	    boolean hasLocationFilter = false;
	    
	    // 회원 정보 SearchDto 에 넣어주기
	    MemberDto loginMember = (MemberDto) session.getAttribute("user");
	    if (loginMember != null) {
	    	dto.setMemberSeq(Long.parseLong(loginMember.getSeq()));
	    	
	    	LocationDto location = locationService
	                .selectMainLocationByMember(dto.getMemberSeq());

	        hasLocationFilter = (location != null);
	        model.addAttribute("hasLocationFilter", hasLocationFilter);
	    }

	    // 초기 데이터 (필터 적용된 상태)
	    dto.setPage(page);
	    List<DirectSaleDto> list = directSaleService.search(dto);

	    model.addAttribute("categoryTree", categoryTree);
	    model.addAttribute("list", list);

	    // 프론트에서도 쓰게 넘김
	    model.addAttribute("initFilter", dto);

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

        DirectSaleDto dto = directSaleService.getDetail(seq);
        List<CategoryDto> roots = categoryService.findRoots();
		model.addAttribute("roots", roots);
        model.addAttribute("dto", dto);

        return "/direct-sales/edit";
    }
	
	@PostMapping("/direct-sales/{seq}")
    public String edit(@PathVariable("seq") Long seq, DirectSaleDto dto,
    					RedirectAttributes rttr,
    					@RequestParam("imageFile") MultipartFile imageFile) {
		

        dto.setSeq(seq);
        
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
        
        int result = directSaleService.update(dto);
        
        if (result == 0) {
            rttr.addFlashAttribute("error", true);
            return "redirect:/direct-sales/" + seq + "/edit";
        }

        return "redirect:/direct-sales/" + seq;
    }
}

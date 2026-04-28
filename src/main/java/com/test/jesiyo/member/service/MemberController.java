package com.test.jesiyo.member.service;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller; // 추가
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping; // 추가
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.test.jesiyo.category.dto.CategoryDto;
import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.member.repository.MemberDao;
import com.test.jesiyo.member.dto.WishDto;

@Controller // 1. 스프링이 컨트롤러임을 인식하도록 추가
@RequestMapping("/member") // 2. 공통 경로 설정
public class MemberController {
	
    @Autowired // 3. 필드 주입은 변수 바로 위에!
    private MemberDao dao;

    // 4. @GetMapping은 실행될 '메서드' 바로 위에 작성해야 합니다.
    @GetMapping("/mypage")
    public String mypage(Principal principal, Model model) {
	    
        if (principal == null) {
            return "redirect:/login/login";
        }
        
        String userId = principal.getName();
        MemberDto member = dao.getMember(userId);
        
        model.addAttribute("member", member);
        
        return "mypage/mypage";
    }
    
    @GetMapping("/wishlist")
    public String wishlist(Principal principal, Model model) {
        String userId = principal.getName();
        MemberDto member = dao.getMember(userId);
        
        List<WishDto> wishList = dao.getWishList(member.getSeq());
        
        model.addAttribute("wishList", wishList);
        return "wishlist/wishlist";
    }
    
    @GetMapping("/deleteWish")
    public String deleteWish(@RequestParam String seq) {
        dao.deleteWish(seq);
        // [수정] 리다이렉트 경로에 /member 추가
        return "redirect:/member/wishlist"; 
    }

    @GetMapping("/addWish")
    public String addWishForm(Principal principal, Model model) {
        // 1. DB에서 모든 카테고리를 평면 리스트로 가져옵니다 (대/중/소 전체).
        List<CategoryDto> allCategories = dao.getCategoryList();
        
        // 2. 빠른 검색을 위한 Map과 최상위 대분류를 담을 리스트를 준비합니다.
        Map<Long, CategoryDto> categoryMap = new HashMap<>();
        List<CategoryDto> rootCategories = new ArrayList<>();

        // 3. 먼저 모든 데이터를 Map에 담아 인덱싱합니다.
        for (CategoryDto dto : allCategories) {
            categoryMap.put(dto.getSeq(), dto);
            // parentSeq가 0인 것만 대분류 리스트에 따로 모읍니다.
            if (dto.getParentSeq() == 0) {
                rootCategories.add(dto); 
            }
        }

        // 4. [핵심] 자식 항목(중/소분류)을 찾아 부모 객체의 children 리스트에 직접 넣어줍니다.
        for (CategoryDto dto : allCategories) {
            if (dto.getParentSeq() != 0) {
                CategoryDto parent = categoryMap.get((long)dto.getParentSeq());
                if (parent != null) {
                    // 부모 객체 내부의 children 리스트에 자기 자신을 추가합니다.
                    parent.getChildren().add(dto);
                }
            }
        }

        ObjectMapper mapper = new ObjectMapper();
        try {
            // JSP의 c:forEach에는 대분류만 담긴 rootCategories를 보냅니다. [cite: 425]
            model.addAttribute("categoryList", rootCategories); 
            // 자바스크립트용 JSON도 계층 구조가 완성된 데이터를 변환하여 보냅니다. [cite: 374, 432]
            model.addAttribute("categoryJson", mapper.writeValueAsString(rootCategories));
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "wishlist/addWish";
    }
    
    @PostMapping("/addWish")
    public String addWishProc(Principal principal, @RequestParam String cateSeq) {
        String userId = principal.getName();
        MemberDto member = dao.getMember(userId);
        
        Map<String, String> map = new HashMap<String, String>();
        map.put("memberSeq", member.getSeq());
        map.put("cateSeq", cateSeq);
        
        dao.addInterest(map);
        // [수정] 리다이렉트 경로에 /member 추가
        return "redirect:/member/wishlist";
    }
}
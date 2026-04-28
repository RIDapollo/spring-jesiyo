package com.test.jesiyo.member.service;

import java.security.Principal;
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
        
        // 사용자의 seq를 포함한 회원 정보를 가져옵니다.
        MemberDto member = dao.getMember(userId);
        
        // 관심 목록 조회 (중고거래/경매 테이블과 조인된 데이터)
        List<WishDto> wishList = dao.getWishList(member.getSeq());
        
        model.addAttribute("wishList", wishList);
        return "member/wishlist";
    }
    
    @GetMapping("/deleteWish")
    public String deleteWish(@RequestParam String seq) {
        // 관심 목록 삭제 처리
        dao.deleteWish(seq);
        return "redirect:/member/wishlist";
    }

    @GetMapping("/addWish")
    public String addWishForm(Principal principal, Model model) {
        String userId = principal.getName();
        MemberDto member = dao.getMember(userId);
        
        // 전체 카테고리 목록 가져오기
        List<CategoryDto> allCategories = dao.getCategoryList();
        // 현재 사용자가 이미 등록한 관심 목록 가져오기 (중복 방지용)
        List<WishDto> currentInterests = dao.getWishList(member.getSeq());
        
        model.addAttribute("allCategories", allCategories);
        model.addAttribute("currentInterests", currentInterests);
        return "member/addWish";
    }
    
    @PostMapping("/addWish")
    public String addWishProc(Principal principal, @RequestParam String cateSeq) {
        String userId = principal.getName();
        MemberDto member = dao.getMember(userId);
        
        Map<String, String> map = new HashMap<String, String>();
        map.put("memberSeq", member.getSeq());
        map.put("cateSeq", cateSeq);
        
        dao.addInterest(map);
        return "redirect:/member/wishlist";
    }
}
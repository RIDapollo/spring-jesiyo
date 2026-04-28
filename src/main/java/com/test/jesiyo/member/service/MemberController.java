package com.test.jesiyo.member.service;

import java.io.File;
import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller; // 추가
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping; // 추가
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.test.jesiyo.category.dto.CategoryDto;
import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.member.dto.WishDto;
import com.test.jesiyo.member.repository.MemberDao;

@Controller // 1. 스프링이 컨트롤러임을 인식하도록 추가
@RequestMapping("/member") // 2. 공통 경로 설정
public class MemberController {
	
    @Autowired // 3. 필드 주입은 변수 바로 위에!
    private MemberDao dao;
    
    @Autowired
    private BCryptPasswordEncoder passwordEncoder; // 암호화 확인용

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
    
    @GetMapping("/checkPw")
    public String checkPwForm() {
        return "mypage/checkPw"; // WEB-INF/views/member/checkPw.jsp
    }

    // 2. 비밀번호 일치 여부 확인 처리 (POST)
    @PostMapping("/checkPw")
    public String checkPwProc(Principal principal, @RequestParam String userPw, Model model) {
        String userId = principal.getName();
        MemberDto member = dao.getMember(userId); // 기존 getMemberById 활용 가능 [cite: 911, 920]

        // 입력한 비밀번호와 DB의 암호화된 비밀번호 비교 [cite: 658]
        if (passwordEncoder.matches(userPw, member.getUserPw())) {
            // 일치하면 실제 수정 페이지로 이동
            return "redirect:/member/editProfile"; 
        } else {
            // 불일치 시 에러 메시지와 함께 재시도
            model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
            return "mypage/checkPw";
        }
    }
    
    // 3. 실제 프로필 수정 페이지 (비밀번호 확인 통과 시 진입)
    @GetMapping("/editProfile")
    public String editProfileForm(Principal principal, Model model) {
        String userId = principal.getName();
        model.addAttribute("member", dao.getMember(userId));
        return "mypage/editProfile";
    }
    @PostMapping("/editProfile")
    public String editProfileProc(Principal principal, 
                                MemberDto updateDto, 
                                @RequestParam(value="profileImgFile", required=false) MultipartFile file) {
        
        String userId = principal.getName();
        MemberDto existingMember = dao.getMember(userId);
        
        // 1. 비밀번호 처리: 입력값이 있을 때만 암호화하여 수정 [cite: 1138, 1162]
        if (updateDto.getUserPw() != null && !updateDto.getUserPw().isEmpty()) {
            updateDto.setUserPw(passwordEncoder.encode(updateDto.getUserPw()));
        } else {
            updateDto.setUserPw(existingMember.getUserPw());
        }

        // 2. 이미지 업로드 처리
        String uploadPath = "C:/dev/upload/profile";
        if (file != null && !file.isEmpty()) {
            try {
                File folder = new File(uploadPath);
                if (!folder.exists()) folder.mkdirs();

                // UUID를 이용한 고유한 파일명 생성 
                String originalName = file.getOriginalFilename();
                String ext = originalName.substring(originalName.lastIndexOf("."));
                String savedName = UUID.randomUUID().toString() + ext;

                // 로컬 디스크에 파일 저장
                file.transferTo(new File(uploadPath + "/" + savedName));

                // DB 객체에는 파일명(savedName)만 저장
                updateDto.setProfileImg(savedName);
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // 이미지를 새로 올리지 않았다면 기존 파일명 유지
            updateDto.setProfileImg(existingMember.getProfileImg());
        }

        updateDto.setSeq(existingMember.getSeq());
        dao.updateMember(updateDto);

        return "redirect:/member/mypage";
    }
}
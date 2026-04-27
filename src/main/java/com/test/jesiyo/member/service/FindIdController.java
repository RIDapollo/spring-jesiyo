package com.test.jesiyo.member.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.test.jesiyo.member.repository.MemberDao;

@Controller
public class FindIdController {
	@Autowired
    private MemberDao memberDao;
	
	@GetMapping("/member/findId")
	public String findIdView() {
	    return "find/findId";
	}
	@PostMapping("/member/findId")
	public String findId(String email, Model model, RedirectAttributes rttr) {
	    // 1. DB에서 이메일로 사용자 아이디 조회
	    String fullId = memberDao.findIdByEmail(email); 

	    if (fullId != null && fullId.length() >= 4) {
	        // 2. 앞 4자리만 잘라서 모델에 담기
	        String maskedId = fullId.substring(0, 4);
	        model.addAttribute("foundId", maskedId);
	        return "find/findId"; // 결과 페이지 표시
	    } else {
	        // 3. 없을 경우 에러 메시지와 함께 리다이렉트
	        rttr.addAttribute("error", "true");
	        return "redirect:/find/findId";
	    }
	}

}

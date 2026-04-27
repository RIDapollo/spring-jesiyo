package com.test.jesiyo.trade.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.trade.dto.TradeDto;
import com.test.jesiyo.trade.service.TradeService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class TradeController {

	private final TradeService service;
	
	@GetMapping("/trades/list")
    public String tradeListPage(HttpSession session, Model model) {

        MemberDto loginMember = (MemberDto) session.getAttribute("user");

        if (loginMember == null) {
            return "redirect:/member/login";
        }

        Long memberSeq = Long.parseLong(loginMember.getSeq());

        // 최초 10개
        List<TradeDto> list = service.getTradeList(memberSeq, null);

        model.addAttribute("tradeList", list);

        // 마지막 seq (더보기용)
        Long lastSeq = list.isEmpty() ? null : list.get(list.size() - 1).getSeq();
        model.addAttribute("lastSeq", lastSeq);
        
        return "trades/list";
    }
}

package com.test.jesiyo.member.service;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.test.jesiyo.member.dto.MemberDto;
import com.test.jesiyo.member.repository.MemberDao;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class FindPwController {

    private final MemberDao memberDao;
    private final JavaMailSender mailSender;
    private final BCryptPasswordEncoder passwordEncoder;

    // 1. 비밀번호 찾기 폼 이동 (ID, Email 입력창)
    @GetMapping("/findPw")
    public String findPwForm() {
        return "find/findPw";
    }

    // 2. 비밀번호 재설정 메일 발송 요청
    @PostMapping("/findPw")
    public String findPw(@RequestParam String userId, @RequestParam String email, Model model) {
        
        Map<String, String> map = new HashMap<>();
        map.put("userId", userId);
        map.put("email", email);

        // 사용자가 존재하는지 확인
        int count = memberDao.checkMemberForPwReset(map);
        
        if (count > 0) {
            // 고유 토큰 생성
            String token = UUID.randomUUID().toString();
            
            // DB에 토큰과 만료시간 저장
            Map<String, Object> tokenMap = new HashMap<>();
            tokenMap.put("userId", userId);
            tokenMap.put("token", token);
            memberDao.updateResetToken(tokenMap);

            // 이메일 발송
            sendResetEmail(email, token);
            
            model.addAttribute("msg", "가입하신 이메일로 비밀번호 재설정 링크를 보냈습니다.");
        } else {
            model.addAttribute("error", "일치하는 회원 정보가 없습니다.");
        }
        
        return "login/login";
    }

    // 3. 메일 링크 클릭 시 재설정 폼으로 이동
    @GetMapping("/resetPw")
    public String resetPwForm(@RequestParam String token, Model model) {
        // 토큰 유효성 검사 (만료 시간 포함)
        MemberDto member = memberDao.validateToken(token);
        
        if (member != null) {
            model.addAttribute("token", token);
            model.addAttribute("userId", member.getUserId());
            return "find/resetPw"; // 새 비밀번호 입력 페이지
        } else {
            model.addAttribute("msg", "링크가 만료되었거나 유효하지 않습니다.");
            return "common/error";
        }
    }

    // 4. 실제 비밀번호 변경 처리
    @PostMapping("/resetPw")
    public String resetPw(@RequestParam String token, @RequestParam String userPw) {
        
        // 새 비밀번호 암호화
        String encryptedPw = passwordEncoder.encode(userPw);
        
        Map<String, String> map = new HashMap<>();
        map.put("token", token);
        map.put("userPw", encryptedPw);

        // 비밀번호 업데이트 및 토큰 초기화
        int result = memberDao.resetPassword(map);
        
        if (result > 0) {
            return "redirect:/member/login?resetSuccess=true";
        } else {
            return "redirect:/common/error";
        }
    }

    // [Helper] 이메일 발송 메서드
    private void sendResetEmail(String email, String token) {
        String subject = "[Jesiyo] 비밀번호 재설정 안내입니다.";
        String resetLink = "http://localhost:8080/jesiyo/member/resetPw?token=" + token;
        String content = "<div style='margin:20px;'>"
                + "<h2>안녕하세요. Jesiyo입니다.</h2>"
                + "<p>아래 버튼을 클릭하시면 비밀번호 재설정 페이지로 이동합니다.</p>"
                + "<a href='" + resetLink + "' style='padding:10px 20px; background:#FF8A3D; color:white; text-decoration:none; border-radius:5px;'>비밀번호 재설정하기</a>"
                + "<p>본인이 요청하지 않았다면 이 메일을 무시해 주세요.</p>"
                + "</div>";

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setTo(email);
            helper.setSubject(subject);
            helper.setText(content, true);
            mailSender.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
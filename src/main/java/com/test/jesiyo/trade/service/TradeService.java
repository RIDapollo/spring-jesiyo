package com.test.jesiyo.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.test.jesiyo.directsale.util.TimeUtil;
import com.test.jesiyo.notification.dto.NotificationDto;
import com.test.jesiyo.notification.service.NotificationService;
import com.test.jesiyo.trade.dto.TradeDto;
import com.test.jesiyo.trade.dto.TradeReviewDto;
import com.test.jesiyo.trade.repository.TradeDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TradeService {

	private final TradeDao dao;
	private final NotificationService notificationService;
	
	
	public int add(TradeDto dto) {
	
		int result = dao.add(dto);
		// 알림 전송
		notifySeller(dto);
		
		return result;
	}

	public List<TradeDto> getTradeList(Long memberSeq, Long lastSeq) {
		List<TradeDto> list = dao.selectTradeList(memberSeq, lastSeq);
		
		list.forEach(
				trade -> trade.setTimeAgo(TimeUtil.timeAgo(trade.getCreatedAt()))
			);
		
        return list;
    }

	@Transactional
	public int acceptTrade(Long tradeSeq) {
		
		int directResult = dao.updateDirectStatus(tradeSeq);
		int tradeResult = dao.updateTradeToAccepted(tradeSeq);
		
		if ((directResult == 1) && (tradeResult == 1)) {
			return 1;
		}
		
		return 0;
	}

	public int addReview(TradeReviewDto dto) {
		return dao.addReview(dto);
	}
	
	// 판매자에게 거래 요청 알림 보내는 메서드
	private void notifySeller(TradeDto dto) {

	    // 자기 자신 제외 (혹시 대비)
	    if (dto.getBuyerSeq().equals(dto.getSellerSeq())) return;

	    // 알림 보내기
	    notificationService.createNotification(NotificationDto.builder()
            .memberSeq(dto.getSellerSeq())
            .message("회원님의 상품에 거래 요청이 도착했습니다.")
            .refType("DIRECT")
            .refSeq(dto.getDirectSaleSeq())
            .build()
	    );
	}
}

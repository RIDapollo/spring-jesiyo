package com.test.jesiyo.chat.aop;

import java.util.List;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.test.jesiyo.auction.dto.AuctionDto;
import com.test.jesiyo.auction.repository.AuctionRecommendDao;
import com.test.jesiyo.category.dto.CategoryDto;
import com.test.jesiyo.category.repository.CategoryDao;
import com.test.jesiyo.chat.dto.ChatLogDto;
import com.test.jesiyo.directsale.dto.DirectSaleDto;
import com.test.jesiyo.directsale.repository.DirectSaleRecommendDao;

import lombok.RequiredArgsConstructor;

@Aspect
@Component
@RequiredArgsConstructor
public class ChatRecommendAspect {

    private final CategoryDao categoryDao;
    private final AuctionRecommendDao auctionRecommendDao;
    private final DirectSaleRecommendDao directSaleRecommendDao;

    /**
     * ChatService.triggerRecommend() 실행 완료 후 동작하는 AOP
     * 채팅 내용을 카테고리 키워드와 매칭하여
     * 관련 경매/중고거래 최신 2건씩을 채팅 친 사람에게만 전송
     */
    @AfterReturning("execution(* com.test.jesiyo.chat.service.ChatService.triggerRecommend(..))")
    public void recommend(JoinPoint jp) throws Exception {

        // 포인트컷 메서드의 인자 추출
        ChatLogDto dto = (ChatLogDto) jp.getArgs()[0];
        WebSocketSession session = (WebSocketSession) jp.getArgs()[1];

        // 채팅 내용 추출
        String content = dto.getContent();

        // 채팅 내용에서 카테고리 키워드 매칭
        // ex) '헤드폰 사고싶다" → 카테고리 '헤드폰' 매칭
        List<CategoryDto> matched = categoryDao.findMatchedCategories(content);

        // 매칭된 카테고리 없으면 추천 없이 종료
        if (matched.isEmpty()) return;

        for (CategoryDto category : matched) {

            // 매칭된 카테고리의 경매 최신 2건 조회
            List<AuctionDto> auctions = auctionRecommendDao
                .findTop2ByCategorySeqOrderByRegDateDesc(category.getSeq());

            // 매칭된 카테고리의 중고거래 최신 2건 조회
            List<DirectSaleDto> trades = directSaleRecommendDao
                .findTop2ByCategorySeqOrderByRegDateDesc(category.getSeq());

            // 경매, 중고거래 둘 다 비어있으면 다음 카테고리로 넘어감
            if (auctions.isEmpty() && trades.isEmpty()) continue;

            // 경매 seq, title만 추출
            JsonArray auctionArray = new JsonArray();
            for (AuctionDto auction : auctions) {
                JsonObject obj = new JsonObject();
                obj.addProperty("seq", auction.getSeq());
                obj.addProperty("name", auction.getName());
                auctionArray.add(obj);
            }

            // 중고거래 seq, title만 추출
            JsonArray tradeArray = new JsonArray();
            for (DirectSaleDto trade : trades) {
                JsonObject obj = new JsonObject();
                obj.addProperty("seq", trade.getSeq());
                obj.addProperty("name", trade.getName());
                tradeArray.add(obj);
            }

            // 추천 메시지 JSON 구성
            // code: "RECOMMEND" → 클라이언트에서 일반 채팅과 구분하는 식별자
            JsonObject recommend = new JsonObject();
            recommend.addProperty("code", "RECOMMEND");
            recommend.addProperty("categoryName", category.getName());
            recommend.add("auctions", auctionArray);
            recommend.add("trades", tradeArray);

            // 채팅 친 사람의 세션에만 추천 메시지 전송
            if (session.isOpen()) {
                session.sendMessage(new TextMessage(new Gson().toJson(recommend)));
            }

            // 추천 메시지를 한 번이라도 보냈으면 for문 종료
            break;
        }
    }
}

package com.test.jesiyo.liveauction.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.test.jesiyo.liveauction.handler.LiveAuctionHandler;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSocket
@RequiredArgsConstructor
public class LiveAuctionWebSocketConfig implements WebSocketConfigurer {

    private final LiveAuctionHandler liveAuctionHandler;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        // ws://localhost:8080/jesiyo/liveAuction 으로 접속 허용
        registry.addHandler(liveAuctionHandler, "/liveAuction")
                .setAllowedOrigins("*"); 
    }
}

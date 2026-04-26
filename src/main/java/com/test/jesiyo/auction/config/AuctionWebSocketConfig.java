package com.test.jesiyo.auction.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.test.jesiyo.auction.handler.BidWebSocketHandler;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSocket
@RequiredArgsConstructor
public class AuctionWebSocketConfig implements WebSocketConfigurer{

	private final BidWebSocketHandler bidWebSocketHandler;
	
	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		
		registry.addHandler(bidWebSocketHandler, "/bid-ws").setAllowedOrigins("*");
		
	}

}

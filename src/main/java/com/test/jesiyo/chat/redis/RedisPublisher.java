package com.test.jesiyo.chat.redis;

import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class RedisPublisher {

    // Redis에 메시지를 발행할 때 사용하는 템플릿
    private final RedisTemplate<String, String> redisTemplate;

    // RedisConfig에서 등록한 채널(topic) bean
    private final ChannelTopic chatTopic;

    // 문자열(JSON) 메시지를 Redis 채널로 발행
    public void publish(String message) {
        redisTemplate.convertAndSend(chatTopic.getTopic(), message);
    }
}
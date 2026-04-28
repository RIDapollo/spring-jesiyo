package com.test.jesiyo.chat.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.data.redis.listener.adapter.MessageListenerAdapter;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import com.test.jesiyo.chat.redis.RedisSubscriber;

@Configuration
public class ChatRedisConfig {

    // Redis 서버(host, port) 정보로 연결 팩토리 생성
    // LettuceConnectionFactory가 실제 Redis 연결을 담당
	@Bean(name = "chatRedisConnectionFactory")
    public RedisConnectionFactory chatRedisConnectionFactory() {
        RedisStandaloneConfiguration config =
                new RedisStandaloneConfiguration("127.0.0.1", 6379);
        return new LettuceConnectionFactory(config);
    }

    // Redis에 값을 읽고 쓰기 위한 템플릿
    // 지금은 JSON 문자열을 그대로 publish/subscribe 할 예정이므로
    // key, value serializer를 모두 String 방식으로 설정
	@Bean(name = "chatRedisTemplate")
    public RedisTemplate<String, String> chatRedisTemplate(@Qualifier("chatRedisConnectionFactory") RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, String> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);

        // key 직렬화 방식
        template.setKeySerializer(new StringRedisSerializer());

        // value 직렬화 방식
        template.setValueSerializer(new StringRedisSerializer());

        // hash key 직렬화 방식
        template.setHashKeySerializer(new StringRedisSerializer());

        // hash value 직렬화 방식
        template.setHashValueSerializer(new StringRedisSerializer());

        template.afterPropertiesSet();
        return template;
    }

    // Redis Pub/Sub에서 사용할 채널 이름
    // 처음에는 고정 채널 하나("chat")로 시작
	@Bean(name = "chatTopic")
    public ChannelTopic chatTopic() {
        return new ChannelTopic("chat");
    }

    // Redis에서 메시지를 받았을 때 실행할 subscriber 연결
    // RedisSubscriber의 onMessage 메서드를 호출하도록 설정
	@Bean(name = "chatRedisListenerAdapter")
    public MessageListenerAdapter messageListenerAdapter(RedisSubscriber redisSubscriber) {
        return new MessageListenerAdapter(redisSubscriber, "onMessage");
    }

    // Redis Pub/Sub 메시지를 실제로 수신하는 컨테이너
    // 어떤 listener가 어떤 topic을 구독할지 등록
	@Bean(name = "chatRedisMessageListenerContainer")
	public RedisMessageListenerContainer redisMessageListenerContainer(
	        @Qualifier("chatRedisConnectionFactory") RedisConnectionFactory connectionFactory,
	        @Qualifier("chatRedisListenerAdapter") MessageListenerAdapter listenerAdapter,
	        @Qualifier("chatTopic") ChannelTopic chatTopic) {

        RedisMessageListenerContainer container = new RedisMessageListenerContainer();
        container.setConnectionFactory(connectionFactory);

        // chat 채널에 들어온 메시지를 listenerAdapter가 처리하도록 등록
        container.addMessageListener(listenerAdapter, chatTopic);

        return container;
    }
}
package com.test.jesiyo.liveauction.config;

import org.redisson.Redisson;
import org.redisson.api.RedissonClient;
import org.redisson.config.Config;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.StringRedisSerializer;

@Configuration
public class RedisConfig {

    // 1. Redisson Client 설정 (분산 락 사용 용도)
	@Bean(name = "redissonClient", destroyMethod = "shutdown")
    public RedissonClient redissonClient() {
        Config config = new Config();
        config.useSingleServer().setAddress("redis://127.0.0.1:6379"); 
        
        return Redisson.create(config);
    }

    // 2. Spring Data Redis 연결 팩토리 설정 (Lettuce 사용으로 변경)
	@Bean(name = "redisConnectionFactory")
	@Primary // 이 줄을 꼭 추가해주세요!
    public RedisConnectionFactory redisConnectionFactory() {
        // RedissonClient를 파라미터로 받지 않고, Spring 기본인 Lettuce를 독립적으로 사용합니다.
        return new LettuceConnectionFactory("127.0.0.1", 6379);
    }

    // 3. RedisTemplate 설정 (캐시 데이터 저장/조회 용도)
	@Bean(name = "redisTemplate")
    public RedisTemplate<String, Object> redisTemplate(@Qualifier("redisConnectionFactory") RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);
        
        // Key와 Value가 깨지지 않고 문자열로 잘 보이도록 직렬화 설정
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new StringRedisSerializer()); 
        // Hash 자료구조를 쓸 경우를 위한 설정
        template.setHashKeySerializer(new StringRedisSerializer());
        template.setHashValueSerializer(new StringRedisSerializer());
        
        return template;
    }
	
}

//package com.test.jesiyo.liveauction.config;
//
//import org.redisson.Redisson;
//import org.redisson.api.RedissonClient;
//import org.redisson.config.Config;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.data.redis.connection.RedisConnectionFactory;
//import org.springframework.data.redis.core.RedisTemplate;
//import org.springframework.data.redis.serializer.StringRedisSerializer;
//
//@Configuration
//public class RedisConfig {
//
//	// 1. Redisson Client 설정 (분산 락 사용 용도)
//    @Bean(destroyMethod = "shutdown")
//    public RedissonClient redissonClient() {
//        Config config = new Config();
//        // 실제 Redis 서버 주소와 포트로 변경하세요 (기본은 로컬호스트)
//        config.useSingleServer()
//              .setAddress("redis://127.0.0.1:6379"); 
//        
//        return Redisson.create(config);
//    }
//
//    // 2. Spring Data Redis 연결 팩토리 설정
//    @Bean
//    public RedisConnectionFactory redisConnectionFactory(RedissonClient redissonClient) {
//        return new RedissonConnectionFactory(redissonClient);
//    }
//
//    // 3. RedisTemplate 설정 (캐시 데이터 저장/조회 용도)
//    @Bean
//    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory connectionFactory) {
//        RedisTemplate<String, Object> template = new RedisTemplate<>();
//        template.setConnectionFactory(connectionFactory);
//        
//        // Key와 Value가 깨지지 않고 문자열로 잘 보이도록 직렬화 설정
//        template.setKeySerializer(new StringRedisSerializer());
//        template.setValueSerializer(new StringRedisSerializer()); 
//        // Hash 자료구조를 쓸 경우를 위한 설정
//        template.setHashKeySerializer(new StringRedisSerializer());
//        template.setHashValueSerializer(new StringRedisSerializer());
//        
//        return template;
//    }
//	
//}

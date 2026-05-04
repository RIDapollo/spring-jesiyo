package com.test.jesiyo.notification.service;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@Service
public class NotificationEmitterService {

    private final Map<Long, SseEmitter> emitters = new ConcurrentHashMap<>();

    public SseEmitter subscribe(Long memberSeq) {

        SseEmitter emitter = new SseEmitter(60 * 60 * 1000L);
        emitters.put(memberSeq, emitter);

        emitter.onCompletion(() -> emitters.remove(memberSeq));
        emitter.onTimeout(() -> emitters.remove(memberSeq));
        emitter.onError((e) -> emitters.remove(memberSeq));

        return emitter;
    }

    public void send(Long memberSeq, Object data) {

        SseEmitter emitter = emitters.get(memberSeq);

        if (emitter != null) {
            try {
                emitter.send(SseEmitter.event()
                        .name("notification")
                        .data(data));
            } catch (IOException e) {
                emitters.remove(memberSeq);
            }
        }
    }
}

package com.example.withdrawalconsumer.messaging;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

@Component
public class WithdrawalEventConsumer {

    @KafkaListener(
            topics = "bank.withdrawals",
            groupId = "withdrawal-audit-group"
    )
    public void consume(
            String event,
            @Header(KafkaHeaders.RECEIVED_KEY) String key,
            @Header(KafkaHeaders.RECEIVED_PARTITION) int partition,
            @Header(KafkaHeaders.OFFSET) long offset) {

        System.out.printf(
                "[AUDIT] key=%s | partition=%d | offset=%d%n",
                key,
                partition,
                offset
        );

        System.out.println(event);
    }
}
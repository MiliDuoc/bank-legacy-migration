package com.example.withdrawalconsumer.messaging;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class WithdrawalEventConsumer {

    @KafkaListener(
            topics = "bank.withdrawals",
            groupId = "withdrawal-audit-group"
    )
    public void consume(String event) {

        System.out.println("[AUDIT] WithdrawalCreatedEvent recibido");
        System.out.println(event);
    }
}
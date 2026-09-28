# Arquitectura de eventos

La solución utiliza una **arquitectura orientada a eventos con patrón Publish/Subscribe**. Bank Core publica un `WithdrawalCreatedEvent` en el tópico `bank.withdrawals` después de un retiro exitoso. El evento es procesado de forma asíncrona por `withdrawal-consumer`, utilizando particiones para permitir procesamiento escalable.

```mermaid
flowchart LR
    A[BFF ATM] -->|HTTP - Retiro| B[Bank Core]

    B -->|Publica evento| C[Kafka<br/>Topic: bank.withdrawals]

    C --> P0[Partition 0]
    C --> P1[Partition 1]
    C --> P2[Partition 2]

    P0 --> D[withdrawal-consumer<br/>Consumer Group: withdrawal-audit-group]
    P1 --> D
    P2 --> D

    E["WithdrawalCreatedEvent<br/>withdrawalId<br/>accountId<br/>amount<br/>previousBalance<br/>newBalance<br/>occurredAt"] -.-> C
```
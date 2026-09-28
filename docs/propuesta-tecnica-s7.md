# Propuesta técnica — Arquitectura de eventos y tolerancia a fallos

## 1. Objetivo

La propuesta de Semana 7 extiende la arquitectura de microservicios desarrollada en las semanas anteriores incorporando dos capacidades principales:

- Mensajería asíncrona mediante Apache Kafka.
- Tolerancia a fallos mediante Resilience4j.

La implementación mantiene las operaciones bancarias principales como transacciones síncronas y utiliza eventos para comunicar hechos ocurridos después de una operación exitosa.

---

## 2. Arquitectura de eventos

Se implementó una **arquitectura orientada a eventos utilizando el patrón Publish/Subscribe**, con Apache Kafka como broker de mensajería.

El caso de uso seleccionado corresponde al retiro de dinero desde el canal ATM.

El flujo implementado es:

1. BFF ATM recibe una solicitud de retiro.
2. BFF ATM envía la operación a Bank Core mediante HTTP.
3. Bank Core valida y ejecuta el retiro.
4. Bank Core persiste la transacción y actualiza el saldo.
5. Después de un retiro exitoso, Bank Core publica un `WithdrawalCreatedEvent`.
6. Apache Kafka almacena el evento en el tópico `bank.withdrawals`.
7. `withdrawal-consumer` procesa el evento de manera asíncrona.

La ejecución del retiro permanece síncrona y transaccional. Kafka no ejecuta el retiro, sino que comunica que la operación ya ocurrió, permitiendo desacoplar procesos posteriores de la transacción principal.

---

## 3. Evento implementado

El evento publicado corresponde a:

`WithdrawalCreatedEvent`

Contiene los siguientes atributos:

- `withdrawalId`
- `accountId`
- `amount`
- `previousBalance`
- `newBalance`
- `occurredAt`

Para la publicación se utiliza `accountId` como key de Kafka. De esta manera, los eventos asociados a una misma cuenta mantienen afinidad con una misma partición.

---

## 4. Tópico y particiones

Se utiliza el tópico:

`bank.withdrawals`

La configuración utilizada durante las pruebas corresponde a:

- 3 particiones.
- Replication Factor 1.
- Broker Kafka local mediante Docker.
- Kafka 3.9.1 utilizando KRaft.

Las tres particiones permiten distribuir eventos entre múltiples instancias pertenecientes al mismo Consumer Group.

---

## 5. Consumidor asíncrono

Se incorporó el microservicio:

`withdrawal-consumer`

El consumidor utiliza:

`withdrawal-audit-group`

como Consumer Group.

Durante las pruebas se ejecutaron dos instancias simultáneas del consumidor. Kafka realizó el rebalance automático de las tres particiones entre ambas instancias.

También se generaron retiros reales para distintas cuentas, observándose procesamiento de eventos en ambos consumidores y distintas particiones.

Los logs del consumidor incluyen:

- Kafka key.
- Partition.
- Offset.
- Contenido del evento.

Esto permite verificar el procesamiento de cada mensaje y observar la distribución realizada por Kafka.

---

## 6. Procesamiento asíncrono

Se comprobó el desacoplamiento entre productor y consumidor.

Con Kafka disponible, Bank Core puede publicar el evento independientemente de que `withdrawal-consumer` se encuentre temporalmente detenido. Cuando el consumidor vuelve a ejecutarse, continúa procesando los eventos disponibles según los offsets administrados por Kafka.

La implementación actual no utiliza Kafka para ejecutar la transacción bancaria. La persistencia del retiro y la publicación del evento son responsabilidades diferentes.

Para una evolución futura que requiera garantizar atomicidad entre la persistencia en base de datos y la publicación del evento podría evaluarse un patrón Transactional Outbox. Este patrón no forma parte del alcance de la implementación actual.

---

## 7. Tolerancia a fallos con Resilience4j

BFF ATM utiliza Resilience4j para proteger la comunicación HTTP con Bank Core mediante un Circuit Breaker denominado:

`bankCore`

La configuración utilizada considera:

- Sliding Window basada en cantidad de llamadas.
- Tamaño de ventana: 5.
- Mínimo de llamadas: 5.
- Failure Rate Threshold: 50%.
- Wait Duration in Open State: 10 segundos.
- Llamadas permitidas en Half Open: 2.
- Transición automática desde Open hacia Half Open.

La configuración se encuentra centralizada mediante Config Server.

---

## 8. Prueba de tolerancia a fallos

La resiliencia fue validada mediante una prueba controlada.

Inicialmente, BFF ATM consultó correctamente Bank Core y obtuvo HTTP 200.

Posteriormente se detuvo Bank Core y se realizaron llamadas consecutivas desde BFF ATM. Durante las primeras fallas se ejecutó el fallback asociado al Circuit Breaker, registrándose `ResourceAccessException`.

Una vez alcanzado el umbral configurado, nuevas llamadas fueron rechazadas por Resilience4j y se registró `CallNotPermittedException`, evidenciando la apertura del Circuit Breaker.

Finalmente se inició nuevamente Bank Core. Después del período configurado, las llamadas de prueba fueron exitosas y BFF ATM volvió a responder HTTP 200, demostrando la recuperación del servicio.

---

## 9. Diagrama

El diagrama de arquitectura de eventos se encuentra disponible en:

`docs/arquitectura-eventos.md`

El diagrama representa:

- BFF ATM.
- Bank Core.
- `WithdrawalCreatedEvent`.
- Kafka.
- Tópico `bank.withdrawals`.
- Tres particiones.
- `withdrawal-consumer`.
- Consumer Group `withdrawal-audit-group`.

---

## 10. Evidencias

Las evidencias de ejecución se encuentran almacenadas en el directorio de evidencias del proyecto.

Se incluyen evidencias de:

1. Arquitectura de eventos.
2. Tópico Kafka configurado con tres particiones.
3. Retiro aprobado, publicación del evento y procesamiento por el consumidor.
4. Escalabilidad mediante dos consumidores y distribución de eventos.
5. Apertura del Circuit Breaker ante la caída de Bank Core.
6. Recuperación del servicio y retorno a respuestas HTTP 200.

---

## 11. Resultado

La implementación incorpora comunicación asíncrona mediante Apache Kafka sin modificar la responsabilidad transaccional de Bank Core.

La solución permite procesar eventos de retiros de manera desacoplada y distribuir el procesamiento mediante particiones y Consumer Groups.

Adicionalmente, Resilience4j permite que BFF ATM controle fallas temporales de Bank Core mediante Circuit Breaker y fallback, evitando llamadas continuas hacia un servicio no disponible y permitiendo posteriormente su recuperación.
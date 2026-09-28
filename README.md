# Bank Legacy Migration

Proyecto académico desarrollado para la asignatura **Desarrollo Backend III (PBY2203)**.

El proyecto implementa progresivamente la migración de un sistema bancario legacy hacia una arquitectura basada en microservicios, incorporando configuración centralizada, descubrimiento de servicios, seguridad mediante JWT, tolerancia a fallos y mensajería asíncrona.

---

## Estado actual — Semana 7

Durante la Semana 7 se incorporó una arquitectura orientada a eventos mediante **Apache Kafka** y se validó la tolerancia a fallos mediante **Resilience4j**.

El caso de uso implementado corresponde a la publicación asíncrona de eventos después de retiros ATM exitosos.

Flujo principal:

```text
BFF ATM
   |
   | HTTP
   v
Bank Core
   |
   | WithdrawalCreatedEvent
   v
Apache Kafka
   |
   | bank.withdrawals
   v
withdrawal-consumer
```

La transacción bancaria continúa ejecutándose de manera síncrona en Bank Core. Kafka se utiliza para comunicar el evento generado después de una operación exitosa.

---

## Arquitectura del proyecto

Principales componentes:

```text
bank-legacy-migration/
├── bank-core/
├── batch/
├── bff-atm/
├── bff-mobile/
├── bff-web/
├── config-repo/
├── config-server/
├── discovery-server/
├── withdrawal-consumer/
├── docs/
├── evidencias_ejecucion/
├── docker-compose.kafka.yml
├── .env.example
└── README.md
```

### Bank Core

Microservicio encargado de la lógica bancaria principal y persistencia de transacciones.

Durante un retiro ATM exitoso:

1. Valida la operación.
2. Actualiza el saldo.
3. Persiste el retiro.
4. Publica un `WithdrawalCreatedEvent` en Kafka.

### BFF ATM

Backend for Frontend correspondiente al canal ATM.

Incluye:

- Seguridad mediante JWT.
- Validación de roles.
- Validación de issuer y audience.
- Circuit Breaker mediante Resilience4j.
- Comunicación HTTP con Bank Core.

### BFF Web y BFF Mobile

Backends especializados para sus respectivos canales.

Implementan seguridad JWT con validación de firma, expiración, issuer, audience y roles.

### Config Server

Centraliza configuración externa utilizada por los microservicios.

Puerto:

`8888`

### Discovery Server

Implementa Service Discovery mediante Eureka.

Puerto:

`8761`

### withdrawal-consumer

Consumidor asíncrono de los eventos generados por Bank Core.

Utiliza:

```text
Topic: bank.withdrawals
Consumer Group: withdrawal-audit-group
```

Los logs incluyen key, partition y offset para facilitar la trazabilidad del procesamiento.

---

## Arquitectura de eventos

La solución utiliza una **arquitectura orientada a eventos con patrón Publish/Subscribe**.

Bank Core actúa como productor y publica:

`WithdrawalCreatedEvent`

El evento contiene:

- `withdrawalId`
- `accountId`
- `amount`
- `previousBalance`
- `newBalance`
- `occurredAt`

El tópico utilizado es:

`bank.withdrawals`

La key corresponde a:

`accountId`

El tópico utiliza **3 particiones**, permitiendo distribuir eventos entre múltiples consumidores pertenecientes al mismo Consumer Group.

El diagrama completo se encuentra en:

`docs/arquitectura-eventos.md`

La propuesta técnica de Semana 7 se encuentra en:

`docs/propuesta-tecnica-s7.md`

---

## Requisitos

Para ejecutar el proyecto se requiere:

- Java 17.
- Maven.
- Docker.
- PostgreSQL.
- Git.

---

## Variables de entorno

Los BFF utilizan la variable:

```text
JWT_SECRET
```

Existe un archivo de referencia:

`.env.example`

Crear localmente un archivo `.env` con una clave válida:

```text
JWT_SECRET=reemplazar-por-clave-secreta-local
```

El archivo `.env` está excluido del repositorio mediante `.gitignore`.

Antes de iniciar un BFF desde terminal:

```bash
set -a
source ../.env
set +a
```

---

## Ejecución de Kafka

Desde la raíz del proyecto:

```bash
docker compose -f docker-compose.kafka.yml up -d
```

Comprobar el contenedor:

```bash
docker ps --filter name=bank-kafka
```

---

## Configuración del tópico Kafka

Para una instalación nueva, crear el tópico con tres particiones:

```bash
docker exec bank-kafka \
  /opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server localhost:9092 \
  --create \
  --if-not-exists \
  --topic bank.withdrawals \
  --partitions 3 \
  --replication-factor 1
```

Comprobar la configuración:

```bash
docker exec bank-kafka \
  /opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server localhost:9092 \
  --describe \
  --topic bank.withdrawals
```

La configuración esperada es:

```text
PartitionCount: 3
ReplicationFactor: 1
```

Si el tópico ya existe con una sola partición, puede aumentarse a tres mediante:

```bash
docker exec bank-kafka \
  /opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server localhost:9092 \
  --alter \
  --topic bank.withdrawals \
  --partitions 3
```

---

## Ejecución de los servicios

Los servicios deben iniciarse desde terminales independientes.

### 1. Config Server

```bash
cd config-server
mvn spring-boot:run
```

Puerto:

`8888`

### 2. Discovery Server

```bash
cd discovery-server
mvn spring-boot:run
```

Puerto:

`8761`

### 3. Bank Core

```bash
cd bank-core
mvn spring-boot:run
```

Puerto:

`8080`

### 4. withdrawal-consumer

```bash
cd withdrawal-consumer
mvn spring-boot:run
```

Para demostrar procesamiento distribuido pueden ejecutarse dos instancias del mismo consumidor en terminales diferentes.

Kafka realizará automáticamente el rebalance de las particiones dentro de:

`withdrawal-audit-group`

### 5. BFF ATM

```bash
cd bff-atm

set -a
source ../.env
set +a

mvn spring-boot:run
```

Puerto HTTPS:

`8443`

### 6. BFF Web

```bash
cd bff-web

set -a
source ../.env
set +a

mvn spring-boot:run
```

Puerto HTTPS:

`8441`

### 7. BFF Mobile

```bash
cd bff-mobile

set -a
source ../.env
set +a

mvn spring-boot:run
```

Puerto HTTPS:

`8442`

---

## Prueba de retiro ATM

Generar un JWT para el canal ATM:

```bash
cd bff-atm

set -a
source ../.env
set +a

export JWT_ATM="$(mvn -q exec:java \
  -Dexec.mainClass="com.example.bffatm.security.JwtTokenGenerator" \
  -Dexec.args="ATM")"
```

Ejecutar un retiro:

```bash
curl -k -i \
  -X POST \
  -H "Authorization: Bearer $JWT_ATM" \
  -H "Content-Type: application/json" \
  -d '{"monto":100}' \
  https://localhost:8443/api/atm/cuentas/101/retiros
```

Una operación exitosa genera una respuesta HTTP 200 y posteriormente Bank Core publica un `WithdrawalCreatedEvent`.

El evento puede observarse en la consola de `withdrawal-consumer`.

---

## Escalabilidad Kafka

El tópico `bank.withdrawals` utiliza tres particiones.

Al ejecutar dos instancias de `withdrawal-consumer` dentro de `withdrawal-audit-group`, Kafka distribuye las particiones entre ambas instancias mediante rebalance automático.

Durante las pruebas se generaron retiros para múltiples cuentas y se comprobó el procesamiento de eventos en diferentes particiones y consumidores.

La key utilizada es `accountId`, permitiendo mantener afinidad de los eventos asociados a una misma cuenta con una partición.

---

## Tolerancia a fallos

BFF ATM utiliza un Circuit Breaker de Resilience4j para proteger llamadas hacia Bank Core.

La configuración principal corresponde a:

```text
sliding-window-type=COUNT_BASED
sliding-window-size=5
minimum-number-of-calls=5
failure-rate-threshold=50
wait-duration-in-open-state=10s
permitted-number-of-calls-in-half-open-state=2
automatic-transition-from-open-to-half-open-enabled=true
```

Durante las pruebas se detuvo Bank Core y se realizaron llamadas consecutivas desde BFF ATM.

Inicialmente se ejecutó el fallback debido a errores de conexión, registrándose `ResourceAccessException`.

Una vez alcanzado el umbral configurado, Resilience4j rechazó nuevas llamadas mediante `CallNotPermittedException`, evidenciando la apertura del Circuit Breaker.

Después de iniciar nuevamente Bank Core y transcurrir el período configurado, el Circuit Breaker permitió llamadas de prueba y el servicio volvió a responder HTTP 200.

---

## Seguridad JWT

Los BFF validan:

- Firma del token.
- Expiración.
- Subject.
- Role.
- Issuer.
- Audience.

Issuer utilizado:

`bank-legacy-migration`

Audiencias:

```text
BFF ATM    -> bff-atm
BFF Web    -> bff-web
BFF Mobile -> bff-mobile
```

El secreto de firma se obtiene mediante la variable de entorno `JWT_SECRET` y no se almacena directamente en el código fuente.

---

## Evidencias

Las evidencias de ejecución de Semana 7 se encuentran en:

`evidencias_ejecucion/semana7/`

Incluyen:

```text
E01_arquitectura_eventos.png
E02_kafka_topic_3_particiones.png
E03_retiro_evento_kafka_consumidor.png
E04_escalabilidad_kafka_dos_consumidores.png
E05A_resilience4j_circuit_breaker_open.png
E05B_resilience4j_recuperacion.png
```

Las evidencias muestran:

- Arquitectura de eventos y patrón Publish/Subscribe.
- Kafka configurado con tres particiones.
- Retiro ATM exitoso.
- Publicación de `WithdrawalCreatedEvent` desde Bank Core.
- Procesamiento asíncrono del evento mediante `withdrawal-consumer`.
- Distribución de particiones y eventos entre dos consumidores.
- Apertura del Circuit Breaker ante la caída de Bank Core.
- Recuperación del servicio y retorno a respuestas HTTP 200.

---

## Documentación

- Arquitectura de eventos: `docs/arquitectura-eventos.md`
- Propuesta técnica Semana 7: `docs/propuesta-tecnica-s7.md`
- Evidencias de ejecución Semana 7: `evidencias_ejecucion/semana7/`

---

## Tecnologías principales

- Java 17
- Spring Boot
- Spring Cloud Config
- Netflix Eureka
- Spring Security
- JWT / JJWT
- Resilience4j
- Apache Kafka
- PostgreSQL
- Maven
- Docker
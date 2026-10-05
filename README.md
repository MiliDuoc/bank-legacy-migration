# Bank Legacy Migration

Proyecto académico desarrollado para la asignatura **Desarrollo Backend III (PBY2203)**.

El proyecto implementa progresivamente la migración de un sistema bancario legacy hacia una arquitectura distribuida basada en microservicios, incorporando configuración centralizada, descubrimiento de servicios, seguridad OAuth2, tolerancia a fallos, mensajería asíncrona y despliegue mediante contenedores.

---

## Estado actual — Semana 8

Durante la Semana 8 se consolidó la arquitectura desarrollada en semanas anteriores y se preparó su ejecución completa mediante Docker.

La solución incorpora actualmente:

- Spring Cloud Config para configuración centralizada.
- Eureka para descubrimiento de servicios.
- OAuth2 mediante Spring Authorization Server.
- Client Credentials y scopes diferenciados por canal.
- BFF Web, Mobile y ATM.
- Bank Core como microservicio de negocio.
- Resilience4j con Circuit Breaker, Retry y Bulkhead.
- Apache Kafka para mensajería asíncrona.
- PostgreSQL para persistencia.
- Docker y Docker Compose para containerización y orquestación.

---

## Arquitectura

Flujo principal de la solución:

```text
                    Authorization Server
                           OAuth2
                             |
              +--------------+--------------+
              |              |              |
              v              v              v
           BFF Web       BFF Mobile      BFF ATM
              \              |              /
               \             |             /
                +-------- Bank Core -------+
                           |
                    PostgreSQL
                           |
                WithdrawalCreatedEvent
                           |
                           v
                     Apache Kafka
                           |
                  bank.withdrawals
                           |
                           v
                withdrawal-consumer
```

La infraestructura transversal incluye:

```text
Spring Cloud Config  -> configuración centralizada
Eureka               -> descubrimiento de servicios
Resilience4j         -> tolerancia a fallos
Docker Compose       -> orquestación de la solución
```

---

## Componentes principales

```text
bank-legacy-migration/
├── authorization-server/
├── bank-core/
├── batch/
├── bff-atm/
├── bff-mobile/
├── bff-web/
├── config-repo/
├── config-server/
├── discovery-server/
├── withdrawal-consumer/
├── database/
├── docs/
├── evidencias_ejecucion/
└── docker-compose.yaml
```

### Authorization Server

Servidor OAuth2 implementado mediante Spring Authorization Server.

Utiliza el flujo **Client Credentials** y entrega tokens JWT a los clientes registrados:

```text
bff-web-client     -> scope web
bff-mobile-client  -> scope mobile
bff-atm-client     -> scope atm
```

Puerto:

```text
9000
```

### Bank Core

Microservicio encargado de la lógica bancaria y persistencia.

Expone endpoints internos consumidos por los BFF y, después de un retiro exitoso, publica un `WithdrawalCreatedEvent` en Kafka.

Puerto:

```text
8080
```

### BFF Web

Backend for Frontend del canal Web.

Expone información completa de la cuenta y sus movimientos.

Puerto HTTPS:

```text
8441
```

### BFF Mobile

Backend for Frontend del canal Mobile.

Entrega una representación simplificada de la cuenta y sus últimos movimientos.

Puerto HTTPS:

```text
8442
```

### BFF ATM

Backend for Frontend del canal ATM.

Permite consultar saldo y ejecutar retiros.

Puerto HTTPS:

```text
8443
```

### Config Server

Centraliza la configuración externa de los servicios mediante Spring Cloud Config.

Puerto:

```text
8888
```

### Discovery Server

Implementa Service Discovery mediante Eureka.

Puerto:

```text
8761
```

### withdrawal-consumer

Consumidor asíncrono de eventos de retiro.

```text
Topic: bank.withdrawals
Consumer Group: withdrawal-audit-group
```

Puede ejecutarse con múltiples instancias dentro del mismo Consumer Group, permitiendo distribuir las particiones disponibles.

### Batch

Mantiene los procesos batch desarrollados durante las etapas anteriores del proyecto.

Dentro de Docker Compose se configura como un proceso de ejecución finita y utiliza la misma base PostgreSQL de la solución.

---

## Seguridad OAuth2

La seguridad implementada previamente mediante JWT generado localmente fue reemplazada por un esquema OAuth2 centralizado.

Los BFF obtienen tokens desde `authorization-server` utilizando:

```text
grant_type=client_credentials
```

Cada canal posee un scope específico:

```text
Web     -> web
Mobile  -> mobile
ATM     -> atm
```

Los BFF funcionan como Resource Servers y validan los tokens recibidos.

Bank Core también funciona como Resource Server. Los BFF propagan el Bearer Token recibido al realizar llamadas internas hacia Core.

Este esquema permite distinguir entre:

```text
Sin token             -> HTTP 401
Token + scope válido  -> HTTP 200
Scope incorrecto      -> HTTP 403
```

---

## Resiliencia

Las llamadas síncronas desde los BFF hacia Bank Core están protegidas mediante **Resilience4j**.

La política `bankCore` se encuentra centralizada en Config Server.

### Circuit Breaker

Configuración principal:

```text
sliding-window-type=COUNT_BASED
sliding-window-size=5
minimum-number-of-calls=5
failure-rate-threshold=50
wait-duration-in-open-state=10s
permitted-number-of-calls-in-half-open-state=2
automatic-transition-from-open-to-half-open-enabled=true
```

Permite evitar llamadas repetidas hacia Bank Core cuando el servicio presenta fallos.

### Retry

Configuración:

```text
max-attempts=3
wait-duration=500ms
```

Se utiliza en operaciones de consulta hacia Bank Core.

### Bulkhead

Configuración:

```text
max-concurrent-calls=5
max-wait-duration=0
```

Limita la cantidad de llamadas concurrentes hacia Bank Core y evita que una dependencia saturada consuma todos los recursos disponibles.

---

## Mensajería Kafka

La operación bancaria se procesa de manera síncrona en Bank Core.

Después de un retiro exitoso, Core publica:

```text
WithdrawalCreatedEvent
```

en:

```text
Topic: bank.withdrawals
```

El evento contiene:

```text
withdrawalId
accountId
amount
previousBalance
newBalance
occurredAt
```

La key utilizada corresponde a:

```text
accountId
```

El tópico posee:

```text
PartitionCount: 3
ReplicationFactor: 1
```

El uso de `accountId` como key mantiene afinidad entre los eventos asociados a una misma cuenta y su partición.

Las instancias de `withdrawal-consumer` pertenecen a:

```text
withdrawal-audit-group
```

Kafka distribuye automáticamente las particiones entre las instancias disponibles mediante el rebalance del Consumer Group.

---

## Docker y ejecución

La arquitectura completa se encuentra containerizada.

Los servicios Java poseen imágenes propias basadas en Java 17:

```text
bank-authorization-server
bank-config-server
bank-discovery-server
bank-core
bank-bff-web
bank-bff-mobile
bank-bff-atm
bank-withdrawal-consumer
bank-batch
```

Docker Compose incorpora además:

```text
PostgreSQL 17
Apache Kafka 3.9.1
```

### Construcción de los servicios

Antes de construir las imágenes se deben generar los JAR:

```bash
mvn clean package -DskipTests
```

en cada proyecto Maven.

Posteriormente, desde la raíz:

```bash
docker compose build
```

### Levantar la arquitectura

Desde la raíz del proyecto:

```bash
docker compose up -d
```

Comprobar el estado:

```bash
docker compose ps -a
```

El servicio `batch` puede aparecer como:

```text
Exited (0)
```

después de completar correctamente su ejecución.

### Detener la arquitectura

```bash
docker compose down
```

---

## Persistencia

PostgreSQL se ejecuta como parte de Docker Compose.

Puerto expuesto localmente:

```text
5433
```

La inicialización utiliza:

```text
database/bank_legacy_snapshot.sql
```

El snapshot contiene tanto las tablas de negocio como las tablas de metadata utilizadas por Spring Batch, permitiendo reproducir el estado requerido por la aplicación dentro del entorno Docker.

---

## Validación rápida

### Obtener token ATM

```bash
ATM_TOKEN=$(curl -s \
  -u bff-atm-client:atm-secret \
  -d grant_type=client_credentials \
  -d scope=atm \
  http://localhost:9000/oauth2/token \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["access_token"])')
```

### Consultar saldo

```bash
curl -sk \
  -H "Authorization: Bearer $ATM_TOKEN" \
  https://localhost:8443/api/atm/cuentas/101/saldo
```

Respuesta esperada:

```text
HTTP 200
```

### Consultar estado del tópico

```bash
docker compose exec kafka \
  /opt/kafka/bin/kafka-topics.sh \
  --bootstrap-server localhost:29092 \
  --describe \
  --topic bank.withdrawals
```

### Consultar Consumer Group

```bash
docker compose exec kafka \
  /opt/kafka/bin/kafka-consumer-groups.sh \
  --bootstrap-server localhost:29092 \
  --describe \
  --group withdrawal-audit-group
```

---

## Decisiones técnicas

### Transacción bancaria y Kafka

La modificación del saldo continúa siendo una operación síncrona ejecutada por Bank Core.

Kafka se utiliza posteriormente para comunicar el evento generado por una operación exitosa, evitando delegar la consistencia principal de la transacción bancaria al procesamiento asíncrono.

### Retry en operaciones de escritura

Las consultas desde los BFF utilizan Retry como mecanismo de resiliencia.

El retiro ATM **no utiliza Retry**.

Un retiro modifica estado. Si Bank Core procesara correctamente la operación pero la respuesta se perdiera durante la comunicación, un reintento automático podría ejecutar un segundo retiro.

Por esta razón, el retiro utiliza Bulkhead para limitar concurrencia, pero no se reintenta automáticamente.

### Configuración centralizada

Los parámetros de resiliencia se mantienen en `config-repo`, evitando distribuir la misma configuración entre los distintos BFF y permitiendo mantener una política común para la dependencia `bankCore`.

---

## Mejoras incorporadas

A partir de la implementación y retroalimentación de Semana 7 se incorporaron las siguientes mejoras:

- Resilience4j se extendió y centralizó para los BFF Web, Mobile y ATM mediante Circuit Breaker, Retry y Bulkhead según el tipo de operación.
- Se evitó aplicar Retry al retiro ATM para prevenir posibles operaciones duplicadas.
- `withdrawal-consumer` puede escalar horizontalmente dentro de `withdrawal-audit-group`, distribuyendo las tres particiones de `bank.withdrawals` entre múltiples instancias.
- La seguridad JWT implementada previamente fue reemplazada por OAuth2 mediante un Authorization Server, Client Credentials y scopes específicos por canal.
- Bank Core fue protegido como Resource Server y recibe el Bearer Token propagado por los BFF.
- La arquitectura completa fue containerizada mediante imágenes Docker independientes.
- Docker Compose integra infraestructura, configuración, descubrimiento, seguridad, BFF, Bank Core, Batch, persistencia y mensajería.
- PostgreSQL puede reconstruirse mediante un snapshot controlado del esquema y datos requeridos por la solución.

---

## Evidencias — Semana 8

Las evidencias de ejecución se encuentran en [`evidencias_ejecucion/semana8/`](evidencias_ejecucion/semana8/).

### E01 — Docker Compose

[Ver evidencia E01](evidencias_ejecucion/semana8/E01-docker-compose.png)

Demuestra la orquestación de la arquitectura completa y las imágenes Docker generadas para los servicios Java.

### E02 — OAuth2 y scopes

[Ver evidencia E02](evidencias_ejecucion/semana8/E02-oauth2-scopes.png)

Demuestra:

```text
Sin token             -> HTTP 401
Token ATM + scope atm -> HTTP 200
Token Mobile en ATM   -> HTTP 403
```

### E03 — BFF hacia Bank Core

[Ver evidencia E03](evidencias_ejecucion/semana8/E03-bff-bank-core.png)

Valida Web, Mobile y ATM con tokens OAuth2 válidos y respuestas HTTP 200.

### E04 — Resilience4j

[Ver evidencia E04](evidencias_ejecucion/semana8/E04-resilience4j.png)

Muestra la configuración centralizada de Circuit Breaker, Retry y Bulkhead y su aplicación en BFF ATM.

### E05 — Kafka y escalabilidad

[Ver evidencia E05](evidencias_ejecucion/semana8/E05-kafka-escalabilidad.png)

Demuestra:

- Topic `bank.withdrawals`.
- Tres particiones.
- Consumer Group `withdrawal-audit-group`.
- Dos instancias de `withdrawal-consumer`.
- Distribución de particiones.
- Procesamiento sin eventos pendientes (`LAG=0`).

### E06 — Flujo asíncrono

[Ver evidencia E06](evidencias_ejecucion/semana8/E06-kafka-end-to-end.png)

Muestra la publicación de `WithdrawalCreatedEvent` desde Bank Core y la integración de las instancias de `withdrawal-consumer` con Kafka.

---

## Evolución del proyecto

La implementación de Semana 8 integra y extiende el trabajo desarrollado progresivamente durante el proyecto:

```text
Sistema legacy
      ↓
Microservicios y BFF
      ↓
Config Server + Eureka
      ↓
Seguridad
      ↓
Resilience4j
      ↓
Kafka y procesamiento asíncrono
      ↓
OAuth2 + Docker + orquestación completa
```

La evolución mantiene la separación de responsabilidades entre infraestructura, canales de acceso, lógica de negocio y procesamiento asíncrono.

---

## Documentación

```text
docs/arquitectura-eventos.md
docs/propuesta-tecnica-s7.md
evidencias_ejecucion/semana7/
evidencias_ejecucion/semana8/
```

---

## Tecnologías principales

- Java 17
- Spring Boot
- Spring Cloud Config
- Netflix Eureka
- Spring Security
- Spring Authorization Server
- OAuth2 / JWT
- Resilience4j
- Apache Kafka
- PostgreSQL
- Spring Batch
- Maven
- Docker
- Docker Compose
# Propuesta Técnica — Semana 8

## 1. Objetivo

La Semana 8 consolida la migración progresiva del sistema bancario legacy hacia una arquitectura de microservicios preparada para ejecutarse de forma distribuida y contener fallos sin comprometer innecesariamente al resto de la solución.

La propuesta extiende la arquitectura construida durante las semanas anteriores incorporando tres capacidades principales:

- seguridad centralizada mediante OAuth2;
- resiliencia en la comunicación síncrona mediante Resilience4j;
- containerización y orquestación completa mediante Docker y Docker Compose.

Estas capacidades se integran con los componentes previamente desarrollados, particularmente Spring Cloud Config, Eureka, Bank Core y la arquitectura asíncrona basada en Apache Kafka.

---

## 2. Arquitectura propuesta

La solución mantiene una separación entre canales de acceso, lógica de negocio, infraestructura y procesamiento asíncrono.

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

Los BFF actúan como adaptadores específicos para Web, Mobile y ATM, mientras Bank Core concentra la lógica bancaria. Config Server centraliza configuración, Eureka mantiene el descubrimiento de servicios y Kafka desacopla el procesamiento posterior asociado a los retiros.

Sobre esta arquitectura se incorporan OAuth2, Resilience4j y la ejecución containerizada.

---

## 3. Seguridad mediante OAuth2

### 3.1 Problema

En las etapas anteriores del proyecto los BFF utilizaban JWT generado y validado directamente por la aplicación.

Aunque este mecanismo permitía proteger los endpoints, distribuía responsabilidades de seguridad entre los distintos servicios y no representaba un esquema centralizado de autorización.

### 3.2 Solución

Se incorporó un `authorization-server` utilizando Spring Authorization Server.

La comunicación utiliza el flujo:

```text
Client Credentials
```

Se registraron clientes independientes para cada canal:

```text
bff-web-client     -> scope web
bff-mobile-client  -> scope mobile
bff-atm-client     -> scope atm
```

Los BFF funcionan como OAuth2 Resource Servers y verifican tanto la validez del token como el scope correspondiente al canal.

Bank Core también funciona como Resource Server. Cuando un BFF realiza una solicitud hacia Core, propaga el Bearer Token recibido originalmente.

El flujo resultante es:

```text
Cliente
   |
   | solicita token
   v
Authorization Server
   |
   | JWT + scope
   v
BFF
   |
   | Bearer Token
   v
Bank Core
```

### 3.3 Resultado esperado

La autorización permite distinguir correctamente entre:

```text
Solicitud sin token     -> HTTP 401
Token y scope correcto  -> HTTP 200
Scope incorrecto        -> HTTP 403
```

De esta forma, autenticación y autorización dejan de depender de una implementación JWT propia distribuida entre los BFF.

---

## 4. Resiliencia mediante Resilience4j

### 4.1 Problema

Los BFF dependen síncronamente de Bank Core.

Una indisponibilidad o degradación de Core puede generar llamadas repetidas, acumulación de solicitudes o propagación del fallo hacia los canales Web, Mobile y ATM.

### 4.2 Política centralizada

La política `bankCore` se configura mediante Config Server y se aplica en los BFF.

Se utilizan tres patrones:

```text
Circuit Breaker
Retry
Bulkhead
```

### 4.3 Circuit Breaker

Circuit Breaker permite interrumpir temporalmente las llamadas hacia Bank Core cuando se supera un determinado nivel de fallos.

La política implementada utiliza una ventana de cinco llamadas, un mínimo de cinco observaciones y un umbral de fallo del 50 %.

Cuando el circuito se abre, se evita continuar intentando acceder inmediatamente a una dependencia que se encuentra degradada. Posteriormente se permite una transición controlada hacia `HALF_OPEN` para comprobar su recuperación.

### 4.4 Retry

Las operaciones de consulta pueden reintentarse hasta tres veces, esperando 500 ms entre intentos.

Retry se utiliza únicamente cuando repetir la solicitud no modifica el estado del sistema.

Esto permite absorber fallos transitorios sin trasladarlos inmediatamente al cliente.

### 4.5 Bulkhead

Bulkhead limita a cinco las llamadas concurrentes asociadas a la dependencia `bankCore`, sin tiempo de espera adicional.

Su objetivo es evitar que una dependencia degradada monopolice los recursos disponibles en el BFF.

### 4.6 Tratamiento especial del retiro

No se aplica Retry a la operación de retiro ATM.

Esta decisión responde a que un retiro modifica estado.

Por ejemplo:

```text
1. ATM solicita retiro de $100.
2. Bank Core procesa correctamente el retiro.
3. La respuesta se pierde por un problema de comunicación.
4. El BFF interpreta la llamada como fallida.
5. Un Retry automático envía nuevamente el retiro.
```

Sin un mecanismo adicional de idempotencia, este escenario podría producir dos débitos.

Por esta razón, la operación de retiro utiliza Bulkhead para limitar concurrencia, pero no Retry automático.

La resiliencia se aplica según la semántica de cada operación y no de forma uniforme sobre todos los endpoints.

---

## 5. Mensajería asíncrona con Kafka

La arquitectura Kafka implementada previamente se mantiene como mecanismo de desacoplamiento posterior a la operación bancaria.

Después de un retiro exitoso, Bank Core publica un:

```text
WithdrawalCreatedEvent
```

en:

```text
bank.withdrawals
```

El tópico posee tres particiones y utiliza `accountId` como key.

Esto permite mantener afinidad entre eventos correspondientes a una misma cuenta y, al mismo tiempo, distribuir cuentas diferentes entre particiones.

`withdrawal-consumer` utiliza:

```text
withdrawal-audit-group
```

Durante Semana 8 se validó además su ejecución con dos instancias simultáneas. Kafka distribuye las tres particiones entre ambos consumidores pertenecientes al mismo grupo.

Esto permite escalar horizontalmente el procesamiento asíncrono sin modificar Bank Core ni el productor del evento.

---

## 6. Containerización

### 6.1 Objetivo

La ejecución manual de múltiples servicios en terminales independientes aumenta la cantidad de configuración necesaria para reproducir la arquitectura.

Para reducir esta dependencia del entorno local, cada aplicación Java fue containerizada mediante Docker.

Se generaron imágenes independientes para:

```text
authorization-server
config-server
discovery-server
bank-core
bff-web
bff-mobile
bff-atm
withdrawal-consumer
batch
```

Las imágenes utilizan Java 17 y ejecutan el JAR generado por Maven.

Esta separación permite construir, iniciar y reemplazar componentes individualmente manteniendo el aislamiento entre servicios.

---

## 7. Orquestación mediante Docker Compose

`docker-compose.yaml` define el entorno completo necesario para ejecutar la solución.

Además de las aplicaciones Java, incorpora:

```text
PostgreSQL
Apache Kafka
kafka-init
```

La configuración interna utiliza los nombres de los servicios Docker como direcciones de red.

Por ejemplo:

```text
authorization-server:9000
postgres:5432
kafka:29092
```

Esto evita depender de `localhost` para la comunicación entre contenedores.

Desde el equipo anfitrión se mantienen puertos expuestos para validación y desarrollo.

### 7.1 Configuración centralizada

Los BFF obtienen su configuración desde Config Server utilizando la dirección interna definida en Docker.

Esto mantiene el mismo mecanismo de configuración utilizado fuera de Docker, cambiando únicamente la ubicación del servicio mediante variables de entorno.

### 7.2 Persistencia reproducible

PostgreSQL se inicializa utilizando:

```text
database/bank_legacy_snapshot.sql
```

El snapshot contiene las tablas de negocio y metadata de Spring Batch necesarias para reproducir el estado utilizado por la aplicación.

### 7.3 Procesos finitos

No todos los componentes de la arquitectura deben permanecer permanentemente activos.

`kafka-init` finaliza después de comprobar o crear el tópico requerido.

De forma equivalente, Batch se mantiene como un componente de ejecución finita. Dentro del entorno Docker su ejecución automática de jobs se encuentra deshabilitada para evitar modificar el estado controlado utilizado durante las pruebas.

Por lo tanto, un estado:

```text
Exited (0)
```

para estos componentes representa una finalización correcta y no un fallo del contenedor.

---

## 8. Escalabilidad

La arquitectura contempla dos tipos diferentes de escalabilidad.

Los BFF se mantienen separados por canal, permitiendo que Web, Mobile y ATM evolucionen independientemente según sus necesidades.

En el procesamiento asíncrono, `withdrawal-consumer` puede ejecutar múltiples instancias pertenecientes al mismo Consumer Group.

La validación realizada con dos consumidores demostró la redistribución automática de las tres particiones de `bank.withdrawals` entre ambas instancias.

Esta capacidad permite aumentar consumidores sin modificar el productor ni crear procesamiento duplicado dentro del mismo grupo.

---

## 9. Mejoras incorporadas desde Semana 7

La implementación de Semana 8 incorpora observaciones surgidas durante la evaluación de la arquitectura anterior.

### Resiliencia

La implementación inicial de Circuit Breaker concentrada en ATM se extendió hacia una política común para Web, Mobile y ATM.

Además de Circuit Breaker se incorporaron Retry y Bulkhead, diferenciando su aplicación según el tipo de operación.

### Seguridad

La implementación JWT propia fue reemplazada por un Authorization Server OAuth2 centralizado.

Los canales utilizan clientes y scopes independientes y Bank Core también valida los tokens propagados por los BFF.

### Escalabilidad Kafka

Se validó la ejecución de múltiples instancias de `withdrawal-consumer` dentro del mismo Consumer Group, comprobando la distribución de las tres particiones disponibles.

### Despliegue

La arquitectura dejó de depender de levantar manualmente cada servicio y su infraestructura.

Docker y Docker Compose permiten reproducir en un único entorno:

```text
configuración
discovery
autorización
BFF
Bank Core
PostgreSQL
Kafka
consumidores
Batch
```

---

## 10. Límites y mejoras futuras

La implementación prioriza los mecanismos necesarios para la arquitectura actual y mantiene identificadas mejoras que requieren cambios adicionales.

### Transactional Outbox

Actualmente la modificación del saldo y la publicación del evento Kafka no forman una única transacción distribuida.

Si la base de datos confirma el retiro y Kafka se encuentra indisponible inmediatamente después, la operación bancaria puede quedar persistida sin que el evento correspondiente sea publicado.

Una evolución posible es implementar Transactional Outbox, registrando el evento dentro de la misma transacción de base de datos y publicándolo posteriormente desde un proceso independiente.

### Idempotencia

La decisión de no aplicar Retry automático al retiro reduce el riesgo de duplicación, pero no reemplaza una estrategia de idempotencia.

Una evolución posterior podría asociar un identificador único a cada solicitud de retiro y permitir a Bank Core reconocer solicitudes previamente procesadas.

### Procesamiento Kafka

El consumidor actual cumple el objetivo de auditoría y validación del flujo asíncrono.

Como evolución se puede incorporar deserialización tipada, validación explícita del evento y una estrategia de errores mediante retries controlados, backoff y Dead Letter Queue.

Estas mejoras no se consideran implementadas en la versión actual y se mantienen como evolución futura.

---

## 11. Validación de la propuesta

La implementación fue validada mediante pruebas funcionales y salidas de consola.

Las evidencias de Semana 8 cubren:

```text
E01 -> imágenes Docker y orquestación completa
E02 -> OAuth2, autenticación y scopes
E03 -> comunicación BFF -> Bank Core
E04 -> política Resilience4j
E05 -> Kafka, particiones y escalabilidad
E06 -> publicación e integración del flujo asíncrono
```

Las evidencias se encuentran en:

```text
evidencias_ejecucion/semana8/
```

La validación final confirmó además que los servicios Web, Mobile y ATM responden correctamente utilizando OAuth2, que el Consumer Group procesa sin mensajes pendientes y que la arquitectura puede iniciarse de manera reproducible mediante Docker Compose.
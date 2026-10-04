package com.example.bffatm.client;

import com.example.bffatm.client.dto.CoreAccountResponse;
import com.example.bffatm.client.dto.CoreWithdrawalRequest;
import com.example.bffatm.client.dto.CoreWithdrawalResponse;
import com.example.bffatm.exception.CoreApiException;

import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import io.github.resilience4j.bulkhead.annotation.Bulkhead;
import io.github.resilience4j.retry.annotation.Retry;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientResponseException;

import java.math.BigDecimal;
import java.util.Optional;

@Component
public class BankCoreClient {

    private final RestClient restClient;

    public BankCoreClient(
            RestClient.Builder restClientBuilder,
            @Value("${bank.core.base-url}") String bankCoreBaseUrl) {

        this.restClient = restClientBuilder
                .baseUrl(bankCoreBaseUrl)
                .build();
    }

    @Retry(name = "bankCore")
    @CircuitBreaker(
            name = "bankCore",
            fallbackMethod = "getAccountFallback"
    )
    @Bulkhead(
            name = "bankCore",
            type = Bulkhead.Type.SEMAPHORE
    )
    public Optional<CoreAccountResponse> getAccount(Long cuentaId) {

        try {
            CoreAccountResponse response = restClient
                    .get()
                    .uri("/internal/accounts/{cuentaId}", cuentaId)
                    .header(
                            HttpHeaders.AUTHORIZATION,
                            bearerToken()
                    )
                    .retrieve()
                    .body(CoreAccountResponse.class);

            return Optional.ofNullable(response);

        } catch (RestClientResponseException exception) {

            if (exception.getStatusCode().value() == 404) {
                return Optional.empty();
            }

            throw exception;
        }
    }

    /*
     * No se aplica Retry a retiros porque la operación modifica estado.
     * Un reintento automático podría provocar un retiro duplicado.
     */
    @Bulkhead(
            name = "bankCore",
            type = Bulkhead.Type.SEMAPHORE
    )
    public CoreWithdrawalResponse withdraw(
            Long cuentaId,
            BigDecimal monto) {

        try {
            return restClient
                    .post()
                    .uri(
                            "/internal/accounts/{cuentaId}/withdrawals",
                            cuentaId
                    )
                    .header(
                            HttpHeaders.AUTHORIZATION,
                            bearerToken()
                    )
                    .body(new CoreWithdrawalRequest(monto))
                    .retrieve()
                    .body(CoreWithdrawalResponse.class);

        } catch (RestClientResponseException exception) {

            throw new CoreApiException(
                    exception.getStatusCode(),
                    extractMessage(exception)
            );
        }
    }

    private String bearerToken() {

        Authentication authentication =
                SecurityContextHolder
                        .getContext()
                        .getAuthentication();

        if (authentication instanceof JwtAuthenticationToken jwtAuthentication) {
            return "Bearer "
                    + jwtAuthentication
                            .getToken()
                            .getTokenValue();
        }

        throw new IllegalStateException(
                "No existe un token OAuth2 autenticado para propagar a Bank Core"
        );
    }

    private Optional<CoreAccountResponse> getAccountFallback(
            Long cuentaId,
            Throwable throwable) {

        System.out.println(
                "Fallback Bank Core - cuenta " + cuentaId
                        + ": " + throwable.getClass().getSimpleName()
        );

        return Optional.empty();
    }

    private String extractMessage(
            RestClientResponseException exception) {

        String body = exception.getResponseBodyAsString();

        if (body.contains("Fondos insuficientes")) {
            return "Saldo insuficiente";
        }

        if (body.contains("No existe la cuenta")) {
            return "Cuenta no encontrada";
        }

        if (body.contains("monto")) {
            return "El monto del retiro debe ser mayor que cero";
        }

        return "Error al procesar la operación";
    }
}
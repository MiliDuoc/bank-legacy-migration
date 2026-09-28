package com.example.bffweb.security;

public final class JwtSecretProvider {

    private JwtSecretProvider() {
    }

    public static String getSecret() {

        String secret = System.getenv("JWT_SECRET");

        if (secret == null || secret.isBlank()) {
            throw new IllegalStateException(
                    "La variable de entorno JWT_SECRET es obligatoria"
            );
        }

        return secret;
    }
}
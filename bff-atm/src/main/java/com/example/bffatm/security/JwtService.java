package com.example.bffatm.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;

@Service
public class JwtService {

    private final SecretKey key;

    public JwtService() {

        this.key = Keys.hmacShaKeyFor(
                JwtSecretProvider.getSecret().getBytes(StandardCharsets.UTF_8)
        );
    }

    public Claims validateAndGetClaims(String token) {

        return Jwts.parser()
                .verifyWith(key)
                .requireIssuer(JwtConstants.ISSUER)
                .requireAudience(JwtConstants.AUDIENCE)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
}

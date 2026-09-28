package com.example.bffweb.security;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

import java.nio.charset.StandardCharsets;
import java.util.Date;

public class JwtTokenGenerator {

    public static void main(String[] args) {

        String role = args.length > 0
                ? args[0].toUpperCase()
                : "WEB";

        String token = Jwts.builder()
                .subject("usuario-prueba")
                .issuer(JwtConstants.ISSUER)
                .audience()
                    .add(JwtConstants.AUDIENCE)
                    .and()
                .claim("role", role)
                .issuedAt(new Date())
                .expiration(
                        new Date(
                                System.currentTimeMillis()
                                        + 60 * 60 * 1000
                        )
                )
                .signWith(
                        Keys.hmacShaKeyFor(
                                JwtSecretProvider.getSecret().getBytes(
                                        StandardCharsets.UTF_8
                                )
                        ),
                        Jwts.SIG.HS256
                )
                .compact();

        System.out.println(token);
    }
}

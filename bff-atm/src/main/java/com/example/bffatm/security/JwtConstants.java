package com.example.bffatm.security;

public final class JwtConstants {

    private JwtConstants() {
    }

    public static final String SECRET =
            "BackendIII-BancoXYZ-Semana5-ClaveJWT-Segura-2026";

    public static final String ISSUER =
            "bank-legacy-migration";

    public static final String AUDIENCE =
            "bff-atm";
}

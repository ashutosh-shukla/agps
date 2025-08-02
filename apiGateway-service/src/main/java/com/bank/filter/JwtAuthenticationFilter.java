package com.bank.filter;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@Component
public class JwtAuthenticationFilter extends AbstractGatewayFilterFactory<JwtAuthenticationFilter.Config> {

    @Value("${jwt.secret:mySecretKey12345678901234567890123456789012345678901234567890}")
    private String secret;

    private final ObjectMapper objectMapper = new ObjectMapper();

    public JwtAuthenticationFilter() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            ServerHttpRequest request = exchange.getRequest();
            
            // Check if Authorization header exists
            String authHeader = request.getHeaders().getFirst("Authorization");
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return handleUnauthorized(exchange, "Missing or invalid authorization header");
            }

            String token = authHeader.substring(7); // Remove "Bearer " prefix

            try {
                // Validate token and extract claims
                Claims claims = validateToken(token);
                if (claims == null) {
                    return handleUnauthorized(exchange, "Invalid or expired token");
                }

                // Extract user information from token
                String userId = claims.get("userId", String.class);
                String email = claims.get("email", String.class);
                String role = claims.get("role", String.class);
                String firstName = claims.get("firstName", String.class);
                String lastName = claims.get("lastName", String.class);

                // Check role-based access if required
                if (config.getRequiredRole() != null && !config.getRequiredRole().equals(role)) {
                    return handleForbidden(exchange, "Insufficient permissions");
                }

                // Add user information to request headers for downstream services
                ServerHttpRequest modifiedRequest = request.mutate()
                    .header("X-User-Id", userId)
                    .header("X-User-Email", email)
                    .header("X-User-Role", role)
                    .header("X-User-FirstName", firstName)
                    .header("X-User-LastName", lastName)
                    .build();

                return chain.filter(exchange.mutate().request(modifiedRequest).build());

            } catch (Exception e) {
                return handleUnauthorized(exchange, "Token validation failed: " + e.getMessage());
            }
        };
    }

    private Claims validateToken(String token) {
        try {
            SecretKey key = Keys.hmacShaKeyFor(secret.getBytes());
            return Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            return null;
        }
    }

    private Mono<Void> handleUnauthorized(ServerWebExchange exchange, String message) {
        return handleErrorResponse(exchange, HttpStatus.UNAUTHORIZED, message);
    }

    private Mono<Void> handleForbidden(ServerWebExchange exchange, String message) {
        return handleErrorResponse(exchange, HttpStatus.FORBIDDEN, message);
    }

    private Mono<Void> handleErrorResponse(ServerWebExchange exchange, HttpStatus status, String message) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(status);
        response.getHeaders().add("Content-Type", MediaType.APPLICATION_JSON_VALUE);

        Map<String, Object> errorResponse = Map.of(
            "error", true,
            "message", message,
            "status", status.value(),
            "timestamp", System.currentTimeMillis()
        );

        try {
            String responseBody = objectMapper.writeValueAsString(errorResponse);
            DataBuffer buffer = response.bufferFactory().wrap(responseBody.getBytes(StandardCharsets.UTF_8));
            return response.writeWith(Mono.just(buffer));
        } catch (JsonProcessingException e) {
            return response.setComplete();
        }
    }

    public static class Config {
        private String requiredRole;

        public String getRequiredRole() {
            return requiredRole;
        }

        public void setRequiredRole(String requiredRole) {
            this.requiredRole = requiredRole;
        }
    }
}
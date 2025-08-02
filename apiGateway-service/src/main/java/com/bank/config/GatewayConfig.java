package com.bank.config;

import com.bank.filter.JwtAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GatewayConfig {

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                // Auth Service Routes (Public - No JWT Filter)
                .route("auth-service", r -> r
                        .path("/auth/**")
                        .uri("lb://auth-service"))
                
                // Customer Registration Route (Public - No JWT Filter)
                .route("customer-registration", r -> r
                        .path("/customers/register")
                        .uri("lb://customer-service"))
                
                // Customer Validation Route (Public - Used by Auth Service)
                .route("customer-validation", r -> r
                        .path("/customers/validate-credentials")
                        .uri("lb://customer-service"))
                
                // Customer Service Routes (Protected - Requires JWT)
                .route("customer-service-protected", r -> r
                        .path("/customers/**")
                        .filters(f -> f.filter(jwtAuthenticationFilter.apply(new JwtAuthenticationFilter.Config())))
                        .uri("lb://customer-service"))
                
                // KYC Service Routes (Protected - Requires JWT)
                .route("kyc-service", r -> r
                        .path("/kyc/api/**")
                        .filters(f -> f.filter(jwtAuthenticationFilter.apply(new JwtAuthenticationFilter.Config())))
                        .uri("lb://kyc-service"))
                
                // Account Service Routes (Protected - Requires JWT)
                .route("account-service", r -> r
                        .path("/account-api/**")
                        .filters(f -> f.filter(jwtAuthenticationFilter.apply(new JwtAuthenticationFilter.Config())))
                        .uri("lb://account-service"))
                
                // Admin Service Routes (Protected - Requires JWT with ADMIN role)
                .route("admin-service", r -> r
                        .path("/admin/**")
                        .filters(f -> {
                            JwtAuthenticationFilter.Config config = new JwtAuthenticationFilter.Config();
                            config.setRequiredRole("ADMIN");
                            return f.filter(jwtAuthenticationFilter.apply(config));
                        })
                        .uri("lb://admin-service"))
                
                // Health check routes (Public)
                .route("auth-health", r -> r
                        .path("/health/auth")
                        .filters(f -> f.rewritePath("/health/auth", "/auth/health"))
                        .uri("lb://auth-service"))
                
                .route("customer-health", r -> r
                        .path("/health/customer")
                        .filters(f -> f.rewritePath("/health/customer", "/customers/hello"))
                        .uri("lb://customer-service"))
                
                .route("kyc-health", r -> r
                        .path("/health/kyc")
                        .filters(f -> f.rewritePath("/health/kyc", "/kyc/api/health"))
                        .uri("lb://kyc-service"))
                
                .route("account-health", r -> r
                        .path("/health/account")
                        .filters(f -> f.rewritePath("/health/account", "/account-api/accounts/health"))
                        .uri("lb://account-service"))
                
                .route("admin-health", r -> r
                        .path("/health/admin")
                        .filters(f -> f.rewritePath("/health/admin", "/admin/api/health"))
                        .uri("lb://admin-service"))
                
                .build();
    }
}

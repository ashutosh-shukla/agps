package com.bank.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import io.swagger.v3.oas.annotations.servers.Server;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
    info = @Info(
        title = "AGPS Bank - SecureBank API Gateway",
        version = "v1.0",
        description = "Complete Banking Application with JWT Authentication, KYC Management, and Admin Panel",
        contact = @Contact(
            name = "AGPS Bank Development Team",
            email = "support@agpsbank.com",
            url = "https://agpsbank.com"
        ),
        license = @License(
            name = "MIT License",
            url = "https://opensource.org/licenses/MIT"
        )
    ),
    servers = {
        @Server(url = "http://localhost:8080", description = "Development Server"),
        @Server(url = "https://api.agpsbank.com", description = "Production Server")
    }
)
@SecurityScheme(
    name = "Bearer Authentication",
    type = SecuritySchemeType.HTTP,
    bearerFormat = "JWT",
    scheme = "bearer",
    description = "JWT Bearer token for authentication. Get token from /auth/login endpoint."
)
public class SwaggerConfig {

    @Bean
    public GroupedOpenApi authServiceApi() {
        return GroupedOpenApi.builder()
                .group("01-authentication-service")
                .displayName("🔐 Authentication Service")
                .pathsToMatch("/auth/**")
                .build();
    }

    @Bean
    public GroupedOpenApi customerServiceApi() {
        return GroupedOpenApi.builder()
                .group("02-customer-service")
                .displayName("👤 Customer Service")
                .pathsToMatch("/customers/**", "/customer-api/**")
                .build();
    }

    @Bean
    public GroupedOpenApi adminServiceApi() {
        return GroupedOpenApi.builder()
                .group("03-admin-service")
                .displayName("👨‍💼 Admin Service")
                .pathsToMatch("/admin/**")
                .build();
    }

    @Bean
    public GroupedOpenApi kycServiceApi() {
        return GroupedOpenApi.builder()
                .group("04-kyc-service")
                .displayName("📄 KYC Service")
                .pathsToMatch("/kyc/**")
                .build();
    }

    @Bean
    public GroupedOpenApi accountServiceApi() {
        return GroupedOpenApi.builder()
                .group("05-account-service")
                .displayName("🏦 Account Service")
                .pathsToMatch("/account-api/**", "/accounts/**")
                .build();
    }

    @Bean
    public GroupedOpenApi healthCheckApi() {
        return GroupedOpenApi.builder()
                .group("06-health-monitoring")
                .displayName("❤️ Health & Monitoring")
                .pathsToMatch("/health/**", "/actuator/**")
                .build();
    }

    @Bean
    public GroupedOpenApi allServicesApi() {
        return GroupedOpenApi.builder()
                .group("00-all-services")
                .displayName("🌐 All Services")
                .pathsToMatch("/**")
                .pathsToExclude("/swagger-ui/**", "/v3/api-docs/**")
                .build();
    }
}
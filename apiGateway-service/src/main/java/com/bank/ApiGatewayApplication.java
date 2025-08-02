package com.bank;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

//exclude DataSourceAutoConfiguration to avoid issues with missing database configuration
//bcause this is a gateway service that does not require a database

@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})  
@EnableDiscoveryClient

public class ApiGatewayApplication {
    public static void main(String[] args) {
        SpringApplication.run(ApiGatewayApplication.class, args);
    }
}

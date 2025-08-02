package com.bank.service;

import com.bank.dto.CustomerValidationRequest;
import com.bank.dto.CustomerValidationResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "customer-service")
public interface CustomerServiceProxy {

    @PostMapping("/customers/validate-credentials")
    CustomerValidationResponse validateCustomerCredentials(@RequestBody CustomerValidationRequest request);
}
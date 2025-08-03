package com.bank.proxy;

import java.util.List;
import java.util.Map;

import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.bank.model.Customer;

@FeignClient(name = "CUSTOMER-SERVICE", url = "http://localhost:8081/customer-api",path = "/customer-api")
public interface CustomerProxy {

    @GetMapping("/all")
    List<Customer> getAllCustomers();

    @GetMapping("/{id}")
    Customer getCustomerById(@PathVariable("id") String id);

    @PutMapping("/{customerId}/status")
    Customer updateCustomerStatus(@PathVariable("customerId") String customerId, @RequestBody Map<String, String> statusUpdate);

    @PutMapping("/{customerId}/kyc-status")
    Customer updateCustomerKycStatus(@PathVariable("customerId") String customerId, @RequestBody Map<String, String> kycStatusUpdate);
}

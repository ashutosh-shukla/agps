package com.bank.proxy;

import java.util.List;

import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.bank.model.Account;
import com.bank.model.Customer;

@FeignClient(name = "ACCOUNT-SERVICE", url = "http://localhost:8082/account-api",path = "/account-api")
public interface AccountProxy {

    @GetMapping("/customer/{customerId}")
    List<Account> getAccountsByCustomerId(@PathVariable("customerId") String customerId);

    @GetMapping("/all")
    List<Account> getAllAccounts();

    @PostMapping("/{customerId}/activate")
    void activateAccount(@PathVariable("customerId") String customerId);

    @PostMapping("/{customerId}/deactivate")
    void deactivateAccount(@PathVariable("customerId") String customerId);
}

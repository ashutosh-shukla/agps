package com.bank.proxy;

import java.util.List;

import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.bank.model.Account;
import com.bank.model.Customer;

@FeignClient(name = "ACCOUNT-SERVICE", url = "http://localhost:8082/account-api",path = "/account-api")
public interface AccountProxy {

	 @GetMapping("/customer/{customerId}")
	    List<Account> getAccountsByCustomerId(@PathVariable("customerId") String customerId);
}

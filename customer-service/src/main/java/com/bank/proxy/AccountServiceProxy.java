package com.bank.proxy;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bank.model.Account;
import com.bank.model.Transaction;


@FeignClient(name = "account-service", path = "/account-api")
public interface AccountServiceProxy {
	
	 @GetMapping("/health")
	    String healthCheck();
	
	     // ---- AccountController endpoints ----

	     @GetMapping("/accounts/{customerId}")
	     Account getAccountByCustomerId(@PathVariable String customerId);

	     @PostMapping("/accounts/{customerId}/deposit")
	     void deposit(@PathVariable String customerId, @RequestParam BigDecimal amount);

	     @PostMapping("/accounts/{customerId}/withdraw")
	     void withdraw(@PathVariable String customerId, @RequestParam BigDecimal amount);

	     @PostMapping("/accounts/{customerId}/transfer")
	     void transfer(@PathVariable String customerId,
	                   @RequestParam String toAccountNumber,
	                   @RequestParam BigDecimal amount);

	  

	     // ---- TransactionController endpoints ----

	     @GetMapping("/transactions/{customerId}")
	     List<Transaction> getTransactionHistory(@PathVariable String customerId);
	 }


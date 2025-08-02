package com.bank.controller;

import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.bank.model.Account;
import com.bank.services.AccountService;

@RestController
@RequestMapping("/account-api/accounts")
public class AccountController {

	@Autowired
	private AccountService accountService;
	
	@Autowired
	private Environment environment;
	
	@GetMapping("/hellobro")
	public String hellobro() {
		return "Hello from Account Service!";
		
	}
	

    @GetMapping("/health")
    public String healthCheck() {
        return "Account Service is UP";
    }
   

    @GetMapping("/by-customer/{customerId}")
    public Account getByCustomerId(@PathVariable String customerId) {
        return accountService.getAccountByCustomerId(customerId);
    }

    @GetMapping("/by-account/{accountNumber}")
    public Account getByAccountNumber(@PathVariable String accountNumber) {
        return accountService.getAccountByAccountNumber(accountNumber);
    }

    @PutMapping("/deposit")
    public String deposit(@RequestParam String customerId, @RequestParam BigDecimal amount) {
        accountService.deposit(customerId, amount);
        return "Amount deposited successfully.";
    }

    @PutMapping("/withdraw")
    public String withdraw(@RequestParam String customerId, @RequestParam BigDecimal amount) {
        accountService.withdraw(customerId, amount);
        return "Amount withdrawn successfully.";
    }

    @PutMapping("/transfer")
    public String transfer(@RequestParam String fromCustomerId,
                           @RequestParam String toAccountNumber,
                           @RequestParam BigDecimal amount) {
        accountService.transfer(fromCustomerId, toAccountNumber, amount);
        return "Amount transferred successfully.";
    }

    @PutMapping("/update")
    public String updateAccount(@RequestBody Account account) {
        accountService.updateAccount(account);
        return "Account updated successfully.";
    }
	
}


   



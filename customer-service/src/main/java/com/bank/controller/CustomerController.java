package com.bank.controller;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.bank.dto.CredentialValidationRequest;
import com.bank.dto.CredentialValidationResponse;
import com.bank.model.Account;
import com.bank.model.Customer;
import com.bank.model.Transaction;
import com.bank.proxy.AccountServiceProxy;
import com.bank.services.CustomerService;

import jakarta.validation.Valid;

import com.bank.config.*;
@RestController
@RequestMapping("/customers")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private AccountServiceProxy accountServiceProxy;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @GetMapping("/hello")
    public String hello() {
        return "Hello from Customer Service!";
    }

 // Add this method to your existing CustomerController class

   
    @PostMapping("/register")
    public ResponseEntity<Customer> registerCustomer(@RequestBody Customer customer) {
        try {
            Customer savedCustomer = customerService.createCustomer(customer);
            return ResponseEntity.ok(savedCustomer);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }}

    @GetMapping("/{customerId}")
    public Customer getCustomer(@PathVariable String customerId) {
        return customerService.getCustomer(customerId);
    }

    @PutMapping("/{customerId}")
    public Customer updateCustomer(@PathVariable String customerId, @RequestBody Customer customer) {
        return customerService.updateDetails(customerId, customer);
    }

    @PutMapping("/{customerId}/change-password")
    public void changePassword(@PathVariable String customerId,
                               @RequestParam String currentPassword,
                               @RequestParam String newPassword) {
        customerService.changePassword(customerId, currentPassword, newPassword);
    }

	    @PutMapping("/{customerId}/change-email")
	    public void changeEmail(@PathVariable String customerId, @RequestParam String newEmail) {
	        customerService.changeEmail(customerId, newEmail);
	    }

    // --- Account API calls ---

    @GetMapping("/{customerId}/account")
    public Account getAccount(@PathVariable String customerId) {
        return accountServiceProxy.getAccountByCustomerId(customerId);
    }

    @PostMapping("/{customerId}/deposit")
    public void deposit(@PathVariable String customerId, @RequestParam BigDecimal amount) {
        accountServiceProxy.deposit(customerId, amount);
    }

    @PostMapping("/{customerId}/withdraw")
    public void withdraw(@PathVariable String customerId, @RequestParam BigDecimal amount) {
        accountServiceProxy.withdraw(customerId, amount);
    }

    @PostMapping("/{customerId}/transfer")
    public void transfer(@PathVariable String customerId,
                         @RequestParam String toAccountNumber,
                         @RequestParam BigDecimal amount) {
        accountServiceProxy.transfer(customerId, toAccountNumber, amount);
    }

    // --- Transaction API call ---

    @GetMapping("/{customerId}/transactions")
    public List<Transaction> getTransactionHistory(@PathVariable String customerId) {
        return accountServiceProxy.getTransactionHistory(customerId);
    }

    // --- Authentication API call ---

    @PostMapping("/validate-credentials")
    public ResponseEntity<Object> validateCredentials(@Valid @RequestBody CredentialValidationRequest request) {
        try {
            CredentialValidationResponse response = customerService.validateCredentials(request);
            if (response.isValid()) {
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
           return ResponseEntity
        .status(HttpStatus.BAD_REQUEST)
        .body(CredentialValidationResponse.error("Validation failed: " + e.getMessage()));

        }
    }
}
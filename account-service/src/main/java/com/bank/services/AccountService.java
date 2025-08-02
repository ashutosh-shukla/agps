package com.bank.services;



import java.math.BigDecimal;
import java.util.List;

import com.bank.model.Account;



public interface AccountService {
      Account getAccountByCustomerId(String customerId);
    void deposit(String customerId, BigDecimal amount);
    void withdraw(String customerId, BigDecimal amount);
    void transfer(String customerId, String toAccountNumber, BigDecimal amount);

   void updateAccount(Account account);
   Account getAccountByAccountNumber(String toAccountNumber);

   
    
}
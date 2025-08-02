package com.bank.services;



import java.math.BigDecimal;
import java.util.List;

import com.bank.model.Transaction;



public interface TransactionService {
       void deposit(String customerId, BigDecimal amount);
    void withdraw(String customerId, BigDecimal amount);
    void transfer(String fromCustomerId, String toAccountNumber, BigDecimal amount);
    List<Transaction> getTransactionHistory(String customerId);
}

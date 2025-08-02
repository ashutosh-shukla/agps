package com.bank.serviceImpl;



import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bank.dao.AccountDao;
import com.bank.dao.TransactionDao;
import com.bank.exception.CustomerUnavailableException;
import com.bank.model.Account;
import com.bank.model.Transaction;
import com.bank.services.TransactionService;

import jakarta.transaction.Transactional;

@Service
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TransactionDao transactionDao;  

    @Autowired
    private AccountDao accountDao;

    @Override
    @Transactional
    public void deposit(String customerId, BigDecimal amount) {
        Account account = accountDao.findByCustomerId(customerId);
        if (account == null) {
            throw new CustomerUnavailableException("Account not found for Customer ID: " + customerId);
        }

        account.setBalance(account.getBalance().add(amount));
        
        accountDao.update(account);

        Transaction txn = new Transaction(customerId, "DEPOSIT", amount, LocalDateTime.now(),"Self DEPOSIT");
       
        transactionDao.save(txn);
    }

    @Override
    @Transactional
    public void withdraw(String customerId, BigDecimal amount) {
        Account account = accountDao.findByCustomerId(customerId);
        if (account == null) {
            throw new CustomerUnavailableException("Account not found for Customer ID: " + customerId);
        }

        if (account.getBalance().compareTo(amount) < 0) {
            throw new IllegalArgumentException("Insufficient balance");
        }

        account.setBalance(account.getBalance().subtract(amount));
        accountDao.update(account);

        Transaction txn = new Transaction(customerId, "WITHDRAW", amount, LocalDateTime.now(),"Self Withdrawl");
         
        transactionDao.save(txn);
    }

    @Override
    @Transactional
    public void transfer(String fromCustomerId, String toAccountNumber, BigDecimal amount) {
        Account fromAccount = accountDao.findByCustomerId(fromCustomerId);
        if (fromAccount == null) {
            throw new CustomerUnavailableException("Sender account not found");
        }

        Account toAccount = accountDao.findByAccountNumber(toAccountNumber);
        if (toAccount == null) {
            throw new CustomerUnavailableException("Receiver account not found");
        }

        if (fromAccount.getBalance().compareTo(amount) < 0) {
            throw new IllegalArgumentException("Insufficient balance for transfer");
        }

        fromAccount.setBalance(fromAccount.getBalance().subtract(amount));
        toAccount.setBalance(toAccount.getBalance().add(amount));

        accountDao.update(fromAccount);
        accountDao.update(toAccount);

        Transaction txn = new Transaction(fromCustomerId, "TRANSFER", amount, LocalDateTime.now(), toAccountNumber);
        
        transactionDao.save(txn);
    }
     @Override
    public List<Transaction> getTransactionHistory(String customerId) {
        return transactionDao.findByCustomerId(customerId);
    }
}
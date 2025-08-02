package com.bank.serviceImpl;



import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bank.dao.AccountDao;
import com.bank.dao.TransactionDao;
import com.bank.model.Account;
import com.bank.model.Transaction;
import com.bank.services.AccountService;

@Service
public class AccountServiceImpl implements AccountService {
    
    @Autowired
    private AccountDao accountDao;

     @Autowired
    private TransactionDao transactionDao;

    @Override
    public Account getAccountByCustomerId(String customerId) {
        return accountDao.findByCustomerId(customerId);
    }

    @Override
    public void deposit(String customerId, BigDecimal amount) {
        Account account = accountDao.findByCustomerId(customerId);
        account.setBalance(account.getBalance().add(amount));
        
        accountDao.update(account);

        Transaction txn = new Transaction(customerId, "DEPOSIT", amount, LocalDateTime.now(),"SELF DEPOSIT");
		 // Generate a random transaction ID
        transactionDao.save(txn);
    }

    @Override
    public void withdraw(String customerId, BigDecimal amount) {
        Account account = accountDao.findByCustomerId(customerId);
        if (account.getBalance().compareTo(amount) < 0) {
            throw new RuntimeException("Insufficient balance");
        }
        account.setBalance(account.getBalance().subtract(amount));
        accountDao.update(account);

        Transaction txn = new Transaction(customerId, "WITHDRAW", amount, LocalDateTime.now(),"SELF WITHDRAW");
        transactionDao.save(txn);
    }

    @Override
    public void transfer(String customerId, String toAccountNumber, BigDecimal amount) {
        Account fromAccount = accountDao.findByCustomerId(customerId);
        Account toAccount = accountDao.findByAccountNumber(toAccountNumber);

        if (fromAccount.getBalance().compareTo(amount) < 0) {
            throw new RuntimeException("Insufficient balance");
        }

        fromAccount.setBalance(fromAccount.getBalance().subtract(amount));
        toAccount.setBalance(toAccount.getBalance().add(amount));

        accountDao.update(fromAccount);
        accountDao.update(toAccount);

        Transaction txn = new Transaction(customerId, "TRANSFER", amount, LocalDateTime.now(),toAccountNumber);
        transactionDao.save(txn);
    }

    //this is getting used in api calling 

    public void updateAccount(Account account) {
    accountDao.update(account);
}

    @Override
    public Account getAccountByAccountNumber(String toAccountNumber) {
    Account account = accountDao.findByAccountNumber(toAccountNumber);
    if (account != null) {
        return account;
    }
    
        throw new UnsupportedOperationException("Unimplemented method 'getAccountByAccountNumber'");
    }


}

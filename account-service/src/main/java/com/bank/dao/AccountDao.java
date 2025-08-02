package com.bank.dao;



import java.util.List;


import com.bank.model.Account;

public interface AccountDao {

    Account save(Account account);
    Account findByAccountNumber(String accountNumber);
    Account findByCustomerId(String customerId);
    void update(Account account);
    Account getAccountByAccountNumber(String accountNumber);
}

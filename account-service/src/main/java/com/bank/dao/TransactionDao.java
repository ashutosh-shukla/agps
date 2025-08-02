package com.bank.dao;


import java.util.List;

import com.bank.model.Transaction;


public interface TransactionDao {

    void save(Transaction transaction);
    List<Transaction> findByCustomerId(String customerId);
}

package com.bank.services;

import com.bank.model.Account;
import com.bank.model.Customer;
import com.bank.model.KYCDocument;

import java.util.List;

public interface AdminService {

    List<Customer> getAllCustomers();

    Customer getCustomerById(String customerId);

    List<Account> getAccountsByCustomerId(String customerId);

    List<KYCDocument> getKycDocuments(String customerId);
}

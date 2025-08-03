package com.bank.services;

import com.bank.model.Account;
import com.bank.model.Customer;
import com.bank.model.KYCDocument;

import java.util.List;

public interface AdminService {

    // Customer Management
    List<Customer> getAllCustomers();
    Customer getCustomerById(String customerId);
    Customer updateCustomerStatus(String customerId, String status);
    Customer updateCustomerKycStatus(String customerId, String kycStatus);

    // Account Management
    List<Account> getAccountsByCustomerId(String customerId);
    List<Account> getAllAccounts();
    void activateCustomerAccount(String customerId);
    void deactivateCustomerAccount(String customerId);

    // KYC Management
    List<KYCDocument> getKycDocuments(String customerId);
    List<KYCDocument> getAllKycDocuments();
    KYCDocument getKycDocumentById(Long id);
    KYCDocument updateKycStatus(Long id, String status, String remarks);
}

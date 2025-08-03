package com.bank.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bank.model.Account;
import com.bank.model.Customer;
import com.bank.model.KYCDocument;
import com.bank.proxy.AccountProxy;
import com.bank.proxy.CustomerProxy;
import com.bank.proxy.KYCProxy;
import com.bank.services.AdminService;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private CustomerProxy customerProxy;

    @Autowired
    private AccountProxy accountProxy;

    @Autowired
    private KYCProxy kycProxy;

    // Customer Management Implementation
    @Override
    public List<Customer> getAllCustomers() {
        return customerProxy.getAllCustomers();
    }

    @Override
    public Customer getCustomerById(String customerId) {
        return customerProxy.getCustomerById(customerId);
    }

    @Override
    public Customer updateCustomerStatus(String customerId, String status) {
        return customerProxy.updateCustomerStatus(customerId, status);
    }

    @Override
    public Customer updateCustomerKycStatus(String customerId, String kycStatus) {
        return customerProxy.updateCustomerKycStatus(customerId, kycStatus);
    }

    // Account Management Implementation
    @Override
    public List<Account> getAccountsByCustomerId(String customerId) {
        return accountProxy.getAccountsByCustomerId(customerId);
    }

    @Override
    public List<Account> getAllAccounts() {
        return accountProxy.getAllAccounts();
    }

    @Override
    public void activateCustomerAccount(String customerId) {
        accountProxy.activateAccount(customerId);
    }

    @Override
    public void deactivateCustomerAccount(String customerId) {
        accountProxy.deactivateAccount(customerId);
    }

    // KYC Management Implementation
    @Override
    public List<KYCDocument> getKycDocuments(String customerId) {
        return kycProxy.getDocumentsByCustomerId(customerId);
    }

    @Override
    public List<KYCDocument> getAllKycDocuments() {
        return kycProxy.getAllDocuments();
    }

    @Override
    public KYCDocument getKycDocumentById(Long id) {
        return kycProxy.getDocumentById(id);
    }

    @Override
    public KYCDocument updateKycStatus(Long id, String status, String remarks) {
        return kycProxy.updateDocumentStatus(id, status, remarks);
    }
}
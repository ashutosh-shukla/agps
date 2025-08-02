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
	
	@Override
	public List<Customer> getAllCustomers() {
		return customerProxy.getAllCustomers();		
	}

	@Override
	public Customer getCustomerById(String customerId) {
		return customerProxy.getCustomerById(customerId);
	}

	@Override
	public List<Account> getAccountsByCustomerId(String customerId) {
		return accountProxy.getAccountsByCustomerId(customerId);
	}

@Override
public List<KYCDocument> getKycDocuments(String customerId) {
	return kycProxy.getDocumentsByCustomerId(customerId);
}}
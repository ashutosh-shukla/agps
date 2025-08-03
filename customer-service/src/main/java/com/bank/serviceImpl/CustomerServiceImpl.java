package com.bank.serviceImpl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bank.dao.CustomerDao;
import com.bank.dto.CredentialValidationRequest;
import com.bank.dto.CredentialValidationResponse;
import com.bank.exception.CustomerNotFoundException;
import com.bank.model.Customer;
import com.bank.services.CustomerService;
import com.bank.utils.PasswordUtil;
import com.bank.exception.CustomerAlreadyExistsException;

@Service
public class CustomerServiceImpl implements CustomerService{
    @Autowired
    private CustomerDao customerDao;
    
    @Override
    public Customer createCustomer(Customer customer) {
        if (customer.getPassword() == null || customer.getPassword().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        } 
        if (customerDao.existsByEmail(customer.getEmail())) {
            throw new CustomerAlreadyExistsException("Email already exists");
        }
        String encryptedPassword = PasswordUtil.encodePassword(customer.getPassword());
        customer.setPassword(encryptedPassword);
        customer.setStatus("PENDING");
        customer.setCreatedAt(LocalDateTime.now());
        customer.setUpdatedAt(LocalDateTime.now());
        customer.setRole("CUSTOMER");
        
        return customerDao.save(customer);
    }
    
    @Override
    public Customer updateDetails(String customerId, Customer updatedData) {
        Customer existingCustomer = customerDao.findById(customerId);
        if (existingCustomer == null) {
            throw new CustomerNotFoundException("Customer not found with ID: " + customerId);
        }

        // Update fields using business method in Customer entity
        existingCustomer.updateDetails(
            updatedData.getFirstName(),
            updatedData.getLastName(),
            updatedData.getAddress(),
            updatedData.getPhoneNumber()
        );

        // Optionally update other fields if needed (status etc.)
        existingCustomer.setStatus(updatedData.getStatus());
        existingCustomer.setUpdatedAt(LocalDateTime.now());

        // Save the updated customer in DB
        return customerDao.update(existingCustomer);
    }

    @Override
    public void changePassword(String customerId, String currentPassword, String newPassword) {
        Customer customer = customerDao.findById(customerId);
        if (customer == null) {
            throw new CustomerNotFoundException("Customer not found with ID: " + customerId);
        }

        // Check current password matches (assuming passwords are encrypted)
        if (!PasswordUtil.matches(currentPassword, customer.getPassword())) {
            throw new RuntimeException("Current password is incorrect");
        }

        // Encrypt the new password
        String encryptedPassword = PasswordUtil.encodePassword(newPassword);

        // Update password using DAO
        customerDao.updatePassword(customerId, encryptedPassword);
    }

    @Override
    public Customer getCustomer(String customerId) {
        Customer customer = customerDao.findById(customerId);
        if (customer == null) {
            throw new CustomerNotFoundException("Customer not found with ID: " + customerId);
        }
        return customer;
    }
   
    // This method is created by Ashutosh for updating customer details in dashboard
    @Override
    public void save(Customer customer) {
        customerDao.update(customer);
    }
    
    @Override
    public void changeEmail(String customerId, String newEmail) {
        Customer customer = customerDao.findById(customerId);
        customer.setEmail(newEmail);
        customer.setUpdatedAt(LocalDateTime.now());
        customerDao.update(customer);
    }

    @Override
    public Optional<Customer> findByEmail(String email) {
        return customerDao.findByEmail(email);
    }

    @Override
    public CredentialValidationResponse validateCredentials(CredentialValidationRequest request) {
        try {
            Optional<Customer> customerOpt = customerDao.findByEmail(request.getEmail());
            
            if (customerOpt.isPresent()) {
                Customer customer = customerOpt.get();
                
                // Check if password matches
                if (PasswordUtil.matches(request.getPassword(), customer.getPassword())) {
                    return CredentialValidationResponse.success(
                        customer.getCustomerId(),
                        customer.getEmail(),
                        customer.getFirstName(),
                        customer.getLastName(),
                        customer.getRole() != null ? customer.getRole() : "CUSTOMER"
                    );
                }
            }
            
            return (CredentialValidationResponse) CredentialValidationResponse.error("Invalid email or password");
        } catch (Exception e) {
            return (CredentialValidationResponse) CredentialValidationResponse.error("Validation failed: " + e.getMessage());
        }
    }

    // Admin operations implementation
    @Override
    public List<Customer> getAllCustomers() {
        return customerDao.findAll();
    }

    @Override
    public Customer updateCustomerStatus(String customerId, String status) {
        Customer customer = customerDao.findById(customerId);
        if (customer == null) {
            throw new CustomerNotFoundException("Customer not found with ID: " + customerId);
        }
        
        customer.setStatus(status);
        customer.setUpdatedAt(LocalDateTime.now());
        return customerDao.update(customer);
    }

    @Override
    public Customer updateCustomerKycStatus(String customerId, String kycStatus) {
        Customer customer = customerDao.findById(customerId);
        if (customer == null) {
            throw new CustomerNotFoundException("Customer not found with ID: " + customerId);
        }
        
        // You might want to add a kycStatus field to the Customer model
        // For now, we'll use a status field convention
        if ("APPROVED".equals(kycStatus)) {
            customer.setStatus("KYC_APPROVED");
        } else if ("REJECTED".equals(kycStatus)) {
            customer.setStatus("KYC_REJECTED");
        } else {
            customer.setStatus("KYC_PENDING");
        }
        
        customer.setUpdatedAt(LocalDateTime.now());
        return customerDao.update(customer);
    }
}  
   
   


package com.bank.dao;



import java.util.List;
import java.util.Optional;

import com.bank.model.Customer;



public interface CustomerDao {
      Customer save(Customer customer);
      List<Customer> findAll();  //this is for admin future use
      Customer update(Customer customer);
      Customer findById(String customerId);
      void updatePassword(String customerId, String newPassword);
      Optional<Customer> findByEmail(String email);
      //exception handling is done in service layer
      boolean existsByEmail(String email);

}

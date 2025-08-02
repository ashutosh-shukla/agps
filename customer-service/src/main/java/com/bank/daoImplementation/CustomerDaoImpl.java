package com.bank.daoImplementation;



import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import com.bank.dao.CustomerDao;
import com.bank.model.Customer;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;

@Repository
@Transactional
public class CustomerDaoImpl implements CustomerDao {

     @PersistenceContext
    private EntityManager entityManager;

    
    @Override
    public Customer save(Customer customer) {
        customer.setCreatedAt(LocalDateTime.now());
        customer.setUpdatedAt(LocalDateTime.now());
        entityManager.persist(customer);
        entityManager.flush();
        return customer;
    }
    @Override
    public Customer update(Customer customer) {
        return entityManager.merge(customer);
    }

    @Override
    public Customer findById(String customerId) {
        return entityManager.find(Customer.class, customerId);
    }

@Override
public void updatePassword(String customerId, String newPassword) {
    Customer customer = entityManager.find(Customer.class, customerId);
    if (customer != null) {
        customer.setPassword(newPassword);
        customer.setUpdatedAt(LocalDateTime.now());
        entityManager.merge(customer);
    }
}
    @Override
    public List<Customer> findAll() {
        String query = "SELECT c FROM Customer c";
        return entityManager.createQuery(query, Customer.class).getResultList();
    }
	@Override
	public boolean existsByEmail(String email) {
		 TypedQuery<Long> query = entityManager.createQuery(
		            "SELECT COUNT(c) FROM Customer c WHERE c.email = :email", Long.class);
		        query.setParameter("email", email);
		        Long count = query.getSingleResult();
		        return count > 0;
	}
	@Override
	public Optional<Customer> findByEmail(String email) {
				TypedQuery<Customer> query = entityManager.createQuery(
				"SELECT c FROM Customer c WHERE c.email = :email", Customer.class);
		query.setParameter("email", email);
		List<Customer> results = query.getResultList();
		return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
	}
   

}

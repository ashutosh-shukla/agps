package com.bank.daoImplementation;



import java.util.List;

import org.springframework.stereotype.Repository;

import com.bank.dao.TransactionDao;
import com.bank.model.Transaction;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;

@Repository
public class TransactionDaoImpl implements TransactionDao {

 @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Transactional
    public void save(Transaction transaction) {
        entityManager.persist(transaction);
    }

    @Override
    public List<Transaction> findByCustomerId(String customerId) {
        String jpql = "SELECT t FROM Transaction t WHERE t.customerId = :customerId ORDER BY t.date DESC";
        return entityManager.createQuery(jpql, Transaction.class)
                .setParameter("customerId", customerId)
                .getResultList();
    }   
}

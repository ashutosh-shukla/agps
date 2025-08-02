package com.bank.daoImplementation;



import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.bank.dao.AccountDao;
import com.bank.model.Account;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
@Repository
@Transactional
public class AccountDaoImpl implements AccountDao {

    @PersistenceContext
    private EntityManager entityManager;
    @Override
    public Account save(Account account) {
         entityManager.persist(account);
        return account;
    }

    @Override
    public Account findByCustomerId(String customerId) {
            try {
        return entityManager.createQuery(
            "SELECT a FROM Account a WHERE a.customerId = :customerId", Account.class)
            .setParameter("customerId", customerId)
            .getSingleResult();
    } catch (NoResultException e) {
        return null; // or throw AccountNotFoundException
    }
    }

    @Override
    public Account findByAccountNumber(String accountNumber) {
        return entityManager.createQuery("SELECT a FROM Account a WHERE a.accountNumber = :accountNumber", Account.class)
                .setParameter("accountNumber", accountNumber)
                .getSingleResult();
    }

    @Override
    public void update(Account account) {
        entityManager.merge(account);
    }

    @Override
    public Account getAccountByAccountNumber(String accountNumber) {
        try {
            return entityManager.createQuery("SELECT a FROM Account a WHERE a.accountNumber = :accountNumber", Account.class)
                    .setParameter("accountNumber", accountNumber)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null; // or throw AccountNotFoundException
        }
    }
}

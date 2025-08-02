package com.bank.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Transaction {

    private Long transactionId;
    private String customerId;
    private String type;         // DEPOSIT, WITHDRAW, TRANSFER
    private BigDecimal amount;
    private LocalDateTime date;
    private String toAccount;    // For transfers, else null

    // Constructors
    public Transaction() {}

    public Transaction(String customerId, String type, BigDecimal amount, LocalDateTime date) {
        this.customerId = customerId;
        this.type = type;
        this.amount = amount;
        this.date = date;
    }

    public Transaction(String customerId, String type, BigDecimal amount, LocalDateTime date, String toAccount) {
        this.customerId = customerId;
        this.type = type;
        this.amount = amount;
        this.date = date;
        this.toAccount = toAccount;
    }

    // Getters and Setters
    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public String getToAccount() {
        return toAccount;
    }

    public void setToAccount(String toAccount) {
        this.toAccount = toAccount;
    }
}

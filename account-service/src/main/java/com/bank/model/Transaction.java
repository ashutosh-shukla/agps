package com.bank.model;


import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;



@Entity
@Table(name = "BANK_TRANSACTIONS")
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "txn_seq_gen")
    @SequenceGenerator(
    name = "txn_seq_gen",
    sequenceName = "TXN_SEQ",
    initialValue = 1,
    allocationSize = 1)

    private Long transactionId;


    @Column(nullable = false)
    private String customerId;

    @Column(nullable = false, length = 20)
    private String type;   // DEPOSIT, WITHDRAW, TRANSFER

    @Column(nullable = false, precision = 15, scale = 2)
    private BigDecimal amount;

   @Column(name = "transaction_date", nullable = false)
    private LocalDateTime date;


    @Column(length = 20)
    private String toAccount;  // For transfers, else null

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
    public Long getTransactionId() { return transactionId; }

    public void setTransactionId(Long transactionId) { this.transactionId = transactionId; }

    public String getCustomerId() { return customerId; }

    public void setCustomerId(String customerId) { this.customerId = customerId; }

    public String getType() { return type; }

    public void setType(String type) { this.type = type; }

    public BigDecimal getAmount() { return amount; }

    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public LocalDateTime getDate() { return date; }

    public void setDate(LocalDateTime date) { this.date = date; }

    public String getToAccount() { return toAccount; }

    public void setToAccount(String toAccount) { this.toAccount = toAccount; }
}

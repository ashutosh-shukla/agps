package com.bank.controller;


import com.bank.model.Transaction;
import com.bank.services.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/account-api/transactions")
public class TransactionController {

    @Autowired
    private TransactionService transactionService;

    @GetMapping("/{customerId}")
    public List<Transaction> getTransactionHistory(@PathVariable String customerId) {
        return transactionService.getTransactionHistory(customerId);
    }

    // Optional: to test transaction methods independently if needed

    @PostMapping("/deposit")
    public String testDeposit(@RequestParam String customerId, @RequestParam BigDecimal amount) {
        transactionService.deposit(customerId, amount);
        return "Transaction - deposit recorded.";
    }

    @PostMapping("/withdraw")
    public String testWithdraw(@RequestParam String customerId, @RequestParam BigDecimal amount) {
        transactionService.withdraw(customerId, amount);
        return "Transaction - withdrawal recorded.";
    }

    @PostMapping("/transfer")
    public String testTransfer(@RequestParam String fromCustomerId,
                               @RequestParam String toAccountNumber,
                               @RequestParam BigDecimal amount) {
        transactionService.transfer(fromCustomerId, toAccountNumber, amount);
        return "Transaction - transfer recorded.";
    }
}

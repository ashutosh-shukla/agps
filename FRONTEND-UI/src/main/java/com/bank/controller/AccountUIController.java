package com.bank.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bank.model.Transaction;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/customers")
public class AccountUIController {

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private CustomerUIController customerUIController;

    private static final String API_GATEWAY_URL = "http://localhost:8080";

    // Deposit Page
    @GetMapping("/depositPage/{customerId}")
    public String showDepositPage(@PathVariable String customerId, Model model, RedirectAttributes redirectAttributes) {
        if (!customerUIController.isCustomerApproved(customerId)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Account not approved or active.");
            return "redirect:/customer/dashboard/" + customerId;
        }
        
        // Get account details for balance display
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity(
                API_GATEWAY_URL + "/account-api/accounts/by-customer/" + customerId, Map.class);
            if (response.getStatusCode() == HttpStatus.OK) {
                model.addAttribute("account", response.getBody());
            }
        } catch (Exception e) {
            model.addAttribute("error", "Unable to load account details");
        }
        
        model.addAttribute("customerId", customerId);
        return "deposit";
    }

    @PostMapping("/deposit/{customerId}")
    public String processDeposit(@PathVariable String customerId,
                                @RequestParam BigDecimal amount,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        try {
            if (!customerUIController.isCustomerApproved(customerId)) {
                model.addAttribute("error", "Unauthorized access");
                model.addAttribute("customerId", customerId);
                return "deposit";
            }

            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                model.addAttribute("error", "Amount must be greater than zero");
                model.addAttribute("customerId", customerId);
                loadAccountDetails(customerId, model);
                return "deposit";
            }

            if (amount.compareTo(new BigDecimal("100000")) > 0) {
                model.addAttribute("error", "Maximum deposit limit is ₹1,00,000");
                model.addAttribute("customerId", customerId);
                loadAccountDetails(customerId, model);
                return "deposit";
            }

            String url = API_GATEWAY_URL + "/account-api/accounts/deposit?customerId=" + customerId + "&amount=" + amount;
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.PUT, null, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                model.addAttribute("success", "₹" + amount + " deposited successfully!");
            } else {
                model.addAttribute("error", "Deposit failed. Please try again.");
            }

        } catch (Exception e) {
            model.addAttribute("error", "Deposit failed: " + e.getMessage());
        }

        model.addAttribute("customerId", customerId);
        loadAccountDetails(customerId, model);
        return "deposit";
    }

    // Withdrawal Page
    @GetMapping("/withdrawlPage/{customerId}")
    public String showWithdrawalPage(@PathVariable String customerId, Model model, RedirectAttributes redirectAttributes) {
        if (!customerUIController.isCustomerApproved(customerId)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Account not approved or active.");
            return "redirect:/customer/dashboard/" + customerId;
        }
        
        // Get account details for balance display
        loadAccountDetails(customerId, model);
        model.addAttribute("customerId", customerId);
        return "withdrawl";
    }

    @PostMapping("/withdraw/{customerId}")
    public String processWithdrawal(@PathVariable String customerId,
                                   @RequestParam BigDecimal amount,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        try {
            if (!customerUIController.isCustomerApproved(customerId)) {
                model.addAttribute("error", "Unauthorized access");
                model.addAttribute("customerId", customerId);
                loadAccountDetails(customerId, model);
                return "withdrawl";
            }

            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                model.addAttribute("error", "Amount must be greater than zero");
                model.addAttribute("customerId", customerId);
                loadAccountDetails(customerId, model);
                return "withdrawl";
            }

            if (amount.compareTo(new BigDecimal("50000")) > 0) {
                model.addAttribute("error", "Maximum withdrawal limit is ₹50,000 per transaction");
                model.addAttribute("customerId", customerId);
                loadAccountDetails(customerId, model);
                return "withdrawl";
            }

            String url = API_GATEWAY_URL + "/account-api/accounts/withdraw?customerId=" + customerId + "&amount=" + amount;
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.PUT, null, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                model.addAttribute("success", "₹" + amount + " withdrawn successfully!");
            } else {
                model.addAttribute("error", "Withdrawal failed. Insufficient balance or other error.");
            }

        } catch (Exception e) {
            String errorMessage = e.getMessage();
            if (errorMessage.contains("Insufficient")) {
                model.addAttribute("error", "Insufficient balance for withdrawal");
            } else {
                model.addAttribute("error", "Withdrawal failed: " + errorMessage);
            }
        }

        model.addAttribute("customerId", customerId);
        loadAccountDetails(customerId, model);
        return "withdrawl";
    }

    // Transfer Page
    @GetMapping("/transferPage/{customerId}")
    public String showTransferPage(@PathVariable String customerId, Model model, RedirectAttributes redirectAttributes) {
        if (!customerUIController.isCustomerApproved(customerId)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Account not approved or active.");
            return "redirect:/customer/dashboard/" + customerId;
        }
        
        // Get account details for balance display
        loadAccountDetails(customerId, model);
        model.addAttribute("customerId", customerId);
        return "transfer";
    }

    @PostMapping("/transfer/{customerId}")
    public String processTransfer(@PathVariable String customerId,
                                 @RequestParam String toAccountNumber,
                                 @RequestParam BigDecimal amount,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {
        try {
            if (!customerUIController.isCustomerApproved(customerId)) {
                model.addAttribute("error", "Unauthorized access");
                model.addAttribute("customerId", customerId);
                loadAccountDetails(customerId, model);
                return "transfer";
            }

            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                model.addAttribute("error", "Amount must be greater than zero");
                model.addAttribute("customerId", customerId);
                loadAccountDetails(customerId, model);
                return "transfer";
            }

            if (amount.compareTo(new BigDecimal("100000")) > 0) {
                model.addAttribute("error", "Maximum transfer limit is ₹1,00,000");
                model.addAttribute("customerId", customerId);
                loadAccountDetails(customerId, model);
                return "transfer";
            }

            if (toAccountNumber == null || toAccountNumber.trim().isEmpty()) {
                model.addAttribute("error", "Please enter a valid account number");
                model.addAttribute("customerId", customerId);
                loadAccountDetails(customerId, model);
                return "transfer";
            }

            // Check if target account exists
            try {
                ResponseEntity<Map> targetAccountResponse = restTemplate.getForEntity(
                    API_GATEWAY_URL + "/account-api/accounts/by-account/" + toAccountNumber, Map.class);
                if (targetAccountResponse.getStatusCode() != HttpStatus.OK) {
                    model.addAttribute("error", "Target account not found");
                    model.addAttribute("customerId", customerId);
                    loadAccountDetails(customerId, model);
                    return "transfer";
                }
            } catch (Exception e) {
                model.addAttribute("error", "Target account not found or invalid");
                model.addAttribute("customerId", customerId);
                loadAccountDetails(customerId, model);
                return "transfer";
            }

            String url = API_GATEWAY_URL + "/account-api/accounts/transfer?fromCustomerId=" + customerId +
                        "&toAccountNumber=" + toAccountNumber + "&amount=" + amount;
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.PUT, null, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                model.addAttribute("success", "₹" + amount + " transferred successfully to account " + toAccountNumber);
            } else {
                model.addAttribute("error", "Transfer failed. Please check account details and balance.");
            }

        } catch (Exception e) {
            String errorMessage = e.getMessage();
            if (errorMessage.contains("Insufficient")) {
                model.addAttribute("error", "Insufficient balance for transfer");
            } else if (errorMessage.contains("not found")) {
                model.addAttribute("error", "Target account not found");
            } else {
                model.addAttribute("error", "Transfer failed: " + errorMessage);
            }
        }

        model.addAttribute("customerId", customerId);
        loadAccountDetails(customerId, model);
        return "transfer";
    }

    // Transaction History
    @GetMapping("/transactionHistory/{customerId}")
    public String showTransactionHistory(@PathVariable String customerId,
                                         Model model,
                                         RedirectAttributes redirectAttributes) {

        if (!customerUIController.isCustomerApproved(customerId)) {
            redirectAttributes.addFlashAttribute("error", "Access denied. Account not approved or active.");
            return "redirect:/customer/dashboard/" + customerId;
        }

        try {
            ResponseEntity<Transaction[]> response = restTemplate.getForEntity(
                    API_GATEWAY_URL + "/account-api/transactions/" + customerId, Transaction[].class);

            if (response.getStatusCode() == HttpStatus.OK) {
                Transaction[] transactions = response.getBody();

                model.addAttribute("transactions", transactions);

                if (transactions == null || transactions.length == 0) {
                    model.addAttribute("noTransactions", true);
                    model.addAttribute("message", "No transactions found for your account");
                }
            } else {
                model.addAttribute("error", "Unable to fetch transaction history");
            }
        } catch (Exception e) {
            model.addAttribute("error", "Error fetching transaction history: " + e.getMessage());
        }

        model.addAttribute("customerId", customerId);
        return "transactionHistory";  // JSP name
    }


    // Helper method to load account details
    private void loadAccountDetails(String customerId, Model model) {
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity(
                API_GATEWAY_URL + "/account-api/accounts/by-customer/" + customerId, Map.class);
            if (response.getStatusCode() == HttpStatus.OK) {
                model.addAttribute("account", response.getBody());
            }
        } catch (Exception e) {
            // Silently handle - account details not critical for error display
        }
    }

    // Get Account Details (Helper method for other controllers)
    @GetMapping("/account/{customerId}")
    @ResponseBody
    public ResponseEntity<Map> getAccountDetails(@PathVariable String customerId) {
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity(
                API_GATEWAY_URL + "/account-api/accounts/by-customer/" + customerId, Map.class);
            return response;
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Check Account Balance (Helper method)
    @GetMapping("/balance/{customerId}")
    @ResponseBody
    public ResponseEntity<Map> getAccountBalance(@PathVariable String customerId) {
        try {
            if (!customerUIController.isCustomerApproved(customerId)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }

            ResponseEntity<Map> response = restTemplate.getForEntity(
                API_GATEWAY_URL + "/account-api/accounts/by-customer/" + customerId, Map.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                Map<String, Object> account = response.getBody();
                Map<String, Object> balanceInfo = new HashMap<>();
                balanceInfo.put("balance", account.get("balance"));
                balanceInfo.put("accountNumber", account.get("accountNumber"));
                return ResponseEntity.ok(balanceInfo);
            }
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
package com.bank.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bank.model.Account;
import com.bank.model.Customer;
import com.bank.model.KYCDocument;
import com.bank.services.AdminService;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/admin")
@CrossOrigin(origins = "*")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @GetMapping("/hello")
    public String hello() {
        return "Hello from Admin Service";
    }
    
    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("Admin Service is UP and running");
    }

    // Dashboard API
    @GetMapping("/api/dashboard/stats")
    public ResponseEntity<Map<String, Object>> getDashboardStats() {
        try {
            List<Customer> customers = adminService.getAllCustomers();
            List<KYCDocument> kycDocs = adminService.getAllKycDocuments();
            
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalCustomers", customers.size());
            stats.put("pendingCustomers", customers.stream().filter(c -> "PENDING".equals(c.getStatus())).count());
            stats.put("approvedCustomers", customers.stream().filter(c -> "APPROVED".equals(c.getStatus())).count());
            stats.put("rejectedCustomers", customers.stream().filter(c -> "REJECTED".equals(c.getStatus())).count());
            
            stats.put("totalKyc", kycDocs.size());
            stats.put("pendingKyc", kycDocs.stream().filter(k -> "PENDING".equals(k.getStatus())).count());
            stats.put("approvedKyc", kycDocs.stream().filter(k -> "APPROVED".equals(k.getStatus())).count());
            stats.put("rejectedKyc", kycDocs.stream().filter(k -> "REJECTED".equals(k.getStatus())).count());
            
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Failed to load dashboard stats: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    // Customer Management APIs
    @GetMapping("/api/customers")
    public ResponseEntity<List<Customer>> getAllCustomers() {
        try {
            List<Customer> customers = adminService.getAllCustomers();
            return ResponseEntity.ok(customers);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/api/customers/{customerId}")
    public ResponseEntity<Map<String, Object>> getCustomerDetails(@PathVariable String customerId) {
        try {
            Customer customer = adminService.getCustomerById(customerId);
            List<Account> accounts = adminService.getAccountsByCustomerId(customerId);
            List<KYCDocument> kycDocs = adminService.getKycDocuments(customerId);

            Map<String, Object> response = new HashMap<>();
            response.put("customer", customer);
            response.put("accounts", accounts);
            response.put("kycDocuments", kycDocs);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Customer not found: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
        }
    }

    @PutMapping("/api/customers/{customerId}/status")
    public ResponseEntity<Map<String, String>> updateCustomerStatus(
            @PathVariable String customerId, 
            @RequestBody Map<String, String> statusUpdate) {
        try {
            String newStatus = statusUpdate.get("status");
            Customer updatedCustomer = adminService.updateCustomerStatus(customerId, newStatus);
            
            Map<String, String> response = new HashMap<>();
            response.put("success", "Customer status updated successfully");
            response.put("newStatus", updatedCustomer.getStatus());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to update customer status: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    @PutMapping("/api/customers/{customerId}/kyc-status")
    public ResponseEntity<Map<String, String>> updateCustomerKycStatus(
            @PathVariable String customerId, 
            @RequestBody Map<String, String> statusUpdate) {
        try {
            String newStatus = statusUpdate.get("status");
            Customer updatedCustomer = adminService.updateCustomerKycStatus(customerId, newStatus);
            
            Map<String, String> response = new HashMap<>();
            response.put("success", "Customer KYC status updated successfully");
            response.put("newKycStatus", newStatus);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to update KYC status: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    // KYC Document Management APIs
    @GetMapping("/api/kyc")
    public ResponseEntity<List<KYCDocument>> getAllKycDocuments() {
        try {
            List<KYCDocument> kycDocs = adminService.getAllKycDocuments();
            return ResponseEntity.ok(kycDocs);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/api/kyc/{id}")
    public ResponseEntity<KYCDocument> getKycDocument(@PathVariable Long id) {
        try {
            KYCDocument kycDoc = adminService.getKycDocumentById(id);
            return ResponseEntity.ok(kycDoc);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @PutMapping("/api/kyc/{id}/status")
    public ResponseEntity<Map<String, String>> updateKycStatus(
            @PathVariable Long id, 
            @RequestBody Map<String, String> statusUpdate) {
        try {
            String newStatus = statusUpdate.get("status");
            String remarks = statusUpdate.get("remarks");
            KYCDocument updatedKyc = adminService.updateKycStatus(id, newStatus, remarks);
            
            Map<String, String> response = new HashMap<>();
            response.put("success", "KYC status updated successfully");
            response.put("newStatus", updatedKyc.getStatus());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to update KYC status: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    // Account Management APIs
    @GetMapping("/api/accounts")
    public ResponseEntity<List<Account>> getAllAccounts() {
        try {
            List<Account> accounts = adminService.getAllAccounts();
            return ResponseEntity.ok(accounts);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/api/accounts/{customerId}/activate")
    public ResponseEntity<Map<String, String>> activateAccount(@PathVariable String customerId) {
        try {
            adminService.activateCustomerAccount(customerId);
            
            Map<String, String> response = new HashMap<>();
            response.put("success", "Account activated successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to activate account: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    @PostMapping("/api/accounts/{customerId}/deactivate")
    public ResponseEntity<Map<String, String>> deactivateAccount(@PathVariable String customerId) {
        try {
            adminService.deactivateCustomerAccount(customerId);
            
            Map<String, String> response = new HashMap<>();
            response.put("success", "Account deactivated successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to deactivate account: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    // Legacy dashboard view (keeping for backwards compatibility)
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        List<Customer> customers = adminService.getAllCustomers();
        model.addAttribute("customers", customers);
        return "admin-dashboard";
    }

    @GetMapping("/view")
    public String viewCustomer(@RequestParam String customerId, Model model) {
        Customer customer = adminService.getCustomerById(customerId);
        List<Account> accounts = adminService.getAccountsByCustomerId(customerId);
        List<KYCDocument> kycDocs = adminService.getKycDocuments(customerId);

        model.addAttribute("customer", customer);
        model.addAttribute("accounts", accounts);
        model.addAttribute("kycDocs", kycDocs);

        return "admin-dashboard";
    }
}

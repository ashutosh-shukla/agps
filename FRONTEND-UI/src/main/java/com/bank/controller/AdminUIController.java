package com.bank.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

@Controller
@RequestMapping("/admin")
public class AdminUIController {
    
    private final String API_GATEWAY_URL = "http://localhost:8080";
    
    @Autowired
    private RestTemplate restTemplate;
    
    // Admin Dashboard
    @GetMapping("/dashboard")
    public String showAdminDashboard(Model model) {
        try {
            // Get dashboard statistics
            ResponseEntity<Map> statsResponse = restTemplate.getForEntity(
                API_GATEWAY_URL + "/admin/api/dashboard/stats", Map.class);
            model.addAttribute("stats", statsResponse.getBody());
            
            // Get recent customers
            ResponseEntity<List> customersResponse = restTemplate.getForEntity(
                API_GATEWAY_URL + "/admin/api/customers", List.class);
            List<Map> customers = customersResponse.getBody();
            model.addAttribute("recentCustomers", customers != null && customers.size() > 5 ? 
                customers.subList(0, 5) : customers);
            
            // Get recent KYC documents
            ResponseEntity<List> kycResponse = restTemplate.getForEntity(
                API_GATEWAY_URL + "/admin/api/kyc", List.class);
            List<Map> kycDocs = kycResponse.getBody();
            model.addAttribute("recentKYC", kycDocs != null && kycDocs.size() > 5 ? 
                kycDocs.subList(0, 5) : kycDocs);
            
        } catch (Exception e) {
            model.addAttribute("error", "Unable to load dashboard data: " + e.getMessage());
        }
        return "admin-dashboard-ui";
    }
    
    // Customer Management
    @GetMapping("/customers")
    public String showAllCustomers(Model model) {
        try {
            ResponseEntity<List> response = restTemplate.getForEntity(
                API_GATEWAY_URL + "/admin/api/customers", List.class);
            model.addAttribute("customers", response.getBody());
        } catch (Exception e) {
            model.addAttribute("error", "Unable to fetch customers: " + e.getMessage());
        }
        return "admin-customers-ui";
    }
    
    @GetMapping("/customers/{customerId}")
    public String showCustomerDetails(@PathVariable String customerId, Model model) {
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity(
                API_GATEWAY_URL + "/admin/api/customers/" + customerId, Map.class);
            model.addAttribute("customer", response.getBody());
        } catch (Exception e) {
            model.addAttribute("error", "Customer not found: " + e.getMessage());
        }
        return "admin-customer-details-ui";
    }
    
    @PostMapping("/customers/update-status")
    public String updateCustomerStatus(@RequestParam String customerId,
                                     @RequestParam String status,
                                     RedirectAttributes redirectAttributes) {
        try {
            Map<String, String> request = new HashMap<>();
            request.put("status", status);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, String>> entity = new HttpEntity<>(request, headers);
            
            restTemplate.exchange(API_GATEWAY_URL + "/admin/api/customers/" + customerId + "/status",
                HttpMethod.PUT, entity, Map.class);
            redirectAttributes.addFlashAttribute("success", "Customer status updated successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update customer status: " + e.getMessage());
        }
        return "redirect:/admin/customers";
    }
    
    @PostMapping("/customers/update-kyc-status")
    public String updateKycStatus(@RequestParam String customerId,
                                @RequestParam String status,
                                RedirectAttributes redirectAttributes) {
        try {
            Map<String, String> request = new HashMap<>();
            request.put("status", status);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, String>> entity = new HttpEntity<>(request, headers);
            
            restTemplate.exchange(API_GATEWAY_URL + "/admin/api/customers/" + customerId + "/kyc-status",
                HttpMethod.PUT, entity, Map.class);
            redirectAttributes.addFlashAttribute("success", "KYC status updated successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update KYC status: " + e.getMessage());
        }
        return "redirect:/admin/customers";
    }
    
    // Account Management
    @GetMapping("/accounts")
    public String showAllAccounts(Model model) {
        try {
            ResponseEntity<List> response = restTemplate.getForEntity(
                API_GATEWAY_URL + "/admin/api/accounts", List.class);
            model.addAttribute("accounts", response.getBody());
        } catch (Exception e) {
            model.addAttribute("error", "Unable to fetch accounts: " + e.getMessage());
        }
        return "admin-accounts-ui";
    }
    
    // KYC Management
    @GetMapping("/kyc")
    public String showAllKYC(Model model) {
        try {
            ResponseEntity<List> response = restTemplate.getForEntity(
                API_GATEWAY_URL + "/admin/api/kyc", List.class);
            model.addAttribute("kycDocuments", response.getBody());
        } catch (Exception e) {
            model.addAttribute("error", "Unable to fetch KYC documents: " + e.getMessage());
        }
        return "admin-kyc-ui";
    }
    
    @GetMapping("/kyc/{id}")
    public String showKYCDetails(@PathVariable Long id, Model model) {
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity(
                API_GATEWAY_URL + "/admin/api/kyc/" + id, Map.class);
            model.addAttribute("kycDocument", response.getBody());
        } catch (Exception e) {
            model.addAttribute("error", "KYC document not found: " + e.getMessage());
        }
        return "admin-kyc-details-ui";
    }
    
    @PostMapping("/kyc/update-status")
    public String updateKYCStatus(@RequestParam Long id,
                                @RequestParam String status,
                                RedirectAttributes redirectAttributes) {
        try {
            Map<String, String> request = new HashMap<>();
            request.put("status", status);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, String>> entity = new HttpEntity<>(request, headers);
            
            restTemplate.exchange(API_GATEWAY_URL + "/admin/api/kyc/" + id + "/status",
                HttpMethod.PUT, entity, Map.class);
            redirectAttributes.addFlashAttribute("success", "KYC status updated successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update KYC status: " + e.getMessage());
        }
        return "redirect:/admin/kyc";
    }
    
    // Health check
    @GetMapping("/health")
    @ResponseBody
    public String healthCheck() {
        try {
            String response = restTemplate.getForObject(API_GATEWAY_URL + "/health/admin", String.class);
            return "Frontend UP - Admin Service: " + response;
        } catch (Exception e) {
            return "Frontend UP - Admin Service DOWN: " + e.getMessage();
        }
    }
}

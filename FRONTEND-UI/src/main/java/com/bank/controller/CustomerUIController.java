package com.bank.controller;

import com.bank.model.Customer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/customer")
public class CustomerUIController {
    
    @Autowired
    private RestTemplate restTemplate;
    
    private static final String API_GATEWAY_URL = "http://localhost:8080";

    
    
    // Show registration form
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        if (!model.containsAttribute("customer")) {
            model.addAttribute("customer", new Customer());
        }
        return "register";
    }
    
    // Handle registration
    @PostMapping("/register")
    public String registerCustomer(
            @ModelAttribute("customer") Customer customer,
            Model model,
            RedirectAttributes redirectAttributes) {
        
        try {
            Map<String, Object> customerData = new HashMap<>();
            customerData.put("firstName", customer.getFirstName());
            customerData.put("lastName", customer.getLastName());
            customerData.put("email", customer.getEmail());
            customerData.put("phoneNumber", customer.getPhoneNumber());
            customerData.put("address", customer.getAddress());
            customerData.put("dateOfBirth", customer.getDateOfBirth());
            customerData.put("password", customer.getPassword());
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(customerData, headers);
            
            ResponseEntity<Map> response = restTemplate.postForEntity(
                API_GATEWAY_URL + "/customers/register", entity, Map.class);
            
            if (response.getStatusCode() == HttpStatus.OK) {
                Map<String, Object> responseBody = response.getBody();
                String generatedCustomerId = (String) responseBody.get("customerId");
                
                redirectAttributes.addFlashAttribute("success",
                    "Customer registered successfully! Customer ID: " + generatedCustomerId);
                return "redirect:/customer/dashboard/" + generatedCustomerId;
            }
        } catch (Exception e) {
            model.addAttribute("customer", customer);
            model.addAttribute("error", "Registration failed: " + e.getMessage());
            return "customer/register";
        }
        
        model.addAttribute("customer", customer);
        model.addAttribute("error", "Registration failed. Please try again.");
        return "customer-dashboard";
    }
    
    // Dashboard - Main entry point
    @GetMapping("/dashboard/{customerId}")
    public String showDashboard(@PathVariable String customerId, Model model) {
        try {
            // Get customer details
            ResponseEntity<Map> customerResponse = restTemplate.getForEntity(
                API_GATEWAY_URL + "/customers/" + customerId, Map.class);
            
            if (customerResponse.getStatusCode() == HttpStatus.OK) {
                Map<String, Object> customer = customerResponse.getBody();
                model.addAttribute("customer", customer);
                
                String customerStatus = (String) customer.get("status");
                String kycStatus = (String) customer.get("kycStatus"); // Assuming you have this field
                
                // Try to get account details
                try {
                    ResponseEntity<Map> accountResponse = restTemplate.getForEntity(
                        API_GATEWAY_URL + "/account-api/accounts/by-customer/" + customerId, Map.class);
                    
                    if (accountResponse.getStatusCode() == HttpStatus.OK) {
                        Map<String, Object> account = accountResponse.getBody();
                        String accountStatus = (String) account.get("status");
                        
                        model.addAttribute("account", account);
                        model.addAttribute("hasAccount", true);
                        
                        // Check if customer is approved and has active account
                        if ("APPROVED".equalsIgnoreCase(customerStatus) && 
                            "ACTIVE".equalsIgnoreCase(accountStatus)) {
                            model.addAttribute("isApproved", true);
                            model.addAttribute("canPerformTransactions", true);
                        } else {
                            model.addAttribute("isApproved", false);
                            model.addAttribute("canPerformTransactions", false);
                            model.addAttribute("statusMessage", "Account verification pending");
                        }
                    } else {
                        handleNoAccount(model, customerStatus, kycStatus);
                    }
                    
                } catch (Exception e) {
                    handleNoAccount(model, customerStatus, kycStatus);
                }
                
            } else {
                model.addAttribute("error", "Customer not found");
            }
            
        } catch (Exception e) {
            model.addAttribute("error", "Unable to fetch customer details: " + e.getMessage());
        }
        
        return "customer-dashboard";
    }
    
    // Edit Profile
    @GetMapping("/editProfile/{customerId}")
    public String showEditProfile(@PathVariable String customerId, Model model) {
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity(
                API_GATEWAY_URL + "/customers/" + customerId, Map.class);
            
            if (response.getStatusCode() == HttpStatus.OK) {
                model.addAttribute("customer", response.getBody());
            } else {
                model.addAttribute("error", "Customer not found");
            }
        } catch (Exception e) {
            model.addAttribute("error", "Unable to fetch customer details");
        }
        
        return "editProfile";
    }
    
    @PostMapping("/updateProfile/{customerId}")
    public String updateProfile(@PathVariable String customerId,
                               @RequestParam String firstName,
                               @RequestParam String lastName,
                               @RequestParam String phoneNumber,
                               @RequestParam String address,
                               RedirectAttributes redirectAttributes) {
        try {
            Map<String, Object> updateData = new HashMap<>();
            updateData.put("firstName", firstName);
            updateData.put("lastName", lastName);
            updateData.put("phoneNumber", phoneNumber);
            updateData.put("address", address);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(updateData, headers);
            
            ResponseEntity<String> response = restTemplate.exchange(
                API_GATEWAY_URL + "/customers/" + customerId, HttpMethod.PUT, entity, String.class);
            
            if (response.getStatusCode() == HttpStatus.OK) {
                redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Profile update failed");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Profile update failed: " + e.getMessage());
        }
        
        return "redirect:/customer/dashboard/" + customerId;
    }
    
 
    
    // Helper method to handle no account scenario
    private void handleNoAccount(Model model, String customerStatus, String kycStatus) {
        model.addAttribute("hasAccount", false);
        model.addAttribute("isApproved", false);
        model.addAttribute("canPerformTransactions", false);
        
        if ("PENDING".equalsIgnoreCase(kycStatus) || kycStatus == null) {
            model.addAttribute("needsKyc", true);
            model.addAttribute("statusMessage", "Complete KYC verification to create account");
        } else if ("APPROVED".equalsIgnoreCase(kycStatus)) {
            model.addAttribute("statusMessage", "KYC approved. Account creation in progress.");
        } else {
            model.addAttribute("statusMessage", "KYC verification required");
        }
    }
    
    // Helper method to check if customer is approved
    public boolean isCustomerApproved(String customerId) {
        try {
            ResponseEntity<Map> customerResponse = restTemplate.getForEntity(
                API_GATEWAY_URL + "/customers/" + customerId, Map.class);
            
            if (customerResponse.getStatusCode() == HttpStatus.OK) {
                Map<String, Object> customer = customerResponse.getBody();
                String status = (String) customer.get("status");
                
                // Also check if account exists and is active
                ResponseEntity<Map> accountResponse = restTemplate.getForEntity(
                    API_GATEWAY_URL + "/account-api/accounts/by-customer/" + customerId, Map.class);
                
                if (accountResponse.getStatusCode() == HttpStatus.OK) {
                    Map<String, Object> account = accountResponse.getBody();
                    String accountStatus = (String) account.get("status");
                    return "APPROVED".equalsIgnoreCase(status) && "ACTIVE".equalsIgnoreCase(accountStatus);
                }
            }
        } catch (Exception e) {
            return false;
        }
        return false;
    }
    
}
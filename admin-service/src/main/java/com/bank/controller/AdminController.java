package com.bank.controller;

import org.springframework.beans.factory.annotation.Autowired;
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

@Controller
@RequestMapping("/admin")
public class AdminController {

	  @Autowired
	    private AdminService adminService;

	  @GetMapping("/hello")
	  	public String hello() {
		return "Hello from Admin Service";
	}
	  
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

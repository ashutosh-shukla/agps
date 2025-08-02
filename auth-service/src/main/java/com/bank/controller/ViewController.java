package com.bank.controller;

import com.bank.model.Admin;
import com.bank.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class ViewController {

    @Autowired
    private AuthService authService;

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @GetMapping("/admin-register")
    public String adminRegisterPage(Model model) {
        model.addAttribute("admin", new Admin());
        return "admin-register";
    }

    @PostMapping("/admin-register")
    public String registerAdmin(@ModelAttribute Admin admin, Model model) {
        try {
            authService.registerAdmin(admin);
            model.addAttribute("message", "Admin registered successfully! You can now login.");
            model.addAttribute("messageType", "success");
        } catch (RuntimeException e) {
            model.addAttribute("message", "Registration failed: " + e.getMessage());
            model.addAttribute("messageType", "error");
            model.addAttribute("admin", admin);
        }
        return "admin-register";
    }

    @GetMapping("/home")
    public String homePage(@RequestParam(value = "token", required = false) String token,
                          @RequestParam(value = "role", required = false) String role,
                          @RequestParam(value = "firstName", required = false) String firstName,
                          @RequestParam(value = "lastName", required = false) String lastName,
                          Model model) {
        if (token != null && role != null) {
            model.addAttribute("token", token);
            model.addAttribute("role", role);
            model.addAttribute("firstName", firstName);
            model.addAttribute("lastName", lastName);
            model.addAttribute("authenticated", true);
        } else {
            model.addAttribute("authenticated", false);
        }
        return "home";
    }
}
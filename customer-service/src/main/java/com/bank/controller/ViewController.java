package com.bank.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {

    @GetMapping("/customers/register")
    public String customerRegisterPage() {
        return "customer-register";
    }
}
package com.bank.exception;


import javax.security.auth.login.AccountNotFoundException;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.ui.Model;

@ControllerAdvice
public class CustomExceptionHandler {
    @ExceptionHandler(CustomerNotFoundException.class)
    public String handleCustomerNotFound(Model model) {
        model.addAttribute("error", "Customer not found!");
        return "errorPage";
    }

    @ExceptionHandler(AccountNotFoundException.class)
    public String handleAccountNotFound(Model model) {
        model.addAttribute("error", "Account not found!");
        return "errorPage";
    }
}

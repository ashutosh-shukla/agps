package com.bank.controller;

import com.bank.dto.*;
import com.bank.model.Admin;
import com.bank.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Auth Service is running");
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest loginRequest) {
        LoginResponse response = authService.login(loginRequest);
        if (response.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/validate-token")
    public ResponseEntity<TokenValidationResponse> validateToken(@Valid @RequestBody TokenValidationRequest request) {
        TokenValidationResponse response = authService.validateToken(request);
        if (response.isValid()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/admin/register")
    public ResponseEntity<String> registerAdmin(@Valid @RequestBody Admin admin) {
        try {
            authService.registerAdmin(admin);
            return ResponseEntity.ok("Admin registered successfully");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body("Registration failed: " + e.getMessage());
        }
    }

    @GetMapping("/admin/check/{email}")
    public ResponseEntity<Boolean> checkAdminExists(@PathVariable String email) {
        boolean exists = authService.findAdminByEmail(email).isPresent();
        return ResponseEntity.ok(exists);
    }
}
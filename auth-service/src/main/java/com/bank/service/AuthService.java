package com.bank.service;

import com.bank.dto.*;
import com.bank.model.Admin;
import com.bank.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class AuthService {

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private CustomerServiceProxy customerServiceProxy;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public LoginResponse login(LoginRequest loginRequest) {
        try {
            // First, try to authenticate as admin
            Optional<Admin> adminOpt = adminRepository.findByEmail(loginRequest.getEmail());
            if (adminOpt.isPresent()) {
                Admin admin = adminOpt.get();
                if (passwordEncoder.matches(loginRequest.getPassword(), admin.getPassword())) {
                    String token = jwtService.generateToken(
                        admin.getAdminId(),
                        admin.getEmail(),
                        admin.getRole(),
                        admin.getFirstName(),
                        admin.getLastName()
                    );
                    return LoginResponse.success(token, admin.getAdminId(), admin.getEmail(), 
                                               admin.getFirstName(), admin.getLastName(), admin.getRole());
                }
            }

            // If not admin, try to authenticate as customer
            CustomerValidationRequest customerRequest = new CustomerValidationRequest(
                loginRequest.getEmail(), 
                loginRequest.getPassword()
            );
            
            CustomerValidationResponse customerResponse = customerServiceProxy.validateCustomerCredentials(customerRequest);
            
            if (customerResponse.isValid()) {
                String token = jwtService.generateToken(
                    customerResponse.getCustomerId(),
                    customerResponse.getEmail(),
                    customerResponse.getRole(),
                    customerResponse.getFirstName(),
                    customerResponse.getLastName()
                );
                return LoginResponse.success(token, customerResponse.getCustomerId(), customerResponse.getEmail(),
                                           customerResponse.getFirstName(), customerResponse.getLastName(), customerResponse.getRole());
            }

            return LoginResponse.error("Invalid email or password");
        } catch (Exception e) {
            return LoginResponse.error("Authentication failed: " + e.getMessage());
        }
    }

    public TokenValidationResponse validateToken(TokenValidationRequest request) {
        try {
            String token = request.getToken();
            
            if (jwtService.validateToken(token)) {
                String userId = jwtService.extractUserId(token);
                String email = jwtService.extractEmail(token);
                String role = jwtService.extractRole(token);
                
                return TokenValidationResponse.success(userId, email, role);
            } else {
                return TokenValidationResponse.error("Invalid or expired token");
            }
        } catch (Exception e) {
            return TokenValidationResponse.error("Token validation failed: " + e.getMessage());
        }
    }

    public Admin registerAdmin(Admin admin) {
        if (adminRepository.existsByEmail(admin.getEmail())) {
            throw new RuntimeException("Admin with this email already exists");
        }
        
        admin.setPassword(passwordEncoder.encode(admin.getPassword()));
        return adminRepository.save(admin);
    }

    public Optional<Admin> findAdminByEmail(String email) {
        return adminRepository.findByEmail(email);
    }
}
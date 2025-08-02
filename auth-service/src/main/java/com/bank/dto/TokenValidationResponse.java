package com.bank.dto;

public class TokenValidationResponse {

    private boolean valid;
    private String userId;
    private String email;
    private String role;
    private String message;

    public TokenValidationResponse() {}

    public TokenValidationResponse(boolean valid, String userId, String email, String role, String message) {
        this.valid = valid;
        this.userId = userId;
        this.email = email;
        this.role = role;
        this.message = message;
    }

    // Static factory methods
    public static TokenValidationResponse success(String userId, String email, String role) {
        return new TokenValidationResponse(true, userId, email, role, "Token is valid");
    }

    public static TokenValidationResponse error(String message) {
        return new TokenValidationResponse(false, null, null, null, message);
    }

    // Getters and Setters
    public boolean isValid() {
        return valid;
    }

    public void setValid(boolean valid) {
        this.valid = valid;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
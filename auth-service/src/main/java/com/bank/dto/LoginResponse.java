package com.bank.dto;

public class LoginResponse {

    private String token;
    private String userId;
    private String email;
    private String firstName;
    private String lastName;
    private String role;
    private String message;
    private boolean success;

    public LoginResponse() {}

    public LoginResponse(String token, String userId, String email, String firstName, String lastName, String role, String message, boolean success) {
        this.token = token;
        this.userId = userId;
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.role = role;
        this.message = message;
        this.success = success;
    }

    // Static factory methods for success and error responses
    public static LoginResponse success(String token, String userId, String email, String firstName, String lastName, String role) {
        return new LoginResponse(token, userId, email, firstName, lastName, role, "Login successful", true);
    }

    public static LoginResponse error(String message) {
        return new LoginResponse(null, null, null, null, null, null, message, false);
    }

    // Getters and Setters
    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
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

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
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

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }
}
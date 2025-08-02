package com.bank.dto;

public class CustomerValidationResponse {

    private boolean valid;
    private String customerId;
    private String email;
    private String firstName;
    private String lastName;
    private String role;
    private String message;

    public CustomerValidationResponse() {}

    public CustomerValidationResponse(boolean valid, String customerId, String email, String firstName, String lastName, String role, String message) {
        this.valid = valid;
        this.customerId = customerId;
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.role = role;
        this.message = message;
    }

    // Static factory methods
    public static CustomerValidationResponse success(String customerId, String email, String firstName, String lastName, String role) {
        return new CustomerValidationResponse(true, customerId, email, firstName, lastName, role, "Customer validation successful");
    }

    public static CustomerValidationResponse error(String message) {
        return new CustomerValidationResponse(false, null, null, null, null, null, message);
    }

    // Getters and Setters
    public boolean isValid() {
        return valid;
    }

    public void setValid(boolean valid) {
        this.valid = valid;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
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
}
package com.bank.dto;



public class CredentialValidationResponse {
    private boolean valid;
    private String customerId;
    private String firstName;
    private String lastName;
    private String email;
    private String role;
    private String status;
    private String message;
    
    public CredentialValidationResponse() {}
    
 public static CredentialValidationResponse success(String customerId, String email,
                                                       String firstName, String lastName, String role) {
        CredentialValidationResponse response = new CredentialValidationResponse();
        response.valid = true;
        response.customerId = customerId;
        response.email = email;
        response.firstName = firstName;
        response.lastName = lastName;
        response.role = role;
        response.message = "Login successful";
        return response;
    }

  

    public CredentialValidationResponse(boolean valid, String message) {
        this.valid = valid;
        this.message = message;
    }
    
    // Getters and Setters
    public boolean isValid() { return valid; }
    public void setValid(boolean valid) { this.valid = valid; }
    
    public String getCustomerId() { return customerId; }
    public void setCustomerId(String customerId) { this.customerId = customerId; }
    
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public static Object error(String string) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'error'");
    }
}
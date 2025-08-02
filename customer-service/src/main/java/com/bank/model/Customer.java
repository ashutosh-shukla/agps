package com.bank.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "MY_CUSTOMER")
public class Customer {


   @Id
    @GeneratedValue(strategy = GenerationType.UUID) 
@Column(name = "customer_id", length = 60, unique = true, nullable = false)
private String customerId;
    
    @Column(nullable = false, length = 100)
    private String firstName;
    
    
    
    @Column(nullable = false, length = 100)
    private String lastName;
    
    @Column(nullable = false, length = 20)
    private String Role;
    
    @Column(unique = true, nullable = false, length = 100)
    private String email;
    
    @Column(unique = true, nullable = false, length = 15)
    private String phoneNumber;
    
    @Column(nullable = false)
    private String address;
    
    @Column(nullable = false, length = 10)
    private String dateOfBirth;
    
    @Column(nullable = false, length = 20)
    private String status;
    
    @Column(nullable = false)
    private LocalDateTime createdAt;
    
    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @Column(nullable = false)
    private String password;

    

    // Default constructor
    public Customer() {}


    // Getters and Setters
    public String getCustomerId() { return customerId; }
    public void setCustomerId(String customerId) { this.customerId = customerId; }
    
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(String dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

      public void updateDetails(String firstName, String lastName, String address, String phoneNumber) {
        this.setFirstName(firstName);
        this.setLastName(lastName);
        this.setAddress(address);
        this.setPhoneNumber(phoneNumber);
    }
   public String getPassword() {
    return password;
    }   

public void setPassword(String password) {
    this.password = password;
}


	public String getRole() {
		return Role;
	}

	public void setRole(String role) {
		this.Role = role;
	}

}




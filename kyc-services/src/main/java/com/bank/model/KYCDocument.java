package com.bank.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.util.Date;

@Entity
@Table(name = "kyc_documents")
public class KYCDocument {
    
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "kyc_seq")
    @SequenceGenerator(name = "kyc_seq", sequenceName = "kyc_sequence", allocationSize = 1)
    private Long id;
    
    @NotBlank(message = "Full name is required")
    @Size(max = 100, message = "Full name must not exceed 100 characters")
    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;
    
    @NotBlank(message = "Email is required")
    @Size(max = 100, message = "Email must not exceed 100 characters")
    @Column(name = "email", nullable = false, length = 100)
    private String email;
    
    @NotBlank(message = "Phone number is required")
    @Size(max = 15, message = "Phone number must not exceed 15 characters")
    @Column(name = "phone_number", nullable = false, length = 15)
    private String phoneNumber;
    
    @Lob
    @Column(name = "aadhar_front", columnDefinition = "CLOB")
    private String aadharFront;
    
    @Lob
    @Column(name = "aadhar_back", columnDefinition = "CLOB")
    private String aadharBack;
    
    @Lob
    @Column(name = "pan_front", columnDefinition = "CLOB")
    private String panFront;
    
    @Lob
    @Column(name = "pan_back", columnDefinition = "CLOB")
    private String panBack;
    
    @Lob
    @Column(name = "photograph", columnDefinition = "CLOB")
    private String photograph;
    
    @Column(name = "status", length = 20)
    private String status = "PENDING";
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "updated_at")
    private Date updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = new Date();
        updatedAt = new Date();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = new Date();
    }
    
    // Constructors
    public KYCDocument() {}
    
    public KYCDocument(String fullName, String email, String phoneNumber) {
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    public String getAadharFront() {
        return aadharFront;
    }
    
    public void setAadharFront(String aadharFront) {
        this.aadharFront = aadharFront;
    }
    
    public String getAadharBack() {
        return aadharBack;
    }
    
    public void setAadharBack(String aadharBack) {
        this.aadharBack = aadharBack;
    }
    
    public String getPanFront() {
        return panFront;
    }
    
    public void setPanFront(String panFront) {
        this.panFront = panFront;
    }
    
    public String getPanBack() {
        return panBack;
    }
    
    public void setPanBack(String panBack) {
        this.panBack = panBack;
    }
    
    public String getPhotograph() {
        return photograph;
    }
    
    public void setPhotograph(String photograph) {
        this.photograph = photograph;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Date getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
}

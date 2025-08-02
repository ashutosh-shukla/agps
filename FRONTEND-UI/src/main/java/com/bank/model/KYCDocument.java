package com.bank.model;

import java.util.Date;

public class KYCDocument {

    private Long id;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String aadharFront;
    private String aadharBack;
    private String panFront;
    private String panBack;
    private String photograph;
    private String status;
    private Date createdAt;
    private Date updatedAt;

    public KYCDocument() {}

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

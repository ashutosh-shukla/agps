package com.bank.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.bank.model.KYCDocument;

import java.util.List;

@Repository
public interface KYCDocumentRepository extends JpaRepository<KYCDocument, Long> {
    
    List<KYCDocument> findByStatus(String status);
    
    List<KYCDocument> findByEmailContainingIgnoreCase(String email);
    
    @Query("SELECT k FROM KYCDocument k ORDER BY k.createdAt DESC")
    List<KYCDocument> findAllOrderByCreatedAtDesc();
    
    boolean existsByEmail(String email);
}

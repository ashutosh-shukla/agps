package com.bank.services;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import org.springframework.web.multipart.MultipartFile;

import com.bank.model.KYCDocument;

public interface KYCDocumentService {

    List<KYCDocument> getAllDocuments();

    KYCDocument getDocumentById(Long id);

    List<KYCDocument> getDocumentsByStatus(String status);

    List<KYCDocument> getDocumentsByCustomerId(String customerId);

    KYCDocument saveDocument(KYCDocument document);

    KYCDocument saveKYCDocument(String fullName, String email, String phoneNumber,
                                 MultipartFile aadharFront, MultipartFile aadharBack,
                                 MultipartFile panFront, MultipartFile panBack,
                                 MultipartFile photograph) throws IOException;

    KYCDocument updateDocumentStatus(Long id, String status, String remarks);

    void deleteDocument(Long id);
}

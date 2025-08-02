package com.bank.services;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import org.springframework.web.multipart.MultipartFile;

import com.bank.model.KYCDocument;

public interface KYCDocumentService {

    List<KYCDocument> getAllDocuments();

    Optional<KYCDocument> getDocumentById(Long id);

    List<KYCDocument> getDocumentsByStatus(String status);

    KYCDocument saveDocument(KYCDocument document);

    KYCDocument saveKYCDocument(String fullName, String email, String phoneNumber,
                                 MultipartFile aadharFront, MultipartFile aadharBack,
                                 MultipartFile panFront, MultipartFile panBack,
                                 MultipartFile photograph) throws IOException;

    void updateDocumentStatus(Long id, String status);

    void deleteDocument(Long id);
}

package com.bank.servicesImpl;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.bank.model.KYCDocument;
import com.bank.repository.KYCDocumentRepository;
import com.bank.services.KYCDocumentService;
import com.bank.utils.FileUtil;

import java.io.IOException;
import java.util.Base64;
import java.util.List;
import java.util.Optional;

@Service
public class KYCDocumentServiceImpl implements KYCDocumentService {
    
    @Autowired
    private KYCDocumentRepository kycDocumentRepository;
    
    public List<KYCDocument> getAllDocuments() {
        return kycDocumentRepository.findAllOrderByCreatedAtDesc();
    }
    
    public Optional<KYCDocument> getDocumentById(Long id) {
        return kycDocumentRepository.findById(id);
    }
    
    public List<KYCDocument> getDocumentsByStatus(String status) {
        return kycDocumentRepository.findByStatus(status);
    }
    
    public KYCDocument saveDocument(KYCDocument document) {
        return kycDocumentRepository.save(document);
    }
    
    public KYCDocument saveKYCDocument(String fullName, String email, String phoneNumber,
                                    MultipartFile aadharFront, MultipartFile aadharBack,
                                    MultipartFile panFront, MultipartFile panBack,
                                    MultipartFile photograph) throws IOException {
        
        // Check if email already exists
        if (kycDocumentRepository.existsByEmail(email)) {
            throw new RuntimeException("KYC document already exists for this email");
        }
        
        // Validate required files
        FileUtil.validateImageFile(aadharFront, "Aadhar Front");
        FileUtil.validateImageFile(aadharBack, "Aadhar Back");
        FileUtil.validateImageFile(photograph, "Photograph");
        
        // Validate optional files if provided
        if (panFront != null && !panFront.isEmpty()) {
            FileUtil.validateImageFile(panFront, "PAN Front");
        }
        if (panBack != null && !panBack.isEmpty()) {
            FileUtil.validateImageFile(panBack, "PAN Back");
        }
        
        KYCDocument document = new KYCDocument(fullName, email, phoneNumber);
        
        // Convert files to Base64
        document.setAadharFront(convertToBase64(aadharFront));
        document.setAadharBack(convertToBase64(aadharBack));
        document.setPhotograph(convertToBase64(photograph));
        
        if (panFront != null && !panFront.isEmpty()) {
            document.setPanFront(convertToBase64(panFront));
        }
        
        if (panBack != null && !panBack.isEmpty()) {
            document.setPanBack(convertToBase64(panBack));
        }
        
        return kycDocumentRepository.save(document);
    }
    
    public void updateDocumentStatus(Long id, String status) {
        Optional<KYCDocument> documentOpt = kycDocumentRepository.findById(id);
        if (documentOpt.isPresent()) {
            KYCDocument document = documentOpt.get();
            document.setStatus(status);
            kycDocumentRepository.save(document);
        }
    }
    
    private String convertToBase64(MultipartFile file) throws IOException {
        byte[] bytes = file.getBytes();
        String base64 = Base64.getEncoder().encodeToString(bytes);
        String mimeType = file.getContentType();
        return "data:" + mimeType + ";base64," + base64;
    }
    
    public void deleteDocument(Long id) {
        kycDocumentRepository.deleteById(id);
    }
}

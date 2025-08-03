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
import java.util.Date;

@Service
public class KYCDocumentServiceImpl implements KYCDocumentService {
    
    @Autowired
    private KYCDocumentRepository kycDocumentRepository;
    
    @Override
    public List<KYCDocument> getAllDocuments() {
        return kycDocumentRepository.findAllOrderByCreatedAtDesc();
    }
    
    @Override
    public KYCDocument getDocumentById(Long id) {
        Optional<KYCDocument> documentOpt = kycDocumentRepository.findById(id);
        return documentOpt.orElse(null);
    }
    
    @Override
    public List<KYCDocument> getDocumentsByStatus(String status) {
        return kycDocumentRepository.findByStatus(status);
    }
    
    @Override
    public List<KYCDocument> getDocumentsByCustomerId(String customerId) {
        // This method should find documents by email match with customer
        // For now, we'll implement a basic search by full name or email
        // You might want to enhance this based on your customer-kyc relationship
        return kycDocumentRepository.findByFullNameContainingIgnoreCase(customerId);
    }
    
    @Override
    public KYCDocument saveDocument(KYCDocument document) {
        return kycDocumentRepository.save(document);
    }
    
    @Override
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
        
        KYCDocument savedDocument = kycDocumentRepository.save(document);
        
        // Send notification to admin about new KYC document
        sendNotificationToAdmin(savedDocument, "NEW_UPLOAD");
        
        return savedDocument;
    }
    
    @Override
    public KYCDocument updateDocumentStatus(Long id, String status, String remarks) {
        Optional<KYCDocument> documentOpt = kycDocumentRepository.findById(id);
        if (documentOpt.isPresent()) {
            KYCDocument document = documentOpt.get();
            String previousStatus = document.getStatus();
            
            document.setStatus(status);
            document.setAdminRemarks(remarks);
            document.setReviewedAt(new Date());
            // Note: reviewedBy should be set from JWT token context
            // document.setReviewedBy(getCurrentAdminEmail());
            
            KYCDocument updatedDocument = kycDocumentRepository.save(document);
            
            // Send notification to customer about status change
            if (!previousStatus.equals(status)) {
                sendNotificationToCustomer(updatedDocument, status);
            }
            
            return updatedDocument;
        } else {
            throw new RuntimeException("KYC Document not found with ID: " + id);
        }
    }
    
    private String convertToBase64(MultipartFile file) throws IOException {
        byte[] bytes = file.getBytes();
        String base64 = Base64.getEncoder().encodeToString(bytes);
        String mimeType = file.getContentType();
        return "data:" + mimeType + ";base64," + base64;
    }
    
    @Override
    public void deleteDocument(Long id) {
        kycDocumentRepository.deleteById(id);
    }
    
    /**
     * Send notification to admin about new KYC document upload
     */
    private void sendNotificationToAdmin(KYCDocument document, String notificationType) {
        try {
            // In a real application, this would send email/SMS notification
            // For now, we'll log the notification
            String message = String.format(
                "New KYC document uploaded by %s (%s). Document ID: %d. Please review and approve/reject.",
                document.getFullName(),
                document.getEmail(),
                document.getId()
            );
            
            System.out.println("ADMIN NOTIFICATION: " + message);
            
            // TODO: Implement actual notification service
            // emailService.sendNotification("admin@agpsbank.com", "New KYC Document", message);
            // smsService.sendNotification("+1234567890", message);
            
        } catch (Exception e) {
            System.err.println("Failed to send admin notification: " + e.getMessage());
        }
    }
    
    /**
     * Send notification to customer about KYC status update
     */
    private void sendNotificationToCustomer(KYCDocument document, String status) {
        try {
            String message;
            String subject;
            
            switch (status.toUpperCase()) {
                case "APPROVED":
                    subject = "KYC Documents Approved - AGPS Bank";
                    message = String.format(
                        "Dear %s,\n\n" +
                        "Congratulations! Your KYC documents have been approved.\n" +
                        "Document ID: %d\n" +
                        "Admin Remarks: %s\n\n" +
                        "You can now proceed with your account activation.\n\n" +
                        "Thank you for choosing AGPS Bank!\n\n" +
                        "Best regards,\n" +
                        "AGPS Bank Team",
                        document.getFullName(),
                        document.getId(),
                        document.getAdminRemarks() != null ? document.getAdminRemarks() : "All documents verified successfully"
                    );
                    break;
                case "REJECTED":
                    subject = "KYC Documents - Action Required - AGPS Bank";
                    message = String.format(
                        "Dear %s,\n\n" +
                        "Your KYC documents require attention.\n" +
                        "Document ID: %d\n" +
                        "Status: REJECTED\n" +
                        "Admin Remarks: %s\n\n" +
                        "Please resubmit your documents after addressing the concerns mentioned above.\n\n" +
                        "If you have any questions, please contact our support team.\n\n" +
                        "Best regards,\n" +
                        "AGPS Bank Team",
                        document.getFullName(),
                        document.getId(),
                        document.getAdminRemarks() != null ? document.getAdminRemarks() : "Document verification failed"
                    );
                    break;
                default:
                    subject = "KYC Documents Status Update - AGPS Bank";
                    message = String.format(
                        "Dear %s,\n\n" +
                        "Your KYC document status has been updated.\n" +
                        "Document ID: %d\n" +
                        "New Status: %s\n" +
                        "Admin Remarks: %s\n\n" +
                        "Best regards,\n" +
                        "AGPS Bank Team",
                        document.getFullName(),
                        document.getId(),
                        status,
                        document.getAdminRemarks() != null ? document.getAdminRemarks() : "Status updated"
                    );
            }
            
            System.out.println("CUSTOMER NOTIFICATION: " + subject);
            System.out.println("To: " + document.getEmail());
            System.out.println("Message: " + message);
            
            // TODO: Implement actual notification service
            // emailService.sendNotification(document.getEmail(), subject, message);
            // if (document.getPhoneNumber() != null) {
            //     smsService.sendNotification(document.getPhoneNumber(), 
            //         "KYC Status: " + status + ". Check email for details.");
            // }
            
        } catch (Exception e) {
            System.err.println("Failed to send customer notification: " + e.getMessage());
        }
    }
}

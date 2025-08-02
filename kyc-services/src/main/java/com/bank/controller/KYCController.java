package com.bank.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.bank.model.KYCDocument;
import com.bank.services.KYCDocumentService;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/kyc/api")
@CrossOrigin(origins = "http://localhost:7071")
public class KYCController {
    
    @Autowired
    private KYCDocumentService kycDocumentService;
    
    @GetMapping("/health")
    @ResponseBody
    public String healthCheck() {
        return "KYC Service is UP";
    }
    
    // API endpoint for file upload (called by frontend)
    @PostMapping("/upload")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> uploadKYCDocuments(
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam("phoneNumber") String phoneNumber,
            @RequestParam(value = "aadharFront", required = false) MultipartFile aadharFront,
            @RequestParam(value = "aadharBack", required = false) MultipartFile aadharBack,
            @RequestParam(value = "panFront", required = false) MultipartFile panFront,
            @RequestParam(value = "panBack", required = false) MultipartFile panBack,
            @RequestParam(value = "photograph", required = false) MultipartFile photograph) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Validate required fields
            if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phoneNumber == null || phoneNumber.trim().isEmpty()) {
                response.put("error", "All personal details are required");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Validate email format
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                response.put("error", "Please enter a valid email address");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Validate phone number format
            if (!phoneNumber.matches("^[0-9]{10}$")) {
                response.put("error", "Please enter a valid 10-digit phone number");
                return ResponseEntity.badRequest().body(response);
            }
            
            KYCDocument savedDocument = kycDocumentService.saveKYCDocument(
                fullName.trim(), email.trim(), phoneNumber.trim(),
                aadharFront, aadharBack, panFront, panBack, photograph
            );
            
            response.put("success", true);
            response.put("message", "KYC documents uploaded successfully!");
            response.put("id", savedDocument.getId());
            
            return ResponseEntity.ok(response);
            
        } catch (IOException e) {
            response.put("error", "File validation error: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (RuntimeException e) {
            response.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (Exception e) {
            response.put("error", "An unexpected error occurred. Please try again.");
            return ResponseEntity.internalServerError().body(response);
        }
    }
    
    // Direct upload endpoint (for direct backend access)
    @PostMapping("/direct-upload")
    public String directUploadKYCDocuments(
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam("phoneNumber") String phoneNumber,
            @RequestParam("aadharFront") MultipartFile aadharFront,
            @RequestParam("aadharBack") MultipartFile aadharBack,
            @RequestParam("panFront") MultipartFile panFront,
            @RequestParam("panBack") MultipartFile panBack,
            @RequestParam("photograph") MultipartFile photograph,
            RedirectAttributes redirectAttributes) {
        
        try {
            KYCDocument savedDocument = kycDocumentService.saveKYCDocument(
                fullName.trim(), email.trim(), phoneNumber.trim(),
                aadharFront, aadharBack, panFront, panBack, photograph
            );
            
            redirectAttributes.addFlashAttribute("success",
                "KYC documents uploaded successfully! Reference ID: " + savedDocument.getId());
                
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Upload failed: " + e.getMessage());
        }
        
        return "redirect:/kyc/api/upload-form";
    }
    
    @GetMapping("/upload-form")
    public String showUploadForm(Model model) {
        return "kyc-upload";
    }
}

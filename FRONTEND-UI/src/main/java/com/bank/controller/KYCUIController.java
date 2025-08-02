package com.bank.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.*;

@Controller
@RequestMapping("/kyc")
public class KYCUIController {

    // Assuming your API Gateway is running on localhost:8080
    // and the KYC Service is exposed at /kyc/api
    private final String API_GATEWAY_URL = "http://localhost:8080";

    @Autowired
    private RestTemplate restTemplate;

    /**
     * Displays the KYC document upload form.
     * @return The name of the JSP view for the upload form.
     */
    @GetMapping("/form/{customerId}")
    public String showUploadForm() {
        return "kyc-upload";
    }
    
    @GetMapping("/form/success")
    public String showUploadSuccess() {
		return "KYCSuccessfull";
	}
    /**
     * Handles the submission of KYC documents from the frontend.
     * It sends the data to the backend KYC service via the API Gateway.
     *
     * @param fullName The full name of the customer.
     * @param email The email address of the customer.
     * @param phoneNumber The phone number of the customer.
     * @param aadharFront The MultipartFile for the Aadhar card front side.
     * @param aadharBack The MultipartFile for the Aadhar card back side.
     * @param panFront The MultipartFile for the PAN card front side.
     * @param panBack The MultipartFile for the PAN card back side.
     * @param photograph The MultipartFile for the customer's photograph.
     * @param redirectAttributes Used to add flash attributes for success/error messages after redirect.
     * @return A redirect string to the KYC upload form, with messages.
     */
    @PostMapping("/upload")
    public String uploadKYCDocuments(
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam("phoneNumber") String phoneNumber,
            @RequestParam(value = "aadharFront", required = false) MultipartFile aadharFront,
            @RequestParam(value = "aadharBack", required = false) MultipartFile aadharBack,
            @RequestParam(value = "panFront", required = false) MultipartFile panFront,
            @RequestParam(value = "panBack", required = false) MultipartFile panBack,
            @RequestParam(value = "photograph", required = false) MultipartFile photograph,
            RedirectAttributes redirectAttributes) {

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("fullName", fullName.trim());
            body.add("email", email.trim());
            body.add("phoneNumber", phoneNumber.trim());

            // Helper function to add MultipartFile to MultiValueMap
            addFileToBody(body, "aadharFront", aadharFront);
            addFileToBody(body, "aadharBack", aadharBack);
            addFileToBody(body, "panFront", panFront);
            addFileToBody(body, "panBack", panBack);
            addFileToBody(body, "photograph", photograph);

            HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

            // Call the KYC microservice through the API Gateway
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    API_GATEWAY_URL + "/kyc/api/upload", // This path maps to your KYCService's @RequestMapping("/kyc/api") and @PostMapping("/upload")
                    requestEntity,
                    Map.class
            );

            if (response.getStatusCode() == HttpStatus.OK) {
                Map<String, Object> responseBody = response.getBody();
                redirectAttributes.addFlashAttribute("success",
                        "KYC documents uploaded successfully! Reference ID: " + responseBody.get("id"));
            } else {
                // This block might not be reached for 4xx/5xx errors as RestTemplate throws exceptions
                redirectAttributes.addFlashAttribute("error",
                        "Upload failed with status: " + response.getStatusCode());
            }

        } catch (HttpClientErrorException e) {
            // Handle specific HTTP client errors (e.g., 400 Bad Request from backend validation)
            String errorMessage = "Upload failed: " + e.getMessage();
            try {
                // Attempt to parse the error message from the backend response body
                Map<String, Object> errorResponse = e.getResponseBodyAs(Map.class);
                if (errorResponse != null && errorResponse.containsKey("error")) {
                    errorMessage = (String) errorResponse.get("error");
                }
            } catch (Exception parseException) {
                // Log parsing error, but use the default message
                System.err.println("Failed to parse error response: " + parseException.getMessage());
            }
            redirectAttributes.addFlashAttribute("error", errorMessage);
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error",
                    "File processing error: " + e.getMessage());
        } catch (Exception e) {
            // Catch any other unexpected exceptions
            redirectAttributes.addFlashAttribute("error",
                    "An unexpected error occurred during upload: " + e.getMessage());
        }

        return "KYCSuccessfull"; // Redirect back to the upload form
    }

    /**
     * Helper method to add a MultipartFile to the MultiValueMap if it's not empty.
     * @param body The MultiValueMap to add the file to.
     * @param paramName The name of the parameter for the file (e.g., "aadharFront").
     * @param file The MultipartFile to add.
     * @throws IOException If there's an issue reading the file bytes.
     */
    private void addFileToBody(MultiValueMap<String, Object> body, String paramName, MultipartFile file) throws IOException {
        if (file != null && !file.isEmpty()) {
            body.add(paramName, new ByteArrayResource(file.getBytes()) {
                @Override
                public String getFilename() {
                    return file.getOriginalFilename();
                }
            });
        }
    }

    /**
     * Displays the admin panel to view all KYC documents.
     * Fetches documents from the backend service via API Gateway.
     * @param model Model to pass data to the view.
     * @return The name of the JSP view for the admin panel.
     */
    @GetMapping("/admin")
    public String showAdmin(Model model) {
        try {
            ResponseEntity<List> response = restTemplate.getForEntity(
                    API_GATEWAY_URL + "/kyc/api/admin", List.class); // This path maps to your KYCService's /kyc/api/admin
            model.addAttribute("documents", response.getBody());
        } catch (HttpClientErrorException e) {
             model.addAttribute("error", "Error fetching documents: " + e.getResponseBodyAsString());
        } catch (Exception e) {
            model.addAttribute("error", "Unable to fetch KYC documents: " + e.getMessage());
        }
        return "admin-panel-simple";
    }

    /**
     * Views a specific KYC document details.
     * @param id The ID of the document to view.
     * @param model Model to pass data to the view.
     * @return The name of the JSP view for document details.
     */
    @GetMapping("/admin/view/{id}")
    public String viewDocument(@PathVariable Long id, Model model) {
        try {
            ResponseEntity<Map> response = restTemplate.getForEntity(
                    API_GATEWAY_URL + "/kyc/api/admin/view/" + id, Map.class); // This path maps to your KYCService's /kyc/api/admin/view/{id}
            model.addAttribute("document", response.getBody());
            return "document-view";
        } catch (HttpClientErrorException e) {
            // Document not found or other client errors
            return "redirect:/kyc/admin?error=Document not found: " + e.getMessage();
        } catch (Exception e) {
            return "redirect:/kyc/admin?error=Error viewing document: " + e.getMessage();
        }
    }

    /**
     * Deletes a KYC document.
     * @param id The ID of the document to delete.
     * @param redirectAttributes Used to add flash attributes for success/error messages.
     * @return A redirect string to the admin panel.
     */
    @PostMapping("/admin/delete/{id}")
    public String deleteDocument(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            // Using exchange for DELETE as postForObject might not be suitable for DELETE with no request body
            restTemplate.exchange(API_GATEWAY_URL + "/kyc/api/admin/delete/" + id, HttpMethod.DELETE, null, String.class);
            redirectAttributes.addFlashAttribute("success", "Document deleted successfully");
        } catch (HttpClientErrorException e) {
             redirectAttributes.addFlashAttribute("error", "Error deleting document: " + e.getResponseBodyAsString());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting document: " + e.getMessage());
        }
        return "redirect:/kyc/admin";
    }

    /**
     * Updates the status of a KYC document.
     * @param id The ID of the document to update.
     * @param status The new status.
     * @param redirectAttributes Used to add flash attributes for success/error messages.
     * @return A redirect string to the admin panel.
     */
    @PostMapping("/admin/update-status/{id}")
    public String updateStatus(@PathVariable Long id,
                               @RequestParam("status") String status,
                               RedirectAttributes redirectAttributes) {
        try {
            Map<String, String> request = new HashMap<>();
            request.put("status", status);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, String>> entity = new HttpEntity<>(request, headers);

            restTemplate.postForObject(API_GATEWAY_URL + "/kyc/api/admin/update-status/" + id, entity, String.class);
            redirectAttributes.addFlashAttribute("success", "Status updated successfully");
        } catch (HttpClientErrorException e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update status: " + e.getResponseBodyAsString());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update status: " + e.getMessage());
        }
        return "redirect:/kyc/admin";
    }

    /**
     * Health check endpoint for the UI service and to check KYC microservice status.
     * @return A string indicating the health status.
     */
    @GetMapping("/health")
    @ResponseBody
    public String healthCheck() {
        try {
            // Calls the health endpoint of the API Gateway, which should then route to KYC service's health
            String response = restTemplate.getForObject(API_GATEWAY_URL + "/kyc/api/health", String.class);
            return "Frontend UP - KYC Service: " + response;
        } catch (Exception e) {
            return "Frontend UP - KYC Service DOWN: " + e.getMessage();
        }
    }
}
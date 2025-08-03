package com.bank.proxy;

import java.util.List;
import java.util.Map;

import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.bank.model.KYCDocument;

@FeignClient(name = "KYC-SERVICE", url = "http://localhost:8083/kyc/api", path = "/kyc/api")
public interface KYCProxy {

    @GetMapping("/customer/{customerId}")
    List<KYCDocument> getDocumentsByCustomerId(@PathVariable("customerId") String customerId);

    @GetMapping("/all")
    List<KYCDocument> getAllDocuments();

    @GetMapping("/{id}")
    KYCDocument getDocumentById(@PathVariable("id") Long id);

    @PutMapping("/{id}/status")
    KYCDocument updateDocumentStatus(@PathVariable("id") Long id, @RequestBody Map<String, String> statusUpdate);
}

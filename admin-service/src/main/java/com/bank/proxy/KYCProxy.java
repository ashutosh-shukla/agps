package com.bank.proxy;

import java.util.List;

import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.bank.model.KYCDocument;


@FeignClient(name = "KYC-SERVICE", url = "http://localhost:8083/kyc/api", path = "/kyc/api")
public interface KYCProxy {

	 @GetMapping("/customer/{customerId}")
	    List<KYCDocument> getDocumentsByCustomerId(@PathVariable("customerId") String customerId);
	}

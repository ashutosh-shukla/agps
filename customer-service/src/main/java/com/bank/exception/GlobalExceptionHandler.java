package com.bank.exception;

import java.time.LocalDateTime;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import jakarta.servlet.http.HttpServletRequest;

@RestControllerAdvice
public class GlobalExceptionHandler {

	 @ExceptionHandler(CustomerAlreadyExistsException.class)
	    public ResponseEntity<ErrorResponse> handleCustomerAlreadyExists(CustomerAlreadyExistsException ex, HttpServletRequest request) {
	        ErrorResponse error = new ErrorResponse(
	                LocalDateTime.now(),
	                "CONFLICT",
	                ex.getMessage(),
	                request.getRequestURI()
	        );
	        return new ResponseEntity<>(error, HttpStatus.CONFLICT);
	    }
}

package com.bank.exception;

public class CustomerUnavailableException extends RuntimeException {
    public CustomerUnavailableException(String message) {
        super(message);
    }
}

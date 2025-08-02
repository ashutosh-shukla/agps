package com.bank.utils;



import java.util.Random;

public class AccountUtil {
     public static String generateAccountNumber() {
        Random random = new Random();
        int start = 1000000000; // 10-digit starting point
        return String.valueOf(start + random.nextInt(899999999));
    }
}


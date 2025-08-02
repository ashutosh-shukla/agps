package com.bank.utils;

import java.text.DecimalFormat;

public class JspUtil {
    
    public static String formatFileSize(long bytes) {
        if (bytes <= 0) return "0 B";
        
        final String[] units = new String[]{"B", "KB", "MB", "GB"};
        int digitGroups = (int) (Math.log10(bytes) / Math.log10(1024));
        
        DecimalFormat df = new DecimalFormat("#,##0.0");
        double size = bytes / Math.pow(1024, digitGroups);
        
        // Remove unnecessary decimal places for whole numbers
        if (size == Math.floor(size)) {
            df = new DecimalFormat("#,##0");
        }
        
        return df.format(size) + " " + units[digitGroups];
    }
    
    public static String truncateString(String str, int maxLength) {
        if (str == null || str.length() <= maxLength) {
            return str;
        }
        return str.substring(0, maxLength) + "...";
    }
    
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }
}

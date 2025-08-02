package com.bank.utils;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Arrays;
import java.util.List;

public class FileUtil {
    
    private static final List<String> ALLOWED_IMAGE_TYPES = Arrays.asList(
        "image/jpeg", "image/jpg", "image/png", "image/gif", "image/bmp"
    );
    
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
    
    public static boolean isValidImageFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return false;
        }
        
        // Check file size
        if (file.getSize() > MAX_FILE_SIZE) {
            return false;
        }
        
        // Check content type
        String contentType = file.getContentType();
        return contentType != null && ALLOWED_IMAGE_TYPES.contains(contentType.toLowerCase());
    }
    
    public static String formatFileSize(long bytes) {
        if (bytes <= 0) return "0 B";
        
        final String[] units = new String[]{"B", "KB", "MB", "GB"};
        int digitGroups = (int) (Math.log10(bytes) / Math.log10(1024));
        
        DecimalFormat df = new DecimalFormat("#,##0.#");
        return df.format(bytes / Math.pow(1024, digitGroups)) + " " + units[digitGroups];
    }
    
    public static void validateImageFile(MultipartFile file, String fieldName) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IOException(fieldName + " is required");
        }
        
        if (!isValidImageFile(file)) {
            throw new IOException(fieldName + " must be a valid image file (JPG, PNG, GIF, BMP) and less than 10MB");
        }
    }
}

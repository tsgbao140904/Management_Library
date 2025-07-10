package com.library.util;

import java.time.LocalDate;

public class DateProvider {
    private static DateProvider instance;
    private LocalDate mockDate;

    private DateProvider() {
        this.mockDate = null; // Sử dụng ngày hiện tại nếu không có mock
    }

    public static synchronized DateProvider getInstance() {
        if (instance == null) {
            instance = new DateProvider();
        }
        return instance;
    }

    public LocalDate getCurrentDate() {
        return (mockDate != null) ? mockDate : LocalDate.now();
    }

    public void setMockDate(LocalDate mockDate) {
        this.mockDate = mockDate;
    }

    public void clearMockDate() {
        this.mockDate = null;
    }
}
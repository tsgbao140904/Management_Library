package com.library.model.strategy;

import com.library.model.Loan;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class DailyFeeCalculator implements FeeCalculator {
    private static final double FEE_PER_DAY = 5000.0; // 5.000 VNĐ/ngày
    private static final double LATE_FEE_PER_DAY = 3000.0; // 3.000 VNĐ/ngày trễ

    @Override
    public double calculateFee(Loan loan) {
        LocalDate borrowDate = loan.getBorrowDate();
        LocalDate dueDate = loan.getDueDate();
        if (borrowDate == null || dueDate == null) {
            return 0.0;
        }

        LocalDate endDate = loan.getReturnDate() != null ? loan.getReturnDate() : LocalDate.now();
        // Số ngày mượn (tối thiểu 1)
        long daysBorrowed = ChronoUnit.DAYS.between(borrowDate, endDate) + 1;
        daysBorrowed = Math.max(1, daysBorrowed);
        // Số ngày trễ (tối thiểu 0)
        long daysLate = endDate.isAfter(dueDate) ? ChronoUnit.DAYS.between(dueDate, endDate) : 0;
        daysLate = Math.max(0, daysLate);
        // Tổng phí
        return daysBorrowed * FEE_PER_DAY + daysLate * LATE_FEE_PER_DAY;
    }
}
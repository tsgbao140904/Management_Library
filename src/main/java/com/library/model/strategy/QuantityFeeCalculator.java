package com.library.model.strategy;

import com.library.model.Loan;
import com.library.util.DateProvider;

import java.time.LocalDate;

public class QuantityFeeCalculator implements FeeCalculator {
    private static final double FEE_PER_LOAN = 30000.0; // 30.000 VNĐ/lần mượn
    private static final double LATE_FEE_PER_DAY = 3000.0; // 3.000 VNĐ/ngày trễ

    @Override
    public double calculateFee(Loan loan) {
        LocalDate dueDate = loan.getDueDate();
        if (dueDate == null) {
            return 0.0;
        }

        LocalDate endDate = loan.getReturnDate() != null ? loan.getReturnDate() : DateProvider.getInstance().getCurrentDate();
        // Số ngày trễ (tối thiểu 0)
        long daysLate = endDate.isAfter(dueDate) ? java.time.temporal.ChronoUnit.DAYS.between(dueDate, endDate) : 0;
        daysLate = Math.max(0, daysLate);
        // Tổng phí = phí mượn cố định + phí trễ (nếu có)
        return FEE_PER_LOAN + daysLate * LATE_FEE_PER_DAY;
    }
}
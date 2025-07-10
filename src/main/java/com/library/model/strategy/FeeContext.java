package com.library.model.strategy;

import com.library.model.Loan;

public class FeeContext {
    private FeeCalculator feeCalculator;

    public FeeContext(FeeCalculator feeCalculator) {
        this.feeCalculator = feeCalculator;
    }

    public double calculateFee(Loan loan) {
        if (feeCalculator != null && loan != null) {
            return feeCalculator.calculateFee(loan);
        }
        return 0.0;
    }

    public void setFeeCalculator(FeeCalculator feeCalculator) {
        this.feeCalculator = feeCalculator;
    }
}
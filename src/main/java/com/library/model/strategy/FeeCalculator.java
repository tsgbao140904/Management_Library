package com.library.model.strategy;

import com.library.model.Loan;

public interface FeeCalculator {
    double calculateFee(Loan loan);
}
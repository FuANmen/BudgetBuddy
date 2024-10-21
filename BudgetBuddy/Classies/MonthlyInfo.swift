//
//  MonthlyInfo.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/09/30.
//

import Foundation

class MonthlyInfo: ObservableObject {
    var walletId: String
    var yearMonth: String
    @Published var monthlyGoals: MonthlyGoals
    @Published var monthlyTransactions: MonthlyTransactions
    
    public init(walletId: String, yearMonth: String, monthlyGoals: MonthlyGoals, monthlyTransactions: MonthlyTransactions) {
        self.walletId = walletId
        self.yearMonth = yearMonth
        self.monthlyGoals = monthlyGoals
        self.monthlyTransactions = monthlyTransactions
    }
}

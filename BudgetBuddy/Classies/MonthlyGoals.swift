//
//  MonthlyGoals.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/09/27.
//

import Foundation

class MonthlyGoals: ObservableObject {
    var walletId: String
    var targetMonth: String
    var budgetBreakdowns: [BudgetBreakdown]
    @Published var goals: [Goal]
    
    init(walletId: String, targetMonth: String, budgetBreakdowns: [BudgetBreakdown], goals: [Goal]) {
        self.walletId = walletId
        self.targetMonth = targetMonth
        self.budgetBreakdowns = budgetBreakdowns
        self.goals = goals
    }
    
    init?(dictionary: [String: Any]) {
        guard let walletId = dictionary["walletId"] as? String,
              let targetMonth = dictionary["targetMonth"] as? String,
              let budgetBreakdownsData = dictionary["budgetBreakdowns"] as? [[String: Any]],
              let goalsData = dictionary["goals"] as? [[String: Any]] else {
            return nil
        }
        self.walletId = walletId
        self.targetMonth = targetMonth
        self.budgetBreakdowns = budgetBreakdownsData.map { document in
            BudgetBreakdown(dictionary: document)!
        }
        self.goals = goalsData.map { document in
            Goal(dictionary: document)!
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "walletId": walletId,
            "targetMonth": targetMonth,
            "budgetBreakdowns": budgetBreakdowns.map { $0.toDictionary() },
            "goals": goals.map { $0.toDictionary() }
        ]
    }
    
    internal func getTotalBudget() -> Double{
        var budget = 0.0
        self.budgetBreakdowns.forEach { breakdown in
            budget += breakdown.amount
        }
        return budget
    }
}

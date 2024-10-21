//
//  Goal.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/09/26.
//

import Foundation


class Goal: ObservableObject, Identifiable, Hashable {
    var id: String { categoryId }
    var categoryId: String
    @Published var budget: Double
    
    init(categoryId: String, budget: Double) {
        self.categoryId = categoryId
        self.budget = budget
    }

    init?(dictionary: [String: Any]) {
        guard let categoryId = dictionary["categoryId"] as? String,
              let budget = dictionary["budget"] as? Double else {
            return nil
        }
        self.categoryId = categoryId
        self.budget = budget
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "categoryId": categoryId,
            "budget": budget
        ]
    }
    
    // Hashableプロトコルへの準拠
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

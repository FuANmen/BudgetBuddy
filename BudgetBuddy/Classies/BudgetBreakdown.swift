//
//  BudgetBreakdown.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/09/27.
//

import Foundation

class BudgetBreakdown {
    var id: String
    var title: String
    var amount: Double
    
    init(id: String? = nil, title: String, amount: Double) {
        if id == nil {
            self.id = BudgetBreakdown.getId()
        } else {
            self.id = id!
        }
        self.title = title
        self.amount = amount
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let title = dictionary["title"] as? String,
              let amount = dictionary["amount"] as? Double else {
            return nil
        }
        self.id = id
        self.title = title
        self.amount = amount
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "amount": amount
        ]
    }
    
    static func getId() -> String {
        return String(format: "%04d", Int.random(in: 1...1000))
    }
}

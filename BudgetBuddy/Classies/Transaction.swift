//
//  Transaction.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/09/27.
//

import Foundation

class Transaction: ObservableObject, Equatable, Identifiable {
    var id: String { tranId }
    var tranId: String
    @Published var date: Date
    var categoryId: String
    @Published var title: String
    @Published var amount: Double
    
    init(id: String? = nil, date: Date, categoryId: String, title: String, amount: Double) {
        if id != nil {
            self.tranId = id!
        } else {
            self.tranId = Transaction.getId()
        }
        self.date = date
        self.categoryId = categoryId
        self.title = title
        self.amount = amount
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let date = dictionary["date"] as? Date,
              let categoryId = dictionary["categoryId"] as? String,
              let title = dictionary["title"] as? String,
              let amount = dictionary["amount"] as? Double else {
            return nil
        }
        self.tranId = id
        self.date = date
        self.categoryId = categoryId
        self.title = title
        self.amount = amount
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": tranId,
            "date": date,
            "categoryId": categoryId,
            "title": title,
            "amount": amount
        ]
    }
    
    static func getId() -> String {
        return String(format: "%04d", Int.random(in: 1...1000))
    }
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id // walletId を使用して等価性を比較
    }
}

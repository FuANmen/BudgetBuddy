import Foundation
import SwiftUI

class MonthlyTransactions: ObservableObject {
    var walletId: String
    var targetMonth: String
    @Published var transactions: [Transaction]  // 変更可能で監視可能にする
    
    init (walletId: String, targetMonth: String, transactions: [Transaction]) {
        self.walletId = walletId
        self.targetMonth = targetMonth
        self.transactions = transactions
    }
    
    init?(dictionary: [String: Any]) {
        guard let walletId = dictionary["walletId"] as? String,
              let targetMonth = dictionary["targetMonth"] as? String,
              let transactionsData = dictionary["transactions"] as? [[String: Any]] else {
            return nil
        }
        self.walletId = walletId
        self.targetMonth = targetMonth
        self.transactions = transactionsData.map { document in
            Transaction(dictionary: document)!
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "walletId": walletId,
            "targetMonth": targetMonth,
            "transactions": transactions.map { $0.toDictionary() }
        ]
    }
    
    // 当月の支出総額を取得
    internal func getExpense() -> Double {
        return transactions.reduce(0) { $0 + $1.amount }
    }
    
    internal func getCategoryOfExpense(categoryId: String) -> Double {
        var expense = 0.0
        self.transactions.forEach { trans in
            if trans.categoryId == categoryId {
                expense += trans.amount
            }
        }
        return expense
    }
    
    internal func getCategoryOfTransactions(categoryId: String) -> [Transaction] {
        var transactions: [Transaction] = []
        self.transactions.forEach { trans in
            if trans.categoryId == categoryId {
                transactions.append(trans)
            }
        }
        return transactions
    }
}

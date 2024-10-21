//
//  Wallet.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/09/26.
//

import Foundation

// Wallet クラスの定義（省略なし）
class Wallet: Identifiable, Equatable {
    var id: String { walletId } // `Identifiable` プロトコルを満たすために `id` プロパティを追加
    var walletId: String
    var name: String
    var ownerId: String
    var isDefault: Bool
    var isPrivate: Bool
    var sortOrder: Int
    var categories: [Category]
    
    init(walletId: String? = nil, name: String, ownerId: String, isDefault: Bool, isPrivate: Bool, sortOrder: Int, categories: [Category] = []) {
        self.walletId = walletId ?? UUID().uuidString // デフォルトでUUIDを設定
        self.name = name
        self.ownerId = ownerId
        self.isDefault = isDefault
        self.isPrivate = isPrivate
        self.sortOrder = sortOrder
        self.categories = categories
    }
    
    // Equatable プロトコルの要件を満たすためのメソッド
    static func == (lhs: Wallet, rhs: Wallet) -> Bool {
        return lhs.walletId == rhs.walletId // walletId を使用して等価性を比較
    }
}

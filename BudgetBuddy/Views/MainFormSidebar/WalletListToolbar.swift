//
//  WalletListToolbar.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/09/24.
//

import SwiftUI

struct WalletListToolbar: View {
    @State private var showAlert = false // アラートの表示状態を管理

    // 親から渡されるクロージャ
    var onCreateNewWallet: () -> Void // 新しいウォレットを作成するクロージャ
    var onAddExistingWallet: () -> Void // 既存ウォレットを追加するクロージャ

    var body: some View {
        HStack {
           Spacer()
           Button(action: {
               showAlert = true
           }) {
               Image(systemName: "plus") // SF Symbols のアイコンを使用
                   .resizable() // アイコンのサイズを変更可能にする
                   .frame(width: 24, height: 24) // サイズを指定
                   .foregroundColor(.blue)
           }
           .padding()
        }
        .alert(isPresented: $showAlert) {
           Alert(
               title: Text("Choose an Action"),
               message: Text("Would you like to create a new Wallet or add an existing Wallet to Shared Wallet?"),
               primaryButton: .default(Text("Create New Wallet")) {
                   onCreateNewWallet()
               },
               secondaryButton: .default(Text("Add Existing Wallet")) {
                   onAddExistingWallet()
               }
           )
        }
    }
}



struct WalletListToolbar_Previews: PreviewProvider {
    static var previews: some View {
        WalletListToolbar(
            onCreateNewWallet: {
                print("Create New Wallet tapped")
            },
            onAddExistingWallet: {
                print("Add Existing Wallet tapped")
            }
        )
    }
}

//
//  NewWalletForm.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/09/26.
//

import SwiftUI

struct NewWalletForm: View {
    @Binding var isPresented: Bool // フォームの表示状態を管理
    @Binding var wallets: [Wallet] // Walletのリストへのバインディング
    
    @State private var walletName: String = "" // フォームの入力内容
    @State private var ownerId: String = "" // 所有者IDの入力
    @State private var isDefault: Bool = false // デフォルトかどうか
    @State private var isPrivate: Bool = false // プライベートかどうか

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Wallet Details")) {
                    TextField("Wallet Name", text: $walletName)
                    TextField("Owner ID", text: $ownerId)
                    Toggle(isOn: $isDefault) {
                        Text("Set as Default")
                    }
                    Toggle(isOn: $isPrivate) {
                        Text("Private Wallet")
                    }
                }
                
                Button(action: {
                    // 新しい Wallet を作成
                    let newWallet = Wallet(
                        name: walletName,
                        ownerId: ownerId,
                        isDefault: isDefault,
                        isPrivate: isPrivate,
                        sortOrder: wallets.count + 1,
                        categories: []
                    )
                    wallets.append(newWallet) // Wallet をリストに追加
                    isPresented = false // フォームを閉じる
                }) {
                    Text("Create Wallet")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Create New Wallet")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false // キャンセルボタンでフォームを閉じる
            })
        }
    }
}

struct NewWalletForm_Previews: PreviewProvider {
    static var previews: some View {
        // プレビュー用の固定値
        NewWalletForm(
            isPresented: .constant(true), // フォームを表示状態にする
            wallets: .constant([]) // 空の Wallet リスト
        )
    }
}

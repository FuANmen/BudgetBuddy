//
//  SideMenuView.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/09/26.
//

import SwiftUI

struct MainFormSidebar: View {
    // 表示するフォームID
    private let NewWalletForm_001: Int = 1
    private let SelectExistWalletForm_002: Int = 2
    
    // ユーザ情報
    @Binding var userInfo: UserInfo
    // Wallet情報
    @Binding var selectedWallet: Wallet?
    @State var userWallets: [Wallet]
    @State var sharedWallets: [Wallet]
    
    @State var showForm = false // フォーム表示状態を管理
    @State var showFormID: Int?
    
    public init(userInfo: Binding<UserInfo>,
                selectedWallet: Binding<Wallet?>) {
        self._userInfo = userInfo
        self._selectedWallet = selectedWallet
        
        // TODO: ユーザ情報からWallet情報を取得
        self.userWallets = [
            Wallet(walletId: "001", name: "Personal", ownerId: "1", isDefault: true, isPrivate: false, sortOrder: 1)
        ]
        self.sharedWallets = [
            Wallet(name: "Family", ownerId: "2", isDefault: true, isPrivate: false, sortOrder: 2)
        ]
        
        if self.selectedWallet == nil {
            if !self.userWallets.isEmpty {
                self.selectedWallet = self.userWallets.first
            }
            else if !self.sharedWallets.isEmpty {
                self.selectedWallet = self.sharedWallets.first
            }
        }
    }
    
    var body: some View {
        ZStack {
            // 背景に影をつけたい要素
            Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                .ignoresSafeArea() // 画面全体をカバーする
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 0) // 影をつける
            VStack {
                UserInfoAria(userInfo: self.userInfo)
                WalletListForm(userWallets: self.$userWallets,
                               sharedWallets: self.$sharedWallets,
                               selectedWallet: self.$selectedWallet)
                WalletListToolbar(
                    onCreateNewWallet: {
                        self.showForm = true
                        self.showFormID = NewWalletForm_001
                    },
                    onAddExistingWallet: {
                        self.showForm = true
                        self.showFormID = SelectExistWalletForm_002
                    }
                )
            }
            .onAppear {
                if selectedWallet == nil && !userWallets.isEmpty {
                    self.selectedWallet = userWallets.first
                }
                else if selectedWallet == nil && !sharedWallets.isEmpty {
                    self.selectedWallet = sharedWallets.first
                }
            }
            .sheet(isPresented: $showForm) {
                switch (self.showFormID) {
                case NewWalletForm_001:
                    NewWalletForm(isPresented: $showForm, wallets: $userWallets)
                    // TODO:
                case SelectExistWalletForm_002:
                    NewWalletForm(isPresented: $showForm, wallets: $userWallets)
                case .none:
                    // TODO:
                    NewWalletForm(isPresented: $showForm, wallets: $userWallets)
                case .some(_):
                    // TODO:
                    NewWalletForm(isPresented: $showForm, wallets: $userWallets)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        @State var userInfo: UserInfo = UserInfo(name: "User01")
        @State var selectedWallet: Wallet? = nil
        
        MainFormSidebar(userInfo: $userInfo, selectedWallet: $selectedWallet)
    }
}

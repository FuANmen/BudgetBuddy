//
//  MainFormToolbarForm.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/09/27.
//

import SwiftUI

struct MainFormToolbarForm: View {
    var humburgerBtnTapped: () -> Void
    var walletSettingBtnTapped: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                self.humburgerBtnTapped()
            }) {
                Image(systemName: "line.3.horizontal") // SF Symbols のアイコンを使用
                    .resizable() // アイコンのサイズを変更可能にする
                    .frame(width: 20, height: 16) // サイズを指定
                    .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
            }
            .padding(.leading)
            Spacer()
            Button(action: {
                self.walletSettingBtnTapped()
            }) {
                Image(systemName: "gearshape") // SF Symbols のアイコンを使用
                    .resizable() // アイコンのサイズを変更可能にする
                    .frame(width: 20, height: 20) // サイズを指定
                    .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
            }
            .padding(.trailing)
        }
    }
}

#Preview {
    MainFormToolbarForm(humburgerBtnTapped: {}, walletSettingBtnTapped: {})
}

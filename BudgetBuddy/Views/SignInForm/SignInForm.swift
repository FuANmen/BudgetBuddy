//
//  SignInForm.swift
//  BudgetBuddey(SwiftUI)
//
//  Created by 柴田健作 on 2024/09/22.
//

import SwiftUI

struct SignInForm: View {
    var onSubmit: (String, String) -> Void
    
    @State private var userName: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("メールアドレス", text: $userName)
                    SecureField("パスワード", text: $password)
                }
                
                Button(action: {
                    self.onSubmit(userName, password)
                }) {
                    Text("アカウント作成")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("新規作成")
        }
    }
}

struct SignInForm_Previews: PreviewProvider {
    static var previews: some View {
        SignInForm(onSubmit: { username, password in
            print("\(username) \(password)")
        })
    }
}

//
//  UserInfoForm.swift
//  BudgetBuddey(SwiftUI)
//
//  Created by 柴田健作 on 2024/09/23.
//

import SwiftUI

struct UserInfoAria: View {
    let userInfo: UserInfo
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcom")
                    .font(.caption)
                Text("\(self.userInfo.name)")
                    .font(.title)
            }
            Spacer()
            Image(systemName: "person")
                .padding()
                .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .background(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
                .clipShape(Circle())
        }
        .padding()
    }
}

#Preview {
    UserInfoAria(userInfo: UserInfo(name: "Test User"))
}

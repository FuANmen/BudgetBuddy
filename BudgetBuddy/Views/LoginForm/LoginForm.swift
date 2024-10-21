import SwiftUI
import Firebase
import FirebaseAuth

struct LoginForm: View {
    @EnvironmentObject private var monthlyInfo: MonthlyInfo
    @State private var email: String = "s.ke.marisa@gmail.com"
    @State private var password: String = "K68k4839"
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = false
    
    private var currentMonth: String
    
    init() {
        // 現在の日付を"yyyy-MM"の形式で取得
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        self.currentMonth = dateFormatter.string(from: Date())
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                
                Button(action: login) {
                    Text("Login")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding(.top)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            // ログイン状態に応じて遷移
            .navigationDestination(isPresented: $isLoggedIn) {
                MainFormView(userInfo: UserInfo(name: "Test"), targetMonth: self.currentMonth)
            }
        }
    }
    
    private func login() {
        // TODO: Login
        isLoggedIn = true
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                print(errorMessage)
//                errorMessage = error.localizedDescription
//                return
//            }
//
//            // ログイン成功
//            isLoggedIn = true
//        }
    }
}

#Preview {
    LoginForm()
}

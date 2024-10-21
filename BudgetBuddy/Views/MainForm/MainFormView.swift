import SwiftUI

struct MainFormView: View {
    @State var userInfo: UserInfo
    @State var selectedWallet: Wallet? = nil
    @State var selectedGoal: Goal? = nil
    
    @State var sidebarShow: Bool = false
    @State var walletSettingShow: Bool = false
    @State var showExpenses: Bool = false
    @State var showBudget: Bool = false
    @State var showGoal: Bool = false
    
    let sidebarWidth: CGFloat = 250 // サイドバーの幅
    
    @EnvironmentObject var monthlyInfo: MonthlyInfo
    @State var targetMonth: String
    
    private let inExFormHeight: Double = 120

    var body: some View {
        ZStack(alignment: .leading) {
            if selectedWallet != nil {
                // メインの月ごとのフォーム
                MonthlyInfosForm(targetMonth: $targetMonth,
                                 selectedWallet: $selectedWallet,
                                 selectedGoal: $selectedGoal,
                                 showExpenses: $showExpenses,
                                 showBudget: $showBudget,
                                 showGoal: $showGoal)
                .environmentObject(self.monthlyInfo)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: sidebarShow ? sidebarWidth : 0)
                .animation(.easeInOut(duration: 0.3), value: sidebarShow)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 70 {
                                sidebarShow = true
                            }
                        }
                )
            }
            // サイドバー
            MainFormSidebar(userInfo: $userInfo, selectedWallet: $selectedWallet)
                .frame(width: sidebarWidth, height: .infinity) // サイドバーの固定幅
                .background(Color.white)
                .offset(x: sidebarShow ? 0 : -sidebarWidth)
                .animation(.easeInOut(duration: 0.3), value: sidebarShow)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -70 {
                                sidebarShow = false
                            }
                        }
                )
            // 背景をタッチできないようにする半透明のオーバーレイ
            Color.black.opacity(sidebarShow ? 0.3 : 0) // オーバーレイの透明度
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width) // オーバーレイを画面全体に広げる
                .offset(x: sidebarShow ? sidebarWidth : 0) // サイドバーが出るときにスライド
                .animation(.easeInOut(duration: 0.3), value: sidebarShow) // アニメーションを設定
                .onTapGesture {
                    sidebarShow.toggle() // オーバーレイをタップしてサイドバーを閉じる
                }
        }
        .navigationBarBackButtonHidden(true) // デフォルトの戻るボタンを非表示
        .toolbar {
            // カスタムタイトル
            ToolbarItem(placement: .principal) {
                Text(selectedWallet?.name ?? "non selected")
                    .font(.subheadline)
                    .foregroundColor(!sidebarShow ? .black : .clear)
                    .animation(.easeInOut(duration: 0.15), value: sidebarShow)
            }
            // 左側のボタン (ハンバーガーメニューを戻るボタンの代わりに)
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    sidebarShow.toggle() // サイドバーを開く
                }) {
                    Image(systemName: "line.horizontal.3")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 30, height: 30)
                }
                .opacity(!sidebarShow ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.15), value: sidebarShow)
            }

            // 右側のボタン (設定)
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    walletSettingShow = true // 設定画面を開く
                }) {
                    Image(systemName: "gearshape")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 30, height: 30)
                }
                .opacity(!sidebarShow ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.15), value: sidebarShow)
            }
        }
        .onChange(of: selectedWallet) {
            self.sidebarShow = false
        }
        .sheet(isPresented: $walletSettingShow) {
            WalletEditForm(wallet: $selectedWallet)
        }
        .navigationDestination(isPresented: $showExpenses) {
            if selectedWallet != nil {
                MonthlyTransactionsForm(wallet: self.$selectedWallet,
                                        targetMonth: self.$targetMonth)
                .environmentObject(self.monthlyInfo)
            } else {
                Text("No transactions available")
            }
        }
        .navigationDestination(isPresented: $showBudget) {
            if selectedWallet != nil {
                BudgetForm(budgetBreakdowns: Binding(
                    get: { monthlyInfo.monthlyGoals.budgetBreakdowns },
                    set: { _ in }))
            } else {
                Text("No transactions available")
            }
        }
        .navigationDestination(isPresented: $showGoal) {
            if let selectedGoal = selectedGoal,
               let selectedWallet = selectedWallet,
               let index = monthlyInfo.monthlyGoals.goals.firstIndex(where: { $0.categoryId == selectedGoal.categoryId })
            {
                // $monthlyGoals.goals[index] のようにバインディングを作成
                GoalForm(wallet: $selectedWallet,
                         targetMonth: $targetMonth,
                         showGoalCategoryId: selectedGoal.categoryId)
                .environmentObject(self.monthlyInfo)
            }
        }
    }
}

// Preview
struct MainFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainFormView(userInfo: UserInfo(name: "Test"), targetMonth: "2024-10")
        }
    }
}

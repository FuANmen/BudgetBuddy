import SwiftUI

struct GoalsListForm: View {
    @Binding var showGoal: Bool
    @Binding var selectedGoal: Goal?
    @ObservedObject var monthlyInfo: MonthlyInfo
    
    @State var showNewGoalForm: Bool = false
    @State private var isFlashing = false // 点滅状態のための変数

    var body: some View {
        ZStack {
            ScrollViewReader { reader in
                List(self.monthlyInfo.monthlyGoals.goals) { goal in
                    VStack(spacing: 0) {
                        HStack(alignment: .center) {
                            Text("\(goal.categoryId) :")
                                .font(.title)
                                .padding(.top)
                                .padding(.leading)
                            Spacer()
                            Text("¥\(Int(getGoalRemain(goal: goal)))")
                                .font(.title)
                                .padding(.top)
                                .padding(.trailing)
                        }
                        // progressをBindingに変更
                        RoundedProgressBarView(progress: getGoalRemain(goal: goal),
                                               total: goal.budget)
                            .padding(.top, 12)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                        HStack {
                            Text("0")
                            Spacer()
                            Text("\(String(format: "%.1f", goal.budget / 10000.0))万")
                        }
                        .padding(.bottom, 10)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    }
                    .background(
                        goal == monthlyInfo.monthlyGoals.goals.last && isFlashing
                            ? Color.gray.opacity(0.2) // 点滅の色
                            : Color.clear
                    )
                    .onTapGesture {
                        self.selectedGoal = goal
                        self.showGoal = true
                    }
                }
                .listStyle(GroupedListStyle())
                .sheet(isPresented: $showNewGoalForm) {
                    NewGoalForm(isPresented: $showNewGoalForm,
                                addNewGoal: { newGoal in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.monthlyInfo.monthlyGoals.goals.append(newGoal)

                            if self.monthlyInfo.monthlyGoals.goals.count > 0 {
                                reader.scrollTo(self.monthlyInfo.monthlyGoals.goals.last!.categoryId)
                                // 点滅アニメーションを開始
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isFlashing = true
                                }
                                // 点滅後にリセット
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        isFlashing = false
                                    }
                                }
                            }
                        }
                    })
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showNewGoalForm = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
        }
    }
    
    private func getGoalRemain(goal: Goal) -> Double {
        return goal.budget - monthlyInfo.monthlyTransactions.getCategoryOfExpense(categoryId: goal.categoryId)
    }
}


#Preview {
    ZStack {
        @State var showGoal: Bool = false
        @State var selectedGoal: Goal? = nil
        @State var monthlyInfo: MonthlyInfo = MonthlyInfo(walletId: "001", yearMonth: "2024-09", monthlyGoals: MonthlyGoals(walletId: "001",
                                                             targetMonth: "2024-09",
                                                             budgetBreakdowns: [
                                                                BudgetBreakdown(id: "001",
                                                                                title: "給料",
                                                                                amount: 20400000)
                                                             ],
                                                             goals: [
                                                                Goal(categoryId: "001", budget: 30000),
                                                                Goal(categoryId: "002", budget: 20000),
                                                                Goal(categoryId: "003", budget: 10000)
                                                             ]), monthlyTransactions: MonthlyTransactions(walletId: "001",
                                                                                  targetMonth: "2024-09",
                                                                                  transactions: [
                                                                                    Transaction(id: "001", date: Date(), categoryId: "001", title: "食費", amount: 2000)
                                                                                  ]))
        
        GoalsListForm(showGoal: $showGoal, selectedGoal: $selectedGoal, monthlyInfo: monthlyInfo)
    }
}

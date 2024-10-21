import SwiftUI

struct MonthlyInfosForm: View {
    @EnvironmentObject var monthlyInfo: MonthlyInfo
    @Binding var targetMonth: String
    @Binding var selectedWallet: Wallet?
    @Binding var selectedGoal: Goal?
    @Binding var showExpenses: Bool
    @Binding var showBudget: Bool
    @Binding var showGoal: Bool
    
    @State private var showNewGoalForm = false
    @State private var isFlashing = false
    
    private let inExFormHeight: Double = 120

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    // MonthlyInExForm部分
                    HStack {
                        Button(action: {
                            self.subOneMonth()
                        }) {
                            Image(systemName: "chevron.compact.left")
                                .font(.system(size: 40))
                                .foregroundColor(Color.blue)
                        }
                        .padding(.leading, 2)
                        
                        Text("\(targetMonth.suffix(2))月")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top)
                            .padding(.bottom)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(width: 80)
                            .scaleEffect(isFlashing ? 1.2 : 1.0)
                            .animation(.easeOut(duration: 0.2), value: isFlashing)
                        
                        Divider()
                            .background(Color.gray.opacity(0.8))
                            .padding(.top, 2)
                            .padding(.bottom, 2)

                        VStack {
                            HStack {
                                Text("予算 :")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.green)
                                Spacer()
                                Text("¥\(Int(monthlyInfo.monthlyGoals.getTotalBudget()))")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.green)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .padding(.trailing, 2)
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color.gray)
                            }
                            .onTapGesture {
                                showBudget = true
                            }
                            
                            Divider()
                                .background(Color.gray.opacity(0.8))

                            HStack {
                                Text("残高 :")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.blue)
                                Spacer()
                                Text("¥\(Int(getTotalRemain()))")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.blue)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .padding(.trailing, 2)
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color.gray)
                            }
                            .onTapGesture {
                                showExpenses = true
                            }
                        }

                        Button(action: {
                            if !self.compareYearMonth() {
                                self.addOneMonth()
                            }
                        }) {
                            Image(systemName: "chevron.compact.right")
                                .font(.system(size: 40))
                                .foregroundColor(Color.blue)
                                .opacity(self.compareYearMonth() ? 0.0 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: self.compareYearMonth())
                        }
                        .padding(.leading)
                        .padding(.trailing, 2)
                    }
                    .frame(height: inExFormHeight)
                    .onChange(of: targetMonth) {
                        isFlashing = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                isFlashing = false
                            }
                        }
                    }
                    .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 10)

                    // GoalsListForm部分
                    ScrollViewReader { reader in
                        List(self.monthlyInfo.monthlyGoals.goals) { goal in
                            VStack(spacing: 0) {
                                HStack {
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
                                    ? Color.gray.opacity(0.2)
                                    : Color.clear
                            )
                            .onTapGesture {
                                self.selectedGoal = goal
                                self.showGoal = true
                            }
                        }
                        .listStyle(GroupedListStyle())
                        .sheet(isPresented: $showNewGoalForm) {
                            NewGoalForm(isPresented: $showNewGoalForm, addNewGoal: { newGoal in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.monthlyInfo.monthlyGoals.goals.append(newGoal)
                                    if self.monthlyInfo.monthlyGoals.goals.count > 0 {
                                        reader.scrollTo(self.monthlyInfo.monthlyGoals.goals.last!.categoryId)
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            isFlashing = true
                                        }
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
    }

    private func getTotalRemain() -> Double {
        return monthlyInfo.monthlyGoals.getTotalBudget() - monthlyInfo.monthlyTransactions.getExpense()
    }

    private func getGoalRemain(goal: Goal) -> Double {
        return goal.budget - monthlyInfo.monthlyTransactions.getCategoryOfExpense(categoryId: goal.categoryId)
    }
    
    private func compareYearMonth() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        if let targetDate = dateFormatter.date(from: self.targetMonth) {
            let currentDate = Date()
            let calendar = Calendar.current
            let targetComponents = calendar.dateComponents([.year, .month], from: targetDate)
            let currentComponents = calendar.dateComponents([.year, .month], from: currentDate)
            
            return targetComponents.year == currentComponents.year && targetComponents.month == currentComponents.month
        } else {
            return false
        }
    }
    
    private func addOneMonth() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        if let currentDate = dateFormatter.date(from: targetMonth) {
            if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) {
                targetMonth = dateFormatter.string(from: nextMonth)
            }
        }
    }
    
    private func subOneMonth() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        if let currentDate = dateFormatter.date(from: targetMonth) {
            if let nextMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) {
                targetMonth = dateFormatter.string(from: nextMonth)
            }
        }
    }
}

struct MonthlyInfosForm_Previews: PreviewProvider {
    static var previews: some View {
        // プレビュー用のダミーデータ
        @State var monthlyInfo: MonthlyInfo =
            MonthlyInfo(walletId: "001", yearMonth: "2024-10", monthlyGoals: MonthlyGoals(
                walletId: "001", targetMonth: "2024-10", budgetBreakdowns: [
                    BudgetBreakdown(id: "001", title: "給料", amount: 200000),
                    BudgetBreakdown(id: "002", title: "副収入", amount: 0000)
                ], goals: [
                    Goal(categoryId: "001", budget: 30000),
                    Goal(categoryId: "002", budget: 20000),
                    Goal(categoryId: "003", budget: 10000)
                ]), monthlyTransactions: MonthlyTransactions(
                    walletId: "001", targetMonth: "2024-10", transactions: [
                        Transaction(id: "001", date: Date(), categoryId: "001", title: "食費", amount: 50000),
                        Transaction(id: "002", date: Date(), categoryId: "002", title: "衣服", amount: 30000),
                        Transaction(id: "003", date: Date(), categoryId: "000", title: "その他", amount: 60000)
                    ])
            )
        
        @State var targetMonth = "2024-10"
        @State var selectedWallet: Wallet? = Wallet(walletId: "001", name: "001", ownerId: "001", isDefault: false, isPrivate: false, sortOrder: 0)
        @State var selectedGoal: Goal? = nil
        @State var showExpenses = false
        @State var showBudget = false
        @State var showGoal = false
        
        // MonthlyInfosFormのプレビュー
        MonthlyInfosForm(targetMonth: $targetMonth,
                         selectedWallet: $selectedWallet,
                         selectedGoal: $selectedGoal,
                         showExpenses: $showExpenses,
                         showBudget: $showBudget,
                         showGoal: $showGoal)
        .environmentObject(MonthlyInfoCash())
    }
}

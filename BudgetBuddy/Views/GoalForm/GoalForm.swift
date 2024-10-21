import SwiftUI

struct GoalForm: View {
    @EnvironmentObject var monthlyInfo: MonthlyInfo
    @Binding var wallet: Wallet?
    @Binding var targetMonth: String
    var showGoalCategoryId: String
    
    @State var showEditGoal: Bool = false
    @State var selectedTransaction: Transaction = Transaction(date: Date(), categoryId: "Non", title: "Non", amount: 0)
    @State var showEditTransaction: Bool = false
    
    private var goal: Goal {
        return monthlyInfo.monthlyGoals.goals.first(where: { $0.categoryId == self.showGoalCategoryId})!
    }
    
    var remainingAmount: Double {
        goal.budget - monthlyInfo.monthlyTransactions.getCategoryOfExpense(categoryId: goal.categoryId)
    }
    
    var body: some View {
        List {
            // 予算概要セクション
            Section(header: HStack {
                Text("予算概要").font(.headline)
                Spacer()
                Button(action: {
                    self.showEditGoal = true
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .foregroundColor(.blue)
                        .frame(width: 20, height: 20)
                }
                .padding(.bottom, 2)
            }) {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(targetMonth)
                                .font(.caption)
                                .foregroundStyle(.gray)
                            Text("カテゴリ: \(goal.categoryId)")
                                .font(.title2)
                                .bold()
                        }
                        Spacer()
                    }
                    HStack {
                        VStack {
                            Spacer()
                            HStack {
                                Text("予算:")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.green)
                                Spacer() // スペースを入れて右側に金額を配置
                                Text("\(Int(goal.budget))")
                                    .font(.title3)
                                    .bold()
                                    .lineLimit(1)
                                    .foregroundColor(.green)
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing, 20)
                            }
                            HStack {
                                Text("利用:")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.red)
                                Spacer() // スペースを入れて右側に金額を配置
                                Text("\(Int(monthlyInfo.monthlyTransactions.getCategoryOfExpense(categoryId: goal.categoryId)))")
                                    .font(.title3)
                                    .bold()
                                    .lineLimit(1)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing, 20)
                            }
                            Divider()
                                .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                                .padding(.trailing, 10)
                            HStack {
                                Text("残り:")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(remainingAmount >= 0 ? .blue : .orange)
                                Spacer() // スペースを入れて右側に金額を配置
                                Text("¥\(Int(remainingAmount))")
                                    .font(.title3)
                                    .bold()
                                    .lineLimit(1)
                                    .foregroundColor(remainingAmount >= 0 ? .blue : .orange)
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing, 20)
                            }
                            .padding(.bottom, 10)
                        }
                        Spacer()
                        PieChart(spentAmount: monthlyInfo.monthlyTransactions.getCategoryOfExpense(categoryId: goal.categoryId),
                                       totalBudget: goal.budget,
                                       foregroundColor: .blue)
                            .frame(width: 120, height: 120)
                    }
                    .padding(.bottom, 10)
                }
            }
            // 取引履歴セクション
            Section(header: Text("利用履歴").font(.headline)) {
                ForEach(monthlyInfo.monthlyTransactions.transactions) { transaction in
                    if transaction.categoryId == goal.categoryId {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(transaction.title)
                                    .font(.title3)
                                    .bold()
                                Text(transaction.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("¥\(Int(transaction.amount))")
                                .font(.title3)
                                .foregroundColor(transaction.amount >= 0 ? .green : .red)
                        }
                        .background(.white)
                        .onTapGesture {
                            selectedTransaction = transaction
                            showEditTransaction = true
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle()) // スタイリッシュなリストスタイル
        .navigationDestination(isPresented: $showEditGoal) {
            EditGoalForm(goal: self.goal)
        }
        .sheet(isPresented: $showEditTransaction) {
            
        }
    }
}

struct GoalForm_Previews: PreviewProvider {
    static var previews: some View {
        @State var wallet: Wallet? = Wallet(walletId: "001", name: "001", ownerId: "001", isDefault: false, isPrivate: false, sortOrder: 0)
        @State var targetMonth = "2024-10"
        @State var categoryId = "001"
        NavigationView {
            GoalForm(wallet: $wallet, targetMonth: $targetMonth, showGoalCategoryId: categoryId)
                .environmentObject(MonthlyInfoCash())
        }
    }
}

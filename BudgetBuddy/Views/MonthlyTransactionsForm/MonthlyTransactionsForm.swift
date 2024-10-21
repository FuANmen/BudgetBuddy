import SwiftUI

struct MonthlyTransactionsForm: View {
    @EnvironmentObject var monthlyInfo: MonthlyInfo
    @Binding var wallet: Wallet?
    @Binding var targetMonth: String
    
    @State private var showNewTransFrom = false
    @State var selectedTransaction: Transaction? = nil
    @State private var showEditTransaction = false
    
    private var remainingAmount: Double {
        monthlyInfo.monthlyGoals.getTotalBudget() - monthlyInfo.monthlyTransactions.getExpense()
    }
    
    var body: some View {
        List {
            Section(header: Text("\(targetMonth)").font(.headline)) {
                HStack {
                    VStack {
                        Spacer()
                        HStack {
                            Text("予算:")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.green)
                            Spacer() // スペースを入れて右側に金額を配置
                            Text("\(Int(monthlyInfo.monthlyGoals.getTotalBudget()))")
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
                            Text("\(Int(monthlyInfo.monthlyTransactions.getExpense()))")
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
                    PieChart(spentAmount: monthlyInfo.monthlyTransactions.getExpense(),
                             totalBudget: monthlyInfo.monthlyGoals.getTotalBudget(),
                             foregroundColor: .blue)
                    .frame(width: 120, height: 120)
                }
            }
            Section(header: Text("利用履歴").font(.headline)) {
                ForEach($monthlyInfo.monthlyTransactions.transactions) { $transaction in
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
                    .padding(.vertical, 5)
                    .onTapGesture {
                        self.selectedTransaction = transaction
                        self.showEditTransaction = true
                    }
                }
            }
        }
        .listStyle(DefaultListStyle()) // リストのスタイルを平坦に
        .navigationBarTitle("総支出", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            showNewTransFrom = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 20))
                .foregroundColor(.blue)
        })
        .sheet(isPresented: $showNewTransFrom) {
            NewTransactionForm(isPresented: $showNewTransFrom, targetMonth: self.targetMonth, addNewTransaction: { newTransaction in
                monthlyInfo.monthlyTransactions.transactions.append(newTransaction)
            })
        }
        .sheet(isPresented: $showEditTransaction) {
            if let transaction = selectedTransaction {
                EditTransactionForm(title: "", isPresented: $showEditTransaction,
                                    targetMonth: targetMonth,
                                    transaction: Binding(
                                        get: { transaction },
                                        set: { selectedTransaction = $0 }
                                    ),
                deleteTransaction: { deleteTransaction in
                    if let index = monthlyInfo.monthlyTransactions.transactions.firstIndex(where: { $0.id == deleteTransaction.id }) {
                        monthlyInfo.monthlyTransactions.transactions.remove(at: index)
                    }
                })
            }
        }
    }
}


#Preview {
    ZStack {
        @State var wallet: Wallet? = Wallet(walletId: "001", name: "001", ownerId: "001", isDefault: false, isPrivate: false, sortOrder: 0)
        @State var targetMonth = "2024-10"
        MonthlyTransactionsForm(wallet: $wallet, targetMonth: $targetMonth)
            .environmentObject(MonthlyInfoCash())
    }
}

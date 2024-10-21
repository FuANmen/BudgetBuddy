import SwiftUI

struct EditTransactionForm: View {
    @EnvironmentObject var monthlyInfo: MonthlyInfo
    var title: String
    @Binding var isPresented: Bool
    var targetMonth: String?
    @Binding var transaction: Transaction
    
    var deleteTransaction: (Transaction) -> Void
    
    var body: some View {
        VStack {
            Text(self.title)
                .font(.title2)
                .bold()
            TextField("タイトル", text: $transaction.title)
                .font(.largeTitle)
                .bold()
                .padding()
            HStack {
                Text("¥")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.green)
                    .padding(.leading, 20)
                TextField("金額", value: $transaction.amount, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.green)
            }
            Divider()
                .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
            if targetMonth != nil {
                TargetMonthDatePicker(selectedDate: $transaction.date, targetMonth: targetMonth!)
                    .padding(.bottom)
            } else {
                DatePicker("日付", selection: $transaction.date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.bottom)
            }
            Spacer()
            Button(action: {
                deleteTransaction(transaction)
                self.isPresented = false
            }) {
                Text("削除")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct EditTransactionForm_Previews: PreviewProvider {
    static var previews: some View {
        // プレビュー用のトランザクションデータを作成
        @State var isPresented = true
        @State var transaction = Transaction(id: "001", date: Date(), categoryId: "001", title: "ランチ", amount: 1000)
        
        EditTransactionForm(title: "食費", isPresented: $isPresented, targetMonth: "2024-10", transaction: $transaction, deleteTransaction: { _ in })
    }
}

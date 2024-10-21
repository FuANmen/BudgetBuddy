import SwiftUI

struct NewBudgetBreakdownForm: View {
    @Binding var isPresented: Bool
    @State private var title: String = ""
    @State private var amount: String = ""
    
    var addNewBudgetBreakdown: (BudgetBreakdown) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("新しい予算項目")) {
                    TextField("タイトル", text: $title)
                    TextField("金額", text: $amount)
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarTitle("新しい予算項目", displayMode: .inline)
            .navigationBarItems(leading: Button("キャンセル") {
                isPresented = false
            }, trailing: Button("追加") {
                if let amountValue = Double(amount) {
                    let newBudgetBreakdown = BudgetBreakdown(title: title, amount: amountValue)
                    addNewBudgetBreakdown(newBudgetBreakdown)
                    isPresented = false
                }
            })
        }
    }
}

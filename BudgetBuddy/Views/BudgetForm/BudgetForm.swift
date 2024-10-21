import SwiftUI

struct BudgetForm: View {
    @Binding var budgetBreakdowns: [BudgetBreakdown]
    @State private var showNewBudgetForm = false
    
    var body: some View {
        BudgetBreakdownListForm(budgetBreakdowns: self.$budgetBreakdowns)
            .navigationBarTitle("予算項目", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showNewBudgetForm = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            })
            .sheet(isPresented: $showNewBudgetForm) {
                NewBudgetBreakdownForm(isPresented: $showNewBudgetForm,
                                       addNewBudgetBreakdown: { newBudgetBreakdown in
                    self.budgetBreakdowns.append(newBudgetBreakdown)
                })
            }
    }
}

#Preview {
    ZStack {
        @State var budgetBreakdowns: [BudgetBreakdown] = [
            BudgetBreakdown(title: "給料", amount: 300000),
            BudgetBreakdown(title: "副収入", amount: 50000),
            BudgetBreakdown(title: "投資", amount: 20000),
            BudgetBreakdown(title: "貯金", amount: 30000)
        ]
        BudgetForm(budgetBreakdowns: $budgetBreakdowns)
    }
}

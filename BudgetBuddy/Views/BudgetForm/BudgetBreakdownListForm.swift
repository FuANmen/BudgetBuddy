import SwiftUI

struct BudgetBreakdownListForm: View {
    @Binding var budgetBreakdowns: [BudgetBreakdown]
    
    var body: some View {
        NavigationView {
            VStack {
                // 予算の内訳リスト
                List(budgetBreakdowns, id: \.id) { breakdown in
                    VStack(alignment: .leading) {
                        Text(breakdown.title)
                            .font(.headline)
                        Text("¥\(Int(breakdown.amount))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
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
        BudgetBreakdownListForm(budgetBreakdowns: $budgetBreakdowns)
    }
}

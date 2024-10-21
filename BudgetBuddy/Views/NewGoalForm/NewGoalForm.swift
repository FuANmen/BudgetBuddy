import SwiftUI

struct NewGoalForm: View {
    @State private var categoryId: String = ""
    @State private var budget: String = ""
    
    @Binding var isPresented: Bool
    
    var addNewGoal: (_ newGoal: Goal) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Category ID", text: $categoryId)
                    TextField("Budget", text: $budget)
                        .keyboardType(.decimalPad)
                }
                
                Button("Save") {
                    if let budgetDouble = Double(budget) {
                        // TODO: 新しい目標を保存
                        self.isPresented = false
                        let newGoal = Goal(categoryId: categoryId, budget: budgetDouble)
                        self.addNewGoal(newGoal)
                    }
                }
                .disabled(categoryId.isEmpty || budget.isEmpty)
            }
            .navigationTitle("New Goal")
        }
    }
}


#Preview {
    ZStack {
        @State var showNewGoalForm = true
        NewGoalForm(isPresented: $showNewGoalForm, addNewGoal: {newGoal in })
    }
}

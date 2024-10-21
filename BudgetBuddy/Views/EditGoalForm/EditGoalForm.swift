//
//  EditGoalForm.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/10/18.
//

import SwiftUI

struct EditGoalForm: View {
    @ObservedObject var goal: Goal
    
    // NumberFormatterを定義
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        Form {
            Section(header: Text("目標の編集").font(.headline)) {
                TextField("カテゴリID", text: $goal.categoryId)
                TextField("予算", value: $goal.budget, formatter: numberFormatter)
                    .keyboardType(.numberPad)
            }
        }
        .navigationTitle("編集")
    }
}

#Preview {
    // ここでStateを定義
    @State var previewGoal = Goal(categoryId: "001", budget: 30000)
    
    return EditGoalForm(goal: previewGoal)
}


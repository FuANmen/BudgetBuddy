// NewTransactionForm.swift
// BudgetBuddy
//
// Created by 柴田健作 on 2024/10/02.
//

import SwiftUI

struct NewTransactionForm: View {
    @Binding var isPresented: Bool
    var targetMonth: String?
    @StateObject private var newTransaction = Transaction(date: Date(), categoryId: "001", title: "", amount: 0.0)
    
    var addNewTransaction: (Transaction) -> Void
    
    var body: some View {
        VStack {
            Text("New Transaction")
                .font(.title2)
                .bold()
            TextField("タイトル", text: $newTransaction.title)
                .font(.largeTitle)
                .bold()
                .padding()
            HStack {
                Text("¥")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                TextField("金額", value: $newTransaction.amount, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
            }
            Divider()
                .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
            if let targetMonth = targetMonth {
                TargetMonthDatePicker(selectedDate: $newTransaction.date, targetMonth: targetMonth)
                    .padding(.bottom)
            } else {
                DatePicker("日付", selection: $newTransaction.date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.bottom)
            }
            Spacer()
            Button(action: {
                addNewTransaction(newTransaction)
                self.isPresented = false
            }) {
                Text("保存")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct NewTransactionForm_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresented = true
        ZStack {
            NewTransactionForm(isPresented: $isPresented, targetMonth: "2024-10", addNewTransaction: { newTransaction in
                // Transactionのdescriptionを使ってコンソールに出力
                print(newTransaction)
            })
        }
    }
}

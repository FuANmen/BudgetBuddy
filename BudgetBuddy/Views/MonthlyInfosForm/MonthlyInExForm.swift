//
//  MonthlyInExForm.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/09/27.
//

import SwiftUI

struct MonthlyInExForm: View {
    @Binding var targetMonth: String
    @ObservedObject var monthlyInfo: MonthlyInfo
    
    var showBudgetForm: () -> Void
    var showExpensesForm: () -> Void
    
    @State private var animateTargetMonth = false
    
    var body: some View {
        HStack {
            Button(action: {
                self.subOneMonth()
            }) {
                Image(systemName: "chevron.compact.left")
                    .font(.system(size: 40))
                    .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
            }
            .padding(.leading, 2)

            // targetMonthが変更されたときにアニメーションを追加
            Text("\(targetMonth.suffix(2))月")
                .font(.largeTitle)
                .bold()
                .padding(.top)
                .padding(.bottom)
                .lineLimit(1) // 行数を1に制限
                .minimumScaleFactor(0.5) // 最小スケールを設定
                .frame(width: 80)
                .scaleEffect(animateTargetMonth ? 1.2 : 1.0) // アニメーション用のスケール効果
                .animation(.easeOut(duration: 0.2), value: animateTargetMonth)
            Divider()
                .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
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
                        .lineLimit(1) // 行数を1に制限
                        .minimumScaleFactor(0.5) // 最小スケールを設定
                        .padding(.trailing, 2)
                    Image(systemName: "ellipsis") // SF Symbols のアイコンを使用
                        .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                    .frame(height: 30)
                }
                .background(.white)
                .onTapGesture {
                    showBudgetForm()
                }
                Divider()
                    .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                HStack {
                    Text("残高 :")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.blue)
                    Spacer()
                    Text("¥\(Int(getRemain()))")
                        .font(.title)
                        .bold()
                        .foregroundColor(.blue)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.trailing, 2)
                    Image(systemName: "ellipsis") // SF Symbols のアイコンを使用
                        .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                    .frame(height: 30)
                }
                .background(.white)
                .padding(.bottom)
                .onTapGesture {
                    showExpensesForm()
                }
            }
            Button(action: {
                if !self.compareYearMonth() {
                    self.addOneMonth()
                }
            }) {
                Image(systemName: "chevron.compact.right")
                    .font(.system(size: 40))
                    .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                    .opacity(self.compareYearMonth() ? 0.0 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: self.compareYearMonth())
            }
            .padding(.leading)
            .padding(.trailing, 2)
        }
        .onChange(of: targetMonth) {
            animateTargetMonth = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    animateTargetMonth = false
                }
            }
        }
    }
    
    private func getRemain() -> Double {
        return monthlyInfo.monthlyGoals.getTotalBudget() - monthlyInfo.monthlyTransactions.getExpense()
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

#Preview {
    ZStack {
        @State var targetMonth = "2024-09"
        @State var monthlyInfo: MonthlyInfo = MonthlyInfo(walletId: "001", yearMonth: "2024-09", monthlyGoals: MonthlyGoals(walletId: "001",
                                                             targetMonth: "2024-09",
                                                             budgetBreakdowns: [
                                                                BudgetBreakdown(id: "001",
                                                                                title: "給料",
                                                                                amount: 20400000)
                                                             ],
                                                             goals: [
                                                                Goal(categoryId: "001", budget: 30000),
                                                                Goal(categoryId: "002", budget: 20000),
                                                                Goal(categoryId: "003", budget: 10000)
                                                             ]), monthlyTransactions: MonthlyTransactions(walletId: "001",
                                                                                  targetMonth: "2024-09",
                                                                                  transactions: [
                                                                                    Transaction(id: "001", date: Date(), categoryId: "001", title: "食費", amount: 2000)
                                                                                  ]))
        
        MonthlyInExForm(targetMonth: $targetMonth,
                        monthlyInfo: monthlyInfo,
                        showBudgetForm: {},
                        showExpensesForm: {})
    }
}

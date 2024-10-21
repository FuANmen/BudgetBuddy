//
//  BudgetBuddyApp.swift
//  BudgetBuddy
//
//  Created by 柴田健作 on 2024/10/05.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    private var currentMonth: String
    
    
    init() {
      FirebaseApp.configure()
      FirebaseConfiguration.shared.setLoggerLevel(.debug)
        
        // 現在の日付を"yyyy-MM"の形式で取得
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        self.currentMonth = dateFormatter.string(from: Date())
    }
  var body: some Scene {
    WindowGroup {
      NavigationView {
        LoginForm()
              .environmentObject(MonthlyInfo(
                  walletId: "001",
                  yearMonth: currentMonth,
                  monthlyGoals: MonthlyGoals(
                      walletId: "001",
                      targetMonth: currentMonth,
                      budgetBreakdowns: [
                          BudgetBreakdown(id: "001", title: "給料", amount: Double(200000)),
                          BudgetBreakdown(id: "002", title: "副収入", amount: Double(currentMonth.suffix(2))! * 1000.0)
                      ],
                      goals: [
                          Goal(categoryId: "001", budget: 100000),
                          Goal(categoryId: "002", budget: 50000),
                          Goal(categoryId: "003", budget: 10000)
                      ]
                  ),
                  monthlyTransactions: MonthlyTransactions(
                      walletId: "001",
                      targetMonth: "2024-10",
                      transactions: [
                          Transaction(id: "001", date: Date(), categoryId: "001", title: "食費", amount: 50000),
                          Transaction(id: "002", date: Date(), categoryId: "002", title: "衣服", amount: 30000),
                          Transaction(id: "003", date: Date(), categoryId: "000", title: "その他", amount: 60000)
                      ]
                  )
              ))
      }
    }
  }
}


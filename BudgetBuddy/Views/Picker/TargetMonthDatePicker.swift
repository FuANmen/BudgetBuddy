import SwiftUI
struct TargetMonthDatePicker: View {
    @Binding var selectedDate: Date
    var targetMonth: String
    
    var year: Int {
        return Int(targetMonth.prefix(4))!
    }
    var month: Int {
        return Int(targetMonth.suffix(2))!
    }

    var body: some View {
        VStack {
            // 年月の表示
            HStack {
                Text("\(String(year))年 \(String(month))月")
                    .font(.title2)
                    .padding(.leading)
                Spacer()
            }
            .padding(.top)
            
            // カレンダーの表示
            let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7)
            let days = getDaysInMonth(year: year, month: month)

            LazyVGrid(columns: columns, spacing: 10) {
                // 曜日の表示
                ForEach(["日", "月", "火", "水", "木", "金", "土"], id: \.self) { day in
                    Text(day)
                        .font(.headline)
                        .foregroundStyle(.gray)
                }
                
                // 日付の表示
                ForEach(days, id: \.self) { day in
                    let dateComponents = DateComponents(year: year, month: month, day: day)
                    let date = Calendar.current.date(from: dateComponents)!

                    Text(day != 0 ? "\(day)" : "")
                        .font(.headline)
                        .frame(width: 30, height: 30) // サイズを指定
                        .background(isSelected(date) ? Color.blue : Color.clear) // 選択されている日付の背景色
                        .foregroundColor(isSelected(date) ? Color.white : Color.black) // 選択されている日付の文字色
                        .cornerRadius(15)
                        .onTapGesture {
                            selectedDate = date // 選択された日付をバインディングに渡す
                        }
                }
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }

    // 指定した年月の日数を取得
    private func getDaysInMonth(year: Int, month: Int) -> [Int] {
        var days: [Int] = []
        
        // 指定した年月の初日を取得
        let firstDayOfMonth = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!

        // 月の日数を取得
        let range = Calendar.current.range(of: .day, in: .month, for: firstDayOfMonth)!
        days = Array(range.lowerBound..<range.upperBound)
        
        // 空白の日付を表示（最初の日がどの曜日かに基づいて）
        let firstWeekday = getFirstWeekday(year: year, month: month)
        for _ in 0..<firstWeekday {
            days.insert(0, at: 0)
        }

        return days
    }

    // 指定した年月の最初の日の曜日を取得
    private func getFirstWeekday(year: Int, month: Int) -> Int {
        let firstDayOfMonth = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
        return Calendar.current.component(.weekday, from: firstDayOfMonth) - 1 // 日曜日を0にするために-1
    }
    
    // 選択された日付を確認するためのヘルパー関数
    private func isSelected(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }
}

struct TargetMonthDatePicker_DEMO: View {
    @StateObject private var tran = Transaction(date: Date(), categoryId: "001", title: "", amount: 100)
    
    var body: some View {
        VStack {
            Text("選択された日付: \(tran.date, formatter: dateFormatter)")
                .padding()
            
            // TargetMonthDatePickerを呼び出す
            TargetMonthDatePicker(selectedDate: $tran.date, targetMonth: "2024-10")
                .padding()
        }
    }
}

// 日付フォーマッタ
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

#Preview {
    TargetMonthDatePicker_DEMO()
}

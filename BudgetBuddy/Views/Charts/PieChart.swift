import SwiftUI

struct BudgetPieSlice {
    let value: Double
    let color: Color
}

struct PieChart: View {
    var spentAmount: Double
    var totalBudget: Double
    var foregroundColor: Color
    var backgroundColor: Color = Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))

    var slices: [BudgetPieSlice] {
        let remainingAmount = (totalBudget - spentAmount) > 0 ? (totalBudget - spentAmount) : 0
        let spentPercentage = spentAmount / totalBudget
        let remainingPercentage = remainingAmount / totalBudget

        return [
            BudgetPieSlice(value: spentPercentage, color: backgroundColor),   // 使った金額の割合
            BudgetPieSlice(value: remainingPercentage, color: foregroundColor) // 残っている金額の割合
        ]
    }

    var body: some View {
        ZStack {
            ForEach(0..<slices.count, id: \.self) { index in
                PieSliceView(startAngle: self.angle(for: index),
                             endAngle: self.angle(for: index + 1),
                             color: self.slices[index].color)
            }
        }
    }

    private func angle(for index: Int) -> Angle {
        let total = slices.reduce(0) { $0 + $1.value }
        let sliceValue = slices[..<index].reduce(0) { $0 + $1.value }
        // -90 degrees to start from the top (12 o'clock position)
        return .degrees(sliceValue / total * 360 - 90)
    }
}

struct PieSliceView: View {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2

                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            }
            .fill(color)
            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 0) // 影の設定を直接適用
        }
    }
}

struct PieChartDemo: View {
    var body: some View {
        VStack {
            Text("予算に対する残りの割合")
                .font(.headline)
            PieChart(spentAmount: 30.0, totalBudget: 100.0, foregroundColor: .blue)
                .frame(width: 200, height: 200)
        }
    }
}

struct PieChartDemo_Previews: PreviewProvider {
    static var previews: some View {
        PieChartDemo()
    }
}

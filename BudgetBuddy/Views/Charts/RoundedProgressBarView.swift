import SwiftUI

struct RoundedProgressViewStyle: ProgressViewStyle {
    var barHeight: CGFloat = 10 // 進捗バーの高さ
    var barColor: Color = .blue // 進捗バーの色
    var backgroundColor: Color = .gray.opacity(0.3) // バックグラウンドの色

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // バックグラウンド
                RoundedRectangle(cornerRadius: barHeight / 2)
                    .frame(height: barHeight)
                    .foregroundColor(backgroundColor)

                // 進捗の色付き部分
                RoundedRectangle(cornerRadius: barHeight / 2)
                    .frame(width: min(CGFloat(configuration.fractionCompleted ?? 0) * geometry.size.width, geometry.size.width), height: barHeight) // 幅を進捗に合わせる
                    .foregroundColor(barColor)
            }
        }
    }
}

struct RoundedProgressBarView: View {
    @State private var currentProgress: Double = 0 // アニメーション用の進捗変数
    var progress: Double // 現在の進捗
    var total: Double // 最大値

    var body: some View {
        VStack {
            ProgressView(value: currentProgress, total: total) // currentProgressに基づいて進捗を表示
                .progressViewStyle(RoundedProgressViewStyle(barHeight: 20, barColor: .blue)) // カスタムスタイルを使用
                .onAppear() {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentProgress = progress
                    }
                }
                .onChange(of: progress) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentProgress = progress // アニメーションで進捗を更新
                    }
                }
        }
    }
}

struct RoundedProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedProgressBarView(progress: 100, total: 100) // 最大値を100としてプレビュー
    }
}

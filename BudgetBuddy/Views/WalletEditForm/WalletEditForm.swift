import SwiftUI

struct WalletEditForm: View {
    @Binding var wallet: Wallet?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                if let wallet = wallet { // オプショナルの wallet をアンラップ
                    Section(header: Text("ウォレット情報")) {
                        TextField("ウォレット名", text: Binding(
                            get: { wallet.name },
                            set: { wallet.name = $0 }
                        ))
                        Toggle("デフォルト", isOn: Binding(
                            get: { wallet.isDefault },
                            set: { wallet.isDefault = $0 }
                        ))
                        Toggle("プライベート", isOn: Binding(
                            get: { wallet.isPrivate },
                            set: { wallet.isPrivate = $0 }
                        ))
                        Picker("ソート順", selection: Binding(
                            get: { wallet.sortOrder },
                            set: { wallet.sortOrder = $0 }
                        )) {
                            ForEach(0..<10) { index in
                                Text("\(index)").tag(index)
                            }
                        }
                    }

                    Section {
                        Button("保存") {
                            saveChanges()
                        }
                        .foregroundColor(.blue)
                        Button("キャンセル") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.red)
                    }
                } else {
                    Text("ウォレットが見つかりません")
                }
            }
            .navigationTitle("ウォレット編集")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func saveChanges() {
        // ウォレットの保存処理をここに実装
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    ZStack {
        @State var wallet: Wallet? = Wallet(walletId: "001", name: "Personal", ownerId: "1", isDefault: true, isPrivate: false, sortOrder: 1)
        
        WalletEditForm(wallet: $wallet)
    }
}

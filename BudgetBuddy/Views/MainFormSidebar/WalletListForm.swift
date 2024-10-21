import SwiftUI

struct WalletListForm: View {
    @Binding var userWallets: [Wallet]
    @Binding var sharedWallets: [Wallet]
    @Binding var selectedWallet: Wallet?
    
    public init(userWallets: Binding<[Wallet]>,
                 sharedWallets: Binding<[Wallet]>,
                 selectedWallet: Binding<Wallet?> ) {
        self._userWallets = userWallets
        self._sharedWallets = sharedWallets
        self._selectedWallet = selectedWallet
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("My Wallets")
                    .textCase(nil) // 大文字変換を無効にする
                ) {
                    ForEach(userWallets) { wallet in
                        HStack {
                            Text(wallet.name)
                            Spacer()
                            if self.selectedWallet?.id == wallet.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle()) // セル全体をタップ領域にする
                        .onTapGesture {
                            selectedWallet = wallet
                        }
                    }
                }
                
                Section(header: Text("Shared Wallets")
                    .textCase(nil) // 大文字変換を無効にする
                ) {
                    ForEach(sharedWallets) { wallet in
                        HStack {
                            Text(wallet.name)
                            Spacer()
                            if self.selectedWallet?.id == wallet.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle()) // セル全体をタップ領域にする
                        .onTapGesture {
                            selectedWallet = wallet
                        }
                    }
                }
            }
            .navigationTitle("Wallets")
        }
        .listStyle(GroupedListStyle()) // iOS 15以前でセクションを分かりやすくするためのスタイル指定
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // プレビュー内で@Stateを使用するために、ラップする
        PreviewWrapper()
    }

    // プレビュー用のラップビュー
    struct PreviewWrapper: View {
        @State var userWallets: [Wallet] = [
            Wallet(walletId: "1", name: "Personal", ownerId: "1", isDefault: true, isPrivate: false, sortOrder: 1)
        ]
        @State var sharedWallets: [Wallet] = [
            Wallet(name: "Family", ownerId: "0", isDefault: true, isPrivate: false, sortOrder: 2)
        ]
        @State var selectedWallet: Wallet? = Wallet(walletId: "1", name: "Personal", ownerId: "1", isDefault: true, isPrivate: false, sortOrder: 1)

        var body: some View {
            WalletListForm(userWallets: $userWallets,
                           sharedWallets: $sharedWallets,
                           selectedWallet: $selectedWallet)
        }
    }
}

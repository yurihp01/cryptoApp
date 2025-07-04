import SwiftUI

struct CryptoListView: View {
    @StateObject var viewModel: CryptoListViewModel
    var onSelect: (Crypto) -> Void

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading...")
            case .failure(let error):
                ErrorView(viewModel: viewModel, error: error)
            case .success(let cryptos):
                List(cryptos, id: \.symbol) { crypto in
                    Button {
                        onSelect(crypto)
                    } label: {
                        CryptoRowView(crypto: crypto)
                    }
                }
            }
        }
        .navigationTitle("📈 Cryptos")
        .padding(12)
    }
}

#Preview {
    CryptoListView(viewModel: CryptoListViewModel(service: CryptoWebSocketService(symbols: Symbols.allCases.map { $0.rawValue })), onSelect: { _ in })
}

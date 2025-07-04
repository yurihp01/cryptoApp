//
//  AppCoordinatorView.swift
//  cryptoApp
//
//  Created by Yuri on 04/07/25.
//

import SwiftUI

struct AppCoordinatorView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            let symbols = Symbols.allCases.map { $0.rawValue }
            let service = CryptoWebSocketService(symbols: symbols)
            CryptoListView(viewModel: CryptoListViewModel(service: service)) { selected in
                path.append(selected)
            }
            .navigationDestination(for: Crypto.self) { crypto in
                CryptoDetailView(viewModel: CryptoDetailViewModel(crypto: crypto, service: service))
            }
        }
    }
}

//
//  AppCoordinator.swift
//  cryptoApp
//
//  Created by Yuri on 04/07/25.
//

import Combine
import SwiftUI

final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let service: CryptoWebSocketServiceProtocol

    init(service: CryptoWebSocketServiceProtocol) {
        self.service = service
    }

    func push(to route: AppRoute) {
        path.append(route)
    }

    @ViewBuilder
    func build(_ route: AppRoute) -> some View {
        switch route {
        case .detail(let crypto):
            CryptoDetailView(viewModel: CryptoDetailViewModel(crypto: crypto, service: self.service))
        case .list:
            CryptoListView(
                viewModel: CryptoListViewModel(service: self.service),
                onSelect: { crypto in
                    self.push(to: .detail(crypto))
                }
            )
        }
    }

    @ViewBuilder
    func makeRootView() -> some View {
        AppCoordinatorView(coordinator: self)
    }
}

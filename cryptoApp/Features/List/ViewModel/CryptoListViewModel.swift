//
//  CryptoListViewModel.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import Combine
import Foundation

import Foundation
import Combine

final class CryptoListViewModel: ObservableObject {
    @Published var state: ViewState<[Crypto]> = .loading

    private let service: CryptoWebSocketServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: CryptoWebSocketServiceProtocol) {
        self.service = service
        bind()
        service.connect()
    }

    func retry() {
        state = .loading
        service.connect()
    }
}

private extension CryptoListViewModel {
    func bind() {
        service.cryptosPublisher
            .sink { [weak self] cryptos in
                guard let self else { return }
                self.state = .success(cryptos)
            }
            .store(in: &cancellables)

        service.errorPublisher
            .sink { [weak self] error in
                self?.state = .failure(error)
            }
            .store(in: &cancellables)
    }
}

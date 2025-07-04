//
//  CryptoDetailViewModel.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import Foundation
import Combine

final class CryptoDetailViewModel: ObservableObject {
    @Published var state: ViewState<Crypto> = .loading
    
    private let service: CryptoWebSocketServiceProtocol
    private let cryptoSymbol: Symbols
    private var cancellables = Set<AnyCancellable>()
    
    init(crypto: Crypto, service: CryptoWebSocketServiceProtocol) {
        self.service = service
        self.cryptoSymbol = crypto.symbol
        self.state = .success(crypto)
        bind()
    }
    
    func retry() {
        state = .loading
        service.connect()
    }
}

private extension CryptoDetailViewModel {
    func bind() {
        service.cryptosPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cryptos in
                guard let self else { return }
                if let updated = cryptos.first(where: { $0.symbol == self.cryptoSymbol }) {
                    self.state = .success(updated)
                }
            }
            .store(in: &cancellables)
        
        service.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.state = .failure(error)
            }
            .store(in: &cancellables)
    }
}

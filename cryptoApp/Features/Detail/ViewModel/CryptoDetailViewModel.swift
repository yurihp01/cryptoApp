//
//  CryptoDetailViewModel.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import Foundation
import Combine

final class CryptoDetailViewModel: ObservableObject {
    private let service: CryptoWebSocketServiceProtocol
    
    @Published var crypto: Crypto
    private var cancellables = Set<AnyCancellable>()
    
    init(crypto: Crypto, service: CryptoWebSocketServiceProtocol) {
        self.crypto = crypto
        self.service = service
        
        bindCrypto()
    }
}

private extension CryptoDetailViewModel {
    func bindCrypto() {
        service.getCryptos()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let cryptos):
                    guard let self,
                          let crypto = cryptos.first(where: { $0.symbol == self.crypto.symbol }) else { return }
                    self.crypto = crypto
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

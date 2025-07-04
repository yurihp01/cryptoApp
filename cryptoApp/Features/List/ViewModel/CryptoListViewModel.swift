//
//  CryptoListViewModel.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import Combine
import Foundation

final class CryptoListViewModel: ObservableObject {
    @Published var state: ViewState<[Crypto]> = .loading
    
    private let service: CryptoWebSocketServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: CryptoWebSocketServiceProtocol) {
        self.service = service
        bind()
    }
    
    func retry() {
        state = .loading
        bind()
    }
}

private extension CryptoListViewModel {
    func bind() {
        service.getCryptos()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let cryptos):
                    self?.state = .success(cryptos)
                case .failure(let error):
                    self?.state = .failure(error)
                }
            }
            .store(in: &cancellables)
    }
}


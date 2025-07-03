//
//  AppDependencies.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import Foundation

final class AppDependencies {
    let service: CryptoWebSocketServiceProtocol
    let coordinator: CryptoListCoordinator
    
    init(symbols: [String]) {
        service = CryptoWebSocketService(symbols: symbols)
        coordinator = CryptoListCoordinator(dependencies: self)
    }
    
    func makeCryptoListViewModel() -> CryptoListViewModel {
        CryptoListViewModel(dependencies: self)
    }
    
    func makeCryptoDetailViewModel(for ticker: Crypto) -> CryptoDetailViewModel {
        CryptoDetailViewModel(ticker: ticker)
    }
}

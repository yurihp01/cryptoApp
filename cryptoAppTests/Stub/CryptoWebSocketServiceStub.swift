//
//  CryptoWebSocketServiceStub.swift
//  cryptoAppTests
//
//  Created by Yuri on 04/07/25.
//

@testable import cryptoApp
import Combine

final class CryptoWebSocketServiceStub: CryptoWebSocketServiceProtocol {
    private let subject = PassthroughSubject<Result<[Crypto], CryptoError>, Never>()
    private let acceptedSymbols: [String]
    private var currentCryptos: [String: Crypto] = [:]
    
    init(symbols: [String]) {
        self.acceptedSymbols = symbols
    }
    
    func getCryptos() -> AnyPublisher<Result<[Crypto], CryptoError>, Never> {
        subject.eraseToAnyPublisher()
    }
    
    func emit(crypto: Crypto) {
        guard acceptedSymbols.contains(crypto.symbol.rawValue) else { return }
        currentCryptos[crypto.symbol.rawValue] = crypto
        subject.send(.success(Array(currentCryptos.values)))
    }
    
    func emitError(_ error: CryptoError) {
        subject.send(.failure(error))
    }
}

enum MockError: Error {
    case disconnected
}

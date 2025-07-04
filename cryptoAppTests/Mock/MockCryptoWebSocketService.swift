//
//  MockCryptoWebSocketService.swift
//  cryptoApp
//
//  Created by Yuri on 04/07/25.
//

import Foundation
import Combine
@testable import cryptoApp

enum MockError: Error, Equatable {
    case disconnected
}

final class MockCryptoWebSocketService: CryptoWebSocketServiceProtocol {
    private let cryptosSubject = CurrentValueSubject<[Crypto], Never>([])
    private let errorSubject = PassthroughSubject<CryptoError, Never>()
    private let result: Result<[Crypto], CryptoError>
    
    var cryptosPublisher: AnyPublisher<[Crypto], Never> {
        cryptosSubject.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<CryptoError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    private(set) var connectCalled = false
    
    init(result: Result<[Crypto], CryptoError>) {
        self.result = result
        emitStoredResult()
    }
    
    func connect() {
        connectCalled = true
    }
}

private extension MockCryptoWebSocketService {
    func emitStoredResult() {
        DispatchQueue.main.async {
            switch self.result {
            case .success(let cryptos):
                self.cryptosSubject.send(cryptos)
            case .failure(let error):
                self.errorSubject.send(error)
            }
        }
    }
}

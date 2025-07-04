//
//  MockCryptoWebSocketService.swift
//  cryptoApp
//
//  Created by Yuri on 04/07/25.
//

import Combine

final class MockCryptoWebSocketService: CryptoWebSocketServiceProtocol {
    let result: Result<[Crypto], CryptoError>
    
    init(result: Result<[Crypto], CryptoError>) {
        self.result = result
    }
    
    func getCryptos() -> AnyPublisher<Result<[Crypto], CryptoError>, Never> {
        Just(result).eraseToAnyPublisher()
    }
}

//
//  CryptoWebSocketServiceStub.swift
//  cryptoAppTests
//
//  Created by Yuri on 04/07/25.
//

import Foundation
import Combine

final class CryptoWebSocketServiceStub: CryptoWebSocketServiceProtocol {
    private let cryptosSubject = CurrentValueSubject<[Crypto], Never>([])
    private let errorSubject = PassthroughSubject<CryptoError, Never>()
    
    private(set) var didConnect = false

    var cryptosPublisher: AnyPublisher<[Crypto], Never> {
        cryptosSubject.eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<CryptoError, Never> {
        errorSubject.eraseToAnyPublisher()
    }

    init(symbols: [String]) {}

    func connect() {
        didConnect = true
    }

    func emit(crypto: Crypto) {
        cryptosSubject.send([crypto])
    }

    func emitError(_ error: CryptoError) {
        errorSubject.send(error)
    }
}

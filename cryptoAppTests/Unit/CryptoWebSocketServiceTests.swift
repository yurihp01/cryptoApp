//
//  CryptoWebSocketService.swift
//  cryptoApp
//
//  Created by Yuri on 04/07/25.
//

import XCTest
@testable import cryptoApp
import Combine

final class CryptoWebSocketServiceTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var service: CryptoWebSocketServiceProtocol!
    
    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
        service = nil
    }
    
    func test_getCryptos_emitsUpdatedCrypto() {
        // Given
        let symbols = ["BTCUSDT"]
        service = CryptoWebSocketServiceStub(symbols: symbols)

        let expectation = expectation(description: "Should emit updated crypto")

        // When
        service.getCryptos()
            .sink(receiveCompletion: { _ in }) { completion in
                if case .success(let cryptos) = completion {
                    XCTAssertEqual(cryptos.count, 1)
                    XCTAssertEqual(cryptos.first?.symbol.rawValue, "BTCUSDT")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        (self.service as? CryptoWebSocketServiceStub)?.emit(crypto: Crypto.mockCrypto)

        // Then
        wait(for: [expectation], timeout: 2)
    }
    
    func test_getCryptos_emitsErrorOnFailure() {
        // Given
        service = CryptoWebSocketServiceStub(symbols: ["BTCUSDT"])
        
        let expectation = expectation(description: "Should emit error")
        
        service.getCryptos()
            .sink(receiveCompletion: { _ in
            }, receiveValue: {
                completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, CryptoError.connectionFailed(MockError.disconnected))
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)
        
        (service as? CryptoWebSocketServiceStub)?.emitError(.connectionFailed(MockError.disconnected))
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_getCryptos_ignoresUnrelatedSymbols() {
        service = CryptoWebSocketServiceStub(symbols: ["ETHUSDT"])
        let expectation = expectation(description: "Should not emit unrelated crypto")
        expectation.isInverted = true
        
        service.getCryptos()
            .dropFirst()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { completion in
                if case .success(let cryptos) = completion, cryptos.contains(where: { $0.symbol == Symbols.btcusdt }) {
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)
        
        (service as? CryptoWebSocketServiceStub)?.emit(crypto: Crypto.mockCrypto)
        
        wait(for: [expectation], timeout: 1)
    }
}

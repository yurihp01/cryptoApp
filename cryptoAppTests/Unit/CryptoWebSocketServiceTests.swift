//
//  CryptoWebSocketService.swift
//  cryptoApp
//
//  Created by Yuri on 04/07/25.
//

import XCTest
import Combine
@testable import cryptoApp

final class CryptoWebSocketServiceTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var service: CryptoWebSocketServiceStub!

    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
        service = nil
    }

    func test_emitCrypto_updatesPublisher() {
        service = CryptoWebSocketServiceStub(symbols: ["BTCUSDT"])

        let expected = Crypto.mockCrypto
        let expectation = expectation(description: "Should receive updated crypto")

        service.cryptosPublisher
            .dropFirst()
            .sink { cryptos in
                XCTAssertEqual(cryptos.first, expected)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        service.emit(crypto: expected)
        wait(for: [expectation], timeout: 1)
    }

    func test_emitError_triggersErrorPublisher() {
        service = CryptoWebSocketServiceStub(symbols: ["BTCUSDT"])

        let expected = CryptoError.connectionFailed(MockError.disconnected)
        let expectation = expectation(description: "Should receive error")

        service.errorPublisher
            .sink { error in
                XCTAssertEqual(error, expected)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        service.emitError(expected)
        wait(for: [expectation], timeout: 1)
    }
}

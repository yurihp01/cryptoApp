//
//  CryptoDetailViewModelTests.swift
//  cryptoAppTests
//
//  Created by Yuri on 04/07/25.
//

import XCTest
@testable import cryptoApp
import Combine

final class CryptoDetailViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func test_crypto_updatesWhenNewDataComes() {
        // Given
        let initial = Crypto.mockCrypto
        let updated = Crypto(symbol: .btcusdt, price: "30500", percentChange: "+1.0%", absoluteChange: "110000")
        let mockService = MockCryptoWebSocketService(result: .success([updated]))
        let viewModel = CryptoDetailViewModel(crypto: initial, service: mockService)
        
        let expectation = XCTestExpectation(description: "Crypto should update")

        viewModel.$crypto
            .dropFirst()
            .sink { crypto in
                XCTAssertEqual(crypto, updated)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_crypto_doesNotUpdateOnFailure() {
        // Given
        let initial = Crypto.mockCrypto
        let mockService = MockCryptoWebSocketService(result: .failure(.connectionFailed(NSError(domain: "test", code: 0))))
        let viewModel = CryptoDetailViewModel(crypto: initial, service: mockService)

        let expectation = XCTestExpectation(description: "Crypto should not update on failure")
        expectation.isInverted = true

        viewModel.$crypto
            .dropFirst()
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 0.5)
    }
}

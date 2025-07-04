//
//  CryptoDetailViewModelTests.swift
//  cryptoAppTests
//
//  Created by Yuri on 04/07/25.
//

import XCTest
import Combine
@testable import cryptoApp

final class CryptoDetailViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func test_updates_crypto_onNewValue() {
        let initial = Crypto.mockCrypto
        let updated = Crypto(symbol: .btcusdt, price: "40000", percentChange: "1%", absoluteChange: "9000")

        let service = CryptoWebSocketServiceStub(symbols: [initial.symbol.rawValue])
        let viewModel = CryptoDetailViewModel(crypto: initial, service: service)

        let expectation = expectation(description: "Should update crypto state")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .success(let value) = state {
                    XCTAssertEqual(value, updated)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        service.emit(crypto: updated)
        wait(for: [expectation], timeout: 1)
    }

    func test_sets_failure_onError() {
        let initial = Crypto.mockCrypto
        let expected = CryptoError.connectionFailed(MockError.disconnected)

        let service = CryptoWebSocketServiceStub(symbols: [initial.symbol.rawValue])
        let viewModel = CryptoDetailViewModel(crypto: initial, service: service)

        let expectation = expectation(description: "Should set failure state")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .failure(let error) = state {
                    XCTAssertEqual(error.localizedDescription, expected.localizedDescription)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        service.emitError(expected)
        wait(for: [expectation], timeout: 1)
    }
}

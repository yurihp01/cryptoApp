//
//  CryptoListViewModelTests.swift
//  cryptoApp
//
//  Created by Yuri on 04/07/25.
//

import XCTest
import Combine
@testable import cryptoApp

final class CryptoListViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func test_initialState_isLoading() {
        let mockService = MockCryptoWebSocketService(result: .success([]))
        let viewModel = CryptoListViewModel(service: mockService)
        XCTAssertEqual(viewModel.state, .loading)
    }

    func test_successState_updatesCryptos() {
        let mockService = MockCryptoWebSocketService(result: .success([.mockCrypto]))
        let viewModel = CryptoListViewModel(service: mockService)

        let expectation = XCTestExpectation(description: "Should receive .success with cryptos")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .success(let cryptos) = state {
                    XCTAssertEqual(cryptos.first?.symbol, .btcusdt)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_failureState_setsError() {
        let error = CryptoError.connectionFailed(NSError(domain: "test", code: -1))
        let mockService = MockCryptoWebSocketService(result: .failure(error))
        let viewModel = CryptoListViewModel(service: mockService)

        let expectation = XCTestExpectation(description: "Should receive .failure with error")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .failure(let receivedError) = state {
                    XCTAssertEqual(receivedError.localizedDescription, error.localizedDescription)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_retry_setsStateToLoading_thenSuccess() {
        let mockService = MockCryptoWebSocketService(result: .success([.mockCrypto]))
        let viewModel = CryptoListViewModel(service: mockService)

        let expectation = XCTestExpectation(description: "Should transition to .success after retry")

        viewModel.retry()

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .success(let cryptos) = state {
                    XCTAssertEqual(cryptos.first?.symbol, .btcusdt)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
}

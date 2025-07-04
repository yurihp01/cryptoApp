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
    private var cancellables = Set<AnyCancellable>()
    
    func test_success_setsSuccessState() {
        let service = CryptoWebSocketServiceStub(symbols: ["BTCUSDT"])
        let viewModel = CryptoListViewModel(service: service)
        
        let expected = Crypto.mockCrypto
        let expectation = expectation(description: "Should receive success state")
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .success(let cryptos) = state {
                    XCTAssertEqual(cryptos.first, expected)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        service.emit(crypto: expected)
        wait(for: [expectation], timeout: 1)
    }
    
    func test_error_setsFailureState() {
        let service = CryptoWebSocketServiceStub(symbols: ["BTCUSDT"])
        let viewModel = CryptoListViewModel(service: service)
        
        let expected = CryptoError.connectionFailed(MockError.disconnected)
        let expectation = expectation(description: "Should receive failure state")
        
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
    
    func test_retry_callsConnectOnService() {
        let mockService = MockCryptoWebSocketService(result: .success([]))
        let viewModel = CryptoListViewModel(service: mockService)
        
        viewModel.retry()
        
        XCTAssertTrue(mockService.connectCalled, "Expected connect() to be called on retry")
    }
}

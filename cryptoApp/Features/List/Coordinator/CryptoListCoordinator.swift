//
//  CryptoListCoordinator.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import SwiftUI

final class CryptoListCoordinator: ObservableObject {
    @Published var path: [CryptoRoute] = []
    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    func showDetail(for ticker: Crypto) {
        path.append(.detail(ticker))
    }

    func goBack() {
        _ = path.popLast()
    }

    func reset() {
        path = []
    }
}

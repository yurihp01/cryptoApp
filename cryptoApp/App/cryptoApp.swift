//
//  cryptoApp.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import SwiftUI

@main
struct cryptoApp: App {
    var body: some Scene {
        let symbols = Symbols.allCases.map(\.rawValue)
        let service = CryptoWebSocketService(symbols: symbols)
        let coordinator = AppCoordinator(service: service)

        return WindowGroup {
            coordinator.makeRootView()
        }
    }
}

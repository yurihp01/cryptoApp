//
//  cryptoApp.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import SwiftUI

private enum Symbols: String, CaseIterable {
    case btcusdt = "BTCUSDT"
    case ethusdt = "ETHUSDT"
    case bnbusdt = "BNBUSDT"
    case xrpusdt = "XRPUSDT"
    case solusdt = "SOLUSDT"
}

@main
struct cryptoAppApp: App {
    private var dependencies = AppDependencies(symbols: Symbols.allCases.map { $0.rawValue })
    
    var body: some Scene {
        WindowGroup {
            CryptoRootView()
                .environment(\.appDependencies, dependencies)
        }
    }
}

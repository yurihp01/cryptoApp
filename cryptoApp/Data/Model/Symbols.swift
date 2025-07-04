//
//  Symbols.swift
//  cryptoApp
//
//  Created by Yuri on 04/07/25.
//

enum Symbols: String, CaseIterable, Decodable {
    case btcusdt = "BTCUSDT"
    case ethusdt = "ETHUSDT"
    case bnbusdt = "BNBUSDT"
    case xrpusdt = "XRPUSDT"
    case solusdt = "SOLUSDT"
    
    var displayName: String {
        switch self {
        case .btcusdt: "Bitcoin"
        case .ethusdt: "Ethereum"
        case .bnbusdt: "Binance Coin"
        case .xrpusdt: "Ripple"
        case .solusdt: "Solana"
        }
    }
}
